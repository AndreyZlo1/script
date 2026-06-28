-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.FreeForAll
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local l__Common__1 = require(script.Parent:WaitForChild("Common"));
local u1 = {
    InterfaceElements = { "Players", "Countdown" }
};
local u2 = nil;
function u1.StateReplication(p3) --[[ Line: 8 ]]
    -- upvalues: u2 (ref), u1 (copy), l__Common__1 (copy)
    u2 = p3;
    u1.UpdateScores(u2.Scores);
    l__Common__1.MinigameGui.SetCountdownGoal(p3.EndTimestamp);
end;
function u1.UpdateScores(p4) --[[ Line: 14 ]]
    -- upvalues: u2 (ref), l__Common__1 (copy)
    if u2 then
        local v5 = {};
        for v6, v7 in p4 do
            v5[v6] = v7;
        end;
        l__Common__1.MinigameGui.SetPlayers(v5);
    end;
end;
return u1;