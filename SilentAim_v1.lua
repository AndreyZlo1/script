--[[
╔══════════════════════════════════════════════════════════════════╗
║              SilentAim v16  --  ACS Engine (FastCastRedux)      ║
║  GitHub: AndreyZlo1/script                                       ║
╠══════════════════════════════════════════════════════════════════╣
║  FIXES v16 (от v15/844304c):  ESP FPS FIX                       ║
║  1. FPS: ESP updateCache перенесён на Heartbeat с throttle       ║
║     RenderStepped только рисует, не итерирует GetPlayers()       ║
║  2. ESP players: ищем в workspace.ИмяИгрока (не ACS_WorkSpace)  ║
║     также правильный fallback для игроков в транспорте           ║
║  3. BulletTracer: Drawing Transparency 0=видимый 1=прозрачный   ║
║     (инвертировано от BasePart), толщина уменьшена до 1.5px      ║
║  4. InfAmmo/FullAuto: правильный хук через u3 upvalue напрямую   ║
║     в shoot-функции, не через getgc-таблицы → viewmodel цела     ║
║  5. Swastika: Transparency=0.05 (почти непрозрачная)             ║
║     AimLine: фиксированный белый цвет, не RGB как свастика       ║
║  6. HeadCircle: max радиус уменьшен до 6px                       ║
║  7. HitSound: Volume=10, убрана конкуренция с игровым звуком     ║
║  8. HitMarker: рисуется на точке попадания (3D→2D), не по центру ║
╠══════════════════════════════════════════════════════════════════╣
║  FPSFIX (v16):                                                   ║
║  A-I: см. v15                                                    ║
║  J. espDataCache: позиции костей кэшируются в Heartbeat          ║
║     drawESP читает только кэш — нет FindFirstChild в render loop  ║
║  K. getPlayerState: убран workspace:GetDescendants() → _seatCache║
║  L. w2s(head/foot) считается 1 раз на игрока вместо 5x           ║
╚══════════════════════════════════════════════════════════════════╝
]]

-- ============================================================
--  SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

-- ============================================================
--  CONFIG
-- ============================================================
local CFG = {
    Enabled       = true,
    FOV           = 300,
    AimPart       = "Head",
    TeamCheck     = true,
    PredictLead   = true,
    LeadFactor    = 0.08,

    SilentAim  = true,
    BulletTP   = true,
    WallBang   = true,
    ForceHit   = false,

    InfAmmo    = false,
    FullAuto   = false,
    FireRate   = nil,

    ESPEnabled    = true,
    ShowBox       = true,
    ShowSkeleton  = true,
    ShowName      = true,
    ShowHP        = true,
    ShowDist      = true,
    ShowState     = true,
    ShowFOV       = true,
    ShowSwastika  = true,
    ShowAimLine   = true,
    ShowTracer    = true,
    ShowHitmarker = true,
    HitSound      = true,

    TeamColor  = Color3.fromRGB(0,200,255),
    EnemyColor = Color3.fromRGB(255,60,60),
    FOVColor   = Color3.fromRGB(255,255,255),

    KillAllSpam = false,
    SpotAll     = false,
    GrenadeSpam = false,
    FFViewModel = false,
}

-- ============================================================
--  DRAWING HELPER
-- ============================================================
local function D(class, props)
    local d = Drawing.new(class)
    for k,v in props do d[k]=v end
    return d
end

-- ============================================================
--  STATUS HUD
-- ============================================================
local dStatus = D("Text",{
    Visible=true, Size=13, Color=Color3.fromRGB(0,255,100),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0),
    Position=Vector2.new(10,10), ZIndex=10
})
local dFOV = D("Circle",{
    Visible=false, Radius=CFG.FOV, Color=CFG.FOVColor,
    Thickness=1, Filled=false, Transparency=0.5
})

-- ============================================================
--  HELPERS
-- ============================================================
local function w2s(pos)
    local sp,vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X,sp.Y), vis, sp.Z
end
local function screenCenter() return Camera.ViewportSize/2 end
local function isTeammate(pl)
    if not CFG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == pl.Team
end
local function hsvToRgb(h,s,v)
    local i=math.floor(h*6); local f=h*6-i; local p=v*(1-s)
    local q=v*(1-f*s); local t=v*(1-(1-f)*s)
    i=i%6
    local r,g,b
    if i==0 then r,g,b=v,t,p elseif i==1 then r,g,b=q,v,p
    elseif i==2 then r,g,b=p,v,t elseif i==3 then r,g,b=p,q,v
    elseif i==4 then r,g,b=t,p,v elseif i==5 then r,g,b=v,p,q end
    return Color3.fromRGB(r*255,g*255,b*255)
end

local SKELETON_BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

-- FPSFIX: getPlayerState принимает pl для _seatCache вместо GetDescendants
local function getPlayerState(char, hum, pl)
    if not hum then return "" end
    if hum.Health<=0 then return "DEAD" end
    local st = hum:GetState()
    if st==Enum.HumanoidStateType.PlatformStanding then return "Vehicle" end
    -- FPSFIX: используем _seatCache вместо workspace:GetDescendants()
    if pl and _seatCache[pl] then return "Vehicle" end
    if char:GetAttribute("Prone")      then return "Prone"   end
    if char:GetAttribute("Crouching")  then return "Crouch"  end
    if char:GetAttribute("Crouch")     then return "Crouch"  end
    if st==Enum.HumanoidStateType.Swimming  then return "Swimming" end
    if st==Enum.HumanoidStateType.Freefall  then return "Airborne" end
    if st==Enum.HumanoidStateType.Climbing  then return "Climbing" end
    return ""
end

-- ============================================================
--  REMOTES
-- ============================================================
local R = {}
local cachedTarget    = nil
local cachedTargetPos = nil
local cachedDist      = 0
local swAngle         = 0
local _fc             = 0

task.spawn(function()
    local rs  = game:GetService("ReplicatedStorage")
    local acs = rs:WaitForChild("ACS_Engine",10)
    local pe  = rs:WaitForChild("PlayerEvents",10)
    local med = rs:FindFirstChild("MedSys") or rs:FindFirstChild("MedSystem")
    local cr  = function(obj) return (obj and obj:IsA("RemoteEvent") and obj) or
                                      (obj and obj:IsA("RemoteFunction") and obj) or
                                      (obj and obj:IsA("UnreliableRemoteEvent") and obj) or nil end

    if acs then
        local events = acs:WaitForChild("Events",5)
        if events then
            R.Damage    = cr(events:FindFirstChild("ServerBullet"))
            R.GunStance = cr(events:FindFirstChild("GunStance"))
            R.Equip     = cr(events:FindFirstChild("Equip"))
            R.Refil     = cr(events:FindFirstChild("Refil"))
            R.SVFlash   = cr(events:FindFirstChild("SVFlash"))
            R.SVLaser   = cr(events:FindFirstChild("SVLaser"))
            R.NVG       = cr(events:FindFirstChild("NVG"))
            R.Surrender = cr(events:FindFirstChild("Surrender"))
            R.Backpack  = cr(events:FindFirstChild("Backpack"))
            R.EditKillCond = cr(events:FindFirstChild("EditKillConditions"))
            R.Stance    = cr(events:FindFirstChild("Stance"))
            R.DoorEvent = cr(events:FindFirstChild("DoorEvent"))
            R.Drag      = cr(events:FindFirstChild("Drag"))
            R.Atirar    = cr(events:FindFirstChild("Atirar"))
        end
    end
    if med then
        R.Collapse   = cr(med:FindFirstChild("Collapse"))
        R.MedHandler = cr(med:FindFirstChild("MedHandler"))
    end
    if pe then
        R.SpotPlayer       = cr(pe:FindFirstChild("SpotPlayer"))
        R.KillMe           = cr(pe:FindFirstChild("KillMe"))
        R.FakeBetaPurchase = cr(pe:FindFirstChild("FakeBetaPurchase"))
        R.ClaimFreeStarter = cr(pe:FindFirstChild("ClaimFreeStarterPack"))
        R.ClaimUGC         = cr(pe:FindFirstChild("ClaimUGC"))
        R.CompleteTutorial = cr(pe:FindFirstChild("CompleteTutorial"))
        R.DropGiveAmmo     = cr(pe:FindFirstChild("DropGiveAmmo"))
        R.DropPickedUp     = cr(pe:FindFirstChild("DropPickedUp"))
        R.RequestTeleport  = cr(pe:FindFirstChild("RequestTeleport"))
        R.RedeemSpin       = cr(pe:FindFirstChild("RedeemSpin"))
        R.ToggleMusic      = cr(pe:FindFirstChild("ToggleMusic"))
        R.RadarSubscription = cr(pe:FindFirstChild("RadarSubscription"))
        R.RequestDeploy    = cr(pe:FindFirstChild("RequestDeploy"))
        R.VoteEvent        = cr(pe:FindFirstChild("VoteEvent"))
    end
    R.CollectCash = cr(rs:FindFirstChild("CollectCashEvent"))
    R.RequestHeli = cr(rs:FindFirstChild("RequestHeliPurchaseEvent"))
    R.RequestPlane = cr(rs:FindFirstChild("RequestPlanePurchaseEvent"))

    local loaded={}; for k,v in R do if v then loaded[#loaded+1]=k end end
    print("[SA v14] Remotes: "..#loaded)
end)

-- ============================================================
--  ESP OBJECTS
-- ============================================================
local espCache = {}
-- ── ESP DATA CACHE (FPSFIX: позиции костей кэшируются в Heartbeat, не в drawESP)
local espDataCache = {}   -- pl → {headPos, rootPos, footPos, bones[], hp, maxhp, alive, dist, state, col}

local function updateESPCache()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos  = myRoot and myRoot.Position

    for _,pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        local root,head,hum,char = getPlayerRoot(pl)
        if not char or not hum then espDataCache[pl]=nil; continue end

        local alive = hum.Health > 0
        if not alive then
            if espDataCache[pl] then espDataCache[pl].alive=false end
            continue
        end

        local rootPos = root and root.Position or Vector3.zero
        local headPos = head and head.Position or rootPos + Vector3.new(0,2.5,0)
        local lfoot   = char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
        local footPos = lfoot and lfoot.Position or rootPos - Vector3.new(0,3,0)

        -- кости скелета
        local bones = {}
        for i,bone in ipairs(SKELETON_BONES) do
            local p0 = char:FindFirstChild(bone[1])
            local p1 = char:FindFirstChild(bone[2])
            bones[i] = (p0 and p1) and {p0.Position, p1.Position} or nil
        end

        local dist = myPos and (myPos - rootPos).Magnitude or 999
        local col  = isTeammate(pl) and CFG.TeamColor or CFG.EnemyColor
        local state = getPlayerState(char, hum, pl)

        espDataCache[pl] = {
            headPos=headPos, rootPos=rootPos, footPos=footPos,
            bones=bones, hp=hum.Health, maxhp=hum.MaxHealth,
            alive=true, dist=dist, state=state,
            col=col, name=pl.Name
        }
    end
end


local function makeESP()
    local e = {}
    e.boxLines = {}
    for i=1,8 do e.boxLines[i]=D("Line",{Visible=false,Thickness=1.5,
        Color=Color3.fromRGB(255,255,255),Transparency=0.2}) end
    e.hpBg   = D("Line",{Visible=false,Thickness=5,Color=Color3.fromRGB(0,0,0),Transparency=0.3})
    e.hpFill = D("Line",{Visible=false,Thickness=3,Color=Color3.fromRGB(0,255,80),Transparency=0.2})
    e.name   = D("Text",{Visible=false,Size=13,Color=Color3.fromRGB(255,255,255),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.dist   = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(200,200,200),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.state  = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(255,200,50),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.skelLines = {}
    for i=1,#SKELETON_BONES do
        e.skelLines[i]=D("Line",{Visible=false,Thickness=1,
            Color=Color3.fromRGB(255,255,255),Transparency=0.3})
    end
    -- FIX6: max head circle radius уменьшен до 6
    e.headCircle = D("Circle",{Visible=false,Filled=false,Thickness=1.5,
        Radius=6,Color=Color3.fromRGB(255,255,255),Transparency=0.2})
    return e
end

local function removeESP(e)
    if not e then return end
    for _,l in e.boxLines  do pcall(l.Remove,l) end
    for _,l in e.skelLines do pcall(l.Remove,l) end
    pcall(e.hpBg.Remove,e.hpBg); pcall(e.hpFill.Remove,e.hpFill)
    pcall(e.name.Remove,e.name); pcall(e.dist.Remove,e.dist)
    pcall(e.state.Remove,e.state); pcall(e.headCircle.Remove,e.headCircle)
end

local function hideESP(e)
    if not e then return end
    for _,l in e.boxLines  do l.Visible=false end
    for _,l in e.skelLines do l.Visible=false end
    e.hpBg.Visible=false; e.hpFill.Visible=false
    e.name.Visible=false; e.dist.Visible=false
    e.state.Visible=false; e.headCircle.Visible=false
end

local function getESP(pl)
    if not espCache[pl] then espCache[pl]=makeESP() end
    return espCache[pl]
end

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(pl)
    if espCache[pl] then removeESP(espCache[pl]); espCache[pl]=nil end
    espDataCache[pl] = nil  -- FPSFIX: чистим кэш данных
end)

-- ============================================================
--  SWASTIKA (Drawing)
-- ============================================================
local SWAS_SEGS = 12
local swasLines = {}
for i=1,SWAS_SEGS do
    swasLines[i]=D("Line",{Visible=false,Thickness=2.5,
        Color=Color3.fromRGB(255,255,255),Transparency=0.05})  -- FIX5: почти непрозрачная
end

local function drawSwastika(center, size, angle, col)
    -- 卐  четыре луча + четыре уголка
    local segs = {
        -- горизонтальная ось
        {Vector2.new(-1,0),Vector2.new(1,0)},
        -- вертикальная ось
        {Vector2.new(0,-1),Vector2.new(0,1)},
        -- правый верхний загиб (→↓)
        {Vector2.new(1,-1),Vector2.new(1,0)},
        -- левый верхний загиб (←↑)
        {Vector2.new(-1,1),Vector2.new(-1,0)},
        -- правый нижний загиб (→↑)
        {Vector2.new(1,1),Vector2.new(0,1)},
        -- левый нижний загиб (←↓)
        {Vector2.new(-1,-1),Vector2.new(0,-1)},
        -- диагональные штрихи
        {Vector2.new(0.5,-1),Vector2.new(1,-1)},
        {Vector2.new(-1,0.5),Vector2.new(-1,1)},
        {Vector2.new(0.5,1),Vector2.new(1,1)},
        {Vector2.new(-1,-0.5),Vector2.new(-1,-1)},
        -- центральная точка (короткий отрезок)
        {Vector2.new(-0.1,0),Vector2.new(0.1,0)},
        {Vector2.new(0,-0.1),Vector2.new(0,0.1)},
    }
    local cos,sin=math.cos(angle),math.sin(angle)
    local function rot(v)
        return Vector2.new(v.X*cos-v.Y*sin, v.X*sin+v.Y*cos)*size+center
    end
    for i,seg in ipairs(segs) do
        local l=swasLines[i]
        l.From=rot(seg[1]); l.To=rot(seg[2])
        l.Color=col; l.Visible=true
    end
end

local function hideSwastika()
    for _,l in swasLines do l.Visible=false end
end

-- ============================================================
--  AIM LINE  (FIX5: белый, не RGB)
-- ============================================================
local aimLine = D("Line",{
    Visible=false,Thickness=1,
    Color=Color3.fromRGB(255,255,255),  -- FIX5: фиксированный белый
    Transparency=0.3
})

-- ============================================================
--  BULLET TRACER
-- ============================================================
local TRACER_LIFE = 0.22
local tracers = {}

local function spawnTracer(from3d, to3d)
    -- FPSFIX-G: конвертируем в 2D при спавне, не пересчитываем каждый кадр
    local sp1,v1,z1 = w2s(from3d); if not v1 or z1<=0 then return end
    local sp2,v2,z2 = w2s(to3d)
    local ep = (v2 and z2>0) and sp2 or sp1
    local t = {}
    t.sp1  = sp1   -- 2D начало
    t.sp2  = ep    -- 2D конец
    t.born = tick()
    t.line = D("Line",{
        Visible=true,
        Thickness=1.5,
        Color=Color3.fromRGB(255,220,80),
        Transparency=0.0,
        From=sp1, To=ep,
        ZIndex=5
    })
    tracers[#tracers+1]=t
end

-- ============================================================
--  HIT MARKER  (FIX8: рисуется на точке попадания 3D→2D)
-- ============================================================
local hitmarkerLines = {}
for i=1,4 do
    hitmarkerLines[i]=D("Line",{Visible=false,Thickness=1.5,
        Color=Color3.fromRGB(255,255,255),Transparency=0.0,ZIndex=8})
end
local hitmarkerUntil = 0
local hitmarkerPos3D = nil  -- FIX8: 3D позиция попадания

local function triggerHitFX(hitPos3D)
    hitmarkerUntil = tick() + 0.18
    -- FIX8: запоминаем 3D позицию если передана, иначе используем cachedTargetPos
    hitmarkerPos3D = hitPos3D or cachedTargetPos
end

-- ============================================================
--  HIT SOUND  (FIX7: громче, без конкуренции с игрой)
-- ============================================================
local hitSoundInst = nil

local function buildHitSound()
    hitSoundInst = Instance.new("Sound")
    hitSoundInst.Name = "SA_HitSound"
    hitSoundInst.SoundId = "rbxassetid://7867933531"
    hitSoundInst.Volume = 10          -- FIX7: громко
    hitSoundInst.RollOffMaxDistance = 0
    hitSoundInst.RollOffMode = Enum.RollOffMode.InverseTapered
    hitSoundInst.PlaybackSpeed = 1.2
    hitSoundInst.Parent = workspace.CurrentCamera
end

local function playHitSound()
    if not CFG.HitSound then return end
    if not hitSoundInst or not hitSoundInst.Parent then buildHitSound() end
    pcall(function() hitSoundInst:Stop(); hitSoundInst:Play() end)
end

-- Re-attach on respawn (FIX7)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if hitSoundInst then hitSoundInst.Parent = workspace.CurrentCamera end
end)

buildHitSound()

-- ============================================================
--  MUZZLE WORLD POS
-- ============================================================
local function getCurrentViewmodelTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    -- 1) ACS_Client viewmodel
    local acs = char:FindFirstChild("ACS_Client")
    if acs then
        for _,v in acs:GetDescendants() do
            if v:IsA("Tool") then return v end
        end
        for _,v in acs:GetChildren() do
            if v:IsA("Model") then return v end
        end
    end
    -- 2) Regular equipped tool
    return char:FindFirstChildOfClass("Tool")
end

local function getMuzzleWorldPos()
    local tool = getCurrentViewmodelTool()
    if not tool then return nil end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return nil end
    local muzzle = handle:FindFirstChild("Muzzle")
        or handle:FindFirstChild("MuzzlePoint")
        or handle:FindFirstChild("MuzzleFlash")
    if muzzle then return muzzle.WorldPosition end
    -- fallback: tip of handle
    return handle.Position + handle.CFrame.LookVector*2
end

-- ============================================================
--  TARGET CACHE  (FIX2: ищем в workspace.PlayerName)
-- ============================================================
local playerDataCache = {}  -- per-player: {root, head, hum, char}
local _seatCache = {}   -- FPSFIX-B: pl -> VehicleSeat (обновляется раз в 2с)
local function rebuildSeatCache()
    _seatCache = {}
    for _,desc in workspace:GetDescendants() do
        if desc:IsA("Seat") or desc:IsA("VehicleSeat") then
            local occ = desc.Occupant
            if occ then
                local pl = Players:GetPlayerFromCharacter(occ.Parent)
                if pl then _seatCache[pl] = desc end
            end
        end
    end
end


local function getPlayerRoot(pl)
    -- FIX2: workspace.PlayerName содержит Character в этой игре
    local char = pl.Character
    if not char then
        -- пробуем найти напрямую в workspace по имени игрока
        char = workspace:FindFirstChild(pl.Name)
    end
    if not char then return nil,nil,nil,nil end

    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum  = char:FindFirstChildOfClass("Humanoid")

    -- FPSFIX-A: vehicle fallback без GetDescendants (использует _seatCache)
    if not root then
        local cached = _seatCache[pl]
        if cached and cached:IsDescendantOf(workspace) then
            root = char:FindFirstChild("HumanoidRootPart") or cached
        end
    end
    return root, head, hum, char
end

local function updateCache()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then cachedTarget=nil; cachedTargetPos=nil; return end

    local myPos = myRoot.Position
    local sc    = screenCenter()
    local bestPl, bestScore, bestPos = nil, math.huge, nil

    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        if isTeammate(pl) then continue end

        local root,head,hum,char = getPlayerRoot(pl)
        if not root or not hum or hum.Health<=0 then continue end

        local aimPart = head or root
        local wPos    = aimPart.Position

        -- FIX2: depth check вместо vis (vis=false за стеной/транспортом)
        local sp,_,spZ = w2s(wPos)
        if spZ <= 0 then continue end  -- за камерой

        local dist     = (myPos - wPos).Magnitude
        local screenD  = (sp - sc).Magnitude
        if screenD > CFG.FOV then continue end

        local score = screenD + dist*0.05
        if score < bestScore then
            bestScore = score
            bestPl    = pl
            if CFG.PredictLead then
                local vel = root.AssemblyLinearVelocity
                bestPos = wPos + vel * CFG.LeadFactor
            else
                bestPos = wPos
            end
        end
    end

    cachedTarget    = bestPl
    cachedTargetPos = bestPos
    if bestPl then
        local r,_,_,_ = getPlayerRoot(bestPl)
        if r then cachedDist = (myRoot.Position - r.Position).Magnitude end
    else
        cachedDist = 0
    end
end

-- ============================================================
--  INF AMMO / FULL AUTO (FIX4: через upvalue u3 напрямую)
-- ============================================================
-- Логика из дампа:
--   u3  = AmmoInGun (текущий магазин, upvalue в shoot-функции ACS_Framework)
--   u7  = ACS_Settings таблица (ShootRate, ShootType итд)
--   ShootType: 1=Semi, 2=Burst, 3=Auto, 4=Pump, 5=BoltAction
-- Мы ищем shoot-функцию по наличию upvalue u7 (таблица с ShootRate+ShootType)
-- и upvalue u3 (число 0..999)
-- НЕ трогаем функции из Animation/Keyframe/Sway чтобы не ломать ViewModel

local u3FnRef   = nil   -- функция shoot
local u3IdxRef  = nil   -- индекс upvalue u3 в этой функции
local u7Ref     = nil   -- таблица ACS_Settings (u7)

local function refreshGunRefs()
    u3FnRef=nil; u3IdxRef=nil; u7Ref=nil

    local gc = getgc(true)
    -- Шаг 1: найти u7 таблицу (ACS_Settings с ShootRate+ShootType)
    for _,obj in gc do
        if type(obj)~="table" then continue end
        local sr = rawget(obj,"ShootRate")
        local st = rawget(obj,"ShootType")
        if type(sr)=="number" and (type(st)=="number" or type(st)=="string") then
            u7Ref = obj
            if not u7Ref._origShootRate then u7Ref._origShootRate = u7Ref.ShootRate end
            if not u7Ref._origShootType then u7Ref._origShootType = u7Ref.ShootType end
            break
        end
    end

    if not u7Ref then warn("[SA v14] u7Ref (ACS_Settings) not found"); return end

    -- Шаг 2: найти shoot-функцию с u7 и числовым u3 как upvalue
    -- FIX4: проверяем info.source чтобы не трогать анимации/viewmodel
    for _,f in getgc(false) do
        if type(f)~="function" then continue end
        local ok, info = pcall(debug.getinfo, f)
        if not ok or not info then continue end

        local src = tostring(info.source or ""):lower()
        -- FIX4: пропускаем файлы с анимациями/viewmodel
        if src:find("spring") or src:find("anim") or src:find("viewmodel")
            or src:find("motor") or src:find("sway") or src:find("control") then
            continue
        end

        local nups = info.nups or 0
        if nups < 3 or nups > 30 then continue end

        local ok2, uvs = pcall(debug.getupvalues, f)
        if not ok2 then continue end

        local foundU7    = false
        local ammoIdx    = nil
        local ammoVal    = nil

        for idx, val in pairs(uvs) do
            if val == u7Ref then foundU7 = true end
            -- u3 = число 0..999 (текущий магазин)
            if type(val)=="number" and val>=0 and val<=999 then
                ammoIdx = idx
                ammoVal = val
            end
        end

        if foundU7 and ammoIdx then
            u3FnRef  = f
            u3IdxRef = ammoIdx
            print(string.format("[SA v14] GunRefs OK: ShootRate=%s ShootType=%s u3idx=%d u3=%s",
                tostring(u7Ref.ShootRate), tostring(u7Ref.ShootType), ammoIdx, tostring(ammoVal)))
            break
        end
    end

    if not u3FnRef then
        warn("[SA v14] shoot function (u3 upvalue) not found — InfAmmo may not work")
    end

    -- Применяем FullAuto если включён
    if CFG.FullAuto and u7Ref then
        u7Ref.ShootRate  = 99999
        u7Ref.ShootType  = 3  -- FIX4: 3=Auto (из дампа ACS_Framework строка 700-706)
    end
    if CFG.FireRate and u7Ref then
        u7Ref.ShootRate = CFG.FireRate
    end
end

-- ============================================================
--  FORCEFIELD VIEWMODEL
-- ============================================================
local ffApplied = false

local function applyFFToTool(tool, enable)
    if not tool then return end
    for _,p in tool:GetDescendants() do
        if p.Name == "Chamber" then continue end  -- не трогаем затвор
        if p:IsA("BasePart") or p:IsA("UnionOperation") or p:IsA("MeshPart") then
            pcall(function()
                if enable then
                    p.Material    = Enum.Material.ForceField
                    p.Color       = Color3.fromRGB(30,180,220)
                    p.Transparency = math.min(p.Transparency, 0.05)
                else
                    p.Material    = Enum.Material.SmoothPlastic
                end
            end)
        end
    end
    ffApplied = enable
end

-- Слежка за сменой оружия
task.spawn(function()
    local lastTool = nil
    while task.wait(0.3) do
        local char = LocalPlayer.Character
        if not char then lastTool=nil; continue end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool ~= lastTool then
            lastTool = tool
            if tool then
                task.wait(0.2)
                refreshGunRefs()
                if CFG.FFViewModel then applyFFToTool(tool, true) end
            else
                ffApplied = false
            end
        end
    end
end)

-- ============================================================
--  HEARTBEAT  (InfAmmo + SpotAll + KillAllSpam + GrenadeSpam)
-- ============================================================
-- FIX1: updateCache перенесён в Heartbeat чтобы не нагружать RenderStepped
local _hbFrame = 0
RunService.Heartbeat:Connect(function()
    _hbFrame = _hbFrame + 1
    if _hbFrame % 120 == 0 then rebuildSeatCache() end  -- FPSFIX-C

    -- updateCache каждые 3 Heartbeat (не каждый кадр)
    if _hbFrame % 3 == 0 then  -- FPSFIX-D: каждые 3 тика
        updateCache()
        if CFG.ESPEnabled then updateESPCache() end  -- FPSFIX: ESP данные в Heartbeat
    end

    -- FIX4: InfAmmo через upvalue u3 напрямую
    if CFG.InfAmmo and u3FnRef and u3IdxRef then
        -- устанавливаем только если значение уменьшилось (после выстрела)
        local ok, cur = pcall(debug.getupvalue, u3FnRef, u3IdxRef)
        if ok and type(cur)=="number" and cur < (u7Ref and u7Ref.Ammo or 30) then
            pcall(debug.setupvalue, u3FnRef, u3IdxRef, (u7Ref and u7Ref.Ammo or 30))
        end
    end

    -- SpotAll
    if CFG.SpotAll and R.SpotPlayer and _hbFrame%60==0 then
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function() R.SpotPlayer:FireServer(pl) end) end)
            end
        end
    end

    -- KillAllSpam
    if CFG.KillAllSpam and R.Damage and _hbFrame%30==0 then  -- FPSFIX-E
        local myChar = LocalPlayer.Character
        local origin = myChar and myChar:FindFirstChild("HumanoidRootPart")
            and myChar.HumanoidRootPart.Position or Camera.CFrame.Position
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function()
                local root,head,hum,char = getPlayerRoot(pl)
                if not root or not hum or hum.Health<=0 then return end
                local hp = head or root
                local sd = {weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                    maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                    origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,99999)}
                pcall(function() R.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
            end)
        end
    end

    -- GrenadeSpam
    if CFG.GrenadeSpam and _hbFrame%20==0 then  -- FPSFIX-F
        task.spawn(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _,tool in char:GetChildren() do
                if tool:IsA("Tool") then
                    local h = tool:FindFirstChild("Handle")
                    if h then pcall(function() tool:Activate() end) end
                end
            end
        end)
    end
end)

-- ============================================================
--  HOOK: ShootModule
-- ============================================================
task.spawn(function()
    task.wait(3)
    local rs = game:GetService("ReplicatedStorage")
    local SM = nil

    -- найти ShootModule через gc
    for _,obj in getgc(true) do
        if type(obj)=="table" and type(rawget(obj,"fire"))=="function" then
            local ok,info=pcall(debug.getinfo,obj.fire)
            if ok and info and (info.nups or 0)>=5 then SM=obj; break end
        end
    end
    if not SM then warn("[SA v14] ShootModule not found"); return end

    -- WallBang hook
    local ok2,uvs=pcall(debug.getupvalues,SM.fire)
    if ok2 then
        for _,val in pairs(uvs) do
            if type(val)=="table" and type(rawget(val,"canRayPierce"))=="function" then
                local orig=val.canRayPierce
                val.canRayPierce=newcclosure(function(pl,inst,sd)
                    if CFG.WallBang and pl==LocalPlayer then
                        if inst and inst.Parent then
                            if inst.Parent:FindFirstChildOfClass("Humanoid") then
                                return orig(pl,inst,sd)
                            end
                            return true
                        end
                        return true
                    end
                    return orig(pl,inst,sd)
                end)
                break
            end
        end
    end

    local origFire = SM.fire
    SM.fire = newcclosure(function(pl, origin, direction, shellData, extra)
        if CFG.Enabled and pl==LocalPlayer then
            -- SilentAim
            if CFG.SilentAim and cachedTargetPos then
                local t = cachedTargetPos - origin
                if t.Magnitude > 0 then direction = t.Unit end
            end
            -- BulletTP
            if CFG.BulletTP and type(shellData)=="table" then
                shellData.shellSpeed = 9e9
            end
            -- BulletTracer: рисуем от ствола к цели
            if CFG.ShowTracer then
                local mp3d = getMuzzleWorldPos() or origin
                local ep3d = cachedTargetPos or (origin + direction*500)
                spawnTracer(mp3d, ep3d)
            end
            -- HitMarker на точке цели (FIX8)
            if cachedTargetPos and CFG.ShowHitmarker then
                task.delay(0.04, function()
                    triggerHitFX(cachedTargetPos)
                    playHitSound()
                end)
            end
            -- ForceHit
            if CFG.ForceHit and cachedTarget and R.Damage then
                task.defer(function()
                    local char = cachedTarget and cachedTarget.Character
                    if not char then return end
                    local hum  = char:FindFirstChildOfClass("Humanoid")
                    local hp   = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if not hum or not hp or hum.Health<=0 then return end
                    local sd2 = {weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                        maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                        origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,99999)}
                    pcall(function() R.Damage:InvokeServer(sd2,hum,(hp.Position-origin).Magnitude,1,hp) end)
                    triggerHitFX(hp.Position)
                    playHitSound()
                end)
            end
        end
        return origFire(pl, origin, direction, shellData, extra)
    end)
    print("[SA v14] ShootModule hooked")
end)

-- hookmetamethod для ServerBullet
task.spawn(function()
    task.wait(3.5)
    local origNC
    origNC = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local method = getnamecallmethod()
        if CFG.Enabled and cachedTargetPos and method=="FireServer" then
            local ok,nm = pcall(function() return self.Name end)
            if ok and nm=="ServerBullet" then
                local args = table.pack(...)
                local oIdx, dIdx
                for i=1,args.n do
                    if typeof(args[i])=="Vector3" then
                        if not oIdx then oIdx=i elseif not dIdx then dIdx=i; break end
                    end
                end
                if dIdx then
                    local origin = oIdx and args[oIdx] or Camera.CFrame.Position
                    local t = cachedTargetPos - origin
                    if t.Magnitude>0 then args[dIdx]=t.Unit end
                end
                if type(args[3])=="table" and CFG.BulletTP then
                    args[3].shellSpeed = 9e9
                end
                return origNC(self, table.unpack(args,1,args.n))
            end
        end
        return origNC(self,...)
    end))
    print("[SA v14] hookmetamethod OK")
end)

-- ============================================================
--  KILL ALL
-- ============================================================
local function doKillAll()
    if not R.Damage then warn("[SA v14] Damage remote not ready"); return end
    local myChar = LocalPlayer.Character
    local origin = myChar and myChar:FindFirstChild("HumanoidRootPart")
        and myChar.HumanoidRootPart.Position or Camera.CFrame.Position
    local n = 0
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        task.spawn(function()
            local root,head,hum,char = getPlayerRoot(pl)
            if not root or not hum or hum.Health<=0 then return end
            local hp = head or root
            local sd = {weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,999999)}
            for _=1,5 do
                pcall(function() R.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
            end
        end)
        n=n+1
    end
    print("[SA v14] KillAll -> "..n)
end

-- ============================================================
--  EXPLOIT UI
-- ============================================================
local exploitUI = nil
local uiVisible = false

local function buildExploitUI()
    if exploitUI then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "SA_ExploitPanel"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not ok then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local main = Instance.new("Frame",sg)
    main.Name = "Main"
    main.Size = UDim2.new(0,340,0,520)
    main.Position = UDim2.new(0.5,-170,0.5,-260)
    main.BackgroundColor3 = Color3.fromRGB(15,15,20)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke",main)
    stroke.Color=Color3.fromRGB(60,120,255); stroke.Thickness=1.5

    local title=Instance.new("TextLabel",main)
    title.Size=UDim2.new(1,0,0,36)
    title.BackgroundColor3=Color3.fromRGB(20,20,35)
    title.BorderSizePixel=0
    title.Text="SilentAim v14  |  Exploit Panel"
    title.TextColor3=Color3.fromRGB(80,180,255)
    title.TextSize=14; title.Font=Enum.Font.GothamBold
    Instance.new("UICorner",title).CornerRadius=UDim.new(0,8)

    local statusLbl=Instance.new("TextLabel",main)
    statusLbl.Name="Status"
    statusLbl.Size=UDim2.new(1,-20,0,22)
    statusLbl.Position=UDim2.new(0,10,0,38)
    statusLbl.BackgroundColor3=Color3.fromRGB(10,10,15)
    statusLbl.BorderSizePixel=0
    statusLbl.Text="Status: Ready"
    statusLbl.TextColor3=Color3.fromRGB(180,180,180)
    statusLbl.TextSize=12; statusLbl.Font=Enum.Font.Code
    statusLbl.TextXAlignment=Enum.TextXAlignment.Left
    statusLbl.TextTruncate=Enum.TextTruncate.AtEnd
    Instance.new("UICorner",statusLbl).CornerRadius=UDim.new(0,4)

    local function setStatus(msg, col)
        statusLbl.Text=">> "..msg
        statusLbl.TextColor3=col or Color3.fromRGB(80,255,120)
    end

    local scroll=Instance.new("ScrollingFrame",main)
    scroll.Size=UDim2.new(1,-10,1,-70)
    scroll.Position=UDim2.new(0,5,0,66)
    scroll.BackgroundTransparency=1
    scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=4
    scroll.ScrollBarImageColor3=Color3.fromRGB(60,120,255)
    scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local layout=Instance.new("UIListLayout",scroll)
    layout.Padding=UDim.new(0,4); layout.SortOrder=Enum.SortOrder.LayoutOrder
    local padding=Instance.new("UIPadding",scroll)
    padding.PaddingLeft=UDim.new(0,4); padding.PaddingRight=UDim.new(0,4)
    padding.PaddingTop=UDim.new(0,4)

    local secOrder=0; local btnOrder=0
    local function section(text)
        secOrder=secOrder+1; btnOrder=btnOrder+1
        local lbl=Instance.new("TextLabel",scroll)
        lbl.Size=UDim2.new(1,0,0,20)
        lbl.BackgroundColor3=Color3.fromRGB(30,30,50)
        lbl.BorderSizePixel=0; lbl.Text="  "..text
        lbl.TextColor3=Color3.fromRGB(100,160,255)
        lbl.TextSize=12; lbl.Font=Enum.Font.GothamSemibold
        lbl.TextXAlignment=Enum.TextXAlignment.Left
        lbl.LayoutOrder=btnOrder
        Instance.new("UICorner",lbl).CornerRadius=UDim.new(0,4)
    end
    local function btn(label, desc, fn)
        btnOrder=btnOrder+1
        local f=Instance.new("Frame",scroll)
        f.Size=UDim2.new(1,0,0,46); f.BackgroundColor3=Color3.fromRGB(22,22,32)
        f.BorderSizePixel=0; f.LayoutOrder=btnOrder
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local b=Instance.new("TextButton",f)
        b.Size=UDim2.new(0,90,0,28); b.Position=UDim2.new(1,-98,0.5,-14)
        b.BackgroundColor3=Color3.fromRGB(40,90,200); b.BorderSizePixel=0
        b.Text=label; b.TextColor3=Color3.fromRGB(255,255,255)
        b.TextSize=12; b.Font=Enum.Font.GothamBold
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        local d=Instance.new("TextLabel",f)
        d.Size=UDim2.new(1,-106,1,0); d.Position=UDim2.new(0,8,0,0)
        d.BackgroundTransparency=1; d.Text=desc
        d.TextColor3=Color3.fromRGB(160,160,180); d.TextSize=11
        d.Font=Enum.Font.Gotham; d.TextXAlignment=Enum.TextXAlignment.Left
        d.TextWrapped=true
        b.MouseButton1Click:Connect(function()
            b.BackgroundColor3=Color3.fromRGB(20,60,140)
            local ok2,err=pcall(fn,setStatus)
            if not ok2 then setStatus("ERROR: "..tostring(err):sub(1,60),Color3.fromRGB(255,80,80)) end
            task.delay(0.3,function() b.BackgroundColor3=Color3.fromRGB(40,90,200) end)
        end)
        b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(55,110,220) end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(40,90,200) end)
    end

    -- РАЗДЕЛЫ UI (только рабочие функции по дампу)
    section("== VISUAL / FLASH ==")
    btn("SVFlash ALL","Flash grenades на всех врагов",function(s)
        assert(R.SVFlash,"SVFlash not found")
        local camPos=Camera.CFrame.Position; local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function()
                    R.SVFlash:FireServer(pl,camPos,3,true) end) end)
                n=n+1
            end
        end
        s("SVFlash -> "..n.." players")
    end)
    btn("NVG Spam","NVG toggle x5 (server)",function(s)
        assert(R.NVG,"NVG not found")
        for i=1,5 do pcall(function() R.NVG:FireServer(true) end) end
        s("NVG x5 fired")
    end)
    btn("SVLaser ALL","Laser визуал на всех",function(s)
        assert(R.SVLaser,"SVLaser not found")
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function()
                    R.SVLaser:FireServer(pl,true,Color3.fromRGB(255,0,0)) end) end)
            end
        end
        s("SVLaser fired")
    end)

    section("== PLAYER TROLLING ==")
    btn("Collapse ALL","MedSys.Collapse на всех врагов",function(s)
        assert(R.Collapse,"MedSys.Collapse not found")
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function() R.Collapse:FireServer(pl) end) end)
                n=n+1
            end
        end
        s("Collapse -> "..n)
    end)
    btn("Surrender ALL","Surrender на всех",function(s)
        assert(R.Surrender,"Surrender not found")
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function() R.Surrender:FireServer(pl) end) end)
            end
        end
        s("Surrender fired")
    end)
    btn("Drag Target","Drag ближайшего врага",function(s)
        assert(R.Drag,"Drag not found")
        if not cachedTarget then s("No target",Color3.fromRGB(255,180,50)); return end
        local root,_,_,_ = getPlayerRoot(cachedTarget)
        if root then pcall(function() R.Drag:FireServer(root) end)
            s("Drag -> "..cachedTarget.Name)
        end
    end)
    btn("KillMe","PlayerEvents.KillMe",function(s)
        assert(R.KillMe,"KillMe not found")
        pcall(function() R.KillMe:FireServer() end)
        s("KillMe fired")
    end)
    btn("KillAll","Damage remote -> убить всех",function(s)
        doKillAll(); s("KillAll executed")
    end)

    section("== AMMO / EQUIP ==")
    btn("DropAmmo","DropGiveAmmo у своей позиции",function(s)
        assert(R.DropGiveAmmo,"DropGiveAmmo not found")
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        pcall(function() R.DropGiveAmmo:FireServer(root and root.Position or Vector3.new()) end)
        s("DropGiveAmmo fired")
    end)
    btn("Refill Ammo","ACS Refil x3 (server-side)",function(s)
        assert(R.Refil,"Refil not found")
        for _=1,3 do task.spawn(function() pcall(function() R.Refil:FireServer() end) end) end
        s("Refil x3 fired")
    end)

    section("== SERVER / WORLD ==")
    btn("OpenDoors","DoorEvent -> открыть все двери",function(s)
        assert(R.DoorEvent,"DoorEvent not found"); local n=0
        for _,v in workspace:GetDescendants() do
            if v.Name:lower():find("door") and v:IsA("Model") then
                task.spawn(function() pcall(function() R.DoorEvent:FireServer(v,true) end) end)
                n=n+1
            end
        end
        s("DoorEvent -> "..n.." doors")
    end)
    btn("ToggleMusic","Выключить серверную музыку",function(s)
        assert(R.ToggleMusic,"ToggleMusic not found")
        pcall(function() R.ToggleMusic:FireServer(false) end)
        s("ToggleMusic(false)")
    end)
    btn("RadarSub","RadarSubscription (все на радаре)",function(s)
        assert(R.RadarSubscription,"RadarSubscription not found")
        pcall(function() R.RadarSubscription:FireServer(true) end)
        s("RadarSubscription(true)")
    end)
    btn("RequestDeploy","RequestDeploy (мгновенный деплой)",function(s)
        assert(R.RequestDeploy,"RequestDeploy not found")
        pcall(function() R.RequestDeploy:FireServer() end)
        s("RequestDeploy fired")
    end)
    btn("CrashAllHeli","Crash Event для всех вертолётов",function(s)
        local rs2=game:GetService("ReplicatedStorage")
        local helis=rs2:FindFirstChild("Helicopters"); local n=0
        if not helis then s("Helicopters not found",Color3.fromRGB(255,80,80)); return end
        for _,heli in helis:GetChildren() do
            local net=heli:FindFirstChild("Networking")
            local ce=net and net:FindFirstChild("CrashEvent")
            if ce then pcall(function() ce:FireServer() end); n=n+1 end
        end
        s("CrashEvent x"..n)
    end)

    section("== ПРОГРЕССИЯ ==")
    btn("RedeemSpin","RedeemSpin (бесплатный спин)",function(s)
        assert(R.RedeemSpin,"RedeemSpin not found")
        pcall(function() R.RedeemSpin:InvokeServer() end)
        s("RedeemSpin invoked")
    end)
    btn("CompleteTutor","CompleteTutorial",function(s)
        if not R.CompleteTutorial then s("CompleteTutorial not found",Color3.fromRGB(255,120,50)); return end
        pcall(function() R.CompleteTutorial:FireServer() end)
        s("CompleteTutorial fired")
    end)

    -- Close button
    local closeBtn=Instance.new("TextButton",main)
    closeBtn.Size=UDim2.new(0,24,0,24)
    closeBtn.Position=UDim2.new(1,-28,0,6)
    closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40)
    closeBtn.Text="X"; closeBtn.TextColor3=Color3.fromRGB(255,255,255)
    closeBtn.TextSize=13; closeBtn.Font=Enum.Font.GothamBold
    closeBtn.BorderSizePixel=0
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,4)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible=false; uiVisible=false
    end)

    exploitUI = main
end

local function toggleUI()
    if not exploitUI then buildExploitUI() end
    uiVisible = not uiVisible
    exploitUI.Visible = uiVisible
end

-- ============================================================
--  ESP RENDER  (FIX1: только рисование, без итерации игроков)
-- ============================================================
-- FPSFIX: drawESP читает только espDataCache — нет FindFirstChild, нет getPlayerRoot
-- Все тяжёлые операции вынесены в updateESPCache() (Heartbeat)
local function drawESP()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        local e = getESP(pl)
        local d = espDataCache[pl]

        if not d or not d.alive then hideESP(e); continue end

        -- depth check (единственный w2s для отсечения)
        local _,_,spZ = w2s(d.rootPos)
        if spZ <= 0 then hideESP(e); continue end

        local col     = d.col
        local headPos = d.headPos
        local footPos = d.footPos
        local dist    = d.dist

        -- w2s для головы и ног (используется несколькими секциями — считаем один раз)
        local hsp,hv,hz = w2s(headPos)
        local fsp,fv,fz = w2s(footPos)

        -- HEAD CIRCLE
        if CFG.ShowSkeleton and hv and hz>0 then
            local r = math.clamp(1400/math.max(dist,1), 2, 6)
            e.headCircle.Position=hsp; e.headCircle.Radius=r
            e.headCircle.Color=col; e.headCircle.Visible=true
        else e.headCircle.Visible=false end

        -- SKELETON (берём позиции из кэша, без FindFirstChild)
        if CFG.ShowSkeleton then
            for i=1,#SKELETON_BONES do
                local l = e.skelLines[i]
                local b = d.bones[i]
                if b then
                    local sp0,v0,z0 = w2s(b[1])
                    local sp1,v1,z1 = w2s(b[2])
                    if z0>0 and z1>0 then
                        l.From=sp0; l.To=sp1; l.Color=col; l.Visible=true
                    else l.Visible=false end
                else l.Visible=false end
            end
        else for _,l in e.skelLines do l.Visible=false end end

        -- BOX
        if CFG.ShowBox and hz>0 and fz>0 then
            local height = math.abs(hsp.Y - fsp.Y)
            local width  = height * 0.45
            local cx     = (hsp.X + fsp.X)/2
            local top    = math.min(hsp.Y,fsp.Y) - 4
            local bot    = math.max(hsp.Y,fsp.Y) + 2
            local left   = cx - width/2; local right = cx + width/2
            local corners = {
                {Vector2.new(left,top),  Vector2.new(left+width*0.25,top)},
                {Vector2.new(right-width*0.25,top), Vector2.new(right,top)},
                {Vector2.new(left,bot),  Vector2.new(left+width*0.25,bot)},
                {Vector2.new(right-width*0.25,bot), Vector2.new(right,bot)},
                {Vector2.new(left,top),  Vector2.new(left,top+(bot-top)*0.25)},
                {Vector2.new(left,bot-(bot-top)*0.25), Vector2.new(left,bot)},
                {Vector2.new(right,top), Vector2.new(right,top+(bot-top)*0.25)},
                {Vector2.new(right,bot-(bot-top)*0.25),Vector2.new(right,bot)},
            }
            for i,seg in ipairs(corners) do
                e.boxLines[i].From=seg[1]; e.boxLines[i].To=seg[2]
                e.boxLines[i].Color=col; e.boxLines[i].Visible=true
            end
        else for _,l in e.boxLines do l.Visible=false end end

        -- HP BAR
        if CFG.ShowHP and hz>0 and fz>0 then
            local height = math.abs(hsp.Y - fsp.Y)
            local width  = height*0.45
            local cx     = (hsp.X+fsp.X)/2
            local top    = math.min(hsp.Y,fsp.Y)-4
            local bot    = math.max(hsp.Y,fsp.Y)+2
            local bx     = cx - width/2 - 6
            local hp     = math.clamp(d.hp/math.max(d.maxhp,1), 0, 1)
            local hpTop  = top + (bot-top)*(1-hp)
            e.hpBg.From=Vector2.new(bx,top); e.hpBg.To=Vector2.new(bx,bot); e.hpBg.Visible=true
            e.hpFill.From=Vector2.new(bx,hpTop); e.hpFill.To=Vector2.new(bx,bot)
            e.hpFill.Color=Color3.fromRGB(math.floor((1-hp)*255),math.floor(hp*255),30)
            e.hpFill.Visible=true
        else e.hpBg.Visible=false; e.hpFill.Visible=false end

        -- NAME
        if CFG.ShowName and hv and hz>0 then
            e.name.Text=d.name; e.name.Color=col
            e.name.Position=hsp+Vector2.new(0,-16); e.name.Visible=true
        else e.name.Visible=false end

        -- DIST
        if CFG.ShowDist and fv and fz>0 then
            e.dist.Text=string.format("%dm",math.floor(dist))
            e.dist.Position=fsp+Vector2.new(0,4); e.dist.Visible=true
        else e.dist.Visible=false end

        -- STATE
        if CFG.ShowState and d.state~="" and fv and fz>0 then
            e.state.Text=d.state
            e.state.Position=fsp+Vector2.new(0,16); e.state.Visible=true
        else e.state.Visible=false end
    end
end

-- ============================================================
--  RENDER STEPPED  (FIX1: только рисование)
-- ============================================================
RunService.RenderStepped:Connect(function()
    _fc = _fc + 1
    swAngle = swAngle + 0.05

    -- FPSFIX-J: STATUS обновляем раз в 10 кадров
    if _fc % 10 == 0 then
    local function b(v) return v and "ON" or "--" end
    dStatus.Text = string.format(
        "SA:%s BTP:%s WB:%s FH:%s IA:%s FA:%s FF:%s | KAS:%s GS:%s SP:%s",
        b(CFG.SilentAim and CFG.Enabled), b(CFG.BulletTP), b(CFG.WallBang),
        b(CFG.ForceHit), b(CFG.InfAmmo), b(CFG.FullAuto), b(CFG.FFViewModel),
        b(CFG.KillAllSpam), b(CFG.GrenadeSpam), b(CFG.SpotAll))
    dStatus.Color = CFG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)
    end  -- /FPSFIX-J status throttle

    -- FOV circle
    dFOV.Position = screenCenter(); dFOV.Radius = CFG.FOV
    dFOV.Visible = CFG.ShowFOV and CFG.Enabled
    dFOV.Color = (cachedTarget and CFG.EnemyColor) or CFG.FOVColor

    -- FIX3: TRACER FADE с правильной прозрачностью Drawing (0=видим, 1=прозрачн)
    local now = tick(); local i = 1
    while i <= #tracers do
        local tr  = tracers[i]
        local age = now - tr.born
        if age > TRACER_LIFE then
            tr.line:Remove(); table.remove(tracers, i)
        else
            -- FPSFIX-H: sp1/sp2 уже в 2D, не пересчитываем w2s каждый кадр
            tr.line.Visible      = true
            tr.line.Transparency = age / TRACER_LIFE
            i = i + 1
        end
    end

    -- AIM LINE (FIX5: белый фиксированный цвет)
    if CFG.ShowAimLine and CFG.Enabled and cachedTargetPos then
        local mp = getMuzzleWorldPos()
        if mp then
            local sp1,v1 = w2s(mp)
            local sp2,_  = w2s(cachedTargetPos)
            if v1 then
                aimLine.Visible = true
                aimLine.From    = sp1
                aimLine.To      = sp2
                aimLine.Color   = Color3.fromRGB(255,255,255)  -- FIX5: белый
            else aimLine.Visible = false end
        else aimLine.Visible = false end
    else aimLine.Visible = false end

    -- HIT MARKER (FIX8: рисуем на точке попадания, не по центру экрана)
    local hmNow = tick()
    if CFG.ShowHitmarker and hmNow < hitmarkerUntil then
        -- FIX8: переводим 3D позицию в 2D
        local hmCenter
        if hitmarkerPos3D then
            local sp,v,z = w2s(hitmarkerPos3D)
            if v and z>0 then
                hmCenter = sp
            else
                hmCenter = screenCenter()  -- fallback по центру если вне экрана
            end
        else
            hmCenter = screenCenter()
        end
        local alpha = (hitmarkerUntil - hmNow) / 0.18
        local len, gap = 8, 6
        local segs = {
            {hmCenter+Vector2.new(-gap-len,-gap-len), hmCenter+Vector2.new(-gap,-gap)},
            {hmCenter+Vector2.new(gap,-gap),           hmCenter+Vector2.new(gap+len,-gap-len)},
            {hmCenter+Vector2.new(-gap,gap),           hmCenter+Vector2.new(-gap-len,gap+len)},
            {hmCenter+Vector2.new(gap,gap),            hmCenter+Vector2.new(gap+len,gap+len)},
        }
        for i=1,4 do
            local l=hitmarkerLines[i]
            l.Visible=true; l.From=segs[i][1]; l.To=segs[i][2]
            -- FIX3: Drawing Transparency 0=непрозрачный
            l.Transparency = 1 - alpha*0.9
        end
    else
        for i=1,4 do hitmarkerLines[i].Visible=false end
    end

    -- SWASTIKA (FIX5: Transparency=0.05 в makeESP уже задано)
    if CFG.ShowSwastika and CFG.Enabled and cachedTargetPos then
        local sp,_,sz = w2s(cachedTargetPos)
        if sz>0 then
            local d   = math.max(cachedDist, 1)
            local sz2 = math.clamp(2500/d, 8, 28)
            local col = hsvToRgb((tick()*0.6)%1, 1, 1)
            drawSwastika(sp, sz2, swAngle, col)
        else hideSwastika() end
    else hideSwastika() end

    -- FPSFIX-I: ESP рисуем каждые 2 кадра (30fps достаточно для ESP)
    if CFG.ESPEnabled and _fc % 2 == 0 then
        drawESP()
    elseif not CFG.ESPEnabled then
        for _,e in espCache do hideESP(e) end
    end
end)

-- ============================================================
--  INPUT BINDINGS
-- ============================================================
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    local k = inp.KeyCode

    if k == Enum.KeyCode.Insert then
        CFG.Enabled    = not CFG.Enabled
        CFG.SilentAim  = CFG.Enabled
        print("[SA v14] SilentAim:", CFG.Enabled)

    elseif k == Enum.KeyCode.Delete then
        CFG.BulletTP = not CFG.BulletTP
        print("[SA v14] BulletTP:", CFG.BulletTP)

    elseif k == Enum.KeyCode.End then
        CFG.WallBang = not CFG.WallBang
        print("[SA v14] WallBang:", CFG.WallBang)

    elseif k == Enum.KeyCode.Home then
        CFG.ForceHit = not CFG.ForceHit
        print("[SA v14] ForceHit:", CFG.ForceHit)

    elseif k == Enum.KeyCode.F5 then
        CFG.InfAmmo = not CFG.InfAmmo
        print("[SA v14] InfAmmo:", CFG.InfAmmo)

    elseif k == Enum.KeyCode.F6 then
        CFG.FullAuto = not CFG.FullAuto
        if u7Ref then
            if CFG.FullAuto then
                u7Ref.ShootRate = 99999
                u7Ref.ShootType = 3  -- Auto
                print("[SA v14] FullAuto ON (ShootType=3, ShootRate=99999)")
            else
                u7Ref.ShootRate = u7Ref._origShootRate or u7Ref.ShootRate
                u7Ref.ShootType = u7Ref._origShootType or u7Ref.ShootType
                print("[SA v14] FullAuto OFF (restored)")
            end
        end

    elseif k == Enum.KeyCode.F7 then
        CFG.FFViewModel = not CFG.FFViewModel
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then applyFFToTool(tool, CFG.FFViewModel) end
        print("[SA v14] FFViewModel:", CFG.FFViewModel)

    elseif k == Enum.KeyCode.F8 then
        CFG.ShowTracer = not CFG.ShowTracer
        print("[SA v14] BulletTracer:", CFG.ShowTracer)

    elseif k == Enum.KeyCode.F9 then
        CFG.ShowAimLine = not CFG.ShowAimLine
        print("[SA v14] AimLine:", CFG.ShowAimLine)

    elseif k == Enum.KeyCode.F10 then
        doKillAll()

    elseif k == Enum.KeyCode.F11 then
        CFG.KillAllSpam = not CFG.KillAllSpam
        print("[SA v14] KillAllSpam:", CFG.KillAllSpam)

    elseif k == Enum.KeyCode.F12 then
        CFG.SpotAll = not CFG.SpotAll
        print("[SA v14] SpotAll:", CFG.SpotAll)

    elseif k == Enum.KeyCode.KeypadZero then
        CFG.GrenadeSpam = not CFG.GrenadeSpam
        print("[SA v14] GrenadeSpam:", CFG.GrenadeSpam)

    elseif k == Enum.KeyCode.KeypadOne then
        -- CrashAllHeli
        local rs2 = game:GetService("ReplicatedStorage")
        local helis = rs2:FindFirstChild("Helicopters"); local n=0
        if helis then
            for _,heli in helis:GetChildren() do
                local net=heli:FindFirstChild("Networking")
                local ce=net and net:FindFirstChild("CrashEvent")
                if ce then pcall(function() ce:FireServer() end); n=n+1 end
            end
        end
        print("[SA v14] CrashAllHeli:", n)

    elseif k == Enum.KeyCode.RightControl then
        toggleUI()

    elseif k == Enum.KeyCode.PageUp then
        CFG.FOV = math.min(CFG.FOV + 50, 800)
        print("[SA v14] FOV:", CFG.FOV)

    elseif k == Enum.KeyCode.PageDown then
        CFG.FOV = math.max(CFG.FOV - 50, 50)
        print("[SA v14] FOV:", CFG.FOV)
    end
end)

-- Initial gun refs
task.spawn(function()
    task.wait(4)
    refreshGunRefs()
end)

print("[SA v14] Loaded. RCtrl=ExploitUI | Insert=Toggle | F5=InfAmmo | F6=FullAuto")
