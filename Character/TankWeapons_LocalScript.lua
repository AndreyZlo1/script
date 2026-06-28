-- Roblox: Workspace.SilverAce293026.TankWeapons
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ContextActionService__2 = game:GetService("ContextActionService");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__RunService__4 = game:GetService("RunService");
game:GetService("StarterGui");
local l__TweenService__5 = game:GetService("TweenService");
local l__ReplicatedStorage__6 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__7 = l__Players__1.LocalPlayer;
local l__Character__8 = l__LocalPlayer__7.Character;
local l__Humanoid__9 = l__Character__8:WaitForChild("Humanoid");
local l__CurrentCamera__10 = workspace.CurrentCamera;
local l__TankGui__11 = l__LocalPlayer__7.PlayerGui:WaitForChild("TankGui");
local l__TankGuiModule__12 = require(l__TankGui__11:WaitForChild("TankGuiModule"));
local l__VehicleToolbar__13 = l__LocalPlayer__7.PlayerGui:WaitForChild("VehicleToolbar");
local l__ToolbarHandler__14 = require(l__VehicleToolbar__13:WaitForChild("ToolbarHandler"));
local u1 = l__ReplicatedStorage__6:WaitForChild("Aimpart"):Clone();
local u2 = l__ReplicatedStorage__6:WaitForChild("AimpartAim"):Clone();
local u3 = l__ReplicatedStorage__6:WaitForChild("AimpartGoal"):Clone();
local u4 = l__ReplicatedStorage__6:WaitForChild("AimpartProxy"):Clone();
local l__StatusUI__15 = l__LocalPlayer__7.PlayerGui:WaitForChild("StatusUI", 999);
local l__ContextTutorialGui__16 = l__LocalPlayer__7.PlayerGui:WaitForChild("ContextTutorialGui");
local l__ContextualTutorialPresets__17 = require(l__ContextTutorialGui__16:WaitForChild("ContextualTutorialPresets"));
local l__ReloadVehicle__18 = l__LocalPlayer__7.PlayerGui:WaitForChild("CustomMobileGui"):WaitForChild("RightFrame"):WaitForChild("Buttons"):WaitForChild("ReloadVehicle");
local l__Reload__19 = script:WaitForChild("Reload");
local l__ReplicatedStorage__20 = game:GetService("ReplicatedStorage");
local l__Modules__21 = l__ReplicatedStorage__20:WaitForChild("Modules");
local l__ShootModule__22 = require(l__Modules__21:WaitForChild("Projectile"):WaitForChild("ShootModule"));
local l__VehicleModule__23 = require(l__Modules__21:WaitForChild("VehicleModule"));
local l__HeatseekModule__24 = require(l__Modules__21:WaitForChild("HeatseekModule"));
local l__ACS_Engine__25 = l__ReplicatedStorage__20:WaitForChild("ACS_Engine");
local l__Events__26 = l__ACS_Engine__25:WaitForChild("Events");
local l__Hitmarker__27 = require(l__ACS_Engine__25:WaitForChild("Modules"):WaitForChild("Hitmarker"));
local l__SpringV3__28 = require(l__ACS_Engine__25.Modules:WaitForChild("SpringV3"));
local u5 = nil;
local u6 = false;
local u7 = nil;
local u8 = {};
local u9 = {};
local u10 = RaycastParams.new();
u10.FilterType = Enum.RaycastFilterType.Exclude;
u10.CollisionGroup = "CamCast";
local u11 = RaycastParams.new();
u11.FilterType = Enum.RaycastFilterType.Exclude;
u11.CollisionGroup = "CamCast";
UDim2.new(0.5, 0, 0.4, 0);
local u12 = {
    Reticle = l__SpringV3__28:create(100, nil, 2, 20)
};
local u13 = {};
local function u18(p14) --[[ Line: 79 ]]
    -- upvalues: l__ReplicatedStorage__20 (copy), u5 (ref), l__Humanoid__9 (copy)
    if l__ReplicatedStorage__20.Vehicles:FindFirstChild(p14.Name) then
        local l__CameraPart__29 = p14.Required.CameraPart;
        u5 = {
            EquippedWeapon = 1,
            Vehicle = p14,
            Seat = p14.Required:FindFirstChildOfClass("VehicleSeat"),
            Dome = {
                XPart = l__CameraPart__29,
                YPart = p14.Required.Dome.DomePart,
                XMotor = l__CameraPart__29.XMotor,
                YMotor = l__CameraPart__29.YMotor,
                FollowPart = p14.Required.Dome.FollowPart
            },
            Config = require(p14.Params.Config),
            Weapons = {}
        };
        if p14.Required:FindFirstChild("CoaxDome") then
            local l__CoaxCameraPart__30 = p14.Required.CoaxCameraPart;
            u5.CoaxDome = {
                XPart = l__CoaxCameraPart__30,
                YPart = p14.Required.CoaxDome.DomePart,
                XMotor = l__CoaxCameraPart__30.XMotor,
                YMotor = l__CoaxCameraPart__30.YMotor,
                FollowPart = p14.Required.CoaxDome.FollowPart
            };
        end;
        u5.Height = u5.Config.Height or 0;
        local l__Name__31 = l__Humanoid__9.SeatPart.Name;
        local v15 = (l__Name__31 == "TankSeat" or l__Name__31 == "ApcSeat") and "DriverWeapons" or (l__Name__31 == "GunnerSeat" and "GunnerWeapons" or nil);
        if v15 and u5.Config[v15] then
            for _, v16 in u5.Config[v15] do
                table.insert(u5.Weapons, v16);
            end;
        end;
        for _, v17 in ipairs(u5.Weapons) do
            v17.LastShotTs = 0;
            v17.IsReloading = false;
        end;
    else
        warn(p14.Name .. " not found!");
    end;
end;
local function u20() --[[ Line: 136 ]]
    -- upvalues: u7 (ref), u5 (ref), u13 (ref), l__ToolbarHandler__14 (copy)
    u7 = false;
    u5 = nil;
    for _, u19 in u13 do
        pcall(function() --[[ Line: 141 ]]
            -- upvalues: u19 (copy)
            task.cancel(u19);
        end);
    end;
    u13 = {};
    l__ToolbarHandler__14.Clear();
end;
local function u24(p21) --[[ Line: 174 ]]
    -- upvalues: u11 (copy), u5 (ref), u1 (copy)
    local l__Position__32 = p21.FollowPart.Position;
    local v22 = p21.FollowPart.CFrame.LookVector * 2000;
    u11.FilterDescendantsInstances = { u5.Vehicle, workspace.CosmeticShellsFolder, u1 };
    local v23 = workspace:Raycast(l__Position__32, v22, u11);
    if v23 and (v23.Instance and v23.Position) then
        u1.Position = v23.Position;
    else
        u1.CFrame = p21.FollowPart.CFrame * CFrame.new(0, 0, -2000);
    end;
end;
local function u28() --[[ Line: 193 ]]
    -- upvalues: u10 (copy), u8 (ref), l__TankGui__11 (copy), u9 (ref), u28 (copy)
    u10.FilterDescendantsInstances = u8;
    local l__CurrentCamera__33 = workspace.CurrentCamera;
    local l__ReticleFrame__34 = l__TankGui__11.MainFrame.ReticleFrame;
    local v25 = l__ReticleFrame__34.AbsolutePosition + l__ReticleFrame__34.AbsoluteSize / 2;
    local v26 = l__CurrentCamera__33:ScreenPointToRay(v25.X, v25.Y, 1);
    local v27 = workspace:Raycast(v26.Origin, v26.Direction.Unit * 2000, u10);
    if not v27 then
        return v26.Origin + v26.Direction.Unit * 2000;
    end;
    if (l__CurrentCamera__33.CFrame.Position - v27.Position).magnitude >= 40 or not v27.Instance:IsA("BasePart") then
        return v27.Position;
    end;
    table.insert(u8, v27.Instance);
    if v27.Instance.Transparency == 0 then
        v27.Instance.Transparency = 0.7;
        table.insert(u9, v27.Instance);
    end;
    return u28();
end;
local function u30(p29) --[[ Line: 226 ]]
    -- upvalues: l__Players__1 (copy)
    return l__Players__1.LocalPlayer:GetAttribute(({
        [Enum.UserInputType.MouseMovement] = "PCLandVehicleSensitivity",
        [Enum.UserInputType.Touch] = "MobileLandVehicleSensitivity",
        [Enum.UserInputType.Gamepad1] = "ConsoleLandVehicleSensitivity"
    })[p29] or "PCLandVehicleSensitivity") or 1;
end;
l__Humanoid__9.Seated:Connect(function() --[[ Name: onSeated, Line 237 ]]
    -- upvalues: l__Humanoid__9 (copy), l__VehicleModule__23 (copy), l__ContextualTutorialPresets__17 (copy), u18 (copy), u30 (copy), u12 (copy), u7 (ref), u5 (ref), l__ToolbarHandler__14 (copy), l__Reload__19 (copy), u13 (ref), l__TankGuiModule__12 (copy), l__HeatseekModule__24 (copy), l__Character__8 (copy), u1 (copy), u11 (copy), u4 (copy), l__ShootModule__22 (copy), l__LocalPlayer__7 (copy), l__Events__26 (copy), l__RunService__4 (copy), l__Hitmarker__27 (copy), l__UserInputService__3 (copy), u6 (ref), l__CurrentCamera__10 (copy), l__TweenService__5 (copy), l__ContextActionService__2 (copy), l__ReloadVehicle__18 (copy), l__StatusUI__15 (copy), u9 (ref), u8 (ref), u28 (copy), u2 (copy), u3 (copy), u20 (copy), l__TankGui__11 (copy), u24 (copy)
    if l__Humanoid__9.SeatPart then
        local u31 = l__VehicleModule__23.checkAndGetTank(l__Humanoid__9.SeatPart);
        if u31 then
            if l__Humanoid__9.SeatPart.Name == "TankSeat" or (l__Humanoid__9.SeatPart.Name == "GunnerSeat" or l__Humanoid__9.SeatPart.Name == "ApcSeat") then
                l__ContextualTutorialPresets__17.startArmedGroundVehicleTutorial();
                u18(u31);
                local l__Y__35 = l__Humanoid__9.SeatPart.Orientation.Y;
                local u32 = 100;
                local u33 = l__Y__35;
                local u34 = u32;
                local u35 = 0;
                local u36 = 0;
                local u37 = nil;
                local function v44(_, p38, p39) --[[ Line: 269 ]]
                    -- upvalues: u37 (ref), u30 (ref), u32 (ref), u12 (ref), l__Y__35 (ref)
                    if p38 == Enum.UserInputState.Change then
                        u37 = p39.UserInputType;
                        local l__GameSettings__36 = UserSettings().GameSettings;
                        local v40 = u37 ~= Enum.UserInputType.MouseMovement and 1 or l__GameSettings__36.MouseSensitivity;
                        local v41 = u30(u37);
                        local v42 = math.clamp(u32 + p39.Delta.Y * (v40 * 0.4 * v41), 10, 170);
                        local v43 = {
                            X = math.clamp(p39.Delta.X, -10, 10),
                            Y = math.clamp(p39.Delta.Y, -10, 10)
                        };
                        u12.Reticle:shove((Vector3.new(v43.X * 2, v43.Y * 2, 0)));
                        u32 = v42;
                        l__Y__35 = l__Y__35 - p39.Delta.X * v40 * v41;
                    end;
                end;
                local function u48() --[[ Line: 297 ]]
                    -- upvalues: u7 (ref), u5 (ref), l__ToolbarHandler__14 (ref), l__Reload__19 (ref), u13 (ref), l__TankGuiModule__12 (ref)
                    u7 = false;
                    local u45 = u5.Weapons[u5.EquippedWeapon];
                    u45.IsReloading = true;
                    u45.LastReloadStarted = os.clock();
                    local v46 = task.spawn(function() --[[ Line: 303 ]]
                        -- upvalues: u45 (copy), l__ToolbarHandler__14 (ref)
                        if u45 then
                            l__ToolbarHandler__14.StartReload(u45.Name, u45.ReloadTime);
                            task.wait(u45.ReloadTime);
                            if u45 then
                                u45.Ammo = u45.AmmoInGun;
                                u45.IsReloading = false;
                                l__ToolbarHandler__14.UpdateAmmo(u45.Name, u45.Ammo);
                            end;
                        end;
                    end);
                    local v47 = task.spawn(function() --[[ Line: 313 ]]
                        -- upvalues: u45 (copy), l__Reload__19 (ref)
                        if u45 then
                            task.wait(u45.ReloadTime - l__Reload__19.TimeLength);
                            l__Reload__19:Play();
                        end;
                    end);
                    table.insert(u13, v46);
                    table.insert(u13, v47);
                    l__TankGuiModule__12.reload(u45.ReloadTime);
                end;
                local function u53() --[[ Line: 329 ]]
                    -- upvalues: u5 (ref), l__HeatseekModule__24 (ref), l__Humanoid__9 (ref), l__TankGuiModule__12 (ref), l__Character__8 (ref), u1 (ref), u11 (ref), u4 (ref), u7 (ref), l__ShootModule__22 (ref), l__LocalPlayer__7 (ref), l__Events__26 (ref), l__RunService__4 (ref), l__Hitmarker__27 (ref), l__ToolbarHandler__14 (ref), u48 (copy)
                    local v49 = u5.Weapons[u5.EquippedWeapon];
                    if v49.SpecialType == "Heatseeker" and not l__HeatseekModule__24.getLockedTarget() then
                    else
                        if v49.MustBeStatic then
                            local l__SeatPart__37 = l__Humanoid__9.SeatPart;
                            if l__SeatPart__37 and math.floor(l__SeatPart__37.AssemblyLinearVelocity.Magnitude) > 1 then
                                l__TankGuiModule__12.notify("Cannot fire while moving");
                                return;
                            end;
                        end;
                        if v49.ObstructedThisFrame then
                            l__TankGuiModule__12.notify("Firing angle is obstructed");
                        elseif v49.LastShotTs > tick() - 60 / v49.ShootRate or (v49.IsReloading or v49.Ammo <= 0) then
                        else
                            local l__Dome__38 = u5.Dome;
                            if v49.Dome then
                                l__Dome__38 = u5[v49.Dome .. "Dome"];
                            end;
                            local v50 = {
                                weaponName = v49.Name,
                                vehicleName = u5.Vehicle.Name,
                                shellType = v49.ShellType or "Bullet",
                                shellName = v49.ShellName,
                                shellSpeed = v49.MuzzleVelocity,
                                shellMaxDist = v49.ShellMaxDist or 7000,
                                filterDescendants = { l__Character__8, u5.Vehicle },
                                origin = l__Dome__38.FollowPart.Position
                            };
                            local v51 = {};
                            if v49.SpecialType == "Heatseeker" then
                                v50.moverType = v49.pathType;
                                v50.specialType = v49.SpecialType;
                                v50.lockedTarget = l__HeatseekModule__24.getLockedTarget();
                            elseif v49.SpecialType == "Artillery" then
                                if not u1 then
                                    warn("No aimpart!");
                                    return;
                                end;
                                local v52 = workspace:Raycast(u1.Position + Vector3.new(0, 1, 0), Vector3.new(0, -2000, 0), u11);
                                if v52 then
                                    local _ = v52.Position;
                                end;
                                v50.moverType = v49.pathType;
                                v50.specialType = "Artillery";
                                v51.hitPosition = u4.Position;
                                v51.domeFolder = l__Dome__38;
                                v51.params = u11;
                                if (v51.hitPosition - l__Dome__38.XPart.Position).Magnitude < 40 then
                                    l__TankGuiModule__12.notify("Target too close");
                                    return;
                                end;
                            end;
                            u7 = true;
                            v49.LastShotTs = tick();
                            v50.shellGravity = v49.ShellGravity;
                            l__ShootModule__22.fire(l__LocalPlayer__7, l__Dome__38.FollowPart.Position, l__Dome__38.FollowPart.CFrame.LookVector, v50, v51);
                            l__Events__26.ServerBullet:FireServer(l__Dome__38.FollowPart.Position, l__Dome__38.FollowPart.CFrame.LookVector, v50);
                            if v49.ShotImpulse then
                                l__RunService__4.Heartbeat:Wait();
                                l__Dome__38.XPart:ApplyImpulse(-l__Dome__38.FollowPart.CFrame.LookVector * v49.ShotImpulse);
                            end;
                            l__Hitmarker__27.tankShot(l__LocalPlayer__7, u5.EquippedWeapon);
                            l__Events__26.TankFireFX:FireServer(u5.EquippedWeapon);
                            v49.Ammo = v49.Ammo - 1;
                            l__ToolbarHandler__14.UpdateAmmo(v49.Name, v49.Ammo);
                            if v49.FireMode ~= "Auto" then
                                u7 = false;
                            end;
                            if v49.Ammo <= 0 then
                                u48();
                            end;
                        end;
                    end;
                end;
                local function v55(_, p54, _) --[[ Line: 430 ]]
                    -- upvalues: u7 (ref), u53 (copy)
                    if p54 == Enum.UserInputState.End or p54 == Enum.UserInputState.Cancel then
                        u7 = false;
                    else
                        if p54 == Enum.UserInputState.Begin then
                            u53();
                        end;
                    end;
                end;
                local function v57(_, p56, _) --[[ Line: 439 ]]
                    -- upvalues: l__UserInputService__3 (ref), u7 (ref), u53 (copy)
                    if l__UserInputService__3:GetLastInputType() == Enum.UserInputType.Gamepad1 then
                    elseif p56 == Enum.UserInputState.End or p56 == Enum.UserInputState.Cancel then
                        u7 = false;
                    else
                        if p56 == Enum.UserInputState.Begin then
                            u53();
                        end;
                    end;
                end;
                local function u64(p58) --[[ Line: 445 ]]
                    -- upvalues: u5 (ref), l__HeatseekModule__24 (ref), l__TankGuiModule__12 (ref), u6 (ref), u7 (ref), l__CurrentCamera__10 (ref)
                    local l__EquippedWeapon__39 = u5.EquippedWeapon;
                    for v59, v60 in u5.Weapons do
                        if v60.Name == p58 then
                            l__EquippedWeapon__39 = v59;
                            break;
                        end;
                    end;
                    u5.EquippedWeapon = l__EquippedWeapon__39;
                    l__HeatseekModule__24.adsStopped();
                    local v61 = u5.Weapons[l__EquippedWeapon__39];
                    l__TankGuiModule__12.switchGun(v61.Name);
                    u6 = false;
                    u7 = false;
                    l__CurrentCamera__10.FieldOfView = v61.FOV;
                    local v62 = u5.Weapons[u5.EquippedWeapon];
                    if v62.IsReloading and v62.LastReloadStarted then
                        local v63 = v62.LastReloadStarted + v62.ReloadTime - os.clock();
                        l__TankGuiModule__12.reload(v62.ReloadTime, v62.ReloadTime - v63);
                    end;
                end;
                local function u68(_, p65, _) --[[ Line: 474 ]]
                    -- upvalues: u5 (ref), u6 (ref), l__TweenService__5 (ref), l__CurrentCamera__10 (ref)
                    local v66 = u5.Weapons[u5.EquippedWeapon];
                    if p65 == Enum.UserInputState.Begin then
                        local v67 = u6 and v66.FOV or v66.AimFOV;
                        u6 = not u6;
                        l__TweenService__5:Create(l__CurrentCamera__10, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                            FieldOfView = v67
                        }):Play();
                    end;
                end;
                local function v72(p69, p70, p71) --[[ Line: 484 ]]
                    -- upvalues: l__UserInputService__3 (ref), u68 (copy)
                    if l__UserInputService__3:GetLastInputType() == Enum.UserInputType.Gamepad1 then
                    else
                        u68(p69, p70, p71);
                    end;
                end;
                l__CurrentCamera__10.CameraType = Enum.CameraType.Scriptable;
                local function v74(p73, _) --[[ Line: 492 ]]
                    -- upvalues: u37 (ref), u35 (ref), u36 (ref)
                    if p73.UserInputType == Enum.UserInputType.Gamepad1 and p73.KeyCode == Enum.KeyCode.Thumbstick2 then
                        u37 = p73.UserInputType;
                        if math.abs(p73.Position.X) > 0.03 then
                            u35 = p73.Position.X;
                        else
                            u35 = 0;
                        end;
                        if math.abs(p73.Position.Y) > 0.03 then
                            u36 = p73.Position.Y;
                            return;
                        end;
                        u36 = 0;
                    end;
                end;
                local function v77(_, p75, _) --[[ Line: 511 ]]
                    -- upvalues: u5 (ref), u48 (copy)
                    if p75 == Enum.UserInputState.Begin then
                        local v76 = u5.Weapons[u5.EquippedWeapon];
                        if v76.IsReloading then
                        elseif v76.Ammo == v76.AmmoInGun then
                        else
                            u48();
                        end;
                    end;
                end;
                local u78 = l__UserInputService__3.InputBegan:Connect(v74);
                local u79 = l__UserInputService__3.InputChanged:Connect(v74);
                local u80 = l__UserInputService__3.InputEnded:Connect(v74);
                l__ContextActionService__2:BindAction("PlayerInput", v44, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch);
                local v81 = l__ReloadVehicle__18;
                local l__Weapons__40 = u5.Weapons;
                if l__Weapons__40 then
                    l__Weapons__40 = #u5.Weapons > 0;
                end;
                v81.Visible = l__Weapons__40;
                l__ToolbarHandler__14.Clear();
                local u82;
                if u5.Weapons and #u5.Weapons > 0 then
                    u1.Parent = workspace;
                    u1.Aim.Enabled = true;
                    l__TankGuiModule__12.setVisible(true);
                    l__StatusUI__15.MainFrame.Gun.Visible = true;
                    for _, u83 in u5.Weapons do
                        l__ToolbarHandler__14.AddVehicleWeapon(u83.Name, u83.Ammo, u83.AmmoInGun, function(p84) --[[ Line: 541 ]]
                            -- upvalues: u64 (copy), u83 (copy)
                            if p84 == "Equip" then
                                u64(u83.Name);
                            end;
                        end);
                    end;
                    l__ContextActionService__2:BindAction("FireTank", v55, true, Enum.KeyCode.ButtonR1);
                    l__ContextActionService__2:BindAction("TankZoom", u68, true, Enum.KeyCode.ButtonL1);
                    l__ContextActionService__2:BindAction("FireTankPC", v57, false, Enum.UserInputType.MouseButton1);
                    l__ContextActionService__2:BindAction("TankZoomPC", v72, false, Enum.UserInputType.MouseButton2);
                    l__ContextActionService__2:BindAction("TankReload", v77, false, Enum.KeyCode.R, Enum.KeyCode.ButtonX);
                    l__ContextActionService__2:SetPosition("FireTank", UDim2.new(0.81, -135, 0.05, -35));
                    l__ContextActionService__2:SetImage("FireTank", "https://www.roblox.com/asset/?id=444744114");
                    l__ContextActionService__2:SetPosition("TankZoom", UDim2.new(0.5, 0, 0.15, 0));
                    l__ContextActionService__2:SetImage("TankZoom", "https://www.roblox.com/asset/?id=3119564478");
                    u82 = l__ReloadVehicle__18.InputBegan:Connect(function() --[[ Line: 561 ]]
                        -- upvalues: u5 (ref), u48 (copy)
                        if Enum.UserInputState.Begin == Enum.UserInputState.Begin then
                            local v85 = u5.Weapons[u5.EquippedWeapon];
                            if v85.IsReloading then
                            elseif v85.Ammo == v85.AmmoInGun then
                            else
                                u48();
                            end;
                        end;
                    end);
                else
                    u82 = nil;
                end;
                local u86 = nil;
                u86 = l__RunService__4.RenderStepped:Connect(function(u87) --[[ Line: 567 ]]
                    -- upvalues: l__StatusUI__15 (ref), u5 (ref), u9 (ref), u8 (ref), u28 (ref), l__Humanoid__9 (ref), l__ContextActionService__2 (ref), u82 (ref), l__ReloadVehicle__18 (ref), u86 (ref), u78 (ref), u79 (ref), u80 (ref), l__TankGuiModule__12 (ref), u1 (ref), u2 (ref), u3 (ref), u4 (ref), u7 (ref), l__CurrentCamera__10 (ref), l__UserInputService__3 (ref), u20 (ref), u37 (ref), u30 (ref), l__Y__35 (ref), u35 (ref), u32 (ref), u36 (ref), u31 (copy), u33 (ref), u34 (ref), l__TankGui__11 (ref), u48 (copy), u53 (copy), u24 (ref), l__HeatseekModule__24 (ref)
                    if l__StatusUI__15 then
                        local l__Gun__41 = l__StatusUI__15.MainFrame.Gun;
                        local u88 = u5.Weapons[u5.EquippedWeapon];
                        local v89 = u88.Ammo == 0 and 0 or 255;
                        l__Gun__41.Ammo.TextColor3 = Color3.fromRGB(255, v89, v89);
                        l__Gun__41.Ammo.Text = math.max(u88.Ammo, 0);
                        l__Gun__41.StoredAmmo.Text = u88.AmmoInGun;
                        for _, v90 in ipairs(u9) do
                            v90.Transparency = 0;
                        end;
                        u8 = { u5.Vehicle };
                        u9 = {};
                        local u91 = u28();
                        if l__Humanoid__9.SeatPart and (l__Humanoid__9.SeatPart.Name == "TankSeat" or l__Humanoid__9.SeatPart.Name == "ApcSeat") then
                            if l__CurrentCamera__10.CameraType ~= Enum.CameraType.Scriptable then
                                l__CurrentCamera__10.CameraType = Enum.CameraType.Scriptable;
                            end;
                            l__UserInputService__3.MouseBehavior = Enum.MouseBehavior.LockCenter;
                            l__UserInputService__3.MouseIconEnabled = false;
                            local l__GameSettings__42 = UserSettings().GameSettings;
                            local v92 = 1;
                            local v93;
                            if u37 == Enum.UserInputType.MouseMovement then
                                v93 = l__GameSettings__42.MouseSensitivity;
                            else
                                v93 = u37 == Enum.UserInputType.Gamepad1 and 1 or v92;
                            end;
                            local v94 = u30(u37);
                            l__Y__35 = l__Y__35 - u35 * v93 * v94;
                            u32 = math.clamp(u32 - u36 * (v93 * 0.4 * v94), 10, 170);
                            local function u108(p95, p96, p97) --[[ Line: 665 ]]
                                -- upvalues: u31 (ref)
                                local v98 = u31:GetAttribute("CameraOffset") or Vector3.new();
                                local v99 = p95.XPart.CFrame * CFrame.new(v98);
                                local v100 = math.sin(p96);
                                local v101 = math.cos(p96);
                                local v102 = math.sin(p97);
                                local v103 = math.cos(p97);
                                local v104 = CFrame.new(v99.Position + Vector3.new(v100, 0, v101));
                                local v105 = CFrame.new(v104.Position, v99.Position);
                                local v106 = CFrame.new(v99.Position, v105.Position) * CFrame.new(0, v103, v102);
                                local v107 = CFrame.new(v106.Position, v99.Position);
                                return CFrame.new(v104.Position + (v99.Position - v107.Position) * 35 + Vector3.new(0, 8, 0), v99.Position + Vector3.new(0, 8, 0));
                            end;
                            local function v131(p109, p110) --[[ Line: 692 ]]
                                -- upvalues: l__Y__35 (ref), u32 (ref), u108 (copy), u33 (ref), u87 (copy), u34 (ref), l__CurrentCamera__10 (ref), u1 (ref), l__TankGui__11 (ref), u88 (copy), u31 (ref), u91 (copy), u3 (ref), u2 (ref), u4 (ref)
                                if p109 then
                                    if p110 then
                                        local v111 = math.rad(l__Y__35);
                                        local v112 = math.rad(u32);
                                        local v113 = u108(p109, v111, v112);
                                        local v114 = math.rad(u33);
                                        local v115 = v114 + u87 * 3 * (v111 - v114);
                                        local v116 = math.rad(u34);
                                        local v117 = v116 + u87 * 3 * (v112 - v116);
                                        l__CurrentCamera__10.CFrame = u108(p109, v115, v117);
                                        u33 = math.deg(v115);
                                        u34 = math.deg(v117);
                                        local v118 = l__CurrentCamera__10:WorldToScreenPoint((v113 * CFrame.new(0, 0, -(v113.Position - u1.Position).Magnitude)).Position);
                                        l__TankGui__11.MainFrame.Position = UDim2.new(0, v118.X, 0, v118.Y);
                                    end;
                                    if u88.MotorDelegate then
                                        local v119 = require(script.MotorDelegates[u88.MotorDelegate]);
                                        local v120, v121 = v119.Tick(u31, p109, u91);
                                        p109.XMotor.TargetAngle = v120;
                                        p109.YMotor.TargetAngle = v121;
                                        if v119.GetPredictiveAimPos then
                                            local v122 = v119.GetPredictiveAimPos(u31, p109, u91);
                                            u1.Aim.Enabled = false;
                                            u3.Parent = workspace;
                                            u3.CFrame = CFrame.new(v122);
                                            local v123 = v119.GetAimPos(u31, p109, u91);
                                            u2.Parent = workspace;
                                            u2.CFrame = CFrame.new(v123);
                                            local v124 = v119.GetTargetPos(u31, p109, u91);
                                            u4.Parent = workspace;
                                            u4.CFrame = CFrame.new(v124);
                                            u3.Aim.Enabled = true;
                                            u2.Aim.Enabled = true;
                                            u4.Aim.Enabled = true;
                                        else
                                            u1.Aim.Enabled = true;
                                            u3.Parent = script;
                                            u2.Parent = script;
                                            u4.Parent = script;
                                            u3.Aim.Enabled = false;
                                            u2.Aim.Enabled = false;
                                            u4.Aim.Enabled = false;
                                        end;
                                    else
                                        local l__XMotor__43 = p109.XMotor;
                                        local l__CFrame__44 = p109.XPart.CFrame;
                                        local v125 = l__CFrame__44:VectorToObjectSpace(u91 - l__CFrame__44.Position);
                                        local v126 = math.atan2(v125.X, v125.Z);
                                        l__XMotor__43.TargetAngle = math.deg(v126) - 180;
                                        local l__YMotor__45 = p109.YMotor;
                                        local l__CFrame__46 = p109.YPart.CFrame;
                                        local v127 = l__CFrame__46:VectorToObjectSpace(u91 - l__CFrame__46.Position);
                                        local l__Y__47 = v127.Y;
                                        local l__X__48 = v127.X;
                                        local l__Z__49 = v127.Z;
                                        local v128 = math.sqrt(l__X__48 * l__X__48 + l__Z__49 * l__Z__49);
                                        local v129 = math.atan2(l__Y__47, v128);
                                        l__YMotor__45.TargetAngle = math.deg(v129);
                                        if p109.XMotor.CurrentAngle > 135 or p109.XMotor.CurrentAngle < -135 then
                                            p109.YMotor.TargetAngle = math.max(0, p109.YMotor.TargetAngle);
                                        end;
                                        u1.Aim.Enabled = true;
                                        u3.Parent = script;
                                        u2.Parent = script;
                                        u4.Parent = script;
                                        u3.Aim.Enabled = false;
                                        u2.Aim.Enabled = false;
                                        u4.Aim.Enabled = false;
                                    end;
                                    if u88 and u88.ObstructionAngles then
                                        local l__ObstructionAngles__50 = u88.ObstructionAngles;
                                        u88.ObstructedThisFrame = false;
                                        local v130 = l__ObstructionAngles__50.Axis == "X" and p109.XMotor or p109.YMotor;
                                        local l__CurrentAngle__51 = v130.CurrentAngle;
                                        local _ = l__ObstructionAngles__50.InvalidArea;
                                        if l__ObstructionAngles__50.InvalidArea.Min < l__CurrentAngle__51 and l__CurrentAngle__51 < l__ObstructionAngles__50.InvalidArea.Max then
                                            if (v130 == p109.XMotor and p109.YMotor or p109.XMotor).CurrentAngle > l__ObstructionAngles__50.OtherAxisClearance then
                                                return;
                                            end;
                                            u88.ObstructedThisFrame = true;
                                        end;
                                    end;
                                end;
                            end;
                            v131(u5.Dome, true);
                            v131(u5.CoaxDome);
                            local v132 = u5.Weapons[u5.EquippedWeapon];
                            if v132.Ammo <= 0 and not v132.IsReloading then
                                u48();
                            end;
                            if u7 and (not v132.IsReloading and v132.LastShotTs <= tick() - 60 / v132.ShootRate) then
                                u53();
                            end;
                            local l__Dome__52 = u5.Dome;
                            if v132.Dome then
                                l__Dome__52 = u5[v132.Dome .. "Dome"];
                            end;
                            u24(l__Dome__52);
                            if v132.SpecialType == "Heatseeker" then
                                local v133 = v132.pathType == "Stinger" and "Air" or "Land";
                                local v134 = workspace.CurrentCamera:WorldToScreenPoint(u1.Position);
                                local v135 = { u31 };
                                l__HeatseekModule__24.aimTick(v133, Vector2.new(v134.X, v134.Y), v135, v132.Name);
                            end;
                        else
                            l__ContextActionService__2:UnbindAction("PlayerInput");
                            l__ContextActionService__2:UnbindAction("FocusControl");
                            l__ContextActionService__2:UnbindAction("FireTank");
                            l__ContextActionService__2:UnbindAction("TankZoom");
                            l__ContextActionService__2:UnbindAction("FireTankPC");
                            l__ContextActionService__2:UnbindAction("TankZoomPC");
                            l__ContextActionService__2:UnbindAction("TankReload");
                            if u82 then
                                u82:Disconnect();
                                u82 = nil;
                                l__ReloadVehicle__18.Visible = false;
                            end;
                            u86:Disconnect();
                            u78:Disconnect();
                            u79:Disconnect();
                            u80:Disconnect();
                            l__TankGuiModule__12.setVisible(false);
                            l__Gun__41.Visible = false;
                            u1.Aim.Enabled = false;
                            u1.Parent = script;
                            u2.Aim.Enabled = false;
                            u2.Parent = script;
                            u3.Aim.Enabled = false;
                            u3.Parent = script;
                            u4.Aim.Enabled = false;
                            u4.Parent = script;
                            u7 = false;
                            for _, v136 in ipairs(u9) do
                                v136.Transparency = 0;
                            end;
                            u8 = {};
                            u9 = {};
                            spawn(function() --[[ Line: 629 ]]
                                -- upvalues: l__CurrentCamera__10 (ref), l__UserInputService__3 (ref)
                                l__CurrentCamera__10.CameraType = Enum.CameraType.Custom;
                                l__CurrentCamera__10.FieldOfView = 70;
                                l__UserInputService__3.MouseBehavior = Enum.MouseBehavior.Default;
                                l__UserInputService__3.MouseIconEnabled = true;
                            end);
                            u20();
                        end;
                    end;
                end);
            else
                l__ContextualTutorialPresets__17.startUnarmedGroundVehicleTutorial();
            end;
        else
            l__ContextualTutorialPresets__17.startUnarmedGroundVehicleTutorial();
        end;
    end;
end);
l__ReloadVehicle__18.Visible = false;