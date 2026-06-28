-- Roblox: ReplicatedStorage._TheHatch.Client.EggSpawner
-- Class: Script
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__Workspace__2 = game:GetService("Workspace");
local l__Parent__3 = script.Parent.Parent;
local l__Shared__4 = l__Parent__3:WaitForChild("Shared");
local l__Characters__5 = require(l__Shared__4:WaitForChild("Characters"));
local l__LocalPlayer__6 = l__Players__1.LocalPlayer;
local l__Remotes__7 = l__Parent__3:WaitForChild("Remotes");
local l__Spawn__8 = l__Remotes__7.Spawn;
local l__Despawn__9 = l__Remotes__7.Despawn;
local l__Pickup__10 = l__Remotes__7.Pickup;
local l__Models__11 = l__Parent__3:WaitForChild("Models");
local u1 = nil;
local u2 = false;
local function u5(p3) --[[ Line: 26 ]]
    -- upvalues: u2 (ref), l__Characters__5 (copy), l__LocalPlayer__6 (copy), u1 (ref), l__Pickup__10 (copy)
    if u2 then
    else
        local v4 = l__Characters__5.getCharacterModel(l__LocalPlayer__6);
        if v4 then
            if p3:IsDescendantOf(v4) then
                u2 = true;
                if u1 then
                    local _, _ = l__Pickup__10:InvokeServer();
                end;
                task.delay(0.5, function() --[[ Line: 41 ]]
                    -- upvalues: u2 (ref)
                    u2 = false;
                end);
            end;
        end;
    end;
end;
local function v6() --[[ Line: 64 ]]
    -- upvalues: u1 (ref)
    if u1 then
        u1:Destroy();
        u1 = nil;
    end;
end;
l__Spawn__8.OnClientEvent:Connect(function(p7, p8) --[[ Name: onSpawnEvent, Line 47 ]]
    -- upvalues: u1 (ref), l__Models__11 (copy), l__Workspace__2 (copy), u5 (copy)
    if u1 then
        u1:Destroy();
    end;
    local v9 = l__Models__11:FindFirstChild(p7);
    local v10;
    if v9 then
        v10 = v9:IsA("MeshPart");
    else
        v10 = v9;
    end;
    local v11 = `No meshpart: {p7}`;
    assert(v10, v11);
    local v12 = v9:Clone();
    v12:PivotTo(CFrame.new(p8));
    v12.Parent = l__Workspace__2;
    u1 = v12;
    v12.Touched:Connect(u5);
end);
l__Despawn__9.OnClientEvent:Connect(v6);