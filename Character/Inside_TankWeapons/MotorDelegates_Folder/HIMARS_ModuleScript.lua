-- Roblox: Workspace.SilverAce293026.TankWeapons.MotorDelegates.HIMARS
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__Common__1 = require(script.Parent:WaitForChild("Common"));
function v1.Tick(_, p2, p3) --[[ Line: 8 ]]
    -- upvalues: l__Common__1 (copy)
    local v4 = l__Common__1.GetRelativeRotationZ(p2.XPart.CFrame, p3);
    local l__YPart__2 = p2.YPart;
    local l__Magnitude__3 = (l__YPart__2.Position - Vector3.new(p3.X, l__YPart__2.Position.Y, p3.Z)).Magnitude;
    local l__CFrame__4 = l__YPart__2.CFrame;
    local l__Position__5 = (l__CFrame__4 + l__CFrame__4.LookVector * l__Magnitude__3).Position;
    local v5 = Vector3.new(l__Position__5.X, p3.Y, l__Position__5.Z);
    local v6 = l__CFrame__4.Position:Lerp(v5, 0.5);
    local v7 = 0;
    if l__Magnitude__3 > 80 then
        v7 = l__Magnitude__3 / 2000 * 500;
    elseif l__Magnitude__3 < 40 then
        return 0, 0;
    end;
    local v8 = v6 + Vector3.new(0, v7, 0);
    return v4, l__Common__1.GetRelativeRotationY(l__YPart__2.CFrame, v8);
end;
function v1.GetAimPos(_, p9, p10, _) --[[ Line: 33 ]]
    local l__YPart__6 = p9.YPart;
    local l__Magnitude__7 = (l__YPart__6.Position - Vector3.new(p10.X, l__YPart__6.Position.Y, p10.Z)).Magnitude;
    local l__CFrame__8 = l__YPart__6.CFrame;
    local l__Position__9 = (l__CFrame__8 + l__CFrame__8.LookVector * l__Magnitude__7).Position;
    local v11 = Vector3.new(l__Position__9.X, p10.Y, l__Position__9.Z);
    return l__CFrame__8.Position:Lerp(v11, 0.5) + Vector3.new(0, l__Magnitude__7 <= 80 and 0 or l__Magnitude__7 / 2000 * 500, 0);
end;
function v1.GetPredictiveAimPos(_, p12, p13, _) --[[ Line: 52 ]]
    local l__YPart__10 = p12.YPart;
    local v14 = Vector3.new(p13.X, l__YPart__10.Position.Y, p13.Z);
    local l__Magnitude__11 = (l__YPart__10.Position - v14).Magnitude;
    local l__CFrame__12 = l__YPart__10.CFrame;
    local l__Position__13 = (l__CFrame__12 + (v14 - l__CFrame__12.Position).Unit * l__Magnitude__11).Position;
    local v15 = Vector3.new(l__Position__13.X, p13.Y, l__Position__13.Z);
    return l__CFrame__12.Position:Lerp(v15, 0.5) + Vector3.new(0, l__Magnitude__11 <= 80 and 0 or l__Magnitude__11 / 2000 * 500, 0);
end;
function v1.GetTargetPos(_, _, p16) --[[ Line: 74 ]]
    return p16;
end;
return v1;