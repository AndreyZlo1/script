-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.VehicleCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = { 0, 15, 30 };
local l__Players__1 = game:GetService("Players");
local l__RunService__2 = game:GetService("RunService");
local l__BaseCamera__3 = require(script.Parent:WaitForChild("BaseCamera"));
local l__CameraInput__4 = require(script.Parent:WaitForChild("CameraInput"));
local l__CameraUtils__5 = require(script.Parent:WaitForChild("CameraUtils"));
require(script.Parent:WaitForChild("ZoomController"));
local l__VehicleCameraCore__6 = require(script:WaitForChild("VehicleCameraCore"));
local l__VehicleCameraConfig__7 = require(script:WaitForChild("VehicleCameraConfig"));
local l__LocalPlayer__8 = l__Players__1.LocalPlayer;
local _ = l__CameraUtils__5.map;
local l__Spring__9 = l__CameraUtils__5.Spring;
local l__mapClamp__10 = l__CameraUtils__5.mapClamp;
local l__sanitizeAngle__11 = l__CameraUtils__5.sanitizeAngle;
local u2 = 0.016666666666666666;
l__RunService__2.Stepped:Connect(function(_, p3) --[[ Line: 42 ]]
    -- upvalues: u2 (ref)
    u2 = p3;
end);
local u4 = setmetatable({}, l__BaseCamera__3);
u4.__index = u4;
function u4.new() --[[ Line: 49 ]]
    -- upvalues: l__BaseCamera__3 (copy), u4 (copy)
    local v5 = l__BaseCamera__3.new();
    local v6 = setmetatable(v5, u4);
    v6:Reset();
    return v6;
end;
function u4.Reset(p7) --[[ Line: 55 ]]
    -- upvalues: l__VehicleCameraCore__6 (copy), l__Spring__9 (copy), l__VehicleCameraConfig__7 (copy), l__CameraUtils__5 (copy), u1 (copy)
    p7.vehicleCameraCore = l__VehicleCameraCore__6.new(p7:GetSubjectCFrame());
    p7.pitchSpring = l__Spring__9.new(0, -math.rad(l__VehicleCameraConfig__7.pitchBaseAngle));
    p7.yawSpring = l__Spring__9.new(0, 0);
    p7.lastPanTick = 0;
    local l__CurrentCamera__12 = workspace.CurrentCamera;
    local v8;
    if l__CurrentCamera__12 then
        v8 = l__CurrentCamera__12.CameraSubject;
    else
        v8 = l__CurrentCamera__12;
    end;
    assert(l__CurrentCamera__12);
    assert(v8);
    assert(v8:IsA("VehicleSeat"));
    local v9 = v8:GetConnectedParts(true);
    local v10, v11 = l__CameraUtils__5.getLooseBoundingSphere(v9);
    p7.assemblyRadius = math.max(v11, 5);
    p7.assemblyOffset = v8.CFrame:Inverse() * v10;
    p7.gamepadZoomLevels = {};
    for _, v12 in u1 do
        table.insert(p7.gamepadZoomLevels, v12 * p7.assemblyRadius / 10);
    end;
    p7:SetCameraToSubjectDistance(p7.gamepadZoomLevels[#p7.gamepadZoomLevels]);
end;
function u4._StepRotation(p13, p14, p15) --[[ Line: 85 ]]
    -- upvalues: l__CameraInput__4 (copy), l__sanitizeAngle__11 (copy), l__VehicleCameraConfig__7 (copy), l__mapClamp__10 (copy)
    local l__yawSpring__13 = p13.yawSpring;
    local l__pitchSpring__14 = p13.pitchSpring;
    local v16 = l__CameraInput__4.getRotation(true);
    local v17 = -v16.X;
    local v18 = -v16.Y;
    l__yawSpring__13.pos = l__sanitizeAngle__11(l__yawSpring__13.pos + v17);
    l__pitchSpring__14.pos = l__sanitizeAngle__11((math.clamp(l__pitchSpring__14.pos + v18, -1.3962634015954636, 1.3962634015954636)));
    if l__CameraInput__4.getRotationActivated() then
        p13.lastPanTick = os.clock();
    end;
    local v19 = -math.rad(l__VehicleCameraConfig__7.pitchBaseAngle);
    local v20 = math.rad(l__VehicleCameraConfig__7.pitchDeadzoneAngle);
    if os.clock() - p13.lastPanTick > l__VehicleCameraConfig__7.autocorrectDelay then
        local v21 = l__mapClamp__10(p15, l__VehicleCameraConfig__7.autocorrectMinCarSpeed, l__VehicleCameraConfig__7.autocorrectMaxCarSpeed, 0, l__VehicleCameraConfig__7.autocorrectResponse);
        l__yawSpring__13.freq = v21;
        l__pitchSpring__14.freq = v21;
        if l__yawSpring__13.freq < 0.001 then
            l__yawSpring__13.vel = 0;
        end;
        if l__pitchSpring__14.freq < 0.001 then
            l__pitchSpring__14.vel = 0;
        end;
        local v22 = l__sanitizeAngle__11(v19 - l__pitchSpring__14.pos);
        if math.abs(v22) <= v20 then
            l__pitchSpring__14.goal = l__pitchSpring__14.pos;
        else
            l__pitchSpring__14.goal = v19;
        end;
    else
        l__yawSpring__13.freq = 0;
        l__yawSpring__13.vel = 0;
        l__pitchSpring__14.freq = 0;
        l__pitchSpring__14.vel = 0;
        l__pitchSpring__14.goal = v19;
    end;
    return CFrame.fromEulerAnglesYXZ(l__pitchSpring__14:step(p14), l__yawSpring__13:step(p14), 0);
end;
function u4._GetThirdPersonLocalOffset(p23) --[[ Line: 148 ]]
    -- upvalues: l__VehicleCameraConfig__7 (copy)
    return p23.assemblyOffset + Vector3.new(0, p23.assemblyRadius * l__VehicleCameraConfig__7.verticalCenterOffset, 0);
end;
function u4._GetFirstPersonLocalOffset(p24, p25) --[[ Line: 152 ]]
    -- upvalues: l__LocalPlayer__8 (copy)
    local l__Character__15 = l__LocalPlayer__8.Character;
    if l__Character__15 and l__Character__15.Parent then
        local v26 = l__Character__15:FindFirstChild("Head");
        if v26 and v26:IsA("BasePart") then
            return p25:Inverse() * v26.Position;
        end;
    end;
    return p24:_GetThirdPersonLocalOffset();
end;
function u4.Update(p27) --[[ Line: 166 ]]
    -- upvalues: u2 (ref), l__mapClamp__10 (copy)
    local l__CurrentCamera__16 = workspace.CurrentCamera;
    local v28;
    if l__CurrentCamera__16 then
        v28 = l__CurrentCamera__16.CameraSubject;
    else
        v28 = l__CurrentCamera__16;
    end;
    local l__vehicleCameraCore__17 = p27.vehicleCameraCore;
    assert(l__CurrentCamera__16);
    assert(v28);
    assert(v28:IsA("VehicleSeat"));
    local v29 = u2;
    u2 = 0;
    local v30 = p27:GetSubjectCFrame();
    local v31 = p27:GetSubjectVelocity();
    local v32 = p27:GetSubjectRotVelocity();
    local v33 = v31:Dot(v30.ZVector);
    local v34 = math.abs(v33);
    local v35 = v30.YVector:Dot(v32);
    local v36 = math.abs(v35);
    local v37 = v30.XVector:Dot(v32);
    local v38 = math.abs(v37);
    local v39 = p27:StepZoom();
    local v40 = p27:_StepRotation(v29, v34);
    local v41 = l__mapClamp__10(v39, 0.5, p27.assemblyRadius, 1, 0);
    local v42 = p27:_GetThirdPersonLocalOffset():Lerp(p27:_GetFirstPersonLocalOffset(v30), v41);
    l__vehicleCameraCore__17:setTransform(v30);
    local v43 = l__vehicleCameraCore__17:step(v29, v38, v36, v41);
    local v44 = CFrame.new(v30 * v42) * v43 * v40;
    return v44 * CFrame.new(0, 0, v39), v44;
end;
function u4.ApplyVRTransform(_) --[[ Line: 211 ]] end;
return u4;