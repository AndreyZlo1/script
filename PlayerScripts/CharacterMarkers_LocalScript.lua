-- Roblox: Players.SilverAce293026.PlayerScripts.CharacterMarkers
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__Modules__2 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__CharacterMarkerModule__3 = require(l__Modules__2:WaitForChild("CharacterMarkerModule"));
l__Players__1.PlayerAdded:Connect(function(p1) --[[ Line: 10 ]]
    -- upvalues: l__CharacterMarkerModule__3 (copy)
    l__CharacterMarkerModule__3.ProcessNewPlayer(p1);
end);
l__Players__1.PlayerRemoving:Connect(function(p2) --[[ Line: 14 ]]
    -- upvalues: l__CharacterMarkerModule__3 (copy)
    l__CharacterMarkerModule__3.ProcessLeavingPlayer(p2);
end);
for _, v3 in l__Players__1:GetChildren() do
    l__CharacterMarkerModule__3.ProcessNewPlayer(v3);
end;