-- Roblox: Players.SilverAce293026.PlayerScripts.ACS_EventHandler
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
game:GetService("UserInputService");
game:GetService("ContextActionService");
game:GetService("RunService");
local l__TweenService__2 = game:GetService("TweenService");
game:GetService("Debris");
game:GetService("PhysicsService");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__Modules__4 = l__ReplicatedStorage__3:WaitForChild("Modules");
local l__ACS_Engine__5 = l__ReplicatedStorage__3:WaitForChild("ACS_Engine");
local l__Events__6 = l__ACS_Engine__5:WaitForChild("Events");
local l__Modules__7 = l__ACS_Engine__5:WaitForChild("Modules");
l__ACS_Engine__5:WaitForChild("HUD");
l__ACS_Engine__5:WaitForChild("ArmModel");
l__ACS_Engine__5:WaitForChild("GunModels");
local l__GameRules__8 = l__ACS_Engine__5:WaitForChild("GameRules");
l__ACS_Engine__5:WaitForChild("FX");
require(l__GameRules__8:WaitForChild("Config"));
require(l__Modules__7:WaitForChild("Spring"));
local l__Hitmarker__9 = require(l__Modules__7:WaitForChild("Hitmarker"));
require(l__Modules__7:WaitForChild("Utilities"));
local l__ACS_WorkSpace__10 = workspace:WaitForChild("ACS_WorkSpace");
local l__LocalPlayer__11 = l__Players__1.LocalPlayer;
l__LocalPlayer__11:GetMouse();
local _ = workspace.CurrentCamera;
local l__ShootModule__12 = require(l__Modules__4:WaitForChild("Projectile"):WaitForChild("ShootModule"));
require(l__Modules__4:WaitForChild("VehicleModule"));
local l__CosmeticShellsFolder__13 = workspace:WaitForChild("CosmeticShellsFolder");
l__Events__6.TurretAngleChanged.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 44 ]]
    -- upvalues: l__LocalPlayer__11 (copy)
    if p1 == l__LocalPlayer__11 or not (p2 and (p3 and (p4 and (p2.Occupant and (p2:FindFirstChild("XMotor") and p2:FindFirstChild("YMotor")))))) then
    else
        p2.YMotor.C0 = CFrame.new() * CFrame.Angles(-p4, 0, 0);
        p2.XMotor.C0 = CFrame.new() * CFrame.Angles(0, p3, 0);
    end;
end);
l__Events__6.StopGrappling.OnClientEvent:Connect(function(p5) --[[ Line: 50 ]]
    -- upvalues: l__CosmeticShellsFolder__13 (copy)
    local v6 = l__CosmeticShellsFolder__13:GetChildren();
    for _, v7 in ipairs(v6) do
        if v7.Name == "GrappleShell" and v7.Creator.Value == p5.UserId then
            if v7:FindFirstChild("RopeConstraint") then
                v7.RopeConstraint:Destroy();
                v7.Transparency = 1;
            end;
            if p5.Character and (p5.Character:FindFirstChild("HumanoidRootPart") and p5.Character.HumanoidRootPart:FindFirstChild("GrappleForce")) then
                p5.Character.HumanoidRootPart.GrappleForce:Destroy();
            end;
        end;
    end;
end);
l__Events__6.HitEffect.OnClientEvent:Connect(function(p8, p9, p10, p11, p12, p13) --[[ Line: 65 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__Hitmarker__9 (copy)
    if p8 ~= l__LocalPlayer__11 then
        l__Hitmarker__9.HitEffect(p9, p10, p11, p12, p13);
    end;
end);
l__Events__6.TankFireFX.OnClientEvent:Connect(function(p14, p15) --[[ Line: 71 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__Hitmarker__9 (copy)
    if p14 == l__LocalPlayer__11 then
    else
        l__Hitmarker__9.tankShot(p14, p15);
    end;
end);
l__Events__6.HeliRocketFireFX.OnClientEvent:Connect(function(p16, p17, p18) --[[ Line: 76 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__Hitmarker__9 (copy)
    if p16 == l__LocalPlayer__11 then
    else
        l__Hitmarker__9.heliRocketShot(p16, p17, p18);
    end;
end);
l__Events__6.MLGHitmarker.OnClientEvent:Connect(function(p19, p20, p21, p22) --[[ Line: 81 ]]
    -- upvalues: l__Hitmarker__9 (copy)
    l__Hitmarker__9.playMLGHitmarker(p19, p20, p21, p22);
end);
l__Events__6.ExplosionFX.OnClientEvent:Connect(function(_, p23, p24, _, p25) --[[ Line: 85 ]]
    -- upvalues: l__Hitmarker__9 (copy)
    l__Hitmarker__9.Explosion(p23, p24, p25);
end);
l__Events__6.Atirar.OnClientEvent:Connect(function(p26, p27, p28, p29, p30) --[[ Line: 91 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__TweenService__2 (copy)
    if p26.UserId == l__LocalPlayer__11.UserId or not p27 then
    else
        if p26.Character:FindFirstChild("S" .. p27.Name) and (p26.Character["S" .. p27.Name]:FindFirstChild("Handle") and p26.Character["S" .. p27.Name].Handle:FindFirstChild("Muzzle")) then
            local v31 = p30 and p30.gun.End.Muzzle or p26.Character:FindFirstChild("S" .. p27.Name).Handle.Muzzle;
            if p28 then
                local l__Supressor__14 = v31.Supressor;
                local l__Parent__15 = l__Supressor__14.Parent;
                l__Supressor__14.PlayOnRemove = true;
                l__Supressor__14.PlaybackSpeed = 0.95 + math.random() * 0.1;
                l__Supressor__14.Parent = nil;
                l__Supressor__14.Parent = l__Parent__15;
                l__Supressor__14.PlayOnRemove = false;
            else
                local l__Fire__16 = v31.Fire;
                local l__Parent__17 = l__Fire__16.Parent;
                l__Fire__16.PlayOnRemove = true;
                l__Fire__16.PlaybackSpeed = 0.95 + math.random() * 0.1;
                l__Fire__16.Parent = nil;
                l__Fire__16.Parent = l__Parent__17;
                l__Fire__16.PlayOnRemove = false;
            end;
            if p29 and v31:FindFirstChild("RealisticSmoke") then
                local l__RealisticSmoke__18 = v31.RealisticSmoke;
                local u32 = l__RealisticSmoke__18:GetAttribute("EmitCount");
                local v33 = l__RealisticSmoke__18:GetAttribute("EmitDelay");
                delay(v33, function(_) --[[ Line: 117 ]]
                    -- upvalues: l__RealisticSmoke__18 (copy), u32 (copy)
                    l__RealisticSmoke__18:Emit(u32);
                end);
            elseif not p28 then
                for _, u34 in ipairs({ v31:FindFirstChild("Flare"), v31:FindFirstChild("Muzzle"), v31:FindFirstChild("RealisticSmoke") }) do
                    if u34 then
                        local u35 = u34:GetAttribute("EmitCount");
                        local v36 = u34:GetAttribute("EmitDelay");
                        delay(v36, function(_) --[[ Line: 127 ]]
                            -- upvalues: u34 (copy), u35 (copy)
                            u34:Emit(u35);
                        end);
                    end;
                end;
            end;
        end;
        if p26.Character:FindFirstChild("AnimBase") ~= nil and p26.Character.AnimBase:FindFirstChild("AnimBaseW") then
            local l__AnimBaseW__19 = p26.Character:WaitForChild("AnimBase"):WaitForChild("AnimBaseW");
            l__TweenService__2:Create(l__AnimBaseW__19, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {
                C1 = CFrame.new(0, 0, 0.15):Inverse()
            }):Play();
            delay(0.1, function() --[[ Line: 137 ]]
                -- upvalues: l__TweenService__2 (ref), l__AnimBaseW__19 (copy)
                l__TweenService__2:Create(l__AnimBaseW__19, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {
                    C1 = CFrame.new():Inverse()
                }):Play();
            end);
        end;
    end;
end);
l__Events__6.SVLaser.OnClientEvent:Connect(function(p37, p38, p39, p40, p41, p42) --[[ Line: 143 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__ACS_WorkSpace__10 (copy)
    if p37 ~= l__LocalPlayer__11 and (p37.Character and p42) then
        if l__ACS_WorkSpace__10.Server:FindFirstChild(p37.Name .. "_Laser") == nil then
            local v43 = Instance.new("Part", l__ACS_WorkSpace__10.Server);
            local v44 = Instance.new("Attachment", v43);
            v44.Name = "Att0";
            v43.Name = p37.Name .. "_Laser";
            v43.Transparency = 1;
            if p37.Character:FindFirstChild("S" .. p42.Name) and p37.Character:FindFirstChild("S" .. p42.Name).Handle:FindFirstChild("Muzzle") then
                local l__Muzzle__20 = p37.Character:FindFirstChild("S" .. p42.Name).Handle.Muzzle;
                local v45 = Instance.new("Beam", v43);
                v45.Transparency = NumberSequence.new(0);
                v45.LightEmission = 1;
                v45.LightInfluence = 0;
                v45.Attachment0 = v44;
                v45.Attachment1 = l__Muzzle__20;
                v45.Color = ColorSequence.new(p40);
                v45.FaceCamera = true;
                v45.Width0 = 0.01;
                v45.Width1 = 0.01;
                v45.Enabled = false;
            end;
        end;
        if p39 == 1 then
            if l__ACS_WorkSpace__10.Server:FindFirstChild(p37.Name .. "_Laser") then
                local v46 = l__ACS_WorkSpace__10.Server:FindFirstChild(p37.Name .. "_Laser");
                v46.Shape = "Ball";
                v46.Size = Vector3.new(0.2, 0.2, 0.2);
                v46.CanCollide = false;
                v46.Anchored = true;
                v46.Color = p40;
                v46.Material = Enum.Material.Neon;
                v46.Position = p38;
                if p41 then
                    v46.Transparency = 1;
                else
                    v46.Transparency = 0;
                end;
                if v46:FindFirstChild("Beam") then
                    v46.Beam.Enabled = false;
                end;
            end;
        elseif p39 == 2 and l__ACS_WorkSpace__10.Server:FindFirstChild(p37.Name .. "_Laser") then
            l__ACS_WorkSpace__10.Server:FindFirstChild(p37.Name .. "_Laser"):Destroy();
        end;
    end;
end);
l__Events__6.SVFlash.OnClientEvent:Connect(function(p47, p48, p49) --[[ Line: 210 ]]
    -- upvalues: l__LocalPlayer__11 (copy)
    local v50 = p47 ~= l__LocalPlayer__11 and (p47.Character and (p48 and p47.Character:FindFirstChild("S" .. p48.Name)));
    if v50 then
        for _, v51 in pairs(v50:GetDescendants()) do
            if v51:IsA("BasePart") and v51.Name == "FlashPoint" then
                v51.Light.Enabled = p49;
            end;
        end;
    end;
end);
l__Events__6.GunStance.OnClientEvent:Connect(function(p52, p53, p54) --[[ Line: 269 ]]
    -- upvalues: l__TweenService__2 (copy)
    if p52.Character.Humanoid.Health <= 0 or not (p54 and (p52.Character:FindFirstChild("AnimBase") and (p52.Character.AnimBase:FindFirstChild("RAW") and (p52.Character.AnimBase:FindFirstChild("LAW") and (p52.Character.AnimBase:FindFirstChild("RLAW") and (p52.Character.AnimBase:FindFirstChild("LLAW") and (p52.Character.AnimBase:FindFirstChild("RHW") and p52.Character.AnimBase:FindFirstChild("LHW")))))))) then
    else
        local l__Character__21 = p52.Character;
        local l__AnimBase__22 = p52.Character.AnimBase;
        local v55 = {
            RightArm = l__AnimBase__22.RAW,
            LeftArm = l__AnimBase__22.LAW,
            RightElbow = l__AnimBase__22.RLAW,
            LeftElbow = l__AnimBase__22.LLAW,
            RightWrist = l__AnimBase__22.RHW,
            LeftWrist = l__AnimBase__22.LHW
        };
        local v56 = CFrame.new(0, l__Character__21.RightUpperArm.Size.Y / 2, 0);
        local v57 = CFrame.new(0, l__Character__21.RightLowerArm.Size.Y / 1.9, 0);
        local v58 = CFrame.new(0, l__Character__21.LeftUpperArm.Size.Y / 2, 0);
        local v59 = CFrame.new(0, l__Character__21.LeftLowerArm.Size.Y / 1.9, 0);
        local v60 = TweenInfo.new(0.25, Enum.EasingStyle.Sine);
        local v61 = ({
            [0] = "Pos",
            [1] = "HighReady",
            [2] = "Aim",
            [3] = "Sprint",
            [-1] = "LowReady",
            [-2] = "Patrol"
        })[p53];
        if v61 then
            local v62 = p53 == 0 and "SV_" or "";
            local v63;
            if p53 == 0 then
                v63 = "Arm" .. v61 or v61;
            else
                v63 = v61;
            end;
            l__TweenService__2:Create(v55.RightArm, v60, {
                C0 = p54[v62 .. "Right" .. v63]
            }):Play();
            l__TweenService__2:Create(v55.LeftArm, v60, {
                C0 = p54[v62 .. "Left" .. v63]
            }):Play();
            l__TweenService__2:Create(v55.RightElbow, v60, {
                C0 = v56 * p54[v62 .. "RightElbow" .. v61]
            }):Play();
            l__TweenService__2:Create(v55.LeftElbow, v60, {
                C0 = v58 * p54[v62 .. "LeftElbow" .. v61]
            }):Play();
            l__TweenService__2:Create(v55.RightWrist, v60, {
                C0 = v57 * p54[v62 .. "RightWrist" .. v61]
            }):Play();
            l__TweenService__2:Create(v55.LeftWrist, v60, {
                C0 = v59 * p54[v62 .. "LeftWrist" .. v61]
            }):Play();
        end;
    end;
end);
l__Events__6.HeadRot.OnClientEvent:Connect(function(p64) --[[ Line: 326 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__Players__1 (copy), l__TweenService__2 (copy)
    for v65, v66 in pairs(p64) do
        if v65 ~= l__LocalPlayer__11.UserId then
            local v67 = l__Players__1:GetPlayerByUserId(v65);
            if v67 and (v67.Character and (v67.Character:FindFirstChild("Head") and v67.Character.Head:FindFirstChild("Neck"))) then
                l__TweenService__2:Create(v67.Character.Head.Neck, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                    C0 = v66
                }):Play();
            end;
        end;
    end;
end);
l__Events__6.ServerBullet.OnClientEvent:Connect(function(p68, p69, p70, p71, p72) --[[ Line: 339 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__ShootModule__12 (copy)
    if p68 == l__LocalPlayer__11 or not p68.Character then
    else
        local v73 = p68.Character:FindFirstChild("S" .. p71.weaponName);
        if v73 and (v73:FindFirstChild("Handle") and v73.Handle:FindFirstChild("Muzzle")) then
            p69 = v73.Handle.Muzzle.WorldPosition;
        end;
        l__ShootModule__12.fire(p68, p69, p70, p71, p72);
    end;
end);