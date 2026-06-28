-- Roblox: ReplicatedStorage.WeaponProgression.ProgressionPresets.DMR
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__Modules__1 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__Util__2 = require(l__Modules__1:WaitForChild("Util"));
local u2 = {
    [2] = { "o1" },
    [3] = { "m6" },
    [4] = nil,
    [5] = { "o4" },
    [6] = { "l1" },
    [7] = nil,
    [8] = { "o6" },
    [9] = { "f1" },
    [10] = { "o15" },
    [11] = { "o10" },
    [12] = { "m5" },
    [13] = { "o7" },
    [14] = nil,
    [15] = { "o5" },
    [16] = nil,
    [17] = { "m2" },
    [18] = nil,
    [19] = { "o2" },
    [20] = { "f4" },
    [21] = nil,
    [22] = { "o8" },
    [23] = nil,
    [24] = { "l2" },
    [25] = { "o13" },
    [26] = nil,
    [27] = nil,
    [28] = nil,
    [29] = nil,
    [30] = { "f2" },
    [31] = nil,
    [32] = { "l3" },
    [33] = nil,
    [34] = { "o3" },
    [35] = nil,
    [36] = nil,
    [37] = { "m8" },
    [38] = nil,
    [39] = { "f3" },
    [40] = nil,
    [41] = nil,
    [42] = nil,
    [43] = nil,
    [44] = { "o9" },
    [45] = nil,
    [46] = nil,
    [47] = { "o11" },
    [48] = nil,
    [49] = nil,
    [50] = nil
};
function v1.getAttachments(p3, p4, p5, p6, p7) --[[ Line: 60 ]]
    -- upvalues: l__Util__2 (copy), u2 (copy)
    local v8 = l__Util__2.deepCopy(u2);
    local v9 = {
        a = { 16, 26, 41 },
        m = { 2, 12, 17 },
        l = { 6, 24, 32 },
        f = {
            9,
            20,
            30,
            39
        }
    };
    if p4 then
        for _, v10 in ipairs(v9.m) do
            v8[v10] = nil;
        end;
    end;
    if p6 then
        for _, v11 in ipairs(v9.l) do
            v8[v11] = nil;
        end;
    end;
    if p5 then
        for _, v12 in ipairs(v9.f) do
            v8[v12] = nil;
        end;
    end;
    if p7 then
        v8[24] = nil;
    end;
    if not p3 then
        return v8;
    end;
    if p3.replace then
        for v13, v14 in p3.replace do
            if v14 == "clear" then
                v8[v13] = nil;
            else
                v8[v13] = v14;
            end;
        end;
    end;
    for v15, v16 in v9 do
        if p3[v15] then
            for v17 = 1, #v16 do
                if #p3[v15] < v17 then
                    break;
                end;
                v8[v16[v17]] = { p3[v15][v17] };
            end;
        end;
    end;
    return v8;
end;
return v1;