-- Roblox: Players.SilverAce293026.PlayerScripts.CmdrController
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__CmdrClient__2 = require(l__ReplicatedStorage__1:WaitForChild("CmdrClient"));
local l__TPLibraries__3 = l__ReplicatedStorage__1:WaitForChild("TPLibraries");
local l__Icon__4 = require(l__TPLibraries__3:WaitForChild("Icon"));
local l__RolePowers__5 = require(l__ReplicatedStorage__1:WaitForChild("Cmdr"):WaitForChild("Util"):WaitForChild("RolePowers"));
local l__LocalPlayer__6 = game:GetService("Players").LocalPlayer;
l__CmdrClient__2:SetActivationKeys({ Enum.KeyCode.Semicolon });
if l__RolePowers__5.getPlayerPower(l__LocalPlayer__6) <= 0 then
else
    l__Icon__4.new():setLabel("Cmdr").selected:Connect(function() --[[ Line: 17 ]]
        -- upvalues: l__CmdrClient__2 (copy)
        l__CmdrClient__2:Toggle();
    end);
    local l__Cmdr__7 = l__ReplicatedStorage__1:WaitForChild("Cmdr");
    local l__Network__8 = l__Cmdr__7:WaitForChild("Network");
    local l__Enums__9 = l__Cmdr__7:WaitForChild("Enums");
    local l__GetEnumTable__10 = l__Network__8:WaitForChild("GetEnumTable");
    local function u4(p1) --[[ Line: 28 ]]
        -- upvalues: l__GetEnumTable__10 (copy), l__CmdrClient__2 (copy)
        local v2;
        if p1:GetAttribute("QueryServer") == true then
            v2 = l__GetEnumTable__10:InvokeServer(p1.Name) or {};
        else
            v2 = require(p1) or {};
        end;
        local v3 = l__CmdrClient__2.Util.MakeEnumType(p1.Name, v2);
        l__CmdrClient__2.Registry:RegisterType(string.lower(p1.Name), v3);
    end;
    l__Enums__9.ChildAdded:Connect(u4);
    for _, u5 in l__Enums__9:GetChildren() do
        coroutine.wrap(function() --[[ Line: 43 ]]
            -- upvalues: u4 (copy), u5 (copy)
            u4(u5);
        end)();
    end;
    local l__Types__11 = l__Cmdr__7:WaitForChild("Types");
    l__Types__11.ChildAdded:Connect(function(p6) --[[ Name: processNewType, Line 51 ]]
        -- upvalues: l__CmdrClient__2 (copy)
        local v7 = require(p6);
        l__CmdrClient__2.Registry:RegisterType(string.lower(p6.Name), v7);
    end);
    for _, u8 in l__Types__11:GetChildren() do
        coroutine.wrap(function() --[[ Line: 59 ]]
            -- upvalues: u8 (copy), l__CmdrClient__2 (copy)
            local v9 = u8;
            local v10 = require(v9);
            l__CmdrClient__2.Registry:RegisterType(string.lower(v9.Name), v10);
        end)();
    end;
end;