--[[
    SilentAim v5 — ACS Engine (FastCastRedux)
    Полная переработка на основе дампа GameDump

    АРХИТЕКТУРА ИЗ ДАМПА:
    ─────────────────────────────────────────────────────────
    ACS_Framework.lua line 1570-1571:
      ShootModule.fire(LocalPlayer, origin, direction, shellData)   ← локальный FastCast
      ServerBullet:FireServer(origin, direction, shellData)          ← серверная реплика

    Сервер получает FireServer и делает свой FastCast с теми же данными.
    
    ПОЧЕМУ v3/v4 НЕ РАБОТАЛИ:
    ─────────────────────────────────────────────────────────
    1. rawequal(self, ServerBulletRemote) — НЕНАДЁЖЕН.
       Roblox instance caching: FindFirstChild может вернуть другой C++ proxy.
       Нужен compareinstances() (Potassium) или проверка по имени/пути.

    2. Ошибочная стратегия: мы патчили args внутри namecall, но
       ShootModule.fire() вызывается ДО FireServer в том же frame.
       Если hookfunction на ShootModule.fire — мы контролируем И локальный
       FastCast И то что уходит на сервер через намкол.

    СТРАТЕГИЯ v5:
    ─────────────────────────────────────────────────────────
    Метод 1 (основной): hookfunction на ShootModule.fire через getgc/filtergc
      - Перехватываем direction прямо в ShootModule.fire
      - Это работает и для локального рендера И для сервера
      - Не зависит от instance caching проблемы

    Метод 2 (резервный): hookmetamethod с compareinstances + проверка по имени
      - Используется если ShootModule недоступен через GC
      - compareinstances() вместо rawequal() — работает корректно

    WallBang/BulletTP:
    ─────────────────────────────────────────────────────────
    НЕ через shellData таблицу (сервер может игнорировать клиентские значения).
    Правильный способ: hookfunction на BulletHitDetector.canRayPierce
      - canRayPierce вызывается в ShootModule для проверки пробития
      - return true всегда = пуля проходит сквозь всё (WallBang)
    BulletTP: через ShootModule.fire — shellSpeed в shellData это единственный путь,
      НО патчим через upvalue самого ShootModule, не через аргументы.
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    Enabled      = true,
    FOV          = 300,
    AimPart      = "Head",        -- "Head" | "HumanoidRootPart" | "UpperTorso"
    TeamCheck    = true,
    PredictLead  = true,
    LeadFactor   = 0.085,

    BulletTP     = true,          -- мгновенный долёт (shellSpeed huge)
    WallBang     = true,          -- сквозь стены (canRayPierce = true)
    NoSpread     = true,          -- убрать разброс (direction точно в голову)

    ShowFOV      = true,
    ShowLine     = true,
    ShowName     = true,
    ShowDistance = true,
    LineColor    = Color3.fromRGB(0, 255, 80),
    FOVColor     = Color3.fromRGB(255, 255, 255),
    DebugLog     = true,
}

-- ============================================================
--  СЕРВИСЫ
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

-- ============================================================
--  ESP DRAWING
-- ============================================================
local drawFOV = Drawing.new("Circle")
drawFOV.Visible = false; drawFOV.Radius = CONFIG.FOV
drawFOV.Color = CONFIG.FOVColor; drawFOV.Thickness = 1
drawFOV.Filled = false; drawFOV.Transparency = 0.55

local drawLine = Drawing.new("Line")
drawLine.Visible = false; drawLine.Thickness = 1.5
drawLine.Color = CONFIG.LineColor; drawLine.Transparency = 0.85

local drawLineDot = Drawing.new("Circle")
drawLineDot.Visible = false; drawLineDot.Radius = 5
drawLineDot.Filled = true; drawLineDot.Color = CONFIG.LineColor
drawLineDot.Transparency = 0.85

local drawName = Drawing.new("Text")
drawName.Visible = false; drawName.Size = 14
drawName.Color = Color3.fromRGB(255,255,255)
drawName.Outline = true; drawName.OutlineColor = Color3.fromRGB(0,0,0)
drawName.Center = true

local drawDist = Drawing.new("Text")
drawDist.Visible = false; drawDist.Size = 12
drawDist.Color = Color3.fromRGB(200,200,200)
drawDist.Outline = true; drawDist.OutlineColor = Color3.fromRGB(0,0,0)
drawDist.Center = true

-- ============================================================
--  КЕШ ЦЕЛИ (обновляется в RenderStepped)
-- ============================================================
local cachedTarget    = nil
local cachedTargetPos = nil
local cachedDist      = 0

local _rp = RaycastParams.new()
_rp.FilterType = Enum.RaycastFilterType.Exclude

local function hasWall(origin, targetPos, char)
    local filter = {Camera}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    table.insert(filter, char)
    _rp.FilterDescendantsInstances = filter
    return workspace:Raycast(origin, targetPos - origin, _rp) ~= nil
end

local function w2s(pos)
    local sp, vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), vis
end

local function screenCenter()
    return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
end

local function predictPos(part)
    if not CONFIG.PredictLead then return part.Position end
    local root = part.Parent:FindFirstChild("HumanoidRootPart") or part
    local ok, vel = pcall(function() return root.AssemblyLinearVelocity end)
    if not ok then return part.Position end
    local dist = (part.Position - Camera.CFrame.Position).Magnitude
    return part.Position + vel * (dist / 1000) * CONFIG.LeadFactor
end

local function updateCache()
    local center = screenCenter()
    local camPos = Camera.CFrame.Position
    local bestPlayer, bestPos, bestDist, bestSD = nil, nil, 0, math.huge

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if CONFIG.TeamCheck and LocalPlayer.Team ~= nil and LocalPlayer.Team == pl.Team then continue end
        local char = pl.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = char:FindFirstChild(CONFIG.AimPart) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        local predPos = predictPos(part)
        local sp, vis = w2s(predPos)
        if not vis then continue end
        local sd = (sp - center).Magnitude
        if sd > CONFIG.FOV then continue end
        if not CONFIG.WallBang and hasWall(camPos, predPos, char) then continue end
        if sd < bestSD then
            bestSD = sd
            bestPlayer = pl
            bestPos = predPos
            bestDist = (predPos - camPos).Magnitude
        end
    end

    cachedTarget    = bestPlayer
    cachedTargetPos = bestPos
    cachedDist      = bestDist
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not CONFIG.Enabled then
        drawFOV.Visible = false; drawLine.Visible = false
        drawLineDot.Visible = false; drawName.Visible = false
        drawDist.Visible = false; return
    end
    updateCache()
    local center = screenCenter()
    drawFOV.Position = center
    drawFOV.Visible = CONFIG.ShowFOV
    drawFOV.Radius = CONFIG.FOV
    drawFOV.Color = cachedTarget and CONFIG.LineColor or CONFIG.FOVColor

    if cachedTarget and cachedTargetPos then
        local sp, vis = w2s(cachedTargetPos)
        drawLine.Visible = CONFIG.ShowLine and vis
        drawLine.From = center; drawLine.To = sp
        drawLineDot.Visible = CONFIG.ShowLine and vis
        drawLineDot.Position = sp
        drawName.Visible = CONFIG.ShowName and vis
        drawName.Position = Vector2.new(sp.X, sp.Y - 22)
        drawName.Text = cachedTarget.Name
        drawDist.Visible = CONFIG.ShowDistance and vis
        drawDist.Position = Vector2.new(sp.X, sp.Y + 10)
        drawDist.Text = string.format("%.0fm", cachedDist)
    else
        drawLine.Visible = false; drawLineDot.Visible = false
        drawName.Visible = false; drawDist.Visible = false
    end
end)

-- ============================================================
--  МЕТОД 1: hookfunction на ShootModule.fire через GC
--  ShootModule.fire(player, origin, direction, shellData, extra?)
--  p9=origin, p10=direction, u11=shellData
-- ============================================================
local function hookShootModule()
    local ShootModule = nil

    -- Ищем ShootModule через GC — ищем таблицу у которой есть функция fire
    for _, obj in getgc(true) do
        if type(obj) == "table"
            and type(rawget(obj, "fire")) == "function"
            and rawget(obj, "fire") ~= nil
        then
            -- Дополнительная проверка: fire принимает (player, origin V3, dir V3, shellData table)
            local info = debug.getinfo(rawget(obj, "fire"))
            if info and info.nups and info.nups >= 5 then
                ShootModule = obj
                break
            end
        end
    end

    if not ShootModule then
        -- Запасной поиск через filtergc если доступен
        local ok, results = pcall(filtergc, "table", {
            Keys = {"fire"},
            ValTypes = {"function"}
        })
        if ok and results then
            for _, obj in ipairs(results) do
                local info = debug.getinfo(rawget(obj, "fire"))
                if info and info.nups and info.nups >= 5 then
                    ShootModule = obj
                    break
                end
            end
        end
    end

    if not ShootModule then
        warn("[SA v5] ShootModule не найден через GC, переключаемся на Метод 2")
        return false
    end

    print("[SA v5] ShootModule найден через GC, хукаем fire()")

    local origFire = ShootModule.fire
    ShootModule.fire = newcclosure(function(player, origin, direction, shellData, extra)
        -- Применяем только для LocalPlayer
        if CONFIG.Enabled and player == LocalPlayer and cachedTargetPos then

            -- NoSpread / SilentAim: направление к цели
            if CONFIG.NoSpread or true then  -- всегда направляем в цель когда SA включён
                local toTarget = cachedTargetPos - origin
                if toTarget.Magnitude > 0 then
                    direction = toTarget.Unit
                end
            end

            -- BulletTP: огромная скорость пули в shellData
            if CONFIG.BulletTP and type(shellData) == "table" then
                shellData.shellSpeed = 9e9
            end

            if CONFIG.DebugLog then
                print(string.format("[SA v5] FIRE hook → %s | dist=%.0f",
                    cachedTarget and cachedTarget.Name or "?", cachedDist))
            end
        end

        return origFire(player, origin, direction, shellData, extra)
    end, "ACS_ShootModule_fire")

    -- WallBang через canRayPierce в BulletHitDetector (upvalue ShootModule.fire)
    -- Ищем BulletHitDetector через upvalues ShootModule.fire
    if CONFIG.WallBang then
        task.spawn(function()
            -- Ищем BulletHitDetector в upvalues оригинального fire
            local uvs = debug.getupvalues(origFire)
            for name, val in pairs(uvs) do
                if type(val) == "table" and type(rawget(val, "canRayPierce")) == "function" then
                    print("[SA v5] BulletHitDetector найден через upvalue:", name)
                    local origPierce = val.canRayPierce
                    val.canRayPierce = newcclosure(function(player, instance, shellData)
                        if CONFIG.WallBang and player == LocalPlayer then
                            return true  -- пуля проходит сквозь всё
                        end
                        return origPierce(player, instance, shellData)
                    end, "ACS_canRayPierce")
                    print("[SA v5] WallBang: canRayPierce захукан")
                    break
                end
            end
        end)
    end

    return true
end

-- ============================================================
--  МЕТОД 2: hookmetamethod (резервный) с compareinstances
-- ============================================================
local function hookNamecall()
    local ServerBulletRemote = nil

    -- Ищем Remote — сначала FindFirstChild, потом WaitForChild
    local function findRemote()
        local ok, rs = pcall(game.GetService, game, "ReplicatedStorage")
        if not ok then return nil end
        local engine = rs:FindFirstChild("ACS_Engine")
        if not engine then
            local ok2, e = pcall(function() return rs:WaitForChild("ACS_Engine", 10) end)
            if ok2 then engine = e end
        end
        if not engine then return nil end
        local events = engine:FindFirstChild("Events")
        if not events then
            local ok3, e = pcall(function() return engine:WaitForChild("Events", 8) end)
            if ok3 then events = e end
        end
        if not events then return nil end
        return events:FindFirstChild("ServerBullet")
    end

    ServerBulletRemote = findRemote()
    if ServerBulletRemote then
        print("[SA v5] Fallback Remote OK:", ServerBulletRemote:GetFullName())
    else
        warn("[SA v5] Remote не найден при старте, жду...")
        task.spawn(function()
            task.wait(5)
            ServerBulletRemote = findRemote()
            if ServerBulletRemote then
                print("[SA v5] Remote найден:", ServerBulletRemote:GetFullName())
            else
                warn("[SA v5] ServerBullet не найден: ReplicatedStorage.ACS_Engine.Events.ServerBullet")
            end
        end)
    end

    local origNamecall
    origNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()

        if CONFIG.Enabled and method == "FireServer" and ServerBulletRemote and cachedTargetPos then
            -- compareinstances — корректное сравнение instance proxy объектов
            local isServerBullet = false
            local ok, result = pcall(compareinstances, self, ServerBulletRemote)
            if ok and result then
                isServerBullet = true
            else
                -- Запасная проверка по имени + пути
                local ok2, name = pcall(function() return self.Name end)
                if ok2 and name == "ServerBullet" then
                    local ok3, parent = pcall(function() return self.Parent end)
                    if ok3 and parent then
                        local ok4, pname = pcall(function() return parent.Name end)
                        if ok4 and pname == "Events" then
                            isServerBullet = true
                        end
                    end
                end
            end

            if isServerBullet then
                local args = table.pack(...)
                -- args: [1]=origin(V3), [2]=direction(V3), [3]=shellData(table)
                -- Ищем Vector3 по типу — надёжнее чем по индексу
                local originIdx, dirIdx
                for i = 1, args.n do
                    if typeof(args[i]) == "Vector3" then
                        if not originIdx then originIdx = i
                        elseif not dirIdx then dirIdx = i; break end
                    end
                end

                if dirIdx then
                    local origin = originIdx and args[originIdx] or Camera.CFrame.Position
                    local toTarget = cachedTargetPos - origin
                    if toTarget.Magnitude > 0 then
                        args[dirIdx] = toTarget.Unit
                    end
                end

                -- BulletTP и WallBang через shellData (аргумент)
                local shellData = args[3]
                if type(shellData) == "table" then
                    if CONFIG.BulletTP then
                        shellData.shellSpeed = 9e9
                    end
                    if CONFIG.WallBang then
                        shellData.maxPenetrationCount    = 99
                        shellData.currentPenetrationCount = 0
                        shellData.penetrationMultiplier  = 1.0
                    end
                end

                if CONFIG.DebugLog then
                    print(string.format("[SA v5 fallback] FIRE → %s | dir patched=%s",
                        cachedTarget and cachedTarget.Name or "?",
                        tostring(dirIdx ~= nil)))
                end

                return origNamecall(self, table.unpack(args, 1, args.n))
            end
        end

        return origNamecall(self, ...)
    end))

    print("[SA v5] hookmetamethod (fallback) активен")
end

-- ============================================================
--  ИНИЦИАЛИЗАЦИЯ — сначала пробуем hookfunction, потом namecall
-- ============================================================
task.spawn(function()
    -- Небольшая задержка чтобы ShootModule успел загрузиться
    task.wait(1)

    local method1ok = hookShootModule()
    -- Метод 2 всегда включаем как страховку
    hookNamecall()

    print(string.format(
        "[SilentAim v5] Готов | FOV=%d | AimPart=%s | ShootHook=%s | BTP=%s | WB=%s",
        CONFIG.FOV, CONFIG.AimPart,
        tostring(method1ok),
        tostring(CONFIG.BulletTP),
        tostring(CONFIG.WallBang)
    ))
    print("[SA v5] Insert=toggle | Delete=BulletTP | End=WallBang | PageUp=FOV+ | PageDown=FOV-")
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local function notify(title, text)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification",
                {Title=title, Text=text, Duration=2})
        end)
    end
    if input.KeyCode == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        notify("SilentAim v5", CONFIG.Enabled and "✓ ON" or "✗ OFF")
    elseif input.KeyCode == Enum.KeyCode.Delete then
        CONFIG.BulletTP = not CONFIG.BulletTP
        notify("BulletTP", CONFIG.BulletTP and "✓ ON" or "✗ OFF")
    elseif input.KeyCode == Enum.KeyCode.End then
        CONFIG.WallBang = not CONFIG.WallBang
        notify("WallBang", CONFIG.WallBang and "✓ ON" or "✗ OFF")
    elseif input.KeyCode == Enum.KeyCode.PageUp then
        CONFIG.FOV = math.min(CONFIG.FOV + 50, 800)
        drawFOV.Radius = CONFIG.FOV
        notify("FOV", "= " .. CONFIG.FOV)
    elseif input.KeyCode == Enum.KeyCode.PageDown then
        CONFIG.FOV = math.max(CONFIG.FOV - 50, 50)
        drawFOV.Radius = CONFIG.FOV
        notify("FOV", "= " .. CONFIG.FOV)
    end
end)
