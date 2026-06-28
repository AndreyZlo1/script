--[[
    SilentAim v7 — ACS Engine (FastCastRedux)
    GitHub: AndreyZlo1/script | коммит 78e5b5e

    НОВОЕ В v7:
    ─────────────────────────────────────────────
    + FullAuto  — принудительный ShootType=3 через upvalue u7
    + InfAmmo   — патч u3/u4 через upvalue, бесконечно
    + NoRecoil  — нулевой camRecoil/gunRecoil через u7 upvalue
    + FireRate  — патч u7.ShootRate (+ горячие клавиши +/-)
    + KillAll   — Damage:InvokeServer на всех игроков

    АРХИТЕКТУРА:
    ─────────────────────────────────────────────
    u7      = gun config table (ShootRate, ShootType, camRecoil...)
    u3      = текущие патроны в магазине
    u4      = запасные патроны
    u64     = {NextShot, BurstBullets, LastShot}
    Recoil()= функция с upvalues [u7, u54, Control, u65, u17]

    Поиск через getgc():
    - u7: table с ключами ShootRate + ShootType + camRecoil
    - Recoil: function с upvalue name "Recoil" или по сигнатуре
    - u3/u4: числа в upvalues функций с "u3"/"u4" по дампу

    KillAll:
    - Damage:InvokeServer(shellData, humanoid, 0, 1, hitPart)
    - Сервер верит клиенту о попадании, наносит урон
    - Проходим по всем Players включая тиммейтов
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    -- Silent Aim
    Enabled      = true,
    FOV          = 300,
    AimPart      = "Head",
    TeamCheck    = true,
    PredictLead  = true,
    LeadFactor   = 0.08,
    SilentAim    = true,
    BulletTP     = true,
    WallBang     = true,
    ForceHit     = false,

    -- Новые фичи
    FullAuto     = false,   -- принудительный Auto для любого оружия
    InfAmmo      = false,   -- бесконечные патроны (u3/u4 = большое число)
    NoRecoil     = false,   -- нулевой отдача камеры и модели
    FireRate     = nil,     -- nil = не трогаем, число = RPM (напр. 1200)

    -- ESP
    ShowFOV      = true,
    ShowLine     = true,
    ShowName     = true,
    ShowHP       = true,
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
drawLineDot.Filled = true; drawLineDot.Color = CONFIG.LineColor; drawLineDot.Transparency = 0.85

local drawName = Drawing.new("Text")
drawName.Visible = false; drawName.Size = 14
drawName.Color = Color3.fromRGB(255,255,255)
drawName.Outline = true; drawName.OutlineColor = Color3.fromRGB(0,0,0); drawName.Center = true

local drawHP = Drawing.new("Text")
drawHP.Visible = false; drawHP.Size = 12
drawHP.Color = Color3.fromRGB(150,255,150)
drawHP.Outline = true; drawHP.OutlineColor = Color3.fromRGB(0,0,0); drawHP.Center = true

local drawDist = Drawing.new("Text")
drawDist.Visible = false; drawDist.Size = 11
drawDist.Color = Color3.fromRGB(200,200,200)
drawDist.Outline = true; drawDist.OutlineColor = Color3.fromRGB(0,0,0); drawDist.Center = true

-- HUD текст для статуса
local drawStatus = Drawing.new("Text")
drawStatus.Visible = true; drawStatus.Size = 13
drawStatus.Color = Color3.fromRGB(255,220,0)
drawStatus.Outline = true; drawStatus.OutlineColor = Color3.fromRGB(0,0,0)
drawStatus.Position = Vector2.new(10, 10)

-- ============================================================
--  HITBOX-части из BulletHitDetector дампа
-- ============================================================
local HITBOX_PARTS = {
    Head=true, RootPart=true, UpperTorso=true, LowerTorso=true,
    LeftFoot=true, LeftLowerLeg=true, LeftUpperLeg=true,
    LeftHand=true, LeftLowerArm=true, LeftUpperArm=true,
    RightFoot=true, RightLowerLeg=true, RughtUpperLeg=true,
    RightHand=true, RightLowerArm=true, RightUpperArm=true
}

-- ============================================================
--  КЕШ ЦЕЛИ
-- ============================================================
local cachedTarget    = nil
local cachedTargetPos = nil
local cachedDist      = 0
local cachedHP        = 0

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
    local bestPlayer, bestPos, bestDist, bestSD, bestHP = nil, nil, 0, math.huge, 0

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
            bestSD = sd; bestPlayer = pl; bestPos = predPos
            bestDist = (predPos - camPos).Magnitude; bestHP = math.floor(hum.Health)
        end
    end

    cachedTarget = bestPlayer; cachedTargetPos = bestPos
    cachedDist = bestDist; cachedHP = bestHP
end

-- ============================================================
--  RENDER LOOP + HUD
-- ============================================================
RunService.RenderStepped:Connect(function()
    -- HUD статус
    local function boolStr(v) return v and "§ON" or "OFF" end
    drawStatus.Text = string.format(
        "[SA v7] SA:%s BTP:%s WB:%s FA:%s IA:%s NR:%s FH:%s FR:%s",
        boolStr(CONFIG.SilentAim and CONFIG.Enabled),
        boolStr(CONFIG.BulletTP), boolStr(CONFIG.WallBang),
        boolStr(CONFIG.FullAuto), boolStr(CONFIG.InfAmmo),
        boolStr(CONFIG.NoRecoil), boolStr(CONFIG.ForceHit),
        CONFIG.FireRate and tostring(CONFIG.FireRate).."rpm" or "def"
    ):gsub("§ON", "ON")
    drawStatus.Color = CONFIG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)

    if not CONFIG.Enabled then
        drawFOV.Visible = false; drawLine.Visible = false
        drawLineDot.Visible = false; drawName.Visible = false
        drawHP.Visible = false; drawDist.Visible = false; return
    end
    updateCache()
    local center = screenCenter()
    drawFOV.Position = center; drawFOV.Visible = CONFIG.ShowFOV
    drawFOV.Radius = CONFIG.FOV
    drawFOV.Color = cachedTarget and CONFIG.LineColor or CONFIG.FOVColor

    if cachedTarget and cachedTargetPos then
        local sp, vis = w2s(cachedTargetPos)
        drawLine.Visible = CONFIG.ShowLine and vis
        drawLine.From = center; drawLine.To = sp
        drawLineDot.Visible = CONFIG.ShowLine and vis; drawLineDot.Position = sp
        drawName.Visible = CONFIG.ShowName and vis
        drawName.Position = Vector2.new(sp.X, sp.Y - 24)
        drawName.Text = cachedTarget.Name
        drawHP.Visible = CONFIG.ShowHP and vis
        drawHP.Position = Vector2.new(sp.X, sp.Y - 12)
        drawHP.Text = cachedHP .. " HP"
        drawHP.Color = Color3.fromRGB(
            math.floor(255*(1-cachedHP/100)),
            math.floor(255*(cachedHP/100)), 0)
        drawDist.Visible = CONFIG.ShowDistance and vis
        drawDist.Position = Vector2.new(sp.X, sp.Y + 8)
        drawDist.Text = string.format("%.0fm", cachedDist)
    else
        drawLine.Visible=false; drawLineDot.Visible=false
        drawName.Visible=false; drawHP.Visible=false; drawDist.Visible=false
    end
end)

-- ============================================================
--  REMOTES — безопасный поиск
-- ============================================================
local Remotes = {}

task.spawn(function()
    local ok, rs = pcall(game.GetService, game, "ReplicatedStorage")
    if not ok then return end
    local function sw(p, n, t) local o,r = pcall(function() return p:WaitForChild(n, t or 12) end); return o and r or p:FindFirstChild(n) end
    local engine = sw(rs, "ACS_Engine", 15)
    if not engine then warn("[SA v7] ACS_Engine не найден"); return end
    local events = sw(engine, "Events", 10)
    if not events then warn("[SA v7] Events не найден"); return end
    local function cr(i) return (i and cloneref) and cloneref(i) or i end
    Remotes.ServerBullet = cr(events:FindFirstChild("ServerBullet"))
    Remotes.Damage       = cr(events:FindFirstChild("Damage"))
    if Remotes.ServerBullet then print("[SA v7] ServerBullet OK") end
    if Remotes.Damage then print("[SA v7] Damage OK") end
end)

-- ============================================================
--  GC HELPERS
-- ============================================================

-- Ищем функцию по имени через getgc
local function findFuncByName(name)
    for _, f in getgc(false) do
        if type(f) == "function" then
            local ok, info = pcall(debug.getinfo, f)
            if ok and info and info.name == name then return f end
        end
    end
end

-- Ищем таблицу по набору обязательных ключей
local function findTableByKeys(keys)
    for _, obj in getgc(true) do
        if type(obj) == "table" then
            local found = true
            for _, k in ipairs(keys) do
                if rawget(obj, k) == nil then found = false; break end
            end
            if found then return obj end
        end
    end
end

-- ============================================================
--  ПАТЧ u7 (gun config) — FullAuto + NoRecoil + FireRate + InfAmmo
--  u7 — table с полями ShootRate, ShootType, camRecoil, gunRecoil
-- ============================================================
local u7Patched = nil

local function findAndPatchU7()
    -- Ищем u7 в getgc: table с ShootRate + ShootType + camRecoil
    local u7 = findTableByKeys({"ShootRate", "ShootType", "camRecoil", "gunRecoil"})

    if not u7 then
        -- Резервный поиск через upvalues функции Recoil
        local recoilFn = findFuncByName("Recoil")
        if recoilFn then
            local uvs = debug.getupvalues(recoilFn)
            for _, v in pairs(uvs) do
                if type(v) == "table" and v.ShootRate and v.camRecoil then
                    u7 = v; break
                end
            end
        end
    end

    if not u7 then
        warn("[SA v7] u7 (gun config) не найден в GC")
        return nil
    end

    u7Patched = u7
    print(string.format("[SA v7] u7 найден: ShootRate=%s ShootType=%s",
        tostring(u7.ShootRate), tostring(u7.ShootType)))
    return u7
end

-- Применяем патч u7 (вызывать при смене флагов + при экипировке нового оружия)
local function applyU7Patch(u7)
    if not u7 then return end

    -- FullAuto: ShootType=3 (непрерывный огонь при зажатой кнопке)
    if CONFIG.FullAuto then
        u7.ShootType = 3
    end

    -- NoRecoil: обнуляем camRecoil и gunRecoil
    if CONFIG.NoRecoil then
        u7.camRecoil = {
            camRecoilUp    = {0, 0},
            camRecoilTilt  = {0, 0},
            camRecoilLeft  = {0, 0},
            camRecoilRight = {0, 0},
        }
        u7.gunRecoil = {
            gunRecoilUp    = {0, 0},
            gunRecoilTilt  = {0, 0},
            gunRecoilLeft  = {0, 0},
            gunRecoilRight = {0, 0},
        }
        -- u17 (recoil power) — через upvalues Recoil
        local recoilFn = findFuncByName("Recoil")
        if recoilFn then
            local uvs = debug.getupvalues(recoilFn)
            for k, v in pairs(uvs) do
                if type(v) == "number" and k ~= "u7" and k ~= "u54" then
                    -- u17 = recoil power (число)
                    debug.setupvalue(recoilFn, k, 0)
                end
            end
        end
    end

    -- FireRate: ShootRate в RPM
    if CONFIG.FireRate then
        u7.ShootRate = CONFIG.FireRate
    end
end

-- ============================================================
--  InfAmmo — патч u3 / u4 через upvalues стрелятельной функции
--  u3 = curAmmo, u4 = storedAmmo
--  Нет прямого доступа к переменным — патчим через hookfunction на
--  функцию которая их уменьшает (u250 — основная shoot function)
-- ============================================================
local infAmmoConnection = nil

local function setupInfAmmo()
    -- Стратегия: в Heartbeat непрерывно патчим через getgc upvalue u3/u4
    -- Ищем функции у которых есть upvalue типа number с именем "u3"/"u4"
    -- (Potassium debug.getupvalues возвращает {name=val} или {[idx]=val})
    -- Резервно: перехватываем любые функции которые декрементируют ammo

    -- Простой способ: hookfunction на ACS_Framework shoot через ShootModule
    -- u3 уменьшается после u250() — это в той же closure где и ShootModule.fire
    -- Вместо патча upvalue — просто хукаем Damage и возвращаем InfAmmo флаг

    -- ОСНОВНОЙ СПОСОБ: RunService.Heartbeat — проверяем все closure
    -- у которых есть u3 как upvalue number > 0, и ставим его в 9999
    if infAmmoConnection then infAmmoConnection:Disconnect() end
    infAmmoConnection = RunService.Heartbeat:Connect(function()
        if not CONFIG.InfAmmo then return end
        -- Ищем таблицу u64 {NextShot, BurstBullets, LastShot} — соседняя closure
        -- с u3. Через getgc ищем все функции и патчим upvalue u3
        for _, f in getgc(false) do
            if type(f) ~= "function" then continue end
            local ok, uvs = pcall(debug.getupvalues, f)
            if not ok then continue end
            for idx, val in pairs(uvs) do
                -- u3 и u4 — числа, обычно 0..200 диапазон патронов
                if type(val) == "number" and val >= 0 and val < 500 then
                    -- Проверяем что это upvalue патронов (смотрим на соседей)
                    -- Эвристика: если у этой функции есть upvalue похожий на u7 (table ShootRate)
                    local hasU7 = false
                    for _, uv in pairs(uvs) do
                        if type(uv) == "table" and rawget(uv, "ShootRate") ~= nil then
                            hasU7 = true; break
                        end
                    end
                    if hasU7 then
                        -- Это функция из ACS_Framework, val похоже на ammo
                        pcall(debug.setupvalue, f, idx, 9999)
                    end
                end
            end
        end
    end)
end

-- ============================================================
--  HOOK ShootModule.fire + BulletHitDetector.canRayPierce
-- ============================================================
local ShootModuleHooked = false

local function hookShootModule()
    local ShootModule = nil
    for _, obj in getgc(true) do
        if type(obj) == "table" then
            local f = rawget(obj, "fire")
            if type(f) == "function" then
                local ok, info = pcall(debug.getinfo, f)
                if ok and info and (info.nups or 0) >= 5 then
                    ShootModule = obj; break
                end
            end
        end
    end
    if not ShootModule then
        local ok, res = pcall(filtergc, "table", {Keys={"fire"}, ValTypes={"function"}})
        if ok and res then
            for _, obj in ipairs(res) do
                local f = rawget(obj, "fire")
                if type(f) == "function" then
                    local ok2, info = pcall(debug.getinfo, f)
                    if ok2 and info and (info.nups or 0) >= 5 then
                        ShootModule = obj; break
                    end
                end
            end
        end
    end
    if not ShootModule then warn("[SA v7] ShootModule не найден"); return false end

    local origFire = ShootModule.fire

    -- Hook canRayPierce (WallBang исправленный)
    local uvs = debug.getupvalues(origFire)
    for _, val in pairs(uvs) do
        if type(val) == "table" and type(rawget(val, "canRayPierce")) == "function" then
            local origPierce = val.canRayPierce
            val.canRayPierce = newcclosure(function(player, instance, shellData)
                if CONFIG.WallBang and player == LocalPlayer then
                    if instance and instance.Parent then
                        local hasHum = instance.Parent:FindFirstChildOfClass("Humanoid") ~= nil
                        local isHitbox = HITBOX_PARTS[instance.Name] == true
                        if hasHum and isHitbox then
                            return origPierce(player, instance, shellData)
                        end
                        return true
                    end
                    return true
                end
                return origPierce(player, instance, shellData)
            end, "ACS_canRayPierce")
            print("[SA v7] WallBang: canRayPierce OK")
            break
        end
    end

    ShootModule.fire = newcclosure(function(player, origin, direction, shellData, extra)
        if CONFIG.Enabled and player == LocalPlayer then
            if CONFIG.SilentAim and cachedTargetPos then
                local toTarget = cachedTargetPos - origin
                if toTarget.Magnitude > 0 then direction = toTarget.Unit end
            end
            if CONFIG.BulletTP and type(shellData) == "table" then
                shellData.shellSpeed = 9e9
            end
            if CONFIG.ForceHit and cachedTarget then
                task.defer(function()
                    if not Remotes.Damage or not cachedTarget then return end
                    local char = cachedTarget.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hp = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if not hum or not hp or hum.Health <= 0 then return end
                    local dist = (hp.Position - origin).Magnitude
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    local sd = {
                        weaponName=tool and tool.Name or "G19X", shellType="Bullet",
                        shellName="9x19mm", shellSpeed=9e9,
                        maxPenetrationCount=0, currentPenetrationCount=0,
                        penetrationMultiplier=0.8, origin=origin,
                        bulletID=LocalPlayer.Name..LocalPlayer.UserId..tick()..math.random(111,999)
                    }
                    pcall(function() Remotes.Damage:InvokeServer(sd, hum, dist, 1, hp) end)
                end)
            end
        end
        return origFire(player, origin, direction, shellData, extra)
    end, "ACS_ShootModule_fire")

    ShootModuleHooked = true
    print("[SA v7] ShootModule.fire OK")
    return true
end

-- ============================================================
--  HOOK hookmetamethod — резервный
-- ============================================================
local function hookNamecall()
    local origNC
    origNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if CONFIG.Enabled and method == "FireServer"
            and Remotes.ServerBullet and cachedTargetPos
        then
            local isTarget = false
            local ok, res = pcall(compareinstances, self, Remotes.ServerBullet)
            if ok and res then isTarget = true
            else
                local ok2, nm = pcall(function() return self.Name end)
                local ok3, pr = pcall(function() return self.Parent and self.Parent.Name end)
                if ok2 and ok3 and nm == "ServerBullet" and pr == "Events" then isTarget = true end
            end
            if isTarget then
                local args = table.pack(...)
                local oIdx, dIdx
                for i = 1, args.n do
                    if typeof(args[i]) == "Vector3" then
                        if not oIdx then oIdx = i elseif not dIdx then dIdx = i; break end
                    end
                end
                if dIdx then
                    local origin = oIdx and args[oIdx] or Camera.CFrame.Position
                    local toT = cachedTargetPos - origin
                    if toT.Magnitude > 0 then args[dIdx] = toT.Unit end
                end
                local sd = args[3]
                if type(sd) == "table" and CONFIG.BulletTP then sd.shellSpeed = 9e9 end
                return origNC(self, table.unpack(args, 1, args.n))
            end
        end
        return origNC(self, ...)
    end))
    print("[SA v7] hookmetamethod OK")
end

-- ============================================================
--  KILLALL — Damage:InvokeServer на ВСЕХ игроков
--  shellData минимальный но валидный
-- ============================================================
local killAllCooldown = false

local function doKillAll()
    if killAllCooldown then
        warn("[SA v7] KillAll на кулдауне (3 сек)")
        return
    end
    if not Remotes.Damage then
        warn("[SA v7] Damage remote не найден — KillAll невозможен")
        return
    end

    killAllCooldown = true
    local lchar = LocalPlayer.Character
    local origin = lchar and lchar:FindFirstChild("HumanoidRootPart")
        and lchar.HumanoidRootPart.Position or Camera.CFrame.Position
    local tool = lchar and lchar:FindFirstChildOfClass("Tool")

    local count = 0
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        local char = pl.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local hitPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not hitPart then continue end

        local dist = (hitPart.Position - origin).Magnitude
        local sd = {
            weaponName              = tool and tool.Name or "G19X",
            shellType               = "Bullet",
            shellName               = "9x19mm",
            shellSpeed              = 9e9,
            maxPenetrationCount     = 0,
            currentPenetrationCount = 0,
            penetrationMultiplier   = 0.8,
            origin                  = origin,
            bulletID                = LocalPlayer.Name .. LocalPlayer.UserId
                                      .. tick() .. math.random(111,999) .. math.random(111,999),
        }

        task.spawn(function()
            local ok, err = pcall(function()
                Remotes.Damage:InvokeServer(sd, hum, dist, 1, hitPart)
            end)
            if not ok and CONFIG.DebugLog then
                warn("[SA v7] KillAll error на " .. pl.Name .. ": " .. tostring(err))
            end
        end)
        count = count + 1
        task.wait(0.05)  -- небольшая задержка между InvokeServer чтобы не спамить
    end

    print(string.format("[SA v7] KillAll: отправлено %d запросов", count))
    task.wait(3)
    killAllCooldown = false
end

-- ============================================================
--  WATCH — при смене оружия перепатчиваем u7
-- ============================================================
local lastEquipped = nil
task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if not char then continue end
        local tool = char:FindFirstChildOfClass("Tool")
        local toolName = tool and tool.Name or nil
        if toolName ~= lastEquipped then
            lastEquipped = toolName
            if toolName then
                print("[SA v7] Оружие сменилось на:", toolName, "— перепатчиваем u7")
                task.wait(0.3)  -- ждём инициализации u7
                local u7 = findAndPatchU7()
                if u7 then applyU7Patch(u7) end
            end
        end
    end
end)

-- ============================================================
--  ИНИЦИАЛИЗАЦИЯ
-- ============================================================
task.spawn(function()
    task.wait(1.5)
    local ok = hookShootModule()
    hookNamecall()

    task.wait(0.5)
    local u7 = findAndPatchU7()
    if u7 then applyU7Patch(u7) end

    setupInfAmmo()

    print(string.format(
        "[SilentAim v7] Готов | ShootHook=%s | SA=%s | BTP=%s | WB=%s",
        tostring(ok), tostring(CONFIG.SilentAim),
        tostring(CONFIG.BulletTP), tostring(CONFIG.WallBang)
    ))
    print("[SA v7] Клавиши:")
    print("  Insert     = SA on/off")
    print("  Delete     = BulletTP on/off")
    print("  End        = WallBang on/off")
    print("  Home       = ForceHit on/off")
    print("  F5         = FullAuto on/off")
    print("  F6         = InfAmmo on/off")
    print("  F7         = NoRecoil on/off")
    print("  F8         = FireRate x2 (двойная скорострельность)")
    print("  F9         = FireRate reset")
    print("  F10        = KillAll (ОПАСНО)")
    print("  PageUp     = FOV +50")
    print("  PageDown   = FOV -50")
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local function notify(t, m)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification",
                {Title=t, Text=m, Duration=2.5})
        end)
    end
    local k = input.KeyCode

    if k == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        notify("SA v7", CONFIG.Enabled and "✓ SilentAim ON" or "✗ SilentAim OFF")

    elseif k == Enum.KeyCode.Delete then
        CONFIG.BulletTP = not CONFIG.BulletTP
        notify("BulletTP", CONFIG.BulletTP and "✓ ON" or "✗ OFF")

    elseif k == Enum.KeyCode.End then
        CONFIG.WallBang = not CONFIG.WallBang
        notify("WallBang", CONFIG.WallBang and "✓ ON (стены, не хитбоксы)" or "✗ OFF")

    elseif k == Enum.KeyCode.Home then
        CONFIG.ForceHit = not CONFIG.ForceHit
        notify("ForceHit", CONFIG.ForceHit and "✓ ON (агрессивно)" or "✗ OFF")

    elseif k == Enum.KeyCode.F5 then
        CONFIG.FullAuto = not CONFIG.FullAuto
        notify("FullAuto", CONFIG.FullAuto and "✓ ON" or "✗ OFF")
        local u7 = u7Patched or findAndPatchU7()
        if CONFIG.FullAuto and u7 then u7.ShootType = 3
        elseif u7 then u7.ShootType = u7._origShootType or u7.ShootType end
        if u7 and not u7._origShootType then u7._origShootType = u7.ShootType end

    elseif k == Enum.KeyCode.F6 then
        CONFIG.InfAmmo = not CONFIG.InfAmmo
        notify("InfAmmo", CONFIG.InfAmmo and "✓ ON" or "✗ OFF")

    elseif k == Enum.KeyCode.F7 then
        CONFIG.NoRecoil = not CONFIG.NoRecoil
        notify("NoRecoil", CONFIG.NoRecoil and "✓ ON" or "✗ OFF")
        local u7 = u7Patched or findAndPatchU7()
        if u7 then applyU7Patch(u7) end

    elseif k == Enum.KeyCode.F8 then
        -- FireRate x2
        local u7 = u7Patched or findAndPatchU7()
        if u7 then
            if not u7._origShootRate then u7._origShootRate = u7.ShootRate end
            CONFIG.FireRate = u7._origShootRate * 2
            u7.ShootRate = CONFIG.FireRate
            notify("FireRate x2", tostring(CONFIG.FireRate) .. " RPM")
        else
            notify("FireRate", "u7 не найден")
        end

    elseif k == Enum.KeyCode.F9 then
        -- FireRate reset
        local u7 = u7Patched or findAndPatchU7()
        if u7 and u7._origShootRate then
            u7.ShootRate = u7._origShootRate
            CONFIG.FireRate = nil
            notify("FireRate", "Сброшен → " .. tostring(u7._origShootRate) .. " RPM")
        else
            notify("FireRate", "Оригинал не запомнен")
        end

    elseif k == Enum.KeyCode.F10 then
        notify("KillAll", "Выполняется...")
        task.spawn(doKillAll)

    elseif k == Enum.KeyCode.PageUp then
        CONFIG.FOV = math.min(CONFIG.FOV+50, 800)
        drawFOV.Radius = CONFIG.FOV
        notify("FOV", "= " .. CONFIG.FOV)

    elseif k == Enum.KeyCode.PageDown then
        CONFIG.FOV = math.max(CONFIG.FOV-50, 50)
        drawFOV.Radius = CONFIG.FOV
        notify("FOV", "= " .. CONFIG.FOV)
    end
end)
