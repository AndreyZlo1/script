-- Roblox: ReplicatedStorage._TheHatch.Client.EggAwardedUI
-- Class: Script
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__TeleportService__2 = game:GetService("TeleportService");
local l__Players__3 = game:GetService("Players");
local l__RunService__4 = game:GetService("RunService");
local l__MarketplaceService__5 = game:GetService("MarketplaceService");
local l___TheHatch__6 = l__ReplicatedStorage__1:WaitForChild("_TheHatch");
local l__GUIs__7 = script.Parent:WaitForChild("GUIs");
local l__AutoScale__8 = require(l__GUIs__7:WaitForChild("AutoScale"));
local l__ButtonAnimated__9 = require(l__GUIs__7:WaitForChild("ButtonAnimated"));
local l__CloseButton__10 = require(l__GUIs__7:WaitForChild("CloseButton"));
local l__HatchingGui__11 = require(l__GUIs__7:WaitForChild("HatchingGui"));
local l__EggSlot__12 = require(l__GUIs__7:WaitForChild("EggSlot"));
local l__DialogGui__13 = require(l__GUIs__7:WaitForChild("DialogGui"));
local l__DevHint__14 = require(l__GUIs__7:WaitForChild("DevHint"));
l___TheHatch__6:WaitForChild("Remotes").Awarded.OnClientEvent:Connect(function(u1) --[[ Line: 23 ]]
    -- upvalues: l__GUIs__7 (copy), l__DialogGui__13 (copy), l__HatchingGui__11 (copy), l__EggSlot__12 (copy), l__AutoScale__8 (copy), l__ButtonAnimated__9 (copy), l__CloseButton__10 (copy), l__Players__3 (copy), l___TheHatch__6 (copy), l__RunService__4 (copy), l__MarketplaceService__5 (copy), l__TeleportService__2 (copy)
    local l__DialogGui__15 = l__GUIs__7.DialogGui.DialogGui;
    local l__HatchingGui__16 = l__GUIs__7.HatchingGui.HatchingGui;
    local l__Translations__17 = require(script.Parent:WaitForChild("Translations"));
    l__Translations__17.translateUI({
        ["portal.title"] = l__DialogGui__15.JoinHub.Titlebar.Content.Title,
        ["portal.subtitle"] = l__DialogGui__15.JoinHub.Titlebar.Content.Caption,
        ["portal.description-a"] = l__DialogGui__15.JoinHub.Content.BodyA,
        ["portal.description-b"] = l__DialogGui__15.JoinHub.Content.BodyB,
        ["portal.go-to-hub"] = l__DialogGui__15.JoinHub.Content.AcceptButton.Label,
        ["portal.cancel"] = l__DialogGui__15.JoinHub.Content.DeclineButton.Label
    });
    l__Translations__17.translateUI({
        ["join.title"] = l__DialogGui__15.NextGame.Titlebar.Content.Title,
        ["join.subtitle"] = l__DialogGui__15.NextGame.Titlebar.Content.Caption,
        ["join.play-next"] = l__DialogGui__15.NextGame.Content.AcceptButton,
        ["join.return"] = l__DialogGui__15.NextGame.Content.DeclineButton
    });
    l__Translations__17.translateUI({
        ["teleport-fail.title"] = l__DialogGui__15.TeleportError.Titlebar.Content.Title,
        ["teleport-fail.subtitle"] = l__DialogGui__15.TeleportError.Titlebar.Content.Caption,
        ["teleport-fail.description"] = l__DialogGui__15.TeleportError.Content.Caption,
        ["teleport-fail.back-to-hub"] = l__DialogGui__15.TeleportError.Content.AcceptButton,
        ["teleport-fail.cancel"] = l__DialogGui__15.TeleportError.Content.DeclineButton
    });
    local u2 = l__DialogGui__13.new(l__DialogGui__15);
    local v3 = l__HatchingGui__11.new(l__HatchingGui__16);
    l__EggSlot__12.new(l__HatchingGui__16.Egg);
    l__AutoScale__8.new(l__DialogGui__15.UIScale);
    l__AutoScale__8.new(l__HatchingGui__16.UIScale);
    l__ButtonAnimated__9.new(l__DialogGui__15.JoinHub.Content.AcceptButton);
    l__ButtonAnimated__9.new(l__DialogGui__15.JoinHub.Content.DeclineButton);
    l__ButtonAnimated__9.new(l__DialogGui__15.NextGame.Content.AcceptButton);
    l__ButtonAnimated__9.new(l__DialogGui__15.NextGame.Content.DeclineButton);
    l__CloseButton__10.new(l__DialogGui__15.NextGame.CloseButton);
    l__ButtonAnimated__9.new(l__DialogGui__15.TeleportError.Content.AcceptButton);
    l__ButtonAnimated__9.new(l__DialogGui__15.TeleportError.Content.DeclineButton);
    l__DialogGui__15.Parent = l__Players__3.LocalPlayer.PlayerGui;
    l__HatchingGui__16.Parent = l__Players__3.LocalPlayer.PlayerGui;
    v3.playAnimation(u1.category, u1.index, 1);
    local u4 = nil;
    local u5 = nil;
    local function u8(p6) --[[ Line: 93 ]]
        -- upvalues: l__RunService__4 (ref), u2 (copy), u4 (ref), l___TheHatch__6 (ref), l__MarketplaceService__5 (ref), u1 (copy)
        if p6 then
            local l__place_id__18 = p6.place_id;
            local _ = p6.universe_id;
            local l__origin_place_id__19 = p6.origin_place_id;
            local u7 = "";
            pcall(function() --[[ Line: 110 ]]
                -- upvalues: u7 (ref), l__MarketplaceService__5 (ref), l__place_id__18 (copy)
                u7 = l__MarketplaceService__5:GetProductInfo(l__place_id__18).Name;
            end);
            u2:promptNextGame(l__place_id__18, u7, 1, function() --[[ Name: onJoinGame, Line 114 ]]
                -- upvalues: l__RunService__4 (ref), u2 (ref), u4 (ref), l__place_id__18 (copy), l___TheHatch__6 (ref)
                if l__RunService__4:IsStudio() then
                    u2:promptTeleportError(function() --[[ Line: 90 ]] end, "Cannot teleport from Studio");
                else
                    u4 = l__place_id__18;
                    l___TheHatch__6.Remotes.TeleportToNextPlace:InvokeServer(l__place_id__18);
                end;
            end, function() --[[ Name: onReturnToHub, Line 118 ]]
                -- upvalues: l__origin_place_id__19 (copy), u4 (ref), l___TheHatch__6 (ref)
                u4 = l__origin_place_id__19;
                l___TheHatch__6.Remotes.TeleportToHub:InvokeServer();
            end);
        else
            if u1.teleport_enabled then
                u2:promptJoinHub(function() --[[ Line: 128 ]]
                    -- upvalues: u4 (ref), l___TheHatch__6 (ref)
                    u4 = 98209635344835;
                    l___TheHatch__6.Remotes.TeleportToHub:InvokeServer();
                end);
            end;
        end;
    end;
    l__TeleportService__2.TeleportInitFailed:connect(function(_, p9, p10, p11, _) --[[ Line: 134 ]]
        -- upvalues: u4 (ref), u5 (ref), l___TheHatch__6 (ref), u8 (copy), u2 (copy)
        if p11 == u4 then
            if p9 == Enum.TeleportResult.Unauthorized then
                u5 = p11;
                local v12 = l___TheHatch__6.Remotes.GetNextDestination:InvokeServer(u5);
                if v12 then
                    u8(v12);
                    return;
                else
                    u2:promptJoinHub(function() --[[ Line: 142 ]]
                        -- upvalues: u4 (ref), l___TheHatch__6 (ref)
                        u4 = 98209635344835;
                        l___TheHatch__6.Remotes.TeleportToHub:InvokeServer();
                    end);
                    return;
                end;
            end;
            u2:promptTeleportError(function() --[[ Line: 147 ]]
                -- upvalues: u4 (ref), l___TheHatch__6 (ref)
                u4 = 98209635344835;
                l___TheHatch__6.Remotes.TeleportToHub:InvokeServer();
            end, p10);
        end;
    end);
    task.delay(4.5, function() --[[ Line: 154 ]]
        -- upvalues: u8 (copy), u1 (copy)
        u8(u1.teleport_destination);
    end);
end);
local u13 = nil;
local u14 = nil;
local u15 = nil;
l___TheHatch__6:WaitForChild("Remotes").DisplayHint.OnClientEvent:Connect(function(p16) --[[ Line: 163 ]]
    -- upvalues: u13 (ref), u14 (ref), l__DevHint__14 (copy), l__Players__3 (copy), l__AutoScale__8 (copy), u15 (ref)
    if u13 == nil then
        u13 = script.Parent.GUIs:WaitForChild("DevHint").DevHint;
        u14 = l__DevHint__14.new(u13);
        u13.Parent = l__Players__3.LocalPlayer.PlayerGui;
    end;
    u14:show(p16.hint);
    u13.Enabled = true;
    l__AutoScale__8.new(u13.UIScale);
    if u15 then
        task.cancel(u15);
        u15 = nil;
    end;
    if p16.duration then
        local _ = p16.duration;
    end;
    u15 = task.delay(30, function() --[[ Line: 183 ]]
        -- upvalues: u14 (ref)
        u14:hide();
    end);
end);