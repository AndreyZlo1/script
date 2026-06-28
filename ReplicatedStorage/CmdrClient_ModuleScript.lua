-- Roblox: ReplicatedStorage.CmdrClient
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local l__StarterGui__2 = game:GetService("StarterGui");
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
local l__Shared__4 = script:WaitForChild("Shared");
local l__Util__5 = require(l__Shared__4:WaitForChild("Util"));
if l__RunService__1:IsClient() == false then
    error("Server scripts cannot require the client library. Please require the server library to use Cmdr in your own code.");
end;
local v1 = {
    Enabled = true,
    MashToEnable = false,
    ActivationUnlocksMouse = false,
    HideOnLostFocus = true,
    PlaceName = "Cmdr",
    ReplicatedRoot = script,
    RemoteFunction = script:WaitForChild("CmdrFunction"),
    RemoteEvent = script:WaitForChild("CmdrEvent"),
    ActivationKeys = {
        [Enum.KeyCode.F2] = true
    },
    Util = l__Util__5,
    Events = {}
};
local u5 = setmetatable(v1, {
    __index = function(u2, p3) --[[ Name: __index, Line 28 ]]
        local u4 = u2.Dispatcher[p3];
        if u4 and type(u4) == "function" then
            return function(_, ...) --[[ Line: 31 ]]
                -- upvalues: u4 (copy), u2 (copy)
                return u4(u2.Dispatcher, ...);
            end;
        end;
    end
});
u5.Registry = require(l__Shared__4.Registry)(u5);
u5.Dispatcher = require(l__Shared__4.Dispatcher)(u5);
if l__StarterGui__2:WaitForChild("Cmdr") and (wait() and l__LocalPlayer__3:WaitForChild("PlayerGui"):FindFirstChild("Cmdr") == nil) then
    l__StarterGui__2.Cmdr:Clone().Parent = l__LocalPlayer__3.PlayerGui;
end;
local u6 = require(script.CmdrInterface)(u5);
function u5.SetActivationKeys(p7, p8) --[[ Line: 49 ]]
    -- upvalues: l__Util__5 (copy)
    p7.ActivationKeys = l__Util__5.MakeDictionary(p8);
end;
function u5.SetPlaceName(p9, p10) --[[ Line: 54 ]]
    -- upvalues: u6 (copy)
    p9.PlaceName = p10;
    u6.Window:UpdateLabel();
end;
function u5.SetEnabled(p11, p12) --[[ Line: 60 ]]
    p11.Enabled = p12;
end;
function u5.SetActivationUnlocksMouse(p13, p14) --[[ Line: 65 ]]
    p13.ActivationUnlocksMouse = p14;
end;
function u5.Show(p15) --[[ Line: 70 ]]
    -- upvalues: u6 (copy)
    if p15.Enabled then
        u6.Window:Show();
    end;
end;
function u5.Hide(_) --[[ Line: 79 ]]
    -- upvalues: u6 (copy)
    u6.Window:Hide();
end;
function u5.Toggle(p16) --[[ Line: 84 ]]
    -- upvalues: u6 (copy)
    if not p16.Enabled then
        return p16:Hide();
    end;
    u6.Window:SetVisible(not u6.Window:IsVisible());
end;
function u5.SetMashToEnable(p17, p18) --[[ Line: 93 ]]
    p17.MashToEnable = p18;
    if p18 then
        p17:SetEnabled(false);
    end;
end;
function u5.SetHideOnLostFocus(p19, p20) --[[ Line: 102 ]]
    p19.HideOnLostFocus = p20;
end;
function u5.HandleEvent(p21, p22, p23) --[[ Line: 107 ]]
    p21.Events[p22] = p23;
end;
if l__RunService__1:IsServer() == false then
    u5.Registry:RegisterTypesIn(script:WaitForChild("Types"));
    u5.Registry:RegisterCommandsIn(script:WaitForChild("Commands"));
end;
u5.RemoteEvent.OnClientEvent:Connect(function(p24, ...) --[[ Line: 118 ]]
    -- upvalues: u5 (ref)
    if u5.Events[p24] then
        u5.Events[p24](...);
    end;
end);
require(script.DefaultEventHandlers)(u5);
return u5;