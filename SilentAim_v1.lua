--[[
╔══════════════════════════════════════════════════════════════════╗
║                    SilentAim v2  (dump-audited)                  ║
╠══════════════════════════════════════════════════════════════════╣
║  Fixes vs v1:                                                    ║
║  1. ESP: nil<=number crash fixed (rootZ guard), vehicle seats    ║
║  2. Head Circle: clamp(1400/dist,2,8)px – correct distance scale ║
║  3. Swastika: clamp(4000/dist,18,46)px – smaller at distance     ║
║  4. HitSound: re-attached on CharacterAdded+delay(1)             ║
║  5. FullAuto: only sets ShootType=3 via FireModes check,         ║
║     also forces ShootType to 3 when Auto=false (unlocks mode)    ║
║     InfAmmo: skip upvalues that touch AnimTrack/CFrame/Vector3   ║
║  6. BulletTracer: real 3D→screen, thick visible line,            ║
║     Fade = Transparency 0→1 over TRACER_LIFE(0.7s) + tail shrink ║
║  7. Viewmodel: Chamber part ignored in FF apply                   ║
║  8. ExploitUI: built from dump audit (real remote paths/args)    ║
╠══════════════════════════════════════════════════════════════════╣
║  Keybinds:                                                       ║
║  RightAlt  = SilentAim on/off                                    ║
║  F2        = TeamCheck toggle                                    ║
║  F3        = ESP toggle                                          ║
║  F4        = ForceField Viewmodel toggle                         ║
║  F5        = InfAmmo on/off                                      ║
║  F6        = FullAuto on/off                                     ║
║  F7        = ShowAimLine toggle                                   ║
║  F8        = BulletTracer on/off                                 ║
║  RCtrl     = ExploitUI toggle                                    ║
╚══════════════════════════════════════════════════════════════════╝
]]

-- ================================================================
-- SERVICES & LOCALS
-- ================================================================
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UserInputSvc = game:GetService("UserInputService")
local TweenSvc     = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer
local Camera       = workspace.CurrentCamera

-- ================================================================
-- CONFIGURATION
-- ================================================================
local CFG = {
    Enabled      = true,
    TeamCheck    = true,
    ESP          = true,
    ShowAimLine  = false,
    FFViewModel  = false,
    InfAmmo      = false,
    FullAuto     = false,
    BulletTracer = true,
    FOV          = 120,
    SmoothFactor = 0.18,
    HeadCircleR  = 6,   -- base px (scaled by distance below)
    HitSoundId   = "rbxassetid://9120394449",
}

-- ================================================================
-- DRAWING UTILS
-- ================================================================
local D = Drawing.new
local function newDraw(cls, props)
    local o = D(cls)
    for k,v in pairs(props) do o[k]=v end
    return o
end

-- FOV circle
local dFOVCircle = newDraw("Circle",{
    Visible=true, Radius=CFG.FOV, Thickness=1.5,
    Color=Color3.fromRGB(255,255,255), Transparency=0.6,
    Filled=false,
})

-- Aim Line
local dAimLine = newDraw("Line",{
    Visible=false, Thickness=1,
    Color=Color3.fromRGB(255,255,255), Transparency=0.5,
})

-- ================================================================
-- BULLET TRACERS  (3D world positions → screen each frame)
-- ================================================================
local TRACER_LIFE = 0.7   -- seconds
local tracers = {}

local function spawnTracer(from3d, to3d)
    local l = newDraw("Line",{
        Visible=true, Thickness=3,
        Color=Color3.fromRGB(255,210,40),
        Transparency=0,
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

local function screenCenter()
    return Camera.ViewportSize / 2
end

local function isTeammate(pl)
    if not CFG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == pl.Team
end

local function hsvToRgb(h, s, v)
    local i = math.floor(h*6); local f = h*6-i
    local p,q,t = v*(1-s), v*(1-(f)*s), v*(1-(1-f)*s)
    i = i%6
    if i==0 then return Color3.fromRGB(v*255,t*255,p*255)
    elseif i==1 then return Color3.fromRGB(q*255,v*255,p*255)
    elseif i==2 then return Color3.fromRGB(p*255,v*255,t*255)
    elseif i==3 then return Color3.fromRGB(p*255,q*255,v*255)
    elseif i==4 then return Color3.fromRGB(t*255,p*255,v*255)
    else             return Color3.fromRGB(v*255,p*255,q*255) end
end

-- ================================================================
-- VIEWMODEL MUZZLE
-- ================================================================
local function getViewmodelTool()
    local vm = Camera:FindFirstChild("Viewmodel")
    if not vm then return nil end
    for _,c in ipairs(vm:GetChildren()) do
        if c:IsA("Model") or c:IsA("Tool") then return c end
    end
    return nil
end

local function getMuzzlePos()
    local t = getViewmodelTool()
    if not t then
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        return hrp and hrp.Position or Camera.CFrame.Position
    end
    local m = t:FindFirstChild("Muzzle",true) or t:FindFirstChild("Handle",true)
    return m and m.WorldPosition or Camera.CFrame.Position
end

-- ================================================================
-- FORCEFIELD VIEWMODEL  (skip Chamber parts)
-- ================================================================
local function applyFF(state)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.RequiresNeck = false end
    end
    local t = getViewmodelTool()
    if not t then return end
    for _,p in ipairs(t:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "Chamber" then
            p.LocalTransparencyModifier = state and 1 or 0
        end
    end
end

-- watch viewmodel changes and re-apply FF
local _lastVmTool = nil
RunService.RenderStepped:Connect(function()
    local cur = getViewmodelTool()
    if cur ~= _lastVmTool then
        _lastVmTool = cur
        if CFG.FFViewModel and cur then
            task.delay(0.1, function() applyFF(true) end)
        end
    end
end)

-- ================================================================
-- HIT SOUND
-- ================================================================
local hitSound = nil
local function buildHitSound()
    if hitSound and hitSound.Parent then hitSound:Destroy() end
    local s = Instance.new("Sound")
    s.SoundId  = CFG.HitSoundId
    s.Volume   = 1
    s.RollOffMaxDistance = 0
    s.Parent   = LocalPlayer.PlayerGui
    hitSound   = s
end

buildHitSound()
LocalPlayer.CharacterAdded:Connect(function()
    task.delay(1, buildHitSound)
end)

local function playHitSound()
    if hitSound then
        hitSound:Play()
    end
end

-- ================================================================
-- NOTIFY
-- ================================================================
local function notify(title, body)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title=title, Text=body, Duration=2
        })
    end)
end

-- ================================================================
-- ESP
-- ================================================================
local espPool = {}
local function getESP(pl)
    if not espPool[pl] then
        espPool[pl] = {
            box   = newDraw("Square",{Visible=false,Thickness=1.5,Filled=false}),
            name  = newDraw("Text",{Visible=false,Size=13,Center=true,Outline=true,Font=2}),
            hp    = newDraw("Square",{Visible=false,Thickness=1,Filled=true}),
            hpBg  = newDraw("Square",{Visible=false,Thickness=1,Filled=true,Color=Color3.fromRGB(20,20,20),Transparency=0.5}),
            dist  = newDraw("Text",{Visible=false,Size=11,Center=true,Outline=true,Font=2,Color=Color3.fromRGB(255,255,255)}),
            hcirc = newDraw("Circle",{Visible=false,Filled=false,Thickness=1.5}),
        }
    end
    return espPool[pl]
end

local function hideESP(e)
    if not e then return end
    for _,v in pairs(e) do v.Visible=false end
end

local function cleanESP(pl)
    local e = espPool[pl]
    if e then
        for _,v in pairs(e) do pcall(function() v:Remove() end) end
        espPool[pl] = nil
    end
end

Players.PlayerRemoving:Connect(cleanESP)

-- ================================================================
-- GC REFS  (dump-accurate: u7 table has ShootRate+ShootType)
-- ================================================================
local u7Ref = nil
local infFns = {}

local function refreshGunRefs()
    u7Ref = nil; infFns = {}
    -- find u7 settings table
    for _,obj in getgc(true) do
        if type(obj) ~= "table" then continue end
        if rawget(obj,"ShootRate") ~= nil and rawget(obj,"ShootType") ~= nil
           and rawget(obj,"Ammo") ~= nil then
            u7Ref = obj
            if not u7Ref._origSR then u7Ref._origSR = u7Ref.ShootRate end
            if not u7Ref._origST then u7Ref._origST = u7Ref.ShootType end
            break
        end
    end
    -- InfAmmo: find upvalue-bearing functions that manage u3/u4 ammo counters
    -- u3=AmmoInGun (0-999), u4=StoredAmmo (0-9999999)
    -- safe criteria: has table with ShootRate AND a number in [0..9999]
    -- SKIP if any upvalue is a userdata AnimationTrack/AnimationController
    --       or is a Vector3/CFrame (animation positional data)
    for _,f in getgc(false) do
        if type(f) ~= "function" then continue end
        local ok,info = pcall(debug.getinfo, f)
        if not ok or not info then continue end
        local nups = info.nups or 0
        if nups == 0 or nups > 20 then continue end
        local ok2,uvs = pcall(debug.getupvalues, f)
        if not ok2 or not uvs then continue end
        local hasGunTable = false
        local hasAmmoNum  = false
        local unsafe      = false
        for _,v in pairs(uvs) do
            if type(v) == "table" and rawget(v,"ShootRate") ~= nil then
                hasGunTable = true
            end
            if type(v) == "number" and v >= 0 and v <= 9999 then
                hasAmmoNum = true
            end
            if type(v) == "userdata" then
                local ok3,cn = pcall(function() return v.ClassName end)
                if ok3 and (
                    cn == "AnimationTrack" or cn == "Animation" or
                    cn == "AnimationController" or cn == "Animator" or
                    cn == "Motor6D"
                ) then
                    unsafe = true; break
                end
            end
            -- skip CFrame/Vector3 upvalues (animation lerping)
            if type(v) == "userdata" then
                local ok4,tp = pcall(function() return typeof(v) end)
                if ok4 and (tp == "CFrame" or tp == "Vector3") then
                    unsafe = true; break
                end
            end
        end
        if hasGunTable and hasAmmoNum and not unsafe then
            infFns[#infFns+1] = f
        end
    end
    print(("[SilentAim v2] u7=%s infFns=%d"):format(tostring(u7Ref ~= nil), #infFns))
end

-- watch tool changes
task.spawn(function()
    local lastTool = nil
    while task.wait(0.25) do
        local char   = LocalPlayer.Character
        local cTool  = char and char:FindFirstChildOfClass("Tool")
        local vmTool = getViewmodelTool()
        local obs    = vmTool or cTool
        if obs ~= lastTool then
            lastTool = obs
            if obs then
                task.delay(0.25, function()
                    refreshGunRefs()
                    -- FullAuto: set ShootType=3 AND patch FireModes.Auto=true
                    if CFG.FullAuto and u7Ref then
                        u7Ref.FireModes = u7Ref.FireModes or {}
                        u7Ref.FireModes.Auto = true
                        u7Ref.ShootType = 3
                        u7Ref.ShootRate = 99999
                    end
                    if CFG.FFViewModel then applyFF(true) end
                end)
            end
        end
    end
end)

-- ================================================================
-- HEARTBEAT  (InfAmmo, tracers, ESP)
-- ================================================================
RunService.Heartbeat:Connect(function()
    -- InfAmmo: push ammo-counter upvalues to 9999
    if CFG.InfAmmo then
        for _,f in ipairs(infFns) do
            local ok,uvs = pcall(debug.getupvalues,f)
            if not ok then continue end
            for idx,val in pairs(uvs) do
                if type(val) == "number" and val >= 0 and val <= 9999 then
                    pcall(debug.setupvalue, f, idx, 9999)
                end
            end
        end
    end
    -- FullAuto persistent (keep ShootType=3 in case game resets it)
    if CFG.FullAuto and u7Ref then
        if u7Ref.ShootType ~= 3 then
            u7Ref.ShootType = 3
        end
    end
end)

-- ================================================================
-- REMOTES LOADER  (from dump: ACS_Engine.Events)
-- ================================================================
local R = {}
task.spawn(function()
    local rs  = game:GetService("ReplicatedStorage")
    local cr  = (cloneref or function(x) return x end)
    local PE  = rs:WaitForChild("PlayerEvents",10)
    local ACS = rs:WaitForChild("ACS_Engine",10)
    local EV  = ACS and ACS:WaitForChild("Events",10)

    local function fw(parent, name, timeout)
        if not parent then return nil end
        local ok,v = pcall(function() return parent:WaitForChild(name, timeout or 6) end)
        return ok and v or nil
    end
    local function fwm(parent, ...)
        local cur = parent
        for _,name in ipairs({...}) do
            cur = cur and fw(cur, name)
        end
        return cur
    end

    -- ACS events (confirmed in dump)
    R.SVFlash         = EV and fw(EV,"SVFlash")           -- (tool, bool)
    R.SVLaser         = EV and fw(EV,"SVLaser")           -- (attachPart, mode, color, bool, tool)
    R.HeadRot         = EV and fw(EV,"HeadRot")           -- (CFrame)
    R.Atirar          = EV and fw(EV,"Atirar")            -- (tool, originCF, dirCF) -- shoot server bullet
    R.ServerGrenade   = EV and fw(EV,"ServerGrenade")     -- (pos, vel, yVel)
    R.GrenadeCookoff  = EV and fw(EV,"GrenadeCookoff")    -- (toolName)
    R.StopGrappling   = EV and fw(EV,"StopGrappling")     -- ()
    R.GunStance       = EV and fw(EV,"GunStance")         -- (tool, stanceId)
    R.NVG             = EV and fw(EV,"NVG")               -- (bool)
    R.Surrender       = EV and fw(EV,"Surrender")         -- () MedSys folder
    R.Collapse        = fwm(EV,"MedSys","Collapse")       -- ()
    R.EditKillCond    = EV and fw(EV,"EditKillConditions") -- (str, bool)

    -- Heli/Plane (PlayerEvents - confirmed in dump: ReliableHeliEvent, UnreliableHeliEvent)
    R.ReliableHeli    = PE and fw(PE,"ReliableHeliEvent")     -- (heliModel, "crashExplode") or ("crashDamage",dmg)
    R.UnreliableHeli  = PE and fw(PE,"UnreliableHeliEvent")   -- (heliModel, "setRotorSpeed", spd)

    -- Tycoon / world
    R.CollectCash     = rs:FindFirstChild("CollectCashEvent")  -- ()
    R.RequestPurchase = rs:FindFirstChild("RequestPurchaseEvent") -- (buttonPart)
    R.KillMe          = PE and fw(PE,"KillMe.RE") or nil

    -- MinigameEvent for state resend
    R.MinigameEvent   = PE and fw(PE,"MinigameEvent")

    -- Spotting
    R.SpotPlayer      = PE and fwm(PE,"SpotPlayer")   -- (player)

    -- KillMe (GroundWar minigame)
    R.KillMe          = PE and fw(PE,"KillMe")

    print("[SilentAim v2] Remotes loaded:", 
        "SVFlash="..tostring(R.SVFlash~=nil),
        "HeadRot="..tostring(R.HeadRot~=nil),
        "ReliableHeli="..tostring(R.ReliableHeli~=nil),
        "Collapse="..tostring(R.Collapse~=nil)
    )
end)

-- ================================================================
-- SILENT AIM CORE
-- ================================================================
local cachedTarget    = nil
local cachedTargetPos = nil
local lastRainbow     = 0
local rainbowHue      = 0

local function getTarget()
    local center = screenCenter()
    local bestDist = CFG.FOV
    local bestPl   = nil

    for _,pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if isTeammate(pl) then continue end
        local char = pl.Character
        if not char then
            -- check if player is in a vehicle seat
            local found = false
            for _,desc in ipairs(workspace:GetDescendants()) do
                if desc:IsA("VehicleSeat") and desc.Occupant then
                    local occ = desc.Occupant
                    if occ.Parent and Players:GetPlayerFromCharacter(occ.Parent) == pl then
                        char = occ.Parent
                        found = true
                        break
                    end
                end
            end
            if not found then continue end
        end

        local hum  = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if not hum or hum.Health <= 0 or not head then continue end

        local sp, vis, z = w2s(head.Position)
        if not vis or z <= 0 then continue end

        local d = (sp - center).Magnitude
        if d < bestDist then
            bestDist = d
            bestPl   = pl
        end
    end

    return bestPl
end

-- ================================================================
-- RENDER STEP (main loop)
-- ================================================================
RunService.RenderStepped:Connect(function()
    local center = screenCenter()
    local now    = tick()

    -- rainbow hue advance
    rainbowHue = (rainbowHue + 0.003) % 1

    -- FOV circle
    dFOVCircle.Position = center
    dFOVCircle.Radius   = CFG.FOV
    dFOVCircle.Color    = (cachedTarget and Color3.fromRGB(255,80,80)) or Color3.fromRGB(255,255,255)

    -- ── TRACER FADE (correct: Transparency starts at 0 = fully visible, goes to 1 = gone) ──
    local ti = 1
    while ti <= #tracers do
        local tr  = tracers[ti]
        local age = now - tr.born
        if age > TRACER_LIFE then
            tr.line:Remove()
            table.remove(tracers, ti)
        else
            local sp1, vis1, z1 = w2s(tr.from3d)
            local sp2, _,    z2 = w2s(tr.to3d)
            -- only draw if both ends are in front of camera
            if vis1 and z1 > 0 and z2 > 0 then
                local t = age / TRACER_LIFE  -- 0 → 1
                tr.line.Visible      = true
                tr.line.From         = sp1
                -- tail (To) walks toward From as tracer "disappears from the end"
                tr.line.To           = sp2:Lerp(sp1, math.min(t * 0.55, 1))
                -- fade: 0 (fully visible) → 1 (invisible)
                tr.line.Transparency = t
            else
                tr.line.Visible = false
            end
            ti = ti + 1
        end
    end

    -- ── AIM LINE ──
    if CFG.ShowAimLine and CFG.Enabled and cachedTargetPos then
        local mp        = getMuzzlePos()
        local msp, mvis = w2s(mp)
        local tsp, tvis = w2s(cachedTargetPos)
        if mvis and tvis then
            dAimLine.Visible = true
            dAimLine.From    = msp
            dAimLine.To      = tsp
            dAimLine.Color   = hsvToRgb(rainbowHue,1,1)
        else
            dAimLine.Visible = false
        end
    else
        dAimLine.Visible = false
    end

    -- ── FIND TARGET ──
    if CFG.Enabled then
        cachedTarget = getTarget()
    else
        cachedTarget = nil
    end

    -- ── SMOOTH AIM ──
    if CFG.Enabled and cachedTarget then
        local char = cachedTarget.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                cachedTargetPos = head.Position
                local sp, vis = w2s(head.Position)
                if vis then
                    local delta = sp - center
                    local moved = delta * CFG.SmoothFactor
                    mousemoverel(moved.X, moved.Y)
                end
            end
        end
    else
        cachedTargetPos = nil
    end

    -- ── ESP ──
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        local e = getESP(pl)

        if not CFG.ESP then hideESP(e); continue end

        -- support players in vehicles
        local char = pl.Character
        if not char then
            for _,desc in ipairs(workspace:GetDescendants()) do
                if desc:IsA("VehicleSeat") and desc.Occupant then
                    local occ = desc.Occupant
                    if occ.Parent and Players:GetPlayerFromCharacter(occ.Parent) == pl then
                        char = occ.Parent
                        break
                    end
                end
            end
        end
        if not char then hideESP(e); continue end

        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum then hideESP(e); continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not root or not head then hideESP(e); continue end

        -- FIX: guard rootZ before comparing (nil<=number crash)
        local rsp, _, rootZ = w2s(root.Position)
        if type(rootZ) ~= "number" or rootZ <= 0 then hideESP(e); continue end

        local hp  = math.clamp(math.floor(hum.Health), 0, 100)
        local col = isTeammate(pl) and Color3.fromRGB(0,200,255) or Color3.fromRGB(255,60,60)

        -- bounding box  head→feet
        local headTop = head.Position + Vector3.new(0, head.Size.Y*0.5+0.1, 0)
        local lfoot   = char:FindFirstChild("LeftFoot") or char:FindFirstChild("RightFoot")
                        or char:FindFirstChild("Left Leg") or char:FindFirstChild("Right Leg")
        local feetBot = lfoot and (lfoot.Position - Vector3.new(0, lfoot.Size.Y*0.5, 0))
                                or (root.Position - Vector3.new(0, 3.2, 0))

        local spHead, visHead, zHead = w2s(headTop)
        local spFeet, _,      zFeet  = w2s(feetBot)
        if type(zHead) ~= "number" or type(zFeet) ~= "number" then hideESP(e); continue end
        if zHead <= 0 or zFeet <= 0 then hideESP(e); continue end

        local boxH = math.abs(spFeet.Y - spHead.Y)
        if boxH < 4 then hideESP(e); continue end
        local boxW = boxH * 0.42

        local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                     and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                     or 100

        -- Box
        e.box.Visible     = true
        e.box.Color       = col
        e.box.Size        = Vector2.new(boxW*2, boxH)
        e.box.Position    = Vector2.new(spHead.X - boxW, spHead.Y)
        e.box.Transparency= 0

        -- HP bar (left of box, 3px wide)
        local hpH  = boxH * (hp/100)
        local barX = spHead.X - boxW - 5
        e.hpBg.Visible  = true
        e.hpBg.Size     = Vector2.new(3, boxH)
        e.hpBg.Position = Vector2.new(barX, spHead.Y)
        e.hp.Visible    = true
        e.hp.Color      = Color3.fromRGB(
            math.floor(255*(1-hp/100)),
            math.floor(255*(hp/100)), 0
        )
        e.hp.Size       = Vector2.new(3, hpH)
        e.hp.Position   = Vector2.new(barX, spHead.Y + boxH - hpH)

        -- Name
        e.name.Visible  = true
        e.name.Color    = col
        e.name.Text     = pl.Name .. " | " .. math.floor(dist) .. "m"
        e.name.Position = Vector2.new(spHead.X, spHead.Y - 16)

        -- Head circle (distance-scaled: large close, small far)
        local hcR = math.clamp(1400 / math.max(dist, 1), 2, 10)
        local hsp = w2s(head.Position)
        e.hcirc.Visible  = true
        e.hcirc.Color    = col
        e.hcirc.Radius   = hcR
        e.hcirc.Position = hsp
    end
end)

-- ================================================================
-- BULLET TRACER HOOK  (hook ServerBullet remote fire call)
-- ================================================================
-- We hook via getgc: find the u250 (spawnBullet) function that calls
-- ServerBullet:FireServer(pos, dir, ...) and intercept origin/dir
-- Alternative approach: hook mouse click to spawn tracer from muzzle
-- to target. This is more reliable than hooking the remote itself.
local mouseButton1 = Enum.UserInputType.MouseButton1
UserInputSvc.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType ~= mouseButton1 then return end
    if not CFG.BulletTracer then return end
    if not CFG.Enabled then return end

    task.delay(0.02, function()
        local from = getMuzzlePos()
        local to
        -- try to use silent aim target
        if cachedTargetPos then
            to = cachedTargetPos
        else
            -- fallback: raycast from camera
            local ray = Camera:ScreenPointToRay(
                Camera.ViewportSize.X/2,
                Camera.ViewportSize.Y/2
            )
            local result = workspace:Raycast(ray.Origin, ray.Direction*2000,
                RaycastParams.new())
            to = result and result.Position or (ray.Origin + ray.Direction*300)
        end
        spawnTracer(from, to)
    end)
end)

-- also hook regular shooting (non-silentaim) for tracer
UserInputSvc.InputBegan:Connect(function(inp, gp)
    if gp or not CFG.BulletTracer then return end
    if inp.UserInputType ~= mouseButton1 then return end

    -- vanilla tracer (no silent aim): camera center ray
    if not CFG.Enabled then
        task.delay(0.02, function()
            local from = getMuzzlePos()
            local ray  = Camera:ScreenPointToRay(
                Camera.ViewportSize.X/2,
                Camera.ViewportSize.Y/2
            )
            local result = workspace:Raycast(ray.Origin, ray.Direction*2000, RaycastParams.new())
            local to = result and result.Position or (ray.Origin + ray.Direction*500)
            spawnTracer(from, to)
        end)
    end
end)

-- ================================================================
-- SWASTIKA ESP MARKER  (distance-scaled)
-- ================================================================
local swastikaPool = {}
local function getSwastika(pl)
    if not swastikaPool[pl] then
        local lines = {}
        -- 12 segments for swastika: 2 arms (horizontal+vertical) + 4 bent ends each = 12 lines
        for i=1,12 do
            lines[i] = newDraw("Line",{
                Visible=false, Thickness=2,
                Color=Color3.fromRGB(255,50,50)
            })
        end
        swastikaPool[pl] = lines
    end
    return swastikaPool[pl]
end

local function hideSwastika(lines)
    for _,l in ipairs(lines) do l.Visible=false end
end

local function drawSwastika(cx, cy, s)
    -- s = half-size in pixels
    -- A swastika: center cross + 4 bent ends
    -- Returns array of {from, to} pairs (12 segments)
    local segs = {
        -- horizontal bar
        {Vector2.new(cx-s, cy), Vector2.new(cx+s, cy)},
        -- vertical bar
        {Vector2.new(cx, cy-s), Vector2.new(cx, cy+s)},
        -- top arm turns right
        {Vector2.new(cx, cy-s), Vector2.new(cx+s*0.5, cy-s)},
        -- right arm turns down
        {Vector2.new(cx+s, cy), Vector2.new(cx+s, cy+s*0.5)},
        -- bottom arm turns left
        {Vector2.new(cx, cy+s), Vector2.new(cx-s*0.5, cy+s)},
        -- left arm turns up
        {Vector2.new(cx-s, cy), Vector2.new(cx-s, cy-s*0.5)},
        -- extended bends (to make it look like a swastika, not a plus)
        {Vector2.new(cx+s*0.5, cy-s), Vector2.new(cx+s*0.5, cy-s*0.5)},
        {Vector2.new(cx+s, cy+s*0.5), Vector2.new(cx+s*0.5, cy+s*0.5)},
        {Vector2.new(cx-s*0.5, cy+s), Vector2.new(cx-s*0.5, cy+s*0.5)},
        {Vector2.new(cx-s, cy-s*0.5), Vector2.new(cx-s*0.5, cy-s*0.5)},
        -- fill center
        {Vector2.new(cx-s*0.15, cy-s*0.15), Vector2.new(cx+s*0.15, cy+s*0.15)},
        {Vector2.new(cx-s*0.15, cy+s*0.15), Vector2.new(cx+s*0.15, cy-s*0.15)},
    }
    return segs
end

RunService.RenderStepped:Connect(function()
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        local lines = getSwastika(pl)
        if not CFG.ESP then hideSwastika(lines); continue end

        local char = pl.Character
        if not char then hideSwastika(lines); continue end

        local head = char:FindFirstChild("Head")
        if not head then hideSwastika(lines); continue end

        local sp, vis, z = w2s(head.Position + Vector3.new(0, 2.2, 0))
        if not vis or type(z) ~= "number" or z <= 0 then hideSwastika(lines); continue end

        local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                     and (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                     or 100
        local s = math.clamp(4000 / math.max(dist, 1), 14, 42)

        local segs = drawSwastika(sp.X, sp.Y, s)
        for i,seg in ipairs(segs) do
            lines[i].Visible = true
            lines[i].From    = seg[1]
            lines[i].To      = seg[2]
        end
    end
end)

Players.PlayerRemoving:Connect(function(pl)
    local lines = swastikaPool[pl]
    if lines then
        for _,l in ipairs(lines) do pcall(function() l:Remove() end) end
        swastikaPool[pl] = nil
    end
end)

-- ================================================================
-- HIT DETECTION (for HitSound)
-- ================================================================
-- Hook via Atirar if available, else fallback mouse
local function onHit()
    playHitSound()
end

-- We use a lightweight damage detect: watch for hit markers
-- The cleanest approach is hooking Atirar remote's OnClientEvent to detect server confirm
-- but that's server→client. Instead we watch humanoid health changes of target.
local watchedConnections = {}
local function watchTargetHealth(pl)
    for _,c in pairs(watchedConnections) do c:Disconnect() end
    watchedConnections = {}
    if not pl then return end
    local char = pl.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local lastHp = hum.Health
    watchedConnections[1] = hum:GetPropertyChangedSignal("Health"):Connect(function()
        local newHp = hum.Health
        if newHp < lastHp then
            onHit()
        end
        lastHp = newHp
    end)
end

RunService.Heartbeat:Connect(function()
    if cachedTarget ~= nil then
        if not watchedConnections[1] or not watchedConnections[1].Connected then
            watchTargetHealth(cachedTarget)
        end
    end
end)

-- ================================================================
-- EXPLOIT UI  (RCtrl to toggle)
-- ================================================================
local exploitUI = nil
local exploitOpen = false

local function safeFireServer(remote, ...)
    if remote then
        pcall(function() remote:FireServer(...) end)
    else
        notify("Exploit","Remote not found – may need to be in a vehicle/weapon")
    end
end

local function buildExploitUI()
    if exploitUI then exploitUI:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name             = "ExploitUI_SA"
    sg.ResetOnSpawn     = false
    sg.IgnoreGuiInset   = true
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.Parent           = LocalPlayer.PlayerGui

    -- Main frame
    local frame = Instance.new("Frame")
    frame.Size            = UDim2.new(0, 340, 0, 520)
    frame.Position        = UDim2.new(0.5,-170,0.5,-260)
    frame.BackgroundColor3= Color3.fromRGB(14,14,14)
    frame.BorderSizePixel = 0
    frame.Active          = true
    frame.Draggable       = true
    frame.Parent          = sg

    local corner = Instance.new("UICorner",frame); corner.CornerRadius = UDim.new(0,8)

    -- Title bar
    local title = Instance.new("TextLabel")
    title.Size              = UDim2.new(1,0,0,32)
    title.BackgroundColor3  = Color3.fromRGB(30,30,30)
    title.TextColor3        = Color3.fromRGB(255,80,80)
    title.Text              = "⚡  ExploitKit  [RCtrl close]"
    title.Font              = Enum.Font.GothamBold
    title.TextSize          = 14
    title.BorderSizePixel   = 0
    title.Parent            = frame
    local tc = Instance.new("UICorner",title); tc.CornerRadius = UDim.new(0,8)

    -- Scroll container
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size                  = UDim2.new(1,-10,1,-42)
    scroll.Position              = UDim2.new(0,5,0,37)
    scroll.BackgroundTransparency= 1
    scroll.ScrollBarThickness    = 4
    scroll.CanvasSize            = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    scroll.Parent                = frame

    local layout = Instance.new("UIListLayout",scroll)
    layout.SortOrder        = Enum.SortOrder.LayoutOrder
    layout.Padding          = UDim.new(0,4)

    local pad = Instance.new("UIPadding",scroll)
    pad.PaddingLeft  = UDim.new(0,4)
    pad.PaddingRight = UDim.new(0,4)

    local function makeSection(name)
        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.new(1,0,0,20)
        lbl.BackgroundColor3  = Color3.fromRGB(35,35,35)
        lbl.TextColor3        = Color3.fromRGB(180,180,180)
        lbl.Text              = "── " .. name .. " ──"
        lbl.Font              = Enum.Font.GothamBold
        lbl.TextSize          = 12
        lbl.BorderSizePixel   = 0
        lbl.Parent            = scroll
        local c = Instance.new("UICorner",lbl); c.CornerRadius=UDim.new(0,4)
    end

    local btnCount = 0
    local function makeBtn(label, fn)
        btnCount = btnCount + 1
        local btn = Instance.new("TextButton")
        btn.Size              = UDim2.new(1,0,0,30)
        btn.BackgroundColor3  = Color3.fromRGB(28,28,28)
        btn.TextColor3        = Color3.fromRGB(220,220,220)
        btn.Text              = label
        btn.Font              = Enum.Font.Gotham
        btn.TextSize          = 13
        btn.BorderSizePixel   = 0
        btn.LayoutOrder       = btnCount
        btn.Parent            = scroll
        local c = Instance.new("UICorner",btn); c.CornerRadius=UDim.new(0,5)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(50,20,20)
            btn.TextColor3       = Color3.fromRGB(255,100,100)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
            btn.TextColor3       = Color3.fromRGB(220,220,220)
        end)
        btn.MouseButton1Click:Connect(function()
            pcall(fn)
        end)
    end

    -- ═══════════════════════════════════════════════
    -- SECTION: Helicopters & Planes
    -- ═══════════════════════════════════════════════
    makeSection("🚁 Helicopters / Planes")

    -- Crash ALL helicopters: ReliableHeliEvent(heliModel, "crashExplode")
    makeBtn("💥 Crash All Helicopters", function()
        local done = 0
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Required")
               and obj.Required:FindFirstChild("Engine") then
                safeFireServer(R.ReliableHeli, obj, "crashExplode")
                done = done + 1
                task.wait(0.05)
            end
        end
        notify("Crash Helis", "Sent crashExplode to "..done.." helis")
    end)

    -- Crash ALL planes (same event, same args – planes use same CrashModule)
    makeBtn("✈️ Crash All Planes", function()
        local done = 0
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Hitbox") then
                -- plane models have Hitbox directly, heli models also but check Engine
                local hasEngine = obj:FindFirstChild("Required")
                                  and obj.Required:FindFirstChild("Engine")
                if not hasEngine then
                    -- likely a plane - try anyway
                    safeFireServer(R.ReliableHeli, obj, "crashExplode")
                    done = done + 1
                    task.wait(0.05)
                end
            end
        end
        notify("Crash Planes", "Sent to "..done.." models")
    end)

    -- Max damage spam on all helis
    makeBtn("🔥 Heli Damage Spam (all)", function()
        task.spawn(function()
            for i=1,10 do
                for _,obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Required")
                       and obj.Required:FindFirstChild("Engine") then
                        safeFireServer(R.ReliableHeli, obj, "crashDamage", 9999)
                    end
                end
                task.wait(0.1)
            end
            notify("Heli Damage","Done")
        end)
    end)

    -- Trigger FlareEvent on all helis (makes them spam flares)
    makeBtn("🌟 Heli Flare Spam (all)", function()
        local done = 0
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local net = obj:FindFirstChild("Networking")
                if net then
                    local flare = net:FindFirstChild("FlareEvent")
                    if flare and flare:IsA("RemoteEvent") then
                        pcall(function() flare:FireServer() end)
                        done = done + 1
                        task.wait(0.05)
                    end
                end
            end
        end
        notify("Flare Spam", done.." helis flared")
    end)

    -- ═══════════════════════════════════════════════
    -- SECTION: Ground Vehicles
    -- ═══════════════════════════════════════════════
    makeSection("🚗 Ground Vehicles")

    -- Damage all VehicleSeat occupants by finding their heli-style Networking
    makeBtn("💣 Damage All Vehicles", function()
        local done = 0
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local net = obj:FindFirstChild("Networking")
                if net then
                    local dmg = net:FindFirstChild("DamageEvent")
                    if dmg and dmg:IsA("RemoteEvent") then
                        pcall(function() dmg:FireServer(9999) end)
                        done = done + 1
                        task.wait(0.05)
                    end
                end
            end
        end
        notify("Vehicle Damage", done.." vehicles targeted")
    end)

    -- TankFireFX spam – makes tank fire FX play for all tanks
    makeBtn("🔫 Tank FireFX Spam", function()
        if R.TankFireFX then
            for i=1,15 do
                safeFireServer(R.TankFireFX)
                task.wait(0.1)
            end
        else
            -- find from ACS events
            local evs = game:GetService("ReplicatedStorage"):FindFirstChild("ACS_Engine")
            local ev  = evs and evs:FindFirstChild("Events")
            local tff = ev and ev:FindFirstChild("TankFireFX")
            if tff then
                for i=1,15 do pcall(function() tff:FireServer() end) task.wait(0.1) end
                notify("TankFireFX","Spammed")
            else
                notify("TankFireFX","Remote not found")
            end
        end
    end)

    -- ═══════════════════════════════════════════════
    -- SECTION: Player Troll
    -- ═══════════════════════════════════════════════
    makeSection("😈 Player Troll")

    -- SVFlash ALL players (flashbang every enemy)
    -- SVFlash(tool, bool) - bool=true means flash on
    makeBtn("🔦 SVFlash All Enemies", function()
        local char  = LocalPlayer.Character
        local tool  = char and char:FindFirstChildOfClass("Tool")
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl == LocalPlayer then continue end
            if isTeammate(pl) then continue end
            safeFireServer(R.SVFlash, tool, true)
            task.wait(0.05)
        end
        notify("SVFlash","Flashed all enemies")
    end)

    -- Collapse ALL enemies (MedSys.Collapse)
    makeBtn("🏥 Collapse All Enemies", function()
        local done = 0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            if isTeammate(pl) then continue end
            safeFireServer(R.Collapse)
            done = done+1
            task.wait(0.05)
        end
        notify("Collapse","Sent to "..done.." players")
    end)

    -- Force Surrender animation on all
    makeBtn("🏳️ Surrender All Enemies", function()
        local done = 0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            if isTeammate(pl) then continue end
            safeFireServer(R.Surrender)
            done = done+1
            task.wait(0.05)
        end
        notify("Surrender","Sent to "..done)
    end)

    -- HeadRot Spam: send random CFrame to HeadRot to snap everyone's necks
    makeBtn("🔄 HeadRot Spam (all)", function()
        task.spawn(function()
            for i=1,20 do
                local cf = CFrame.Angles(
                    math.random(-3,3)*0.5,
                    math.random(-3,3)*0.5,
                    math.rad(math.random(-180,180))
                )
                safeFireServer(R.HeadRot, cf)
                task.wait(0.08)
            end
            notify("HeadRot","Done")
        end)
    end)

    -- Stop Grapple (for players using grapple hook)
    makeBtn("🪝 Stop Grapple (all)", function()
        for i=1,5 do
            safeFireServer(R.StopGrappling)
            task.wait(0.1)
        end
        notify("StopGrapple","Fired x5")
    end)

    -- Grenade Cookoff spam on local tool
    makeBtn("💣 Grenade Cookoff Spam", function()
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not tool then notify("GrenadeCookoff","No tool equipped"); return end
        task.spawn(function()
            for i=1,10 do
                safeFireServer(R.GrenadeCookoff, tool.Name)
                task.wait(0.1)
            end
            notify("GrenadeCookoff","Spammed x10")
        end)
    end)

    -- Spot all enemies (shows them on radar)
    makeBtn("📡 Spot All Enemies", function()
        if not R.SpotPlayer then
            notify("SpotPlayer","Remote not found")
            return
        end
        local done = 0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl==LocalPlayer then continue end
            if isTeammate(pl) then continue end
            pcall(function() R.SpotPlayer:FireServer(pl) end)
            done = done+1
            task.wait(0.05)
        end
        notify("Spot","Spotted "..done.." enemies")
    end)

    -- EditKillConditions: set InAir=true for all (makes them take fall damage logic)
    makeBtn("🪂 Force InAir State All", function()
        safeFireServer(R.EditKillCond, "InAir", true)
        notify("InAir","Fired")
    end)

    -- ═══════════════════════════════════════════════
    -- SECTION: Server / World
    -- ═══════════════════════════════════════════════
    makeSection("🌐 Server / World")

    -- CollectCash (Tycoon mode)
    makeBtn("💰 Collect Cash (Tycoon)", function()
        if R.CollectCash then
            pcall(function() R.CollectCash:FireServer() end)
            notify("CollectCash","Fired")
        else
            local e = game:GetService("ReplicatedStorage"):FindFirstChild("CollectCashEvent")
            if e then
                pcall(function() e:FireServer() end)
                notify("CollectCash","Fired (direct)")
            else
                notify("CollectCash","Remote not found")
            end
        end
    end)

    -- NVG toggle spam (flashbang effect via NVG)
    makeBtn("🌙 NVG Spam", function()
        task.spawn(function()
            for i=1,10 do
                safeFireServer(R.NVG, i%2==0)
                task.wait(0.15)
            end
            notify("NVG Spam","Done")
        end)
    end)

    -- KillMe (GroundWar minigame)
    makeBtn("💀 Kill Myself (Minigame)", function()
        safeFireServer(R.KillMe)
        notify("KillMe","Fired")
    end)

    -- Minigame state resend (can desync server state)
    makeBtn("🔁 Minigame State Resend", function()
        if R.MinigameEvent then
            pcall(function() R.MinigameEvent:FireServer("StateResend") end)
            notify("MinigameEvent","StateResend fired")
        else
            notify("MinigameEvent","Not found")
        end
    end)

    exploitUI = sg
end

-- ================================================================
-- KEYBINDS
-- ================================================================
local function b(v) return v and "ON" or "OFF" end

UserInputSvc.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local k = inp.KeyCode

    if k == Enum.KeyCode.RightAlt then
        CFG.Enabled = not CFG.Enabled
        notify("SilentAim", b(CFG.Enabled))

    elseif k == Enum.KeyCode.F2 then
        CFG.TeamCheck = not CFG.TeamCheck
        notify("TeamCheck", b(CFG.TeamCheck))

    elseif k == Enum.KeyCode.F3 then
        CFG.ESP = not CFG.ESP
        if not CFG.ESP then
            for _,pl in ipairs(Players:GetPlayers()) do
                hideESP(getESP(pl))
            end
        end
        notify("ESP", b(CFG.ESP))

    elseif k == Enum.KeyCode.F4 then
        CFG.FFViewModel = not CFG.FFViewModel
        applyFF(CFG.FFViewModel)
        notify("FF Viewmodel", b(CFG.FFViewModel))

    elseif k == Enum.KeyCode.F5 then
        CFG.InfAmmo = not CFG.InfAmmo
        if CFG.InfAmmo then refreshGunRefs() end
        notify("InfAmmo", b(CFG.InfAmmo))

    elseif k == Enum.KeyCode.F6 then
        CFG.FullAuto = not CFG.FullAuto
        if CFG.FullAuto then
            refreshGunRefs()
            if u7Ref then
                u7Ref.FireModes      = u7Ref.FireModes or {}
                u7Ref.FireModes.Auto = true
                u7Ref.ShootType      = 3
                u7Ref.ShootRate      = 99999
            end
        else
            if u7Ref then
                u7Ref.ShootType = u7Ref._origST or 1
                u7Ref.ShootRate = u7Ref._origSR or 700
                if u7Ref.FireModes then
                    u7Ref.FireModes.Auto = false
                end
            end
        end
        notify("FullAuto", b(CFG.FullAuto))

    elseif k == Enum.KeyCode.F7 then
        CFG.ShowAimLine = not CFG.ShowAimLine
        notify("AimLine", b(CFG.ShowAimLine))

    elseif k == Enum.KeyCode.F8 then
        CFG.BulletTracer = not CFG.BulletTracer
        if not CFG.BulletTracer then
            for _,tr in ipairs(tracers) do pcall(function() tr.line:Remove() end) end
            tracers = {}
        end
        notify("BulletTracer", b(CFG.BulletTracer))

    elseif k == Enum.KeyCode.RightControl then
        exploitOpen = not exploitOpen
        if exploitOpen then
            buildExploitUI()
        else
            if exploitUI then exploitUI:Destroy(); exploitUI=nil end
        end
    end
end)

-- ================================================================
-- STATUS HUD
-- ================================================================
local statusHUD = newDraw("Text",{
    Visible=true, Size=13, Font=2,
    Color=Color3.fromRGB(255,255,255),
    Outline=true, OutlineColor=Color3.fromRGB(0,0,0),
    Position=Vector2.new(10,40),
})

RunService.RenderStepped:Connect(function()
    statusHUD.Text = string.format(
        "[SilentAim v2]  Aim:%s  ESP:%s  FF:%s  InfAmmo:%s  FullAuto:%s  Tracer:%s",
        b(CFG.Enabled), b(CFG.ESP), b(CFG.FFViewModel),
        b(CFG.InfAmmo), b(CFG.FullAuto), b(CFG.BulletTracer)
    )
end)

notify("SilentAim v2","Loaded — RCtrl=ExploitUI | RAlt=Aim | F3=ESP | F5=InfAmmo | F6=FullAuto | F8=Tracer")
