--[[
    SilentAim v4 — ACS Engine (FastCastRedux)
    Разработан на основе дампа GameDump
    
    ИЗ ДАМПА УСТАНОВЛЕНО:
    ServerBullet:FireServer(origin: Vector3, direction: Vector3, shellData: table)
      args[1] = origin  (Position мушки / камеры)
      args[2] = direction (LookVector + spread = итоговый unit-вектор)
      args[3] = shellData { shellSpeed=MuzzleVelocity, maxPenetrationCount, bulletID, ... }
    
    ИСПРАВЛЕНИЕ v3 → v4:
      - Проблема была: direction это НЕ просто LookVector, это уже spread-rotated вектор.
        Наш newDir правильный, но shellData.origin не совпадал с args[1] (мы не трогали его).
        Сервер FastCast стартует луч от shellData.origin в shellData direction.
        Если args[1] (origin) и shellData.origin расходятся — луч летит не туда.
        ФИКС: патчим И args[1] И shellData.origin — оба на позицию камеры (уже там стоит).
      - НОВОЕ: BulletTP — shellSpeed = 999999 (пуля долетает мгновенно)
      - НОВОЕ: WallBang — maxPenetrationCount = 99, penetrationMultiplier = 1.0 (сквозь стены)
      - НОВОЕ: NoSpread — direction идёт прямо в цель (мы уже это делали, теперь точнее)
      - НОВОЕ: дебаг-лог в консоль — видно что именно патчится
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    Enabled       = true,
    FOV           = 300,
    AimPart       = "Head",     -- "Head" | "HumanoidRootPart" | "UpperTorso"
    TeamCheck     = true,
    WallCheck     = true,
    PredictLead   = true,
    LeadFactor    = 0.085,

    -- === ЧИТЫ ===
    BulletTP      = true,       -- shellSpeed = 999999 → пуля прилетает мгновенно
    WallBang      = true,       -- maxPenetrationCount = 99, penetrationMultiplier = 1.0 → сквозь стены
    NoSpread      = true,       -- direction всегда точно в цель (убирает случайный разброс)

    -- Drawing
    ShowFOV       = true,
    ShowLine      = true,
    ShowName      = true,
    ShowDistance  = true,       -- показывать дистанцию до цели
    LineColorLock = Color3.fromRGB(0, 255, 80),
    LineColorIdle = Color3.fromRGB(255, 60, 60),
    FOVColor      = Color3.fromRGB(255, 255, 255),
    DebugLog      = true,       -- печатать в консоль что патчим
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
--  DRAWING
-- ============================================================
local drawFOV = Drawing.new("Circle")
drawFOV.Visible      = false
drawFOV.Radius       = CONFIG.FOV
drawFOV.Color        = CONFIG.FOVColor
drawFOV.Thickness    = 1
drawFOV.Filled       = false
drawFOV.Transparency = 0.55

local drawLine = Drawing.new("Line")
drawLine.Visible      = false
drawLine.Thickness    = 1.5
drawLine.Color        = CONFIG.LineColorLock
drawLine.Transparency = 0.85

local drawLineDot = Drawing.new("Circle")
drawLineDot.Visible      = false
drawLineDot.Radius       = 5
drawLineDot.Filled       = true
drawLineDot.Color        = CONFIG.LineColorLock
drawLineDot.Transparency = 0.85

local drawName = Drawing.new("Text")
drawName.Visible      = false
drawName.Size         = 14
drawName.Color        = Color3.fromRGB(255, 255, 255)
drawName.Outline      = true
drawName.OutlineColor = Color3.fromRGB(0, 0, 0)
drawName.Center       = true

local drawDist = Drawing.new("Text")
drawDist.Visible      = false
drawDist.Size         = 12
drawDist.Color        = Color3.fromRGB(200, 200, 200)
drawDist.Outline      = true
drawDist.OutlineColor = Color3.fromRGB(0, 0, 0)
drawDist.Center       = true

-- ============================================================
--  HELPERS — только чистая математика, никаких сервисных вызовов в хуке
-- ============================================================
local function getHitPart(char)
    return char:FindFirstChild(CONFIG.AimPart) or char:FindFirstChild("HumanoidRootPart")
end

local function isSameTeam(player)
    if not CONFIG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == player.Team
end

local _rayParams = RaycastParams.new()
_rayParams.FilterType = Enum.RaycastFilterType.Exclude
local function hasWall(origin, targetPos, char)
    if not CONFIG.WallCheck then return false end
    local filter = {Camera}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    table.insert(filter, char)
    _rayParams.FilterDescendantsInstances = filter
    local result = workspace:Raycast(origin, targetPos - origin, _rayParams)
    return result ~= nil
end

local function worldToScreen(pos)
    local sp, vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), vis
end

local function screenCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function predictPos(hitPart, spd)
    if not CONFIG.PredictLead then return hitPart.Position end
    local root = hitPart.Parent:FindFirstChild("HumanoidRootPart") or hitPart
    local ok, vel = pcall(function() return root.AssemblyLinearVelocity end)
    if not ok then return hitPart.Position end
    local dist   = (hitPart.Position - Camera.CFrame.Position).Magnitude
    local travel = dist / math.max(spd, 1)
    return hitPart.Position + vel * travel * CONFIG.LeadFactor
end

-- ============================================================
--  КЕШ ЦЕЛИ — обновляется из RenderStepped, хук только читает
-- ============================================================
local cachedTarget    = nil
local cachedTargetPos = nil
local cachedTargetDist = 0

local function updateTargetCache()
    local center = screenCenter()
    local origin = Camera.CFrame.Position
    local bestPlayer, bestPos, bestDist = nil, nil, math.huge
    local bestScreenDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if isSameTeam(player) then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = getHitPart(char)
        if not part then continue end
        local predPos = predictPos(part, 1000)
        local sp, vis = worldToScreen(predPos)
        if not vis then continue end
        local screenDist = (sp - center).Magnitude
        if screenDist > CONFIG.FOV then continue end
        -- Если WallBang включён — игнорируем стены при прицеливании
        if not CONFIG.WallBang and hasWall(origin, predPos, char) then continue end
        if screenDist < bestScreenDist then
            bestScreenDist = screenDist
            bestPlayer = player
            bestPos    = predPos
            bestDist   = (predPos - origin).Magnitude
        end
    end

    cachedTarget     = bestPlayer
    cachedTargetPos  = bestPos
    cachedTargetDist = bestDist or 0
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not CONFIG.Enabled then
        drawFOV.Visible     = false
        drawLine.Visible    = false
        drawLineDot.Visible = false
        drawName.Visible    = false
        drawDist.Visible    = false
        return
    end

    updateTargetCache()

    local center = screenCenter()

    drawFOV.Position = center
    drawFOV.Visible  = CONFIG.ShowFOV
    drawFOV.Radius   = CONFIG.FOV
    drawFOV.Color    = cachedTarget and CONFIG.LineColorLock or CONFIG.FOVColor

    if cachedTarget and cachedTargetPos then
        local sp, vis = worldToScreen(cachedTargetPos)

        drawLine.Visible  = CONFIG.ShowLine and vis
        drawLine.From     = center
        drawLine.To       = sp
        drawLine.Color    = CONFIG.LineColorLock

        drawLineDot.Visible   = CONFIG.ShowLine and vis
        drawLineDot.Position  = sp
        drawLineDot.Color     = CONFIG.LineColorLock

        drawName.Visible   = CONFIG.ShowName and vis
        drawName.Position  = Vector2.new(sp.X, sp.Y - 22)
        drawName.Text      = cachedTarget.Name

        drawDist.Visible   = CONFIG.ShowDistance and vis
        drawDist.Position  = Vector2.new(sp.X, sp.Y + 10)
        drawDist.Text      = string.format("%.0fm", cachedTargetDist)
    else
        drawLine.Visible    = false
        drawLineDot.Visible = false
        drawName.Visible    = false
        drawDist.Visible    = false
    end
end)

-- ============================================================
--  REMOTE
-- ============================================================
local ServerBulletRemote = nil

local function findRemote()
    local rs = game:GetService("ReplicatedStorage")
    local ok, engine = pcall(function()
        local e = rs:FindFirstChild("ACS_Engine")
        if not e then e = rs:WaitForChild("ACS_Engine", 15) end
        return e
    end)
    if not ok or not engine then return nil end
    local ok2, events = pcall(function()
        local e = engine:FindFirstChild("Events")
        if not e then e = engine:WaitForChild("Events", 10) end
        return e
    end)
    if not ok2 or not events then return nil end
    return events:FindFirstChild("ServerBullet")
end

ServerBulletRemote = findRemote()
if ServerBulletRemote then
    print("[SilentAim v4] Remote OK:", ServerBulletRemote:GetFullName())
else
    warn("[SilentAim v4] Remote не найден, жду 6 сек...")
    task.spawn(function()
        task.wait(6)
        ServerBulletRemote = findRemote()
        if ServerBulletRemote then
            print("[SilentAim v4] Remote найден:", ServerBulletRemote:GetFullName())
        else
            warn("[SilentAim v4] ServerBullet не найден! Путь: ReplicatedStorage.ACS_Engine.Events.ServerBullet")
        end
    end)
end

-- ============================================================
--  HOOK
--  ServerBullet:FireServer(origin: Vector3, direction: Vector3, shellData: table)
--  args[1] = origin (Vector3)
--  args[2] = direction (Vector3, unit)
--  args[3] = shellData (table) — содержит shellSpeed, maxPenetrationCount, origin, etc.
--
--  ВАЖНО: shellData.origin = args[1] (копия позиции мушки, используется FastCast на сервере)
--  Нам нужно патчить ТОЛЬКО args[2] (direction) — на направление к цели.
--  shellData.origin трогать не нужно — пуля летит от мушки, только направление меняем.
-- ============================================================
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if CONFIG.Enabled
        and method == "FireServer"
        and ServerBulletRemote
        and rawequal(self, ServerBulletRemote)
        and cachedTargetPos
    then
        local args = table.pack(...)
        -- args.n = 3: [1]=origin(V3), [2]=direction(V3), [3]=shellData(table)

        -- Автодетект индексов Vector3
        local originIdx, dirIdx
        for i = 1, args.n do
            if typeof(args[i]) == "Vector3" then
                if not originIdx then originIdx = i
                elseif not dirIdx then dirIdx = i; break end
            end
        end

        -- Патч direction → прямо в кешированную цель
        if originIdx and dirIdx then
            local origin = args[originIdx]
            local toTarget = cachedTargetPos - origin
            if toTarget.Magnitude > 0 then
                args[dirIdx] = toTarget.Unit    -- точный unit-вектор к голове цели
            end
        end

        -- Патч shellData (args[3])
        local shellData = args[3]
        if type(shellData) == "table" then
            -- BulletTP: shellSpeed огромный → пуля летит мгновенно
            if CONFIG.BulletTP then
                shellData.shellSpeed = 999999
            end
            -- WallBang: пуля проходит сквозь всё
            if CONFIG.WallBang then
                shellData.maxPenetrationCount    = 99
                shellData.currentPenetrationCount = 0
                shellData.penetrationMultiplier  = 1.0
            end
            -- NoSpread: убедимся что origin в shellData совпадает с тем что мы отправляем
            -- (на всякий случай синхронизируем)
            if originIdx and shellData.origin then
                shellData.origin = args[originIdx]
            end
        end

        if CONFIG.DebugLog then
            local tName = cachedTarget and cachedTarget.Name or "?"
            local dist  = cachedTargetDist
            print(string.format(
                "[SA v4] FIRE → %s | dist=%.0f | BTP=%s WB=%s",
                tName, dist,
                tostring(CONFIG.BulletTP),
                tostring(CONFIG.WallBang)
            ))
        end

        return originalNamecall(self, table.unpack(args, 1, args.n))
    end

    return originalNamecall(self, ...)
end))

-- ============================================================
--  KEYBINDS
--  Insert      = включить/выключить SilentAim
--  Delete      = включить/выключить BulletTP
--  End         = включить/выключить WallBang
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    local function notify(title, text)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title, Text = text, Duration = 2
            })
        end)
    end

    if input.KeyCode == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        notify("SilentAim v4", CONFIG.Enabled and "✓ Включён" or "✗ Выключен")
        print("[SA v4] Enabled =", CONFIG.Enabled)

    elseif input.KeyCode == Enum.KeyCode.Delete then
        CONFIG.BulletTP = not CONFIG.BulletTP
        notify("BulletTP", CONFIG.BulletTP and "✓ ON — мгновенный долёт" or "✗ OFF")
        print("[SA v4] BulletTP =", CONFIG.BulletTP)

    elseif input.KeyCode == Enum.KeyCode.End then
        CONFIG.WallBang = not CONFIG.WallBang
        notify("WallBang", CONFIG.WallBang and "✓ ON — сквозь стены" or "✗ OFF")
        print("[SA v4] WallBang =", CONFIG.WallBang)
    end
end)

-- ============================================================
--  СТАТУС
-- ============================================================
print(string.format(
    "[SilentAim v4] Загружен | FOV=%d | AimPart=%s | BulletTP=%s | WallBang=%s",
    CONFIG.FOV, CONFIG.AimPart,
    tostring(CONFIG.BulletTP), tostring(CONFIG.WallBang)
))
print("  Insert=toggle | Delete=BulletTP | End=WallBang")
