-- Roblox: Workspace.SilverAce293026.PlaneControl.MovementModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__RunService__1 = game:GetService("RunService");
game:GetService("UserInputService");
local l__Players__2 = game:GetService("Players");
game:GetService("ReplicatedStorage");
local l__TweenService__3 = game:GetService("TweenService");
local u2 = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
local l__LocalPlayer__4 = l__Players__2.LocalPlayer;
l__LocalPlayer__4:WaitForChild("PlayerGui");
local l__InputModule__5 = require(script.Parent:WaitForChild("InputModule"));
local l__UtilModule__6 = require(script.Parent:WaitForChild("UtilModule"));
local l__CameraModule__7 = require(script.Parent:WaitForChild("CameraModule"));
function u1.SetGear(p3) --[[ Line: 23 ]]
    -- upvalues: u1 (copy), l__TweenService__3 (copy), u2 (copy)
    u1.GearDown = p3;
    local v4 = p3 and "Down" or "Up";
    if not u1.GearInfo then
        return;
    end;
    local l__Wheels__8 = u1._plane.Wheels;
    local l__Gear__9 = u1._plane.BodyKit.Gear;
    local v5 = {};
    local v6 = {};
    for _, v7 in l__Wheels__8:GetChildren() do
        local l__Name__10 = v7.Name;
        local l__Cosmetic__11 = l__Gear__9[l__Name__10].Cosmetic;
        for v8 = 1, 32 do
            local v9 = v7:FindFirstChild((`Wheel{v8}Mount`));
            if not v9 then
                break;
            end;
            local v10 = u1.GearInfo[l__Name__10][`Wheel{v8}`][v4];
            local v11 = l__TweenService__3:Create(v9.Motor6D, u2, {
                C1 = v10.MountCF
            });
            table.insert(v6, v11);
            local l__AlignOrientation__12 = l__Cosmetic__11[`Wheel{v8}`].AlignOrientation;
            if not table.find(v5, l__AlignOrientation__12.Attachment1) then
                local l__Attachment1__13 = l__AlignOrientation__12.Attachment1;
                table.insert(v5, l__Attachment1__13);
                local v12 = l__TweenService__3:Create(l__Attachment1__13, u2, {
                    CFrame = v10.OrientCF
                });
                table.insert(v6, v12);
            end;
        end;
    end;
    for _, v13 in u1._plane.Suspension:GetChildren() do
        local v14 = l__TweenService__3:Create(v13, u2, {
            FreeLength = p3 and v13:GetAttribute("DefaultLength") or 0
        });
        table.insert(v6, v14);
    end;
    local u15 = {};
    for _, v16 in l__Gear__9:GetDescendants() do
        if v16:IsA("HingeConstraint") then
            local v17 = l__TweenService__3:Create(v16, u2, {
                TargetAngle = p3 and 0 or 90
            });
            table.insert(u15, v17);
        end;
    end;
    for _, v18 in v6 do
        v18:Play();
    end;
    task.delay(u2.Time, function() --[[ Line: 90 ]]
        -- upvalues: u15 (copy)
        for _, v19 in u15 do
            v19:Play();
        end;
    end);
end;
function u1.ThrustLoop(p20) --[[ Line: 97 ]]
    -- upvalues: u1 (copy)
    local l___thrustIntent__14 = u1._thrustIntent;
    u1.ThrustPercent = math.clamp(u1.ThrustPercent + l___thrustIntent__14 * p20 * 20, 0, 100);
    local v21 = u1.ThrustPercent == 100 and l___thrustIntent__14 > 0;
    local v22 = u1._maxSpeed * (u1.ThrustPercent / 100);
    if v21 then
        v22 = v22 * 1.1;
    end;
    local l__PrimaryPart__15 = u1._plane.PrimaryPart;
    local v23 = (Vector3.new(0, 1, 0)):Angle(l__PrimaryPart__15.CFrame.LookVector);
    local v24 = 0;
    if v23 < 1.25 then
        v24 = -((1.25 - v23 - 0) * (u1._maxSpeed * 0.37 - 0) / 1.25 + 0);
    elseif v23 > 1.8915926535897931 then
        v24 = (v23 - 1.8915926535897931) * (u1._maxSpeed * 0.37 - 0) / 1.25 + 0;
    end;
    local l__Y__16 = l__PrimaryPart__15.Position.Y;
    local v25 = l__Y__16 <= 3000 and 0 or math.min((l__Y__16 - 3000) / 500, 1) * 1.5;
    local v26 = math.max((v22 + v24) * (1 - v25), 0);
    u1.Thrust.VectorVelocity = Vector3.new(0, 0, v26);
    local v27 = math.min(v26 / u1._liftSpeed, 1) * u1._maxLift;
    u1.Lift.Force = Vector3.new(0, v27, 0);
    u1.WEPActive = v21;
end;
local function u33(p28, p29) --[[ Line: 149 ]]
    local l__LookVector__17 = p28.LookVector;
    local l__LookVector__18 = p29.LookVector;
    local l__Unit__19 = Vector3.new(l__LookVector__17.X, 0, l__LookVector__17.Z).Unit;
    local l__Unit__20 = Vector3.new(l__LookVector__18.X, 0, l__LookVector__18.Z).Unit;
    local v30 = l__Unit__19:Dot(l__Unit__20);
    local v31 = math.clamp(v30, -1, 1);
    local v32 = math.acos(v31);
    if l__Unit__19:Cross(l__Unit__20).Y < 0 then
        v32 = -v32;
    end;
    if p28.UpVector.Y < 0 then
        v32 = -v32;
    end;
    return v32;
end;
local u34 = 0;
function u1.GyroLoop(_) --[[ Line: 179 ]]
    -- upvalues: u1 (copy), l__CameraModule__7 (copy), l__UtilModule__6 (copy), u33 (copy), u34 (ref)
    local l__Magnitude__21 = u1._gasTank.AssemblyLinearVelocity.Magnitude;
    local l__AlignPart__22 = l__CameraModule__7.AlignPart;
    if l__UtilModule__6.IsOnGround() then
        local v35, v36;
        if u1._groundTorqueSpeeds[1] < l__Magnitude__21 then
            local v37 = (l__Magnitude__21 - u1._groundTorqueSpeeds[1]) / u1._groundTorqueSpeeds[2];
            v35 = v37 * u1._groundMaxTorque;
            v36 = Vector3.new(15, 1, 0) * v37;
        else
            v35 = 0;
            v36 = Vector3.new(15, 0, 0);
        end;
        u1.Gyro.P = v35;
        u1.Gyro.MaxTorque = v36;
        u1.Thrust.MaxAxesForce = Vector3.new(0, 0, 1000000);
    else
        u1.Gyro.MaxTorque = Vector3.new(100200000, 100200000, 0);
        u1.RollGyro.MaxTorque = Vector3.new(0, 0, 1200000);
        local v38 = u1.Lift.Force.Y < u1._maxLift * 0.8 and 0 or 3.5;
        local v39 = ((u1.Lift.Force.Y - 0) * 100 / (u1._maxLift - 0) + 0) / 100;
        u1.Thrust.MaxAxesForce = Vector3.new(2500000 * v39, u1.Lift.Force.Y * v38, 2500000 * v39);
        u1.Gyro.P = (l__Magnitude__21 - 0) * 90 / (u1._maxSpeed - 0) + 100;
        u1.RollGyro.P = (l__Magnitude__21 - 0) * 450 / (u1._maxSpeed - 0) + 0;
        local v40 = u1._gasTank.CFrame:AngleBetween(u1.Gyro.CFrame) / 0.28;
        local v41 = (1 - math.clamp(v40, 0, 1)) * 290;
        u1.Gyro.D = 300 - v41;
        u1.RollGyro.D = u1._plane:GetAttribute("HandlingDamp") or 190;
    end;
    local _ = l__AlignPart__22.CFrame.LookVector;
    local _ = u1._gasTank.CFrame.LookVector;
    local v42 = u33(l__AlignPart__22.CFrame, u1._gasTank.CFrame);
    local v43;
    if math.abs(v42) > 0.05 then
        local v44 = math.abs(v42) - 0.05;
        local v45 = math.clamp(v44, 0, 1.0471975511965976) / 1.0471975511965976;
        v43 = math.sign(v42) * v45 * 80;
    else
        v43 = 0;
    end;
    if v42 ~= 0 then
        u34 = v43;
    end;
    u1.Gyro.CFrame = CFrame.Angles(0, math.rad(l__CameraModule__7.xRot * l__CameraModule__7._yawSign), 0) * CFrame.Angles(math.rad(l__CameraModule__7.yRot), 0, 0) * CFrame.Angles(0, 0, (math.rad(l__CameraModule__7.zRot + v43)));
    u1.RollGyro.CFrame = u1.Gyro.CFrame;
    local u46 = math.abs(v43 / 80) * 30;
    local u47 = math.sign(v43);
    pcall(function() --[[ Line: 256 ]]
        -- upvalues: u1 (ref), u47 (copy), u46 (copy)
        for _, v48 in u1.ControlConstraints.Ailerons do
            v48.TargetAngle = (v48.Name:find("Left") and u47 or u47) * u46;
        end;
    end);
end;
function u1.SetSweep(p49) --[[ Line: 264 ]]
    -- upvalues: u1 (copy)
    if u1.SweepAngle then
        for _, v50 in u1._plane.BodyKit.HingedWings:GetDescendants() do
            if v50:IsA("HingeConstraint") then
                v50.TargetAngle = p49 and u1.SweepAngle or 0;
            end;
        end;
    end;
end;
function u1.CosmeticLoop(_) --[[ Line: 274 ]]
    -- upvalues: u1 (copy), l__CameraModule__7 (copy)
    local l__PrimaryPart__23 = u1._plane.PrimaryPart;
    local v51 = workspace:Raycast(l__PrimaryPart__23.Position, Vector3.new(0, -1000, 0), u1._altParams);
    if v51 then
        local l__Magnitude__24 = (v51.Position - l__PrimaryPart__23.Position).Magnitude;
        local v52 = math.abs(u1.Thrust.VectorVelocity.Z);
        if v52 < u1._liftSpeed * 1.5 and (l__Magnitude__24 < 50 and not u1.GearDown) then
            u1.SetGear(true);
            u1.SetSweep(false);
        elseif u1._liftSpeed * 1.5 < v52 and (l__Magnitude__24 > 50 and u1.GearDown) then
            u1.SetGear(false);
            u1.SetSweep(true);
        end;
    elseif not v51 and u1.GearDown then
        u1.SetGear(false);
        u1.SetSweep(true);
    end;
    local l__AlignPart__25 = l__CameraModule__7.AlignPart;
    local l__LookVector__26 = u1._gasTank.CFrame.LookVector;
    local _ = u1._gasTank.CFrame.UpVector;
    local l__RightVector__27 = u1._gasTank.CFrame.RightVector;
    local v53 = -l__LookVector__26:Cross(l__AlignPart__25.CFrame.LookVector).X * 60;
    local v54 = math.clamp(v53, -30, 30);
    for _, v55 in u1.ControlConstraints.Elevators do
        v55.TargetAngle = v54;
    end;
    local v56 = math.abs(l__AlignPart__25.CFrame.RightVector.X - u1._gasTank.CFrame.RightVector.X);
    local v57 = l__RightVector__27:Dot(l__AlignPart__25.CFrame.LookVector, l__RightVector__27);
    local v58 = v56 * math.sign(v57);
    for _, v59 in u1.ControlConstraints.Rudders do
        v59.TargetAngle = math.clamp(-v58 * 120, -20, 20);
    end;
    local l__Magnitude__28 = u1._gasTank.AssemblyLinearVelocity.Magnitude;
    local v60 = u1._liftSpeed >= l__Magnitude__28 and 0 or (l__Magnitude__28 - u1._liftSpeed) / (u1._maxSpeed - u1._liftSpeed) * 1.5;
    for _, v61 in u1.Cosmetics.WingtipFX do
        v61.Lifetime = v60;
    end;
end;
function u1.PropLoop(p62) --[[ Line: 338 ]]
    -- upvalues: u1 (copy)
    for _, v63 in u1._plane.BodyKit.Engines:GetChildren() do
        v63.CFrame = v63.CFrame * CFrame.Angles(0, 0, (math.rad(p62 * 14)));
    end;
end;
local u64 = {};
function u1.SetPlane(p65) --[[ Line: 347 ]]
    -- upvalues: u1 (copy), l__InputModule__5 (copy), l__LocalPlayer__4 (copy), l__RunService__1 (copy), u64 (ref)
    u1._plane = p65;
    u1._gasTank = p65.Required.GasTank;
    u1.GearDown = true;
    if p65.Params:FindFirstChild("Gear") then
        u1.GearInfo = require(p65.Params.Gear);
    end;
    u1.ThrustPercent = 0;
    u1.SweepAngle = p65:GetAttribute("SweepAngle");
    u1.Thrust = u1._gasTank.Thrust;
    u1.Gyro = u1._gasTank.Gyro;
    u1.RollGyro = u1._plane.Required.Engine.Roll;
    u1.Lift = u1._plane.Required.Engine.Lift;
    u1.ControlSurfaces = p65.BodyKit.ControlSurfaces;
    u1.ControlConstraints = {
        Elevators = {},
        Rudders = {},
        Ailerons = {}
    };
    for _, v66 in { "Elevator", "Rudder", "Aileron" } do
        local v67 = u1.ControlSurfaces[`{v66}Constraints`];
        local v68 = `{v66}s`;
        local v69 = u1.ControlConstraints[v68];
        for _, v70 in v67:GetDescendants() do
            if v70:IsA("HingeConstraint") then
                table.insert(v69, v70);
            end;
        end;
    end;
    u1.Cosmetics = {
        WingtipFX = {}
    };
    for _, v71 in p65.Cosmetics:GetChildren() do
        if v71.Name == "WingtipFX" then
            table.insert(u1.Cosmetics.WingtipFX, v71.Trail);
        end;
    end;
    u1._maxSpeed = p65:GetAttribute("MaxSpeed") or 195;
    local v72 = 0;
    for _, v73 in p65:GetDescendants() do
        if v73:IsA("BasePart") then
            v72 = v72 + v73.Mass;
        end;
    end;
    u1._liftSpeed = u1._maxSpeed * 0.4;
    u1._maxLift = v72 * workspace.Gravity;
    if p65:GetAttribute("Kickstart") then
        u1.ThrustPercent = 100;
        u1.Thrust.VectorVelocity = Vector3.new(0, 0, u1._maxSpeed);
        u1.Lift.Force = Vector3.new(0, u1._maxLift, 0);
    end;
    u1._groundTorqueSpeeds = { 5, 20 };
    u1._groundMaxTorque = 300;
    u1._scheme = l__InputModule__5.GetBoundScheme("Plane");
    u1._scheme:SubscribeToControl("Thrust", function(p74, _) --[[ Line: 428 ]]
        -- upvalues: u1 (ref)
        u1._thrustIntent = p74.AnalogValue or p74.Pressure;
    end);
    local v75 = RaycastParams.new();
    v75.FilterType = Enum.RaycastFilterType.Exclude;
    v75.FilterDescendantsInstances = { p65, l__LocalPlayer__4.Character };
    u1._altParams = v75;
    local v76 = l__RunService__1.RenderStepped:Connect(u1.ThrustLoop);
    local v77 = l__RunService__1.RenderStepped:Connect(u1.GyroLoop);
    local v78 = l__RunService__1.RenderStepped:Connect(u1.CosmeticLoop);
    table.insert(u64, v76);
    table.insert(u64, v77);
    table.insert(u64, v78);
end;
function u1.UnsetPlane() --[[ Line: 447 ]]
    -- upvalues: u1 (copy), u64 (ref)
    u1._plane = nil;
    u1._gasTank = nil;
    u1.Thrust = nil;
    u1.SweepAngle = nil;
    for _, v79 in u64 do
        v79:Disconnect();
    end;
    u64 = {};
end;
return u1;