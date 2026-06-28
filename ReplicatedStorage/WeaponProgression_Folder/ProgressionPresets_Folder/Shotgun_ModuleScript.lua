-- Roblox: ReplicatedStorage.WeaponProgression.ProgressionPresets.Shotgun
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__Modules__1 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__Util__2 = require(l__Modules__1:WaitForChild("Util"));
local u2 = {
    [3] = { "f1" },
    [5] = { "o7" },
    [6] = { "o6" },
    [7] = nil,
    [8] = { "o1" },
    [11] = { "l1" },
    [13] = { "o4" },
    [14] = nil,
    [17] = { "f2" },
    [20] = { "o6" },
    [21] = nil,
    [22] = { "l3" },
    [23] = { "o13" },
    [24] = { "m10" },
    [25] = { "o15" },
    [26] = { "f4" },
    [27] = { "o5" },
    [28] = nil,
    [30] = nil,
    [33] = { "o3" },
    [34] = { "f3" },
    [35] = nil,
    [39] = { "l2" },
    [42] = nil,
    [49] = nil
};
function v1.getAttachments(p3, p4, p5) --[[ Line: 36 ]]
    -- upvalues: l__Util__2 (copy), u2 (copy)
    local v6 = l__Util__2.deepCopy(u2);
    if p4 then
        v6[24] = nil;
    end;
    if p5 then
        v6[3] = nil;
        v6[17] = nil;
        v6[26] = nil;
        v6[34] = nil;
    end;
    if not p3 then
        return v6;
    end;
    local v7 = {
        a = { 11, 26, 41 }
    };
    if p3.replace then
        for v8, v9 in p3.replace do
            if v9 == "clear" then
                v6[v8] = nil;
            else
                v6[v8] = v9;
            end;
        end;
    end;
    for v10, v11 in v7 do
        if p3[v10] then
            for v12 = 1, #v11 do
                if #p3[v10] < v12 then
                    break;
                end;
                v6[v11[v12]] = { p3[v10][v12] };
            end;
        end;
    end;
    return v6;
end;
return v1;