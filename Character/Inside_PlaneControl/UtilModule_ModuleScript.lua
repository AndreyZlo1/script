-- Roblox: Workspace.SilverAce293026.PlaneControl.UtilModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__LocalPlayer__1 = game.Players.LocalPlayer;
if not l__LocalPlayer__1.Character then
    l__LocalPlayer__1.CharacterAdded:Wait();
end;
function v1.SetPlane(_) --[[ Line: 7 ]] end;
function v1.UnsetPlane() --[[ Line: 11 ]] end;
function v1.IsOnGround() --[[ Line: 15 ]]
    return false;
end;
return v1;