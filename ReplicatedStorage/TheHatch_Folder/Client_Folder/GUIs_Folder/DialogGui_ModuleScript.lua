-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.DialogGui
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Maid__1 = require(script.Parent.Maid);
local l__Theme__2 = require(script.Parent.Theme);
local l__spr__3 = require(script.Parent.spr);
local u1 = {};
local function u2() --[[ Line: 54 ]] end;
function u1.new(p3) --[[ Line: 56 ]]
    -- upvalues: u2 (copy), l__Maid__1 (copy), u1 (copy)
    local v4 = {
        dialog = nil,
        category = 1,
        experience = 1,
        title = "Experience",
        instance = p3,
        onAccept = u2,
        onDecline = u2,
        maid = l__Maid__1.new()
    };
    local v5 = setmetatable(v4, {
        __index = u1
    });
    v5:init();
    return v5;
end;
function u1.promptNextGame(p6, p7, p8, p9, p10, p11) --[[ Line: 73 ]]
    p6.experience = p7;
    p6.title = p8;
    p6.category = p9;
    p6.onAccept = p10;
    p6.onDecline = p11;
    p6:updateGameThumbnail();
    p6:setDialog("NextGame");
end;
function u1.promptTeleportError(p12, p13, p14) --[[ Line: 90 ]]
    -- upvalues: u2 (copy)
    p12.onAccept = p13;
    p12.onDecline = u2;
    p12:setDialog("TeleportError");
    p12.instance.TeleportError.Titlebar.Content.Caption.Text = tostring(p14);
end;
function u1.promptJoinHub(p15, p16) --[[ Line: 98 ]]
    -- upvalues: u2 (copy)
    p15.onAccept = p16;
    p15.onDecline = u2;
    p15:setDialog("JoinHub");
end;
function u1.closeDialog(p17) --[[ Line: 104 ]]
    -- upvalues: u2 (copy)
    p17.onAccept = u2;
    p17.onDecline = u2;
    p17:setDialog(nil);
end;
function u1.updateDialogVisibility(p18, u19, p20) --[[ Line: 110 ]]
    if u19 then
        local l__instance__4 = p18.instance;
        if p20 then
            l__instance__4[u19].Visible = true;
            p18.maid[`delay{u19}`] = nil;
        else
            p18.maid[`delay{u19}`] = task.delay(1, function() --[[ Line: 121 ]]
                -- upvalues: l__instance__4 (copy), u19 (copy)
                l__instance__4[u19].Visible = false;
            end);
        end;
    end;
end;
function u1.setDialog(p21, p22) --[[ Line: 127 ]]
    -- upvalues: l__spr__3 (copy)
    p21:updateDialogVisibility(p21.dialog, false);
    p21:updateDialogVisibility(p22, true);
    p21.dialog = p22;
    local l__target__5 = l__spr__3.target;
    local l__NextGame__6 = p21.instance.NextGame;
    local v23 = 0.8;
    local v24 = 2;
    local v25 = {};
    local v26;
    if p22 == "NextGame" then
        v26 = UDim2.fromScale(0.5, 0.5);
    else
        v26 = UDim2.fromScale(0.5, 1.5);
    end;
    v25.Position = v26;
    l__target__5(l__NextGame__6, v23, v24, v25);
    local l__target__7 = l__spr__3.target;
    local l__TeleportError__8 = p21.instance.TeleportError;
    local v27 = 0.8;
    local v28 = 2;
    local v29 = {};
    local v30;
    if p22 == "TeleportError" then
        v30 = UDim2.fromScale(0.5, 0.5);
    else
        v30 = UDim2.fromScale(0.5, 1.5);
    end;
    v29.Position = v30;
    l__target__7(l__TeleportError__8, v27, v28, v29);
    local l__target__9 = l__spr__3.target;
    local l__JoinHub__10 = p21.instance.JoinHub;
    local v31 = 0.8;
    local v32 = 2;
    local v33 = {};
    local v34;
    if p22 == "JoinHub" then
        v34 = UDim2.fromScale(0.5, 0.5);
    else
        v34 = UDim2.fromScale(0.5, 1.5);
    end;
    v33.Position = v34;
    l__target__9(l__JoinHub__10, v31, v32, v33);
    l__spr__3.target(p21.instance.Focus, 1, 1, {
        BackgroundTransparency = p22 and 0.4 or 1
    });
end;
function u1.updateGameThumbnail(p35) --[[ Line: 149 ]]
    -- upvalues: l__Theme__2 (copy)
    local l__Content__11 = p35.instance.NextGame.Content;
    local l__experience__12 = p35.experience;
    local v36 = l__Theme__2.lighten(l__Theme__2.categories[p35.category].color, 0.1);
    l__Content__11.Thumbnail.Image = `rbxthumb://type=GameThumbnail&id={l__experience__12}&w=384&h=216`;
    l__Content__11.Thumbnail.Title.Caption.Text = p35.title;
    l__Content__11.Thumbnail.UIStroke.Color = l__Theme__2.plusDarker(v36, 0.5);
    l__Content__11.Thumbnail.Box.UIStroke.Color = v36;
end;
function u1.init(u37) --[[ Line: 161 ]]
    -- upvalues: l__spr__3 (copy)
    local l__instance__13 = u37.instance;
    u37.maid:Add(l__instance__13.NextGame.Content.AcceptButton.Activated:Connect(function() --[[ Line: 164 ]]
        -- upvalues: u37 (copy)
        task.defer(u37.onAccept);
        u37:closeDialog();
    end));
    u37.maid:Add(l__instance__13.NextGame.Content.DeclineButton.Activated:Connect(function() --[[ Line: 169 ]]
        -- upvalues: u37 (copy)
        task.defer(u37.onDecline);
        u37:closeDialog();
    end));
    u37.maid:Add(l__instance__13.NextGame.CloseButton.Activated:Connect(function() --[[ Line: 174 ]]
        -- upvalues: u37 (copy)
        u37:closeDialog();
    end));
    u37.maid:Add(l__instance__13.TeleportError.Content.AcceptButton.Activated:Connect(function() --[[ Line: 178 ]]
        -- upvalues: u37 (copy)
        task.defer(u37.onAccept);
        u37:closeDialog();
    end));
    u37.maid:Add(l__instance__13.TeleportError.Content.DeclineButton.Activated:Connect(function() --[[ Line: 183 ]]
        -- upvalues: u37 (copy)
        u37:closeDialog();
    end));
    u37.maid:Add(l__instance__13.JoinHub.Content.AcceptButton.Activated:Connect(function() --[[ Line: 187 ]]
        -- upvalues: u37 (copy)
        task.defer(u37.onAccept);
        u37:closeDialog();
    end));
    u37.maid:Add(l__instance__13.JoinHub.Content.DeclineButton.Activated:Connect(function() --[[ Line: 192 ]]
        -- upvalues: u37 (copy)
        u37:closeDialog();
    end));
    l__instance__13.NextGame.Position = UDim2.fromScale(0.5, 1.5);
    l__instance__13.TeleportError.Position = UDim2.fromScale(0.5, 1.5);
    l__instance__13.JoinHub.Position = UDim2.fromScale(0.5, 1.5);
    l__instance__13.NextGame.Visible = false;
    l__instance__13.TeleportError.Visible = false;
    l__instance__13.JoinHub.Visible = false;
    l__instance__13.Enabled = true;
    u37.maid:Add(function() --[[ Line: 206 ]]
        -- upvalues: l__spr__3 (ref), l__instance__13 (copy)
        l__spr__3.stop(l__instance__13.NextGame);
        l__spr__3.stop(l__instance__13.TeleportError);
        l__spr__3.stop(l__instance__13.JoinHub);
        l__instance__13.Enabled = false;
    end);
end;
function u1.Destroy(p38) --[[ Line: 214 ]]
    p38.maid:DoCleaning();
end;
return u1;