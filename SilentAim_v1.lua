--[[
    SilentAim v9 -- ACS Engine (FastCastRedux)
    GitHub: AndreyZlo1/script | commit 70acb6c

    CHANGES v9:
    REMOVED:  NoRecoil (caused C stack overflow + FPS drops)
    ADDED:    Box ESP (corner style), R15 Skeleton, Name, Gradient HP Bar,
              Distance label, Player state (Prone/Crouch/Vehicle/Air/Swim)
    OPTIMIZED: ESP updates every 2 frames, GC scan once per weapon switch,
               InfAmmo uses pre-cached function list (no per-frame getgc)
    EXPLOITS: KillAll spam, SpotAll, GrenadeSpam, CrashAllHeli,
              ToggleMusic, SquadKickAll, EditKillConditions (NoAirPenalty)

    BINDS:
    Insert   = SilentAim on/off
    Delete   = BulletTP on/off
    End      = WallBang on/off
    Home     = ForceHit on/off
    F5       = FullAuto on/off
    F6       = InfAmmo on/off
    F7       = NoAirPenalty toggle
    F8       = FireRate x2
    F9       = FireRate reset
    F10      = KillAll (once)
    F11      = KillAllSpam Heartbeat on/off
    F12      = SpotAll on/off
    Numpad0  = GrenadeSpam on/off
    Numpad1  = CrashAllHeli
    Numpad2  = ToggleMusic (off)
    Numpad3  = SquadKickAll
    PgUp/Dn  = FOV +/-50
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local CFG = {
    Enabled=true, FOV=300, AimPart="Head", TeamCheck=true,
    PredictLead=true, LeadFactor=0.08,
    SilentAim=true, BulletTP=true, WallBang=true, ForceHit=false,
    FullAuto=false, InfAmmo=false, FireRate=nil,
    ESPEnabled=true, ShowBox=true, ShowSkeleton=true, ShowName=true,
    ShowHP=true, ShowDist=true, ShowState=true, ShowFOV=true,
    TeamColor=Color3.fromRGB(0,200,255), EnemyColor=Color3.fromRGB(255,60,60),
    FOVColor=Color3.fromRGB(255,255,255),
    KillAllSpam=false, SpotAll=false, GrenadeSpam=false,
    CrashAllHeli=false, NoAirPenalty=false,
}

-- Drawing helper
local function D(class, props)
    local d = Drawing.new(class)
    for k,v in props do d[k]=v end
    return d
end

-- Status bar
local dStatus = D("Text",{
    Visible=true,Size=13,Color=Color3.fromRGB(0,255,100),
    Outline=true,OutlineColor=Color3.fromRGB(0,0,0),
    Position=Vector2.new(10,10),ZIndex=10
})
local dFOV = D("Circle",{
    Visible=false,Radius=CFG.FOV,Color=CFG.FOVColor,
    Thickness=1,Filled=false,Transparency=0.5
})

-- ============================================================
--  ESP OBJECTS
-- ============================================================
local espCache = {}
local BOX_CORNER = 6

local function makeESP()
    local e = {}
    e.boxLines = {}
    for i=1,8 do
        e.boxLines[i] = D("Line",{Visible=false,Thickness=1.5,
            Color=Color3.fromRGB(255,255,255),Transparency=0.8})
    end
    e.hpBg   = D("Line",{Visible=false,Thickness=5,Color=Color3.fromRGB(0,0,0),Transparency=0.5})
    e.hpFill = D("Line",{Visible=false,Thickness=3,Color=Color3.fromRGB(0,255,80),Transparency=0.8})
    e.name   = D("Text",{Visible=false,Size=13,Color=Color3.fromRGB(255,255,255),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.dist   = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(200,200,200),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.state  = D("Text",{Visible=false,Size=11,Color=Color3.fromRGB(255,200,50),
        Outline=true,OutlineColor=Color3.fromRGB(0,0,0),Center=true})
    e.skelLines = {}
    for i=1,12 do
        e.skelLines[i] = D("Line",{Visible=false,Thickness=1,
            Color=Color3.fromRGB(255,255,255),Transparency=0.7})
    end
    return e
end

local function removeESP(e)
    for _,l in e.boxLines do l:Remove() end
    for _,l in e.skelLines do l:Remove() end
    e.hpBg:Remove(); e.hpFill:Remove()
    e.name:Remove(); e.dist:Remove(); e.state:Remove()
end

local function getESP(pl)
    if not espCache[pl] then espCache[pl]=makeESP() end
    return espCache[pl]
end

Players.PlayerRemoving:Connect(function(pl)
    if espCache[pl] then removeESP(espCache[pl]); espCache[pl]=nil end
end)

-- ============================================================
--  HELPERS
-- ============================================================
local function w2s(pos)
    local sp,vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X,sp.Y), vis
end

local function screenCenter() return Camera.ViewportSize/2 end

local function isTeammate(pl)
    if not CFG.TeamCheck then return false end
    return LocalPlayer.Team~=nil and LocalPlayer.Team==pl.Team
end

-- R15 skeleton connections
local SKELETON = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
}

local function getPlayerState(char, hum)
    if not hum then return "" end
    if hum.Health<=0 then return "X DEAD" end
    if char:FindFirstChildOfClass("Seat") then return "~ Vehicle" end
    if char:GetAttribute("Prone") then return "v Prone" end
    if char:GetAttribute("Crouching") or char:GetAttribute("Crouch") then return "^ Crouch" end
    local st = hum:GetState()
    if st==Enum.HumanoidStateType.Swimming then return "~ Swim" end
    if st==Enum.HumanoidStateType.Freefall then return "^ Air"  end
    if st==Enum.HumanoidStateType.Climbing  then return "^ Climb" end
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
local cachedDist=0; local cachedHP=0
local _fc=0

local function predictPos(part)
    if not CFG.PredictLead then return part.Position end
    local root = part.Parent:FindFirstChild("HumanoidRootPart") or part
    local ok,vel = pcall(function() return root.AssemblyLinearVelocity end)
    if not ok then return part.Position end
    return part.Position + vel*(cachedDist/1200)*CFG.LeadFactor
end

local function updateCache()
    local center = screenCenter()
    local camPos = Camera.CFrame.Position
    local best,bestPos,bestDist,bestSD,bestHP = nil,nil,0,math.huge,0
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        if isTeammate(pl) then continue end
        local char = pl.Character; if not char then continue end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then continue end
        local part = char:FindFirstChild(CFG.AimPart) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        local pp = predictPos(part)
        local sp,vis = w2s(pp); if not vis then continue end
        local sd = (sp-center).Magnitude
        if sd>CFG.FOV then continue end
        if sd<bestSD then
            bestSD=sd; best=pl; bestPos=pp
            bestDist=(pp-camPos).Magnitude; bestHP=math.floor(hum.Health)
        end
    end
    cachedTarget=best; cachedTargetPos=bestPos; cachedDist=bestDist; cachedHP=bestHP
end

-- ============================================================
--  ESP DRAW FUNCTIONS
-- ============================================================
local function drawBox(e, tl, br, col)
    local w=br.X-tl.X; local h=br.Y-tl.Y
    local cw=math.min(w*0.25,BOX_CORNER); local ch=math.min(h*0.25,BOX_CORNER)
    local segs = {
        {tl, tl+Vector2.new(cw,0)},
        {tl, tl+Vector2.new(0,ch)},
        {Vector2.new(br.X,tl.Y), Vector2.new(br.X,tl.Y)+Vector2.new(-cw,0)},
        {Vector2.new(br.X,tl.Y), Vector2.new(br.X,tl.Y)+Vector2.new(0,ch)},
        {br, br+Vector2.new(-cw,0)},
        {br, br+Vector2.new(0,-ch)},
        {Vector2.new(tl.X,br.Y), Vector2.new(tl.X,br.Y)+Vector2.new(cw,0)},
        {Vector2.new(tl.X,br.Y), Vector2.new(tl.X,br.Y)+Vector2.new(0,-ch)},
    }
    for i,seg in ipairs(segs) do
        local l=e.boxLines[i]; l.Visible=true; l.From=seg[1]; l.To=seg[2]; l.Color=col
    end
end

local function drawSkeleton(e, char, col)
    local pts = {}
    for _,p in char:GetChildren() do
        if p:IsA("BasePart") then pts[p.Name]=p end
    end
    for i,conn in ipairs(SKELETON) do
        local l = e.skelLines[i]; if not l then continue end
        local a = pts[conn[1]]; local b = pts[conn[2]]
        if a and b then
            local sa,va = w2s(a.Position); local sb,vb = w2s(b.Position)
            if va and vb then
                l.Visible=true; l.From=sa; l.To=sb; l.Color=col
            else l.Visible=false end
        else l.Visible=false end
    end
end

local function drawHPBar(e, tl, br, hp)
    local x = tl.X-6
    e.hpBg.Visible=true
    e.hpBg.From=Vector2.new(x,br.Y); e.hpBg.To=Vector2.new(x,tl.Y)
    e.hpBg.Color=Color3.fromRGB(20,20,20)
    local midY = br.Y+(tl.Y-br.Y)*(hp/100)
    local r=math.floor(255*(1-hp/100)); local g=math.floor(255*(hp/100))
    e.hpFill.Visible=true
    e.hpFill.From=Vector2.new(x,br.Y); e.hpFill.To=Vector2.new(x,midY)
    e.hpFill.Color=Color3.fromRGB(r,g,0)
end

local function hideESP(e)
    for _,l in e.boxLines do l.Visible=false end
    for _,l in e.skelLines do l.Visible=false end
    e.hpBg.Visible=false; e.hpFill.Visible=false
    e.name.Visible=false; e.dist.Visible=false; e.state.Visible=false
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    _fc=_fc+1; local upd=(_fc%2==0)
    if upd then updateCache() end

    local function b(v) return v and "ON" or "--" end
    dStatus.Text = string.format(
        "SA:%s BTP:%s WB:%s FA:%s IA:%s FH:%s | KA:%s GA:%s SP:%s",
        b(CFG.SilentAim and CFG.Enabled),b(CFG.BulletTP),b(CFG.WallBang),
        b(CFG.FullAuto),b(CFG.InfAmmo),b(CFG.ForceHit),
        b(CFG.KillAllSpam),b(CFG.GrenadeSpam),b(CFG.SpotAll))
    dStatus.Color = CFG.Enabled and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)

    dFOV.Position = screenCenter(); dFOV.Visible=CFG.ShowFOV and CFG.Enabled
    dFOV.Radius   = CFG.FOV
    dFOV.Color    = (cachedTarget and CFG.EnemyColor) or CFG.FOVColor

    if not upd then return end
    if not CFG.ESPEnabled then
        for _,e in espCache do hideESP(e) end
        return
    end

    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LocalPlayer then continue end
        local e = getESP(pl)
        local char = pl.Character
        if not char then hideESP(e); continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then hideESP(e); continue end
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not root or not head then hideESP(e); continue end
        local hp  = math.clamp(math.floor(hum.Health),0,100)
        local col = isTeammate(pl) and CFG.TeamColor or CFG.EnemyColor
        local rootSP,rootVis = w2s(root.Position)
        local headSP,_       = w2s(head.Position+Vector3.new(0,0.5,0))
        if not rootVis then hideESP(e); continue end
        local dist = math.floor((root.Position-Camera.CFrame.Position).Magnitude)

        if CFG.ShowBox then
            local ht=math.abs(headSP.Y-rootSP.Y); local wd=ht*0.55
            local tl=Vector2.new(headSP.X-wd,headSP.Y)
            local br=Vector2.new(headSP.X+wd,rootSP.Y)
            drawBox(e,tl,br,col)
            if CFG.ShowHP then drawHPBar(e,tl,br,hp)
            else e.hpBg.Visible=false; e.hpFill.Visible=false end
            if CFG.ShowName then
                e.name.Visible=true
                e.name.Position=Vector2.new(headSP.X,tl.Y-16)
                e.name.Text=pl.Name; e.name.Color=col
            else e.name.Visible=false end
            if CFG.ShowDist then
                e.dist.Visible=true
                e.dist.Position=Vector2.new(rootSP.X,br.Y+4)
                e.dist.Text=dist.."m"
            else e.dist.Visible=false end
            if CFG.ShowState then
                local st=getPlayerState(char,hum)
                if st~="" then
                    e.state.Visible=true
                    e.state.Position=Vector2.new(rootSP.X,br.Y+16)
                    e.state.Text=st
                else e.state.Visible=false end
            else e.state.Visible=false end
        else
            for _,l in e.boxLines do l.Visible=false end
            e.hpBg.Visible=false; e.hpFill.Visible=false
            e.name.Visible=false; e.dist.Visible=false; e.state.Visible=false
        end

        if CFG.ShowSkeleton and hp>0 then
            drawSkeleton(e,char,col)
        else
            for _,l in e.skelLines do l.Visible=false end
        end
    end
end)

-- ============================================================
--  REMOTES
-- ============================================================
local Remotes = {}
task.spawn(function()
    local rs = game:GetService("ReplicatedStorage")
    local function sw(p,n)
        local ok,r = pcall(function() return p:WaitForChild(n,10) end)
        return ok and r or nil
    end
    local function cr(i) return (i and cloneref) and cloneref(i) or i end

    local engine = sw(rs,"ACS_Engine")
    local events = engine and sw(engine,"Events")
    local pe     = sw(rs,"PlayerEvents")

    if events then
        Remotes.ServerBullet  = cr(events:FindFirstChild("ServerBullet"))
        Remotes.Damage        = cr(events:FindFirstChild("Damage"))
        Remotes.ServerGrenade = cr(events:FindFirstChild("ServerGrenade"))
        Remotes.GunStance     = cr(events:FindFirstChild("GunStance"))
        Remotes.EditKillConds = cr(events:FindFirstChild("EditKillConditions"))
    end
    if pe then
        Remotes.SpotPlayer        = cr(pe:FindFirstChild("SpotPlayer"))
        Remotes.KillMe            = cr(pe:FindFirstChild("KillMe"))
        Remotes.ReliableHeliEvent = cr(pe:FindFirstChild("ReliableHeliEvent"))
        Remotes.ToggleMusic       = cr(pe:FindFirstChild("ToggleMusic"))
        Remotes.SquadKickPlayer   = cr(pe:FindFirstChild("SquadKickPlayer"))
    end

    local ok_list = {}
    for k,v in Remotes do if v then ok_list[#ok_list+1]=k end end
    print("[SA v9] Remotes: "..table.concat(ok_list,", "))
end)

-- ============================================================
--  GC REFS (called once per weapon switch)
-- ============================================================
local u7Ref=nil; local u64Ref=nil; local infAmmoFns={}

local function refreshGunRefs()
    u7Ref=nil; u64Ref=nil; infAmmoFns={}

    for _,obj in getgc(true) do
        if type(obj)~="table" then continue end
        if not u7Ref and rawget(obj,"ShootRate")~=nil
                      and rawget(obj,"ShootType")~=nil
                      and rawget(obj,"camRecoil")~=nil then
            u7Ref=obj
        end
        if not u64Ref then
            local ns=rawget(obj,"NextShot")
            if type(ns)=="number" and ns>1e12 then u64Ref=obj end
        end
    end

    for _,f in getgc(false) do
        if type(f)~="function" then continue end
        local ok,uvs=pcall(debug.getupvalues,f)
        if not ok then continue end
        local hasU7=false
        for _,uv in pairs(uvs) do
            if type(uv)=="table" and rawget(uv,"ShootRate")~=nil then hasU7=true; break end
        end
        if hasU7 then infAmmoFns[#infAmmoFns+1]=f end
    end

    if u7Ref then
        if not u7Ref._origShootType then u7Ref._origShootType=u7Ref.ShootType end
        if not u7Ref._origShootRate then u7Ref._origShootRate=u7Ref.ShootRate end
        print(string.format("[SA v9] u7 OK: ShootRate=%s ShootType=%s InfFns=%d",
            u7Ref.ShootRate, u7Ref.ShootType, #infAmmoFns))
    end
end

-- ============================================================
--  HEARTBEAT
-- ============================================================
RunService.Heartbeat:Connect(function()
    -- FullAuto: reset shot cooldown
    if CFG.FullAuto and u64Ref then
        u64Ref.NextShot=0
        if u64Ref.NextMobileShot then u64Ref.NextMobileShot=0 end
    end

    -- InfAmmo via cached fn list
    if CFG.InfAmmo then
        for _,f in infAmmoFns do
            local ok,uvs=pcall(debug.getupvalues,f)
            if not ok then continue end
            for idx,val in pairs(uvs) do
                if type(val)=="number" and val>=0 and val<=500 then
                    pcall(debug.setupvalue,f,idx,9999)
                end
            end
        end
    end

    -- KillAll spam
    if CFG.KillAllSpam and Remotes.Damage then
        local myChar = LocalPlayer.Character
        local origin = myChar and myChar:FindFirstChild("HumanoidRootPart")
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

    -- GrenadeSpam
    if CFG.GrenadeSpam and Remotes.ServerGrenade then
        local origin = Camera.CFrame.Position
        local target = cachedTargetPos or (origin+Camera.CFrame.LookVector*50)
        local dir = (target-origin).Unit
        pcall(function()
            Remotes.ServerGrenade:FireServer(origin,dir,{
                shellType="Grenade",shellName="M67",shellSpeed=50,
                origin=origin,bulletID=LocalPlayer.UserId..tick()
            })
        end)
    end
end)

-- ============================================================
--  HOOK ShootModule.fire
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
    if not SM then warn("[SA v9] ShootModule not found"); return end

    -- WallBang: patch canRayPierce
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
            if CFG.BulletTP and type(shellData)=="table" then
                shellData.shellSpeed=9e9
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
    print("[SA v9] ShootModule OK")
end

-- hookmetamethod fallback
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
    print("[SA v9] hookmetamethod OK")
end

-- ============================================================
--  EXPLOIT FUNCTIONS
-- ============================================================
local function doKillAll()
    if not Remotes.Damage then warn("[SA v9] Damage remote not found"); return end
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
            local dist=(hp.Position-origin).Magnitude
            local sd={weaponName="G19X",shellType="Bullet",shellName="9x19mm",shellSpeed=9e9,
                maxPenetrationCount=0,currentPenetrationCount=0,penetrationMultiplier=0.8,
                origin=origin,bulletID=LocalPlayer.UserId..tick()..math.random(1,999999)}
            for _=1,5 do
                pcall(function() Remotes.Damage:InvokeServer(sd,hum,dist,1,hp) end)
            end
        end)
        n=n+1
    end
    print("[SA v9] KillAll -> "..n.." players")
end

local function doSpotAll()
    if not Remotes.SpotPlayer then return end
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            task.spawn(function()
                pcall(function() Remotes.SpotPlayer:FireServer(pl) end)
            end)
        end
    end
end
task.spawn(function() while task.wait(2) do if CFG.SpotAll then doSpotAll() end end end)

local function doCrashAllHeli()
    if not Remotes.ReliableHeliEvent then warn("[SA v9] ReliableHeliEvent not found"); return end
    local n=0
    for _,obj in workspace:GetDescendants() do
        if obj:IsA("Model") then
            local req=obj:FindFirstChild("Required")
            if req and (req:FindFirstChild("Engine") or req:FindFirstChild("RotorPivot")) then
                task.spawn(function()
                    pcall(function() Remotes.ReliableHeliEvent:FireServer(obj,"crashExplode") end)
                end)
                n=n+1
            end
        end
    end
    print("[SA v9] CrashAllHeli -> "..n.." vehicles")
end

local function doToggleMusic(state)
    if not Remotes.ToggleMusic then warn("[SA v9] ToggleMusic not found"); return end
    pcall(function() Remotes.ToggleMusic:FireServer(state) end)
end

local function doSquadKickAll()
    if not Remotes.SquadKickPlayer then warn("[SA v9] SquadKickPlayer not found"); return end
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer then
            task.spawn(function()
                pcall(function() Remotes.SquadKickPlayer:FireServer(pl) end)
            end)
        end
    end
    print("[SA v9] SquadKickAll sent")
end

-- NoAirPenalty continuous
task.spawn(function()
    while task.wait(0.2) do
        if CFG.NoAirPenalty and Remotes.EditKillConds then
            pcall(function() Remotes.EditKillConds:FireServer("InAir",false) end)
        end
    end
end)

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
                if u7Ref then
                    if CFG.FullAuto then u7Ref.ShootType=3 end
                    if CFG.FireRate  then u7Ref.ShootRate=CFG.FireRate end
                end
            end
        end
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
    print("[SA v9] Ready -- press Insert to toggle")
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
local function notify(t,m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=t,Text=m,Duration=2.5})
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k=input.KeyCode

    if k==Enum.KeyCode.Insert then
        CFG.Enabled=not CFG.Enabled; notify("SilentAim v9", CFG.Enabled and "ON" or "OFF")
    elseif k==Enum.KeyCode.Delete then
        CFG.BulletTP=not CFG.BulletTP; notify("BulletTP", CFG.BulletTP and "ON" or "OFF")
    elseif k==Enum.KeyCode.End then
        CFG.WallBang=not CFG.WallBang; notify("WallBang", CFG.WallBang and "ON" or "OFF")
    elseif k==Enum.KeyCode.Home then
        CFG.ForceHit=not CFG.ForceHit; notify("ForceHit", CFG.ForceHit and "ON" or "OFF")
    elseif k==Enum.KeyCode.F5 then
        CFG.FullAuto=not CFG.FullAuto; notify("FullAuto", CFG.FullAuto and "ON" or "OFF")
        if u7Ref then u7Ref.ShootType=CFG.FullAuto and 3 or (u7Ref._origShootType or 1) end
    elseif k==Enum.KeyCode.F6 then
        CFG.InfAmmo=not CFG.InfAmmo; notify("InfAmmo", CFG.InfAmmo and "ON" or "OFF")
    elseif k==Enum.KeyCode.F7 then
        CFG.NoAirPenalty=not CFG.NoAirPenalty
        notify("NoAirPenalty", CFG.NoAirPenalty and "ON" or "OFF")
    elseif k==Enum.KeyCode.F8 then
        if u7Ref then
            if not u7Ref._origShootRate then u7Ref._origShootRate=u7Ref.ShootRate end
            CFG.FireRate=u7Ref._origShootRate*2; u7Ref.ShootRate=CFG.FireRate
            notify("FireRate x2", CFG.FireRate.." RPM")
        end
    elseif k==Enum.KeyCode.F9 then
        if u7Ref and u7Ref._origShootRate then
            u7Ref.ShootRate=u7Ref._origShootRate; CFG.FireRate=nil
            notify("FireRate", "Reset -> "..u7Ref._origShootRate.." RPM")
        end
    elseif k==Enum.KeyCode.F10 then
        notify("KillAll","Sending..."); task.spawn(doKillAll)
    elseif k==Enum.KeyCode.F11 then
        CFG.KillAllSpam=not CFG.KillAllSpam
        notify("KillAllSpam", CFG.KillAllSpam and "ON (Heartbeat)" or "OFF")
    elseif k==Enum.KeyCode.F12 then
        CFG.SpotAll=not CFG.SpotAll; notify("SpotAll", CFG.SpotAll and "ON" or "OFF")
    elseif k==Enum.KeyCode.KeypadZero then
        CFG.GrenadeSpam=not CFG.GrenadeSpam; notify("GrenadeSpam", CFG.GrenadeSpam and "ON" or "OFF")
    elseif k==Enum.KeyCode.KeypadOne then
        notify("CrashAllHeli","..."); task.spawn(doCrashAllHeli)
    elseif k==Enum.KeyCode.KeypadTwo then
        notify("ToggleMusic","Music OFF"); doToggleMusic(false)
    elseif k==Enum.KeyCode.KeypadThree then
        notify("SquadKickAll","Kicking..."); task.spawn(doSquadKickAll)
    elseif k==Enum.KeyCode.PageUp then
        CFG.FOV=math.min(CFG.FOV+50,800); dFOV.Radius=CFG.FOV; notify("FOV","= "..CFG.FOV)
    elseif k==Enum.KeyCode.PageDown then
        CFG.FOV=math.max(CFG.FOV-50,50); dFOV.Radius=CFG.FOV; notify("FOV","= "..CFG.FOV)
    end
end)
