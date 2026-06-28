-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__CameraUtils__1 = require(script.Parent.Parent.CameraUtils);
local l__VehicleCameraConfig__2 = require(script.Parent.VehicleCameraConfig);
local l__map__3 = l__CameraUtils__1.map;
local l__mapClamp__4 = l__CameraUtils__1.mapClamp;
local l__sanitizeAngle__5 = l__CameraUtils__1.sanitizeAngle;
local u1 = {};
u1.__index = u1;
function u1.new(p2, p3, p4) --[[ Line: 36 ]]
    -- upvalues: u1 (copy)
    return setmetatable({
        fRising = p2,
        fFalling = p3,
        g = p4,
        p = p4,
        v = p4 * 0
    }, u1);
end;
function u1.step(p5, p6) --[[ Line: 46 ]]
    local l__fRising__6 = p5.fRising;
    local l__fFalling__7 = p5.fFalling;
    local l__g__8 = p5.g;
    local l__p__9 = p5.p;
    local l__v__10 = p5.v;
    local v7 = 6.283185307179586;
    if l__v__10 > 0 then
        l__fFalling__7 = l__fRising__6 or l__fFalling__7;
    end;
    local v8 = v7 * l__fFalling__7;
    local v9 = l__p__9 - l__g__8;
    local v10 = math.exp(-v8 * p6);
    local v11 = (v9 * (1 + v8 * p6) + l__v__10 * p6) * v10 + l__g__8;
    local v12 = (l__v__10 * (1 - v8 * p6) - v9 * (v8 * v8 * p6)) * v10;
    p5.p = v11;
    p5.v = v12;
    return v11;
end;
local u13 = {};
u13.__index = u13;
function u13.new(p14) --[[ Line: 72 ]]
    -- upvalues: l__sanitizeAngle__5 (copy), u1 (copy), l__VehicleCameraConfig__2 (copy), u13 (copy)
    local v15 = typeof(p14) == "CFrame";
    assert(v15);
    local v16 = {
        yawV = 0,
        pitchV = 0
    };
    local _, v17 = p14:toEulerAnglesYXZ();
    v16.yawG = l__sanitizeAngle__5(v17);
    local _, v18 = p14:toEulerAnglesYXZ();
    v16.yawP = l__sanitizeAngle__5(v18);
    v16.pitchG = l__sanitizeAngle__5((p14:toEulerAnglesYXZ()));
    v16.pitchP = l__sanitizeAngle__5((p14:toEulerAnglesYXZ()));
    v16.fSpringYaw = u1.new(l__VehicleCameraConfig__2.yawReponseDampingRising, l__VehicleCameraConfig__2.yawResponseDampingFalling, 0);
    v16.fSpringPitch = u1.new(l__VehicleCameraConfig__2.pitchReponseDampingRising, l__VehicleCameraConfig__2.pitchResponseDampingFalling, 0);
    return setmetatable(v16, u13);
end;
function u13.setGoal(p19, p20) --[[ Line: 99 ]]
    -- upvalues: l__sanitizeAngle__5 (copy)
    local v21 = typeof(p20) == "CFrame";
    assert(v21);
    local _, v22 = p20:toEulerAnglesYXZ();
    p19.yawG = l__sanitizeAngle__5(v22);
    p19.pitchG = l__sanitizeAngle__5((p20:toEulerAnglesYXZ()));
end;
function u13.getCFrame(p23) --[[ Line: 106 ]]
    return CFrame.fromEulerAnglesYXZ(p23.pitchP, p23.yawP, 0);
end;
function u13.step(p24, p25, p26, p27, p28) --[[ Line: 110 ]]
    -- upvalues: l__mapClamp__4 (copy), l__map__3 (copy), l__VehicleCameraConfig__2 (copy), l__sanitizeAngle__5 (copy)
    local v29 = typeof(p25) == "number";
    assert(v29);
    local v30 = typeof(p27) == "number";
    assert(v30);
    local v31 = typeof(p26) == "number";
    assert(v31);
    local v32 = typeof(p28) == "number";
    assert(v32);
    local l__fSpringYaw__11 = p24.fSpringYaw;
    local l__fSpringPitch__12 = p24.fSpringPitch;
    l__fSpringYaw__11.g = l__mapClamp__4(l__map__3(p28, 0, 1, p27, 0), math.rad(l__VehicleCameraConfig__2.cutoffMinAngularVelYaw), math.rad(l__VehicleCameraConfig__2.cutoffMaxAngularVelYaw), 1, 0);
    l__fSpringPitch__12.g = l__mapClamp__4(l__map__3(p28, 0, 1, p26, 0), math.rad(l__VehicleCameraConfig__2.cutoffMinAngularVelPitch), math.rad(l__VehicleCameraConfig__2.cutoffMaxAngularVelPitch), 1, 0);
    local v33 = 6.283185307179586 * l__VehicleCameraConfig__2.yawStiffness * l__fSpringYaw__11:step(p25);
    local v34 = 6.283185307179586 * l__VehicleCameraConfig__2.pitchStiffness * l__fSpringPitch__12:step(p25) * l__map__3(p28, 0, 1, 1, l__VehicleCameraConfig__2.firstPersonResponseMul);
    local v35 = v33 * l__map__3(p28, 0, 1, 1, l__VehicleCameraConfig__2.firstPersonResponseMul);
    local l__yawG__13 = p24.yawG;
    local l__yawP__14 = p24.yawP;
    local l__yawV__15 = p24.yawV;
    local v36 = l__sanitizeAngle__5(l__yawP__14 - l__yawG__13);
    local v37 = math.exp(-v35 * p25);
    local v38 = l__sanitizeAngle__5((v36 * (1 + v35 * p25) + l__yawV__15 * p25) * v37 + l__yawG__13);
    local v39 = (l__yawV__15 * (1 - v35 * p25) - v36 * (v35 * v35 * p25)) * v37;
    p24.yawP = v38;
    p24.yawV = v39;
    local l__pitchG__16 = p24.pitchG;
    local l__pitchP__17 = p24.pitchP;
    local l__pitchV__18 = p24.pitchV;
    local v40 = l__sanitizeAngle__5(l__pitchP__17 - l__pitchG__16);
    local v41 = math.exp(-v34 * p25);
    local v42 = l__sanitizeAngle__5((v40 * (1 + v34 * p25) + l__pitchV__18 * p25) * v41 + l__pitchG__16);
    local v43 = (l__pitchV__18 * (1 - v34 * p25) - v40 * (v34 * v34 * p25)) * v41;
    p24.pitchP = v42;
    p24.pitchV = v43;
    return p24:getCFrame();
end;
local u44 = {};
u44.__index = u44;
function u44.new(p45) --[[ Line: 167 ]]
    -- upvalues: u13 (copy), u44 (copy)
    local v46 = {
        vrs = u13.new(p45)
    };
    return setmetatable(v46, u44);
end;
function u44.step(p47, p48, p49, p50, p51) --[[ Line: 173 ]]
    return p47.vrs:step(p48, p49, p50, p51);
end;
function u44.setTransform(p52, p53) --[[ Line: 177 ]]
    p52.vrs:setGoal(p53);
end;
return u44;