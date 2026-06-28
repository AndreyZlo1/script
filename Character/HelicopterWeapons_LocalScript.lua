-- Roblox: Workspace.SilverAce293026.HelicopterWeapons
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = game:getService("ContextActionService");
local l__UserInputService__1 = game:GetService("UserInputService");
local l__RunService__2 = game:GetService("RunService");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__CustomMobileGui__4 = l__LocalPlayer__3:WaitForChild("PlayerGui"):WaitForChild("CustomMobileGui");
l__CustomMobileGui__4:WaitForChild("LeftHeliFrame");
local l__RightHeliFrame__5 = l__CustomMobileGui__4:WaitForChild("RightHeliFrame");
local l__StarterPlayer__6 = game:GetService("StarterPlayer");
local l__Character__7 = l__LocalPlayer__3.Character;
local l__Humanoid__8 = l__Character__7:WaitForChild("Humanoid");
local l__ReplicatedStorage__9 = game:GetService("ReplicatedStorage");
local l__Modules__10 = l__ReplicatedStorage__9:WaitForChild("Modules");
local l__ShootModule__11 = require(l__Modules__10:WaitForChild("Projectile"):WaitForChild("ShootModule"));
require(l__Modules__10:WaitForChild("VFXModule"));
local l__VehicleModule__12 = require(l__Modules__10:WaitForChild("VehicleModule"));
local l__HeatseekModule__13 = require(l__Modules__10:WaitForChild("HeatseekModule"));
local l__UnreliableHeliEvent__14 = l__ReplicatedStorage__9:WaitForChild("PlayerEvents"):WaitForChild("UnreliableHeliEvent");
script.Parent:WaitForChild("Helicopter"):WaitForChild("GetAimPart");
local l__Reload__15 = script:WaitForChild("Reload");
local u2 = l__ReplicatedStorage__9:WaitForChild("Aimpart"):Clone();
local l__ACS_Engine__16 = l__ReplicatedStorage__9:WaitForChild("ACS_Engine");
local l__Events__17 = l__ACS_Engine__16:WaitForChild("Events");
local l__Hitmarker__18 = require(l__ACS_Engine__16:WaitForChild("Modules"):WaitForChild("Hitmarker"));
local l__PlayerGui__19 = l__LocalPlayer__3:WaitForChild("PlayerGui");
local l__HeliGuiModule__20 = require(l__PlayerGui__19:WaitForChild("HeliGui"):WaitForChild("HeliGuiModule"));
local l__StatusUI__21 = l__PlayerGui__19:WaitForChild("StatusUI", 999);
local l__VehicleToolbar__22 = l__PlayerGui__19:WaitForChild("VehicleToolbar");
local l__ToolbarHandler__23 = require(l__VehicleToolbar__22:WaitForChild("ToolbarHandler"));
local u3 = nil;
local u4 = nil;
local l__CurrentCamera__24 = workspace.CurrentCamera;
local function u7(p5, ...) --[[ Line: 49 ]]
    for _, v6 in { ... } do
        table.insert(p5, v6);
    end;
end;
local u8 = nil;
local u9 = nil;
local u10 = 1;
local u11 = {};
local function u23(p12, p13) --[[ Line: 74 ]]
    -- upvalues: u4 (ref), u3 (ref), u8 (ref), u10 (ref), l__ToolbarHandler__23 (copy), u9 (ref)
    u4 = p12;
    u3 = p12.Required.HeliSeat;
    u8 = {};
    u10 = 1;
    local v14 = u4.Params:FindFirstChild("Config");
    l__ToolbarHandler__23.Clear();
    if v14 then
        local v15 = require(v14);
        u8 = {};
        local v16 = p13 == "HeliSeat" and "DriverWeapons" or (p13 == "GunnerSeat" and "GunnerWeapons" or nil);
        if v16 and v15[v16] then
            for _, v17 in v15[v16] do
                table.insert(u8, v17);
            end;
        end;
        local l__Weaponry__25 = u4.Weaponry;
        u9 = {};
        for v18, v19 in u8 do
            v19.AmmoFull = v19.Ammo;
            if v19.HardpointData then
                local l__HardpointData__26 = v19.HardpointData;
                local v20 = l__Weaponry__25[l__HardpointData__26.Name];
                u9[v18] = {
                    Parts = {},
                    Folder = v20
                };
                if l__HardpointData__26.Mode == "Sequential" then
                    local v21 = 1;
                    local v22 = v20:FindFirstChild("Muzzle" .. v21);
                    while v22 ~= nil do
                        table.insert(u9[v18].Parts, v22);
                        v21 = v21 + 1;
                        v22 = v20:FindFirstChild("Muzzle" .. v21);
                    end;
                    v19.HardpointIndexToUse = 1;
                else
                    local _ = v19.HardpointData.Mode == "Simultaneous";
                end;
            end;
        end;
    else
        u8 = nil;
    end;
end;
local u24 = {};
local u25 = {};
local u26 = RaycastParams.new();
u26.FilterType = Enum.RaycastFilterType.Exclude;
u26.CollisionGroup = "CamCast";
local u27 = RaycastParams.new();
u27.FilterType = Enum.RaycastFilterType.Exclude;
u27.CollisionGroup = "CamCast";
local function u31() --[[ Line: 212 ]]
    -- upvalues: u26 (copy), u24 (ref), u25 (ref), u31 (copy)
    u26.FilterDescendantsInstances = u24;
    local l__CurrentCamera__27 = workspace.CurrentCamera;
    local v28 = Vector2.new(l__CurrentCamera__27.ViewportSize.X / 2, l__CurrentCamera__27.ViewportSize.Y / 2);
    local v29 = l__CurrentCamera__27:ViewportPointToRay(v28.X, v28.Y, 1);
    local v30 = workspace:Raycast(v29.Origin, v29.Direction.Unit * 1000, u26);
    if not v30 then
        return v29.Origin + v29.Direction.Unit * 1000;
    end;
    if (l__CurrentCamera__27.CFrame.Position - v30.Position).magnitude >= 0 or not v30.Instance:IsA("BasePart") then
        return v30.Position;
    end;
    table.insert(u24, v30.Instance);
    if v30.Instance.Transparency == 0 then
        v30.Instance.Transparency = 0.7;
        table.insert(u25, v30.Instance);
    end;
    return u31();
end;
local function u37(p32) --[[ Line: 239 ]]
    -- upvalues: u4 (ref), u2 (copy), u27 (copy)
    local l__Position__28 = p32.Position;
    local v33 = p32.CFrame.LookVector * 1000;
    local v34 = {
        u4,
        workspace.CosmeticShellsFolder,
        u2,
        workspace.Flares
    };
    for _, v35 in u4:GetDescendants() do
        if v35:IsA("Seat") then
            local l__Occupant__29 = v35.Occupant;
            if l__Occupant__29 then
                table.insert(v34, l__Occupant__29.Parent);
            end;
        end;
    end;
    u27.FilterDescendantsInstances = v34;
    local v36 = workspace:Raycast(l__Position__28, v33, u27);
    if v36 and (v36.Instance and v36.Position) then
        u2.Position = v36.Position;
    else
        u2.CFrame = p32.CFrame * CFrame.new(0, 0, -1000);
    end;
end;
l__Humanoid__8.Seated:Connect(function() --[[ Name: onSeated, Line 270 ]]
    -- upvalues: l__Humanoid__8 (copy), l__VehicleModule__12 (copy), u23 (copy), l__StatusUI__21 (copy), l__RightHeliFrame__5 (copy), u8 (ref), u10 (ref), l__HeliGuiModule__20 (copy), l__ToolbarHandler__23 (copy), l__Reload__15 (copy), u9 (ref), u4 (ref), l__Character__7 (copy), l__HeatseekModule__13 (copy), l__ShootModule__11 (copy), l__LocalPlayer__3 (copy), l__Events__17 (copy), l__Hitmarker__18 (copy), l__UserInputService__1 (copy), l__CurrentCamera__24 (copy), l__StarterPlayer__6 (copy), u2 (copy), u24 (ref), u25 (ref), u31 (copy), l__UnreliableHeliEvent__14 (copy), u37 (copy), u11 (copy), u1 (copy), u7 (copy), l__RunService__2 (copy)
    if l__Humanoid__8.SeatPart then
        local u38, v39 = l__VehicleModule__12.checkAndGetHeliSeatType(l__Humanoid__8.SeatPart);
        if u38 then
            u23(u38, v39);
            l__StatusUI__21.MainFrame.Gun.Visible = false;
            l__RightHeliFrame__5.Buttons.ReloadVehicle.Visible = u8 ~= nil;
            if u8 then
                if #u8 == 0 then
                else
                    local u40 = u8[u10];
                    l__StatusUI__21.MainFrame.Gun.Visible = true;
                    local u41 = false;
                    local function u43() --[[ Line: 294 ]]
                        -- upvalues: u40 (ref), l__HeliGuiModule__20 (ref), l__ToolbarHandler__23 (ref), l__Reload__15 (ref)
                        u40.IsReloading = true;
                        u40.LastReloadStarted = os.clock();
                        l__HeliGuiModule__20.reload(u40.ReloadTime);
                        l__ToolbarHandler__23.StartReload(u40.Name, u40.ReloadTime);
                        local u42 = u40;
                        coroutine.wrap(function() --[[ Line: 300 ]]
                            -- upvalues: u42 (copy), l__Reload__15 (ref), l__ToolbarHandler__23 (ref)
                            task.wait(math.max(u42.ReloadTime - l__Reload__15.TimeLength), 0);
                            l__Reload__15:Play();
                            task.wait(l__Reload__15.TimeLength);
                            u42.Ammo = u42.AmmoFull;
                            l__ToolbarHandler__23.UpdateAmmo(u42.Name, u42.Ammo);
                            u42.IsReloading = false;
                        end)();
                    end;
                    local function u52() --[[ Line: 311 ]]
                        -- upvalues: u40 (ref), u9 (ref), u10 (ref), u4 (ref), l__Character__7 (ref), l__HeatseekModule__13 (ref), l__ShootModule__11 (ref), l__LocalPlayer__3 (ref), l__Events__17 (ref), l__Hitmarker__18 (ref), l__ToolbarHandler__23 (ref), u43 (copy)
                        if u40.ShotCooldown then
                        elseif u40.IsReloading then
                        elseif u40.Ammo < 1 then
                        else
                            if u9[u10] then
                                local v44 = {
                                    weaponName = u40.Name,
                                    vehicleName = u4.Name,
                                    shellType = u40.ShellType or "Bullet",
                                    shellName = u40.ShellName,
                                    shellSpeed = u40.MuzzleVelocity,
                                    shellMaxDist = u40.ShellMaxDist or 7000,
                                    specialType = u40.SpecialType,
                                    filterDescendants = { l__Character__7, u4 }
                                };
                                local v45 = u9[u10];
                                local l__HardpointData__30 = u40.HardpointData;
                                if l__HardpointData__30.Mode == "Sequential" then
                                    local l__Parts__31 = v45.Parts;
                                    local l__HardpointIndexToUse__32 = u40.HardpointIndexToUse;
                                    local v46 = #l__Parts__31 < l__HardpointIndexToUse__32 and 1 or l__HardpointIndexToUse__32;
                                    local v47 = l__Parts__31[v46];
                                    if u40.SpecialType == "Heatseeker" then
                                        local v48 = l__HeatseekModule__13.getLockedTarget();
                                        if not v48 then
                                            return;
                                        end;
                                        v44.lockedTarget = v48;
                                        v44.moverType = "Stinger";
                                        l__HeatseekModule__13.tellTargetAboutIncomingProjectile();
                                    end;
                                    l__ShootModule__11.fire(l__LocalPlayer__3, v47.Position, -v47.CFrame.LookVector, v44);
                                    l__Events__17.ServerBullet:FireServer(v47.Position, -v47.CFrame.LookVector, v44);
                                    local v49 = v47:FindFirstChild("Fire");
                                    if v49 then
                                        v49.PlayOnRemove = true;
                                        v49.Parent = nil;
                                        v49.Parent = v47;
                                    end;
                                    l__Hitmarker__18.heliRocketShot(l__LocalPlayer__3, v47.Name, u9[u10].Folder);
                                    l__Events__17.HeliRocketFireFX:FireServer(v47.Name, u9[u10].Folder);
                                    u40.HardpointIndexToUse = v46 + 1;
                                else
                                    local _ = l__HardpointData__30.Mode == "Simultaneous";
                                end;
                            end;
                            u40.ShotCooldown = true;
                            local v50 = u40;
                            v50.Ammo = v50.Ammo - 1;
                            l__ToolbarHandler__23.UpdateAmmo(u40.Name, u40.Ammo);
                            local u51 = u40;
                            task.delay(60 / u51.ShootRate, function() --[[ Line: 375 ]]
                                -- upvalues: u51 (copy)
                                u51.ShotCooldown = false;
                            end);
                            if u40.Ammo < 1 then
                                u43();
                            end;
                        end;
                    end;
                    local function v54(_, p53, _) --[[ Line: 384 ]]
                        -- upvalues: u41 (ref), u40 (ref), u52 (copy)
                        if p53 == Enum.UserInputState.End then
                            u41 = false;
                        elseif p53 == Enum.UserInputState.Begin then
                            if u40.FireMode == "Auto" then
                                u41 = true;
                            end;
                            u52();
                        end;
                    end;
                    local function v56(_, p55, _) --[[ Line: 399 ]]
                        -- upvalues: l__UserInputService__1 (ref), u41 (ref), u40 (ref), u52 (copy)
                        if l__UserInputService__1:GetLastInputType() == Enum.UserInputType.Gamepad1 then
                        elseif p55 == Enum.UserInputState.End then
                            u41 = false;
                        elseif p55 == Enum.UserInputState.Begin then
                            if u40.FireMode == "Auto" then
                                u41 = true;
                            end;
                            u52();
                        end;
                    end;
                    local u57 = false;
                    local function u70(_) --[[ Line: 406 ]]
                        -- upvalues: u40 (ref), u57 (ref), l__CurrentCamera__24 (ref), l__Humanoid__8 (ref), l__LocalPlayer__3 (ref), l__StarterPlayer__6 (ref), u2 (ref), u38 (copy), l__UserInputService__1 (ref), u24 (ref), u4 (ref), u25 (ref), u31 (ref), u9 (ref), u10 (ref), l__UnreliableHeliEvent__14 (ref), u37 (ref)
                        if u40.CameraPart or not u57 then
                            if u40.CameraPart then
                                local v58 = u38.Required[u40.CameraPart];
                                l__CurrentCamera__24.CameraType = Enum.CameraType.Custom;
                                l__CurrentCamera__24.CameraSubject = v58;
                                l__CurrentCamera__24.FieldOfView = u40.FOV;
                                u57 = true;
                                if u40.Turret then
                                    l__UserInputService__1.MouseBehavior = Enum.MouseBehavior.LockCenter;
                                    l__UserInputService__1.MouseIconEnabled = false;
                                    if u40.Turret.FirstPerson then
                                        l__LocalPlayer__3.CameraMinZoomDistance = 0;
                                        l__LocalPlayer__3.CameraMaxZoomDistance = 0;
                                    end;
                                    local _ = l__CurrentCamera__24.CFrame * CFrame.new(0, 0, -1000);
                                    u24 = { u4 };
                                    u25 = {};
                                    local v59 = u31();
                                    local l__Folder__33 = u9[u10].Folder;
                                    local _ = l__Folder__33.Root;
                                    local l__Motor6D__34 = l__Folder__33.BarrelConnector.Motor6D;
                                    local l__CFrame__35 = l__Folder__33.Root.CFrame;
                                    local v60 = l__CFrame__35:VectorToObjectSpace(v59 - l__CFrame__35.Position);
                                    local v61 = math.atan2(v60.X, v60.Z);
                                    local v62 = math.deg(v61) - 180;
                                    local l__CFrame__36 = l__Folder__33.Root.CFrame;
                                    local v63 = l__CFrame__36:VectorToObjectSpace(v59 - l__CFrame__36.Position);
                                    local l__Y__37 = v63.Y;
                                    local l__X__38 = v63.X;
                                    local l__Z__39 = v63.Z;
                                    local v64 = math.sqrt(l__X__38 * l__X__38 + l__Z__39 * l__Z__39);
                                    local v65 = math.atan2(l__Y__37, v64);
                                    local v66 = math.deg(v65);
                                    local v67 = v62 >= -180 and math.max(v62, -90) or math.min(v62, -270);
                                    local v68 = math.clamp(v66, -40, 15);
                                    l__Motor6D__34.C0 = CFrame.new() * CFrame.Angles(-math.rad(v68), -math.rad(v67), 0);
                                    l__UnreliableHeliEvent__14:FireServer(u4, "turretAngle", v67, v68);
                                    u2.Parent = workspace;
                                    u2.Aim.Enabled = true;
                                    u37(l__Folder__33.FollowPart);
                                    local v69 = l__Folder__33:FindFirstChild("BarrelConnectorX");
                                    if v69 then
                                        v69.Motor6D.C0 = CFrame.new() * CFrame.Angles(0, -math.rad(v67), 0);
                                    end;
                                end;
                            end;
                        else
                            l__CurrentCamera__24.CameraType = Enum.CameraType.Custom;
                            l__CurrentCamera__24.CameraSubject = l__Humanoid__8;
                            u57 = false;
                            l__CurrentCamera__24.FieldOfView = 70;
                            l__LocalPlayer__3.CameraMinZoomDistance = l__StarterPlayer__6.CameraMinZoomDistance;
                            l__LocalPlayer__3.CameraMaxZoomDistance = l__StarterPlayer__6.CameraMaxZoomDistance;
                            u2.Aim.Enabled = false;
                            u2.Parent = script;
                        end;
                    end;
                    local function u78(p71) --[[ Line: 481 ]]
                        -- upvalues: l__HeatseekModule__13 (ref), u41 (ref), u8 (ref), u10 (ref), u40 (ref), u11 (ref), l__HeliGuiModule__20 (ref), u70 (copy)
                        l__HeatseekModule__13.adsStopped();
                        u41 = false;
                        local v72 = nil;
                        for v73, v74 in u8 do
                            if v74.Name == p71 then
                                v72 = v73;
                                break;
                            end;
                        end;
                        u10 = v72;
                        u40 = u8[u10];
                        for _, v75 in u11 do
                            v75:Disconnect();
                        end;
                        l__HeliGuiModule__20.switchGun(u8[u10].Name);
                        u70(1);
                        local v76 = u40;
                        if v76.IsReloading and v76.LastReloadStarted then
                            local v77 = v76.LastReloadStarted + v76.ReloadTime - os.clock();
                            l__HeliGuiModule__20.reload(v76.ReloadTime, v76.ReloadTime - v77);
                        end;
                    end;
                    local u79 = {};
                    local function v81(_, p80) --[[ Line: 519 ]]
                        -- upvalues: u40 (ref), u43 (copy)
                        if p80 == Enum.UserInputState.Begin then
                            if u40.IsReloading then
                            elseif u40.Ammo == u40.AmmoFull then
                            else
                                u43();
                            end;
                        end;
                    end;
                    if u8 then
                        for _, u82 in u8 do
                            l__ToolbarHandler__23.AddVehicleWeapon(u82.Name, u82.Ammo, u82.AmmoFull, function() --[[ Line: 528 ]]
                                -- upvalues: u78 (copy), u82 (copy)
                                u78(u82.Name);
                            end);
                        end;
                        u1:BindAction("FireHeliWeapon", v54, false, Enum.KeyCode.ButtonR1);
                        u1:BindAction("FireHeliWeaponPC", v56, false, Enum.UserInputType.MouseButton1);
                        u1:BindAction("ReloadHeliWeapon", v81, false, Enum.KeyCode.R, Enum.KeyCode.ButtonX);
                        u7(u79, l__RightHeliFrame__5.Buttons.Shoot.InputBegan:Connect(function() --[[ Line: 538 ]]
                            -- upvalues: u41 (ref), u40 (ref), u52 (copy)
                            local l__Begin__40 = Enum.UserInputState.Begin;
                            if l__Begin__40 == Enum.UserInputState.End then
                                u41 = false;
                            elseif l__Begin__40 == Enum.UserInputState.Begin then
                                if u40.FireMode == "Auto" then
                                    u41 = true;
                                end;
                                u52();
                            end;
                        end), l__RightHeliFrame__5.Buttons.Shoot.InputEnded:Connect(function() --[[ Line: 542 ]]
                            -- upvalues: u41 (ref), u40 (ref), u52 (copy)
                            local l__End__41 = Enum.UserInputState.End;
                            if l__End__41 == Enum.UserInputState.End then
                                u41 = false;
                            elseif l__End__41 == Enum.UserInputState.Begin then
                                if u40.FireMode == "Auto" then
                                    u41 = true;
                                end;
                                u52();
                            end;
                        end), l__RightHeliFrame__5.Buttons.ReloadVehicle.InputBegan:Connect(function() --[[ Line: 546 ]]
                            -- upvalues: u40 (ref), u43 (copy)
                            if Enum.UserInputState.Begin == Enum.UserInputState.Begin then
                                if u40.IsReloading then
                                elseif u40.Ammo == u40.AmmoFull then
                                else
                                    u43();
                                end;
                            end;
                        end));
                    end;
                    local u83 = nil;
                    u83 = l__RunService__2.RenderStepped:Connect(function(p84) --[[ Line: 553 ]]
                        -- upvalues: l__Humanoid__8 (ref), u1 (ref), u83 (ref), l__HeatseekModule__13 (ref), l__HeliGuiModule__20 (ref), l__StatusUI__21 (ref), u79 (ref), l__CurrentCamera__24 (ref), l__LocalPlayer__3 (ref), l__StarterPlayer__6 (ref), l__UserInputService__1 (ref), u2 (ref), u41 (ref), u52 (copy), u40 (ref), u4 (ref), u70 (copy)
                        if l__Humanoid__8.SeatPart then
                            if u41 then
                                u52();
                            end;
                            if u40.SpecialType == "Heatseeker" then
                                if not (l__Humanoid__8 and l__Humanoid__8.SeatPart) then
                                    return;
                                end;
                                local v85 = workspace.CurrentCamera:WorldToScreenPoint((l__Humanoid__8.SeatPart.CFrame * CFrame.new(0, 0, -100)).Position);
                                local v86 = Vector2.new(v85.X, v85.Y);
                                l__HeatseekModule__13.aimTick(u40.PathType or "Air", v86, { u4 });
                            end;
                            u70(p84);
                            l__StatusUI__21.MainFrame.Gun.Ammo.Text = u40.Ammo;
                            l__StatusUI__21.MainFrame.Gun.StoredAmmo.Text = u40.AmmoFull;
                        else
                            u1:UnbindAction("FireHeliWeapon");
                            u1:UnbindAction("FireHeliWeaponPC");
                            u1:UnbindAction("SwitchHeliWeapon");
                            u1:UnbindAction("ReloadHeliWeapon");
                            u83:Disconnect();
                            l__HeatseekModule__13.adsStopped();
                            l__HeliGuiModule__20.setVisible(false);
                            l__StatusUI__21.MainFrame.Gun.Visible = false;
                            for _, v87 in u79 do
                                v87:Disconnect();
                            end;
                            u79 = nil;
                            l__CurrentCamera__24.FieldOfView = 70;
                            l__LocalPlayer__3.CameraMaxZoomDistance = l__StarterPlayer__6.CameraMaxZoomDistance;
                            l__LocalPlayer__3.CameraMinZoomDistance = l__StarterPlayer__6.CameraMinZoomDistance;
                            l__CurrentCamera__24.CameraType = Enum.CameraType.Custom;
                            l__CurrentCamera__24.CameraSubject = l__Humanoid__8;
                            l__UserInputService__1.MouseBehavior = Enum.MouseBehavior.Default;
                            l__UserInputService__1.MouseIconEnabled = true;
                            u2.Aim.Enabled = false;
                            u2.Parent = script;
                        end;
                    end);
                    l__HeliGuiModule__20.setVisible(true);
                    u70(1);
                end;
            end;
        end;
    end;
end);
local u92 = {
    turretAngle = function(p88, p89) --[[ Name: turretAngle, Line 605 ]]
        -- upvalues: u4 (ref)
        local l__Turret__42 = u4.Weaponry.Turret;
        local _ = l__Turret__42.Root;
        local v90 = l__Turret__42:FindFirstChild("BarrelConnector");
        if v90 then
            v90:FindFirstChild("Motor6D").C0 = CFrame.new() * CFrame.Angles(-math.rad(p89), -math.rad(p88), 0);
            local v91 = l__Turret__42:FindFirstChild("BarrelConnectorX");
            if v91 then
                v91:FindFirstChild("Motor6D").C0 = CFrame.new() * CFrame.Angles(0, -math.rad(p88), 0);
            end;
        end;
    end
};
l__UnreliableHeliEvent__14.OnClientEvent:Connect(function(p93, ...) --[[ Line: 624 ]]
    -- upvalues: u4 (ref), u92 (copy)
    if u4 then
        if u92[p93] then
            u92[p93](unpack({ ... }));
        end;
    end;
end);
script:WaitForChild("GetActiveWeaponData").OnInvoke = function() --[[ Line: 632 ]]
    -- upvalues: u4 (ref), u8 (ref), u10 (ref)
    if u4 then
        if u8 then
            if #u8 == 0 then
            elseif u10 then
                if u8[u10] then
                    return u8[u10];
                end;
            end;
        end;
    end;
end;