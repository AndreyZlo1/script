-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.EggSlot
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__EggData__1 = require(script.Parent.EggData);
local l__Maid__2 = require(script.Parent.Maid);
local l__Theme__3 = require(script.Parent.Theme);
require(script.Parent.Tween);
local l__spr__4 = require(script.Parent.spr);
local u1 = {};
function u1.new(p2) --[[ Line: 33 ]]
    -- upvalues: l__Maid__2 (copy), u1 (copy)
    local v3 = {
        instance = p2,
        maid = l__Maid__2.new()
    };
    local u4 = setmetatable(v3, {
        __index = u1
    });
    u4.maid:Add(p2.AttributeChanged:Connect(function() --[[ Line: 39 ]]
        -- upvalues: u4 (copy)
        u4:updateAppearance();
        u4:updateStatus();
        u4:updateBounce();
    end));
    u4:deactivateOnHold();
    u4:updateAppearance();
    u4:updateStatus();
    u4:updateBounce();
    return u4;
end;
function u1.updateStatus(p5) --[[ Line: 54 ]]
    local l__instance__5 = p5.instance;
    if l__instance__5:GetAttribute("Locked") then
        local v6 = l__instance__5:GetAttribute("LockedIcon") == true;
        l__instance__5.Animated.Status.Amount.Visible = false;
        l__instance__5.Animated.Status.Lock.Visible = true;
        l__instance__5.Animated.Status.Visible = v6;
        l__instance__5.Animated.Icon.Question.Visible = not v6;
    else
        local v7 = tonumber(l__instance__5:GetAttribute("Amount")) or 0;
        if v7 > 1 then
            l__instance__5.Animated.Status.Lock.Visible = false;
            l__instance__5.Animated.Status.Amount.Text = `{v7}`;
            l__instance__5.Animated.Status.Amount.Visible = true;
            l__instance__5.Animated.Status.Visible = true;
        else
            l__instance__5.Animated.Status.Visible = false;
        end;
    end;
end;
function u1.updateAppearance(p8) --[[ Line: 78 ]]
    -- upvalues: l__EggData__1 (copy), l__Theme__3 (copy)
    local l__instance__6 = p8.instance;
    local v9 = tonumber(l__instance__6:GetAttribute("CategoryIndex"));
    local v10 = tonumber(l__instance__6:GetAttribute("EggIndex"));
    local v11 = l__instance__6:GetAttribute("Locked");
    if v11 then
        v11 = not l__instance__6:GetAttribute("LockedIcon");
    end;
    local v12 = l__EggData__1.eggs[v9];
    if v12 then
        v12 = l__EggData__1.eggs[v9][v10];
    end;
    local v13;
    if v12 then
        v13 = v12.name;
    else
        v13 = l__instance__6:GetAttribute("Name") or "";
    end;
    local v14;
    if v12 then
        v14 = v12.thumbnail;
    else
        v14 = l__instance__6:GetAttribute("Thumbnail") or "";
    end;
    local v15;
    if v12 then
        v15 = v12.rarity;
    else
        v15 = l__instance__6:GetAttribute("Rarity") or 0;
    end;
    local v16 = l__EggData__1.rarities[v15] or (l__instance__6:GetAttribute("RarityText") or "Unknown");
    local v17 = l__Theme__3.rarities[v15] or l__Theme__3.rarities[0];
    local v18;
    if l__instance__6:GetAttribute("Locked") then
        v18 = l__Theme__3.rarities[0];
    else
        v18 = v17;
    end;
    local v19 = l__Theme__3.plusDarker(v18, 0.25);
    l__instance__6.Animated.Icon.Question.TextColor3 = l__Theme__3.plusLighter(v18, 0.25);
    l__instance__6.Animated.Icon.Question.Visible = v11;
    l__instance__6.Animated.Icon.Image = v14 == "" and "rbxassetid://71269200872007" or v14;
    local l__Icon__7 = l__instance__6.Animated.Icon;
    local v20;
    if v11 then
        v20 = Color3.new();
    else
        v20 = Color3.new(1, 1, 1);
    end;
    l__Icon__7.ImageColor3 = v20;
    l__instance__6.Animated.Icon.ImageTransparency = v11 and 0.65 or 0;
    l__instance__6.Animated.Dots.Image = v15 == 2 and "rbxassetid://79927483780753" or (v15 == 3 and "rbxassetid://133224976988347" or "");
    l__instance__6.Animated.Dots.ImageColor3 = l__Theme__3.plusLighter(v18, 0.25);
    l__instance__6.Animated.Box.BackgroundColor3 = v18;
    l__instance__6.Animated.Outline.BackgroundColor3 = v19;
    l__instance__6.Animated.Outline.UIStroke.Color = v19;
    l__instance__6.Animated.BorderDark.UIStroke.Color = v19;
    if v11 then
        l__instance__6.Animated:SetAttribute("Tooltip", (`<font color="#{l__Theme__3.plusDarker(v17, 0.25):ToHex()}">{v16}</font> ???`));
    else
        l__instance__6.Animated:SetAttribute("Tooltip", (`<font color="#{l__Theme__3.plusDarker(v17, 0.25):ToHex()}">{v16}</font> {v13}`));
    end;
end;
function u1.updateBounce(p21) --[[ Line: 125 ]]
    -- upvalues: l__spr__4 (copy)
    local v22 = p21.instance:GetAttribute("Bounce");
    if type(v22) == "number" then
        p21.instance:SetAttribute("Bounce", nil);
        l__spr__4.target(p21.instance.Animated, 0.7, 5, {
            Position = UDim2.fromScale(0.5, 0.5)
        });
        l__spr__4.setVelocity(p21.instance.Animated, {
            Position = UDim2.fromScale(0, v22 * 80)
        });
    end;
end;
function u1.deactivateOnHold(u23) --[[ Line: 138 ]]
    if u23.instance.Active and u23.instance.Selectable then
        u23.maid:Add(u23.instance.InputBegan:Connect(function(p24) --[[ Line: 143 ]]
            -- upvalues: u23 (copy)
            if p24.UserInputType == Enum.UserInputType.Touch then
                u23.maid.deactivate = task.delay(0.5, function() --[[ Line: 145 ]]
                    -- upvalues: u23 (ref)
                    u23.instance.Active = false;
                end);
            end;
        end));
        u23.maid:Add(u23.instance.InputEnded:Connect(function(p25) --[[ Line: 151 ]]
            -- upvalues: u23 (copy)
            if p25.UserInputType == Enum.UserInputType.Touch then
                u23.maid.deactivate = nil;
                u23.instance.Active = true;
            end;
        end));
    end;
end;
function u1.Destroy(p26) --[[ Line: 159 ]]
    p26.maid:DoCleaning();
end;
return u1;