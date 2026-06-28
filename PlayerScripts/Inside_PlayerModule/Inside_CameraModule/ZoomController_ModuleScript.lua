-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.ZoomController
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Popper__1 = require(script:WaitForChild("Popper"));
local l__clamp__2 = math.clamp;
local l__exp__3 = math.exp;
local l__min__4 = math.min;
local l__max__5 = math.max;
local u1 = nil;
local u2 = nil;
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
assert(l__LocalPlayer__6);
local function v3() --[[ Line: 23 ]]
    -- upvalues: u1 (ref), l__LocalPlayer__6 (copy), u2 (ref)
    u1 = l__LocalPlayer__6.CameraMinZoomDistance;
    u2 = l__LocalPlayer__6.CameraMaxZoomDistance;
end;
u1 = l__LocalPlayer__6.CameraMinZoomDistance;
u2 = l__LocalPlayer__6.CameraMaxZoomDistance;
l__LocalPlayer__6:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(v3);
l__LocalPlayer__6:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(v3);
local u4 = {};
u4.__index = u4;
function u4.new(p5, p6, p7, p8) --[[ Line: 37 ]]
    -- upvalues: l__clamp__2 (copy), u4 (copy)
    local v9 = l__clamp__2(p6, p7, p8);
    return setmetatable({
        v = 0,
        freq = p5,
        x = v9,
        minValue = p7,
        maxValue = p8,
        goal = v9
    }, u4);
end;
function u4.Step(p10, p11) --[[ Line: 49 ]]
    -- upvalues: l__exp__3 (copy)
    local v12 = p10.freq * 2 * 3.141592653589793;
    local l__x__7 = p10.x;
    local l__v__8 = p10.v;
    local l__minValue__9 = p10.minValue;
    local l__maxValue__10 = p10.maxValue;
    local l__goal__11 = p10.goal;
    local v13 = l__goal__11 - l__x__7;
    local v14 = v12 * p11;
    local v15 = l__exp__3(-v14);
    local v16 = l__goal__11 + (l__v__8 * p11 - v13 * (v14 + 1)) * v15;
    local v17 = ((v13 * v12 - l__v__8) * v14 + l__v__8) * v15;
    if v16 < l__minValue__9 then
        l__maxValue__10 = l__minValue__9;
        v17 = 0;
    elseif l__maxValue__10 < v16 then
        v17 = 0;
    else
        l__maxValue__10 = v16;
    end;
    p10.x = l__maxValue__10;
    p10.v = v17;
    return l__maxValue__10;
end;
local u18 = u4.new(4.5, 12.5, 0.5, u2);
local u19 = 0;
return {
    Update = function(p20, p21, p22) --[[ Name: Update, Line 98 ]]
        -- upvalues: u18 (copy), u19 (ref), u1 (ref), u2 (ref), l__clamp__2 (copy), l__max__5 (copy), l__Popper__1 (copy), l__min__4 (copy)
        local v23;
        if u18.goal > 1 then
            local l__x__12 = u18.x;
            local l__goal__13 = u18.goal;
            local v24 = u19;
            local v25 = u1;
            local v26 = l__clamp__2(l__goal__13 + v24 * (l__goal__13 * 0.0375 + 1), v25, u2);
            local v27 = l__max__5(l__x__12, v26 < 1 and (v24 <= 0 and v25 and v25 or 1) or v26);
            v23 = l__Popper__1(p21 * CFrame.new(0, 0, 0.5), v27 - 0.5, p22) + 0.5;
        else
            v23 = (1 / 0);
        end;
        u18.minValue = 0.5;
        u18.maxValue = l__min__4(u2, v23);
        return u18:Step(p20);
    end,
    GetZoomRadius = function() --[[ Name: GetZoomRadius, Line 122 ]]
        -- upvalues: u18 (copy)
        return u18.x;
    end,
    SetZoomParameters = function(p28, p29) --[[ Name: SetZoomParameters, Line 126 ]]
        -- upvalues: u18 (copy), u19 (ref)
        u18.goal = p28;
        u19 = p29;
    end,
    ReleaseSpring = function() --[[ Name: ReleaseSpring, Line 131 ]]
        -- upvalues: u18 (copy)
        u18.x = u18.goal;
        u18.v = 0;
    end
};