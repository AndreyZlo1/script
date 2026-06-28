-- Roblox: Workspace.SilverAce293026.VehiclePrompts2
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__Players__2 = game:GetService("Players");
local l__Modules__3 = l__ReplicatedStorage__1:WaitForChild("Modules");
local l__VehicleModule__4 = require(l__Modules__3:WaitForChild("VehicleModule"));
local l__Humanoid__5 = l__Players__2.LocalPlayer.Character:WaitForChild("Humanoid");
local u1 = nil;
l__Humanoid__5.Seated:Connect(function(_, p2) --[[ Line: 13 ]]
    -- upvalues: u1 (ref), l__VehicleModule__4 (copy)
    if p2 then
        u1 = p2;
        local l__Parent__6 = p2.Parent;
        local v3, v4;
        if l__Parent__6.Name ~= "Required" then
            l__Parent__6 = l__Parent__6.Parent;
            if l__Parent__6.Name ~= "Required" then
                v3 = nil;
                if v3 then
                    if v3:HasTag("Aircraft") then
                        return;
                    else
                        v4 = l__VehicleModule__4.getSeatPrompts(v3);
                        for _, v6 in ipairs(v4) do
                            v6.Enabled = false;
                        end;
                        return;
                    end;
                else
                    return;
                end;
            end;
        end;
        v3 = l__Parent__6.Parent;
        if v3 then
            if v3:HasTag("Aircraft") then
                return;
            else
                v4 = l__VehicleModule__4.getSeatPrompts(v3);
                for _, v6 in ipairs(v4) do
                    v6.Enabled = false;
                end;
                return;
            end;
        else
            return;
        end;
    end;
    if not u1 then
        return;
    end;
    local l__Parent__7 = u1.Parent;
    local v7;
    if l__Parent__7.Name ~= "Required" then
        l__Parent__7 = l__Parent__7.Parent;
        if l__Parent__7.Name ~= "Required" then
            v7 = nil;
            if v7 then
                if v7:HasTag("Aircraft") then
                    return;
                else
                    l__VehicleModule__4.setPromptsBasedOnOccupants(v7);
                    return;
                end;
            else
                return;
            end;
        end;
    end;
    v7 = l__Parent__7.Parent;
    if v7 then
        if v7:HasTag("Aircraft") then
        else
            l__VehicleModule__4.setPromptsBasedOnOccupants(v7);
        end;
    end;
end);