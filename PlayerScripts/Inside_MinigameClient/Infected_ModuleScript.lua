-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.Infected
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local l__Common__1 = require(script.Parent:WaitForChild("Common"));
local u1 = {
    InterfaceElements = { "Heading", "Countdown" }
};
local u2 = nil;
function u1.StateReplication(p3) --[[ Line: 8 ]]
    -- upvalues: u2 (ref), u1 (copy)
    u2 = p3;
    u1.Update(p3);
end;
function u1.Update(p4) --[[ Line: 13 ]]
    -- upvalues: u2 (ref), l__Common__1 (copy)
    u2 = p4;
    if p4.StartTimestamp and p4.StartTimestamp > os.time() then
        l__Common__1.MinigameGui.SetHeading("A player will become infected shortly");
        l__Common__1.MinigameGui.SetCountdownGoal(p4.StartTimestamp);
    else
        l__Common__1.MinigameGui.SetCountdownGoal(p4.EndTimestamp);
        local v5 = #p4.Teams.Blue.Players;
        l__Common__1.MinigameGui.SetHeading(string.format("%s survivor%s remain%s!", v5, v5 > 1 and "s" or "", v5 > 1 and "" or "s"));
    end;
end;
return u1;