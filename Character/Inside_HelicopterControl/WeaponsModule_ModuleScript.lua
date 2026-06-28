-- Roblox: Workspace.SilverAce293026.HelicopterControl.WeaponsModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__RunService__1 = game:GetService("RunService");
local l__Players__2 = game:GetService("Players");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__GetElevationIntent__4 = script.Parent:WaitForChild("MovementModule"):WaitForChild("GetElevationIntent");
local l__Modules__5 = l__ReplicatedStorage__3:WaitForChild("Modules");
local l__FlaresSettings__6 = require(l__Modules__5:WaitForChild("FlaresSettings"));
local l__InputModule__7 = require(script.Parent:WaitForChild("InputModule"));
local l__LocalPlayer__8 = l__Players__2.LocalPlayer;
local l__PlayerGui__9 = l__LocalPlayer__8:WaitForChild("PlayerGui");
local l__HeliControls__10 = l__PlayerGui__9:WaitForChild("HeliControls");
local l__CustomMobileGui__11 = l__PlayerGui__9:WaitForChild("CustomMobileGui");
l__CustomMobileGui__11:WaitForChild("LeftHeliFrame");
local l__RightHeliFrame__12 = l__CustomMobileGui__11:WaitForChild("RightHeliFrame");
local l__GetActiveWeaponData__13 = l__LocalPlayer__8.Character:WaitForChild("HelicopterWeapons"):WaitForChild("GetActiveWeaponData");
local l__Radar__14 = l__PlayerGui__9:WaitForChild("Radar");
local l__RadarHandler__15 = require(l__Radar__14:WaitForChild("RadarHandler"));
function u1.ReticleLoop() --[[ Line: 36 ]]
    -- upvalues: u1 (copy), l__HeliControls__10 (copy), l__GetElevationIntent__4 (copy), l__FlaresSettings__6 (copy), l__GetActiveWeaponData__13 (copy)
    if u1.helicopterModel then
        if u1.seat then
            local l__CurrentCamera__16 = workspace.CurrentCamera;
            local l__CFrame__17 = u1.seat.CFrame;
            local l__LookVector__18 = l__CFrame__17.LookVector;
            local v2 = l__CFrame__17.Position + l__LookVector__18 * 100;
            local l__X__19 = l__HeliControls__10.Circle.AbsoluteSize.X;
            local l__Altimeter__20 = l__HeliControls__10.Altimeter;
            local _ = l__Altimeter__20.Content;
            local v3 = (Vector3.new(u1.seat.Position.X, -110, u1.seat.Position.Z) - u1.seat.Position).Magnitude / 2.4;
            local v4 = math.floor(v3) .. "m";
            local v5 = #u1.altimeterLines.regular + 1;
            u1.altimeterLines.middle.Position = UDim2.new(1, 0, 0.5, 0);
            local l__Y__21 = u1.seat.AssemblyLinearVelocity.Y;
            local v6 = math.abs(l__Y__21) / 40;
            local v7 = math.clamp(v6, -0.5, 0.5);
            if l__Y__21 < 0 then
                v7 = -v7 or v7;
            end;
            l__Altimeter__20.Pointer.Position = UDim2.new(1.2, 0, -(v7 - 0.5), 0);
            l__Altimeter__20.Pointer.Text = "< " .. math.floor(u1.helicopterModel.PrimaryPart.AssemblyLinearVelocity.Y / 2.4) .. "m/s";
            local v8 = math.floor((v5 - 1) / 2);
            local v9 = math.floor(v5 - 1 - v8);
            for v10 = 1, v8 do
                local v11 = u1.altimeterLines.regular[v10];
                local v12 = 0.5 - v10 * 0.035;
                if v12 < 0 then
                    v12 = v12 + 1;
                end;
                v11.Position = UDim2.new(1, 0, v12, 0);
            end;
            for v13 = 1, v9 do
                local v14 = u1.altimeterLines.regular[v13 + v9];
                local v15 = v13 * 0.035 + 0.5;
                if v15 > 1 then
                    v15 = v15 - 1;
                end;
                v14.Position = UDim2.new(1, 0, v15, 0);
            end;
            l__Altimeter__20.Value.Text = v4;
            local v16, v17 = l__CurrentCamera__16:WorldToScreenPoint(v2);
            l__HeliControls__10.Left.Visible = v17;
            l__HeliControls__10.Right.Visible = v17;
            local l__X__22 = l__HeliControls__10.Left.AbsoluteSize.X;
            l__HeliControls__10.Left.Position = UDim2.new(0, v16.X - (l__X__19 + l__X__22 / 2), 0, v16.Y);
            l__HeliControls__10.Right.Position = UDim2.new(0, v16.X + (l__X__19 + l__X__22 / 2), 0, v16.Y);
            local v18, v19 = l__CurrentCamera__16:WorldToScreenPoint(l__CFrame__17.Position + l__LookVector__18 * 100);
            l__HeliControls__10.Circle.Visible = v19;
            l__HeliControls__10.Circle.Position = UDim2.new(0, v18.X, 0, v18.Y);
            local l__Stats__23 = l__HeliControls__10.Stats;
            local v20 = {
                elev = l__Stats__23.Elev,
                flares = l__Stats__23.Flares,
                speed = l__Stats__23.Speed,
                weapon = l__Stats__23.Weapon
            };
            local v21 = l__GetElevationIntent__4:Invoke() or 0;
            v20.elev.Value.Text = (v21 == -0 and 0 or v21) .. "%";
            local v22 = os.time() - u1.flaresLastDeployed;
            local v23 = u1.flaresLastDeployed + l__FlaresSettings__6.Cooldown - os.time();
            local v24 = l__FlaresSettings__6.Cooldown + 1 <= v22;
            v20.flares.Value.Text = v24 and "READY" or v23;
            v20.flares.Value.TextColor3 = v24 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 0, 0);
            local v25 = math.ceil(u1.helicopterModel.PrimaryPart.AssemblyLinearVelocity.Magnitude / 2.4);
            v20.speed.Value.Text = v25 .. "m/s";
            if u1.hasWeapons then
                local v26 = l__GetActiveWeaponData__13:Invoke();
                local v27 = v26.Abbreviation or string.upper(v26.Name);
                v20.weapon.Value.Text = v27;
                if v26.HardpointData then
                    local v28 = u1.helicopterModel.Weaponry[v26.HardpointData.Name];
                    local v29 = Vector3.new();
                    local v30 = 0;
                    local v31 = nil;
                    for _, v32 in v28:GetDescendants() do
                        if v32:IsA("BasePart") then
                            v30 = v30 + 1;
                            v29 = v29 + v32.Position;
                            if not v31 then
                                v31 = v32.CFrame.LookVector;
                            end;
                        end;
                    end;
                    local v33 = v29 / v30;
                    l__CFrame__17 = CFrame.new(v33, v33 + v31 * 1);
                end;
                local v34 = workspace:Raycast(l__CFrame__17.Position, l__CFrame__17.LookVector * -1000, u1.castParams);
                if v34 and v34.Instance then
                    local v35, v36 = l__CurrentCamera__16:WorldToScreenPoint(v34.Position);
                    l__HeliControls__10.Surface.Visible = v36;
                    l__HeliControls__10.Surface.Position = UDim2.new(0, v35.X, 0, v35.Y);
                else
                    l__HeliControls__10.Surface.Position = UDim2.new(0, v18.X, 0, v18.Y);
                    l__HeliControls__10.Surface.Visible = v19;
                end;
            else
                l__HeliControls__10.Surface.Visible = false;
                v20.weapon.Value.Text = "NONE";
            end;
        end;
    end;
end;
function u1.SetHeli(u37) --[[ Line: 190 ]]
    -- upvalues: u1 (copy), l__LocalPlayer__8 (copy), l__RadarHandler__15 (copy), l__Players__2 (copy), l__InputModule__7 (copy), l__FlaresSettings__6 (copy), l__RunService__1 (copy), l__RightHeliFrame__12 (copy), l__HeliControls__10 (copy)
    u1.helicopterModel = u37;
    u1.seat = l__LocalPlayer__8.Character.Humanoid.SeatPart;
    u1.hasWeapons = u37:FindFirstChild("Weaponry");
    if u1.hasWeapons then
        u1.hasWeapons = #u1.hasWeapons:GetChildren() > 0;
    end;
    l__RadarHandler__15.Show();
    u1.network = u1.helicopterModel.Networking;
    u1.castParams = RaycastParams.new();
    u1.castParams.FilterType = Enum.RaycastFilterType.Exclude;
    u1.castParams.CollisionGroup = "CamCast";
    u1.castParams.FilterDescendantsInstances = { u37, l__LocalPlayer__8.Character };
    u1.connections = {};
    local function u41() --[[ Line: 210 ]]
        -- upvalues: u37 (copy), l__LocalPlayer__8 (ref), l__Players__2 (ref), u1 (ref)
        local v38 = { u37, l__LocalPlayer__8.Character };
        local v39 = {};
        for _, v40 in l__Players__2:GetChildren() do
            if v40.Character then
                table.insert(v39, v40.Character);
            end;
        end;
        if #v39 >= 1 then
            table.move(v39, 1, #v39, #v38 + 1, v38);
        end;
        u1.castParams.FilterDescendantsInstances = v38;
    end;
    local v43 = l__Players__2.PlayerAdded:Connect(function(p42) --[[ Line: 223 ]]
        -- upvalues: u41 (copy)
        p42.CharacterAdded:Connect(function(_) --[[ Line: 224 ]]
            -- upvalues: u41 (ref)
            u41();
        end);
    end);
    table.insert(u1.connections, v43);
    u41();
    u1.flaresLastDeployed = 0;
    l__InputModule__7.GetBoundScheme("Heli"):SubscribeToControl("Flares", function(p44, _) --[[ Line: 234 ]]
        -- upvalues: u1 (ref), l__FlaresSettings__6 (ref)
        if p44.Pressed then
            if os.time() - u1.flaresLastDeployed < l__FlaresSettings__6.Cooldown + 1 then
                return;
            end;
            u1.flaresLastDeployed = os.time();
            u1.network.FlareEvent:FireServer();
        end;
    end);
    local u45 = {
        Locking = 0,
        IncomingProjectile = 0
    };
    local l__LockonGui__24 = l__Players__2.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("LockonGui");
    local function u49(p46, p47) --[[ Line: 250 ]]
        -- upvalues: u49 (copy), l__LockonGui__24 (copy)
        local v48 = p46 == "Locking" and script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing and p46 == "Locking" then
        else
            if p46 == "IncomingProjectile" and p47 == true then
                u49("Locking", false);
            end;
            l__LockonGui__24[p46].Visible = p47;
            if p47 then
                if v48.Playing then
                else
                    v48:Play();
                end;
            else
                v48:Stop();
            end;
        end;
    end;
    l__RunService__1:BindToRenderStep("HeliRocketAlerts", Enum.RenderPriority.Camera.Value + 1, function(_) --[[ Line: 272 ]]
        -- upvalues: u45 (copy), l__LockonGui__24 (copy)
        for v50, v51 in u45 do
            if os.time() - v51 >= 3 then
                local v52 = v50 == "Locking" and script.Locking or script.IncomingProjectile;
                if not script.IncomingProjectile.Playing or v50 ~= "Locking" then
                    local _ = v50 == "IncomingProjectile";
                    l__LockonGui__24[v50].Visible = false;
                    v52:Stop();
                end;
            end;
        end;
    end);
    local v55 = u1.helicopterModel.Networking.RocketEvent.OnClientEvent:Connect(function(p53) --[[ Line: 282 ]]
        -- upvalues: u45 (copy), u49 (copy), l__LockonGui__24 (copy)
        u45[p53] = os.time();
        local v54 = p53 == "Locking" and script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing and p53 == "Locking" then
        else
            if p53 == "IncomingProjectile" then
                u49("Locking", false);
            end;
            l__LockonGui__24[p53].Visible = true;
            if v54.Playing then
            else
                v54:Play();
            end;
        end;
    end);
    table.insert(u1.connections, v55);
    u1.helicopterModel:GetAttributeChangedSignal("Flares"):Connect(function() --[[ Line: 288 ]]
        -- upvalues: u1 (ref), l__LockonGui__24 (copy)
        if u1.helicopterModel:GetAttribute("Flares") then
            local l__IncomingProjectile__25 = script.IncomingProjectile;
            local _ = script.IncomingProjectile.Playing;
            l__LockonGui__24.IncomingProjectile.Visible = false;
            l__IncomingProjectile__25:Stop();
            local v56 = script.Locking or script.IncomingProjectile;
            if script.IncomingProjectile.Playing then
                return;
            end;
            l__LockonGui__24.Locking.Visible = false;
            v56:Stop();
        end;
    end);
    u1.beforeUnset = {};
    function u1.beforeUnset.RocketAlerts() --[[ Line: 297 ]]
        -- upvalues: l__LockonGui__24 (copy)
        local l__IncomingProjectile__26 = script.IncomingProjectile;
        local _ = script.IncomingProjectile.Playing;
        l__LockonGui__24.IncomingProjectile.Visible = false;
        l__IncomingProjectile__26:Stop();
        local v57 = script.Locking or script.IncomingProjectile;
        if script.IncomingProjectile.Playing then
        else
            l__LockonGui__24.Locking.Visible = false;
            v57:Stop();
        end;
    end;
    l__RightHeliFrame__12.Buttons.Shoot.Visible = u1.hasWeapons == true;
    l__RightHeliFrame__12.Buttons.ChangeWeapon.Visible = u1.hasWeapons == true;
    l__HeliControls__10.Circle.Visible = u1.hasWeapons == true;
    l__HeliControls__10.Enabled = true;
    local l__Content__27 = l__HeliControls__10.Altimeter.Content;
    u1.altimeterLines = {
        regular = {}
    };
    l__Content__27:ClearAllChildren();
    for v58 = 0, 28 do
        local v59 = 0.3;
        local v60 = Instance.new("Frame", l__Content__27);
        v60.Name = "Line";
        v60.AnchorPoint = Vector2.new(1, 0);
        if v58 == 14 then
            u1.altimeterLines.middle = v60;
            v59 = 0.55;
        else
            table.insert(u1.altimeterLines.regular, v60);
        end;
        v60.Size = UDim2.new(v59, 0, 0.015, 0);
        v60.Visible = true;
        v60.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        v60.BorderSizePixel = 0;
    end;
    l__RunService__1:BindToRenderStep("HeliControls_Reticle", Enum.RenderPriority.Camera.Value - 1, u1.ReticleLoop);
end;
function u1.UnsetHeli() --[[ Line: 338 ]]
    -- upvalues: u1 (copy), l__RadarHandler__15 (copy), l__RunService__1 (copy), l__HeliControls__10 (copy)
    for _, v61 in u1.beforeUnset do
        v61();
    end;
    l__RadarHandler__15.Hide();
    l__RunService__1.RenderStepped:Wait();
    l__RunService__1:UnbindFromRenderStep("HeliControls_Reticle");
    l__RunService__1:UnbindFromRenderStep("HeliRocketAlerts");
    u1.helicopterModel = nil;
    l__HeliControls__10.Enabled = false;
    for _, v62 in u1.connections do
        v62:Disconnect();
    end;
end;
return u1;