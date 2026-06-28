-- Roblox: Workspace.SilverAce293026.TankWeapons.MotorDelegates.Common
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    GetRelativeRotationZ = function(p1, p2) --[[ Name: GetRelativeRotationZ, Line 3 ]]
        local _, v3, _ = p1:ToOrientation();
        local v4 = CFrame.new(p1.Position) * CFrame.fromOrientation(0, v3, 0);
        local v5 = v4:VectorToObjectSpace(p2 - v4.Position);
        local v6 = math.atan2(v5.X, v5.Z);
        return math.deg(v6) + 180;
    end,
    GetRelativeRotationY = function(p7, p8) --[[ Name: GetRelativeRotationY, Line 14 ]]
        local v9 = p7:VectorToObjectSpace(p8 - p7.Position);
        local l__Y__1 = v9.Y;
        local l__X__2 = v9.X;
        local l__Z__3 = v9.Z;
        local v10 = math.sqrt(l__X__2 * l__X__2 + l__Z__3 * l__Z__3);
        local v11 = math.atan2(l__Y__1, v10);
        return math.deg(v11);
    end
};