-- Roblox: ReplicatedStorage.WeaponProgression.ExpLevels
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
u1.debugToggle = require(l__ReplicatedStorage__1:WaitForChild("ReplicatedConfig")).AttachmentsDebug.ShortLevels;
u1.levelExpMap = {};
u1.levelExpMap[0] = 0;
u1.levelExpMap[1] = 100;
u1.levelExpMap[2] = 150;
u1.levelExpMap[3] = 200;
u1.levelExpMap[4] = 250;
u1.levelExpMap[5] = 300;
u1.levelExpMap[6] = 350;
u1.levelExpMap[7] = 400;
u1.levelExpMap[8] = 450;
u1.levelExpMap[9] = 500;
u1.levelExpMap[10] = 500;
u1.levelExpMap[11] = 500;
u1.levelExpMap[12] = 500;
u1.levelExpMap[13] = 500;
u1.levelExpMap[14] = 500;
u1.levelExpMap[15] = 500;
u1.levelExpMap[16] = 500;
u1.levelExpMap[17] = 500;
u1.levelExpMap[18] = 500;
u1.levelExpMap[19] = 500;
u1.levelExpMap[20] = 500;
u1.levelExpMap[21] = 500;
u1.levelExpMap[22] = 500;
u1.levelExpMap[23] = 500;
u1.levelExpMap[24] = 500;
u1.levelExpMap[25] = 500;
u1.levelExpMap[26] = 500;
u1.levelExpMap[27] = 500;
u1.levelExpMap[28] = 500;
u1.levelExpMap[29] = 500;
u1.levelExpMap[30] = 500;
u1.levelExpMap[31] = 500;
u1.levelExpMap[32] = 500;
u1.levelExpMap[33] = 500;
u1.levelExpMap[34] = 500;
u1.levelExpMap[35] = 500;
u1.levelExpMap[36] = 500;
u1.levelExpMap[37] = 500;
u1.levelExpMap[38] = 500;
u1.levelExpMap[39] = 500;
u1.levelExpMap[40] = 500;
u1.levelExpMap[41] = 500;
u1.levelExpMap[42] = 500;
u1.levelExpMap[43] = 500;
u1.levelExpMap[44] = 500;
u1.levelExpMap[45] = 500;
u1.levelExpMap[46] = 500;
u1.levelExpMap[47] = 500;
u1.levelExpMap[48] = 500;
u1.levelExpMap[49] = 500;
u1.levelExpMap[50] = 500;
if u1.debugToggle then
    for v2 = 0, 50 do
        u1.levelExpMap[v2] = 100;
    end;
end;
u1.Debug = {
    printXPCount = function() --[[ Name: printXPCount, Line 68 ]]
        -- upvalues: u1 (copy)
        local v3 = 0;
        for _, v4 in pairs(u1.levelExpMap) do
            v3 = v3 + v4;
        end;
        print(v3);
    end
};
return u1.levelExpMap;