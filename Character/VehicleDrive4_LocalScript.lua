-- Roblox: Workspace.SilverAce293026.VehicleDrive4
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
game:GetService("ReplicatedStorage");
local l__ContextActionService__2 = game:GetService("ContextActionService");
local l__RunService__3 = game:GetService("RunService");
local l__StarterGui__4 = game:GetService("StarterGui");
local l__LocalPlayer__5 = l__Players__1.LocalPlayer;
local l__Humanoid__6 = (l__LocalPlayer__5.Character or l__LocalPlayer__5.CharacterAdded:Wait()):WaitForChild("Humanoid");
local l__PlayerGui__7 = l__LocalPlayer__5:WaitForChild("PlayerGui");
local l__Handbrake__8 = l__PlayerGui__7:WaitForChild("CustomMobileGui"):WaitForChild("RightFrame"):WaitForChild("Buttons"):WaitForChild("Handbrake");
local l__VehicleGui__9 = l__PlayerGui__7:WaitForChild("VehicleGui");
local l__VehicleGuiModule__10 = require(l__VehicleGui__9:WaitForChild("VehicleGuiModule"));
local l__Util__11 = require(script:WaitForChild("Util"));
local u1 = nil;
local function u24(p2, p3, p4) --[[ Line: 27 ]]
    -- upvalues: u1 (ref), l__Util__11 (copy)
    if u1.FlipAccel then
        p3 = -p3;
    end;
    if math.abs(p3) < 0.1 and u1.VirtualThrottle ~= 0 then
        p3 = u1.VirtualThrottle;
    end;
    local v5 = math.sign(p3);
    local v6 = u1.EngineSpeed or 0;
    local v7 = math.max(u1.Params.ForwardMaxSpeed, u1.Params.ReverseMaxSpeed);
    local v8;
    if v5 >= 0 then
        v8 = p3 * u1.Params.ForwardMaxSpeed;
    else
        v8 = p3 * u1.Params.ReverseMaxSpeed;
    end;
    local v9 = l__Util__11.GetForwardSpeed(u1.Model);
    local v10;
    if v5 == 0 or math.abs(v9) <= 1 then
        v10 = false;
    else
        v10 = v5 ~= math.sign(v9);
    end;
    local l__Acceleration__12 = u1.Params.Acceleration;
    if v10 then
        l__Acceleration__12 = u1.Params.BrakePower;
        v8 = 0;
    elseif math.abs(v8) < math.abs(v6) then
        l__Acceleration__12 = u1.Params.Deceleration;
    end;
    local v11 = l__Util__11.Lerp(v6, v9, (math.min(p2 * u1.Params.SpeedSyncFactor, 1)));
    local v12;
    if v11 < v8 then
        v12 = math.min(v11 + l__Acceleration__12 * p2, v8);
    else
        v12 = math.max(v11 - l__Acceleration__12 * p2, v8);
    end;
    u1.EngineSpeed = v12;
    local v13 = math.min(v9, v7) / v7;
    local v14 = l__Util__11.Lerp(u1.Params.LowSpeedTorque, u1.Params.HighSpeedTorque, v13);
    local v15 = l__Util__11.MphToStudsPerSec(v12) / u1.WheelRadius;
    u1.Motors.Right.Wheel1.AngularVelocity = v15;
    u1.Motors.Right.Wheel1.MotorMaxTorque = v14;
    u1.Motors.Left.Wheel1.AngularVelocity = -v15;
    u1.Motors.Left.Wheel1.MotorMaxTorque = v14;
    if p4 then
        for _, v16 in u1.Motors do
            for v17, v18 in v16 do
                if v17 ~= "Wheel1" then
                    v18.AngularVelocity = 0;
                    v18.MotorMaxTorque = u1.Params.HandbrakeTorque;
                end;
            end;
        end;
    else
        for v19, v20 in u1.Motors do
            for v21, v22 in v20 do
                if v21 ~= "Wheel1" then
                    local v23;
                    if v19 == "Left" then
                        v23 = -v15 or v15;
                    else
                        v23 = v15;
                    end;
                    v22.AngularVelocity = v23;
                    v22.MotorMaxTorque = v14;
                end;
            end;
        end;
    end;
end;
local function u42(_, p25, p26) --[[ Line: 116 ]]
    -- upvalues: u1 (ref), l__Util__11 (copy)
    local v27 = math.max(u1.Params.ForwardMaxSpeed, u1.Params.ReverseMaxSpeed);
    local v28 = l__Util__11.GetForwardSpeed(u1.Model);
    local v29 = 1 - math.min(v28, v27) / v27 * u1.Params.SteeringReduction;
    local v30 = p25 * math.max(v29, 0);
    if u1.LocomotionType == "Wheels" then
        if v30 > 0 then
            for _, v31 in u1.Racks do
                v31.TargetPosition = v30 * v31.LowerLimit;
            end;
        else
            for _, v32 in u1.Racks do
                v32.TargetPosition = -v30 * v32.UpperLimit;
            end;
        end;
    else
        if u1.LocomotionType == "Tracks" then
            local v33 = l__Util__11.GetForwardSpeed(u1.Model);
            local v34 = math.abs(v33);
            u1.VirtualThrottle = 0;
            if math.abs(p25) <= 0.1 then
                return;
            end;
            local v35 = math.max(1 - v34 / u1.Params.ForwardMaxSpeed, 0.3);
            local v36 = v35 * 1 * math.abs(v30) + 1;
            local v37 = 1 - v35 * 1 * math.abs(v30);
            if math.abs(p26) <= 0.15 then
                v36 = 1;
                v37 = -1;
                if u1.FlipAccel then
                    v36 = v36 * -1;
                    v37 = v37 * -1;
                end;
            end;
            if v30 > 0 then
                for _, v38 in u1.Motors.Right do
                    v38.AngularVelocity = v38.AngularVelocity * v37;
                end;
                for _, v39 in u1.Motors.Left do
                    v39.AngularVelocity = v39.AngularVelocity * v36;
                end;
            elseif v30 < 0 then
                for _, v40 in u1.Motors.Left do
                    v40.AngularVelocity = v40.AngularVelocity * v37;
                end;
                for _, v41 in u1.Motors.Right do
                    v41.AngularVelocity = v41.AngularVelocity * v36;
                end;
            end;
            u1.VirtualThrottle = math.abs(v30);
        end;
    end;
end;
local function u46() --[[ Line: 184 ]]
    -- upvalues: u1 (ref)
    for _, v43 in u1.Wheels do
        for _, v44 in v43 do
            local v45 = math.abs(v44.AssemblyLinearVelocity.Magnitude - u1.WheelRadius * v44.AssemblyAngularVelocity.Magnitude) > u1.WheelParams.SlipThreshold and u1.WheelParams.KineticFriction or u1.WheelParams.StaticFriction;
            v44.CustomPhysicalProperties = PhysicalProperties.new(u1.WheelParams.Density, v45, u1.WheelParams.Elasticity);
        end;
    end;
end;
local function u55(p47, p48) --[[ Line: 218 ]]
    -- upvalues: u1 (ref), l__Util__11 (copy), l__ContextActionService__2 (copy), l__Handbrake__8 (copy), l__RunService__3 (copy), u24 (copy), u42 (copy), u46 (copy)
    u1 = {
        Model = p47:FindFirstAncestorOfClass("Model"),
        Seat = p47
    };
    u1.Motors = l__Util__11.GetMotors(u1.Model);
    u1.Racks = l__Util__11.GetRacks(u1.Model);
    u1.Wheels = l__Util__11.GetWheels(u1.Model);
    u1.EventConnections = {};
    u1.LocomotionType = p48;
    u1.WheelRadius = u1.Wheels.Left.Wheel1.Size.Y / 2;
    u1.VirtualThrottle = 0;
    u1.FlipAccel = u1.Model:GetAttribute("FlipAccel");
    u1.Params = {};
    for _, u49 in u1.Model.Params:GetChildren() do
        if u49:IsA("ValueBase") then
            u1.Params[u49.Name] = u49.Value;
            local v50 = u49.Changed:Connect(function() --[[ Line: 245 ]]
                -- upvalues: u1 (ref), u49 (copy)
                u1.Params[u49.Name] = u49.Value;
            end);
            table.insert(u1.EventConnections, v50);
        end;
    end;
    u1.WheelParams = {};
    for v51, v52 in u1.Model.Wheels:GetAttributes() do
        u1.WheelParams[v51] = v52;
    end;
    l__ContextActionService__2:BindAction("CarHandbrake", function(_, p53) --[[ Line: 263 ]]
        -- upvalues: u1 (ref)
        if u1 then
            if p53 == Enum.UserInputState.Begin then
                u1.Handbrake = true;
            else
                if p53 == Enum.UserInputState.End then
                    u1.Handbrake = false;
                end;
            end;
        end;
    end, false, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonX);
    table.insert(u1.EventConnections, l__Handbrake__8.InputBegan:Connect(function() --[[ Line: 272 ]]
        -- upvalues: u1 (ref)
        u1.Handbrake = true;
    end));
    table.insert(u1.EventConnections, l__Handbrake__8.InputEnded:Connect(function() --[[ Line: 276 ]]
        -- upvalues: u1 (ref)
        u1.Handbrake = false;
    end));
    l__Handbrake__8.Visible = true;
    table.insert(u1.EventConnections, l__RunService__3.Stepped:Connect(function(_, p54) --[[ Line: 285 ]]
        -- upvalues: u1 (ref), u24 (ref), u42 (ref), u46 (ref)
        local l__Seat__13 = u1.Seat;
        local l__ThrottleFloat__14 = l__Seat__13.ThrottleFloat;
        local l__SteerFloat__15 = l__Seat__13.SteerFloat;
        u24(p54, l__ThrottleFloat__14, u1.Handbrake);
        u42(p54, l__SteerFloat__15, l__ThrottleFloat__14);
        u46();
    end));
end;
local function u62() --[[ Line: 294 ]]
    -- upvalues: u1 (ref), l__ContextActionService__2 (copy), l__Handbrake__8 (copy), l__VehicleGuiModule__10 (copy)
    for _, v56 in u1.EventConnections do
        v56:Disconnect();
    end;
    u1.EngineSpeed = 0;
    for _, v57 in u1.Motors do
        for _, v58 in v57 do
            v58.AngularVelocity = 0;
            v58.MotorMaxTorque = u1.Params.LowSpeedTorque;
        end;
    end;
    for _, v59 in u1.Racks do
        v59.TargetPosition = 0;
    end;
    for _, v60 in u1.Wheels do
        for _, v61 in v60 do
            v61.CustomPhysicalProperties = PhysicalProperties.new(u1.WheelParams.Density, u1.WheelParams.StaticFriction, u1.WheelParams.Elasticity);
        end;
    end;
    l__ContextActionService__2:UnbindAction("CarHandbrake");
    l__Handbrake__8.Visible = false;
    u1 = nil;
    l__VehicleGuiModule__10.Clear();
end;
l__Humanoid__6.Seated:Connect(function(p63, p64) --[[ Line: 336 ]]
    -- upvalues: u1 (ref), u62 (copy), l__Util__11 (copy), u55 (copy), l__StarterGui__4 (copy)
    if p63 or not u1 then
        if p63 then
            if not p64 then
                return;
            end;
            if p64.Name == "PlaneSeat" then
                return;
            end;
            local v65 = l__Util__11.GetLocomotionType(p64);
            if not v65 then
                return;
            end;
            u55(p64, v65);
            l__StarterGui__4:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
        end;
    else
        u62();
    end;
end);
l__Handbrake__8.Visible = false;