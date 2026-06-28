-- Roblox: ReplicatedStorage.WeaponProgression.ProgressionPresets.Sniper
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__Modules__1 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__Util__2 = require(l__Modules__1:WaitForChild("Util"));
local u2 = {
    [0] = { "o10" },
    [3] = { "m4" },
    [5] = nil,
    [8] = nil,
    [9] = { "o5" },
    [10] = nil,
    [11] = { "m5" },
    [16] = nil,
    [15] = nil,
    [23] = { "m2" },
    [20] = nil,
    [24] = nil,
    [25] = nil,
    [27] = { "m8" },
    [31] = { "o11" },
    [30] = nil,
    [35] = nil
};
function v1.getAttachments(p3, p4) --[[ Line: 29 ]]
    -- upvalues: l__Util__2 (copy), u2 (copy)
    local v5 = l__Util__2.deepCopy(u2);
    local v6 = {
        m = {
            3,
            11,
            23,
            27
        },
        a = { 8, 16, 24 },
        o = {
            0,
            3,
            9,
            31
        }
    };
    if p4 then
        for _, v7 in ipairs(v6.m) do
            v5[v7] = nil;
        end;
    end;
    if not p3 then
        return v5;
    end;
    if p3.replace then
        for v8, v9 in p3.replace do
            if v9 == "clear" then
                v5[v8] = nil;
            else
                v5[v8] = v9;
            end;
        end;
    end;
    for v10, v11 in v6 do
        if p3[v10] then
            for v12 = 1, #v11 do
                if #p3[v10] < v12 then
                    break;
                end;
                v5[v11[v12]] = { p3[v10][v12] };
            end;
        end;
    end;
    return v5;
end;
return v1;