-- Roblox: Workspace.SilverAce293026.Helicopter
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = game:getService("ContextActionService");
local l__UserInputService__1 = game:GetService("UserInputService");
local l__RunService__2 = game:GetService("RunService");
game:GetService("StarterPlayer");
local l__Players__3 = game:GetService("Players");
local l__LocalPlayer__4 = l__Players__3.LocalPlayer;
local l__TweenService__5 = game:GetService("TweenService");
local l__Character__6 = l__LocalPlayer__4.Character;
local l__Humanoid__7 = l__Character__6:WaitForChild("Humanoid");
local l__Modules__8 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
require(l__Modules__8:WaitForChild("FlaresSettings"));
local l__VFXModule__9 = require(l__Modules__8:WaitForChild("VFXModule"));
local l__FlareReplicationEvent__10 = game:GetService("ReplicatedStorage"):WaitForChild("FlareReplicationEvent");
local u2 = script:FindFirstChild("Aimpart") or Instance.new("Part");
u2.Name = "Aimpart";
u2.Transparency = 0;
u2.CanCollide = false;
u2.Anchored = true;
script:WaitForChild("Aim"):Clone().Parent = u2;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = nil;
l__LocalPlayer__4:GetMouse();
local u12 = nil;
local u13 = nil;
local l__CurrentCamera__11 = workspace.CurrentCamera;
local u14 = false;
local u15 = nil;
local u16 = nil;
local u17 = false;
local u18 = nil;
local u19 = 0;
local u20 = 0;
local u21 = 0;
local u22 = nil;
local u23 = nil;
local l__ControlModule__12 = require(l__LocalPlayer__4:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"));
local u24 = RaycastParams.new();
u24.FilterType = Enum.RaycastFilterType.Exclude;
u24.CollisionGroup = "CamCast";
local l__ContextTutorialGui__13 = l__LocalPlayer__4.PlayerGui:WaitForChild("ContextTutorialGui");
local l__ContextualTutorialPresets__14 = require(l__ContextTutorialGui__13:WaitForChild("ContextualTutorialPresets"));
local function v26(p25) --[[ Line: 96 ]]
    -- upvalues: u3 (ref), l__Character__6 (copy), u2 (copy)
    if not u3 then
        if l__Character__6:FindFirstChild("Aimpart") then
            u3 = l__Character__6.Aimpart;
        else
            if not p25 then
                return nil;
            end;
            u3 = u2:Clone();
        end;
    end;
    u3.Parent = l__Character__6;
    u3.Aim.Enabled = true;
    return u3;
end;
script:WaitForChild("GetAimPart").OnInvoke = v26;
local u27 = {
    Locking = 0,
    IncomingProjectile = 0
};
local l__LockonGui__15 = l__Players__3.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("LockonGui");
local function u31(p28, p29) --[[ Line: 120 ]]
    -- upvalues: u31 (copy), l__LockonGui__15 (copy)
    local v30 = p28 == "Locking" and script.Locking or script.IncomingProjectile;
    if script.IncomingProjectile.Playing and p28 == "Locking" then
    else
        if p28 == "IncomingProjectile" and p29 == true then
            u31("Locking", false);
        end;
        l__LockonGui__15[p28].Visible = p29;
        if p29 then
            if v30.Playing then
            else
                v30:Play();
            end;
        else
            v30:Stop();
        end;
    end;
end;
l__RunService__2:BindToRenderStep("HeliRocketAlerts", Enum.RenderPriority.Camera.Value + 1, function(_) --[[ Line: 144 ]]
    -- upvalues: u27 (copy), l__LockonGui__15 (copy)
    for v32, v33 in u27 do
        if os.time() - v33 >= 3 then
            local v34 = v32 == "Locking" and script.Locking or script.IncomingProjectile;
            if not script.IncomingProjectile.Playing or v32 ~= "Locking" then
                local _ = v32 == "IncomingProjectile";
                l__LockonGui__15[v32].Visible = false;
                v34:Stop();
            end;
        end;
    end;
end);
local function u41(p35) --[[ Line: 152 ]]
    -- upvalues: u5 (ref), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u27 (copy), u31 (copy), l__LockonGui__15 (copy), u10 (ref), u18 (ref), u12 (ref), u13 (ref), u17 (ref), u9 (ref)
    u5 = p35;
    u4 = p35.HeliSeat;
    u6 = u5.Engine;
    u7 = u5.ROTOR.HingeConstraint;
    u8 = u5.ROTOR2.HingeConstraint;
    local v38 = u5.Parent.Networking.RocketEvent.OnClientEvent:Connect(function(p36) --[[ Line: 161 ]]
        -- upvalues: u27 (ref), u31 (ref), l__LockonGui__15 (ref)
        u27[p36] = os.time();
        local v37 = p36 == "Locking" and script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing and p36 == "Locking" then
        else
            if p36 == "IncomingProjectile" then
                u31("Locking", false);
            end;
            l__LockonGui__15[p36].Visible = true;
            if v37.Playing then
            else
                v37:Play();
            end;
        end;
    end);
    table.insert(u10, v38);
    local v40 = u5.Parent:GetAttributeChangedSignal("Flares"):Connect(function() --[[ Line: 167 ]]
        -- upvalues: u5 (ref), l__LockonGui__15 (ref)
        if u5.Parent:GetAttribute("Flares") then
            local l__IncomingProjectile__16 = script.IncomingProjectile;
            local _ = script.IncomingProjectile.Playing;
            l__LockonGui__15.IncomingProjectile.Visible = false;
            l__IncomingProjectile__16:Stop();
            local v39 = script.Locking or script.IncomingProjectile;
            if script.IncomingProjectile.Playing then
                return;
            end;
            l__LockonGui__15.Locking.Visible = false;
            v39:Stop();
        end;
    end);
    table.insert(u10, v40);
    u18 = u5.Parent.Params.UpForceLimit.Value;
    u12 = u5.OrientationPart;
    u13 = u5.Followpart;
    u17 = false;
    u9 = u5.Parent.Params.RocketsEnabled.Value;
end;
local function u44() --[[ Line: 185 ]]
    -- upvalues: u4 (ref), u6 (ref), u5 (ref), u7 (ref), u8 (ref), u10 (ref), l__LockonGui__15 (copy), u18 (ref), u12 (ref), u13 (ref), u17 (ref), u22 (ref), u23 (ref), u20 (ref), u21 (ref), u19 (ref), u3 (ref)
    if u4 and u4.Occupant then
        u6.AlignOrientation.Enabled = false;
    end;
    u5 = nil;
    u4 = nil;
    u6 = nil;
    u7 = nil;
    u8 = nil;
    for _, v42 in u10 do
        v42:Disconnect();
    end;
    u10 = {};
    local v43 = script.Locking or script.IncomingProjectile;
    if not script.IncomingProjectile.Playing then
        l__LockonGui__15.Locking.Visible = false;
        v43:Stop();
    end;
    local l__IncomingProjectile__17 = script.IncomingProjectile;
    local _ = script.IncomingProjectile.Playing;
    l__LockonGui__15.IncomingProjectile.Visible = false;
    l__IncomingProjectile__17:Stop();
    u18 = nil;
    u12 = nil;
    u13 = nil;
    u17 = false;
    u22 = nil;
    u23 = nil;
    u20 = 0;
    u21 = 0;
    u19 = 0;
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;
end;
local function u48() --[[ Line: 222 ]]
    -- upvalues: u13 (ref), u3 (ref), l__Character__6 (copy), u2 (copy)
    local l__Position__18 = u13.Position;
    local v45 = -u13.CFrame.LookVector * 2000;
    RaycastParams.new();
    local v46 = Ray.new(l__Position__18, v45);
    local _, v47, _ = workspace:FindPartOnRayWithWhitelist(v46, { u13 });
    if v47 then
        if not u3 then
            if l__Character__6:FindFirstChild("Aimpart") then
                u3 = l__Character__6.Aimpart;
            else
                u3 = u2:Clone();
            end;
        end;
        u3.Parent = l__Character__6;
        u3.Aim.Enabled = true;
        u3.Position = v47;
    else
        if not u3 then
            if l__Character__6:FindFirstChild("Aimpart") then
                u3 = l__Character__6.Aimpart;
            else
                u3 = u2:Clone();
            end;
        end;
        u3.Parent = l__Character__6;
        u3.Aim.Enabled = true;
        u3.CFrame = u13.CFrame * CFrame.new(0, 0, 10000);
    end;
end;
local function u54(p49, p50, p51) --[[ Line: 252 ]]
    -- upvalues: u7 (ref), u8 (ref)
    local v52 = p50 or u7;
    local v53 = p51 or u8;
    local l__AngularVelocity__19 = v52.AngularVelocity;
    local _ = v53.AngularVelocity;
    if p49 * 20 < l__AngularVelocity__19 then
        v52.AngularVelocity = math.max(p49 * 20, v52.AngularVelocity - 0.1);
        v53.AngularVelocity = math.min(-p49 * 40, v53.AngularVelocity + 0.1);
    else
        v52.AngularVelocity = math.min(p49 * 20, v52.AngularVelocity + 0.1);
        v53.AngularVelocity = math.max(-p49 * 40, v53.AngularVelocity - 0.1);
    end;
end;
local function u56() --[[ Line: 276 ]]
    -- upvalues: u24 (copy), u5 (ref), l__Character__6 (copy)
    u24.FilterDescendantsInstances = { u5.Parent, l__Character__6 };
    local l__CurrentCamera__20 = workspace.CurrentCamera;
    local v55 = workspace:Raycast(l__CurrentCamera__20.CFrame.Position, l__CurrentCamera__20.CFrame.LookVector * 1000, u24);
    if v55 then
        return v55.Position;
    else
        return l__CurrentCamera__20.CFrame.Position + l__CurrentCamera__20.CFrame.LookVector * 10000;
    end;
end;
local function u67(p57, p58, p59) --[[ Line: 303 ]]
    -- upvalues: u19 (ref)
    local l__AssemblyLinearVelocity__21 = p57.AssemblyLinearVelocity;
    local v60 = u19 <= 5000 and -100 or -70;
    local l__X__22 = l__AssemblyLinearVelocity__21.X;
    local l__Z__23 = l__AssemblyLinearVelocity__21.Z;
    local v61 = math.pow(l__X__22, 2) + math.pow(l__Z__23, 2);
    local v62 = math.sqrt(v61);
    local v63 = p58 >= v62 and 1 or p58 / v62;
    local v64 = l__AssemblyLinearVelocity__21.X * v63;
    local l__Y__24 = l__AssemblyLinearVelocity__21.Y;
    if l__AssemblyLinearVelocity__21.Y <= 0 and u19 > 5000 then
        l__Y__24 = l__Y__24 * 0.9;
    end;
    local v65 = math.min(l__Y__24, p59);
    local v66 = math.max(v65, v60);
    p57.Velocity = Vector3.new(v64, v66, l__AssemblyLinearVelocity__21.Z * v63);
end;
local function u77() --[[ Line: 321 ]]
    -- upvalues: l__CurrentCamera__11 (copy), u5 (ref), l__UserInputService__1 (copy), u6 (ref), u22 (ref), u23 (ref), u48 (copy), l__ControlModule__12 (copy), u20 (ref), u21 (ref), u18 (ref), u15 (ref), u16 (ref), u19 (ref), u54 (copy), u17 (ref), u56 (copy), u12 (ref), u67 (copy)
    l__CurrentCamera__11.CameraType = Enum.CameraType.Custom;
    l__CurrentCamera__11.CameraSubject = u5.CameraPart;
    l__UserInputService__1.MouseBehavior = Enum.MouseBehavior.LockCenter;
    l__UserInputService__1.MouseIconEnabled = false;
    local l__AssemblyLinearVelocity__25 = u6.AssemblyLinearVelocity;
    local l__X__26 = l__AssemblyLinearVelocity__25.X;
    local l__Z__27 = l__AssemblyLinearVelocity__25.Z;
    local v68 = math.pow(l__X__26, 2) + math.pow(l__Z__27, 2);
    local v69 = math.sqrt(v68);
    if u22 and u23 then
        local _ = u5.Parent.Networking.CrashEvent;
        if v69 - u22 <= -40 then
            print("Horizontal crash");
        elseif math.abs(l__AssemblyLinearVelocity__25.Y) - u23 <= -40 then
            print("Vertical crash");
        end;
    end;
    u22 = v69;
    u23 = math.abs(l__AssemblyLinearVelocity__25.Y);
    u48();
    local v70 = l__ControlModule__12:GetMoveVector();
    u20 = v70.X * -30;
    u21 = v70.Z * 30;
    local v71 = u18 / 200;
    local v72 = nil;
    local v73 = nil;
    if u15 and u16 or not (u15 or u16) then
        v72 = 0.5;
        v73 = 0;
        u19 = math.max(0, u19 - v71);
    elseif u15 then
        u19 = math.min(u18, u19 + v71);
        v72 = 1;
        v73 = 1;
    elseif u16 then
        u19 = math.max(-u18, u19 - v71);
        v72 = 0.3;
        v73 = -1;
    end;
    u54(u17 and v72 and v72 or 1 / u18 * u19);
    if u19 >= u18 / 2 then
        u17 = true;
        u6.AlignOrientation.Enabled = true;
        u6.LinearVelocity.MaxForce = 200000;
    end;
    if u17 then
        l__ControlModule__12:GetMoveVector();
        local v74 = CFrame.new(u6.Position, (u56()));
        local _, v75, _ = v74:ToEulerAnglesYXZ();
        local v76 = CFrame.Angles(0, v75, 0) * CFrame.Angles(math.rad(u21), 0, 0) * CFrame.Angles(0, 0, (math.rad(u20)));
        u12.CFrame = CFrame.new(v74.Position) * v76;
        u6.BlizzardVelocity.Force = Vector3.new(0, u18, 0);
    end;
    local l__Value__28 = u5.Parent.Params.HorizontalSpeedLimit.Value;
    local l__Value__29 = u5.Parent.Params.VerticalSpeedLimit.Value;
    u67(u6, l__Value__28, l__Value__29);
    u6.LinearVelocity.LineVelocity = v73 * l__Value__29 / 2;
end;
l__Humanoid__7.Seated:Connect(function() --[[ Name: onSeated, Line 406 ]]
    -- upvalues: l__Humanoid__7 (copy), u41 (copy), u5 (ref), l__ContextualTutorialPresets__14 (copy), u15 (ref), u16 (ref), u14 (ref), l__TweenService__5 (copy), l__CurrentCamera__11 (copy), l__UserInputService__1 (copy), u1 (copy), l__RunService__2 (copy), l__Character__6 (copy), u44 (copy), u11 (ref), u67 (copy), u7 (ref), u8 (ref), u77 (copy)
    if l__Humanoid__7.SeatPart then
        local l__SeatPart__30 = l__Humanoid__7.SeatPart;
        local v78 = l__SeatPart__30.Name == "HeliSeat";
        local l__Parent__31 = l__SeatPart__30.Parent;
        local u79 = v78 and l__Parent__31 and l__Parent__31 or nil;
        if u79 then
            u41(u79);
            if u5 and (u5.Parent and (u5.Parent.Name == "AH-1Z Viper" or u5.Parent.Name == "RAH-66 Comanche")) then
                l__ContextualTutorialPresets__14.startArmedHeliTutorial();
            else
                l__ContextualTutorialPresets__14.startUnarmedHeliTutorial();
            end;
            local function v81(_, p80, _) --[[ Line: 417 ]]
                -- upvalues: u15 (ref)
                if p80 == Enum.UserInputState.Begin then
                    u15 = true;
                else
                    if p80 == Enum.UserInputState.End then
                        u15 = false;
                    end;
                end;
            end;
            local function v83(_, p82, _) --[[ Line: 425 ]]
                -- upvalues: u16 (ref)
                if p82 == Enum.UserInputState.Begin then
                    u16 = true;
                else
                    if p82 == Enum.UserInputState.End then
                        u16 = false;
                    end;
                end;
            end;
            local function v86(_, p84, _) --[[ Line: 433 ]]
                -- upvalues: u14 (ref), l__TweenService__5 (ref), l__CurrentCamera__11 (ref)
                if p84 == Enum.UserInputState.Begin then
                    local v85 = u14 and 70 or 50;
                    u14 = not u14;
                    l__TweenService__5:Create(l__CurrentCamera__11, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        FieldOfView = v85
                    }):Play();
                end;
            end;
            l__CurrentCamera__11.CameraType = Enum.CameraType.Custom;
            l__CurrentCamera__11.CameraSubject = u5.CameraPart;
            l__UserInputService__1.MouseBehavior = Enum.MouseBehavior.LockCenter;
            l__UserInputService__1.MouseIconEnabled = false;
            u1:BindAction("HeliZoom", v86, false, Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL1);
            u1:BindAction("HeliAscend", v81, true, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonR2);
            u1:BindAction("HeliDescend", v83, true, Enum.KeyCode.LeftControl, Enum.KeyCode.C, Enum.KeyCode.ButtonL2);
            u1:BindAction("HeliFlares", function(_, p87, _) --[[ Name: deployFlares, Line 442 ]]
                -- upvalues: u79 (copy)
                if p87 == Enum.UserInputState.Begin then
                    u79.Parent.Networking.FlareEvent:FireServer();
                end;
            end, false, Enum.KeyCode.F, Enum.KeyCode.DPadDown);
            u1:SetPosition("HeliAscend", UDim2.new(0.5, 0, 0.15, 0));
            u1:SetImage("HeliAscend", "https://www.roblox.com/asset/?id=6183930112");
            u1:SetPosition("HeliDescend", UDim2.new(0.75, 0, 0.15, 0));
            u1:SetImage("HeliDescend", "https://www.roblox.com/asset/?id=3154643144");
            u1:SetPosition("HeliFlares", UDim2.new(0.5, 0, -0.55, 0));
            u1:SetImage("HeliFlares", "https://www.roblox.com/asset/?id=15049808173");
            local u88 = nil;
            u88 = l__RunService__2.RenderStepped:Connect(function() --[[ Line: 471 ]]
                -- upvalues: l__Humanoid__7 (ref), u1 (ref), u88 (ref), l__CurrentCamera__11 (ref), l__Character__6 (ref), l__UserInputService__1 (ref), u5 (ref), u44 (ref), u11 (ref), u67 (ref), u7 (ref), u8 (ref), u77 (ref)
                if l__Humanoid__7.SeatPart and l__Humanoid__7.SeatPart.Name == "HeliSeat" then
                    local _, v89 = pcall(u77);
                    if v89 then
                        print(v89);
                    end;
                else
                    u1:UnbindAction("HeliAscend");
                    u1:UnbindAction("HeliDescend");
                    u1:UnbindAction("HeliZoom");
                    u1:UnbindAction("HeliFlares");
                    u88:Disconnect();
                    spawn(function() --[[ Line: 481 ]]
                        -- upvalues: l__CurrentCamera__11 (ref), l__Character__6 (ref), l__UserInputService__1 (ref)
                        l__CurrentCamera__11.CameraSubject = l__Character__6.Humanoid;
                        l__UserInputService__1.MouseBehavior = Enum.MouseBehavior.Default;
                        l__UserInputService__1.MouseIconEnabled = true;
                    end);
                    if u5:FindFirstChild("ROTOR") then
                        u11 = {
                            Rotor1 = u5.ROTOR.HingeConstraint,
                            Rotor2 = u5.ROTOR2.HingeConstraint,
                            Seat = u5.HeliSeat,
                            Engine = u5.Engine,
                            HorizontalSpeedLimit = u5.Parent.Params.HorizontalSpeedLimit.Value,
                            VerticalSpeedLimit = u5.Parent.Params.VerticalSpeedLimit.Value
                        };
                        u44();
                        spawn(function() --[[ Line: 504 ]]
                            -- upvalues: u11 (ref), u67 (ref), u7 (ref), u8 (ref)
                            while u11 and (u11.Rotor1 and (u11.Rotor2 and (u11.Engine and (u11.Rotor1.AngularVelocity >= 0 and u11.Seat.Occupant == nil)))) do
                                if u11.HorizontalSpeedLimit and u11.VerticalSpeedLimit then
                                    u67(u11.Engine, u11.HorizontalSpeedLimit, u11.VerticalSpeedLimit);
                                end;
                                local v90 = u11.Rotor1 or u7;
                                local v91 = u11.Rotor2 or u8;
                                local l__AngularVelocity__32 = v90.AngularVelocity;
                                local _ = v91.AngularVelocity;
                                if l__AngularVelocity__32 > 0 then
                                    v90.AngularVelocity = math.max(0, v90.AngularVelocity - 0.1);
                                    v91.AngularVelocity = math.min(-0, v91.AngularVelocity + 0.1);
                                else
                                    v90.AngularVelocity = math.min(0, v90.AngularVelocity + 0.1);
                                    v91.AngularVelocity = math.max(-0, v91.AngularVelocity - 0.1);
                                end;
                                if u11.Rotor1.AngularVelocity <= 4 then
                                    u11.Engine.AlignOrientation.Enabled = false;
                                    u11.Engine.LinearVelocity.MaxForce = 0;
                                    u11.Engine.LinearVelocity.LineVelocity = 0;
                                    u11.Engine.BlizzardVelocity.Force = Vector3.new(0, 0, 0);
                                    break;
                                end;
                                task.wait();
                            end;
                            u11 = nil;
                        end);
                    else
                        u44();
                    end;
                end;
            end);
        end;
    end;
end);
l__FlareReplicationEvent__10.OnClientEvent:Connect(function(p92) --[[ Line: 534 ]]
    -- upvalues: l__VFXModule__9 (copy)
    l__VFXModule__9.flareFX(p92);
end);