-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.TeamDeathmatch
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__Common__2 = require(script.Parent:WaitForChild("Common"));
local v1 = {
    InterfaceElements = { "Teams", "Countdown" }
};
local u2 = nil;
function v1.StateReplication(p3) --[[ Line: 8 ]]
    -- upvalues: u2 (ref), l__Common__2 (copy)
    u2 = p3;
    l__Common__2.MinigameGui.UpdateTeams(p3.ScoreGoal, p3.Teams.Blue.Score, p3.Teams.Red.Score);
    l__Common__2.MinigameGui.SetCountdownGoal(p3.EndTimestamp);
end;
function v1.UpdateScores(p4, p5) --[[ Line: 14 ]]
    -- upvalues: u2 (ref), l__Common__2 (copy)
    if u2 then
        l__Common__2.MinigameGui.UpdateTeams(u2.ScoreGoal, p4, p5);
    end;
end;
function v1.PlayerAssignedTeam(p6, _) --[[ Line: 19 ]]
    -- upvalues: l__Players__1 (copy)
    if p6 == l__Players__1.LocalPlayer then
    end;
end;
return v1;