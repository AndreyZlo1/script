-- Roblox: Workspace.SilverAce293026.PlaneControl.CrashModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__PlayerEvents__1 = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents");
local u2 = {
    Reliable = l__PlayerEvents__1:WaitForChild("ReliableHeliEvent"),
    Unreliable = l__PlayerEvents__1:WaitForChild("UnreliableHeliEvent")
};
function u1.HitboxTouched(p3) --[[ Line: 10 ]]
    -- upvalues: u1 (copy), u2 (copy)
    if p3.CollisionGroup == "CamCast" or p3.CollisionGroup == "CamCastIgnore" then
    elseif p3:IsDescendantOf(u1.helicopterModel) then
    elseif p3.Parent == workspace:WaitForChild("Flares") then
    else
        local v4 = p3:FindFirstAncestorOfClass("Model");
        if v4 and v4:FindFirstChild("Humanoid") then
        elseif p3:FindFirstAncestor("CosmeticShellsFolder") then
        elseif p3.Name == "VehicleHitbox" or (p3.Transparency ~= 1 or p3:IsDescendantOf(workspace.Map)) then
            if p3.Material == Enum.Material.ForceField then
            else
                local l__Engine__2 = u1.helicopterModel.Required.Engine;
                local l__AssemblyLinearVelocity__3 = l__Engine__2.AssemblyLinearVelocity;
                if (Vector3.new(0, 1, 0)):Dot(l__Engine__2.CFrame.UpVector) < -0.1 then
                    u2.Reliable:FireServer(u1.helicopterModel, "crashExplode");
                    for _, v5 in u1.hitboxConns do
                        v5:Disconnect();
                    end;
                    u1.hitboxConns = {};
                elseif l__AssemblyLinearVelocity__3.Magnitude < 40 then
                elseif os.time() - u1.lastSmallCrash < 2 then
                else
                    u1.lastSmallCrash = os.time();
                    u2.Reliable:FireServer(u1.helicopterModel, "crashDamage", l__AssemblyLinearVelocity__3.Magnitude * 55);
                    for _, v6 in u1.hitboxConns do
                        v6:Disconnect();
                    end;
                    u1.hitboxConns = {};
                end;
            end;
        end;
    end;
end;
function u1.SetPlane(p7) --[[ Line: 50 ]]
    -- upvalues: u1 (copy)
    u1.helicopterModel = p7;
    local l__Hitbox__4 = p7.Hitbox;
    u1.hitboxConns = {};
    for _, v8 in l__Hitbox__4:GetChildren() do
        if v8:GetAttribute("IgnoreCrashes") then
            u1.skidPart = u1.skidPart or v8;
        else
            table.insert(u1.hitboxConns, v8.Touched:Once(u1.HitboxTouched));
        end;
    end;
    u1.lastSmallCrash = os.time();
end;
function u1.UnsetPlane() --[[ Line: 64 ]]
    -- upvalues: u1 (copy)
    u1.helicopterModel = nil;
    for _, v9 in u1.hitboxConns do
        v9:Disconnect();
    end;
    u1.hitboxConns = {};
end;
return u1;