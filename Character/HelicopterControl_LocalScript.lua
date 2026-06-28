-- Roblox: Workspace.SilverAce293026.HelicopterControl
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__FlareReplicationEvent__3 = game:GetService("ReplicatedStorage"):WaitForChild("FlareReplicationEvent");
local l__StarterGui__4 = game:GetService("StarterGui");
local l__PlayerGui__5 = l__Players__1.LocalPlayer:WaitForChild("PlayerGui");
local l__CustomMobileGui__6 = l__PlayerGui__5:WaitForChild("CustomMobileGui");
local l__RightHeliFrame__7 = l__CustomMobileGui__6:WaitForChild("RightHeliFrame");
local l__LeftHeliFrame__8 = l__CustomMobileGui__6:WaitForChild("LeftHeliFrame");
local u1 = nil;
local l__ContextTutorialGui__9 = l__PlayerGui__5:WaitForChild("ContextTutorialGui");
local l__ContextualTutorialPresets__10 = require(l__ContextTutorialGui__9:WaitForChild("ContextualTutorialPresets"));
local l__VehicleGui__11 = l__PlayerGui__5:WaitForChild("VehicleGui");
local l__VehicleGuiModule__12 = require(l__VehicleGui__11:WaitForChild("VehicleGuiModule"));
local l__Modules__13 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
require(l__Modules__13:WaitForChild("FlaresSettings"));
local l__VFXModule__14 = require(l__Modules__13:WaitForChild("VFXModule"));
local u2 = {
    Camera = require(script:WaitForChild("CameraModule")),
    Movement = require(script:WaitForChild("MovementModule")),
    Crash = require(script:WaitForChild("CrashModule")),
    Weapons = require(script:WaitForChild("WeaponsModule"))
};
local l__InputModule__15 = require(script:WaitForChild("InputModule"));
local u3 = false;
local function u7(p4, p5) --[[ Line: 49 ]]
    for _, v6 in p4:GetDescendants() do
        if v6:IsA("ProximityPrompt") then
            v6.Enabled = p5;
        end;
    end;
end;
local u8 = nil;
local function u10() --[[ Line: 76 ]]
    -- upvalues: u8 (ref), u2 (copy), l__InputModule__15 (copy), u7 (copy), l__RightHeliFrame__7 (copy), l__LeftHeliFrame__8 (copy), u3 (ref)
    if u8 == nil then
    else
        for _, v9 in u2 do
            v9.UnsetHeli();
        end;
        l__InputModule__15.UnbindScheme("Heli");
        u7(u8, true);
        u8 = nil;
        if u8 then
            l__RightHeliFrame__7.Visible = u3;
            l__LeftHeliFrame__8.Visible = u3;
        else
            l__RightHeliFrame__7.Visible = false;
            l__LeftHeliFrame__8.Visible = false;
        end;
    end;
end;
local function u13(p11) --[[ Line: 87 ]]
    -- upvalues: u10 (copy), u8 (ref), u7 (copy), l__InputModule__15 (copy), u2 (copy), l__RightHeliFrame__7 (copy), l__LeftHeliFrame__8 (copy), u3 (ref), l__ContextualTutorialPresets__10 (copy)
    u10();
    u8 = p11;
    u7(u8, false);
    l__InputModule__15.BindScheme("Heli", require(script.InputModule.HeliScheme));
    for _, v12 in u2 do
        v12.SetHeli(p11);
    end;
    if u8 then
        l__RightHeliFrame__7.Visible = u3;
        l__LeftHeliFrame__8.Visible = u3;
    else
        l__RightHeliFrame__7.Visible = false;
        l__LeftHeliFrame__8.Visible = false;
    end;
    if p11.Params:FindFirstChild("Config") then
        l__ContextualTutorialPresets__10.startArmedHeliTutorial();
    else
        l__ContextualTutorialPresets__10.startUnarmedHeliTutorial();
    end;
end;
local function v16(p14) --[[ Line: 109 ]]
    -- upvalues: u3 (ref), u8 (ref), l__RightHeliFrame__7 (copy), l__LeftHeliFrame__8 (copy)
    local v15 = u3;
    u3 = p14.UserInputType == Enum.UserInputType.Touch;
    if v15 ~= u3 then
        if not u8 then
            l__RightHeliFrame__7.Visible = false;
            l__LeftHeliFrame__8.Visible = false;
            return;
        end;
        l__RightHeliFrame__7.Visible = u3;
        l__LeftHeliFrame__8.Visible = u3;
    end;
end;
l__UserInputService__2.InputChanged:Connect(v16);
l__UserInputService__2.InputBegan:Connect(v16);
l__Players__1.LocalPlayer.Character:WaitForChild("Humanoid").Seated:Connect(function(_, p17) --[[ Line: 125 ]]
    -- upvalues: l__RightHeliFrame__7 (copy), l__LeftHeliFrame__8 (copy), u1 (ref), u7 (copy), u10 (copy), l__VehicleGuiModule__12 (copy), u3 (ref), l__StarterGui__4 (copy), u13 (copy)
    if p17 then
        local v18 = p17:FindFirstAncestorOfClass("Model");
        if v18 then
            local v19 = v18:FindFirstChild("Required");
            if v19 then
                if v19:FindFirstChild("HeliSeat") == nil then
                    v18 = nil;
                end;
            else
                v18 = nil;
            end;
        else
            v18 = nil;
        end;
        if v18 then
            u7(v18, false);
            if p17.Name == "HeliSeat" then
                u13(v18);
                l__StarterGui__4:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
            else
                u1 = v18;
                if p17.Name == "GunnerSeat" then
                    for _, v20 in l__RightHeliFrame__7.Buttons:GetChildren() do
                        v20.Visible = false;
                    end;
                    for _, v21 in l__LeftHeliFrame__8.Buttons:GetChildren() do
                        v21.Visible = false;
                    end;
                    l__RightHeliFrame__7.Buttons.Shoot.Visible = true;
                    l__RightHeliFrame__7.Visible = u3;
                    l__RightHeliFrame__7.Visible = u3;
                    l__StarterGui__4:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
                end;
            end;
        end;
    else
        l__RightHeliFrame__7.Visible = false;
        l__RightHeliFrame__7.Visible = false;
        for _, v22 in l__RightHeliFrame__7.Buttons:GetChildren() do
            v22.Visible = true;
        end;
        for _, v23 in l__LeftHeliFrame__8.Buttons:GetChildren() do
            v23.Visible = true;
        end;
        if u1 then
            u7(u1, true);
            u1 = nil;
        else
            u10();
        end;
        l__VehicleGuiModule__12.Clear();
    end;
end);
l__FlareReplicationEvent__3.OnClientEvent:Connect(function(p24) --[[ Line: 174 ]]
    -- upvalues: l__VFXModule__14 (copy)
    l__VFXModule__14.flareFX(p24);
end);