-- Roblox: ReplicatedFirst.LoadingScript
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__StarterGui__1 = game:GetService("StarterGui");
game:GetService("UserInputService");
local l__TweenService__2 = game:GetService("TweenService");
local l__Lighting__3 = game:GetService("Lighting");
local l__GuiService__4 = game:GetService("GuiService");
local l__ReplicatedStorage__5 = game:GetService("ReplicatedStorage");
local l__TeleportFailed__6 = l__ReplicatedStorage__5:WaitForChild("PlayerEvents"):WaitForChild("TeleportFailed");
local u1 = {
    PlayClicked = l__ReplicatedStorage__5:WaitForChild("BindableEvents"):WaitForChild("PlayClicked")
};
local u2 = require(l__ReplicatedStorage__5:WaitForChild("ReplicatedConfig")).Mode ~= "Tycoon";
local l__Blur__7 = l__Lighting__3:WaitForChild("Blur");
l__Blur__7.Size = u2 and 8 or 15;
local l__LocalPlayer__8 = game:GetService("Players").LocalPlayer;
local l__LoadingGui__9 = script:WaitForChild("LoadingGui");
local l__Menu__10 = l__LoadingGui__9:WaitForChild("Frame"):WaitForChild("Menu");
local u3 = {};
local u4 = false;
for _, v5 in {
    "Loadout",
    "Play",
    "Settings",
    "Store",
    "Tycoon"
} do
    u3[v5] = l__Menu__10:WaitForChild(v5 .. "ButtonFrame"):WaitForChild(v5 .. "Button");
end;
l__LoadingGui__9.Parent = l__LocalPlayer__8.PlayerGui;
script.Parent:RemoveDefaultLoadingScreen();
function setGUI()
    -- upvalues: l__StarterGui__1 (copy)
    l__StarterGui__1:SetCore("ResetButtonCallback", false);
    l__StarterGui__1:SetCore("TopbarEnabled", false);
end;
function setGUIBack()
    -- upvalues: l__StarterGui__1 (copy)
    l__StarterGui__1:SetCore("ResetButtonCallback", true);
    l__StarterGui__1:SetCore("TopbarEnabled", true);
end;
coroutine.wrap(function() --[[ Line: 50 ]]
    local v6 = tick();
    while not pcall(setGUI) and tick() - v6 < 1 do
        task.wait();
    end;
end)();
local l__Frame__11 = l__LoadingGui__9:WaitForChild("Frame");
local l__Menu__12 = l__Frame__11:WaitForChild("Menu");
local l__ProgressBar__13 = l__Menu__12:WaitForChild("ProgressBar");
local l__BarFill__14 = l__ProgressBar__13:WaitForChild("BarFill");
l__LocalPlayer__8.PlayerGui:WaitForChild("NotificationGui", (1 / 0)).Enabled = false;
l__BarFill__14.Size = UDim2.new(0, 0, 1, 0);
local l__Value__15 = workspace:WaitForChild("Params"):WaitForChild("DoubleCash").Value;
l__Menu__12:WaitForChild("GameNameLabel"):WaitForChild("DoubleCash").Visible = l__Value__15;
if u2 then
    l__Menu__12.HintLabel.Visible = false;
end;
for v7 = 1, 50 do
    task.wait(v7 == 7 and 0.3 or (v7 == 20 and 0.5 or 0.02));
    l__BarFill__14.Size = UDim2.new(v7 / 50, 0, 1, 0);
end;
repeat
    task.wait(0.5);
until game:IsLoaded();
local l__CurrentCamera__16 = workspace.CurrentCamera;
local l__CameraPart__17 = l__ReplicatedStorage__5:WaitForChild("CameraPart");
local l__TreeSet__18 = l__ReplicatedStorage__5:WaitForChild("TreeSet");
l__CameraPart__17:Clone().Parent = workspace;
l__TreeSet__18:Clone().Parent = workspace;
local u8 = l__ReplicatedStorage__5:WaitForChild("DMNoMapCamPart"):Clone();
u8.Parent = workspace;
task.spawn(function() --[[ Line: 100 ]]
    -- upvalues: u2 (copy), l__CurrentCamera__16 (copy), u8 (copy), u4 (ref), l__CameraPart__17 (copy)
    if u2 then
        l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
        l__CurrentCamera__16.CameraSubject = nil;
        l__CurrentCamera__16.CFrame = u8.CFrame;
        local l__Minigames__19 = workspace:WaitForChild("Minigames");
        local v9 = l__Minigames__19:FindFirstChild("Map", true);
        while not v9 do
            task.wait(0.1);
            v9 = l__Minigames__19:FindFirstChild("Map", true);
        end;
        if u4 then
        else
            local l__CamPart__20 = v9:WaitForChild("CamPart");
            l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
            l__CurrentCamera__16.CameraSubject = nil;
            l__CurrentCamera__16.CFrame = l__CamPart__20.CFrame;
        end;
    else
        l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
        l__CurrentCamera__16.CameraSubject = nil;
        l__CurrentCamera__16.CFrame = l__CameraPart__17.CFrame;
    end;
end);
local u10 = false;
for _, v11 in u3 do
    v11.Visible = true;
end;
local v12 = TweenInfo.new(1.5, Enum.EasingStyle.Quad);
local u13 = l__TweenService__2:Create(l__Frame__11, v12, {
    BackgroundTransparency = 1
});
local u14 = {};
for v15, v16 in u3 do
    u14[v15] = l__TweenService__2:Create(v16, v12, {
        TextTransparency = 0
    });
end;
u14.Play.Completed:Connect(function() --[[ Line: 153 ]]
    -- upvalues: l__GuiService__4 (copy), u3 (copy)
    l__GuiService__4.SelectedObject = l__GuiService__4:IsTenFootInterface() and u3.Play or nil;
end);
l__ProgressBar__13.Visible = false;
u3.Play.TextTransparency = 1;
u3.Tycoon.TextTransparency = 1;
u3.Loadout.TextTransparency = 1;
u3.Play.Visible = true;
u3.Loadout.Visible = u2;
if u2 then
    u3.Play.Text = "DEPLOY";
else
    u3.Loadout.Visible = false;
    u3.Tycoon.Parent.Size = UDim2.new(0.21, 0, 0.07, 0);
    u3.Tycoon.Parent.Position = UDim2.new(0.5, 0, 0.78, 0);
end;
u3.Tycoon.Activated:Connect(function() --[[ Line: 175 ]]
    -- upvalues: l__Menu__12 (copy), l__LoadingGui__9 (copy)
    l__Menu__12.Visible = false;
    l__LoadingGui__9.Frame.ModesFrame.Position = UDim2.new(1.2, 0, 0.15, 0);
    l__LoadingGui__9.Frame.ModesFrame.Visible = true;
    l__LoadingGui__9.Frame.ModesFrame:TweenPosition(UDim2.new(0.5, 0, 0.15, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1);
end);
local l__Modules__21 = l__ReplicatedStorage__5:WaitForChild("Modules");
local l__UIController__22 = require(l__Modules__21:WaitForChild("UIController"));
u3.Loadout.Activated:Connect(function() --[[ Line: 186 ]]
    -- upvalues: l__UIController__22 (copy), l__LoadingGui__9 (copy)
    l__UIController__22:OpenUI("LoadoutUI");
    l__LoadingGui__9.Enabled = false;
end);
u3.Settings.Activated:Connect(function() --[[ Line: 191 ]]
    -- upvalues: l__UIController__22 (copy), l__LoadingGui__9 (copy)
    l__UIController__22:OpenUI("SettingsUI");
    l__LoadingGui__9.Enabled = false;
    l__LoadingGui__9:SetAttribute("Return", true);
end);
u3.Store.Activated:Connect(function() --[[ Line: 197 ]]
    -- upvalues: l__UIController__22 (copy), l__LoadingGui__9 (copy)
    l__UIController__22:OpenUI("ShopUI");
    l__LoadingGui__9.Enabled = false;
    l__LoadingGui__9:SetAttribute("Return", true);
end);
l__TeleportFailed__6.OnClientEvent:Connect(function() --[[ Line: 203 ]]
    -- upvalues: l__LoadingGui__9 (copy)
    l__LoadingGui__9.Enabled = true;
end);
function onClick(p17)
    -- upvalues: l__GuiService__4 (copy), u2 (copy), l__LoadingGui__9 (copy), l__Blur__7 (copy), u10 (ref), l__ReplicatedStorage__5 (copy), u4 (ref), l__CurrentCamera__16 (copy), l__LocalPlayer__8 (copy), u1 (copy)
    l__GuiService__4.SelectedObject = nil;
    if u2 then
        l__LoadingGui__9.Enabled = false;
        l__Blur__7.Size = 0;
        u10 = true;
        if p17 or l__ReplicatedStorage__5.PlayerEvents.RequestDeploy:InvokeServer() then
            u4 = true;
            l__CurrentCamera__16.CameraType = Enum.CameraType.Custom;
            l__LocalPlayer__8.PlayerGui:WaitForChild("CustomToolbar").Enabled = true;
            l__LocalPlayer__8.PlayerGui:WaitForChild("NotificationGui").Enabled = true;
            l__LocalPlayer__8.PlayerGui:WaitForChild("UpdateGui").Enabled = true;
            require(l__ReplicatedStorage__5:WaitForChild("Modules"):WaitForChild("MusicModule")).setHardpointPlaying(false);
            coroutine.wrap(function() --[[ Line: 235 ]]
                local v18 = tick();
                while not pcall(setGUIBack) and tick() - v18 < 1 do
                    task.wait();
                end;
            end)();
        else
            l__LoadingGui__9.Enabled = true;
            l__Blur__7.Size = 8;
            u10 = false;
        end;
    else
        l__Blur__7.Size = 0;
        l__LoadingGui__9.Enabled = false;
        l__LoadingGui__9:SetAttribute("HasClickedPlay", true);
        l__LocalPlayer__8.PlayerGui:WaitForChild("CustomToolbar").Enabled = true;
        l__CurrentCamera__16.CameraType = Enum.CameraType.Custom;
        l__LocalPlayer__8.PlayerGui:WaitForChild("ShopGui").Enabled = true;
        l__LocalPlayer__8.PlayerGui:WaitForChild("NotificationGui").Enabled = true;
        l__LocalPlayer__8.PlayerGui:WaitForChild("UpdateGui").Enabled = true;
        require(l__ReplicatedStorage__5:WaitForChild("Modules"):WaitForChild("MusicModule")).setHardpointPlaying(false);
        coroutine.wrap(function() --[[ Line: 257 ]]
            local v19 = tick();
            while not pcall(setGUIBack) and tick() - v19 < 1 do
                task.wait();
            end;
        end)();
        u1.PlayClicked:Fire();
    end;
end;
u3.Play.MouseButton1Down:Connect(function() --[[ Line: 269 ]]
    onClick();
end);
script:WaitForChild("EmulatePlayClick").Event:Connect(function() --[[ Line: 273 ]]
    -- upvalues: l__UIController__22 (copy)
    l__UIController__22:CloseAllUI();
    onClick(true);
end);
spawn(function() --[[ Line: 278 ]]
    -- upvalues: u13 (copy)
    u13:Play();
end);
spawn(function() --[[ Line: 282 ]]
    -- upvalues: u14 (copy)
    for _, v20 in u14 do
        v20:Play();
    end;
end);
l__StarterGui__1:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
if u2 then
    local function v23(_) --[[ Line: 291 ]]
        -- upvalues: u10 (ref), l__LocalPlayer__8 (copy), u4 (ref), l__LoadingGui__9 (copy), l__Blur__7 (copy), u2 (copy), l__CurrentCamera__16 (copy), u8 (copy), l__CameraPart__17 (copy), l__StarterGui__1 (copy)
        if u10 then
            u10 = false;
        elseif l__LocalPlayer__8:GetAttribute("MG_Spectating") then
        else
            if u4 then
                l__LoadingGui__9.Enabled = true;
            end;
            l__Blur__7.Size = 8;
            u4 = false;
            coroutine.wrap(function() --[[ Line: 305 ]]
                -- upvalues: u4 (ref), u2 (ref), l__CurrentCamera__16 (ref), u8 (ref), l__CameraPart__17 (ref)
                local v21 = tick();
                while tick() - v21 < 1 do
                    task.wait();
                    if u4 then
                        return;
                    end;
                    task.spawn(function() --[[ Line: 100 ]]
                        -- upvalues: u2 (ref), l__CurrentCamera__16 (ref), u8 (ref), u4 (ref), l__CameraPart__17 (ref)
                        if u2 then
                            l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
                            l__CurrentCamera__16.CameraSubject = nil;
                            l__CurrentCamera__16.CFrame = u8.CFrame;
                            local l__Minigames__23 = workspace:WaitForChild("Minigames");
                            local v22 = l__Minigames__23:FindFirstChild("Map", true);
                            while not v22 do
                                task.wait(0.1);
                                v22 = l__Minigames__23:FindFirstChild("Map", true);
                            end;
                            if u4 then
                            else
                                local l__CamPart__24 = v22:WaitForChild("CamPart");
                                l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
                                l__CurrentCamera__16.CameraSubject = nil;
                                l__CurrentCamera__16.CFrame = l__CamPart__24.CFrame;
                            end;
                        else
                            l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
                            l__CurrentCamera__16.CameraSubject = nil;
                            l__CurrentCamera__16.CFrame = l__CameraPart__17.CFrame;
                        end;
                    end);
                end;
            end)();
            l__StarterGui__1:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
            l__StarterGui__1:SetCore("TopbarEnabled", true);
            l__StarterGui__1:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true);
            l__LocalPlayer__8.PlayerGui:WaitForChild("NotificationGui").Enabled = false;
            l__LocalPlayer__8.PlayerGui:WaitForChild("UpdateGui").Enabled = false;
        end;
    end;
    if not l__LocalPlayer__8.Character then
        l__LocalPlayer__8.CharacterAdded:Wait();
    end;
    l__LocalPlayer__8.CharacterAdded:Connect(v23);
    l__StarterGui__1:SetCoreGuiEnabled(Enum.CoreGuiType.All, false);
    l__StarterGui__1:SetCore("TopbarEnabled", true);
    l__StarterGui__1:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true);
    l__LocalPlayer__8.PlayerGui:WaitForChild("NotificationGui").Enabled = false;
    l__LocalPlayer__8.PlayerGui:WaitForChild("UpdateGui").Enabled = false;
end;
local l__Button__25 = l__LoadingGui__9:WaitForChild("Frame"):WaitForChild("ModesFrame"):WaitForChild("BackBtn"):WaitForChild("ButtonFrame"):WaitForChild("Button");
local l__ModesBack__26 = require(l__LoadingGui__9:WaitForChild("ModesBack"));
l__Button__25.Activated:Connect(function() --[[ Line: 338 ]]
    -- upvalues: l__ModesBack__26 (copy)
    l__ModesBack__26.closeClicked();
end);
local l__RunService__27 = game:GetService("RunService");
if u2 then
    local l__DMState__28 = l__ReplicatedStorage__5:WaitForChild("DMState");
    local l__IntermissionLabel__29 = l__Menu__12:WaitForChild("IntermissionLabel");
    local function v25() --[[ Line: 348 ]]
        -- upvalues: u3 (copy), l__DMState__28 (copy), l__IntermissionLabel__29 (copy), u4 (ref), u2 (copy), l__CurrentCamera__16 (copy), u8 (copy), l__CameraPart__17 (copy)
        u3.Play.Visible = l__DMState__28:GetAttribute("InProgress") == true;
        if l__DMState__28:GetAttribute("WaitingForPlayers") then
            l__IntermissionLabel__29.Visible = true;
            l__IntermissionLabel__29.Text = "Waiting for players";
        elseif l__DMState__28:GetAttribute("Tournament") then
            l__IntermissionLabel__29.Visible = true;
            l__IntermissionLabel__29.Text = "Tournament mode";
        end;
        if not u4 then
            task.spawn(function() --[[ Line: 100 ]]
                -- upvalues: u2 (ref), l__CurrentCamera__16 (ref), u8 (ref), u4 (ref), l__CameraPart__17 (ref)
                if u2 then
                    l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
                    l__CurrentCamera__16.CameraSubject = nil;
                    l__CurrentCamera__16.CFrame = u8.CFrame;
                    local l__Minigames__30 = workspace:WaitForChild("Minigames");
                    local v24 = l__Minigames__30:FindFirstChild("Map", true);
                    while not v24 do
                        task.wait(0.1);
                        v24 = l__Minigames__30:FindFirstChild("Map", true);
                    end;
                    if u4 then
                    else
                        local l__CamPart__31 = v24:WaitForChild("CamPart");
                        l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
                        l__CurrentCamera__16.CameraSubject = nil;
                        l__CurrentCamera__16.CFrame = l__CamPart__31.CFrame;
                    end;
                else
                    l__CurrentCamera__16.CameraType = Enum.CameraType.Scriptable;
                    l__CurrentCamera__16.CameraSubject = nil;
                    l__CurrentCamera__16.CFrame = l__CameraPart__17.CFrame;
                end;
            end);
        end;
    end;
    l__DMState__28.AttributeChanged:Connect(v25);
    v25();
    local u26 = 0;
    l__RunService__27.RenderStepped:Connect(function(_) --[[ Line: 368 ]]
        -- upvalues: u26 (ref), l__DMState__28 (copy), l__IntermissionLabel__29 (copy)
        u26 = u26 + 0.2;
        if u26 < 0.3 then
        else
            u26 = 0;
            if l__DMState__28:GetAttribute("Intermission") == nil then
                if l__DMState__28:GetAttribute("Tournament") then
                    l__IntermissionLabel__29.Visible = true;
                    l__IntermissionLabel__29.Text = "Tournament mode";
                else
                    local v27 = l__DMState__28:GetAttribute("WaitingForPlayers");
                    l__IntermissionLabel__29.Visible = v27;
                    l__IntermissionLabel__29.Text = v27 and "Waiting for players" or "";
                end;
            else
                local v28 = l__DMState__28:GetAttribute("Intermission") - workspace:GetServerTimeNow();
                local v29 = math.floor(v28);
                l__IntermissionLabel__29.Text = "Intermission: " .. v29;
                l__IntermissionLabel__29.Visible = v29 > 0;
            end;
        end;
    end);
end;