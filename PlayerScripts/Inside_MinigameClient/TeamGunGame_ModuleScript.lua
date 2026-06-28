-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.TeamGunGame
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local l__Common__1 = require(script.Parent:WaitForChild("Common"));
local v1 = {
    InterfaceElements = { "Teams" }
};
local u2 = nil;
function v1.StateReplication(p3) --[[ Line: 8 ]]
    -- upvalues: u2 (ref), l__Common__1 (copy)
    u2 = p3;
    l__Common__1.MinigameGui.UpdateTeams(#u2.GunGameConfig.Guns + 1, 1, 1);
end;
function v1.UpdateScores(p4, p5) --[[ Line: 14 ]]
    -- upvalues: u2 (ref), l__Common__1 (copy)
    if u2 then
        l__Common__1.MinigameGui.UpdateTeams(#u2.GunGameConfig.Guns + 1, p4, p5);
    end;
end;
return v1;