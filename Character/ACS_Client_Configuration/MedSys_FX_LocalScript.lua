-- Roblox: Workspace.SilverAce293026.ACS_Client.MedSys_FX
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local _ = l__ReplicatedStorage__2.ACS_Engine.Events;
local l__LocalPlayer__3 = l__Players__1.LocalPlayer;
game:GetService("RunService");
local l__MedSys__4 = l__ReplicatedStorage__2:WaitForChild("ACS_Engine").Events.MedSys;
local l__Config__5 = require(l__ReplicatedStorage__2.ACS_Engine.GameRules:WaitForChild("Config"));
workspace.CurrentCamera:ClearAllChildren();
local l__StarterGui__6 = game:GetService("StarterGui");
l__StarterGui__6:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, l__Config__5.CoreGuiPlayerList);
l__LocalPlayer__3.PlayerGui:SetTopbarTransparency(l__Config__5.TopBarTransparency);
l__StarterGui__6:SetCoreGuiEnabled(Enum.CoreGuiType.Health, l__Config__5.CoreGuiHealth);
local l__Humanoid__7 = script.Parent.Parent.Humanoid;
if game.Workspace.CurrentCamera:FindFirstChild("BS") == nil then
    local v1 = Instance.new("ColorCorrectionEffect");
    v1.Parent = game.Workspace.CurrentCamera;
    v1.Name = "BS";
end;
if game.Workspace.CurrentCamera:FindFirstChild("BO") == nil then
    local v2 = Instance.new("ColorCorrectionEffect");
    v2.Parent = game.Workspace.CurrentCamera;
    v2.Name = "BO";
end;
if game.Workspace.CurrentCamera:FindFirstChild("DorFX") == nil then
    local v3 = Instance.new("BlurEffect");
    v3.Parent = game.Workspace.CurrentCamera;
    v3.Name = "DorFX";
end;
local l__TweenService__8 = game:GetService("TweenService");
local l__Debris__9 = game:GetService("Debris");
local l__BS__10 = game.Workspace.CurrentCamera.BS;
local l__BO__11 = game.Workspace.CurrentCamera.BO;
local l__DorFX__12 = game.Workspace.CurrentCamera.DorFX;
l__BS__10.Saturation = 0;
l__TweenService__8:Create(l__BS__10, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
    Contrast = 0
}):Play();
l__TweenService__8:Create(l__BO__11, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
    Brightness = 0
}):Play();
l__BO__11.Saturation = 0;
l__TweenService__8:Create(l__DorFX__12, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
    Size = 0
}):Play();
l__BS__10.TintColor = Color3.new(1, 1, 1);
l__BO__11.TintColor = Color3.new(1, 1, 1);
local l__ACS_Client__13 = l__LocalPlayer__3.Character:WaitForChild("ACS_Client");
l__ACS_Client__13:WaitForChild("Stances");
local l__Variaveis__14 = l__ACS_Client__13:WaitForChild("Variaveis");
local l__Sangue__15 = l__Variaveis__14:WaitForChild("Sangue");
local l__Dor__16 = l__Variaveis__14:WaitForChild("Dor");
local l__HitCount__17 = l__Variaveis__14:WaitForChild("HitCount");
local l__Health__18 = l__Humanoid__7.Health;
l__Humanoid__7.HealthChanged:Connect(function(p4) --[[ Line: 73 ]]
    -- upvalues: l__Health__18 (ref), l__Humanoid__7 (copy), l__TweenService__8 (copy), l__Debris__9 (copy)
    if p4 <= 0 then
        workspace.CurrentCamera:ClearAllChildren();
    else
        if p4 < l__Health__18 and p4 < l__Humanoid__7.MaxHealth / 2 then
            local v5 = (p4 / l__Health__18 - 1) * -1;
            local v6 = script.FX.ColorCorrection:clone();
            v6.Parent = game.Workspace.CurrentCamera;
            v6.TintColor = Color3.new(1, p4 / 2 / l__Health__18, p4 / 2 / l__Health__18);
            l__TweenService__8:Create(v6, TweenInfo.new(3 * v5, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0), {
                TintColor = Color3.new(1, 1, 1)
            }):Play();
            l__Debris__9:AddItem(v6, 3 * v5);
        end;
        l__Health__18 = p4;
    end;
end);
l__Dor__16.Changed:Connect(function(_) --[[ Line: 105 ]] end);
l__Sangue__15.Changed:Connect(function(p7) --[[ Line: 109 ]]
    -- upvalues: l__Sangue__15 (copy), l__BS__10 (copy)
    if l__Sangue__15.MaxValue / 2 <= p7 then
        l__BS__10.Saturation = math.max(-1, (p7 - l__Sangue__15.MaxValue / 2) / (l__Sangue__15.MaxValue / 2) - 1);
    end;
end);
l__HitCount__17.Changed:Connect(function(p8) --[[ Line: 115 ]]
    -- upvalues: l__MedSys__4 (copy)
    if p8 >= 3 then
        l__MedSys__4.Render:FireServer(true, "N/A");
    end;
end);
local l__Humanoid__19 = script.Parent.Parent.Humanoid;
l__ACS_Client__13:GetAttributeChangedSignal("Surrender"):Connect(function() --[[ Line: 123 ]]
    -- upvalues: l__ACS_Client__13 (copy), l__Humanoid__19 (copy), l__StarterGui__6 (copy)
    if l__ACS_Client__13:GetAttribute("Surrender") == true then
        l__Humanoid__19:UnequipTools();
        l__StarterGui__6:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
    end;
end);