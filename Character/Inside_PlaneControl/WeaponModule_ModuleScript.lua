-- Roblox: Workspace.SilverAce293026.PlaneControl.WeaponModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__ContextActionService__1 = game:GetService("ContextActionService");
local l__RunService__2 = game:GetService("RunService");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__AimTrail__4 = script:WaitForChild("AimTrail");
local l__CustomMobileGui__5 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CustomMobileGui");
l__CustomMobileGui__5:WaitForChild("RightHeliFrame");
l__CustomMobileGui__5:WaitForChild("LeftHeliFrame");
local l__Modules__6 = l__ReplicatedStorage__3:WaitForChild("Modules");
local l__ShootModule__7 = require(l__Modules__6:WaitForChild("Projectile"):WaitForChild("ShootModule"));
require(l__Modules__6:WaitForChild("VehicleModule"));
local l__HeatseekModule__8 = require(l__Modules__6:WaitForChild("HeatseekModule"));
local l__FlaresSettings__9 = require(l__Modules__6:WaitForChild("FlaresSettings"));
local l__ACS_Engine__10 = l__ReplicatedStorage__3:WaitForChild("ACS_Engine");
local l__Events__11 = l__ACS_Engine__10:WaitForChild("Events");
require(l__ACS_Engine__10:WaitForChild("Modules"):WaitForChild("Hitmarker"));
local l__BombSight__12 = script:WaitForChild("BombSight");
local l__Players__13 = game.Players;
local l__LocalPlayer__14 = l__Players__13.LocalPlayer;
local u2 = l__LocalPlayer__14.Character or l__LocalPlayer__14.CharacterAdded:Wait();
local l__PlayerGui__15 = l__LocalPlayer__14.PlayerGui;
local l__ToolbarHandler__16 = require(l__PlayerGui__15:WaitForChild("VehicleToolbar"):WaitForChild("ToolbarHandler"));
local l__UIModule__17 = require(script.Parent.UIModule);
local l__InputModule__18 = require(script.Parent:WaitForChild("InputModule"));
local l__PlaneControls__19 = l__PlayerGui__15:WaitForChild("PlaneControls");
local l__PlaneGuiModule__20 = require(l__PlaneControls__19:WaitForChild("PlaneGuiModule"));
local l__Radar__21 = l__PlayerGui__15:WaitForChild("Radar");
local l__RadarHandler__22 = require(l__Radar__21:WaitForChild("RadarHandler"));
local u3 = {};
function u1.SetPlane(u4) --[[ Line: 46 ]]
    -- upvalues: u1 (copy), l__RadarHandler__22 (copy), l__ToolbarHandler__16 (copy), l__UIModule__17 (copy), l__PlaneGuiModule__20 (copy), l__BombSight__12 (copy), l__HeatseekModule__8 (copy), l__RunService__2 (copy), u3 (ref), l__AimTrail__4 (copy), u2 (copy), l__LocalPlayer__14 (copy), l__ShootModule__7 (copy), l__Events__11 (copy), l__ContextActionService__1 (copy), l__InputModule__18 (copy), l__FlaresSettings__9 (copy), l__Players__13 (copy)
    u1.Plane = u4;
    l__RadarHandler__22.Show();
    u1.Weapons = {};
    local l__Params__23 = u4:WaitForChild("Params");
    if l__Params__23:FindFirstChild("Config") then
        u1.Weapons = require(l__Params__23.Config);
    end;
    local u5 = nil;
    local u6 = false;
    for _, u7 in u1.Weapons.Weapons do
        u7.LastShotTs = 0;
        if not u7.MaxAmmo then
            u7.MaxAmmo = u7.Ammo;
        end;
        l__ToolbarHandler__16.AddVehicleWeapon(u7.Name, u7.Ammo, u7.MaxAmmo, function() --[[ Line: 66 ]]
            -- upvalues: l__UIModule__17 (ref), u7 (copy), l__PlaneGuiModule__20 (ref), u5 (ref), l__BombSight__12 (ref), l__HeatseekModule__8 (ref)
            l__UIModule__17.aimUdim = u7.AimSize or UDim2.new(0.029, 0, 0.029, 0);
            l__UIModule__17.SetWeapon(u7.Abbreviation);
            l__PlaneGuiModule__20.switchGun(u7.Name);
            u5 = u7;
            if u5.SpecialType ~= "Bomb" then
                l__BombSight__12.Parent = script;
            end;
            if u5.IsReloading then
                local v8 = u5.StartedReloading + u5.ReloadTime - os.clock();
                l__PlaneGuiModule__20.reload(u5.ReloadTime, u5.ReloadTime - v8);
            end;
            l__HeatseekModule__8.adsStopped();
        end);
    end;
    local v12 = l__RunService__2.RenderStepped:Connect(function(_) --[[ Line: 86 ]]
        -- upvalues: u5 (ref), u4 (copy), l__HeatseekModule__8 (ref), u1 (ref)
        if u5 then
            if u5.SpecialType == "Heatseeker" then
                local l__pathType__24 = u5.pathType;
                local v9, v10 = workspace.CurrentCamera:WorldToScreenPoint((u4.PrimaryPart.CFrame * CFrame.new(0, 0, -500)).Position);
                if not v10 then
                    return;
                end;
                local v11 = { u4 };
                l__HeatseekModule__8.aimTick(l__pathType__24, Vector2.new(v9.X, v9.Y), v11, u5.Name, u1.Plane:GetAttribute("AimDist") or 2500, false, 400);
            end;
        end;
    end);
    table.insert(u3, v12);
    local v23 = l__RunService__2.RenderStepped:Connect(function(_) --[[ Line: 110 ]]
        -- upvalues: u5 (ref), u4 (copy), l__HeatseekModule__8 (ref), u1 (ref), l__AimTrail__4 (ref), l__BombSight__12 (ref), u2 (ref)
        if u5 then
            if u5.PredictFire then
                local v13 = workspace.CurrentCamera:WorldToScreenPoint((u4.PrimaryPart.CFrame * CFrame.new(0, 0, -100)).Position);
                local v14 = { u4 };
                local v15 = l__HeatseekModule__8.aimTick("Air", Vector2.new(v13.X, v13.Y), v14, u5.Name, u1.Plane:GetAttribute("AimDist") or 2500, true);
                if v15 then
                    l__AimTrail__4.BillboardGui.Enabled = true;
                    l__AimTrail__4.Parent = workspace;
                    local v16 = u4.Hardpoints[u5.HardpointData.Name];
                    if v16:IsA("Folder") then
                        v16 = u4.PrimaryPart;
                    end;
                    local v17 = v15:FindFirstAncestorOfClass("Model");
                    local l__Position__25 = v16.Position;
                    local l__CFrame__26 = v17.PrimaryPart.CFrame;
                    local l__AssemblyLinearVelocity__27 = v17.PrimaryPart.AssemblyLinearVelocity;
                    local l__MuzzleVelocity__28 = u5.MuzzleVelocity;
                    local l__Z__29 = l__CFrame__26:VectorToObjectSpace(l__AssemblyLinearVelocity__27).Z;
                    local v18 = (l__CFrame__26.Position - l__Position__25).Magnitude / l__MuzzleVelocity__28;
                    for _ = 1, 3 do
                        v18 = ((l__CFrame__26 * CFrame.new(0, 0, l__Z__29 * v18)).Position - l__Position__25).Magnitude / l__MuzzleVelocity__28;
                    end;
                    l__AimTrail__4.CFrame = l__CFrame__26 * CFrame.new(0, 0, l__Z__29 * v18);
                else
                    l__AimTrail__4.Parent = script;
                    l__AimTrail__4.BillboardGui.Enabled = false;
                end;
            elseif u5.SpecialType == "Bomb" then
                l__BombSight__12.Parent = workspace;
                l__BombSight__12.SurfaceGui.Enabled = true;
                local v19 = RaycastParams.new();
                v19.FilterType = Enum.RaycastFilterType.Exclude;
                v19.FilterDescendantsInstances = { u4, u2, l__BombSight__12 };
                v19.CollisionGroup = "CamCast";
                v19.IgnoreWater = false;
                local l__Position__30 = (u4.PrimaryPart.CFrame * CFrame.new(0, 0, -u4.PrimaryPart.AssemblyLinearVelocity.Magnitude * 2.5)).Position;
                local v20 = Vector3.new(l__Position__30.X, u4.PrimaryPart.Position.Y, l__Position__30.Z);
                local v21 = workspace:Raycast(v20, Vector3.new(0, -2048, 0), v19);
                if v21 and v21.Instance then
                    local v22 = workspace:Raycast(u4.PrimaryPart.CFrame.Position, (v21.Position - u4.PrimaryPart.Position).Unit * 2048, v19);
                    if v22 and v22.Instance then
                        l__BombSight__12.CFrame = CFrame.new(v22.Position);
                    else
                        l__BombSight__12.CFrame = CFrame.new(v21.Position);
                    end;
                else
                    l__BombSight__12.CFrame = CFrame.new(0, 5000, 0);
                end;
            else
                l__BombSight__12.Parent = script;
                l__BombSight__12.SurfaceGui.Enabled = false;
                l__AimTrail__4.Parent = script;
                l__AimTrail__4.BillboardGui.Enabled = false;
            end;
        end;
    end);
    table.insert(u3, v23);
    local function u26() --[[ Line: 203 ]]
        -- upvalues: u5 (ref), u4 (copy), l__ToolbarHandler__16 (ref), l__PlaneGuiModule__20 (ref)
        if u5.IsReloading then
        elseif u5.Ammo >= u5.MaxAmmo then
        else
            u4.Networking.CannonSound:FireServer(false);
            u5.IsReloading = true;
            u5.StartedReloading = os.clock();
            local u24 = u5;
            l__ToolbarHandler__16.StartReload(u5.Name, u5.ReloadTime);
            l__PlaneGuiModule__20.reload(u5.ReloadTime);
            task.delay(u5.ReloadTime, function() --[[ Line: 212 ]]
                -- upvalues: u24 (copy), l__ToolbarHandler__16 (ref), u4 (ref)
                u24.Ammo = u24.MaxAmmo;
                u24.IsReloading = false;
                l__ToolbarHandler__16.UpdateAmmo(u24.Name, u24.Ammo);
                if u24.HardpointData.Cosmetic then
                    for _, v25 in u4.Hardpoints[u24.HardpointData.Name]:GetChildren() do
                        if v25.Name:find("Cosmetic") then
                            v25.Transparency = 0;
                        end;
                    end;
                end;
            end);
        end;
    end;
    local v43 = l__RunService__2.Heartbeat:Connect(function(_) --[[ Line: 227 ]]
        -- upvalues: u6 (ref), u5 (ref), u26 (copy), u4 (copy), l__HeatseekModule__8 (ref), l__LocalPlayer__14 (ref), u2 (ref), l__BombSight__12 (ref), l__ShootModule__7 (ref), l__Events__11 (ref), l__ToolbarHandler__16 (ref)
        if not u6 then
            return;
        end;
        if u5.IsReloading then
            return;
        end;
        if u5.Ammo <= 0 then
            u26();
            return;
        end;
        u4.Networking.CannonSound:FireServer(u5.CannonSound);
        local _ = u5.LastShotTs;
        if os.clock() < u5.LastShotTs + 60 / u5.ShootRate then
            return;
        end;
        if u5.SpecialType == "Heatseeker" and not l__HeatseekModule__8.getLockedTarget() then
            return;
        end;
        local u27 = {
            weaponName = u5.Name,
            vehicleName = u4.Name,
            shellType = u5.ShellType or "Bullet",
            shellName = u5.ShellName,
            shellSpeed = u5.MuzzleVelocity,
            shellMaxDist = u5.ShellMaxDist or 7000,
            filterDescendants = { l__LocalPlayer__14.Character, u4 }
        };
        local u28 = {};
        if u5.SpecialType == "Heatseeker" then
            u27.moverType = u5.pathType;
            u27.specialType = u5.SpecialType;
            u27.lockedTarget = l__HeatseekModule__8.getLockedTarget();
        end;
        u27.shellGravity = u5.ShellGravity;
        local u29 = u4.Hardpoints[u5.HardpointData.Name];
        local function v38(p30) --[[ Line: 263 ]]
            -- upvalues: u27 (copy), u29 (ref), u5 (ref), l__HeatseekModule__8 (ref), u4 (ref), u2 (ref), l__BombSight__12 (ref), u28 (copy), l__ShootModule__7 (ref), l__LocalPlayer__14 (ref), l__Events__11 (ref), l__ToolbarHandler__16 (ref)
            u27.origin = u29.Position;
            if u5.SpecialType == "Heatseeker" then
                local v31 = l__HeatseekModule__8.getLockedTarget();
                if not v31 then
                    return;
                end;
                u27.lockedTarget = v31;
                u27.moverType = "Stinger";
                u27.shellSpeed = 575;
                l__HeatseekModule__8.tellTargetAboutIncomingProjectile();
            elseif u5.SpecialType == "Bomb" then
                u27.moverType = "Bomb";
                u27.shellSpeed = u4.PrimaryPart.AssemblyLinearVelocity.Magnitude;
                u27.endPosition = Vector3.new();
                local v32 = RaycastParams.new();
                v32.FilterType = Enum.RaycastFilterType.Exclude;
                v32.FilterDescendantsInstances = { u4, u2, l__BombSight__12 };
                v32.CollisionGroup = "CamCast";
                v32.IgnoreWater = false;
                local l__Position__31 = (u4.PrimaryPart.CFrame * CFrame.new(0, 0, -u4.PrimaryPart.AssemblyLinearVelocity.Magnitude * 2.5)).Position;
                local v33 = Vector3.new(l__Position__31.X, u4.PrimaryPart.Position.Y, l__Position__31.Z);
                local v34 = workspace:Raycast(v33, Vector3.new(0, -2048, 0), v32);
                if not (v34 and v34.Instance) then
                    return;
                end;
                u28.endPosition = v34.Position;
            end;
            local l__LookVector__32 = u29.CFrame.LookVector;
            if p30 then
                l__LookVector__32 = -l__LookVector__32;
            end;
            if u5.FireCentral then
                local v35 = RaycastParams.new();
                v35.FilterType = Enum.RaycastFilterType.Exclude;
                v35.FilterDescendantsInstances = { u4, u2, l__BombSight__12 };
                v35.CollisionGroup = "CamCast";
                v35.IgnoreWater = false;
                local v36 = workspace:Raycast(u4.PrimaryPart.Position, u4.PrimaryPart.CFrame.LookVector.Unit * 2048, v35);
                if v36 and v36.Instance then
                    l__LookVector__32 = (v36.Position - u29.Position).Unit;
                end;
            end;
            l__ShootModule__7.fire(l__LocalPlayer__14, u29.Position, l__LookVector__32, u27, u28);
            l__Events__11.ServerBullet:FireServer(u29.Position, l__LookVector__32, u27, u28);
            u5.LastShotTs = os.clock();
            local v37 = u5;
            v37.Ammo = v37.Ammo - 1;
            l__ToolbarHandler__16.UpdateAmmo(u5.Name, u5.Ammo);
        end;
        if u29:IsA("Folder") then
            if u5.HardpointData.Cosmetic then
                local v39 = u29:GetChildren();
                local v40 = u29:GetAttribute("FlipLookVec");
                for _, v41 in v39 do
                    if v41.Name:find("Cosmetic") and v41.Transparency ~= 1 then
                        v41.Transparency = 1;
                        u29 = v41;
                        v38(v40);
                        break;
                    end;
                end;
            else
                for _, v42 in u29:GetChildren() do
                    u29 = v42;
                    v38();
                end;
            end;
        else
            v38();
        end;
    end);
    table.insert(u3, v43);
    l__ContextActionService__1:BindActionAtPriority("PlaneFire", function(_, p44) --[[ Name: shoot, Line 355 ]]
        -- upvalues: u6 (ref), u4 (copy)
        if p44 == Enum.UserInputState.Begin then
            u6 = true;
        else
            if p44 == Enum.UserInputState.End then
                u6 = false;
                u4.Networking.CannonSound:FireServer(false);
            end;
        end;
    end, true, 1000000, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR1);
    l__ContextActionService__1:BindActionAtPriority("PlaneReload", function(_, p45) --[[ Line: 365 ]]
        -- upvalues: u26 (copy)
        if p45 == Enum.UserInputState.End then
            u26();
        end;
    end, true, 1000000, Enum.KeyCode.R, Enum.KeyCode.ButtonX);
    l__ContextActionService__1:SetPosition("PlaneFire", UDim2.new(1, -105, 0.05, -35));
    l__ContextActionService__1:SetImage("PlaneFire", "https://www.roblox.com/asset/?id=444744114");
    l__ContextActionService__1:SetPosition("PlaneReload", UDim2.new(1, -105, 0.35, -35));
    l__ContextActionService__1:SetImage("PlaneReload", "rbxassetid://16231259267");
    u1.flaresLastDeployed = 0;
    l__UIModule__17.flaresLastDeployed = 0;
    local l__Networking__33 = u1.Plane.Networking;
    local l__RocketEvent__34 = l__Networking__33.RocketEvent;
    local l__FlareEvent__35 = l__Networking__33.FlareEvent;
    local v46 = l__InputModule__18.GetBoundScheme("Plane");
    l__ContextActionService__1:BindAction("PlaneFlares", function(_, p47) --[[ Line: 393 ]]
        -- upvalues: u1 (ref), l__FlaresSettings__9 (ref), l__UIModule__17 (ref), l__FlareEvent__35 (copy)
        if p47 == Enum.UserInputState.End then
            if os.time() - u1.flaresLastDeployed < l__FlaresSettings__9.Cooldown + 1 then
            else
                u1.flaresLastDeployed = os.time();
                l__UIModule__17.flaresLastDeployed = os.time();
                l__FlareEvent__35:FireServer();
            end;
        end;
    end, true);
    l__ContextActionService__1:SetPosition("PlaneFlares", UDim2.new(1, -45, 0.125, -35));
    l__ContextActionService__1:SetImage("PlaneFlares", "https://www.roblox.com/asset/?id=15049808173");
    v46:SubscribeToControl("Flares", function(p48, _) --[[ Line: 400 ]]
        -- upvalues: u1 (ref), l__FlaresSettings__9 (ref), l__UIModule__17 (ref), l__FlareEvent__35 (copy)
        if p48.Pressed then
            if os.time() - u1.flaresLastDeployed < l__FlaresSettings__9.Cooldown + 1 then
                return;
            end;
            u1.flaresLastDeployed = os.time();
            l__UIModule__17.flaresLastDeployed = os.time();
            l__FlareEvent__35:FireServer();
        end;
    end);
    local l__LockonGui__36 = l__Players__13.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("LockonGui");
    local u49 = {
        Locking = 0,
        IncomingProjectile = 0
    };
    local function u53(p50, p51) --[[ Line: 413 ]]
        -- upvalues: u53 (copy), l__LockonGui__36 (copy)
        local v52 = p50 == "Locking" and script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing and p50 == "Locking" then
        else
            if p50 == "IncomingProjectile" and p51 == true then
                u53("Locking", false);
            end;
            l__LockonGui__36[p50].Visible = p51;
            if p51 then
                if v52.Playing then
                else
                    v52:Play();
                end;
            else
                v52:Stop();
            end;
        end;
    end;
    l__RunService__2:BindToRenderStep("PlaneRocketAlerts", Enum.RenderPriority.Camera.Value + 1, function(_) --[[ Line: 435 ]]
        -- upvalues: u49 (copy), l__LockonGui__36 (copy)
        for v54, v55 in u49 do
            if os.time() - v55 >= 3 then
                local v56 = v54 == "Locking" and script.Locking or script.IncomingProjectile;
                if not script.IncomingProjectile.Playing or v54 ~= "Locking" then
                    local _ = v54 == "IncomingProjectile";
                    l__LockonGui__36[v54].Visible = false;
                    v56:Stop();
                end;
            end;
        end;
    end);
    local v59 = l__RocketEvent__34.OnClientEvent:Connect(function(p57) --[[ Line: 443 ]]
        -- upvalues: u49 (copy), u53 (copy), l__LockonGui__36 (copy)
        u49[p57] = os.time();
        local v58 = p57 == "Locking" and script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing and p57 == "Locking" then
        else
            if p57 == "IncomingProjectile" then
                u53("Locking", false);
            end;
            l__LockonGui__36[p57].Visible = true;
            if v58.Playing then
            else
                v58:Play();
            end;
        end;
    end);
    table.insert(u3, v59);
    local v61 = u1.Plane:GetAttributeChangedSignal("Flares"):Connect(function() --[[ Line: 449 ]]
        -- upvalues: u1 (ref), l__LockonGui__36 (copy)
        if u1.Plane:GetAttribute("Flares") then
            local l__IncomingProjectile__37 = script.IncomingProjectile;
            local _ = script.IncomingProjectile.Playing;
            l__LockonGui__36.IncomingProjectile.Visible = false;
            l__IncomingProjectile__37:Stop();
            local v60 = script.Locking or script.IncomingProjectile;
            if script.IncomingProjectile.Playing then
                return;
            end;
            l__LockonGui__36.Locking.Visible = false;
            v60:Stop();
        end;
    end);
    table.insert(u3, v61);
    function u1.FlareUnset() --[[ Line: 458 ]]
        -- upvalues: l__LockonGui__36 (copy)
        local l__IncomingProjectile__38 = script.IncomingProjectile;
        local _ = script.IncomingProjectile.Playing;
        l__LockonGui__36.IncomingProjectile.Visible = false;
        l__IncomingProjectile__38:Stop();
        local v62 = script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing then
        else
            l__LockonGui__36.Locking.Visible = false;
            v62:Stop();
        end;
    end;
end;
function u1.UnsetPlane() --[[ Line: 464 ]]
    -- upvalues: u1 (copy), l__BombSight__12 (copy), l__ToolbarHandler__16 (copy), l__RadarHandler__22 (copy), l__AimTrail__4 (copy), u3 (ref), l__ContextActionService__1 (copy), l__RunService__2 (copy)
    u1.Plane = nil;
    l__BombSight__12.Parent = script;
    l__BombSight__12.SurfaceGui.Enabled = false;
    l__ToolbarHandler__16.Clear();
    l__RadarHandler__22.Hide();
    l__AimTrail__4.Parent = script;
    for _, v63 in u3 do
        v63:Disconnect();
    end;
    u3 = {};
    l__ContextActionService__1:UnbindAction("PlaneFire");
    l__ContextActionService__1:UnbindAction("PlaneReload");
    l__ContextActionService__1:UnbindAction("PlaneFlares");
    l__RunService__2:UnbindFromRenderStep("PlaneRocketAlerts");
    u1.FlareUnset();
end;
return u1;