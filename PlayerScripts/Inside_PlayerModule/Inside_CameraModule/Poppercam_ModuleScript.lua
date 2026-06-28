-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.Poppercam
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ZoomController__1 = require(script.Parent:WaitForChild("ZoomController"));
local u1 = {};
u1.__index = u1;
local u2 = CFrame.new();
function u1.new() --[[ Line: 31 ]]
    -- upvalues: u1 (copy)
    return setmetatable({
        lastCFrame = nil
    }, u1);
end;
function u1.Step(p3, p4, p5) --[[ Line: 37 ]]
    -- upvalues: u2 (copy)
    local v6 = p3.lastCFrame or p5;
    p3.lastCFrame = p5;
    local l__Position__2 = p5.Position;
    local _, _, _, v7, v8, v9, v10, v11, v12, v13, v14, v15 = p5:GetComponents();
    local u16 = CFrame.new(0, 0, 0, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    local l__p__3 = v6.p;
    local _, _, _, v17, v18, v19, v20, v21, v22, v23, v24, v25 = v6:GetComponents();
    local v26 = CFrame.new(0, 0, 0, v17, v18, v19, v20, v21, v22, v23, v24, v25);
    local u27 = (l__Position__2 - l__p__3) / p4;
    local v28, v29 = (u16 * v26:inverse()):ToAxisAngle();
    local u30 = v28 * v29 / p4;
    return {
        extrapolate = function(p31) --[[ Name: extrapolate, Line 52 ]]
            -- upvalues: u27 (copy), l__Position__2 (copy), u30 (copy), u2 (ref), u16 (copy)
            local v32 = u27 * p31 + l__Position__2;
            local v33 = u30 * p31;
            local l__Magnitude__4 = v33.Magnitude;
            local v34;
            if l__Magnitude__4 > 0.00001 then
                v34 = CFrame.fromAxisAngle(v33, l__Magnitude__4);
            else
                v34 = u2;
            end;
            return v34 * u16 + v32;
        end,
        posVelocity = u27,
        rotVelocity = u30
    };
end;
function u1.Reset(p35) --[[ Line: 65 ]]
    p35.lastCFrame = nil;
end;
local l__BaseOcclusion__5 = require(script.Parent:WaitForChild("BaseOcclusion"));
local u36 = setmetatable({}, l__BaseOcclusion__5);
u36.__index = u36;
function u36.new() --[[ Line: 75 ]]
    -- upvalues: l__BaseOcclusion__5 (copy), u36 (copy), u1 (copy)
    local v37 = l__BaseOcclusion__5.new();
    local v38 = setmetatable(v37, u36);
    v38.focusExtrapolator = u1.new();
    return v38;
end;
function u36.GetOcclusionMode(_) --[[ Line: 81 ]]
    return Enum.DevCameraOcclusionMode.Zoom;
end;
function u36.Enable(p39, _) --[[ Line: 85 ]]
    p39.focusExtrapolator:Reset();
end;
function u36.Update(p40, p41, p42, p43, _) --[[ Line: 89 ]]
    -- upvalues: l__ZoomController__1 (copy)
    local v44 = CFrame.new(p43.p, p42.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
    local v45 = p40.focusExtrapolator:Step(p41, v44);
    local v46 = l__ZoomController__1.Update(p41, v44, v45);
    return v44 * CFrame.new(0, 0, v46), p43;
end;
function u36.CharacterAdded(_, _, _) --[[ Line: 102 ]] end;
function u36.CharacterRemoving(_, _, _) --[[ Line: 106 ]] end;
function u36.OnCameraSubjectChanged(_, _) --[[ Line: 109 ]] end;
return u36;