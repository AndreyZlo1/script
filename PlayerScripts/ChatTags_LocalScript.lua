-- Roblox: Players.SilverAce293026.PlayerScripts.ChatTags
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__TextChatService__1 = game:GetService("TextChatService");
local l__Players__2 = game:GetService("Players");
local l__Modules__3 = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local l__ChatTags__4 = require(l__Modules__3:WaitForChild("ChatTags"));
function l__TextChatService__1.OnIncomingMessage(p1) --[[ Line: 10 ]]
    -- upvalues: l__Players__2 (copy), l__ChatTags__4 (copy)
    local v2 = Instance.new("TextChatMessageProperties");
    if p1.TextSource then
        v2.PrefixText = (l__ChatTags__4[l__Players__2:GetPlayerByUserId(p1.TextSource.UserId):GetAttribute("ChatTag") or "None"] or "") .. " " .. p1.PrefixText;
    end;
    return v2;
end;