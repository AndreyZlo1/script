-- Roblox: Players.SilverAce293026.PlayerScripts.AutomatedFriendInvite
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__SocialService__1 = game:GetService("SocialService");
local l__StarterGui__2 = game:GetService("StarterGui");
local l__Players__3 = game:GetService("Players");
local l__LocalPlayer__4 = l__Players__3.LocalPlayer;
local v1 = 180;
local u2 = Instance.new("BindableFunction");
u2.Name = "FriendInvitePrompt";
u2.Parent = game:GetService("ReplicatedStorage");
local u3 = nil;
local function u5() --[[ Line: 26 ]]
    -- upvalues: l__LocalPlayer__4 (copy)
    local l__Character__5 = l__LocalPlayer__4.Character;
    local v4;
    if l__Character__5 then
        v4 = l__Character__5:FindFirstChildOfClass("Humanoid");
    else
        v4 = l__Character__5;
    end;
    if l__Character__5 and (v4 and l__Character__5:FindFirstChild("HumanoidRootPart")) then
        if v4.Health == v4.MaxHealth then
            return l__Character__5:FindFirstChild("ForceField") ~= nil;
        else
            return false;
        end;
    else
        return false;
    end;
end;
local function v12() --[[ Line: 39 ]]
    -- upvalues: u5 (copy), l__SocialService__1 (copy), l__LocalPlayer__4 (copy), l__Players__3 (copy), u3 (ref), l__StarterGui__2 (copy), u2 (copy)
    if u5() then
        local v6, v7 = pcall(function() --[[ Line: 16 ]]
            -- upvalues: l__SocialService__1 (ref), l__LocalPlayer__4 (ref)
            return l__SocialService__1:CanSendGameInviteAsync(l__LocalPlayer__4);
        end);
        if v6 and v7 then
            local u8 = nil;
            local v9, _ = pcall(function() --[[ Line: 45 ]]
                -- upvalues: u8 (ref), l__LocalPlayer__4 (ref)
                u8 = l__LocalPlayer__4:GetFriendsOnline();
            end);
            if v9 then
                local v10 = u8[math.random(1, #u8)];
                local l__VisitorId__6 = v10.VisitorId;
                local v11 = l__Players__3:GetUserThumbnailAsync(l__VisitorId__6, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
                u3 = Instance.new("ExperienceInviteOptions");
                u3.InviteUser = l__VisitorId__6;
                u3.PromptMessage = "Invite this friend to join to get boosted income by playing together!";
                l__StarterGui__2:SetCore("SendNotification", {
                    Title = "Notification",
                    Duration = 10,
                    Button1 = "Yes",
                    Button2 = "No",
                    Text = "Invite " .. v10.UserName .. " to play together for boosted income?",
                    Icon = v11,
                    Callback = u2,
                    Button1Style = Enum.ButtonStyle.RobloxRoundButton,
                    Button2Style = Enum.ButtonStyle.RobloxRoundButton
                });
            end;
        end;
    end;
end;
function u2.OnInvoke(p13) --[[ Line: 77 ]]
    -- upvalues: l__SocialService__1 (copy), l__LocalPlayer__4 (copy), u3 (ref)
    if p13 == "Yes" then
        l__SocialService__1:PromptGameInvite(l__LocalPlayer__4, u3);
    end;
end;
task.wait(60);
v12();
while true do
    task.wait(v1);
    v1 = v1 + 180;
    v12();
end;