-- Roblox: Workspace.SilverAce293026.HelicopterWeapons.Backup
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = game:getService("ContextActionService");
local l__UserInputService__1 = game:GetService("UserInputService");
local l__RunService__2 = game:GetService("RunService");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__Character__4 = l__LocalPlayer__3.Character;
local l__Humanoid__5 = l__Character__4:WaitForChild("Humanoid");
local l__ReplicatedStorage__6 = game:GetService("ReplicatedStorage");
local l__Modules__7 = l__ReplicatedStorage__6:WaitForChild("Modules");
local l__ShootModule__8 = require(l__Modules__7:WaitForChild("Projectile"):WaitForChild("ShootModule"));
local l__VehicleModule__9 = require(l__Modules__7:WaitForChild("VehicleModule"));
local l__Reload__10 = script:WaitForChild("Reload");
local l__ACS_Engine__11 = l__ReplicatedStorage__6:WaitForChild("ACS_Engine");
local l__Events__12 = l__ACS_Engine__11:WaitForChild("Events");
local l__Hitmarker__13 = require(l__ACS_Engine__11:WaitForChild("Modules"):WaitForChild("Hitmarker"));
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 8;
local u6 = true;
local u7 = false;
local u8 = false;
local function u10(p9) --[[ Line: 37 ]]
    -- upvalues: u3 (ref), u2 (ref), u4 (ref), l__Character__4 (copy)
    u3 = p9;
    u2 = p9.Required.HeliSeat;
    if p9.Params.RocketsEnabled.Value then
        local l__Weaponry__14 = p9.Weaponry;
        u4 = {
            leftRocket = l__Weaponry__14.Rockets.LeftRocket,
            rightRocket = l__Weaponry__14.Rockets.RightRocket,
            projectileData = {
                shellType = "Explosive",
                shellName = "HeliRocketShell",
                shellSpeed = 400,
                weaponName = p9.Name,
                filterDescendants = { p9, l__Character__4 }
            }
        };
    end;
end;
l__Humanoid__5.Seated:Connect(function() --[[ Name: onSeated, Line 65 ]]
    -- upvalues: l__Humanoid__5 (copy), l__VehicleModule__9 (copy), u10 (copy), u4 (ref), u7 (ref), u8 (ref), u5 (ref), u6 (ref), l__ShootModule__8 (copy), l__LocalPlayer__3 (copy), l__Events__12 (copy), l__Hitmarker__13 (copy), l__Reload__10 (copy), l__UserInputService__1 (copy), u1 (copy), l__RunService__2 (copy)
    if l__Humanoid__5.SeatPart then
        local v11 = l__VehicleModule__9.checkAndGetHeli(l__Humanoid__5.SeatPart);
        if v11 then
            u10(v11);
            if u4 then
                local function u14(_, p12, _) --[[ Line: 78 ]]
                    -- upvalues: u7 (ref), u8 (ref), u5 (ref), u6 (ref), u4 (ref), l__ShootModule__8 (ref), l__LocalPlayer__3 (ref), l__Events__12 (ref), l__Hitmarker__13 (ref), l__Reload__10 (ref)
                    if u7 or (u8 or (p12 ~= Enum.UserInputState.Begin or u5 < 1)) then
                    else
                        u7 = true;
                        u5 = u5 - 1;
                        local v13 = u6 and u4.rightRocket or u4.leftRocket;
                        l__ShootModule__8.fire(l__LocalPlayer__3, v13.Position, -v13.CFrame.LookVector, u4.projectileData);
                        l__Events__12.ServerBullet:FireServer(v13.Position, -v13.CFrame.LookVector, u4.projectileData);
                        l__Hitmarker__13.heliRocketShot(l__LocalPlayer__3, u6);
                        l__Events__12.HeliRocketFireFX:FireServer(u6);
                        u6 = not u6;
                        delay(0, function() --[[ Line: 92 ]]
                            -- upvalues: u7 (ref)
                            task.wait(0.2);
                            u7 = false;
                        end);
                        if u5 < 1 then
                            u8 = true;
                            delay(0, function() --[[ Line: 99 ]]
                                -- upvalues: l__Reload__10 (ref), u5 (ref), u8 (ref)
                                task.wait(7 - l__Reload__10.TimeLength);
                                l__Reload__10:Play();
                                task.wait(l__Reload__10.TimeLength);
                                u5 = 8;
                                u8 = false;
                            end);
                        end;
                    end;
                end;
                local function v18(p15, p16, p17) --[[ Line: 109 ]]
                    -- upvalues: l__UserInputService__1 (ref), u14 (copy)
                    if l__UserInputService__1:GetLastInputType() == Enum.UserInputType.Gamepad1 then
                    else
                        u14(p15, p16, p17);
                    end;
                end;
                if u4 then
                    u1:BindAction("FireHeliRocket", u14, true, Enum.KeyCode.ButtonR1);
                    u1:BindAction("FireHeliRocketPC", v18, false, Enum.UserInputType.MouseButton1);
                    u1:SetPosition("FireHeliRocket", UDim2.new(0.81, -135, 0.05, -35));
                    u1:SetImage("FireHeliRocket", "https://www.roblox.com/asset/?id=444744114");
                end;
                local u19 = nil;
                u19 = l__RunService__2.RenderStepped:Connect(function() --[[ Line: 123 ]]
                    -- upvalues: l__Humanoid__5 (ref), u1 (ref), u19 (ref)
                    if l__Humanoid__5.SeatPart and l__Humanoid__5.SeatPart.Name == "HeliSeat" then
                    else
                        u1:UnbindAction("FireHeliRocket");
                        u19:Disconnect();
                    end;
                end);
            end;
        end;
    end;
end);