-- Roblox: Workspace.SilverAce293026.HelicopterControl.MovementModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__PlayerEvents__1 = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents");
local l__RunService__2 = game:GetService("RunService");
local l__InputModule__3 = require(script.Parent:WaitForChild("InputModule"));
local l__CameraModule__4 = require(script.Parent:WaitForChild("CameraModule"));
local u2 = {
    Reliable = l__PlayerEvents__1:WaitForChild("ReliableHeliEvent"),
    Unreliable = l__PlayerEvents__1:WaitForChild("UnreliableHeliEvent")
};
function u1.GetRotorSpeed() --[[ Line: 18 ]]
    -- upvalues: u1 (copy)
    return u1.helicopterModel:GetAttribute("rotorSpeed") or 0;
end;
function u1.SetRotorSpeed(p3) --[[ Line: 22 ]]
    -- upvalues: u2 (copy), u1 (copy)
    u2.Unreliable:FireServer(u1.helicopterModel, "setRotorSpeed", p3);
end;
function u1.DistanceFromFloor() --[[ Line: 26 ]]
    -- upvalues: u1 (copy)
    local l__Position__5 = u1.engine.Position;
    local v4 = RaycastParams.new();
    v4.FilterType = Enum.RaycastFilterType.Exclude;
    v4.FilterDescendantsInstances = { u1.helicopterModel };
    local v5 = workspace:Raycast(l__Position__5, Vector3.new(0, -1000, 0), v4);
    return not v5 and 1000 or v5.Distance;
end;
function u1.IsOnFloor() --[[ Line: 39 ]]
    -- upvalues: u1 (copy)
    if u1.cachedFloorResult then
        return u1.cachedFloorResult;
    end;
    if u1.skidPart then
        local v6 = {};
        for _, v7 in u1.skidPart:GetTouchingParts() do
            if not v7:IsDescendantOf(u1.helicopterModel) then
                table.insert(v6, v7);
            end;
        end;
        if #v6 > 0 then
            return true;
        end;
        local v8 = RaycastParams.new();
        v8.FilterType = Enum.RaycastFilterType.Exclude;
        v8.FilterDescendantsInstances = { u1.helicopterModel };
        return workspace:Raycast(u1.skidPart.Position, Vector3.new(0, -2, 0), v8) and true or false;
    end;
end;
function u1.ProcessElevation(_) --[[ Line: 66 ]]
    -- upvalues: u1 (copy)
    local l__elevationIntent__6 = u1.elevationIntent;
    local v9 = l__elevationIntent__6 < 0 and u1.IsOnFloor() and 0 or l__elevationIntent__6;
    local v10 = u1;
    local l__interpolatedElevation__7 = u1.interpolatedElevation;
    v10.interpolatedElevation = l__interpolatedElevation__7 + 0.06 * (v9 - l__interpolatedElevation__7);
    local v11 = u1.GetRotorSpeed();
    if v11 >= 100 then
        return u1.engine.CFrame.UpVector * u1.interpolatedElevation * 20;
    end;
    local v12 = math.clamp(v11 + u1.interpolatedElevation * 5, 0, 100);
    u1.SetRotorSpeed(v12);
end;
function u1.ProcessRollTilt() --[[ Line: 87 ]]
    -- upvalues: u1 (copy)
    local v13 = -u1.rollIntent;
    local v14 = u1;
    local l__interpolatedRoll__8 = u1.interpolatedRoll;
    v14.interpolatedRoll = l__interpolatedRoll__8 + 0.05 * (v13 - l__interpolatedRoll__8);
    if math.abs(v13) <= 0.1 then
        local v15 = -(Vector3.new(0, 1, 0)):Dot(u1.engine.CFrame.RightVector);
        local v16 = math.abs(v15) < 0.02 and 0 or v15;
        local v17 = u1;
        local l__interpolatedRoll__9 = u1.interpolatedRoll;
        v17.interpolatedRoll = l__interpolatedRoll__9 + 0.075 * (v16 * 1.6 - l__interpolatedRoll__9);
    end;
    if u1.GetRotorSpeed() >= 100 then
        return Vector3.new(0, 0, u1.interpolatedRoll);
    end;
    u1.interpolatedRoll = 0;
end;
function u1.ProcessYawRotation() --[[ Line: 112 ]]
    -- upvalues: u1 (copy)
    local l__X__10 = u1.pitchYawIntent.X;
    local v18 = u1.IsOnFloor() and 0 or l__X__10;
    local v19 = u1;
    local l__interpolatedYaw__11 = u1.interpolatedYaw;
    v19.interpolatedYaw = l__interpolatedYaw__11 + 0.03 * (v18 - l__interpolatedYaw__11);
    if u1.GetRotorSpeed() >= 100 then
        return Vector3.new(0, u1.interpolatedYaw, 0);
    end;
    u1.interpolatedYaw = 0;
end;
function u1.ProcessPitchRotation() --[[ Line: 126 ]]
    -- upvalues: u1 (copy)
    local l__Y__12 = u1.pitchYawIntent.Y;
    local v20 = u1.IsOnFloor() and 0 or l__Y__12;
    local v21 = u1;
    local l__interpolatedPitch__13 = u1.interpolatedPitch;
    v21.interpolatedPitch = l__interpolatedPitch__13 + 0.03 * (v20 - l__interpolatedPitch__13);
    if u1.GetRotorSpeed() >= 100 then
        return Vector3.new(u1.interpolatedPitch, 0, 0);
    end;
    u1.interpolatedPitch = 0;
end;
function u1.ProcessMovementVector(_) --[[ Line: 140 ]]
    -- upvalues: u1 (copy)
    local v22 = (Vector3.new(0, 1, 0)):Dot(u1.engine.CFrame.LookVector);
    local v23 = (Vector3.new(0, 1, 0)):Dot(u1.engine.CFrame.RightVector);
    local v24 = (Vector3.new(0, 1, 0)):Dot(u1.engine.CFrame.UpVector);
    local v25 = v24 >= 0 and Vector3.new(0, 0, 0) or Vector3.new(0, -45, 0) * math.abs(v24);
    local v26;
    if math.abs(v22) < 0.03 then
        v26 = -u1.movementBackForth / 60;
    else
        v26 = v22;
    end;
    if math.abs(v23) < 0.06 then
        v23 = -u1.movementLeftRight / 140;
    end;
    local v27 = Vector3.new(0, -1, 0) * v22 * 25;
    if u1.IsOnFloor() then
        local v28 = u1;
        local l__movementBackForth__14 = u1.movementBackForth;
        v28.movementBackForth = l__movementBackForth__14 + 0.1 * (0 - l__movementBackForth__14);
        local v29 = u1;
        local l__movementLeftRight__15 = u1.movementLeftRight;
        v29.movementLeftRight = l__movementLeftRight__15 + 0.1 * (0 - l__movementLeftRight__15);
    else
        local v30 = u1.helicopterModel:GetAttribute("AccelerationDivisor") or 1.2;
        local v31 = u1;
        v31.movementBackForth = v31.movementBackForth + v26 / v30;
        local v32 = u1;
        v32.movementLeftRight = v32.movementLeftRight + v23 * 0.85;
    end;
    local v33 = u1.helicopterModel:GetAttribute("MaxSpeed") or 82;
    u1.movementBackForth = math.clamp(u1.movementBackForth, -v33, v33);
    u1.movementLeftRight = math.clamp(u1.movementLeftRight, -v33 / 2, v33 / 2);
    return -u1.engine.CFrame.LookVector * u1.movementBackForth + v25 + -u1.engine.CFrame.RightVector * u1.movementLeftRight + v27;
end;
function u1.DoCameraSpeedEffect(p34) --[[ Line: 193 ]]
    -- upvalues: l__CameraModule__4 (copy)
    l__CameraModule__4.SetSpeedDistance(p34 / 70);
end;
function u1.MoveLoop(p35) --[[ Line: 197 ]]
    -- upvalues: u1 (copy)
    u1.cachedFloorResult = nil;
    u1.cachedFloorResult = u1.IsOnFloor();
    local v36 = u1.ProcessElevation(p35) or Vector3.new();
    local v37 = u1.ProcessMovementVector(p35) or Vector3.new();
    local v38 = u1.ProcessRollTilt() or Vector3.new();
    local v39 = u1.ProcessYawRotation() or Vector3.new();
    local v40 = u1.ProcessPitchRotation() or Vector3.new();
    u1.interpolatedWorldForce = u1.interpolatedWorldForce:Lerp(v36 + v37, p35 * 2);
    u1.engine.Movement.VectorVelocity = u1.interpolatedWorldForce;
    u1.interpolatedAngularity = u1.interpolatedAngularity:Lerp(v38 + v39 + v40, 0.1);
    u1.engine.AngularVelocity.AngularVelocity = u1.interpolatedAngularity;
    u1.DoCameraSpeedEffect(u1.interpolatedWorldForce.Magnitude);
    u1.pitchYawIntent = Vector2.new();
end;
function u1.RotorLoop(p41) --[[ Line: 229 ]]
    -- upvalues: u1 (copy)
    local l__TopRotor__16 = u1.helicopterModel.BodyKit.TopRotor;
    local l__TailRotor__17 = u1.helicopterModel.BodyKit.TailRotor;
    local v42 = u1.GetRotorSpeed();
    local v43 = l__TopRotor__16:GetAttribute("RotVec") * (v42 * p41 * 18);
    local l__Rotor__18 = l__TopRotor__16.Rotor;
    l__Rotor__18.CFrame = l__Rotor__18.CFrame * CFrame.Angles(math.rad(v43.X), math.rad(v43.Y), (math.rad(v43.Z)));
    local v44 = l__TailRotor__17:GetAttribute("RotVec") * (v42 * p41 * 18);
    local l__Rotor__19 = l__TailRotor__17.Rotor;
    l__Rotor__19.CFrame = l__Rotor__19.CFrame * CFrame.Angles(math.rad(v44.X), math.rad(v44.Y), (math.rad(v44.Z)));
    local v45 = u1.DistanceFromFloor();
    u1.UpdateSmoke(v45);
end;
function u1.UpdateSmoke(p46) --[[ Line: 255 ]]
    -- upvalues: u2 (copy), u1 (copy)
    if u1.GetRotorSpeed() < 100 or p46 > 35 then
        u2.Unreliable:FireServer(u1.helicopterModel, "setSmoke", false, nil);
    else
        u2.Unreliable:FireServer(u1.helicopterModel, "setSmoke", true, p46);
    end;
end;
function u1.SetHeli(p47) --[[ Line: 269 ]]
    -- upvalues: u1 (copy), l__RunService__2 (copy), l__InputModule__3 (copy), l__CameraModule__4 (copy)
    u1.helicopterModel = p47;
    u1.engine = u1.helicopterModel.Required.Engine;
    l__RunService__2:BindToRenderStep("Helicopter_Rotor", Enum.RenderPriority.Input.Value, u1.RotorLoop);
    u1.moveHeartbeat = l__RunService__2.Heartbeat:Connect(u1.MoveLoop);
    for _, v48 in p47.Hitbox:GetChildren() do
        if v48:GetAttribute("IgnoreCrashes") then
            u1.skidPart = v48;
            break;
        end;
    end;
    u1.smokePart = p47.Required.SmokePart;
    u1.interpolatedWorldForce = Vector3.new();
    u1.interpolatedAngularity = Vector3.new();
    u1.pitchYawIntent = Vector2.new();
    u1.elevationIntent = 0;
    u1.rollIntent = 0;
    u1.movementBackForth = 0;
    u1.movementLeftRight = 0;
    u1.interpolatedElevation = u1.elevationIntent;
    u1.interpolatedRoll = u1.rollIntent;
    u1.interpolatedPitch = u1.pitchYawIntent.X;
    u1.interpolatedYaw = u1.pitchYawIntent.Y;
    local u49 = u1.helicopterModel:GetAttribute("RotateDivisor") or 30;
    local u50 = u1.helicopterModel:GetAttribute("RollDivisor") or 1;
    local v51 = l__InputModule__3.GetBoundScheme("Heli");
    v51:SubscribeToControl("PitchAndYaw", function(p52, _) --[[ Line: 306 ]]
        -- upvalues: l__CameraModule__4 (ref), u1 (ref), u49 (copy)
        if l__CameraModule__4.freelook then
            u1.pitchYawIntent = Vector2.new();
        else
            local v53 = -p52.Position;
            local v54;
            if p52.Input == Enum.UserInputType.MouseMovement then
                v54 = -p52.Delta / (u49 / 2.15);
            elseif p52.Input == Enum.KeyCode.Thumbstick2 then
                local v55 = v53 * 0.92;
                v54 = Vector2.new(v55.X, -v55.Y);
            else
                v54 = -p52.Delta / (u49 / 15);
            end;
            u1.pitchYawIntent = Vector2.new(math.clamp(v54.X, -5, 5), (math.clamp(v54.Y, -5, 5)));
        end;
    end);
    v51:SubscribeToControl("Roll", function(p56, _) --[[ Line: 332 ]]
        -- upvalues: l__CameraModule__4 (ref), u1 (ref), u50 (copy)
        if l__CameraModule__4.freelook then
            u1.rollIntent = 0;
        else
            local v57;
            if p56.AnalogValue then
                v57 = p56.AnalogValue;
            else
                local l__X__20 = p56.Position.X;
                v57 = math.abs(l__X__20) < 0.1 and 0 or l__X__20;
            end;
            u1.rollIntent = v57 / u50;
        end;
    end);
    v51:SubscribeToControl("Elevation", function(p58, _) --[[ Line: 352 ]]
        -- upvalues: u1 (ref)
        u1.elevationIntent = p58.AnalogValue or p58.Pressure;
    end);
end;
function u1.UnsetHeli() --[[ Line: 357 ]]
    -- upvalues: u1 (copy), l__RunService__2 (copy)
    u1.helicopterModel = nil;
    u1.moveHeartbeat:Disconnect();
    u1.moveHeartbeat = nil;
    l__RunService__2:UnbindFromRenderStep("Helicopter_Rotor");
    u1.skidPart = nil;
end;
script:WaitForChild("GetElevationIntent").OnInvoke = function() --[[ Line: 365 ]]
    -- upvalues: u1 (copy)
    return not u1.helicopterModel and 0 or math.ceil((u1.elevationIntent or 0) * 100);
end;
return u1;