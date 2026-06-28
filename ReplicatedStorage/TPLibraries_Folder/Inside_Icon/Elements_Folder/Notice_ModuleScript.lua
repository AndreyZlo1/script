-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Notice
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return function(u1, u2) --[[ Line: 1 ]]
    local u3 = Instance.new("Frame");
    u3.Name = "Notice";
    u3.ZIndex = 25;
    u3.AutomaticSize = Enum.AutomaticSize.X;
    u3.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u3.BorderSizePixel = 0;
    u3.BackgroundTransparency = 0.1;
    u3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u3.Visible = false;
    u3.Parent = u1.widget;
    local v4 = Instance.new("UICorner");
    v4.CornerRadius = UDim.new(1, 0);
    v4.Parent = u3;
    Instance.new("UIStroke").Parent = u3;
    local u5 = Instance.new("TextLabel");
    u5.Name = "NoticeLabel";
    u5.ZIndex = 26;
    u5.AnchorPoint = Vector2.new(0.5, 0.5);
    u5.AutomaticSize = Enum.AutomaticSize.X;
    u5.Size = UDim2.new(1, 0, 1, 0);
    u5.BackgroundTransparency = 1;
    u5.Position = UDim2.new(0.5, 0, 0.515, 0);
    u5.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    u5.FontSize = Enum.FontSize.Size14;
    u5.TextColor3 = Color3.fromRGB(0, 0, 0);
    u5.Text = "1";
    u5.TextWrapped = true;
    u5.TextWrap = true;
    u5.Font = Enum.Font.Arial;
    u5.Parent = u3;
    local l__Parent__1 = script.Parent.Parent;
    local l__Packages__2 = l__Parent__1.Packages;
    local l__Janitor__3 = require(l__Packages__2.Janitor);
    local l__GoodSignal__4 = require(l__Packages__2.GoodSignal);
    local l__Utility__5 = require(l__Parent__1.Utility);
    u1.noticeChanged:Connect(function(p6) --[[ Line: 43 ]]
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), l__Utility__5 (copy), u3 (copy)
        if p6 then
            local v7 = p6 > 99;
            u5.Text = v7 and "99+" or p6;
            if v7 then
                u5.TextSize = 11;
            end;
            local v8 = p6 >= 1;
            local v9 = u2.getIconByUID(u1.parentIconUID);
            if u1.isSelected and (#u1.dropdownIcons > 0 and true or #u1.menuIcons > 0) then
                v8 = false;
            elseif v9 and not v9.isSelected then
                v8 = false;
            end;
            l__Utility__5.setVisible(u3, v8, "NoticeHandler");
        end;
    end);
    u1.noticeStarted:Connect(function(p10, p11) --[[ Line: 71 ]]
        -- upvalues: u1 (copy), u2 (copy), l__Janitor__3 (copy), l__GoodSignal__4 (copy), l__Utility__5 (copy)
        local v12 = p10 or u1.deselected;
        local v13 = u2.getIconByUID(u1.parentIconUID);
        if v13 then
            v13:notify(v12);
        end;
        local u14 = u1.janitor:add(l__Janitor__3.new());
        local u15 = u14:add(l__GoodSignal__4.new());
        u14:add(u1.endNotices:Connect(function() --[[ Line: 83 ]]
            -- upvalues: u15 (copy)
            u15:Fire();
        end));
        u14:add(v12:Connect(function() --[[ Line: 86 ]]
            -- upvalues: u15 (copy)
            u15:Fire();
        end));
        local u16 = p11 or l__Utility__5.generateUID();
        u1.notices[u16] = {
            completeSignal = u15,
            clearNoticeEvent = v12
        };
        u1.notified:Fire(u16);
        local v17 = u1;
        v17.totalNotices = v17.totalNotices + 1;
        u1.noticeChanged:Fire(u1.totalNotices);
        u15:Once(function() --[[ Line: 100 ]]
            -- upvalues: u14 (copy), u1 (ref), u16 (ref)
            u14:destroy();
            local v18 = u1;
            v18.totalNotices = v18.totalNotices - 1;
            u1.notices[u16] = nil;
            u1.noticeChanged:Fire(u1.totalNotices);
        end);
    end);
    u3:SetAttribute("ClipToJoinedParent", true);
    u1:clipOutside(u3);
    return u3;
end;