-- Roblox: Workspace.SilverAce293026.PlaneControl.UIModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__Players__1 = game:GetService("Players");
local l__RunService__2 = game:GetService("RunService");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__4 = l__Players__1.LocalPlayer;
local l__PlaneControls__5 = l__LocalPlayer__4.PlayerGui:WaitForChild("PlaneControls");
local l__MovementModule__6 = require(script.Parent:WaitForChild("MovementModule"));
local l__CameraModule__7 = require(script.Parent:WaitForChild("CameraModule"));
local l__Modules__8 = l__ReplicatedStorage__3:WaitForChild("Modules");
local l__FlaresSettings__9 = require(l__Modules__8:WaitForChild("FlaresSettings"));
local function u26() --[[ Line: 25 ]]
    -- upvalues: u1 (copy), l__PlaneControls__5 (copy), l__MovementModule__6 (copy), l__FlaresSettings__9 (copy), l__CameraModule__7 (copy)
    if u1.seat then
        local l__CurrentCamera__10 = workspace.CurrentCamera;
        local l__CFrame__11 = u1.seat.CFrame;
        local v2 = CFrame.new(l__CurrentCamera__10.CFrame.Position) * l__CFrame__11.Rotation;
        local v3 = v2.Position + v2.LookVector * 1000;
        local _ = l__PlaneControls__5.Circle.AbsoluteSize.X;
        local l__Altimeter__12 = l__PlaneControls__5.Altimeter;
        local _ = l__Altimeter__12.Content;
        local v4 = (Vector3.new(u1.seat.Position.X, -110, u1.seat.Position.Z) - u1.seat.Position).Magnitude / 2.4;
        local v5 = math.floor(v4) .. "m";
        local v6 = #u1.altimeterLines.regular + 1;
        u1.altimeterLines.middle.Position = UDim2.new(1, 0, 0.5, 0);
        local l__Y__13 = u1.seat.AssemblyLinearVelocity.Y;
        local v7 = math.abs(l__Y__13) / 40;
        local v8 = math.clamp(v7, -0.5, 0.5);
        if l__Y__13 < 0 then
            v8 = -v8 or v8;
        end;
        l__Altimeter__12.Pointer.Position = UDim2.new(1.2, 0, -(v8 - 0.5), 0);
        l__Altimeter__12.Pointer.Text = "< " .. math.floor(u1._plane.PrimaryPart.AssemblyLinearVelocity.Y / 2.4) .. "m/s";
        local v9 = math.floor((v6 - 1) / 2);
        local v10 = math.floor(v6 - 1 - v9);
        for v11 = 1, v9 do
            local v12 = u1.altimeterLines.regular[v11];
            local v13 = 0.5 - v11 * 0.035;
            if v13 < 0 then
                v13 = v13 + 1;
            end;
            v12.Position = UDim2.new(1, 0, v13, 0);
        end;
        for v14 = 1, v10 do
            local v15 = u1.altimeterLines.regular[v14 + v10];
            local v16 = v14 * 0.035 + 0.5;
            if v16 > 1 then
                v16 = v16 - 1;
            end;
            v15.Position = UDim2.new(1, 0, v16, 0);
        end;
        l__Altimeter__12.Value.Text = v5;
        local v17 = math.ceil(u1.seat.AssemblyLinearVelocity.Magnitude / 2.4);
        l__PlaneControls__5.Stats.Speed.Value.Text = `{v17}m/s`;
        if v17 >= 0 then
            l__PlaneControls__5.Stats.Speed.Value.TextColor3 = Color3.fromRGB(255, 255, 255);
        else
            l__PlaneControls__5.Stats.Speed.Value.TextColor3 = Color3.fromRGB(255, 0, 0);
        end;
        local v18 = math.ceil(l__MovementModule__6.ThrustPercent);
        if l__MovementModule__6.WEPActive then
            v18 = v18 + 10;
            l__PlaneControls__5.Stats.Thrust.Value.TextColor3 = Color3.fromRGB(255, 0, 0);
        else
            l__PlaneControls__5.Stats.Thrust.Value.TextColor3 = Color3.fromRGB(255, 255, 255);
        end;
        l__PlaneControls__5.Stats.Thrust.Value.Text = `{v18}%`;
        local v19 = os.time() - u1.flaresLastDeployed;
        local v20 = u1.flaresLastDeployed + l__FlaresSettings__9.Cooldown - os.time();
        local v21 = l__FlaresSettings__9.Cooldown + 1 <= v19;
        l__PlaneControls__5.Stats.Flares.Value.Text = v21 and "READY" or v20;
        l__PlaneControls__5.Stats.Flares.Value.TextColor3 = v21 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 0, 0);
        local v22 = workspace:Raycast(u1.seat.Position, u1.seat.CFrame.LookVector * 1000, u1.castParams);
        local v23, _ = l__CurrentCamera__10:WorldToScreenPoint(v3);
        l__PlaneControls__5.Aim.Size = u1.aimUdim;
        if v22 and v22.Instance then
            local v24, _ = l__CurrentCamera__10:WorldToScreenPoint(v22.Position);
            l__PlaneControls__5.Aim.Visible = true;
            l__PlaneControls__5.Aim.Position = UDim2.new(0, v24.X, 0, v24.Y);
        else
            l__PlaneControls__5.Aim.Position = UDim2.new(0, v23.X, 0, v23.Y);
            l__PlaneControls__5.Aim.Visible = true;
        end;
        local v25 = l__CurrentCamera__10:WorldToScreenPoint((l__CameraModule__7.AlignPart.CFrame * CFrame.new(0, 0, -500)).Position + Vector3.new(0, 25, 0));
        l__PlaneControls__5.Circle.Position = UDim2.new(0, v25.X, 0, v25.Y);
        l__PlaneControls__5.MainFrame.Position = UDim2.new(0, v25.X, 0, v25.Y + 100);
    end;
end;
local u27 = nil;
function u1.SetPlane(p28) --[[ Line: 145 ]]
    -- upvalues: l__PlaneControls__5 (copy), u1 (copy), l__LocalPlayer__4 (copy), u27 (ref), l__RunService__2 (copy), u26 (copy)
    l__PlaneControls__5.Enabled = true;
    u1._plane = p28;
    u1.seat = p28.Required.PlaneSeat;
    u1.aimUdim = UDim2.new(0.029, 0, 0.029, 0);
    local l__Content__14 = l__PlaneControls__5.Altimeter.Content;
    u1.altimeterLines = {
        regular = {}
    };
    l__Content__14:ClearAllChildren();
    l__PlaneControls__5.Stats.Weapon.Value.Text = "NONE";
    local l__Content__15 = l__PlaneControls__5.Altimeter.Content;
    u1.altimeterLines = {
        regular = {}
    };
    l__Content__15:ClearAllChildren();
    for v29 = 0, 28 do
        local v30 = 0.3;
        local v31 = Instance.new("Frame", l__Content__15);
        v31.Name = "Line";
        v31.AnchorPoint = Vector2.new(1, 0);
        if v29 == 14 then
            u1.altimeterLines.middle = v31;
            v30 = 0.55;
        else
            table.insert(u1.altimeterLines.regular, v31);
        end;
        v31.Size = UDim2.new(v30, 0, 0.015, 0);
        v31.Visible = true;
        v31.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        v31.BorderSizePixel = 0;
    end;
    u1.castParams = RaycastParams.new();
    u1.castParams.FilterType = Enum.RaycastFilterType.Exclude;
    u1.castParams.CollisionGroup = "CamCast";
    u1.castParams.FilterDescendantsInstances = { u1._plane, l__LocalPlayer__4.Character };
    u27 = l__RunService__2.RenderStepped:Connect(u26);
end;
function u1.SetWeapon(p32) --[[ Line: 200 ]]
    -- upvalues: l__PlaneControls__5 (copy)
    l__PlaneControls__5.Stats.Weapon.Value.Text = p32;
end;
function u1.UnsetPlane() --[[ Line: 205 ]]
    -- upvalues: l__PlaneControls__5 (copy), u27 (ref)
    l__PlaneControls__5.Enabled = false;
    u27:Disconnect();
    u27 = nil;
end;
return u1;