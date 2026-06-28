-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.CameraUtils
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__UserGameSettings__3 = UserSettings():GetService("UserGameSettings");
local u1 = {};
local u2 = {};
u2.__index = u2;
function u2.new(p3, p4) --[[ Line: 21 ]]
    -- upvalues: u2 (copy)
    return setmetatable({
        vel = 0,
        freq = p3,
        goal = p4,
        pos = p4
    }, u2);
end;
function u2.step(p5, p6) --[[ Line: 31 ]]
    local v7 = p5.freq * 2 * 3.141592653589793;
    local l__goal__4 = p5.goal;
    local l__pos__5 = p5.pos;
    local l__vel__6 = p5.vel;
    local v8 = l__pos__5 - l__goal__4;
    local v9 = math.exp(-v7 * p6);
    local v10 = (v8 * (v7 * p6 + 1) + l__vel__6 * p6) * v9 + l__goal__4;
    local v11 = (l__vel__6 * (1 - v7 * p6) - v8 * (v7 * v7 * p6)) * v9;
    p5.pos = v10;
    p5.vel = v11;
    return v10;
end;
u1.Spring = u2;
function u1.map(p12, p13, p14, p15, p16) --[[ Line: 53 ]]
    return (p12 - p13) * (p16 - p15) / (p14 - p13) + p15;
end;
function u1.mapClamp(p17, p18, p19, p20, p21) --[[ Line: 58 ]]
    local v22 = (p17 - p18) * (p21 - p20) / (p19 - p18) + p20;
    local v23 = math.min(p20, p21);
    local v24 = math.max(p20, p21);
    return math.clamp(v22, v23, v24);
end;
function u1.getLooseBoundingSphere(p25) --[[ Line: 67 ]]
    local v26 = table.create(#p25);
    for v27, v28 in pairs(p25) do
        v26[v27] = v28.Position;
    end;
    local v29 = v26[1];
    local v30 = v29;
    local v31 = 0;
    for _, v32 in ipairs(v26) do
        local l__Magnitude__7 = (v32 - v29).Magnitude;
        if v31 < l__Magnitude__7 then
            v30 = v32;
            v31 = l__Magnitude__7;
        end;
    end;
    local v33 = v30;
    local v34 = 0;
    for _, v35 in ipairs(v26) do
        local l__Magnitude__8 = (v35 - v30).Magnitude;
        if v34 < l__Magnitude__8 then
            v33 = v35;
            v34 = l__Magnitude__8;
        end;
    end;
    local v36 = (v30 + v33) * 0.5;
    local v37 = (v30 - v33).Magnitude * 0.5;
    for _, v38 in ipairs(v26) do
        local l__Magnitude__9 = (v38 - v36).Magnitude;
        if v37 < l__Magnitude__9 then
            v36 = v36 + (l__Magnitude__9 - v37) * 0.5 * (v38 - v36).Unit;
            v37 = (l__Magnitude__9 + v37) * 0.5;
        end;
    end;
    return v36, v37;
end;
function u1.sanitizeAngle(p39) --[[ Line: 123 ]]
    return (p39 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
end;
function u1.Round(p40, p41) --[[ Line: 128 ]]
    local v42 = 10 ^ p41;
    return math.floor(p40 * v42 + 0.5) / v42;
end;
function u1.IsFinite(p43) --[[ Line: 133 ]]
    local v44;
    if p43 == p43 and p43 ~= (1 / 0) then
        v44 = p43 ~= (-1 / 0);
    else
        v44 = false;
    end;
    return v44;
end;
function u1.IsFiniteVector3(p45) --[[ Line: 137 ]]
    -- upvalues: u1 (copy)
    local v46 = u1.IsFinite(p45.X) and u1.IsFinite(p45.Y);
    if v46 then
        v46 = u1.IsFinite(p45.Z);
    end;
    return v46;
end;
function u1.GetAngleBetweenXZVectors(p47, p48) --[[ Line: 142 ]]
    return math.atan2(p48.X * p47.Z - p48.Z * p47.X, p48.X * p47.X + p48.Z * p47.Z);
end;
function u1.RotateVectorByAngleAndRound(p49, p50, p51) --[[ Line: 146 ]]
    if p49.Magnitude <= 0 then
        return 0;
    end;
    local l__Unit__10 = p49.Unit;
    local v52 = math.atan2(l__Unit__10.Z, l__Unit__10.X);
    local v53 = (math.atan2(l__Unit__10.Z, l__Unit__10.X) + p50) / p51 + 0.5;
    return math.floor(v53) * p51 - v52;
end;
function u1.GamepadLinearToCurve(p54) --[[ Line: 177 ]]
    local l__new__11 = Vector2.new;
    local l__X__12 = p54.X;
    local v55 = l__X__12 < 0 and -1 or 1;
    local v56 = math.abs(l__X__12);
    local v57 = (math.abs(v56) * 2 - 1) * 1.1 - 0.1;
    local v58 = math.clamp(v57, -1, 1);
    local v59;
    if v58 >= 0 then
        v59 = v58 * 0.35 / (0.35 - v58 + 1);
    else
        v59 = -(-v58 * 0.8 / (v58 + 0.8 + 1));
    end;
    local v60 = math.clamp((v59 / 2 + 0.5) * v55, -1, 1);
    local l__Y__13 = p54.Y;
    local v61 = l__Y__13 < 0 and -1 or 1;
    local v62 = math.abs(l__Y__13);
    local v63 = (math.abs(v62) * 2 - 1) * 1.1 - 0.1;
    local v64 = math.clamp(v63, -1, 1);
    local v65;
    if v64 >= 0 then
        v65 = v64 * 0.35 / (0.35 - v64 + 1);
    else
        v65 = -(-v64 * 0.8 / (v64 + 0.8 + 1));
    end;
    return l__new__11(v60, (math.clamp((v65 / 2 + 0.5) * v61, -1, 1)));
end;
function u1.ConvertCameraModeEnumToStandard(p66) --[[ Line: 191 ]]
    if p66 == Enum.TouchCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Follow;
    elseif p66 == Enum.ComputerCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Classic;
    elseif p66 == Enum.TouchCameraMovementMode.Classic or (p66 == Enum.DevTouchCameraMovementMode.Classic or (p66 == Enum.DevComputerCameraMovementMode.Classic or p66 == Enum.ComputerCameraMovementMode.Classic)) then
        return Enum.ComputerCameraMovementMode.Classic;
    elseif p66 == Enum.TouchCameraMovementMode.Follow or (p66 == Enum.DevTouchCameraMovementMode.Follow or (p66 == Enum.DevComputerCameraMovementMode.Follow or p66 == Enum.ComputerCameraMovementMode.Follow)) then
        return Enum.ComputerCameraMovementMode.Follow;
    elseif p66 == Enum.TouchCameraMovementMode.Orbital or (p66 == Enum.DevTouchCameraMovementMode.Orbital or (p66 == Enum.DevComputerCameraMovementMode.Orbital or p66 == Enum.ComputerCameraMovementMode.Orbital)) then
        return Enum.ComputerCameraMovementMode.Orbital;
    elseif p66 == Enum.ComputerCameraMovementMode.CameraToggle or p66 == Enum.DevComputerCameraMovementMode.CameraToggle then
        return Enum.ComputerCameraMovementMode.CameraToggle;
    elseif p66 == Enum.DevTouchCameraMovementMode.UserChoice or p66 == Enum.DevComputerCameraMovementMode.UserChoice then
        return Enum.DevComputerCameraMovementMode.UserChoice;
    else
        return Enum.ComputerCameraMovementMode.Classic;
    end;
end;
local u67 = "";
local u68 = nil;
function u1.setMouseIconOverride(p69) --[[ Line: 252 ]]
    -- upvalues: l__Players__1 (copy), u68 (ref), u67 (ref)
    local l__LocalPlayer__14 = l__Players__1.LocalPlayer;
    if not l__LocalPlayer__14 then
        l__Players__1:GetPropertyChangedSignal("LocalPlayer"):Wait();
        l__LocalPlayer__14 = l__Players__1.LocalPlayer;
    end;
    assert(l__LocalPlayer__14);
    local v70 = l__LocalPlayer__14:GetMouse();
    if v70.Icon ~= u68 then
        u67 = v70.Icon;
    end;
    v70.Icon = p69;
    u68 = p69;
end;
function u1.restoreMouseIcon() --[[ Line: 263 ]]
    -- upvalues: l__Players__1 (copy), u68 (ref), u67 (ref)
    local l__LocalPlayer__15 = l__Players__1.LocalPlayer;
    if not l__LocalPlayer__15 then
        l__Players__1:GetPropertyChangedSignal("LocalPlayer"):Wait();
        l__LocalPlayer__15 = l__Players__1.LocalPlayer;
    end;
    assert(l__LocalPlayer__15);
    local v71 = l__LocalPlayer__15:GetMouse();
    if v71.Icon == u68 then
        v71.Icon = u67;
    end;
    u68 = nil;
end;
local l__Default__16 = Enum.MouseBehavior.Default;
local u72 = nil;
function u1.setMouseBehaviorOverride(p73) --[[ Line: 274 ]]
    -- upvalues: l__UserInputService__2 (copy), u72 (ref), l__Default__16 (ref)
    if l__UserInputService__2.MouseBehavior ~= u72 then
        l__Default__16 = l__UserInputService__2.MouseBehavior;
    end;
    l__UserInputService__2.MouseBehavior = p73;
    u72 = p73;
end;
function u1.restoreMouseBehavior() --[[ Line: 283 ]]
    -- upvalues: l__UserInputService__2 (copy), u72 (ref), l__Default__16 (ref)
    if l__UserInputService__2.MouseBehavior == u72 then
        l__UserInputService__2.MouseBehavior = l__Default__16;
    end;
    u72 = nil;
end;
local l__MovementRelative__17 = Enum.RotationType.MovementRelative;
local u74 = nil;
function u1.setRotationTypeOverride(p75) --[[ Line: 292 ]]
    -- upvalues: l__UserGameSettings__3 (copy), u74 (ref), l__MovementRelative__17 (ref)
    if l__UserGameSettings__3.RotationType ~= u74 then
        l__MovementRelative__17 = l__UserGameSettings__3.RotationType;
    end;
    l__UserGameSettings__3.RotationType = p75;
    u74 = p75;
end;
function u1.restoreRotationType() --[[ Line: 301 ]]
    -- upvalues: l__UserGameSettings__3 (copy), u74 (ref), l__MovementRelative__17 (ref)
    if l__UserGameSettings__3.RotationType == u74 then
        l__UserGameSettings__3.RotationType = l__MovementRelative__17;
    end;
    u74 = nil;
end;
return u1;