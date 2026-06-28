--[[
╔══════════════════════════════════════════════════════════════════╗
║              SilentAim v11  --  ACS Engine (FastCastRedux)      ║
║  GitHub: AndreyZlo1/script  |  base commit: 27e0da7             ║
╠══════════════════════════════════════════════════════════════════╣
║  FIXES v11:                                                      ║
║  - ForceField ViewModel: ищет BasePart глубже + повтор при Equip ║
║  - BulletTracer: правильный Fade (1.0 → 0.0 = прозрачный),     ║
║    WorldToViewport каждый кадр (не застывает), живёт 0.5с        ║
║  - Свастика: ИСПРАВЛЕНА, рисуется с правильным масштабом        ║
║  - State: только ASCII (Drawing не поддерживает Unicode)        ║
║  - AimLine: origin = WorldPosition Attachment MuzzlePoint/Muzzle ║
║    в tool, fallback RightHand                                   ║
║  - Head circle: радиус уменьшен (3500/dist, max 12)             ║
║  - FullAuto: рабочий через ShootRate без изменения ShootType    ║
║  - InfAmmo: зеркалит только bullets, не трогает ViewmodelAnims  ║
║  ADDED:                                                          ║
║  - Exploit UI (ScreenGui, RobloxGui inject, кнопки + статус)    ║
║  - NVG для всех (SVFlash, SVLaser, NVG spam)                    ║
║  - Collapse (MedSys) → заставить упасть                         ║
║  - Surrender → сдаться / заставить другого                      ║
║  - Backpack → дать себе оружие                                  ║
║  - RequestTeleport → телепорт к игроку                          ║
║  - RedeemSpin → бесплатный спин                                 ║
║  - ClaimFreeStarterPack / ClaimUGC                              ║
║  - FakeBetaPurchase                                             ║
║  - CollectCash spam                                             ║
║  - SpotAll, KillMe, DropGiveAmmo, CompleteTutorial              ║
╠══════════════════════════════════════════════════════════════════╣
║  BINDS:                                                         ║
║  Insert   = SilentAim on/off                                    ║
║  Delete   = BulletTP on/off                                     ║
║  End      = WallBang on/off                                     ║
║  Home     = ForceHit on/off                                     ║
║  F5       = InfAmmo on/off                                      ║
║  F6       = FullAuto on/off                                     ║
║  F7       = ForceField ViewModel on/off                         ║
║  F8       = BulletTracer on/off                                 ║
║  F9       = AimLine on/off                                      ║
║  F10      = KillAll (разовый)                                   ║
║  F11      = KillAllSpam toggle                                  ║
║  F12      = SpotAll toggle                                      ║
║  Numpad0  = GrenadeSpam toggle                                  ║
║  Numpad1  = CrashAllHeli                                        ║
║  RCtrl    = Exploit UI toggle                                   ║
║  PgUp/Dn  = FOV +/-50                                           ║
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

    ESPEnabled   = true,
    ShowBox      = true,
    ShowSkeleton = true,
    ShowName     = true,
    ShowHP       = true,
    ShowDist     = true,
    ShowState    = true,
    ShowFOV      = true,
    ShowSwastika = true,
    ShowAimLine  = true,
    ShowTracer   = true,

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

local HITBOX = {
    Head=true,UpperTorso=true,LowerTorso=true,HumanoidRootPart=true,
    LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,
    RightUpperArm=true,RightLowerArm=true,RightHand=true,
    LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,
    RightUpperLeg=true,RightLowerLeg=true,RightFoot=true,
}

-- R15 skeleton bones
local SKELETON_BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

-- Player state (ASCII only - Drawing.Text не поддерживает Unicode/символы)
local function getPlayerState(char, hum)
    if not hum then return "" end
    if hum.Health<=0 then return "DEAD" end
    -- vehicle check via seat
    for _,v in char:GetChildren() do
        if v:IsA("Seat") or v:IsA("VehicleSeat") then return "Vehicle" end
    end
    local seatVal = char:FindFirstChild("SeatValue") or char:FindFirstChild("InSeat")
    if seatVal and seatVal.Value~=nil then return "Vehicle" end
    -- ACS attributes
    if char:GetAttribute("Prone")      then return "Prone"   end
    if char:GetAttribute("Crouching")  then return "Crouch"  end
    if char:GetAttribute("Crouch")     then return "Crouch"  end
    if char:GetAttribute("IsGrappling") then return "Grapple" end
    if char:GetAttribute("IsDragging") then return "Dragging" end
    local st = hum:GetState()
    if st==Enum.HumanoidStateType.Swimming  then return "Swimming" end
    if st==Enum.HumanoidStateType.Freefall  then return "Airborne" end
    if st==Enum.HumanoidStateType.Climbing  then return "Climbing" end
    if st==Enum.HumanoidStateType.PlatformStanding then return "Vehicle" end
    return ""
end

-- ============================================================
--  ESP OBJECTS
-- ============================================================
local espCache = {}

local function makeESP()
    local e = {}
    e.boxLines = {}
    for i=1,8 do e.boxLines[i]=D("Line",{Visible=false,Thickness=1.5,
        Color=Color3.fromRGB(255,255,255),Transparency=0.8}) end
    e.hpBg   = D("Line",{Visible=false,Thickness=5,
        Color=Color3.fromRGB(0,0,0),Transparency=0.4})
    e.hpFill = D("Line",{Visible=false,Thickness=3,
        Color=Color3.fromRGB(0,255,80),Transparency=0.8})
    e.name   = D("Text",{Visible=false,Size=13,
        Color=Color3.fromRGB(255,255,255),Outline=true,
        OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.dist   = D("Text",{Visible=false,Size=11,
        Color=Color3.fromRGB(200,200,200),Outline=true,
        OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.state  = D("Text",{Visible=false,Size=11,
        Color=Color3.fromRGB(255,200,50),Outline=true,
        OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.skelLines = {}
    for i=1,#SKELETON_BONES do
        e.skelLines[i]=D("Line",{Visible=false,Thickness=1,
            Color=Color3.fromRGB(255,255,255),Transparency=0.7})
    end
    e.headCircle = D("Circle",{Visible=false,Filled=false,Thickness=1.5,
        Radius=8,Color=Color3.fromRGB(255,255,255),Transparency=0.7})
    return e
end

local function removeESP(e)
    for _,l in e.boxLines do pcall(l.Remove,l) end
    for _,l in e.skelLines do pcall(l.Remove,l) end
    pcall(e.hpBg.Remove,e.hpBg); pcall(e.hpFill.Remove,e.hpFill)
    pcall(e.name.Remove,e.name); pcall(e.dist.Remove,e.dist)
    pcall(e.state.Remove,e.state); pcall(e.headCircle.Remove,e.headCircle)
end

local function getESP(pl)
    if not espCache[pl] then espCache[pl]=makeESP() end
    return espCache[pl]
end

Players.PlayerRemoving:Connect(function(pl)
    if espCache[pl] then removeESP(espCache[pl]); espCache[pl]=nil end
end)

-- ============================================================
--  BOX DRAW (corner style)
-- ============================================================
local function drawBox(e, tl, br, col)
    local w=br.X-tl.X; local h=br.Y-tl.Y
    local cw=math.clamp(w*0.25,4,16)
    local ch=math.clamp(h*0.25,4,16)
    local segs={
        {tl,tl+Vector2.new(cw,0)},{tl,tl+Vector2.new(0,ch)},
        {Vector2.new(br.X,tl.Y),Vector2.new(br.X-cw,tl.Y)},
        {Vector2.new(br.X,tl.Y),Vector2.new(br.X,tl.Y+ch)},
        {br,br+Vector2.new(-cw,0)},{br,br+Vector2.new(0,-ch)},
        {Vector2.new(tl.X,br.Y),Vector2.new(tl.X+cw,br.Y)},
        {Vector2.new(tl.X,br.Y),Vector2.new(tl.X,br.Y-ch)},
    }
    for i,seg in ipairs(segs) do
        local l=e.boxLines[i]; l.Visible=true
        l.From=seg[1]; l.To=seg[2]; l.Color=col
    end
end

-- ============================================================
--  SKELETON + HEAD CIRCLE
-- ============================================================
local function drawSkeleton(e, char, col)
    local pts={}
    for _,p in char:GetChildren() do
        if p:IsA("BasePart") then pts[p.Name]=p end
    end
    for i,conn in ipairs(SKELETON_BONES) do
        local l=e.skelLines[i]; if not l then continue end
        local a=pts[conn[1]]; local b=pts[conn[2]]
        if a and b then
            local sa,va=w2s(a.Position); local sb,vb=w2s(b.Position)
            if va and vb then
                l.Visible=true; l.From=sa; l.To=sb; l.Color=col
            else l.Visible=false end
        else l.Visible=false end
    end
    -- Head circle - small, distance-aware
    local hd=pts["Head"]
    if hd then
        local sh,vh=w2s(hd.Position)
        if vh then
            local dist=(hd.Position-Camera.CFrame.Position).Magnitude
            local r=math.clamp(3500/dist,3,12)
            e.headCircle.Visible=true
            e.headCircle.Position=sh
            e.headCircle.Radius=r
            e.headCircle.Color=col
        else e.headCircle.Visible=false end
    else e.headCircle.Visible=false end
end

-- ============================================================
--  HP BAR (gradient via per-frame color)
-- ============================================================
local function drawHPBar(e, tl, br, hp)
    local x=tl.X-6
    e.hpBg.Visible=true; e.hpBg.From=Vector2.new(x,br.Y); e.hpBg.To=Vector2.new(x,tl.Y)
    e.hpBg.Color=Color3.fromRGB(20,20,20)
    local midY=br.Y + (tl.Y-br.Y)*(hp/100)
    local r=math.floor(255*(1-hp/100)); local g=math.floor(255*(hp/100))
    e.hpFill.Visible=true
    e.hpFill.From=Vector2.new(x,br.Y); e.hpFill.To=Vector2.new(x,midY)
    e.hpFill.Color=Color3.fromRGB(r,g,0)
end

local function hideESP(e)
    for _,l in e.boxLines do l.Visible=false end
    for _,l in e.skelLines do l.Visible=false end
    e.hpBg.Visible=false; e.hpFill.Visible=false
    e.name.Visible=false; e.dist.Visible=false
    e.state.Visible=false; e.headCircle.Visible=false
end

-- ============================================================
--  SWASTIKA (8 Drawing.Line segments, rotating)
-- ============================================================
local swLines = {}
for i=1,8 do
    swLines[i] = D("Line",{Visible=false,Thickness=2,
        Color=Color3.fromRGB(255,0,0),Transparency=0})
end
local swAngle = 0

local function rotVec2(v,a)
    local c,s=math.cos(a),math.sin(a)
    return Vector2.new(v.X*c-v.Y*s, v.X*s+v.Y*c)
end

-- Свастика: 4 плеча по 2 отрезка каждое (основа + хвост)
local SW_ARMS = {
    {dir=Vector2.new(0,-1), cross=Vector2.new( 1, 0)},
    {dir=Vector2.new( 1, 0), cross=Vector2.new( 0, 1)},
    {dir=Vector2.new( 0, 1), cross=Vector2.new(-1, 0)},
    {dir=Vector2.new(-1, 0), cross=Vector2.new( 0,-1)},
}

local function drawSwastika(center, size, angle, col)
    for i,arm in ipairs(SW_ARMS) do
        local d  = rotVec2(arm.dir,  angle)
        local cr = rotVec2(arm.cross, angle)
        local base   = center + d * (size*0.2)
        local tip    = center + d * size
        local tail   = tip + cr * (size*0.55)
        local li1 = swLines[i*2-1]
        local li2 = swLines[i*2]
        li1.Visible=true; li1.From=base; li1.To=tip; li1.Color=col
        li2.Visible=true; li2.From=tip; li2.To=tail; li2.Color=col
    end
end

local function hideSwastika()
    for _,l in swLines do l.Visible=false end
end

-- ============================================================
--  AIM LINE (gun muzzle -> target)
-- ============================================================
local aimLine = D("Line",{Visible=false,Thickness=1.5,
    Color=Color3.fromRGB(255,255,255),Transparency=0.3})

local function getMuzzleWorldPos()
    local char=LocalPlayer.Character; if not char then return nil end
    local tool=char:FindFirstChildOfClass("Tool"); if not tool then return nil end
    -- Search all descendants for known muzzle attachments or parts
    local function findInst(root, names)
        for _,n in ipairs(names) do
            local f=root:FindFirstChild(n,true)
            if f then return f end
        end
        return nil
    end
    local att = findInst(tool, {"MuzzlePoint","Muzzle","muzzle","FirePoint","FiringPoint","TipAttachment","BarrelEnd"})
    if att then
        if att:IsA("Attachment") then return att.WorldPosition end
        if att:IsA("BasePart")   then return att.Position + att.CFrame.LookVector*att.Size.Z*0.5 end
    end
    -- fallback: righthand or camera
    local rh = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    return rh and rh.Position or Camera.CFrame.Position
end

-- ============================================================
--  BULLET TRACERS
-- ============================================================
local tracers = {}      -- { line, from3d, to3d, born }
local TRACER_LIFE = 0.5

local function spawnTracer(from3d, to3d)
    -- store 3D positions so we update via WorldToViewport every frame
    local l = D("Line",{Visible=true,Thickness=1.5,
        Color=Color3.fromRGB(255,220,60),Transparency=0})
    table.insert(tracers,{line=l, from3d=from3d, to3d=to3d, born=tick()})
end

-- ============================================================
--  TARGET CACHE
-- ============================================================
local cachedTarget=nil; local cachedTargetPos=nil; local cachedDist=0

local function predictPos(part)
    if not CFG.PredictLead then return part.Position end
    local root=part.Parent:FindFirstChild("HumanoidRootPart") or part
    local ok,vel=pcall(function() return root.AssemblyLinearVelocity end)
    if not ok then return part.Position end
    return part.Position + vel*(cachedDist/1200)*CFG.LeadFactor
end

local _fc=0
local function updateCache()
    local center=screenCenter(); local camPos=Camera.CFrame.Position
    local bestDist=math.huge; local best,bestPos,bestRealDist=nil,nil,0
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        if isTeammate(pl) then continue end
        local char=pl.Character; if not char then continue end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then continue end
        local part=char:FindFirstChild(CFG.AimPart) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        local pp=predictPos(part)
        local sp,vis=w2s(pp); if not vis then continue end
        local sd=(sp-center).Magnitude
        if sd>CFG.FOV then continue end
        if sd<bestDist then
            bestDist=sd; best=pl; bestPos=pp
            bestRealDist=(pp-camPos).Magnitude
        end
    end
    cachedTarget=best; cachedTargetPos=bestPos; cachedDist=bestRealDist
end

-- ============================================================
--  REMOTES LOADER
-- ============================================================
local R={}
task.spawn(function()
    local rs=game:GetService("ReplicatedStorage")
    local function fw(parent,name,t)
        local ok,v=pcall(function() return parent:WaitForChild(name,t or 8) end)
        return ok and v or nil
    end
    local cr = (cloneref or function(x) return x end)
    local engine = fw(rs,"ACS_Engine")
    local events = engine and fw(engine,"Events")
    local pe     = fw(rs,"PlayerEvents")
    local med    = events and fw(events,"MedSys")

    if events then
        R.ServerBullet  = cr(events:FindFirstChild("ServerBullet"))
        R.Damage        = cr(events:FindFirstChild("Damage"))
        R.ServerGrenade = cr(events:FindFirstChild("ServerGrenade"))
        R.GunStance     = cr(events:FindFirstChild("GunStance"))
        R.Equip         = cr(events:FindFirstChild("Equip"))
        R.Refil         = cr(events:FindFirstChild("Refil"))
        R.SVFlash       = cr(events:FindFirstChild("SVFlash"))
        R.SVLaser       = cr(events:FindFirstChild("SVLaser"))
        R.NVG           = cr(events:FindFirstChild("NVG"))
        R.Surrender     = cr(events:FindFirstChild("Surrender"))
        R.Backpack      = cr(events:FindFirstChild("Backpack"))
        R.EditKillCond  = cr(events:FindFirstChild("EditKillConditions"))
        R.Stance        = cr(events:FindFirstChild("Stance"))
        R.DoorEvent     = cr(events:FindFirstChild("DoorEvent"))
        R.Drag          = cr(events:FindFirstChild("Drag"))
        R.Atirar        = cr(events:FindFirstChild("Atirar"))
    end
    if med then
        R.Collapse   = cr(med:FindFirstChild("Collapse"))
        R.MedHandler = cr(med:FindFirstChild("MedHandler"))
    end
    if pe then
        R.SpotPlayer         = cr(pe:FindFirstChild("SpotPlayer"))
        R.KillMe             = cr(pe:FindFirstChild("KillMe"))
        R.FakeBetaPurchase   = cr(pe:FindFirstChild("FakeBetaPurchase"))
        R.ClaimFreeStarter   = cr(pe:FindFirstChild("ClaimFreeStarterPack"))
        R.ClaimUGC           = cr(pe:FindFirstChild("ClaimUGC"))
        R.CompleteTutorial   = cr(pe:FindFirstChild("CompleteTutorial"))
        R.DropGiveAmmo       = cr(pe:FindFirstChild("DropGiveAmmo"))
        R.DropPickedUp       = cr(pe:FindFirstChild("DropPickedUp"))
        R.RequestTeleport    = cr(pe:FindFirstChild("RequestTeleport"))
        R.RedeemSpin         = cr(pe:FindFirstChild("RedeemSpin"))
        R.ToggleMusic        = cr(pe:FindFirstChild("ToggleMusic"))
        R.SpotPlayerEvt      = cr(pe:FindFirstChild("SpotPlayer"))
        R.RadarSubscription  = cr(pe:FindFirstChild("RadarSubscription"))
        R.ToggleGuide        = cr(pe:FindFirstChild("ToggleGuide"))
        R.RequestDeploy      = cr(pe:FindFirstChild("RequestDeploy"))
        R.RequestChooseTeam  = cr(pe:FindFirstChild("RequestChooseTeam"))
        R.VoteEvent          = cr(pe:FindFirstChild("VoteEvent"))
        R.StartQuest         = cr(pe:FindFirstChild("StartQuest"))
        R.ShouldEquip        = cr(pe:FindFirstChild("ShouldEquip"))
    end
    R.CollectCash     = cr(rs:FindFirstChild("CollectCashEvent"))
    R.AttemptDynPurch = cr(rs:FindFirstChild("AttemptDynamicPurchase"))
    R.AttemptGunPurch = cr(rs:FindFirstChild("AttemptGunPurchaseByMoney"))
    R.RequestVehicle  = cr(rs:FindFirstChild("RequestVehiclePurchaseEvent"))
    R.RequestHeli     = cr(rs:FindFirstChild("RequestHeliPurchaseEvent"))
    R.RequestPlane    = cr(rs:FindFirstChild("RequestPlanePurchaseEvent"))
    R.PromptPass      = cr(rs:FindFirstChild("PromptPassPurchaseEvent"))

    local loaded={}; for k,v in R do if v then loaded[#loaded+1]=k end end
    print("[SA v11] Remotes loaded: "..#loaded.." ("..table.concat(loaded,", ")..")")
end)

-- ============================================================
--  EXPLOIT UI  (ScreenGui through CoreGui inject)
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

    -- try inject into CoreGui (avoids reset), fallback PlayerGui
    local ok = pcall(function()
        sg.Parent = game:GetService("CoreGui")
    end)
    if not ok then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main frame
    local main = Instance.new("Frame",sg)
    main.Name = "Main"
    main.Size = UDim2.new(0,340,0,480)
    main.Position = UDim2.new(0.5,-170,0.5,-240)
    main.BackgroundColor3 = Color3.fromRGB(15,15,20)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true

    -- Corner rounding
    local corner = Instance.new("UICorner",main)
    corner.CornerRadius = UDim.new(0,8)

    -- Stroke
    local stroke = Instance.new("UIStroke",main)
    stroke.Color = Color3.fromRGB(60,120,255)
    stroke.Thickness = 1.5

    -- Title bar
    local title = Instance.new("TextLabel",main)
    title.Size = UDim2.new(1,0,0,36)
    title.BackgroundColor3 = Color3.fromRGB(20,20,35)
    title.BorderSizePixel = 0
    title.Text = "SilentAim v11  |  Exploit Panel"
    title.TextColor3 = Color3.fromRGB(80,180,255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    Instance.new("UICorner",title).CornerRadius=UDim.new(0,8)

    -- Status output label
    local statusLbl = Instance.new("TextLabel",main)
    statusLbl.Name = "Status"
    statusLbl.Size = UDim2.new(1,-20,0,22)
    statusLbl.Position = UDim2.new(0,10,0,38)
    statusLbl.BackgroundColor3 = Color3.fromRGB(10,10,15)
    statusLbl.BorderSizePixel = 0
    statusLbl.Text = "Status: Ready"
    statusLbl.TextColor3 = Color3.fromRGB(180,180,180)
    statusLbl.TextSize = 12
    statusLbl.Font = Enum.Font.Code
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.TextTruncate = Enum.TextTruncate.AtEnd
    Instance.new("UICorner",statusLbl).CornerRadius=UDim.new(0,4)

    local function setStatus(msg, col)
        statusLbl.Text = ">> "..msg
        statusLbl.TextColor3 = col or Color3.fromRGB(80,255,120)
    end

    -- Scroll frame for buttons
    local scroll = Instance.new("ScrollingFrame",main)
    scroll.Size = UDim2.new(1,-10,1,-70)
    scroll.Position = UDim2.new(0,5,0,66)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(60,120,255)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout",scroll)
    layout.Padding = UDim.new(0,4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local padding = Instance.new("UIPadding",scroll)
    padding.PaddingLeft = UDim.new(0,4)
    padding.PaddingRight = UDim.new(0,4)
    padding.PaddingTop = UDim.new(0,4)

    -- Section header helper
    local secOrder = 0
    local function section(text)
        secOrder=secOrder+1
        local lbl = Instance.new("TextLabel",scroll)
        lbl.Size = UDim2.new(1,0,0,20)
        lbl.BackgroundColor3 = Color3.fromRGB(30,30,50)
        lbl.BorderSizePixel = 0
        lbl.Text = "  "..text
        lbl.TextColor3 = Color3.fromRGB(100,160,255)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = secOrder
        Instance.new("UICorner",lbl).CornerRadius=UDim.new(0,4)
    end

    -- Button helper
    local btnOrder = 0
    local function btn(label, desc, fn)
        btnOrder=btnOrder+1
        local f = Instance.new("Frame",scroll)
        f.Size = UDim2.new(1,0,0,46)
        f.BackgroundColor3 = Color3.fromRGB(22,22,32)
        f.BorderSizePixel = 0
        f.LayoutOrder = btnOrder
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)

        local b = Instance.new("TextButton",f)
        b.Size = UDim2.new(0,90,0,28)
        b.Position = UDim2.new(1,-98,0.5,-14)
        b.BackgroundColor3 = Color3.fromRGB(40,90,200)
        b.BorderSizePixel = 0
        b.Text = label
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextSize = 12
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)

        local d = Instance.new("TextLabel",f)
        d.Size = UDim2.new(1,-106,1,0)
        d.Position = UDim2.new(0,8,0,0)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = Color3.fromRGB(160,160,180)
        d.TextSize = 11
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextWrapped = true

        b.MouseButton1Click:Connect(function()
            b.BackgroundColor3 = Color3.fromRGB(20,60,140)
            local ok2,err=pcall(fn,setStatus)
            if not ok2 then setStatus("ERROR: "..tostring(err):sub(1,60), Color3.fromRGB(255,80,80)) end
            task.delay(0.3, function()
                b.BackgroundColor3 = Color3.fromRGB(40,90,200)
            end)
        end)

        -- hover effect
        b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(55,110,220) end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(40,90,200) end)
    end

    -- ==== SECTIONS ====

    section("== FLASH / VISUAL EFFECTS ==")
    btn("SVFlash ALL", "Flash grenade effect for all players", function(s)
        assert(R.SVFlash,"SVFlash remote not found")
        local camCF = Camera.CFrame
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function()
                    R.SVFlash:FireServer(pl, camCF.Position, 3, true)
                end) end)
            end
        end
        s("SVFlash sent to "..(#Players:GetPlayers()-1).." players")
    end)

    btn("NVG All", "Force NVG toggle on all players", function(s)
        assert(R.NVG,"NVG remote not found")
        for i=1,5 do pcall(function() R.NVG:FireServer(true) end) end
        s("NVG toggled x5")
    end)

    btn("SVLaser ALL", "Laser sight visual on all", function(s)
        assert(R.SVLaser,"SVLaser remote not found")
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function()
                    R.SVLaser:FireServer(pl, true, Color3.fromRGB(255,0,0))
                end) end)
            end
        end
        s("SVLaser sent")
    end)

    section("== PROGRESSION / ECONOMY ==")
    btn("FakeBetaPurch", "FakeBetaPurchase (no args)", function(s)
        assert(R.FakeBetaPurchase,"FakeBetaPurchase not found")
        pcall(function() R.FakeBetaPurchase:FireServer() end)
        s("FakeBetaPurchase fired")
    end)

    btn("ClaimStarter", "Claim free starter pack (spam x3)", function(s)
        assert(R.ClaimFreeStarter,"ClaimFreeStarterPack not found")
        for _=1,3 do task.spawn(function() pcall(function() R.ClaimFreeStarter:FireServer() end) end) end
        s("ClaimFreeStarterPack x3 fired")
    end)

    btn("ClaimUGC", "Claim UGC item (no args)", function(s)
        assert(R.ClaimUGC,"ClaimUGC not found")
        pcall(function() R.ClaimUGC:FireServer() end)
        s("ClaimUGC fired")
    end)

    btn("CollectCash", "CollectCashEvent spam x10", function(s)
        assert(R.CollectCash,"CollectCashEvent not found")
        for _=1,10 do task.spawn(function() pcall(function() R.CollectCash:FireServer() end) end) end
        s("CollectCashEvent x10")
    end)

    btn("RedeemSpin", "RedeemSpin (free spin attempt)", function(s)
        assert(R.RedeemSpin,"RedeemSpin not found")
        pcall(function() R.RedeemSpin:InvokeServer() end)
        s("RedeemSpin fired")
    end)

    btn("CompleteTut", "CompleteTutorial + reward", function(s)
        assert(R.CompleteTutorial,"CompleteTutorial not found")
        pcall(function() R.CompleteTutorial:FireServer() end)
        s("CompleteTutorial fired")
    end)

    btn("AttemptGun0$", "Buy gun with 0 money (no sanity?)", function(s)
        assert(R.AttemptGunPurch,"AttemptGunPurchaseByMoney not found")
        local guns={"AK-47","M4A1","G19X","MP5","AWM","M249"}
        for _,g in ipairs(guns) do
            task.spawn(function() pcall(function() R.AttemptGunPurch:FireServer(g,0) end) end)
        end
        s("AttemptGunPurchase x"..#guns.." (0$)")
    end)

    btn("RequestVeh", "Spawn vehicle (no payment)", function(s)
        assert(R.RequestVehicle,"RequestVehiclePurchaseEvent not found")
        local vehs={"Humvee","BRDM","Truck","LAV"}
        for _,v in ipairs(vehs) do
            task.spawn(function() pcall(function() R.RequestVehicle:FireServer(v,0) end) end)
        end
        s("RequestVehicle x"..#vehs)
    end)

    btn("RequestHeli", "Spawn helicopter (no payment)", function(s)
        assert(R.RequestHeli,"RequestHeliPurchaseEvent not found")
        local helis={"AH-1Z Viper","UH-60 Black Hawk","MH-6 Little Bird"}
        for _,h in ipairs(helis) do
            task.spawn(function() pcall(function() R.RequestHeli:FireServer(h,0) end) end)
        end
        s("RequestHeli x"..#helis)
    end)

    section("== PLAYER MANIPULATION ==")
    btn("Collapse ALL", "MedSys.Collapse -> down all enemies", function(s)
        assert(R.Collapse,"MedSys.Collapse not found")
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function() R.Collapse:FireServer(pl) end) end)
                n=n+1
            end
        end
        s("Collapse sent to "..n.." players")
    end)

    btn("Surrender ALL", "Force Surrender on all", function(s)
        assert(R.Surrender,"Surrender not found")
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=LocalPlayer then
                task.spawn(function() pcall(function() R.Surrender:FireServer(pl) end) end)
            end
        end
        s("Surrender fired for all")
    end)

    btn("Drag Target", "Drag nearest enemy", function(s)
        assert(R.Drag,"Drag not found")
        if not cachedTarget then s("No target in FOV", Color3.fromRGB(255,180,50)); return end
        local char=cachedTarget.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function() R.Drag:FireServer(root) end)
            s("Drag -> "..cachedTarget.Name)
        end
    end)

    btn("KillMe", "PlayerEvents.KillMe", function(s)
        assert(R.KillMe,"KillMe not found")
        pcall(function() R.KillMe:FireServer() end)
        s("KillMe fired")
    end)

    btn("DropAmmo", "DropGiveAmmo at position", function(s)
        assert(R.DropGiveAmmo,"DropGiveAmmo not found")
        local char=LocalPlayer.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local pos=root and root.Position or Vector3.new(0,5,0)
        pcall(function() R.DropGiveAmmo:FireServer(pos) end)
        s("DropGiveAmmo at "..tostring(pos))
    end)

    btn("Equip AK47", "Force equip AK-47 via Backpack remote", function(s)
        assert(R.Backpack,"Backpack remote not found")
        pcall(function() R.Backpack:FireServer("AK-47") end)
        pcall(function() R.Equip:FireServer("AK-47") end)
        s("Backpack+Equip AK-47 fired")
    end)

    section("== SERVER EFFECTS ==")
    btn("RefillAmmo", "ACS Refil -> refill own ammo server", function(s)
        assert(R.Refil,"Refil not found")
        for _=1,3 do task.spawn(function() pcall(function() R.Refil:FireServer() end) end) end
        s("Refil x3 fired")
    end)

    btn("GunStance", "GunStance toggle (server anim)", function(s)
        assert(R.GunStance,"GunStance not found")
        pcall(function() R.GunStance:FireServer(true) end)
        s("GunStance(true) fired")
    end)

    btn("OpenDoors", "DoorEvent - try open all doors", function(s)
        assert(R.DoorEvent,"DoorEvent not found")
        local n=0
        for _,v in workspace:GetDescendants() do
            if v.Name:lower():find("door") and v:IsA("Model") then
                task.spawn(function() pcall(function() R.DoorEvent:FireServer(v,true) end) end)
                n=n+1
            end
        end
        s("DoorEvent sent for "..n.." door models")
    end)

    btn("CrashAllHeli", "Crash all helicopters", function(s)
        local rs2=game:GetService("ReplicatedStorage")
        local helis=rs2:FindFirstChild("Helicopters")
        if not helis then s("Helicopters folder not found", Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,heli in helis:GetChildren() do
            local net=heli:FindFirstChild("Networking")
            local ce=net and net:FindFirstChild("CrashEvent")
            if ce then pcall(function() ce:FireServer() end); n=n+1 end
        end
        s("CrashEvent fired for "..n.." helis")
    end)

    btn("ToggleMusic", "Toggle server music OFF", function(s)
        assert(R.ToggleMusic,"ToggleMusic not found")
        pcall(function() R.ToggleMusic:FireServer(false) end)
        s("ToggleMusic(false) fired")
    end)

    btn("RadarSub", "Subscribe radar (see all enemies on radar?)", function(s)
        assert(R.RadarSubscription,"RadarSubscription not found")
        pcall(function() R.RadarSubscription:FireServer(true) end)
        s("RadarSubscription(true) fired")
    end)

    -- close btn
    local closeBtn = Instance.new("TextButton",main)
    closeBtn.Size = UDim2.new(0,24,0,24)
    closeBtn.Position = UDim2.new(1,-28,0,6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,4)
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false; uiVisible=false
    end)

    exploitUI = main
end

local function toggleUI()
    if not exploitUI then buildExploitUI() end
    uiVisible = not uiVisible
    exploitUI.Visible = uiVisible
end

-- ============================================================
--  GC REFS (weapon switch only)
-- ============================================================
local u7Ref=nil; local infAmmoFns={}

local function refreshGunRefs()
    u7Ref=nil; infAmmoFns={}
    local gc = getgc(true)
    for _,obj in gc do
        if type(obj)~="table" then continue end
        if rawget(obj,"ShootRate")~=nil and rawget(obj,"ShootType")~=nil then
            u7Ref=obj
            if not u7Ref._origShootRate then u7Ref._origShootRate=u7Ref.ShootRate end
            if not u7Ref._origShootType then u7Ref._origShootType=u7Ref.ShootType end
            break
        end
    end
    -- InfAmmo: find ammo counter upvalues
    -- FIXED: only hook functions that manage bullet counts, skip animation functions
    -- detect by checking upvalue names for ammo-related identifiers
    for _,f in getgc(false) do
        if type(f)~="function" then continue end
        local ok,info=pcall(debug.getinfo,f)
        if not ok or not info then continue end
        -- skip functions with too many upvalues (likely animation/physics)
        local nups=info.nups or 0
        if nups==0 or nups>20 then continue end
        local ok2,uvs=pcall(debug.getupvalues,f)
        if not ok2 then continue end
        local hasMagCount=false; local hasTable=false
        for _,uv in pairs(uvs) do
            if type(uv)=="number" and uv>=0 and uv<=999 then hasMagCount=true end
            if type(uv)=="table" and rawget(uv,"ShootRate")~=nil then hasTable=true end
        end
        if hasMagCount and hasTable then infAmmoFns[#infAmmoFns+1]=f end
    end
    print(string.format("[SA v11] GunRefs: u7=%s InfFns=%d", tostring(u7Ref~=nil), #infAmmoFns))
end

-- ============================================================
--  FORCEFIELD VIEWMODEL
-- ============================================================
local ffApplied = false

local function applyFFToTool(tool, enable)
    if not tool then return end
    for _,p in tool:GetDescendants() do
        if p:IsA("BasePart") and not p:IsA("UnionOperation") then
            pcall(function()
                if enable then
                    p.Material = Enum.Material.ForceField
                    p.Color    = Color3.fromRGB(30,180,220)
                else
                    p.Material = Enum.Material.SmoothPlastic
                    p.Color    = Color3.fromRGB(163,162,165)
                end
            end)
        end
    end
    -- also handle UnionOperations
    for _,p in tool:GetDescendants() do
        if p:IsA("UnionOperation") then
            pcall(function()
                if enable then
                    p.Material = Enum.Material.ForceField
                    p.Color    = Color3.fromRGB(30,180,220)
                end
            end)
        end
    end
    ffApplied = enable
end

-- Watch for tool equip/unequip
task.spawn(function()
    local lastTool=nil
    while task.wait(0.25) do
        local char=LocalPlayer.Character
        if not char then lastTool=nil; continue end
        local tool=char:FindFirstChildOfClass("Tool")
        if tool~=lastTool then
            lastTool=tool
            if tool then
                task.wait(0.15) -- wait for tool to fully load
                refreshGunRefs()
                if CFG.FullAuto and u7Ref then u7Ref.ShootRate=99999 end
                if CFG.FireRate and u7Ref then u7Ref.ShootRate=CFG.FireRate end
                if CFG.FFViewModel then applyFFToTool(tool,true) end
            else
                ffApplied=false
            end
        end
    end
end)

-- ============================================================
--  HEARTBEAT
-- ============================================================
RunService.Heartbeat:Connect(function()
    -- InfAmmo: only set bullet count values, don't touch animation upvalues
    if CFG.InfAmmo then
        for _,f in infAmmoFns do
            local ok,uvs=pcall(debug.getupvalues,f)
            if not ok then continue end
            for idx,val in pairs(uvs) do
                -- only override values that look like mag/bullet counts (1-999)
                if type(val)=="number" and val>=0 and val<=999 then
                    pcall(debug.setupvalue,f,idx,9999)
                end
            end
        end
    end

    -- KillAllSpam
    if CFG.KillAllSpam and R.Damage then
        local myChar=LocalPlayer.Character
        local origin=myChar and myChar:FindFirstChild("HumanoidRootPart")
            and myChar.HumanoidRootPart.Position or Camera.CFrame.Position
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function()
                local char=pl.Character; if not char then return end
                local hum=char:FindFirstChildOfClass("Humanoid")
                local hp=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if not hum or not hp or hum.Health<=0 then return end
                local sd={weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                    maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                    origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,999999)}
                pcall(function() R.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
            end)
        end
    end

    -- GrenadeSpam
    if CFG.GrenadeSpam and R.ServerGrenade then
        local origin=Camera.CFrame.Position
        local target=cachedTargetPos or (origin+Camera.CFrame.LookVector*50)
        local dir=(target-origin).Unit
        pcall(function()
            R.ServerGrenade:FireServer(origin,dir,{
                shellType="Grenade",shellName="M67",shellSpeed=50,
                origin=origin,bulletID=LocalPlayer.UserId..tick()
            })
        end)
    end
end)

-- SpotAll
task.spawn(function()
    while task.wait(2) do
        if CFG.SpotAll and R.SpotPlayerEvt then
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LocalPlayer then
                    task.spawn(function() pcall(function() R.SpotPlayerEvt:FireServer(pl) end) end)
                end
            end
        end
    end
end)

-- ============================================================
--  SHOOT MODULE HOOK
-- ============================================================
local function hookShootModule()
    local SM=nil
    for _,obj in getgc(true) do
        if type(obj)~="table" then continue end
        local f=rawget(obj,"fire")
        if type(f)~="function" then continue end
        local ok,info=pcall(debug.getinfo,f)
        if ok and info and (info.nups or 0)>=5 then SM=obj; break end
    end
    if not SM then warn("[SA v11] ShootModule not found"); return end

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

    local origFire=SM.fire
    SM.fire=newcclosure(function(pl,origin,direction,shellData,extra)
        if CFG.Enabled and pl==LocalPlayer then
            -- SilentAim: redirect direction
            if CFG.SilentAim and cachedTargetPos then
                local t=cachedTargetPos-origin
                if t.Magnitude>0 then direction=t.Unit end
            end
            -- BulletTP
            if CFG.BulletTP and type(shellData)=="table" then shellData.shellSpeed=9e9 end
            -- Bullet Tracer: store 3D positions
            if CFG.ShowTracer then
                local mp3d = getMuzzleWorldPos() or origin
                local ep3d = cachedTargetPos or (origin+direction*500)
                spawnTracer(mp3d, ep3d)
            end
            -- ForceHit
            if CFG.ForceHit and cachedTarget and R.Damage then
                task.defer(function()
                    local char=cachedTarget and cachedTarget.Character; if not char then return end
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    local hp=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if not hum or not hp or hum.Health<=0 then return end
                    local sd2={weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                        maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                        origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,99999)}
                    pcall(function() R.Damage:InvokeServer(sd2,hum,(hp.Position-origin).Magnitude,1,hp) end)
                end)
            end
        end
        return origFire(pl,origin,direction,shellData,extra)
    end)
    print("[SA v11] ShootModule hooked")
end

local function hookNamecall()
    local origNC
    origNC=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local method=getnamecallmethod()
        if CFG.Enabled and cachedTargetPos and method=="FireServer" then
            local ok,nm=pcall(function() return self.Name end)
            if ok and nm=="ServerBullet" then
                local args=table.pack(...)
                local oIdx,dIdx
                for i=1,args.n do
                    if typeof(args[i])=="Vector3" then
                        if not oIdx then oIdx=i elseif not dIdx then dIdx=i; break end
                    end
                end
                if dIdx then
                    local origin=oIdx and args[oIdx] or Camera.CFrame.Position
                    local t=cachedTargetPos-origin
                    if t.Magnitude>0 then args[dIdx]=t.Unit end
                end
                if type(args[3])=="table" and CFG.BulletTP then args[3].shellSpeed=9e9 end
                return origNC(self,table.unpack(args,1,args.n))
            end
        end
        return origNC(self,...)
    end))
    print("[SA v11] hookmetamethod OK")
end

-- ============================================================
--  KILL ALL
-- ============================================================
local function doKillAll()
    if not R.Damage then warn("[SA v11] Damage remote not ready"); return end
    local myChar=LocalPlayer.Character
    local origin=myChar and myChar:FindFirstChild("HumanoidRootPart")
        and myChar.HumanoidRootPart.Position or Camera.CFrame.Position
    local n=0
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        task.spawn(function()
            local char=pl.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid")
            local hp=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if not hum or not hp or hum.Health<=0 then return end
            local sd={weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,999999)}
            for _=1,5 do
                pcall(function() R.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
            end
        end)
        n=n+1
    end
    print("[SA v11] KillAll -> "..n)
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    _fc=_fc+1; local upd=(_fc%2==0)
    if upd then updateCache() end
    swAngle=swAngle+0.05

    -- STATUS
    local function b(v) return v and "ON" or "--" end
    dStatus.Text=string.format(
        "SA:%s BTP:%s WB:%s FH:%s IA:%s FA:%s FF:%s | KAS:%s GS:%s SP:%s",
        b(CFG.SilentAim and CFG.Enabled),b(CFG.BulletTP),b(CFG.WallBang),
        b(CFG.ForceHit),b(CFG.InfAmmo),b(CFG.FullAuto),b(CFG.FFViewModel),
        b(CFG.KillAllSpam),b(CFG.GrenadeSpam),b(CFG.SpotAll))
    dStatus.Color=CFG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)

    -- FOV circle
    dFOV.Position=screenCenter(); dFOV.Radius=CFG.FOV
    dFOV.Visible=CFG.ShowFOV and CFG.Enabled
    dFOV.Color=(cachedTarget and CFG.EnemyColor) or CFG.FOVColor

    -- TRACER FADE: update WorldToViewport every frame + fade Transparency
    local now=tick(); local i=1
    while i<=#tracers do
        local tr=tracers[i]; local age=now-tr.born
        if age>TRACER_LIFE then
            tr.line:Remove(); table.remove(tracers,i)
        else
            -- re-project 3D pos to screen every frame so it follows camera
            local sp1,v1=w2s(tr.from3d); local sp2,v2=w2s(tr.to3d)
            if v1 then
                tr.line.Visible=true
                tr.line.From=sp1; tr.line.To=sp2
                -- Transparency 0 = opaque, 1 = invisible
                tr.line.Transparency=age/TRACER_LIFE
            else
                tr.line.Visible=false
            end
            i=i+1
        end
    end

    -- AIM LINE (gun muzzle -> target), updated 3D->2D every frame
    if CFG.ShowAimLine and CFG.Enabled and cachedTargetPos then
        local mp=getMuzzleWorldPos()
        if mp then
            local sp1,v1=w2s(mp); local sp2,_=w2s(cachedTargetPos)
            if v1 then
                aimLine.Visible=true
                aimLine.From=sp1; aimLine.To=sp2
                aimLine.Color=hsvToRgb((_fc*0.01)%1,1,1)
            else aimLine.Visible=false end
        else aimLine.Visible=false end
    else aimLine.Visible=false end

    if not upd then return end

    -- SWASTIKA around closest target
    if CFG.ShowSwastika and CFG.Enabled and cachedTargetPos then
        local sp,vis=w2s(cachedTargetPos)
        if vis then
            local d=math.max(cachedDist,1)
            local sz=math.clamp(2200/d, 20, 70)
            local col=hsvToRgb((tick()*0.6)%1,1,1)
            drawSwastika(sp, sz, swAngle, col)
        else hideSwastika() end
    else hideSwastika() end

    if not CFG.ESPEnabled then
        for _,e in espCache do hideESP(e) end
        return
    end

    -- PER-PLAYER ESP
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        local e=getESP(pl)
        local char=pl.Character
        if not char then hideESP(e); continue end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hum then hideESP(e); continue end

        local root=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        local lfoot=char:FindFirstChild("LeftFoot")
              or char:FindFirstChild("RightFoot")
              or char:FindFirstChild("Left Leg")

        if not root or not head then hideESP(e); continue end

        local _,rootVis=w2s(root.Position)
        if not rootVis then hideESP(e); continue end

        local hp=math.clamp(math.floor(hum.Health),0,100)
        local col=isTeammate(pl) and CFG.TeamColor or CFG.EnemyColor

        -- Full-body bounding box: head top -> feet bottom
        local headTop = head.Position + Vector3.new(0, head.Size.Y*0.5+0.1, 0)
        local feetBot = lfoot
            and (lfoot.Position - Vector3.new(0, lfoot.Size.Y*0.5, 0))
            or  (root.Position  - Vector3.new(0, 3.2, 0))

        local spHead,_ = w2s(headTop)
        local spFeet,_ = w2s(feetBot)

        local boxH = math.abs(spFeet.Y - spHead.Y)
        if boxH < 5 then hideESP(e); continue end
        local boxW = boxH * 0.42
        local tl = Vector2.new(spHead.X - boxW, spHead.Y)
        local br = Vector2.new(spHead.X + boxW, spFeet.Y)
        local dist = math.floor((root.Position-Camera.CFrame.Position).Magnitude)

        if CFG.ShowBox then
            drawBox(e, tl, br, col)
            if CFG.ShowHP then drawHPBar(e, tl, br, hp)
            else e.hpBg.Visible=false; e.hpFill.Visible=false end

            if CFG.ShowName then
                e.name.Visible=true
                e.name.Position=Vector2.new(spHead.X, tl.Y-15)
                e.name.Text=pl.Name; e.name.Color=col
            else e.name.Visible=false end

            if CFG.ShowDist then
                e.dist.Visible=true
                e.dist.Position=Vector2.new(spHead.X, br.Y+3)
                e.dist.Text=dist.."m"
            else e.dist.Visible=false end

            if CFG.ShowState then
                local st=getPlayerState(char,hum)
                if st~="" then
                    e.state.Visible=true; e.state.Text=st
                    e.state.Position=Vector2.new(spHead.X, br.Y+14)
                else e.state.Visible=false end
            else e.state.Visible=false end
        else
            for _,l in e.boxLines do l.Visible=false end
            e.hpBg.Visible=false; e.hpFill.Visible=false
            e.name.Visible=false; e.dist.Visible=false; e.state.Visible=false
        end

        if CFG.ShowSkeleton and hp>0 then
            drawSkeleton(e, char, col)
        else
            for _,l in e.skelLines do l.Visible=false end
            e.headCircle.Visible=false
        end
    end
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
local function notify(t,m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=t,Text=m,Duration=2})
    end)
end

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    local k=input.KeyCode
    if k==Enum.KeyCode.Insert then
        CFG.Enabled=not CFG.Enabled; notify("SilentAim v11",CFG.Enabled and "ON" or "OFF")
    elseif k==Enum.KeyCode.Delete then
        CFG.BulletTP=not CFG.BulletTP; notify("BulletTP",CFG.BulletTP and "ON" or "OFF")
    elseif k==Enum.KeyCode.End then
        CFG.WallBang=not CFG.WallBang; notify("WallBang",CFG.WallBang and "ON" or "OFF")
    elseif k==Enum.KeyCode.Home then
        CFG.ForceHit=not CFG.ForceHit; notify("ForceHit",CFG.ForceHit and "ON" or "OFF")
    elseif k==Enum.KeyCode.F5 then
        CFG.InfAmmo=not CFG.InfAmmo; notify("InfAmmo",CFG.InfAmmo and "ON" or "OFF")
    elseif k==Enum.KeyCode.F6 then
        CFG.FullAuto=not CFG.FullAuto
        if u7Ref then
            if CFG.FullAuto then
                -- FullAuto: set ShootRate to very high, DO NOT change ShootType (breaks ViewModel)
                u7Ref.ShootRate = 99999
            else
                u7Ref.ShootRate = u7Ref._origShootRate or u7Ref.ShootRate
            end
        end
        notify("FullAuto",CFG.FullAuto and "ON" or "OFF")
    elseif k==Enum.KeyCode.F7 then
        CFG.FFViewModel=not CFG.FFViewModel
        local char=LocalPlayer.Character
        local tool=char and char:FindFirstChildOfClass("Tool")
        applyFFToTool(tool, CFG.FFViewModel)
        notify("FF ViewModel",CFG.FFViewModel and "ON" or "OFF")
    elseif k==Enum.KeyCode.F8 then
        CFG.ShowTracer=not CFG.ShowTracer; notify("BulletTracer",CFG.ShowTracer and "ON" or "OFF")
    elseif k==Enum.KeyCode.F9 then
        CFG.ShowAimLine=not CFG.ShowAimLine; notify("AimLine",CFG.ShowAimLine and "ON" or "OFF")
    elseif k==Enum.KeyCode.F10 then
        notify("KillAll","..."); task.spawn(doKillAll)
    elseif k==Enum.KeyCode.F11 then
        CFG.KillAllSpam=not CFG.KillAllSpam; notify("KillAllSpam",CFG.KillAllSpam and "ON" or "OFF")
    elseif k==Enum.KeyCode.F12 then
        CFG.SpotAll=not CFG.SpotAll; notify("SpotAll",CFG.SpotAll and "ON" or "OFF")
    elseif k==Enum.KeyCode.KeypadZero then
        CFG.GrenadeSpam=not CFG.GrenadeSpam; notify("GrenadeSpam",CFG.GrenadeSpam and "ON" or "OFF")
    elseif k==Enum.KeyCode.KeypadOne then
        local rs2=game:GetService("ReplicatedStorage")
        local helis=rs2:FindFirstChild("Helicopters")
        if helis then
            for _,heli in helis:GetChildren() do
                local net=heli:FindFirstChild("Networking")
                local ce=net and net:FindFirstChild("CrashEvent")
                if ce then pcall(function() ce:FireServer() end) end
            end
        end
        notify("CrashAllHeli","sent")
    elseif k==Enum.KeyCode.RightControl then
        toggleUI()
    elseif k==Enum.KeyCode.PageUp then
        CFG.FOV=math.min(CFG.FOV+50,800); dFOV.Radius=CFG.FOV; notify("FOV","= "..CFG.FOV)
    elseif k==Enum.KeyCode.PageDown then
        CFG.FOV=math.max(CFG.FOV-50,50); dFOV.Radius=CFG.FOV; notify("FOV","= "..CFG.FOV)
    end
end)

-- ============================================================
--  INIT
-- ============================================================
task.spawn(function()
    task.wait(1.5)
    hookShootModule()
    hookNamecall()
    task.wait(0.3)
    refreshGunRefs()
    print("[SA v11] Init complete")
    notify("SilentAim v11","Loaded! RCtrl = Exploit UI")
end)
