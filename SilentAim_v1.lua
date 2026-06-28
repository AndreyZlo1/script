--[[
    SilentAim v6 — ACS Engine (FastCastRedux)
    GitHub: AndreyZlo1/script | коммит 7427939

    ═══════════════════════════════════════════════════════
    АРХИТЕКТУРА (из дампа GameDump):
    ═══════════════════════════════════════════════════════

    Выстрел (пешком):
      ShootModule.fire(LocalPlayer, origin, dir, shellData)
      ServerBullet:FireServer(origin, dir, shellData)

    Выстрел (танк):
      ShootModule.fire(LocalPlayer, Dome.FollowPart.Position, Dome.LookVector, shellData)
      ServerBullet:FireServer(origin, LookVector, shellData)

    Выстрел (вертолёт/самолёт):
      ShootModule.fire(LocalPlayer, gun.Position, -gun.LookVector, shellData)
      ServerBullet:FireServer(origin, LookVector, shellData)

    Урон:
      Damage:InvokeServer(shellData, humanoid, distance, hitType, hitPart, [penetrationIdx])
      hitType: 1 = headshot, 2 = остальное

    WallBang:
      BulletHitDetector.canRayPierce — проверяет u2 (hitboxes list)
      Если часть тела — return false (стоп). НАШ FIX: return true только
      для СТЕН (CanCollide=true, нет Humanoid), false для хитбоксов.

    ForceHit:
      Вызов Damage:InvokeServer напрямую с правильным shellData.

    ═══════════════════════════════════════════════════════
    ЧТО ИЗМЕНИЛОСЬ В v6:
    ═══════════════════════════════════════════════════════
    1. WallBang ИСПРАВЛЕН — пуля проходит только сквозь стены/объекты без Humanoid,
       но ОСТАНАВЛИВАЕТСЯ на хитбоксах врагов (корректная логика)
    2. ForceHit — прямой вызов Damage:InvokeServer по цели без физического полёта пули
    3. Транспорт — hookShootModule охватывает ВСЕХ ShootModule.fire (танк/вертолёт/самолёт)
    4. Поиск Remote безопаснее: cloneref + полный путь
    5. BulletTP работает корректно — shellSpeed в самом ShootModule.fire
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    Enabled      = true,
    FOV          = 300,
    AimPart      = "Head",         -- "Head" | "HumanoidRootPart" | "UpperTorso"
    TeamCheck    = true,
    PredictLead  = true,
    LeadFactor   = 0.08,

    SilentAim    = true,           -- перенаправление direction → цель
    BulletTP     = true,           -- shellSpeed = 9e9 (мгновенный долёт)
    WallBang     = true,           -- пуля проходит сквозь стены, НО бьёт хитбоксы
    ForceHit     = false,          -- прямой InvokeServer Damage без полёта пули (агрессивно)

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

-- ============================================================
--  HITBOX-части из BulletHitDetector
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
        -- WallCheck только если WallBang выключен
        if not CONFIG.WallBang and hasWall(camPos, predPos, char) then continue end
        if sd < bestSD then
            bestSD = sd
            bestPlayer = pl
            bestPos = predPos
            bestDist = (predPos - camPos).Magnitude
            bestHP = math.floor(hum.Health)
        end
    end

    cachedTarget    = bestPlayer
    cachedTargetPos = bestPos
    cachedDist      = bestDist
    cachedHP        = bestHP
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
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
            math.floor(255 * (1 - cachedHP/100)),
            math.floor(255 * (cachedHP/100)), 0)
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

local function findRemotes()
    local ok, rs = pcall(game.GetService, game, "ReplicatedStorage")
    if not ok then return end

    local function safe_wait(parent, name, timeout)
        local ok2, result = pcall(function()
            return parent:WaitForChild(name, timeout or 10)
        end)
        return ok2 and result or parent:FindFirstChild(name)
    end

    local engine = safe_wait(rs, "ACS_Engine", 15)
    if not engine then warn("[SA v6] ACS_Engine не найден"); return end

    local events = safe_wait(engine, "Events", 10)
    if not events then warn("[SA v6] Events не найден"); return end

    -- cloneref если доступен (защита от instance caching)
    local function cr(inst)
        if inst and cloneref then return cloneref(inst) end
        return inst
    end

    Remotes.ServerBullet = cr(events:FindFirstChild("ServerBullet"))
    Remotes.Damage       = cr(events:FindFirstChild("Damage"))

    if Remotes.ServerBullet then
        print("[SA v6] ServerBullet:", Remotes.ServerBullet:GetFullName())
    else
        warn("[SA v6] ServerBullet не найден")
    end
    if Remotes.Damage then
        print("[SA v6] Damage:", Remotes.Damage:GetFullName())
    else
        warn("[SA v6] Damage не найден")
    end
end

task.spawn(findRemotes)

-- ============================================================
--  FORCE HIT — прямой вызов Damage:InvokeServer
--  Сигнатура (из BulletHitDetector):
--    Damage:InvokeServer(shellData, humanoid, distance, hitType, hitPart)
--    hitType: 1=head, 2=body
--  Создаём минимальный shellData с нужными полями
-- ============================================================
local function doForceHit(targetPlayer)
    if not CONFIG.ForceHit then return end
    if not Remotes.Damage then return end
    if not targetPlayer or not targetPlayer.Character then return end
    local char = targetPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local hitPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not hitPart then return end
    local lchar = LocalPlayer.Character
    local origin = lchar and lchar:FindFirstChild("HumanoidRootPart")
        and lchar.HumanoidRootPart.Position
        or Camera.CFrame.Position

    -- shellData с обязательными полями для сервера
    local shellData = {
        weaponName              = "G19X",       -- имя оружия в руках
        shellType               = "Bullet",
        shellName               = "9x19mm",
        shellSpeed              = 9e9,
        maxPenetrationCount     = 0,
        currentPenetrationCount = 0,
        penetrationMultiplier   = 0.8,
        origin                  = origin,
        bulletID                = LocalPlayer.Name .. LocalPlayer.UserId
                                  .. tick() .. math.random(111,999),
    }
    -- Попытка взять имя текущего оружия
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then shellData.weaponName = tool.Name end

    local dist = (hitPart.Position - origin).Magnitude
    local ok, err = pcall(function()
        Remotes.Damage:InvokeServer(shellData, hum, dist, 1, hitPart)  -- 1 = headshot
    end)
    if not ok and CONFIG.DebugLog then
        warn("[SA v6] ForceHit error:", err)
    elseif CONFIG.DebugLog then
        print(string.format("[SA v6] ForceHit → %s | dist=%.0f", targetPlayer.Name, dist))
    end
end

-- ============================================================
--  HOOK ShootModule.fire — ОСНОВНОЙ
--  Охватывает пешком + танк + вертолёт + самолёт (все используют ShootModule)
--
--  fire(player, origin, direction, shellData, extra?)
-- ============================================================
local ShootModuleHooked = false

local function hookShootModule()
    -- Ищем через GC все таблицы с полем fire (функция с >= 5 upvalues)
    local ShootModule = nil
    local gcList = getgc(true)
    for i = 1, #gcList do
        local obj = gcList[i]
        if type(obj) == "table" then
            local f = rawget(obj, "fire")
            if type(f) == "function" then
                local ok, info = pcall(debug.getinfo, f)
                if ok and info and (info.nups or 0) >= 5 then
                    ShootModule = obj
                    break
                end
            end
        end
    end

    -- Запасной — filtergc
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

    if not ShootModule then
        warn("[SA v6] ShootModule не найден в GC")
        return false
    end

    local origFire = ShootModule.fire
    print("[SA v6] ShootModule.fire найден, хукаем")

    -- ── Hook canRayPierce для WallBang (ИСПРАВЛЕННЫЙ) ──────────────────
    -- Из upvalues origFire ищем BulletHitDetector
    local uvs = debug.getupvalues(origFire)
    for _, val in pairs(uvs) do
        if type(val) == "table" and type(rawget(val, "canRayPierce")) == "function" then
            print("[SA v6] BulletHitDetector найден, хукаем canRayPierce")
            local origPierce = val.canRayPierce
            val.canRayPierce = newcclosure(function(player, instance, shellData)
                if CONFIG.WallBang and player == LocalPlayer then
                    -- Пропускаем только если это НЕ хитбокс (т.е. стена/объект)
                    if instance and instance.Parent then
                        local hasHumanoid = instance.Parent:FindFirstChildOfClass("Humanoid") ~= nil
                        local isHitboxPart = HITBOX_PARTS[instance.Name] == true
                        if hasHumanoid and isHitboxPart then
                            -- Это хитбокс врага — НЕ пропускаем, пусть оригинал решает
                            return origPierce(player, instance, shellData)
                        end
                        -- Стена / объект / аксессуар — пропускаем
                        return true
                    end
                    return true
                end
                return origPierce(player, instance, shellData)
            end, "ACS_canRayPierce")
            print("[SA v6] WallBang: canRayPierce захукан (хитбоксы защищены)")
            break
        end
    end

    -- ── Hook ShootModule.fire ──────────────────────────────────────────
    ShootModule.fire = newcclosure(function(player, origin, direction, shellData, extra)
        if CONFIG.Enabled and player == LocalPlayer then

            -- SilentAim: направление к цели
            if CONFIG.SilentAim and cachedTargetPos then
                local toTarget = cachedTargetPos - origin
                if toTarget.Magnitude > 0 then
                    direction = toTarget.Unit
                end
            end

            -- BulletTP: скорость пули
            if CONFIG.BulletTP and type(shellData) == "table" then
                shellData.shellSpeed = 9e9
            end

            -- ForceHit: после выстрела прямо говорим серверу о попадании
            if CONFIG.ForceHit and cachedTarget then
                task.defer(doForceHit, cachedTarget)
            end

            if CONFIG.DebugLog then
                print(string.format("[SA v6] FIRE → %s | dist=%.0f | BTP=%s | WB=%s | FH=%s",
                    cachedTarget and cachedTarget.Name or "none",
                    cachedDist,
                    tostring(CONFIG.BulletTP),
                    tostring(CONFIG.WallBang),
                    tostring(CONFIG.ForceHit)))
            end
        end

        return origFire(player, origin, direction, shellData, extra)
    end, "ACS_ShootModule_fire")

    ShootModuleHooked = true
    return true
end

-- ============================================================
--  HOOK hookmetamethod — РЕЗЕРВНЫЙ
--  Используется вместе с основным как второй слой
-- ============================================================
local function hookNamecall()
    local origNamecall
    origNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()

        -- ServerBullet:FireServer — перехват direction
        if CONFIG.Enabled and method == "FireServer"
            and Remotes.ServerBullet and cachedTargetPos
        then
            local isTarget = false
            -- compareinstances (Potassium)
            local ok, res = pcall(compareinstances, self, Remotes.ServerBullet)
            if ok and res then
                isTarget = true
            else
                -- Fallback: проверка по имени + родителю
                local ok2, nm = pcall(function() return self.Name end)
                local ok3, pr = pcall(function() return self.Parent and self.Parent.Name end)
                if ok2 and ok3 and nm == "ServerBullet" and pr == "Events" then
                    isTarget = true
                end
            end

            if isTarget then
                local args = table.pack(...)
                -- Ищем два Vector3 (origin, direction)
                local oIdx, dIdx
                for i = 1, args.n do
                    if typeof(args[i]) == "Vector3" then
                        if not oIdx then oIdx = i
                        elseif not dIdx then dIdx = i; break end
                    end
                end
                if dIdx then
                    local origin = oIdx and args[oIdx] or Camera.CFrame.Position
                    local toT = cachedTargetPos - origin
                    if toT.Magnitude > 0 then args[dIdx] = toT.Unit end
                end
                -- shellData патч (аргумент после двух Vector3)
                local sd = args[3]
                if type(sd) == "table" then
                    if CONFIG.BulletTP then sd.shellSpeed = 9e9 end
                end
                return origNamecall(self, table.unpack(args, 1, args.n))
            end
        end

        return origNamecall(self, ...)
    end))
    print("[SA v6] hookmetamethod (fallback) активен")
end

-- ============================================================
--  ИНИЦИАЛИЗАЦИЯ
-- ============================================================
task.spawn(function()
    task.wait(1.5)  -- ждём загрузку ShootModule
    local ok = hookShootModule()
    hookNamecall()
    print(string.format(
        "[SilentAim v6] Готов | ShootHook=%s | SA=%s | BTP=%s | WB=%s | FH=%s",
        tostring(ok), tostring(CONFIG.SilentAim),
        tostring(CONFIG.BulletTP), tostring(CONFIG.WallBang),
        tostring(CONFIG.ForceHit)
    ))
    print("[SA v6] Клавиши:")
    print("  Insert   = SA on/off")
    print("  Delete   = BulletTP on/off")
    print("  End      = WallBang on/off")
    print("  Home     = ForceHit on/off (агрессивно!)")
    print("  PageUp   = FOV +50")
    print("  PageDown = FOV -50")
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local function notify(t, m)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification",{Title=t,Text=m,Duration=2})
        end)
    end
    local k = input.KeyCode
    if     k == Enum.KeyCode.Insert   then CONFIG.Enabled  = not CONFIG.Enabled;  notify("SilentAim v6", CONFIG.Enabled  and "✓ ON" or "✗ OFF")
    elseif k == Enum.KeyCode.Delete   then CONFIG.BulletTP = not CONFIG.BulletTP; notify("BulletTP",  CONFIG.BulletTP and "✓ ON" or "✗ OFF")
    elseif k == Enum.KeyCode.End      then CONFIG.WallBang = not CONFIG.WallBang; notify("WallBang",  CONFIG.WallBang and "✓ ON" or "✗ OFF")
    elseif k == Enum.KeyCode.Home     then CONFIG.ForceHit = not CONFIG.ForceHit; notify("ForceHit",  CONFIG.ForceHit and "✓ ON (агрессивно)" or "✗ OFF")
    elseif k == Enum.KeyCode.PageUp   then CONFIG.FOV = math.min(CONFIG.FOV+50,800); drawFOV.Radius=CONFIG.FOV; notify("FOV","= "..CONFIG.FOV)
    elseif k == Enum.KeyCode.PageDown then CONFIG.FOV = math.max(CONFIG.FOV-50,50);  drawFOV.Radius=CONFIG.FOV; notify("FOV","= "..CONFIG.FOV)
    end
end)
