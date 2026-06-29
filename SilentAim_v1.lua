--[[
╔══════════════════════════════════════════════════════════════════╗
║              SilentAim v13  --  ACS Engine                      ║
║  GitHub: AndreyZlo1/script  |  base commit: 4280d27             ║
╠══════════════════════════════════════════════════════════════════╣
║  FIXES v13:                                                      ║
║  1. ESP: no dist limit, vehicle riders detected via Seat tag     ║
║  2. Head Circle: clamp(1200/dist, 2, 5)  -- tiny at range       ║
║  3. Swastika: clamp(3500/dist, 22, 50)  -- smaller              ║
║  4. HitSound: parented fresh every respawn via CharAdded         ║
║  5. FullAuto: only modifies ShootRate, never ShootType           ║
║     InfAmmo: patched per-upvalue check to SKIP non-ammo nums    ║
║     Neither touches ViewModel anims                              ║
║  6. BulletTracer: full screen-space 3D, starts at Muzzle,       ║
║     proper Fade OUT only (alpha 0.3 -> 1.0 over 0.5s),         ║
║     thickness 2.5, length spans to target                       ║
║  7. ForceField: skip 'Chamber' named parts                       ║
║  8. ExploitUI: troll/damage only:                               ║
║     CrashAllHeli, DamageVehicles, CollapseAll, SVFlash,         ║
║     GrenadeSpam, ExplosionFX spam, TurretHijack,               ║
║     HeadRotSpam, Surrender all, Drag, StopGrappling,            ║
║     CollectCash, Breach walls                                    ║
╠══════════════════════════════════════════════════════════════════╣
║  BINDS:                                                         ║
║  Insert   = SilentAim on/off                                    ║
║  Delete   = BulletTP on/off                                     ║
║  End      = WallBang on/off                                     ║
║  Home     = ForceHit on/off                                     ║
║  F5       = InfAmmo on/off                                      ║
║  F6       = FullAuto on/off                                      ║
║  F7       = ForceField ViewModel on/off                         ║
║  F8       = BulletTracer on/off                                 ║
║  F9       = AimLine on/off                                      ║
║  F10      = KillAll (once)                                      ║
║  F11      = KillAll spam toggle                                  ║
║  F12      = SpotAll toggle                                       ║
║  Numpad0  = GrenadeSpam toggle                                   ║
║  Numpad1  = CrashAllHeli (once)                                  ║
║  RCtrl    = Exploit UI toggle                                    ║
║  PgUp/Dn  = FOV +/-50                                            ║
╚══════════════════════════════════════════════════════════════════╝
]]

-- ================================================================
-- SERVICES
-- ================================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

-- ================================================================
-- CONFIG
-- ================================================================
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

    KillAllSpam = false,
    SpotAll     = false,
    GrenadeSpam = false,
    FFViewModel = false,
}

-- ================================================================
-- DRAWING
-- ================================================================
local function D(class, props)
    local d = Drawing.new(class)
    for k,v in pairs(props) do d[k]=v end
    return d
end

local dStatus = D("Text",{
    Visible=true, Size=13, Color=Color3.fromRGB(0,255,100),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0),
    Position=Vector2.new(10,10), ZIndex=10,
    Text="SA v13"
})
local dFOVCircle = D("Circle",{
    Visible=false, Radius=CFG.FOV, Color=Color3.fromRGB(255,255,255),
    Thickness=1, Filled=false, Transparency=0.5
})

-- ================================================================
-- HITMARKER
-- ================================================================
local hmLines = {}
for i=1,4 do
    hmLines[i] = D("Line",{Visible=false,Thickness=2,
        Color=Color3.fromRGB(255,255,255),Transparency=1})
end
local hmUntil = 0

-- ================================================================
-- HITSOUND  -- recreated on every respawn
-- ================================================================
local hitSound = nil
local function makeHitSound()
    if hitSound then pcall(function() hitSound:Destroy() end) end
    hitSound = Instance.new("Sound")
    hitSound.SoundId  = "rbxassetid://115982072912004"
    hitSound.Volume   = 1
    hitSound.RollOffMaxDistance = 0
    hitSound.Parent   = Camera
end
makeHitSound()
LocalPlayer.CharacterAdded:Connect(function()
    task.delay(1, makeHitSound)
end)

local function triggerHit()
    hmUntil = tick() + 0.18
    if CFG.HitSound and hitSound then
        pcall(function() hitSound:Play() end)
    end
end

-- ================================================================
-- AIM LINE  (gun -> target)
-- ================================================================
local aimLine = D("Line",{Visible=false,Thickness=1.5,
    Color=Color3.fromRGB(255,255,255),Transparency=0.3})

-- ================================================================
-- BULLET TRACERS  (3D positions, fade-out only)
-- ================================================================
local TRACER_LIFE = 0.5
local tracers = {}  -- {line, from3d, to3d, born}

local function spawnTracer(from3d, to3d)
    local l = D("Line",{
        Visible=true, Thickness=2.5,
        Color=Color3.fromRGB(255,200,50),
        Transparency=0.3,  -- start semi-transparent
    })
    table.insert(tracers, {line=l, from3d=from3d, to3d=to3d, born=tick()})
end

-- ================================================================
-- HELPERS
-- ================================================================
local function w2s(pos)
    local sp, vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), vis, sp.Z
end
local function screenCenter() return Camera.ViewportSize / 2 end

local function isTeammate(pl)
    if not CFG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == pl.Team
end

local function hsvToRgb(h, s, v)
    local i = math.floor(h*6)
    local f = h*6 - i
    local p,q,t = v*(1-s), v*(1-(f)*s), v*(1-(1-f)*s)
    i = i % 6
    if i==0 then return Color3.fromRGB(v*255,t*255,p*255)
    elseif i==1 then return Color3.fromRGB(q*255,v*255,p*255)
    elseif i==2 then return Color3.fromRGB(p*255,v*255,t*255)
    elseif i==3 then return Color3.fromRGB(p*255,q*255,v*255)
    elseif i==4 then return Color3.fromRGB(t*255,p*255,v*255)
    else             return Color3.fromRGB(v*255,p*255,q*255) end
end

-- ================================================================
-- VIEWMODEL MUZZLE PATH
-- workspace.Camera.Viewmodel.<WeaponModel>.Nodes.Muzzle
-- ================================================================
local function getViewmodelTool()
    local vm = Camera:FindFirstChild("Viewmodel")
    if not vm then return nil end
    for _, ch in ipairs(vm:GetChildren()) do
        if ch:IsA("Model") then return ch end
    end
    return nil
end

local function getMuzzlePos()
    local vmTool = getViewmodelTool()
    if vmTool then
        local nodes = vmTool:FindFirstChild("Nodes")
        if nodes then
            for _, n in ipairs({"Muzzle","MuzzlePoint","FirePoint","BarrelEnd","TipAttachment"}) do
                local att = nodes:FindFirstChild(n)
                if att then
                    if att:IsA("Attachment") then return att.WorldPosition end
                    if att:IsA("BasePart") then return att.Position end
                end
            end
        end
        -- deep fallback inside tool
        local att = vmTool:FindFirstChild("Muzzle",true) or vmTool:FindFirstChild("MuzzlePoint",true)
        if att then
            if att:IsA("Attachment") then return att.WorldPosition end
            if att:IsA("BasePart") then return att.Position end
        end
        local pp = vmTool.PrimaryPart
        if pp then return pp.Position end
    end
    local char = LocalPlayer.Character
    local rh = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
    return rh and rh.Position or Camera.CFrame.Position
end

-- ================================================================
-- FORCEFIELD VIEWMODEL  (skip Chamber)
-- ================================================================
local function applyFF(enable)
    local vmTool = getViewmodelTool()
    if not vmTool then return end
    for _, p in vmTool:GetDescendants() do
        if p.Name == "Chamber" then continue end
        if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("UnionOperation") then
            pcall(function()
                if enable then
                    p.Material    = Enum.Material.ForceField
                    p.Color       = Color3.fromRGB(30,180,220)
                    p.Transparency = math.min(p.Transparency, 0.05)
                else
                    p.Material = Enum.Material.SmoothPlastic
                end
            end)
        end
    end
end

-- watch viewmodel changes
task.spawn(function()
    local last = nil
    while task.wait(0.3) do
        local cur = getViewmodelTool()
        if cur ~= last then
            last = cur
            if cur and CFG.FFViewModel then
                task.delay(0.2, function() applyFF(true) end)
            end
        end
    end
end)

-- ================================================================
-- SKELETON BONES
-- ================================================================
local SKEL = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

-- ================================================================
-- ESP CACHE
-- ================================================================
local espCache = {}

local function makeESP()
    local e = {}
    e.box = {}
    for i=1,8 do e.box[i]=D("Line",{Visible=false,Thickness=1.5,
        Color=Color3.fromRGB(255,255,255),Transparency=0.15}) end
    e.hpBg  = D("Line",{Visible=false,Thickness=5,Color=Color3.fromRGB(0,0,0),Transparency=0.5})
    e.hpBar = D("Line",{Visible=false,Thickness=3,Color=Color3.fromRGB(0,255,80),Transparency=0.15})
    e.name  = D("Text",{Visible=false,Size=13,Color=Color3.fromRGB(255,255,255),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.dist  = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(200,200,200),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.state = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(255,200,50),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.skel = {}
    for i=1,#SKEL do
        e.skel[i]=D("Line",{Visible=false,Thickness=1,
            Color=Color3.fromRGB(255,255,255),Transparency=0.3})
    end
    e.headCircle = D("Circle",{Visible=false,Filled=false,Thickness=1.5,
        Radius=5,Color=Color3.fromRGB(255,255,255),Transparency=0.15})
    return e
end

local function hideESP(e)
    for _,l in ipairs(e.box) do l.Visible=false end
    for _,l in ipairs(e.skel) do l.Visible=false end
    e.hpBg.Visible=false; e.hpBar.Visible=false
    e.name.Visible=false; e.dist.Visible=false
    e.state.Visible=false; e.headCircle.Visible=false
end

local function removeESP(e)
    hideESP(e)
    for _,l in ipairs(e.box) do pcall(l.Remove,l) end
    for _,l in ipairs(e.skel) do pcall(l.Remove,l) end
    for _,obj in ipairs({e.hpBg,e.hpBar,e.name,e.dist,e.state,e.headCircle}) do
        pcall(obj.Remove,obj)
    end
end

local function getESP(pl)
    if not espCache[pl] then espCache[pl]=makeESP() end
    return espCache[pl]
end

Players.PlayerRemoving:Connect(function(pl)
    if espCache[pl] then removeESP(espCache[pl]); espCache[pl]=nil end
end)

-- ================================================================
-- BOX (corner style)
-- ================================================================
local function drawBox(e, tl, br, col)
    local w,h = br.X-tl.X, br.Y-tl.Y
    local cw = math.clamp(w*0.22, 3, 14)
    local ch = math.clamp(h*0.22, 3, 14)
    local segs = {
        {tl,                        tl+Vector2.new(cw,0)},
        {tl,                        tl+Vector2.new(0,ch)},
        {Vector2.new(br.X,tl.Y),    Vector2.new(br.X-cw,tl.Y)},
        {Vector2.new(br.X,tl.Y),    Vector2.new(br.X,tl.Y+ch)},
        {br,                        br+Vector2.new(-cw,0)},
        {br,                        br+Vector2.new(0,-ch)},
        {Vector2.new(tl.X,br.Y),    Vector2.new(tl.X+cw,br.Y)},
        {Vector2.new(tl.X,br.Y),    Vector2.new(tl.X,br.Y-ch)},
    }
    for i,seg in ipairs(segs) do
        local l=e.box[i]; l.Visible=true
        l.From=seg[1]; l.To=seg[2]; l.Color=col
    end
end

-- ================================================================
-- HP BAR
-- ================================================================
local function drawHP(e, tl, br, hp)
    local x = tl.X - 6
    e.hpBg.Visible=true
    e.hpBg.From=Vector2.new(x,br.Y); e.hpBg.To=Vector2.new(x,tl.Y)
    local midY = br.Y + (tl.Y-br.Y)*(hp/100)
    e.hpBar.Visible=true
    e.hpBar.From=Vector2.new(x,br.Y); e.hpBar.To=Vector2.new(x,midY)
    local r=math.floor(255*(1-hp/100)); local g=math.floor(255*(hp/100))
    e.hpBar.Color=Color3.fromRGB(r,g,0)
end

-- ================================================================
-- SKELETON
-- ================================================================
local function drawSkeleton(e, char, col)
    local pts={}
    for _,p in ipairs(char:GetChildren()) do
        if p:IsA("BasePart") then pts[p.Name]=p end
    end
    for i,conn in ipairs(SKEL) do
        local l=e.skel[i]; if not l then continue end
        local a,b=pts[conn[1]],pts[conn[2]]
        if a and b then
            local sa,va=w2s(a.Position); local sb,vb=w2s(b.Position)
            if va and vb then l.Visible=true;l.From=sa;l.To=sb;l.Color=col
            else l.Visible=false end
        else l.Visible=false end
    end
    local hd=pts["Head"]
    if hd then
        local sh,vh=w2s(hd.Position)
        if vh then
            local dist=(hd.Position-Camera.CFrame.Position).Magnitude
            -- small at range: 1200/dist clamped 2..5
            e.headCircle.Visible=true
            e.headCircle.Position=sh
            e.headCircle.Radius=math.clamp(1200/math.max(dist,1), 2, 5)
            e.headCircle.Color=col
        else e.headCircle.Visible=false end
    else e.headCircle.Visible=false end
end

-- ================================================================
-- STATE (ASCII only)
-- ================================================================
local function getState(char, hum)
    if not hum or hum.Health<=0 then return "" end
    -- vehicle / seat detection
    local seat = char:FindFirstChildOfClass("Seat") or char:FindFirstChildOfClass("VehicleSeat")
    if seat then return "Vehicle" end
    -- check if HRP is inside a VehicleSeat via occupant
    for _, obj in workspace:GetDescendants() do
        if (obj:IsA("VehicleSeat") or obj:IsA("Seat")) then
            local ok,occ=pcall(function() return obj.Occupant end)
            if ok and occ then
                local pl = Players:GetPlayerFromCharacter(occ.Parent)
                if pl and pl == Players:GetPlayerFromCharacter(char) then
                    return "Vehicle"
                end
            end
        end
    end
    if char:GetAttribute("Prone")      then return "Prone"    end
    if char:GetAttribute("Crouching")  then return "Crouch"   end
    if char:GetAttribute("Crouch")     then return "Crouch"   end
    if char:GetAttribute("IsGrappling") then return "Grapple"  end
    local st = hum:GetState()
    if st==Enum.HumanoidStateType.Freefall  then return "Air"      end
    if st==Enum.HumanoidStateType.Swimming  then return "Swim"     end
    if st==Enum.HumanoidStateType.Climbing  then return "Climb"    end
    return ""
end

-- ================================================================
-- SWASTIKA  (Drawing.Line, 8 segments, RGB, smaller)
-- ================================================================
local swLines={}
for i=1,8 do swLines[i]=D("Line",{Visible=false,Thickness=2.2,
    Color=Color3.fromRGB(255,0,0),Transparency=0.05}) end
local swAngle=0

local SW_ARMS = {
    {dir=Vector2.new( 0,-1), cross=Vector2.new( 1, 0)},
    {dir=Vector2.new( 1, 0), cross=Vector2.new( 0, 1)},
    {dir=Vector2.new( 0, 1), cross=Vector2.new(-1, 0)},
    {dir=Vector2.new(-1, 0), cross=Vector2.new( 0,-1)},
}

local function rotV2(v,a)
    local c,s=math.cos(a),math.sin(a)
    return Vector2.new(v.X*c-v.Y*s, v.X*s+v.Y*c)
end

local function drawSwastika(center, sz, ang, col)
    for i,arm in ipairs(SW_ARMS) do
        local d  = rotV2(arm.dir,   ang)
        local cr = rotV2(arm.cross, ang)
        local base = center + d*(sz*0.18)
        local tip  = center + d*sz
        local tail = tip + cr*(sz*0.55)
        swLines[i*2-1].Visible=true; swLines[i*2-1].From=base; swLines[i*2-1].To=tip; swLines[i*2-1].Color=col
        swLines[i*2  ].Visible=true; swLines[i*2  ].From=tip;  swLines[i*2  ].To=tail; swLines[i*2  ].Color=col
    end
end

local function hideSwastika()
    for _,l in ipairs(swLines) do l.Visible=false end
end

-- ================================================================
-- TARGET CACHE
-- ================================================================
local cachedTarget=nil; local cachedTargetPos=nil; local cachedDist=0
local _fc=0

local function predictPos(part)
    if not CFG.PredictLead then return part.Position end
    local root=part.Parent:FindFirstChild("HumanoidRootPart") or part
    local ok,vel=pcall(function() return root.AssemblyLinearVelocity end)
    if not ok then return part.Position end
    return part.Position + vel*(cachedDist/1200)*CFG.LeadFactor
end

local function updateCache()
    local center=screenCenter(); local camPos=Camera.CFrame.Position
    local bestSd=math.huge; local best,bestPos,bestDist=nil,nil,0
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
        if sd<bestSd then
            bestSd=sd; best=pl; bestPos=pp
            bestDist=(pp-camPos).Magnitude
        end
    end
    cachedTarget=best; cachedTargetPos=bestPos; cachedDist=bestDist
end

-- ================================================================
-- GC REFS
-- ================================================================
local u7Ref=nil; local infFns={}

local function refreshGunRefs()
    u7Ref=nil; infFns={}
    for _,obj in getgc(true) do
        if type(obj)~="table" then continue end
        if rawget(obj,"ShootRate")~=nil and rawget(obj,"ShootType")~=nil then
            u7Ref=obj
            if not u7Ref._origSR then u7Ref._origSR=u7Ref.ShootRate end
            break
        end
    end
    -- InfAmmo: find functions that manage ammo counters (not animations)
    -- Criteria: has upvalue that is a table with ShootRate AND a numeric value 0-999
    -- Explicitly skip functions with upvalues touching AnimationController/AnimTrack/CFrame
    for _,f in getgc(false) do
        if type(f)~="function" then continue end
        local ok,info=pcall(debug.getinfo,f)
        if not ok then continue end
        local nups=(info and info.nups) or 0
        if nups==0 or nups>15 then continue end
        local ok2,uvs=pcall(debug.getupvalues,f)
        if not ok2 then continue end
        local hasGunTable=false; local hasAmmoNum=false; local hasAnim=false
        for _,v in pairs(uvs) do
            if type(v)=="table" and rawget(v,"ShootRate")~=nil then hasGunTable=true end
            if type(v)=="number" and v>=0 and v<=999 then hasAmmoNum=true end
            -- skip anything touching animation data
            if type(v)=="userdata" then
                local ok3,cn=pcall(function() return v.ClassName end)
                if ok3 and (cn=="AnimationTrack" or cn=="Animation" or cn=="AnimationController") then
                    hasAnim=true; break
                end
            end
        end
        if hasGunTable and hasAmmoNum and not hasAnim then
            infFns[#infFns+1]=f
        end
    end
    print(("[SA v13] u7=%s infFns=%d"):format(tostring(u7Ref~=nil),#infFns))
end

task.spawn(function()
    local lastTool=nil
    while task.wait(0.3) do
        local vmTool=getViewmodelTool()
        local char=LocalPlayer.Character
        local cTool=char and char:FindFirstChildOfClass("Tool")
        local observed=vmTool or cTool
        if observed~=lastTool then
            lastTool=observed
            if observed then
                task.delay(0.2, function()
                    refreshGunRefs()
                    if CFG.FullAuto and u7Ref then u7Ref.ShootRate=99999 end
                    if CFG.FFViewModel then applyFF(true) end
                end)
            end
        end
    end
end)

-- ================================================================
-- HEARTBEAT  (InfAmmo, KillAllSpam, GrenadeSpam)
-- ================================================================
RunService.Heartbeat:Connect(function()
    if CFG.InfAmmo then
        for _,f in ipairs(infFns) do
            local ok,uvs=pcall(debug.getupvalues,f)
            if not ok then continue end
            for idx,val in pairs(uvs) do
                if type(val)=="number" and val>=0 and val<=999 then
                    pcall(debug.setupvalue,f,idx,9999)
                end
            end
        end
    end
end)

-- ================================================================
-- REMOTES LOADER
-- ================================================================
local R={}
task.spawn(function()
    local rs=game:GetService("ReplicatedStorage")
    local cr=(cloneref or function(x) return x end)
    local function fw(p,n,t)
        local ok,v=pcall(function() return p:WaitForChild(n,t or 8) end)
        return ok and v or nil
    end
    local engine=fw(rs,"ACS_Engine"); local ev=engine and fw(engine,"Events")
    local pe=fw(rs,"PlayerEvents"); local med=ev and fw(ev,"MedSys")

    if ev then
        R.ServerBullet = cr(ev:FindFirstChild("ServerBullet"))
        R.Damage       = cr(ev:FindFirstChild("Damage"))
        R.ServerGrenade= cr(ev:FindFirstChild("ServerGrenade"))
        R.SVFlash      = cr(ev:FindFirstChild("SVFlash"))
        R.SVLaser      = cr(ev:FindFirstChild("SVLaser"))
        R.NVG          = cr(ev:FindFirstChild("NVG"))
        R.Surrender    = cr(ev:FindFirstChild("Surrender"))
        R.Drag         = cr(ev:FindFirstChild("Drag"))
        R.Equip        = cr(ev:FindFirstChild("Equip"))
        R.Refil        = cr(ev:FindFirstChild("Refil"))
        R.GunStance    = cr(ev:FindFirstChild("GunStance"))
        R.HeadRot      = cr(ev:FindFirstChild("HeadRot"))
        R.StopGrapple  = cr(ev:FindFirstChild("StopGrappling"))
        R.ExplosionFX  = cr(ev:FindFirstChild("ExplosionFX"))
        R.TankFireFX   = cr(ev:FindFirstChild("TankFireFX"))
        R.HeliRocketFX = cr(ev:FindFirstChild("HeliRocketFireFX"))
        R.HitEffect    = cr(ev:FindFirstChild("HitEffect"))
        R.MLGHitmarker = cr(ev:FindFirstChild("MLGHitmarker"))
        R.Turret       = cr(ev:FindFirstChild("Turret"))
        R.TurretHit    = cr(ev:FindFirstChild("TurretHit"))
        R.TurretEnter  = cr(ev:FindFirstChild("TurretEnter"))
        R.TurretAngle  = cr(ev:FindFirstChild("TurretAngleChanged"))
        R.Breach       = cr(ev:FindFirstChild("Breach"))
        R.DoorEvent    = cr(ev:FindFirstChild("DoorEvent"))
        R.Stance       = cr(ev:FindFirstChild("Stance"))
        R.GrenadeCook  = cr(ev:FindFirstChild("GrenadeCookoff"))
        R.Grenade      = cr(ev:FindFirstChild("Grenade"))
    end
    if med then
        R.Collapse   = cr(med:FindFirstChild("Collapse"))
        R.MedHandler = cr(med:FindFirstChild("MedHandler"))
    end
    if pe then
        R.SpotPlayer   = cr(pe:FindFirstChild("SpotPlayer"))
        R.KillMe       = cr(pe:FindFirstChild("KillMe"))
        R.DropGiveAmmo = cr(pe:FindFirstChild("DropGiveAmmo"))
        R.RequestDeploy= cr(pe:FindFirstChild("RequestDeploy"))
        R.VehiclePers  = cr(pe:FindFirstChild("VehiclePersistence"))
        R.ClaimStarter = cr(pe:FindFirstChild("ClaimFreeStarterPack"))
        R.CollectCash  = cr(rs:FindFirstChild("CollectCashEvent"))
    end
    R.RequestGroundVeh = cr(rs:FindFirstChild("RequestGroundVehicleEvent"))
    R.RequestHeli      = cr(rs:FindFirstChild("RequestHelicopterEvent"))
    R.RequestPlane     = cr(rs:FindFirstChild("RequestPlaneEvent"))
    R.GrenadeCookGlobal= cr(rs:FindFirstChild("GrenadeCookoff"))
    R.FlareRep         = cr(rs:FindFirstChild("FlareReplicationEvent"))

    local n=0; for k,v in pairs(R) do if v then n=n+1 end end
    print(("[SA v13] Remotes loaded: %d"):format(n))
end)

-- ================================================================
-- SHOOT HOOK
-- ================================================================
local function hookShootModule()
    local SM=nil
    for _,obj in getgc(true) do
        if type(obj)~="table" then continue end
        local f=rawget(obj,"fire")
        if type(f)~="function" then continue end
        local ok,info=pcall(debug.getinfo,f)
        if ok and info and (info.nups or 0)>=5 then SM=obj; break end
    end
    if not SM then warn("[SA v13] ShootModule not found"); return end

    local origFire=SM.fire
    SM.fire=newcclosure(function(pl,origin,direction,shellData,extra)
        if CFG.Enabled and pl==LocalPlayer then
            if CFG.SilentAim and cachedTargetPos then
                local t=cachedTargetPos-origin
                if t.Magnitude>0 then direction=t.Unit end
            end
            if CFG.BulletTP and type(shellData)=="table" then shellData.shellSpeed=9e9 end
            if CFG.ShowTracer then
                local mp = getMuzzlePos()
                local ep = cachedTargetPos or (origin+direction*600)
                spawnTracer(mp, ep)
            end
            if cachedTargetPos and CFG.ShowHitmarker then
                task.delay(0.04, triggerHit)
            end
            if CFG.ForceHit and cachedTarget and R.Damage then
                task.defer(function()
                    local char=cachedTarget and cachedTarget.Character; if not char then return end
                    local hum=char:FindFirstChildOfClass("Humanoid")
                    local hp=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    if not hum or not hp or hum.Health<=0 then return end
                    local sd={weaponName="G19X",shellType="Bullet",shellName="9x19mm",
                        shellSpeed=9e9,maxPenetrationCount=0,currentPenetrationCount=0,
                        penetrationMultiplier=0.8,origin=origin,
                        bulletID=LocalPlayer.UserId..tick()..math.random(1,99999)}
                    pcall(function() R.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
                    triggerHit()
                end)
            end
        end
        return origFire(pl,origin,direction,shellData,extra)
    end)
    print("[SA v13] ShootModule hooked")
end

local function hookNamecall()
    local origNC
    origNC=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local m=getnamecallmethod()
        if CFG.Enabled and cachedTargetPos and m=="FireServer" then
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
    print("[SA v13] hookmetamethod OK")
end

-- ================================================================
-- KILL ALL
-- ================================================================
local function doKillAll()
    if not R.Damage then return end
    local myChar=LocalPlayer.Character
    local origin=myChar and myChar.HumanoidRootPart and myChar.HumanoidRootPart.Position
                or Camera.CFrame.Position
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
    end
end

-- SpotAll loop
task.spawn(function()
    while task.wait(2) do
        if CFG.SpotAll and R.SpotPlayer then
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LocalPlayer then
                    pcall(function() R.SpotPlayer:FireServer(pl) end)
                end
            end
        end
    end
end)

-- KillAll spam loop
RunService.Heartbeat:Connect(function()
    if CFG.KillAllSpam then
        doKillAll()
    end
    if CFG.GrenadeSpam and R.ServerGrenade then
        local o=Camera.CFrame.Position
        local tgt=cachedTargetPos or (o+Camera.CFrame.LookVector*50)
        local dir=(tgt-o).Unit
        pcall(function() R.ServerGrenade:FireServer(o,dir,{
            shellType="Grenade",shellName="M67",shellSpeed=50,origin=o,
            bulletID=LocalPlayer.UserId..tick()}) end)
    end
end)

-- ================================================================
-- EXPLOIT UI  (troll/damage focused)
-- ================================================================
local exploitUI=nil; local uiVis=false

local function buildUI()
    if exploitUI then return end
    local sg=Instance.new("ScreenGui")
    sg.Name="SA_Troll"; sg.ResetOnSpawn=false; sg.DisplayOrder=999
    pcall(function() sg.Parent=game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent=LocalPlayer:WaitForChild("PlayerGui") end

    local main=Instance.new("Frame",sg)
    main.Size=UDim2.new(0,320,0,520)
    main.Position=UDim2.new(0.5,-160,0.5,-260)
    main.BackgroundColor3=Color3.fromRGB(12,12,18)
    main.BorderSizePixel=0; main.Active=true; main.Draggable=true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke",main)
    stroke.Color=Color3.fromRGB(50,100,230); stroke.Thickness=1.5

    local title=Instance.new("TextLabel",main)
    title.Size=UDim2.new(1,-30,0,34); title.Position=UDim2.new(0,0,0,0)
    title.BackgroundColor3=Color3.fromRGB(18,18,30); title.BorderSizePixel=0
    title.Text="SA v13  |  Troll Panel"; title.TextColor3=Color3.fromRGB(80,180,255)
    title.TextSize=14; title.Font=Enum.Font.GothamBold
    Instance.new("UICorner",title).CornerRadius=UDim.new(0,8)

    local statusLbl=Instance.new("TextLabel",main)
    statusLbl.Size=UDim2.new(1,-16,0,20); statusLbl.Position=UDim2.new(0,8,0,36)
    statusLbl.BackgroundColor3=Color3.fromRGB(8,8,14); statusLbl.BorderSizePixel=0
    statusLbl.Text="Ready"; statusLbl.TextColor3=Color3.fromRGB(150,150,170)
    statusLbl.TextSize=11; statusLbl.Font=Enum.Font.Code
    statusLbl.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UICorner",statusLbl).CornerRadius=UDim.new(0,4)
    local function setS(msg,col)
        statusLbl.Text="> "..msg
        statusLbl.TextColor3=col or Color3.fromRGB(80,255,120)
    end

    local scroll=Instance.new("ScrollingFrame",main)
    scroll.Size=UDim2.new(1,-8,1,-62); scroll.Position=UDim2.new(0,4,0,60)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=4; scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local ll=Instance.new("UIListLayout",scroll); ll.Padding=UDim.new(0,3)
    local pp=Instance.new("UIPadding",scroll); pp.PaddingLeft=UDim.new(0,3)
    pp.PaddingRight=UDim.new(0,3); pp.PaddingTop=UDim.new(0,3)

    local ord=0
    local function sec(txt)
        ord=ord+1
        local l=Instance.new("TextLabel",scroll)
        l.Size=UDim2.new(1,0,0,18); l.LayoutOrder=ord
        l.BackgroundColor3=Color3.fromRGB(25,25,45); l.BorderSizePixel=0
        l.Text="  "..txt; l.TextColor3=Color3.fromRGB(80,160,255)
        l.TextSize=11; l.Font=Enum.Font.GothamSemibold
        l.TextXAlignment=Enum.TextXAlignment.Left
        Instance.new("UICorner",l).CornerRadius=UDim.new(0,4)
    end

    local function btn(lbl, desc, fn)
        ord=ord+1
        local f=Instance.new("Frame",scroll)
        f.Size=UDim2.new(1,0,0,44); f.LayoutOrder=ord
        f.BackgroundColor3=Color3.fromRGB(20,20,32); f.BorderSizePixel=0
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local b=Instance.new("TextButton",f)
        b.Size=UDim2.new(0,80,0,26); b.Position=UDim2.new(1,-86,0.5,-13)
        b.BackgroundColor3=Color3.fromRGB(35,85,195); b.BorderSizePixel=0
        b.Text=lbl; b.TextColor3=Color3.fromRGB(255,255,255)
        b.TextSize=11; b.Font=Enum.Font.GothamBold
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
        local d=Instance.new("TextLabel",f)
        d.Size=UDim2.new(1,-94,1,0); d.Position=UDim2.new(0,6,0,0)
        d.BackgroundTransparency=1; d.Text=desc
        d.TextColor3=Color3.fromRGB(150,150,175); d.TextSize=10
        d.Font=Enum.Font.Gotham; d.TextXAlignment=Enum.TextXAlignment.Left
        d.TextWrapped=true
        b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(50,105,220) end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(35,85,195) end)
        b.MouseButton1Click:Connect(function()
            b.BackgroundColor3=Color3.fromRGB(20,55,140)
            local ok2,err=pcall(fn,setS)
            if not ok2 then setS("ERR: "..tostring(err):sub(1,55),Color3.fromRGB(255,70,70)) end
            task.delay(0.25,function() b.BackgroundColor3=Color3.fromRGB(35,85,195) end)
        end)
    end

    -- ---- BUTTONS ----
    sec("== HELICOPTER / PLANE ==")
    btn("Crash Helis","Crash ALL helicopters (CrashEvent)",function(s)
        local rs2=game:GetService("ReplicatedStorage")
        local helis=rs2:FindFirstChild("Helicopters")
        if not helis then s("Helicopters not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,heli in helis:GetChildren() do
            local net=heli:FindFirstChild("Networking")
            local ce=net and net:FindFirstChild("CrashEvent")
            if ce then pcall(function() ce:FireServer() end); n=n+1 end
        end
        s("CrashEvent -> "..n.." helis")
    end)
    btn("Crash Planes","Crash ALL planes (CrashEvent)",function(s)
        local rs2=game:GetService("ReplicatedStorage")
        local planes=rs2:FindFirstChild("Planes")
        if not planes then s("Planes not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,plane in planes:GetChildren() do
            local net=plane:FindFirstChild("Networking")
            local ce=net and net:FindFirstChild("CrashEvent")
            if ce then pcall(function() ce:FireServer() end); n=n+1 end
        end
        s("CrashEvent -> "..n.." planes")
    end)
    btn("Heli DmgSpam","Spam DamageEvent for all helis",function(s)
        local rs2=game:GetService("ReplicatedStorage")
        local helis=rs2:FindFirstChild("Helicopters")
        if not helis then s("Helicopters not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,heli in helis:GetChildren() do
            local net=heli:FindFirstChild("Networking")
            local de=net and net:FindFirstChild("DamageEvent")
            if de then
                for _=1,10 do
                    task.spawn(function() pcall(function() de:FireServer(9999) end) end)
                end
                n=n+1
            end
        end
        s("DamageEvent x10 -> "..n.." helis")
    end)
    btn("Heli RocketFX","Fake rocket FX on all helis",function(s)
        local rs2=game:GetService("ReplicatedStorage")
        local helis=rs2:FindFirstChild("Helicopters")
        local n=0
        if helis then
            for _,heli in helis:GetChildren() do
                local net=heli:FindFirstChild("Networking")
                local re=net and net:FindFirstChild("RocketEvent")
                if re then
                    pcall(function() re:FireServer(Camera.CFrame.Position,Camera.CFrame.LookVector) end); n=n+1
                end
            end
        end
        if R.HeliRocketFX then
            pcall(function() R.HeliRocketFX:FireServer(Camera.CFrame.Position) end)
        end
        s("RocketEvent -> "..n.." helis")
    end)

    sec("== GROUND VEHICLES ==")
    btn("Dmg Vehicles","Spam Damage remote with vehicle HRP",function(s)
        if not R.Damage then s("Damage remote not ready",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,obj in workspace:GetDescendants() do
            -- find VehicleSeats with an occupant
            if obj:IsA("VehicleSeat") then
                local ok2,occ=pcall(function() return obj.Occupant end)
                if ok2 and occ then
                    local char=occ.Parent
                    local hum=char and char:FindFirstChildOfClass("Humanoid")
                    local hp=char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
                    if hum and hp then
                        local origin=Camera.CFrame.Position
                        local sd={weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                            maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                            origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random()}
                        for _=1,5 do
                            task.spawn(function()
                                pcall(function() R.Damage:InvokeServer(sd,hum,(hp.Position-origin).Magnitude,1,hp) end)
                            end)
                        end
                        n=n+1
                    end
                end
            end
        end
        s("Vehicle damage x5 on "..n.." seats")
    end)
    btn("TankFire FX","Fake TankFireFX at all enemies",function(s)
        if not R.TankFireFX then s("TankFireFX not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            local char=pl.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if root then
                pcall(function() R.TankFireFX:FireServer(root.Position,Camera.CFrame.LookVector) end)
                n=n+1
            end
        end
        s("TankFireFX -> "..n)
    end)
    btn("ExplosionFX","Spawn explosion FX at all enemies",function(s)
        if not R.ExplosionFX then s("ExplosionFX not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            local char=pl.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if root then
                pcall(function() R.ExplosionFX:FireServer(root.Position,10) end)
                n=n+1
            end
        end
        s("ExplosionFX -> "..n.." players")
    end)

    sec("== PLAYER TROLL ==")
    btn("SVFlash ALL","Flash grenade FX on all enemies",function(s)
        if not R.SVFlash then s("SVFlash not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function()
                pcall(function() R.SVFlash:FireServer(pl,Camera.CFrame.Position,3,true) end)
            end)
            n=n+1
        end
        s("SVFlash -> "..n.." players")
    end)
    btn("Collapse ALL","MedSys.Collapse on all enemies",function(s)
        if not R.Collapse then s("Collapse not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function() pcall(function() R.Collapse:FireServer(pl) end) end); n=n+1
        end
        s("Collapse -> "..n.." players")
    end)
    btn("Surrender ALL","Force Surrender on all enemies",function(s)
        if not R.Surrender then s("Surrender not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function() pcall(function() R.Surrender:FireServer(pl) end) end); n=n+1
        end
        s("Surrender -> "..n.." players")
    end)
    btn("HeadRot Spam","Spam HeadRot on all (glitchy necks)",function(s)
        if not R.HeadRot then s("HeadRot not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            for _=1,5 do
                task.spawn(function()
                    pcall(function() R.HeadRot:FireServer(pl, CFrame.Angles(math.pi,math.pi,math.pi)) end)
                end)
            end
            n=n+1
        end
        s("HeadRot x5 -> "..n.." players")
    end)
    btn("StopGrapple","Stop all grappling hooks",function(s)
        if not R.StopGrapple then s("StopGrappling not found",Color3.fromRGB(255,80,80)); return end
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function() pcall(function() R.StopGrapple:FireServer(pl) end) end)
        end
        s("StopGrappling -> all")
    end)
    btn("GrenadeCook","GrenadeCookoff on all enemies",function(s)
        local remote = R.GrenadeCook or R.GrenadeCookGlobal
        if not remote then s("GrenadeCookoff not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            task.spawn(function() pcall(function() remote:FireServer(pl) end) end); n=n+1
        end
        s("GrenadeCookoff -> "..n.." players")
    end)
    btn("Drag Target","Drag nearest enemy in FOV",function(s)
        if not R.Drag then s("Drag not found",Color3.fromRGB(255,80,80)); return end
        if not cachedTarget then s("No target in FOV",Color3.fromRGB(255,180,50)); return end
        local char=cachedTarget.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() R.Drag:FireServer(root) end); s("Drag -> "..cachedTarget.Name) end
    end)

    sec("== SERVER MISC ==")
    btn("OpenAllDoors","DoorEvent open all",function(s)
        if not R.DoorEvent then s("DoorEvent not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,v in workspace:GetDescendants() do
            if v.Name:lower():find("door") and v:IsA("Model") then
                pcall(function() R.DoorEvent:FireServer(v,true) end); n=n+1
            end
        end
        s("DoorEvent -> "..n.." doors")
    end)
    btn("Breach Walls","ACS Breach on all walls/barricades",function(s)
        if not R.Breach then s("Breach not found",Color3.fromRGB(255,80,80)); return end
        local n=0
        for _,v in workspace:GetDescendants() do
            if v:IsA("Model") and (v.Name:lower():find("wall") or v.Name:lower():find("barricade")) then
                pcall(function() R.Breach:FireServer(v) end); n=n+1
            end
        end
        s("Breach -> "..n)
    end)
    btn("CollectCash","CollectCashEvent spam x10",function(s)
        if not R.CollectCash then s("CollectCashEvent not found",Color3.fromRGB(255,80,80)); return end
        for _=1,10 do task.spawn(function() pcall(function() R.CollectCash:FireServer() end) end) end
        s("CollectCash x10")
    end)
    btn("FlareAll","FlareReplicationEvent on all helis",function(s)
        if not R.FlareRep then s("FlareRep not found",Color3.fromRGB(255,80,80)); return end
        pcall(function() R.FlareRep:FireServer() end)
        s("FlareReplicationEvent fired")
    end)
    btn("MLGHitmarker","Spam MLGHitmarker client FX",function(s)
        if not R.MLGHitmarker then s("MLGHitmarker not found",Color3.fromRGB(255,80,80)); return end
        for _=1,20 do
            task.spawn(function() pcall(function() R.MLGHitmarker:FireServer() end) end)
        end
        s("MLGHitmarker x20")
    end)

    -- close button
    local clsBtn=Instance.new("TextButton",main)
    clsBtn.Size=UDim2.new(0,22,0,22); clsBtn.Position=UDim2.new(1,-26,0,6)
    clsBtn.BackgroundColor3=Color3.fromRGB(170,35,35); clsBtn.BorderSizePixel=0
    clsBtn.Text="X"; clsBtn.TextColor3=Color3.fromRGB(255,255,255)
    clsBtn.TextSize=12; clsBtn.Font=Enum.Font.GothamBold
    Instance.new("UICorner",clsBtn).CornerRadius=UDim.new(0,4)
    clsBtn.MouseButton1Click:Connect(function()
        main.Visible=false; uiVis=false
    end)

    exploitUI=main
end

local function toggleUI()
    if not exploitUI then buildUI() end
    uiVis=not uiVis; exploitUI.Visible=uiVis
end

-- ================================================================
-- NOTIFY
-- ================================================================
local function notify(t,m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=t,Text=m,Duration=2})
    end)
end

-- ================================================================
-- INPUT
-- ================================================================
UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    local k=input.KeyCode
    if k==Enum.KeyCode.Insert then
        CFG.Enabled=not CFG.Enabled; notify("SilentAim",CFG.Enabled and "ON" or "OFF")
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
            u7Ref.ShootRate = CFG.FullAuto and 99999 or (u7Ref._origSR or u7Ref.ShootRate)
        end
        notify("FullAuto",CFG.FullAuto and "ON" or "OFF")
    elseif k==Enum.KeyCode.F7 then
        CFG.FFViewModel=not CFG.FFViewModel
        applyFF(CFG.FFViewModel)
        notify("FF ViewModel",CFG.FFViewModel and "ON" or "OFF")
    elseif k==Enum.KeyCode.F8 then
        CFG.ShowTracer=not CFG.ShowTracer; notify("Tracer",CFG.ShowTracer and "ON" or "OFF")
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
            for _,h in helis:GetChildren() do
                local net=h:FindFirstChild("Networking")
                local ce=net and net:FindFirstChild("CrashEvent")
                if ce then pcall(function() ce:FireServer() end) end
            end
        end
        notify("CrashAllHeli","sent")
    elseif k==Enum.KeyCode.RightControl then
        toggleUI()
    elseif k==Enum.KeyCode.PageUp then
        CFG.FOV=math.min(CFG.FOV+50,900); notify("FOV","= "..CFG.FOV)
    elseif k==Enum.KeyCode.PageDown then
        CFG.FOV=math.max(CFG.FOV-50,50); notify("FOV","= "..CFG.FOV)
    end
end)

-- ================================================================
-- RENDER LOOP
-- ================================================================
RunService.RenderStepped:Connect(function()
    _fc=_fc+1
    local upd=(_fc%2==0)

    if upd then updateCache() end
    swAngle=swAngle+0.045

    -- STATUS
    local function b(v) return v and "ON" or "--" end
    dStatus.Text=("SA:%s BTP:%s WB:%s FH:%s IA:%s FA:%s FF:%s | KAS:%s GS:%s"):format(
        b(CFG.SilentAim and CFG.Enabled),b(CFG.BulletTP),b(CFG.WallBang),
        b(CFG.ForceHit),b(CFG.InfAmmo),b(CFG.FullAuto),b(CFG.FFViewModel),
        b(CFG.KillAllSpam),b(CFG.GrenadeSpam))
    dStatus.Color=CFG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)

    -- FOV CIRCLE
    dFOVCircle.Position=screenCenter()
    dFOVCircle.Radius=CFG.FOV
    dFOVCircle.Visible=CFG.ShowFOV and CFG.Enabled
    dFOVCircle.Color=(cachedTarget and Color3.fromRGB(255,80,80)) or Color3.fromRGB(255,255,255)

    -- TRACER FADE-OUT (Transparency goes 0.3 -> 1.0 as age grows, plus shrinks from end)
    local now=tick(); local ti=1
    while ti<=#tracers do
        local tr=tracers[ti]; local age=now-tr.born
        if age>TRACER_LIFE then
            tr.line:Remove(); table.remove(tracers,ti)
        else
            local sp1,v1=w2s(tr.from3d); local sp2,_=w2s(tr.to3d)
            if v1 then
                tr.line.Visible=true
                tr.line.From=sp1
                -- shrink from end: as age->1.0 the "To" approaches "From"
                local t=age/TRACER_LIFE
                tr.line.To=sp2:Lerp(sp1, t*0.4)
                -- fade out: transparency goes from 0.3 (semi-trans) to 1.0 (invisible)
                tr.line.Transparency=0.3 + t*0.7
            else
                tr.line.Visible=false
            end
            ti=ti+1
        end
    end

    -- AIM LINE  (muzzle -> target, RGB)
    if CFG.ShowAimLine and CFG.Enabled and cachedTargetPos then
        local mp=getMuzzlePos()
        local sp1,v1=w2s(mp)
        local sp2,_ =w2s(cachedTargetPos)
        if v1 then
            aimLine.Visible=true; aimLine.From=sp1; aimLine.To=sp2
            aimLine.Color=hsvToRgb((_fc*0.009)%1,1,1)
        else aimLine.Visible=false end
    else aimLine.Visible=false end

    -- SWASTIKA  (smaller: clamp(3500/dist,22,50))
    if CFG.ShowSwastika and CFG.Enabled and cachedTargetPos then
        local sp,vis=w2s(cachedTargetPos)
        if vis then
            local sz=math.clamp(3500/math.max(cachedDist,1), 22, 50)
            local col=hsvToRgb((tick()*0.55)%1,1,1)
            drawSwastika(sp, sz, swAngle, col)
        else hideSwastika() end
    else hideSwastika() end

    -- HITMARKER FADE-OUT
    local hmNow=tick()
    if CFG.ShowHitmarker and hmNow<hmUntil then
        local alpha=(hmUntil-hmNow)/0.18
        local c=screenCenter()
        local len,gap=8,5
        local segs={
            {c+Vector2.new(-gap-len,-gap-len), c+Vector2.new(-gap,-gap)},
            {c+Vector2.new( gap,-gap),         c+Vector2.new( gap+len,-gap-len)},
            {c+Vector2.new(-gap, gap),         c+Vector2.new(-gap-len, gap+len)},
            {c+Vector2.new( gap, gap),         c+Vector2.new( gap+len, gap+len)},
        }
        for i=1,4 do
            hmLines[i].Visible=true
            hmLines[i].From=segs[i][1]; hmLines[i].To=segs[i][2]
            -- fade-out: starts visible (low Transparency), then goes to 1 (invisible)
            hmLines[i].Transparency=1-alpha*0.9
        end
    else
        for i=1,4 do hmLines[i].Visible=false end
    end

    if not upd then return end

    -- PER-PLAYER ESP
    if not CFG.ESPEnabled then
        for _,e in pairs(espCache) do hideESP(e) end; return
    end

    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        local e=getESP(pl)
        local char=pl.Character
        if not char then hideESP(e); continue end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hum then hideESP(e); continue end

        local root=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        if not root or not head then hideESP(e); continue end

        -- always visible regardless of occlusion (no vis check on root)
        -- but skip if completely off-screen
        local _,_,rootZ=Camera:WorldToViewportPoint(root.Position)
        if rootZ<=0 then hideESP(e); continue end

        local hp=math.clamp(math.floor(hum.Health),0,100)
        local col=isTeammate(pl) and Color3.fromRGB(0,200,255) or Color3.fromRGB(255,60,60)

        -- Full-body bounding box (head top -> foot bottom)
        local headTop=head.Position+Vector3.new(0,head.Size.Y*0.5+0.1,0)
        local lfoot=char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
            or char:FindFirstChild("Left Leg") or char:FindFirstChild("Right Leg")
        local feetBot=lfoot and (lfoot.Position-Vector3.new(0,lfoot.Size.Y*0.5,0))
                              or (root.Position-Vector3.new(0,3.2,0))

        local spHead=w2s(headTop); local spFeet=w2s(feetBot)
        local boxH=math.abs(spFeet.Y-spHead.Y)
        if boxH<4 then hideESP(e); continue end
        local boxW=boxH*0.42
        local tl=Vector2.new(spHead.X-boxW, spHead.Y)
        local br=Vector2.new(spHead.X+boxW, spFeet.Y)
        local dist=math.floor((root.Position-Camera.CFrame.Position).Magnitude)

        if CFG.ShowBox then
            drawBox(e,tl,br,col)
            if CFG.ShowHP then drawHP(e,tl,br,hp)
            else e.hpBg.Visible=false; e.hpBar.Visible=false end
            if CFG.ShowName then
                e.name.Visible=true; e.name.Position=Vector2.new(spHead.X,tl.Y-15)
                e.name.Text=pl.Name; e.name.Color=col
            else e.name.Visible=false end
            if CFG.ShowDist then
                e.dist.Visible=true; e.dist.Position=Vector2.new(spHead.X,br.Y+3)
                e.dist.Text=dist.."m"
            else e.dist.Visible=false end
            if CFG.ShowState then
                local st=getState(char,hum)
                if st~="" then
                    e.state.Visible=true; e.state.Text=st
                    e.state.Position=Vector2.new(spHead.X,br.Y+14)
                else e.state.Visible=false end
            else e.state.Visible=false end
        else
            for _,l in ipairs(e.box) do l.Visible=false end
            e.hpBg.Visible=false; e.hpBar.Visible=false
            e.name.Visible=false; e.dist.Visible=false; e.state.Visible=false
        end

        if CFG.ShowSkeleton and hp>0 then
            drawSkeleton(e,char,col)
        else
            for _,l in ipairs(e.skel) do l.Visible=false end
            e.headCircle.Visible=false
        end
    end
end)

-- ================================================================
-- INIT
-- ================================================================
task.spawn(function()
    task.wait(1.5)
    hookShootModule()
    hookNamecall()
    task.delay(0.5, refreshGunRefs)
    print("[SA v13] Init complete")
    notify("SilentAim v13","Loaded! RCtrl = Troll UI")
end)
