-- Roblox: ReplicatedStorage.WeaponProgression.ProgressionPresets.Pistol
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__Modules__1 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__Util__2 = require(l__Modules__1:WaitForChild("Util"));
local u2 = {
    [2] = { "m4" },
    [4] = { "o12" },
    [5] = nil,
    [6] = { "l5" },
    [7] = { "o14" },
    [8] = nil,
    [10] = nil,
    [12] = { "l7" },
    [14] = { "m1" },
    [15] = nil,
    [16] = nil,
    [20] = nil,
    [21] = { "l6" },
    [25] = nil,
    [29] = { "m3" },
    [30] = nil,
    [31] = nil,
    [35] = nil
};
function v1.getAttachments(p3) --[[ Line: 29 ]]
    -- upvalues: l__Util__2 (copy), u2 (copy)
    local v4 = l__Util__2.deepCopy(u2);
    if not p3 then
        return v4;
    end;
    local v5 = {
        a = { 8, 16, 31 }
    };
    if p3.replace then
        for v6, v7 in p3.replace do
            if v7 == "clear" then
                v4[v6] = nil;
            else
                v4[v6] = v7;
            end;
        end;
    end;
    for v8, v9 in v5 do
        if p3[v8] then
            for v10 = 1, #v9 do
                if #p3[v8] < v10 then
                    break;
                end;
                v4[v9[v10]] = { p3[v8][v10] };
            end;
        end;
    end;
    return v4;
end;
return v1;