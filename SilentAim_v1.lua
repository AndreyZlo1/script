--[[
╔══════════════════════════════════════════════════════════════╗
║              SilentAim v10  --  ACS Engine                  ║
║  GitHub: AndreyZlo1/script  |  base: SilentAim_v1 (5d773f3)║
╠══════════════════════════════════════════════════════════════╣
║  REMOVED:  FullAuto (broke ViewModel), ToggleMusic,         ║
║            SquadKickAll, NoAirPenalty (все бред)            ║
║  FIXED:    Box ESP теперь от Head до Feet (полный рост)     ║
║  ADDED:    Skeleton с Circle головой                        ║
║            RGB-свастика вокруг цели (AimWare-стиль)         ║
║            Aim Line: от дула оружия → цель скрипта         ║
║            ForceField ViewModel (weapon skin)               ║
║            Bullet Tracer с Fade анимацией                   ║
║            GrenadeSpam, KillAll, SpotAll, InfAmmo           ║
║            BulletTP, WallBang, ForceHit, SilentAim          ║
╠══════════════════════════════════════════════════════════════╣
║  BINDS:                                                     ║
║  Insert   = SilentAim on/off                                ║
║  Delete   = BulletTP on/off                                 ║
║  End      = WallBang on/off                                 ║
║  Home     = ForceHit on/off                                 ║
║  F5       = InfAmmo on/off                                  ║
║  F6       = FireRate x2 (toggle)                            ║
║  F7       = ForceField ViewModel on/off                     ║
║  F8       = BulletTracer on/off                             ║
║  F9       = AimLine on/off                                  ║
║  F10      = KillAll (разовый)                               ║
║  F11      = KillAllSpam (Heartbeat toggle)                  ║
║  F12      = SpotAll toggle                                  ║
║  Numpad0  = GrenadeSpam toggle                              ║
║  Numpad1  = CrashAllHeli                                    ║
║  PgUp/Dn  = FOV +/-50                                       ║
╚══════════════════════════════════════════════════════════════╝

  ЭКСПЛОЙТЫ ИЗ ДАМПА (информационно, не реализованы автоматом):
  ─────────────────────────────────────────────────────────────
  ReplicatedStorage.CollectCashEvent  ← FireServer() в цикле → дюп кэша
  ReplicatedStorage.PlayerEvents.DropPickedUp ← подбирать дропы других
  ReplicatedStorage.PlayerEvents.FakeBetaPurchase ← (пробуй без аргументов)
  ReplicatedStorage.PlayerEvents.ClaimFreeStarterPack ← спамить
  ReplicatedStorage.PlayerEvents.ClaimUGC ← бесплатный UGC
  ReplicatedStorage.AttemptGunPurchaseByMoney ← пробовать с 0$ аргументом
  ReplicatedStorage.RequestVehiclePurchaseEvent ← спамить спавн техники
  ReplicatedStorage.ACS_Engine.Events.Refil ← бесконечный амуниция-рефил
  ReplicatedStorage.ACS_Engine.Events.Equip ← экипировать любое оружие
  ReplicatedStorage.ACS_Engine.Events.SVFlash/SVLaser ← флеш всем игрокам
  ReplicatedStorage.MinigameEvents.TeleportTo ← телепорт (проверь args)
  ReplicatedStorage.PlayerEvents.CompleteTutorial ← скип туториала + награда
  ReplicatedStorage.PlayerEvents.KillMe ← суицид-троллинг
  ReplicatedStorage.ACS_Engine.Events.Surrender ← заставить сдаться другого?
  ReplicatedStorage.ACS_Engine.Events.Drag ← таскать тела

  ВИЗУАЛЬНЫЕ ИДЕИ (не реализованы, список):
  ─────────────────────────────────────────
  • Chams: заменить Material всего персонажа на Neon + прозрачность
  • SoundESP: Drawing.Text с иконкой 🔊 над игроком если он стреляет
  • 3D FOV Circle: Circle в WorldSpace (через AdornmentGui или Part)
  • SnapLine: линия от нижнего края экрана к ближайшей цели
  • GrenadePredict: рисовать дугу полёта гранаты
  • VehicleESP: отдельный цвет/иконка для транспорта
  • AdminRadar: мини-карта Drawing поверх UI
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

    -- Aim
    SilentAim  = true,
    BulletTP   = true,
    WallBang   = true,
    ForceHit   = false,

    -- Ammo
    InfAmmo  = false,
    FireRate  = nil,   -- nil = stock, number = override

    -- ESP
    ESPEnabled   = true,
    ShowBox      = true,
    ShowSkeleton = true,
    ShowName     = true,
    ShowHP       = true,
    ShowDist     = true,
    ShowState    = true,
    ShowFOV      = true,
    ShowSwastika = true,   -- RGB rotating swastika around target
    ShowAimLine  = true,   -- line from gun muzzle → aim point
    ShowTracer   = true,   -- bullet tracer (my bullets only)

    TeamColor  = Color3.fromRGB(0,200,255),
    EnemyColor = Color3.fromRGB(255,60,60),
    FOVColor   = Color3.fromRGB(255,255,255),

    -- Exploits
    KillAllSpam = false,
    SpotAll     = false,
    GrenadeSpam = false,

    -- ViewModel
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
--  HUD
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
--  ESP POOL
-- ============================================================
local espCache = {}

local function makeESP()
    local e = {}
    -- Corner box: 8 short lines
    e.boxLines = {}
    for i=1,8 do e.boxLines[i]=D("Line",{Visible=false,Thickness=1.5,
        Color=Color3.fromRGB(255,255,255),Transparency=0.8}) end
    -- HP bar
    e.hpBg   = D("Line",{Visible=false,Thickness=5,Color=Color3.fromRGB(0,0,0),Transparency=0.4})
    e.hpFill = D("Line",{Visible=false,Thickness=3,Color=Color3.fromRGB(0,255,80),Transparency=0.8})
    -- Labels
    e.name   = D("Text",{Visible=false,Size=13,Color=Color3.fromRGB(255,255,255),
                Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.dist   = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(200,200,200),
                Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.state  = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(255,200,50),
                Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    -- Skeleton (12 bones + 1 head circle)
    e.skelLines = {}
    for i=1,12 do e.skelLines[i]=D("Line",{Visible=false,Thickness=1,
        Color=Color3.fromRGB(255,255,255),Transparency=0.7}) end
    e.headCircle = D("Circle",{Visible=false,Filled=false,Thickness=1.5,
        Radius=10,Color=Color3.fromRGB(255,255,255),Transparency=0.7})
    return e
end

local function removeESP(e)
    for _,l in e.boxLines do l:Remove() end
    for _,l in e.skelLines do l:Remove() end
    e.hpBg:Remove(); e.hpFill:Remove()
    e.name:Remove(); e.dist:Remove(); e.state:Remove()
    e.headCircle:Remove()
end

local function getESP(pl)
    if not espCache[pl] then espCache[pl]=makeESP() end
    return espCache[pl]
end
Players.PlayerRemoving:Connect(function(pl)
    if espCache[pl] then removeESP(espCache[pl]); espCache[pl]=nil end
end)

-- ============================================================
--  RGB SWASTIKA (AimWare-style) around target
-- ============================================================
-- 4 arms drawn as lines, rotating, rainbow color
local swLines = {}
for i=1,8 do
    swLines[i] = D("Line",{Visible=false,Thickness=2.5,
        Color=Color3.fromRGB(255,0,0),Transparency=0.0})
end
local swAngle = 0

-- Aim line: gun muzzle → predicted target
local aimLine = D("Line",{Visible=false,Thickness=1.5,
    Color=Color3.fromRGB(255,255,255),Transparency=0.4})

-- ============================================================
--  BULLET TRACERS
-- ============================================================
local tracers = {}   -- {line, alpha, born}
local TRACER_LIFE = 0.6  -- seconds

local function spawnTracer(from2d, to2d)
    local l = D("Line",{Visible=true,Thickness=1.5,
        From=from2d, To=to2d,
        Color=Color3.fromRGB(255,220,60),Transparency=0.0})
    table.insert(tracers,{line=l,born=tick()})
end

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
    return LocalPlayer.Team~=nil and LocalPlayer.Team==pl.Team
end
local function hsvToRgb(h,s,v)
    local r,g,b
    local i=math.floor(h*6); local f=h*6-i; local p=v*(1-s)
    local q=v*(1-f*s); local t=v*(1-(1-f)*s)
    i=i%6
    if i==0 then r,g,b=v,t,p elseif i==1 then r,g,b=q,v,p
    elseif i==2 then r,g,b=p,v,t elseif i==3 then r,g,b=p,q,v
    elseif i==4 then r,g,b=t,p,v elseif i==5 then r,g,b=v,p,q end
    return Color3.fromRGB(r*255,g*255,b*255)
end

-- R15 skeleton
local SKELETON = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},
}

local function getPlayerState(char, hum)
    if not hum then return "" end
    if hum.Health<=0 then return "✖ DEAD" end
    if char:FindFirstChildOfClass("Seat") then return "⊕ Vehicle" end
    if char:GetAttribute("Prone")   then return "↓ Prone" end
    if char:GetAttribute("Crouching") or char:GetAttribute("Crouch") then return "↕ Crouch" end
    local st=hum:GetState()
    if st==Enum.HumanoidStateType.Swimming  then return "~ Swim" end
    if st==Enum.HumanoidStateType.Freefall  then return "↑ Air"  end
    if st==Enum.HumanoidStateType.Climbing  then return "↑ Climb" end
    return ""
end

local HITBOX = {
    Head=true,UpperTorso=true,LowerTorso=true,HumanoidRootPart=true,
    LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,
    RightUpperArm=true,RightLowerArm=true,RightHand=true,
    LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,
    RightUpperLeg=true,RightLowerLeg=true,RightFoot=true,
}

-- ============================================================
--  TARGET CACHE
-- ============================================================
local cachedTarget=nil; local cachedTargetPos=nil
local cachedDist=0; local _fc=0

local function predictPos(part)
    if not CFG.PredictLead then return part.Position end
    local root=part.Parent:FindFirstChild("HumanoidRootPart") or part
    local ok,vel=pcall(function() return root.AssemblyLinearVelocity end)
    if not ok then return part.Position end
    return part.Position + vel*(cachedDist/1200)*CFG.LeadFactor
end

local function updateCache()
    local center=screenCenter(); local camPos=Camera.CFrame.Position
    local best,bestPos,bestDist,bestSD=nil,nil,0,math.huge
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
        if sd<bestSD then
            bestSD=sd; best=pl; bestPos=pp
            bestDist=(pp-camPos).Magnitude
        end
    end
    cachedTarget=best; cachedTargetPos=bestPos; cachedDist=bestDist
end

-- ============================================================
--  BOX DRAW (corner style, uses feet for bottom)
-- ============================================================
local function drawBox(e, tl, br, col)
    local w=br.X-tl.X; local h=br.Y-tl.Y
    local cw=math.clamp(w*0.22,4,14); local ch=math.clamp(h*0.22,4,14)
    local segs={
        {tl, tl+Vector2.new(cw,0)},{tl, tl+Vector2.new(0,ch)},
        {Vector2.new(br.X,tl.Y), Vector2.new(br.X-cw,tl.Y)},
        {Vector2.new(br.X,tl.Y), Vector2.new(br.X,tl.Y+ch)},
        {br, br+Vector2.new(-cw,0)},{br, br+Vector2.new(0,-ch)},
        {Vector2.new(tl.X,br.Y), Vector2.new(tl.X+cw,br.Y)},
        {Vector2.new(tl.X,br.Y), Vector2.new(tl.X,br.Y-ch)},
    }
    for i,seg in ipairs(segs) do
        local l=e.boxLines[i]; l.Visible=true; l.From=seg[1]; l.To=seg[2]; l.Color=col
    end
end

local function drawSkeleton(e, char, col)
    local pts={}
    for _,p in char:GetChildren() do
        if p:IsA("BasePart") then pts[p.Name]=p end
    end
    for i,conn in ipairs(SKELETON) do
        local l=e.skelLines[i]; if not l then continue end
        local a=pts[conn[1]]; local b=pts[conn[2]]
        if a and b then
            local sa,va=w2s(a.Position); local sb,vb=w2s(b.Position)
            if va and vb then l.Visible=true;l.From=sa;l.To=sb;l.Color=col
            else l.Visible=false end
        else l.Visible=false end
    end
    -- Head circle
    local hd=pts["Head"]
    if hd then
        local sh,vh=w2s(hd.Position)
        if vh then
            local dist=(hd.Position-Camera.CFrame.Position).Magnitude
            local r=math.clamp(1200/dist,4,20)
            e.headCircle.Visible=true; e.headCircle.Position=sh
            e.headCircle.Radius=r; e.headCircle.Color=col
        else e.headCircle.Visible=false end
    else e.headCircle.Visible=false end
end

local function drawHPBar(e, tl, br, hp)
    local x=tl.X-6
    e.hpBg.Visible=true; e.hpBg.From=Vector2.new(x,br.Y); e.hpBg.To=Vector2.new(x,tl.Y)
    e.hpBg.Color=Color3.fromRGB(20,20,20)
    local midY=br.Y+(tl.Y-br.Y)*(hp/100)
    local r=math.floor(255*(1-hp/100)); local g=math.floor(255*(hp/100))
    e.hpFill.Visible=true; e.hpFill.From=Vector2.new(x,br.Y); e.hpFill.To=Vector2.new(x,midY)
    e.hpFill.Color=Color3.fromRGB(r,g,0)
end

local function hideESP(e)
    for _,l in e.boxLines do l.Visible=false end
    for _,l in e.skelLines do l.Visible=false end
    e.hpBg.Visible=false; e.hpFill.Visible=false
    e.name.Visible=false; e.dist.Visible=false; e.state.Visible=false
    e.headCircle.Visible=false
end

-- ============================================================
--  SWASTIKA DRAW
--  Нарисована как 4 L-образных линии (8 сегментов) rotating
-- ============================================================
local function drawSwastika(center2d, size, angle, col)
    -- swastika: 4 arms, each arm = 1 main seg + 1 perpendicular cross seg
    -- offset pairs for arm bases then tips
    local arms={
        {dir=Vector2.new(1,0),  cross=Vector2.new(0,1)},
        {dir=Vector2.new(0,1),  cross=Vector2.new(-1,0)},
        {dir=Vector2.new(-1,0), cross=Vector2.new(0,-1)},
        {dir=Vector2.new(0,-1), cross=Vector2.new(1,0)},
    }
    local function rot(v,a)
        local c=math.cos(a); local s=math.sin(a)
        return Vector2.new(v.X*c-v.Y*s, v.X*s+v.Y*c)
    end
    for i,arm in ipairs(arms) do
        local base = center2d + rot(arm.dir,angle)*size*0.3
        local tip  = center2d + rot(arm.dir,angle)*size
        local cross= tip + rot(arm.cross,angle)*(size*0.5)
        local l1=swLines[i*2-1]; local l2=swLines[i*2]
        l1.Visible=true; l1.From=base; l1.To=tip; l1.Color=col
        l2.Visible=true; l2.From=tip;  l2.To=cross; l2.Color=col
    end
end

local function hideSwastika()
    for _,l in swLines do l.Visible=false end
end

-- ============================================================
--  GET GUN MUZZLE POSITION
-- ============================================================
local function getMuzzlePos()
    local char=LocalPlayer.Character; if not char then return nil end
    local tool=char:FindFirstChildOfClass("Tool"); if not tool then return nil end
    -- try dedicated muzzle part
    local muzzle=tool:FindFirstChild("Muzzle",true)
              or tool:FindFirstChild("MuzzlePoint",true)
              or tool:FindFirstChild("FirePoint",true)
              or tool:FindFirstChild("FiringPoint",true)
    if muzzle and muzzle:IsA("BasePart") then return muzzle.Position end
    if muzzle and muzzle:IsA("Attachment") then return muzzle.WorldPosition end
    -- fallback: righthand
    local rh=char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    return rh and rh.Position or Camera.CFrame.Position
end

-- ============================================================
--  VIEWMODEL FORCEFIELD
-- ============================================================
local ffApplied=false
local function applyFF(enable)
    local char=LocalPlayer.Character; if not char then return end
    local tool=char:FindFirstChildOfClass("Tool"); if not tool then return end
    for _,p in tool:GetDescendants() do
        if p:IsA("BasePart") then
            if enable then
                p.Material=Enum.Material.ForceField
                p.Color=Color3.fromRGB(30,180,220)
            else
                pcall(function()
                    p.Material=Enum.Material.SmoothPlastic
                    p.Color=Color3.fromRGB(163,162,165)
                end)
            end
        end
    end
    ffApplied=enable
end
LocalPlayer.CharacterAdded:Connect(function() ffApplied=false end)

-- watch tool equip for FF
task.spawn(function()
    local lastT=nil
    while task.wait(0.3) do
        local char=LocalPlayer.Character
        local t=char and char:FindFirstChildOfClass("Tool")
        if t~=lastT then lastT=t; if CFG.FFViewModel and t then applyFF(true) end end
    end
end)

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    _fc=_fc+1; local upd=(_fc%2==0)
    if upd then updateCache() end
    swAngle=swAngle+0.04  -- rotate swastika

    -- Status
    local function b(v) return v and "ON" or "--" end
    dStatus.Text=string.format(
        "SA:%s BTP:%s WB:%s FH:%s IA:%s FF:%s | KA:%s GA:%s SP:%s",
        b(CFG.SilentAim and CFG.Enabled),b(CFG.BulletTP),b(CFG.WallBang),
        b(CFG.ForceHit),b(CFG.InfAmmo),b(CFG.FFViewModel),
        b(CFG.KillAllSpam),b(CFG.GrenadeSpam),b(CFG.SpotAll))
    dStatus.Color=CFG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)

    -- FOV circle
    dFOV.Position=screenCenter(); dFOV.Radius=CFG.FOV
    dFOV.Visible=CFG.ShowFOV and CFG.Enabled
    dFOV.Color=(cachedTarget and CFG.EnemyColor) or CFG.FOVColor

    -- Fade tracers
    local now=tick(); local i=1
    while i<=#tracers do
        local tr=tracers[i]; local age=now-tr.born
        if age>TRACER_LIFE then tr.line:Remove(); table.remove(tracers,i)
        else tr.line.Transparency=age/TRACER_LIFE; i=i+1 end
    end

    -- Aim Line (gun → target)
    if CFG.ShowAimLine and CFG.Enabled and cachedTargetPos then
        local mp=getMuzzlePos()
        if mp then
            local sp1,v1=w2s(mp); local sp2,v2=w2s(cachedTargetPos)
            if v1 then
                aimLine.Visible=true; aimLine.From=sp1; aimLine.To=sp2
                aimLine.Color=hsvToRgb((tick()*0.3)%1,1,1)
            else aimLine.Visible=false end
        else aimLine.Visible=false end
    else aimLine.Visible=false end

    if not upd then return end

    -- Swastika around closest target
    if CFG.ShowSwastika and CFG.Enabled and cachedTargetPos then
        local sp,vis=w2s(cachedTargetPos)
        if vis then
            local d=math.clamp(cachedDist,1,1000)
            local sz=math.clamp(3000/d,18,80)
            local col=hsvToRgb((tick()*0.5)%1,1,1)
            drawSwastika(sp,sz,swAngle,col)
        else hideSwastika() end
    else hideSwastika() end

    if not CFG.ESPEnabled then
        for _,e in espCache do hideESP(e) end
        return
    end

    -- Per-player ESP
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        local e=getESP(pl)
        local char=pl.Character
        if not char then hideESP(e); continue end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hum then hideESP(e); continue end

        local root=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        -- find lowest foot for correct box bottom
        local lf=char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
                  or char:FindFirstChild("Left Leg") or root

        if not root or not head then hideESP(e); continue end

        local hp=math.clamp(math.floor(hum.Health),0,100)
        local col=isTeammate(pl) and CFG.TeamColor or CFG.EnemyColor
        local _,rootVis=w2s(root.Position)
        if not rootVis then hideESP(e); continue end

        local headTop=head.Position+Vector3.new(0,head.Size.Y*0.5+0.2,0)
        local feetBot=lf and (lf.Position-Vector3.new(0,lf.Size.Y*0.5,0)) or (root.Position-Vector3.new(0,2.5,0))

        local spHead,_=w2s(headTop)
        local spFeet,_=w2s(feetBot)
        local dist=math.floor((root.Position-Camera.CFrame.Position).Magnitude)

        -- Box from head-top to feet-bottom, auto width
        local boxH=math.abs(spFeet.Y-spHead.Y)
        local boxW=boxH*0.5
        local tl=Vector2.new(spHead.X-boxW, spHead.Y)
        local br=Vector2.new(spHead.X+boxW, spFeet.Y)

        if CFG.ShowBox then
            drawBox(e,tl,br,col)
            if CFG.ShowHP then drawHPBar(e,tl,br,hp)
            else e.hpBg.Visible=false; e.hpFill.Visible=false end
            e.name.Visible=CFG.ShowName
            if CFG.ShowName then
                e.name.Position=Vector2.new(spHead.X,tl.Y-15)
                e.name.Text=pl.Name; e.name.Color=col
            end
            if CFG.ShowDist then
                e.dist.Visible=true; e.dist.Position=Vector2.new(spHead.X,br.Y+3)
                e.dist.Text=dist.."m"
            else e.dist.Visible=false end
            if CFG.ShowState then
                local st=getPlayerState(char,hum)
                e.state.Visible=(st~=""); e.state.Text=st
                e.state.Position=Vector2.new(spHead.X,br.Y+15)
            else e.state.Visible=false end
        else
            for _,l in e.boxLines do l.Visible=false end
            e.hpBg.Visible=false; e.hpFill.Visible=false
            e.name.Visible=false; e.dist.Visible=false; e.state.Visible=false
        end

        if CFG.ShowSkeleton and hp>0 then drawSkeleton(e,char,col)
        else
            for _,l in e.skelLines do l.Visible=false end
            e.headCircle.Visible=false
        end
    end
end)

-- ============================================================
--  REMOTES
-- ============================================================
local Remotes={}
task.spawn(function()
    local rs=game:GetService("ReplicatedStorage")
    local function sw(p,n)
        local ok,r=pcall(function() return p:WaitForChild(n,10) end)
        return ok and r or nil
    end
    local function cr(i) return (i and cloneref) and cloneref(i) or i end
    local engine=sw(rs,"ACS_Engine")
    local events=engine and sw(engine,"Events")
    local pe=sw(rs,"PlayerEvents")
    if events then
        Remotes.ServerBullet  = cr(events:FindFirstChild("ServerBullet"))
        Remotes.Damage        = cr(events:FindFirstChild("Damage"))
        Remotes.ServerGrenade = cr(events:FindFirstChild("ServerGrenade"))
        Remotes.GunStance     = cr(events:FindFirstChild("GunStance"))
        Remotes.Equip         = cr(events:FindFirstChild("Equip"))
        Remotes.Refil         = cr(events:FindFirstChild("Refil"))
    end
    if pe then
        Remotes.SpotPlayer = cr(pe:FindFirstChild("SpotPlayer"))
        Remotes.KillMe     = cr(pe:FindFirstChild("KillMe"))
    end
    local ok_list={}
    for k,v in Remotes do if v then ok_list[#ok_list+1]=k end end
    print("[SA v10] Remotes: "..table.concat(ok_list,", "))
end)

-- ============================================================
--  GC REFS (weapon switch only)
-- ============================================================
local u7Ref=nil; local u64Ref=nil; local infAmmoFns={}

local function refreshGunRefs()
    u7Ref=nil; u64Ref=nil; infAmmoFns={}
    for _,obj in getgc(true) do
        if type(obj)~="table" then continue end
        if not u7Ref and rawget(obj,"ShootRate")~=nil
                      and rawget(obj,"ShootType")~=nil
                      and rawget(obj,"camRecoil")~=nil then u7Ref=obj end
        if not u64Ref then
            local ns=rawget(obj,"NextShot")
            if type(ns)=="number" and ns>1e12 then u64Ref=obj end
        end
    end
    for _,f in getgc(false) do
        if type(f)~="function" then continue end
        local ok,uvs=pcall(debug.getupvalues,f); if not ok then continue end
        local has=false
        for _,uv in pairs(uvs) do
            if type(uv)=="table" and rawget(uv,"ShootRate")~=nil then has=true; break end
        end
        if has then infAmmoFns[#infAmmoFns+1]=f end
    end
    if u7Ref then
        if not u7Ref._origShootRate then u7Ref._origShootRate=u7Ref.ShootRate end
        print(string.format("[SA v10] u7 OK: ShootRate=%s InfFns=%d",u7Ref.ShootRate,#infAmmoFns))
    end
end

-- ============================================================
--  HEARTBEAT
-- ============================================================
RunService.Heartbeat:Connect(function()
    if CFG.InfAmmo then
        for _,f in infAmmoFns do
            local ok,uvs=pcall(debug.getupvalues,f); if not ok then continue end
            for idx,val in pairs(uvs) do
                if type(val)=="number" and val>=0 and val<=500 then
                    pcall(debug.setupvalue,f,idx,9999) end
            end
        end
    end
    if CFG.KillAllSpam and Remotes.Damage then
        local myChar=LocalPlayer.Character
        local origin=myChar and myChar:FindFirstChild("HumanoidRootPart")
            and myChar.HumanoidRootPart.Position or Camera.CFrame.Position
        local function mkSD()
            return {weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,99999)}
        end
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function()
                local char=pl.Character; if not char then return end
                local hum=char:FindFirstChildOfClass("Humanoid")
                local hp=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if not hum or not hp or hum.Health<=0 then return end
                pcall(function()
                    Remotes.Damage:InvokeServer(mkSD(),hum,(hp.Position-origin).Magnitude,1,hp)
                end)
            end)
        end
    end
    if CFG.GrenadeSpam and Remotes.ServerGrenade then
        local origin=Camera.CFrame.Position
        local target=cachedTargetPos or (origin+Camera.CFrame.LookVector*50)
        local dir=(target-origin).Unit
        pcall(function()
            Remotes.ServerGrenade:FireServer(origin,dir,{
                shellType="Grenade",shellName="M67",shellSpeed=50,
                origin=origin,bulletID=LocalPlayer.UserId..tick()
            })
        end)
    end
end)

-- SpotAll loop
task.spawn(function()
    while task.wait(2) do
        if CFG.SpotAll and Remotes.SpotPlayer then
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LocalPlayer then
                    task.spawn(function()
                        pcall(function() Remotes.SpotPlayer:FireServer(pl) end)
                    end)
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
        if type(f)=="function" then
            local ok,info=pcall(debug.getinfo,f)
            if ok and info and (info.nups or 0)>=5 then SM=obj; break end
        end
    end
    if not SM then warn("[SA v10] ShootModule not found"); return end

    -- WallBang: canRayPierce
    local ok2,uvs=pcall(debug.getupvalues,SM.fire)
    if ok2 then
        for _,val in pairs(uvs) do
            if type(val)=="table" and type(rawget(val,"canRayPierce"))=="function" then
                local orig=val.canRayPierce
                val.canRayPierce=newcclosure(function(pl,inst,sd)
                    if CFG.WallBang and pl==LocalPlayer then
                        if inst and inst.Parent then
                            if inst.Parent:FindFirstChildOfClass("Humanoid") and HITBOX[inst.Name] then
                                return orig(pl,inst,sd) end
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
            if CFG.SilentAim and cachedTargetPos then
                local t=cachedTargetPos-origin
                if t.Magnitude>0 then direction=t.Unit end
            end
            if CFG.BulletTP and type(shellData)=="table" then shellData.shellSpeed=9e9 end

            -- Bullet Tracer
            if CFG.ShowTracer then
                local mp=getMuzzlePos() or origin
                local endPos=cachedTargetPos or (origin+direction*500)
                local sp1,v1=w2s(mp); local sp2,_=w2s(endPos)
                if v1 then spawnTracer(sp1,sp2) end
            end

            if CFG.ForceHit and cachedTarget then
                task.defer(function()
                    if not Remotes.Damage or not cachedTarget then return end
                    local char=cachedTarget.Character; if not char then return end
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    local hp=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if not hum or not hp or hum.Health<=0 then return end
                    local sd={weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                        maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                        origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,99999)}
                    pcall(function()
                        Remotes.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp)
                    end)
                end)
            end
        end
        return origFire(pl,origin,direction,shellData,extra)
    end)
    print("[SA v10] ShootModule OK")
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
    print("[SA v10] hookmetamethod OK")
end

-- ============================================================
--  KILL ALL
-- ============================================================
local function doKillAll()
    if not Remotes.Damage then warn("[SA v10] Damage remote not found"); return end
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
                pcall(function() Remotes.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
            end
        end)
        n=n+1
    end
    print("[SA v10] KillAll -> "..n)
end

-- ============================================================
--  WEAPON WATCH
-- ============================================================
local lastTool=nil
task.spawn(function()
    while task.wait(0.5) do
        local char=LocalPlayer.Character
        local tool=char and char:FindFirstChildOfClass("Tool")
        local name=tool and tool.Name
        if name~=lastTool then
            lastTool=name
            if name then
                task.wait(0.35); refreshGunRefs()
                if u7Ref and CFG.FireRate then u7Ref.ShootRate=CFG.FireRate end
                if CFG.FFViewModel and tool then applyFF(true) end
            end
        end
    end
end)

-- ============================================================
--  INIT
-- ============================================================
task.spawn(function()
    task.wait(1.5); hookShootModule(); hookNamecall()
    task.wait(0.3); refreshGunRefs()
    print("[SA v10] Ready")
end)

-- ============================================================
--  NOTIFICATIONS
-- ============================================================
local function notify(t,m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=t,Text=m,Duration=2.5})
    end)
end

-- ============================================================
--  KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    local k=input.KeyCode
    if k==Enum.KeyCode.Insert then
        CFG.Enabled=not CFG.Enabled; notify("SilentAim v10",CFG.Enabled and "ON" or "OFF")
    elseif k==Enum.KeyCode.Delete then
        CFG.BulletTP=not CFG.BulletTP; notify("BulletTP",CFG.BulletTP and "ON" or "OFF")
    elseif k==Enum.KeyCode.End then
        CFG.WallBang=not CFG.WallBang; notify("WallBang",CFG.WallBang and "ON" or "OFF")
    elseif k==Enum.KeyCode.Home then
        CFG.ForceHit=not CFG.ForceHit; notify("ForceHit",CFG.ForceHit and "ON" or "OFF")
    elseif k==Enum.KeyCode.F5 then
        CFG.InfAmmo=not CFG.InfAmmo; notify("InfAmmo",CFG.InfAmmo and "ON" or "OFF")
    elseif k==Enum.KeyCode.F6 then
        if u7Ref then
            if not u7Ref._origShootRate then u7Ref._origShootRate=u7Ref.ShootRate end
            if CFG.FireRate then
                u7Ref.ShootRate=u7Ref._origShootRate; CFG.FireRate=nil
                notify("FireRate","Reset -> "..u7Ref.ShootRate)
            else
                CFG.FireRate=u7Ref._origShootRate*2; u7Ref.ShootRate=CFG.FireRate
                notify("FireRate x2",CFG.FireRate.." RPM")
            end
        end
    elseif k==Enum.KeyCode.F7 then
        CFG.FFViewModel=not CFG.FFViewModel
        applyFF(CFG.FFViewModel)
        notify("FF ViewModel",CFG.FFViewModel and "ON" or "OFF")
    elseif k==Enum.KeyCode.F8 then
        CFG.ShowTracer=not CFG.ShowTracer; notify("BulletTracer",CFG.ShowTracer and "ON" or "OFF")
    elseif k==Enum.KeyCode.F9 then
        CFG.ShowAimLine=not CFG.ShowAimLine; notify("AimLine",CFG.ShowAimLine and "ON" or "OFF")
    elseif k==Enum.KeyCode.F10 then
        notify("KillAll","..."); task.spawn(doKillAll)
    elseif k==Enum.KeyCode.F11 then
        CFG.KillAllSpam=not CFG.KillAllSpam
        notify("KillAllSpam",CFG.KillAllSpam and "ON" or "OFF")
    elseif k==Enum.KeyCode.F12 then
        CFG.SpotAll=not CFG.SpotAll; notify("SpotAll",CFG.SpotAll and "ON" or "OFF")
    elseif k==Enum.KeyCode.KeypadZero then
        CFG.GrenadeSpam=not CFG.GrenadeSpam; notify("GrenadeSpam",CFG.GrenadeSpam and "ON" or "OFF")
    elseif k==Enum.KeyCode.KeypadOne then
        -- CrashAllHeli
        local rs=game:GetService("ReplicatedStorage")
        local helis=rs:FindFirstChild("Helicopters")
        if helis then
            for _,heli in helis:GetChildren() do
                local net=heli:FindFirstChild("Networking")
                local ce=net and net:FindFirstChild("CrashEvent")
                if ce then pcall(function() ce:FireServer() end) end
            end
        end
        notify("CrashAllHeli","sent")
    elseif k==Enum.KeyCode.PageUp then
        CFG.FOV=math.min(CFG.FOV+50,800); dFOV.Radius=CFG.FOV; notify("FOV","= "..CFG.FOV)
    elseif k==Enum.KeyCode.PageDown then
        CFG.FOV=math.max(CFG.FOV-50,50); dFOV.Radius=CFG.FOV; notify("FOV","= "..CFG.FOV)
    end
end)
