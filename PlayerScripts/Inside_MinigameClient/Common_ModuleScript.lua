-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.Common
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__MinigameGui__1 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MinigameGui");
local l__MinigameUI__2 = require(l__MinigameGui__1:WaitForChild("MinigameUI"));
local l__MinigameEvent__3 = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("MinigameEvent");
v1.MinigameGui = l__MinigameUI__2;
v1.ClientTouchable = require(script.ClientTouchable);
function v1.SendMessage(p2, ...) --[[ Line: 15 ]]
    -- upvalues: l__MinigameEvent__3 (copy)
    l__MinigameEvent__3:FireServer(p2, unpack({ ... }));
end;
return v1;