-- Roblox: Players.SilverAce293026.PlayerScripts.ChessEvents
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ChessNetwork__1 = game:GetService("ReplicatedStorage"):WaitForChild("ChessNetwork");
local v1 = {
    Start = l__ChessNetwork__1:WaitForChild("Start"),
    ReplicateMove = l__ChessNetwork__1:WaitForChild("ReplicateMove")
};
local l__ChessHandler__2 = require(script.Parent:WaitForChild("ChessHandler"));
v1.Start.OnClientEvent:Connect(function(p2, p3, p4, p5) --[[ Name: onStart, Line 11 ]]
    -- upvalues: l__ChessHandler__2 (copy)
    l__ChessHandler__2.RegisterNewGame(p2, p3, p4, p5);
end);
v1.ReplicateMove.OnClientEvent:Connect(function(p6, p7, p8) --[[ Name: onMove, Line 15 ]]
    -- upvalues: l__ChessHandler__2 (copy)
    l__ChessHandler__2.ReplicateMove(p6, p7, p8);
end);
l__ChessNetwork__1.Stop.OnClientEvent:Connect(l__ChessHandler__2.OnStop);