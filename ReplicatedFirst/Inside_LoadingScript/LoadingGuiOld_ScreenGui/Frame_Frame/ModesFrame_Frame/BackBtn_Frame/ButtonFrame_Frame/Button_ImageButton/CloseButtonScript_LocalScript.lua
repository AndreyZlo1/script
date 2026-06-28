-- Roblox: ReplicatedFirst.LoadingScript.LoadingGuiOld.Frame.ModesFrame.BackBtn.ButtonFrame.Button.CloseButtonScript
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Modules__1 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__GuiModule__2 = require(l__Modules__1:WaitForChild("GuiModule"));
local _ = game:GetService("Players").LocalPlayer;
local l__Parent__3 = script.Parent;
local u1 = l__Parent__3;
local u2 = false;
repeat
    l__Parent__3 = l__Parent__3.Parent;
until l__Parent__3.Name == "ShopGui";
local l__SettingsFrame__4 = l__Parent__3:WaitForChild("UnderstoreFrame"):WaitForChild("SettingsFrame");
l__Parent__3:WaitForChild("CodeFrame");
u1.MouseButton1Down:Connect(function() --[[ Name: onClick, Line 16 ]]
    -- upvalues: u2 (ref), l__GuiModule__2 (copy), u1 (copy), l__SettingsFrame__4 (copy)
    if u2 then
    else
        u2 = true;
        l__GuiModule__2.buttonPress(u1, nil, function() --[[ Line: 21 ]]
            -- upvalues: l__GuiModule__2 (ref), u1 (ref), u2 (ref)
            l__GuiModule__2.buttonLift(u1, nil, function() --[[ Line: 22 ]]
                -- upvalues: u2 (ref)
                u2 = false;
            end);
        end);
        l__SettingsFrame__4:SetAttribute("IsPressed", false);
    end;
end);