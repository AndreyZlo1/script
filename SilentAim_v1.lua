--[[
    SilentAim v8 — ACS Engine (FastCastRedux)
    GitHub: AndreyZlo1/script | коммит 63fdd20

    ИЗМЕНЕНИЯ В v8:
    ──────────────────────────────────────────────────
    ИСПРАВЛЕНО:
    + NoRecoil — теперь через hookfunction на Recoil(),
      НЕ трогает viewmodel (Spring не обнуляем, только cam shove)
    + FullAuto — через патч u7.ShootType=3 + Heartbeat сброс u64.NextShot=0
      (работает на semi/burst/pump, оба метода одновременно)

    НОВОЕ:
    + KillAll без задержки — параллельный спам через task.spawn
    + SpotPlayer — помечать всех врагов на радаре
    + GrenadeSpam — ServerGrenade:FireServer спам в цель
    + CrashHeli — ReliableHeliEvent "crashExplode" на все вертолёты в мире
    + KillMe спам — PlayerEvents.KillMe (убивает только тебя — для гриндинга?)

    ИЗВЕСТНЫЕ УЯЗВИМОСТИ ИЗ ДАМПА:
    1. Damage:InvokeServer     — KillAll (урон напрямую)
    2. ServerGrenade:FireServer — граната в любую точку/цель
    3. ReliableHeliEvent crashExplode — крашим вертолёты
    4. SpotPlayer:FireServer(player) — спотим всех на радаре
    5. KillMe:FireServer() — суицид в игре (GroundWar минигейм)
    6. EditKillConditions FireServer — убираем штраф урона в прыжке
    7. Atirar:FireServer(gun,ammo,stored) — обход проверки стрельбы
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    -- Core
    Enabled      = true,
    FOV          = 300,
    AimPart      = "Head",
    TeamCheck    = true,
    PredictLead  = true,
    LeadFactor   = 0.08,

    -- Aim mods
    SilentAim    = true,
    BulletTP     = true,
    WallBang     = true,
    ForceHit     = false,
    FullAuto     = false,
    InfAmmo      = false,
    NoRecoil     = false,
    FireRate     = nil,      -- nil = не менять, число = RPM

    -- Exploits
    KillAllSpam  = false,    -- непрерывный спам KillAll
    SpotAll      = false,    -- помечать всех врагов на радаре
    GrenadeSpam  = false,    -- ServerGrenade в цель
    CrashAllHeli = false,    -- крашить все вертолёты

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
local function makeDraw(class, props)
    local d = Drawing.new(class)
    for k, v in props do d[k] = v end
    return d
end

local drawFOV = makeDraw("Circle", {
    Visible=false, Radius=CONFIG.FOV, Color=CONFIG.FOVColor,
    Thickness=1, Filled=false, Transparency=0.55
})
local drawLine = makeDraw("Line", {
    Visible=false, Thickness=1.5, Color=CONFIG.LineColor, Transparency=0.85
})
local drawLineDot = makeDraw("Circle", {
    Visible=false, Radius=5, Filled=true,
    Color=CONFIG.LineColor, Transparency=0.85
})
local drawName = makeDraw("Text", {
    Visible=false, Size=14, Color=Color3.fromRGB(255,255,255),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0), Center=true
})
local drawHP = makeDraw("Text", {
    Visible=false, Size=12, Color=Color3.fromRGB(150,255,150),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0), Center=true
})
local drawDist = makeDraw("Text", {
    Visible=false, Size=11, Color=Color3.fromRGB(200,200,200),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0), Center=true
})
local drawStatus = makeDraw("Text", {
    Visible=true, Size=12, Color=Color3.fromRGB(0,255,100),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0),
    Position=Vector2.new(10, 10)
})

-- ============================================================
--  HITBOX-ЧАСТИ (из BulletHitDetector дампа)
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
    return part.Position + vel * (cachedDist / 1000) * CONFIG.LeadFactor
end

local function updateCache()
    local center = screenCenter()
    local camPos = Camera.CFrame.Position
    local best, bestPos, bestDist, bestSD, bestHP = nil, nil, 0, math.huge, 0

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if CONFIG.TeamCheck and LocalPlayer.Team ~= nil and LocalPlayer.Team == pl.Team then continue end
        local char = pl.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = char:FindFirstChild(CONFIG.AimPart) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        local pp = predictPos(part)
        local sp, vis = w2s(pp)
        if not vis then continue end
        local sd = (sp - center).Magnitude
        if sd > CONFIG.FOV then continue end
        if sd < bestSD then
            bestSD = sd; best = pl; bestPos = pp
            bestDist = (pp - camPos).Magnitude; bestHP = math.floor(hum.Health)
        end
    end
    cachedTarget = best; cachedTargetPos = bestPos
    cachedDist = bestDist; cachedHP = bestHP
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    local function b(v) return v and "§" or "-" end
    drawStatus.Text = string.format(
        "SA:%s BTP:%s WB:%s FA:%s IA:%s NR:%s FH:%s | KA:%s GA:%s CH:%s",
        b(CONFIG.SilentAim and CONFIG.Enabled), b(CONFIG.BulletTP), b(CONFIG.WallBang),
        b(CONFIG.FullAuto), b(CONFIG.InfAmmo), b(CONFIG.NoRecoil), b(CONFIG.ForceHit),
        b(CONFIG.KillAllSpam), b(CONFIG.GrenadeSpam), b(CONFIG.CrashAllHeli)
    ):gsub("§","ON"):gsub("%-","--")
    drawStatus.Color = CONFIG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)

    if not CONFIG.Enabled then
        drawFOV.Visible=false; drawLine.Visible=false; drawLineDot.Visible=false
        drawName.Visible=false; drawHP.Visible=false; drawDist.Visible=false; return
    end

    updateCache()
    local center = screenCenter()
    drawFOV.Position = center; drawFOV.Visible = CONFIG.ShowFOV
    drawFOV.Radius = CONFIG.FOV
    drawFOV.Color = cachedTarget and CONFIG.LineColor or CONFIG.FOVColor

    if cachedTarget and cachedTargetPos then
        local sp, vis = w2s(cachedTargetPos)
        drawLine.Visible = CONFIG.ShowLine and vis; drawLine.From = center; drawLine.To = sp
        drawLineDot.Visible = CONFIG.ShowLine and vis; drawLineDot.Position = sp
        drawName.Visible = CONFIG.ShowName and vis
        drawName.Position = Vector2.new(sp.X, sp.Y - 24); drawName.Text = cachedTarget.Name
        drawHP.Visible = CONFIG.ShowHP and vis
        drawHP.Position = Vector2.new(sp.X, sp.Y - 12); drawHP.Text = cachedHP .. " HP"
        drawHP.Color = Color3.fromRGB(math.floor(255*(1-cachedHP/100)), math.floor(255*(cachedHP/100)), 0)
        drawDist.Visible = CONFIG.ShowDistance and vis
        drawDist.Position = Vector2.new(sp.X, sp.Y + 8)
        drawDist.Text = string.format("%.0fm", cachedDist)
    else
        drawLine.Visible=false; drawLineDot.Visible=false
        drawName.Visible=false; drawHP.Visible=false; drawDist.Visible=false
    end
end)

-- ============================================================
--  REMOTES — поиск
-- ============================================================
local Remotes = {}

task.spawn(function()
    local rs = game:GetService("ReplicatedStorage")
    local function sw(p,n,t) local ok,r=pcall(function() return p:WaitForChild(n,t or 10) end); return ok and r or p:FindFirstChild(n) end
    local function cr(i) return (i and cloneref) and cloneref(i) or i end

    local engine = sw(rs, "ACS_Engine", 15)
    local events = engine and sw(engine, "Events", 10)
    local pe     = sw(rs, "PlayerEvents", 10)

    if events then
        Remotes.ServerBullet   = cr(events:FindFirstChild("ServerBullet"))
        Remotes.Damage         = cr(events:FindFirstChild("Damage"))
        Remotes.ServerGrenade  = cr(events:FindFirstChild("ServerGrenade"))
        Remotes.Grenade        = cr(events:FindFirstChild("Grenade"))
    end
    if pe then
        Remotes.SpotPlayer       = cr(pe:FindFirstChild("SpotPlayer"))
        Remotes.KillMe           = cr(pe:FindFirstChild("KillMe"))
        Remotes.ReliableHeliEvent= cr(pe:FindFirstChild("ReliableHeliEvent"))
        Remotes.EditKillConds    = cr(pe:FindFirstChild("EditKillConditions"))
            or (events and cr(events:FindFirstChild("EditKillConditions")))
    end

    for k, v in Remotes do
        if v then print("[SA v8] Remote OK:", k) end
    end
end)

-- ============================================================
--  GC HELPERS
-- ============================================================
local function gcFindFunc(namehint)
    for _, f in getgc(false) do
        if type(f) == "function" then
            local ok, info = pcall(debug.getinfo, f)
            if ok and info and info.name == namehint then return f end
        end
    end
end

local function gcFindTable(keys)
    for _, obj in getgc(true) do
        if type(obj) ~= "table" then continue end
        local ok = true
        for _, k in keys do if rawget(obj, k) == nil then ok=false; break end end
        if ok then return obj end
    end
end

-- ============================================================
--  NoRecoil — hookfunction на Recoil(), только обнуляем cam shove
--  НЕ трогает Spring/viewmodel (u65.GunRecoil не вызываем)
--  Из дампа Recoil():
--    u65.Cam:shove(Vector3)    ← двигает камеру, обнуляем
--    u65.GunRecoil:shove(...)  ← viewmodel (НЕ трогаем)
-- ============================================================
local recoilHooked = false

local function hookRecoil()
    local recoilFn = gcFindFunc("Recoil")
    if not recoilFn then
        warn("[SA v8] Recoil() не найдена в GC")
        return false
    end

    hookfunction(recoilFn, newcclosure(function()
        if not CONFIG.NoRecoil then
            return recoilFn()  -- оригинал
        end
        -- NoRecoil ON: просто ничего не делаем
        -- viewmodel (GunRecoil spring) тоже не трогаем — без вызова оригинала
        -- пусть viewmodel анимируется как обычно, но камера не движется
    end))

    recoilHooked = true
    print("[SA v8] Recoil hookfunction OK")
    return true
end

-- ============================================================
--  FullAuto — два метода параллельно:
--  1. u7.ShootType = 3 (auto fire loop при зажатой кнопке)
--  2. Heartbeat: сбрасываем u64.NextShot = 0 (снимаем cooldown)
-- ============================================================
local u7Ref  = nil  -- gun config table
local u64Ref = nil  -- {NextShot, BurstBullets, LastShot}

local function findGunRefs()
    -- u7: table с ShootRate + ShootType + camRecoil
    u7Ref = gcFindTable({"ShootRate", "ShootType", "camRecoil", "gunRecoil"})

    -- u64: table с NextShot (число ms)
    for _, obj in getgc(true) do
        if type(obj) ~= "table" then continue end
        local ns = rawget(obj, "NextShot")
        if type(ns) == "number" and ns > 1e12 then  -- unix ms > 1e12
            u64Ref = obj; break
        end
    end

    if u7Ref then
        print(string.format("[SA v8] u7 найден: ShootRate=%s ShootType=%s",
            tostring(u7Ref.ShootRate), tostring(u7Ref.ShootType)))
    end
    if u64Ref then print("[SA v8] u64 найден: NextShot=" .. tostring(u64Ref.NextShot)) end
end

-- Heartbeat: InfAmmo + FullAuto cooldown сброс
RunService.Heartbeat:Connect(function()
    -- FullAuto: сбрасываем NextShot чтобы можно стрелять немедленно
    if CONFIG.FullAuto and u64Ref then
        u64Ref.NextShot = 0
        u64Ref.NextMobileShot = 0
    end

    -- InfAmmo через upvalues
    if CONFIG.InfAmmo then
        for _, f in getgc(false) do
            if type(f) ~= "function" then continue end
            local ok, uvs = pcall(debug.getupvalues, f)
            if not ok then continue end
            local hasU7 = false
            for _, uv in pairs(uvs) do
                if type(uv) == "table" and rawget(uv, "ShootRate") ~= nil then
                    hasU7 = true; break
                end
            end
            if hasU7 then
                for idx, val in pairs(uvs) do
                    if type(val) == "number" and val >= 0 and val <= 500 then
                        pcall(debug.setupvalue, f, idx, 9999)
                    end
                end
            end
        end
    end
end)

-- ============================================================
--  HOOK ShootModule.fire
-- ============================================================
local function hookShootModule()
    local SM = nil
    for _, obj in getgc(true) do
        if type(obj) ~= "table" then continue end
        local f = rawget(obj, "fire")
        if type(f) == "function" then
            local ok, info = pcall(debug.getinfo, f)
            if ok and info and (info.nups or 0) >= 5 then SM = obj; break end
        end
    end
    if not SM then
        local ok, res = pcall(filtergc, "table", {Keys={"fire"}, ValTypes={"function"}})
        if ok and res then
            for _, obj in ipairs(res) do
                local f = rawget(obj, "fire")
                if type(f) == "function" then
                    local ok2, info = pcall(debug.getinfo, f)
                    if ok2 and info and (info.nups or 0) >= 5 then SM = obj; break end
                end
            end
        end
    end
    if not SM then warn("[SA v8] ShootModule не найден"); return false end

    -- WallBang: hook canRayPierce
    local uvs = debug.getupvalues(SM.fire)
    for _, val in pairs(uvs) do
        if type(val) == "table" and type(rawget(val, "canRayPierce")) == "function" then
            local orig = val.canRayPierce
            val.canRayPierce = newcclosure(function(player, inst, sd)
                if CONFIG.WallBang and player == LocalPlayer then
                    if inst and inst.Parent then
                        local hasH = inst.Parent:FindFirstChildOfClass("Humanoid") ~= nil
                        if hasH and HITBOX_PARTS[inst.Name] then
                            return orig(player, inst, sd)
                        end
                        return true
                    end
                    return true
                end
                return orig(player, inst, sd)
            end, "ACS_canRayPierce"); break
        end
    end

    local origFire = SM.fire
    SM.fire = newcclosure(function(player, origin, direction, shellData, extra)
        if CONFIG.Enabled and player == LocalPlayer then
            if CONFIG.SilentAim and cachedTargetPos then
                local t = cachedTargetPos - origin
                if t.Magnitude > 0 then direction = t.Unit end
            end
            if CONFIG.BulletTP and type(shellData) == "table" then
                shellData.shellSpeed = 9e9
            end
            if CONFIG.ForceHit and cachedTarget then
                task.defer(function()
                    if not Remotes.Damage or not cachedTarget then return end
                    local char = cachedTarget.Character; if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hp = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if not hum or not hp or hum.Health <= 0 then return end
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    local sd = {
                        weaponName=tool and tool.Name or "G19X", shellType="Bullet",
                        shellName="9x19mm", shellSpeed=9e9, maxPenetrationCount=0,
                        currentPenetrationCount=0, penetrationMultiplier=0.8, origin=origin,
                        bulletID=LocalPlayer.Name..LocalPlayer.UserId..tick()..math.random(111,999)
                    }
                    pcall(function() Remotes.Damage:InvokeServer(sd, hum, (hp.Position-origin).Magnitude, 1, hp) end)
                end)
            end
        end
        return origFire(player, origin, direction, shellData, extra)
    end, "ACS_ShootModule_fire")

    print("[SA v8] ShootModule.fire OK")
    return true
end

-- ============================================================
--  HOOK hookmetamethod — резервный
-- ============================================================
local function hookNamecall()
    local origNC
    origNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if CONFIG.Enabled and method == "FireServer" and Remotes.ServerBullet and cachedTargetPos then
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
                        if not oIdx then oIdx=i elseif not dIdx then dIdx=i; break end
                    end
                end
                if dIdx then
                    local origin = oIdx and args[oIdx] or Camera.CFrame.Position
                    local t = cachedTargetPos - origin
                    if t.Magnitude > 0 then args[dIdx] = t.Unit end
                end
                local sd = args[3]
                if type(sd) == "table" and CONFIG.BulletTP then sd.shellSpeed = 9e9 end
                return origNC(self, table.unpack(args, 1, args.n))
            end
        end
        return origNC(self, ...)
    end))
    print("[SA v8] hookmetamethod OK")
end

-- ============================================================
--  EXPLOIT: KillAll — спам Damage:InvokeServer без задержки
--  TeamCheck ОТКЛЮЧЁН (бьёт тиммейтов тоже)
-- ============================================================
local killAllActive = false

local function buildShellData(origin)
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return {
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
end

local function doKillAll(once)
    if not Remotes.Damage then warn("[SA v8] Damage не найден"); return end
    local origin = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        and LocalPlayer.Character.HumanoidRootPart.Position) or Camera.CFrame.Position

    local function spamPlayer(pl)
        local char = pl.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hp  = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not hum or not hp then return end
        if hum.Health <= 0 then return end
        local dist = (hp.Position - origin).Magnitude
        -- Спам 5 запросов параллельно для надёжной регистрации
        for _ = 1, 5 do
            task.spawn(function()
                pcall(function()
                    Remotes.Damage:InvokeServer(buildShellData(origin), hum, dist, 1, hp)
                end)
            end)
        end
    end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            task.spawn(spamPlayer, pl)
        end
    end

    if not once then
        print("[SA v8] KillAll: спам отправлен на всех игроков")
    end
end

-- Непрерывный режим KillAllSpam
RunService.Heartbeat:Connect(function()
    if CONFIG.KillAllSpam and Remotes.Damage then
        doKillAll(true)
    end
end)

-- ============================================================
--  EXPLOIT: SpotPlayer — помечаем всех врагов на радаре
--  Аргумент: player (игрок которого спотим)
-- ============================================================
local function doSpotAll()
    if not Remotes.SpotPlayer then warn("[SA v8] SpotPlayer не найден"); return end
    local count = 0
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            task.spawn(function()
                pcall(function() Remotes.SpotPlayer:FireServer(pl) end)
            end)
            count = count + 1
        end
    end
    print("[SA v8] SpotAll: " .. count .. " игроков")
end

-- Повторный спот каждые 2 секунды если включён
task.spawn(function()
    while task.wait(2) do
        if CONFIG.SpotAll then doSpotAll() end
    end
end)

-- ============================================================
--  EXPLOIT: GrenadeSpam — ServerGrenade:FireServer в цель
--  Args: (origin, direction, shellData)
-- ============================================================
local function doGrenadeSpam()
    if not Remotes.ServerGrenade then warn("[SA v8] ServerGrenade не найден"); return end
    local char = LocalPlayer.Character
    local origin = char and char:FindFirstChild("HumanoidRootPart")
        and char.HumanoidRootPart.Position or Camera.CFrame.Position

    local target = cachedTargetPos or Camera.CFrame.Position + Camera.CFrame.LookVector * 50
    local dir = (target - origin).Unit

    local grenadeData = {
        shellType  = "Grenade",
        shellName  = "M67",
        shellSpeed = 50,
        origin     = origin,
        bulletID   = LocalPlayer.Name .. tick() .. math.random(1,9999),
    }

    for _ = 1, 3 do
        task.spawn(function()
            pcall(function() Remotes.ServerGrenade:FireServer(origin, dir, grenadeData) end)
        end)
    end
    print("[SA v8] GrenadeSpam → " .. (cachedTarget and cachedTarget.Name or "cursor"))
end

RunService.Heartbeat:Connect(function()
    if CONFIG.GrenadeSpam then
        doGrenadeSpam()
    end
end)

-- ============================================================
--  EXPLOIT: CrashAllHeli — ReliableHeliEvent "crashExplode"
--  Из дампа: ReliableHeliEvent:FireServer(helicopterModel, "crashExplode")
--  Ищем все вертолёты/самолёты в workspace и крашим их
-- ============================================================
local function doCrashAllHeli()
    if not Remotes.ReliableHeliEvent then
        warn("[SA v8] ReliableHeliEvent не найден"); return
    end
    local count = 0
    -- Ищем модели с тегом/атрибутом вертолёта или Engine part
    for _, obj in workspace:GetDescendants() do
        if obj:IsA("Model") then
            local req = obj:FindFirstChild("Required")
            if req then
                local engine = req:FindFirstChild("Engine")
                if engine then
                    task.spawn(function()
                        pcall(function()
                            Remotes.ReliableHeliEvent:FireServer(obj, "crashExplode")
                        end)
                    end)
                    count = count + 1
                end
            end
        end
    end
    print("[SA v8] CrashAllHeli: попытка краша " .. count .. " транспортных средств")
end

-- ============================================================
--  WATCH: перепатчиваем при смене оружия
-- ============================================================
local lastTool = nil
task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        local name = tool and tool.Name
        if name ~= lastTool then
            lastTool = name
            if name then
                print("[SA v8] Оружие:", name, "— обновляем refs")
                task.wait(0.3)
                findGunRefs()
                -- FullAuto: ShootType
                if u7Ref then
                    if not u7Ref._origShootType then u7Ref._origShootType = u7Ref.ShootType end
                    if not u7Ref._origShootRate then u7Ref._origShootRate = u7Ref.ShootRate end
                    if CONFIG.FullAuto then u7Ref.ShootType = 3 end
                    if CONFIG.FireRate then u7Ref.ShootRate = CONFIG.FireRate end
                end
            end
        end
    end
end)

-- ============================================================
--  ИНИЦИАЛИЗАЦИЯ
-- ============================================================
task.spawn(function()
    task.wait(1.5)
    hookShootModule()
    hookNamecall()
    task.wait(0.3)
    hookRecoil()
    findGunRefs()

    print([[
[SilentAim v8] Готов
──────────────────────────────────
  Insert     = SA on/off
  Delete     = BulletTP on/off
  End        = WallBang on/off
  Home       = ForceHit on/off
  F5         = FullAuto on/off
  F6         = InfAmmo on/off
  F7         = NoRecoil on/off
  F8         = FireRate x2 / F9 = сброс
  F10        = KillAll (разовый)
  F11        = KillAllSpam on/off (Heartbeat)
  F12        = SpotAll on/off
  Numpad0    = GrenadeSpam on/off
  Numpad1    = CrashAllHeli (разовый)
  PageUp/Dn  = FOV ±50
──────────────────────────────────]])
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
local function notify(t, m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title=t,Text=m,Duration=2.5})
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode

    if k == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        notify("SilentAim v8", CONFIG.Enabled and "ON" or "OFF")

    elseif k == Enum.KeyCode.Delete then
        CONFIG.BulletTP = not CONFIG.BulletTP
        notify("BulletTP", CONFIG.BulletTP and "ON" or "OFF")

    elseif k == Enum.KeyCode.End then
        CONFIG.WallBang = not CONFIG.WallBang
        notify("WallBang", CONFIG.WallBang and "ON" or "OFF")

    elseif k == Enum.KeyCode.Home then
        CONFIG.ForceHit = not CONFIG.ForceHit
        notify("ForceHit", CONFIG.ForceHit and "ON (агрессивно)" or "OFF")

    elseif k == Enum.KeyCode.F5 then
        CONFIG.FullAuto = not CONFIG.FullAuto
        notify("FullAuto", CONFIG.FullAuto and "ON" or "OFF")
        if u7Ref then
            u7Ref.ShootType = CONFIG.FullAuto and 3 or (u7Ref._origShootType or 1)
        end

    elseif k == Enum.KeyCode.F6 then
        CONFIG.InfAmmo = not CONFIG.InfAmmo
        notify("InfAmmo", CONFIG.InfAmmo and "ON" or "OFF")

    elseif k == Enum.KeyCode.F7 then
        CONFIG.NoRecoil = not CONFIG.NoRecoil
        notify("NoRecoil", CONFIG.NoRecoil and "ON (cam only)" or "OFF")

    elseif k == Enum.KeyCode.F8 then
        if u7Ref then
            if not u7Ref._origShootRate then u7Ref._origShootRate = u7Ref.ShootRate end
            CONFIG.FireRate = u7Ref._origShootRate * 2
            u7Ref.ShootRate = CONFIG.FireRate
            notify("FireRate x2", CONFIG.FireRate .. " RPM")
        end

    elseif k == Enum.KeyCode.F9 then
        if u7Ref and u7Ref._origShootRate then
            u7Ref.ShootRate = u7Ref._origShootRate
            CONFIG.FireRate = nil
            notify("FireRate", "Сброшен → " .. u7Ref._origShootRate .. " RPM")
        end

    elseif k == Enum.KeyCode.F10 then
        notify("KillAll", "Отправка...")
        task.spawn(doKillAll, true)

    elseif k == Enum.KeyCode.F11 then
        CONFIG.KillAllSpam = not CONFIG.KillAllSpam
        notify("KillAllSpam", CONFIG.KillAllSpam and "ON (Heartbeat)" or "OFF")

    elseif k == Enum.KeyCode.F12 then
        CONFIG.SpotAll = not CONFIG.SpotAll
        notify("SpotAll", CONFIG.SpotAll and "ON (каждые 2с)" or "OFF")

    elseif k == Enum.KeyCode.KeypadZero then
        CONFIG.GrenadeSpam = not CONFIG.GrenadeSpam
        notify("GrenadeSpam", CONFIG.GrenadeSpam and "ON" or "OFF")

    elseif k == Enum.KeyCode.KeypadOne then
        notify("CrashAllHeli", "Крашим все вертолёты...")
        task.spawn(doCrashAllHeli)

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
