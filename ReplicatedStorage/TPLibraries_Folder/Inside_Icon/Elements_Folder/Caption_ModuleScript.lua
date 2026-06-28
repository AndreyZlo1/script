-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Caption
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = Color3.fromRGB(39, 41, 48);
return function(u2) --[[ Line: 3 ]]
    -- upvalues: u1 (copy)
    local u3 = u2:getInstance("ClickRegion");
    local u4 = Instance.new("CanvasGroup");
    u4.Name = "Caption";
    u4.AnchorPoint = Vector2.new(0.5, 0);
    u4.BackgroundTransparency = 1;
    u4.BorderSizePixel = 0;
    u4.GroupTransparency = 1;
    u4.Position = UDim2.fromOffset(0, 0);
    u4.Visible = true;
    u4.ZIndex = 30;
    u4.Parent = u3;
    local u5 = Instance.new("Frame");
    u5.Name = "Box";
    u5.AutomaticSize = Enum.AutomaticSize.XY;
    u5.BackgroundColor3 = u1;
    u5.Position = UDim2.fromOffset(4, 7);
    u5.ZIndex = 12;
    u5.Parent = u4;
    local v6 = Instance.new("TextLabel");
    v6.Name = "Header";
    v6.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    v6.Text = "Caption";
    v6.TextColor3 = Color3.fromRGB(255, 255, 255);
    v6.TextSize = 15;
    v6.TextTruncate = Enum.TextTruncate.None;
    v6.TextWrapped = false;
    v6.TextXAlignment = Enum.TextXAlignment.Left;
    v6.AutomaticSize = Enum.AutomaticSize.X;
    v6.BackgroundTransparency = 1;
    v6.LayoutOrder = 1;
    v6.Size = UDim2.fromOffset(0, 16);
    v6.ZIndex = 18;
    v6.Parent = u5;
    local v7 = Instance.new("UIListLayout");
    v7.Name = "Layout";
    v7.Padding = UDim.new(0, 8);
    v7.SortOrder = Enum.SortOrder.LayoutOrder;
    v7.Parent = u5;
    local v8 = Instance.new("UICorner");
    v8.Name = "CaptionCorner";
    v8.Parent = u5;
    local v9 = Instance.new("UIPadding");
    v9.Name = "Padding";
    v9.PaddingBottom = UDim.new(0, 12);
    v9.PaddingLeft = UDim.new(0, 12);
    v9.PaddingRight = UDim.new(0, 12);
    v9.PaddingTop = UDim.new(0, 12);
    v9.Parent = u5;
    local u10 = Instance.new("Frame");
    u10.Name = "Hotkeys";
    u10.AutomaticSize = Enum.AutomaticSize.Y;
    u10.BackgroundTransparency = 1;
    u10.LayoutOrder = 3;
    u10.Size = UDim2.fromScale(1, 0);
    u10.Visible = false;
    u10.Parent = u5;
    local v11 = Instance.new("UIListLayout");
    v11.Name = "Layout1";
    v11.Padding = UDim.new(0, 6);
    v11.FillDirection = Enum.FillDirection.Vertical;
    v11.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    v11.HorizontalFlex = Enum.UIFlexAlignment.None;
    v11.ItemLineAlignment = Enum.ItemLineAlignment.Automatic;
    v11.VerticalFlex = Enum.UIFlexAlignment.None;
    v11.SortOrder = Enum.SortOrder.LayoutOrder;
    v11.Parent = u10;
    local v12 = Instance.new("ImageLabel");
    v12.Name = "Key1";
    v12.Image = "rbxasset://textures/ui/Controls/key_single.png";
    v12.ImageTransparency = 0.7;
    v12.ScaleType = Enum.ScaleType.Slice;
    v12.SliceCenter = Rect.new(5, 5, 23, 24);
    v12.AutomaticSize = Enum.AutomaticSize.X;
    v12.BackgroundTransparency = 1;
    v12.LayoutOrder = 1;
    v12.Size = UDim2.fromOffset(0, 30);
    v12.ZIndex = 15;
    v12.Parent = u10;
    local v13 = Instance.new("UIPadding");
    v13.Name = "Inset";
    v13.PaddingLeft = UDim.new(0, 8);
    v13.PaddingRight = UDim.new(0, 8);
    v13.Parent = v12;
    local u14 = Instance.new("TextLabel");
    u14.AutoLocalize = false;
    u14.Name = "LabelContent";
    u14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u14.Text = "";
    u14.TextColor3 = Color3.fromRGB(189, 190, 190);
    u14.TextSize = 15;
    u14.AutomaticSize = Enum.AutomaticSize.X;
    u14.BackgroundTransparency = 1;
    u14.Position = UDim2.fromOffset(0, -1);
    u14.Size = UDim2.fromScale(1, 1);
    u14.ZIndex = 16;
    u14.Parent = v12;
    local u15 = Instance.new("ImageLabel");
    u15.Name = "Caret";
    u15.Image = "rbxassetid://101906294438076";
    u15.ImageColor3 = u1;
    u15.AnchorPoint = Vector2.new(0, 0.5);
    u15.BackgroundTransparency = 1;
    u15.Position = UDim2.new(0, 0, 0, 4);
    u15.Size = UDim2.fromOffset(16, 8);
    u15.ZIndex = 12;
    u15.Parent = u4;
    local u16 = Instance.new("ImageLabel");
    u16.Visible = true;
    u16.Name = "DropShadow";
    u16.Image = "rbxassetid://124920646932671";
    u16.ImageColor3 = Color3.fromRGB(0, 0, 0);
    u16.ImageTransparency = 0.45;
    u16.ScaleType = Enum.ScaleType.Slice;
    u16.SliceCenter = Rect.new(12, 12, 13, 13);
    u16.BackgroundTransparency = 1;
    u16.Position = UDim2.fromOffset(0, 5);
    u16.Size = UDim2.new(1, 0, 0, 48);
    u16.Parent = u4;
    u5:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 145 ]]
        -- upvalues: u16 (copy), u5 (copy)
        u16.Size = UDim2.new(1, 0, 0, u5.AbsoluteSize.Y + 8);
    end);
    local l__captionJanitor__1 = u2.captionJanitor;
    local _, u17 = u2:clipOutside(u4);
    u17.AutomaticSize = Enum.AutomaticSize.None;
    l__captionJanitor__1:add(u4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Name: matchSize, Line 155 ]]
        -- upvalues: u4 (copy), u17 (copy)
        local l__AbsoluteSize__2 = u4.AbsoluteSize;
        u17.Size = UDim2.fromOffset(l__AbsoluteSize__2.X, l__AbsoluteSize__2.Y);
    end));
    local l__AbsoluteSize__3 = u4.AbsoluteSize;
    u17.Size = UDim2.fromOffset(l__AbsoluteSize__3.X, l__AbsoluteSize__3.Y);
    local u18 = false;
    local l__Header__4 = u4.Box.Header;
    local l__UserInputService__5 = game:GetService("UserInputService");
    local function v22(p19) --[[ Line: 168 ]]
        -- upvalues: l__UserInputService__5 (copy), u4 (copy), u2 (copy), l__Header__4 (copy), u14 (copy), u10 (copy)
        local l__KeyboardEnabled__6 = l__UserInputService__5.KeyboardEnabled;
        local v20 = u4:GetAttribute("CaptionText") or "";
        local v21 = v20 == "_hotkey_";
        if l__KeyboardEnabled__6 or not v21 then
            l__Header__4.Text = v20;
            l__Header__4.Visible = not v21;
            if p19 then
                u14.Text = p19.Name;
                u10.Visible = true;
            end;
            if not l__KeyboardEnabled__6 then
                u10.Visible = false;
            end;
        else
            u2:setCaption();
        end;
    end;
    u4:GetAttributeChangedSignal("CaptionText"):Connect(v22);
    local l__Quad__7 = Enum.EasingStyle.Quad;
    local u23 = TweenInfo.new(0.2, l__Quad__7, Enum.EasingDirection.In);
    local u24 = TweenInfo.new(0.2, l__Quad__7, Enum.EasingDirection.Out);
    local l__TweenService__8 = game:GetService("TweenService");
    local l__RunService__9 = game:GetService("RunService");
    local function u36(p25) --[[ Line: 201 ]]
        -- upvalues: u18 (ref), u15 (copy), u4 (copy), u3 (copy), u17 (copy), u23 (copy), u24 (copy), l__TweenService__8 (copy), l__RunService__9 (copy)
        if u18 then
            if p25 == nil then
                p25 = u18;
            end;
            local v26 = not p25;
            if v26 == nil then
                v26 = u18;
            end;
            local v27 = UDim2.new(0.5, 0, 1, v26 and 10 or 2);
            local v28;
            if p25 == nil then
                v28 = u18;
            else
                v28 = p25;
            end;
            local v29 = UDim2.new(0.5, 0, 1, v28 and 10 or 2);
            if p25 then
                u15.Position = UDim2.fromOffset(0, u15.Position.Y.Offset);
                u4.AutomaticSize = Enum.AutomaticSize.XY;
                u4.Size = UDim2.fromOffset(32, 53);
            else
                local l__AbsoluteSize__10 = u4.AbsoluteSize;
                u4.AutomaticSize = Enum.AutomaticSize.Y;
                u4.Size = UDim2.fromOffset(l__AbsoluteSize__10.X, l__AbsoluteSize__10.Y);
            end;
            local u30 = nil;
            local function v33() --[[ Line: 230 ]]
                -- upvalues: u3 (ref), u4 (ref), u15 (ref), u30 (ref)
                local v31 = u3.AbsolutePosition.X - u4.AbsolutePosition.X + u3.AbsoluteSize.X / 2 - u15.AbsoluteSize.X / 2;
                local l__Offset__11 = u15.Position.Y.Offset;
                local v32 = UDim2.fromOffset(v31, l__Offset__11);
                if u30 ~= v31 then
                    u30 = v31;
                    u15.Position = UDim2.fromOffset(0, l__Offset__11);
                    task.wait();
                end;
                u15.Position = v32;
            end;
            u17.Position = v27;
            v33();
            local v34 = l__TweenService__8:Create(u17, p25 and u23 or u24, {
                Position = v29
            });
            local u35 = l__RunService__9.Heartbeat:Connect(v33);
            v34:Play();
            v34.Completed:Once(function() --[[ Line: 253 ]]
                -- upvalues: u35 (copy)
                u35:Disconnect();
            end);
        end;
    end;
    l__captionJanitor__1:add(u3:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 258 ]]
        -- upvalues: u36 (copy)
        u36();
    end));
    u36(false);
    l__captionJanitor__1:add(u2.toggleKeyAdded:Connect(v22));
    for v37, _ in pairs(u2.bindedToggleKeys) do
        local l__KeyboardEnabled__12 = l__UserInputService__5.KeyboardEnabled;
        local v38 = u4:GetAttribute("CaptionText") or "";
        local v39 = v38 == "_hotkey_";
        if l__KeyboardEnabled__12 or not v39 then
            l__Header__4.Text = v38;
            l__Header__4.Visible = not v39;
            if v37 then
                u14.Text = v37.Name;
                u10.Visible = true;
            end;
            if not l__KeyboardEnabled__12 then
                u10.Visible = false;
            end;
        else
            u2:setCaption();
        end;
        break;
    end;
    l__captionJanitor__1:add(u2.fakeToggleKeyChanged:Connect(v22));
    local l__fakeToggleKey__13 = u2.fakeToggleKey;
    if l__fakeToggleKey__13 then
        local l__KeyboardEnabled__14 = l__UserInputService__5.KeyboardEnabled;
        local v40 = u4:GetAttribute("CaptionText") or "";
        local v41 = v40 == "_hotkey_";
        if l__KeyboardEnabled__14 or not v41 then
            l__Header__4.Text = v40;
            l__Header__4.Visible = not v41;
            if l__fakeToggleKey__13 then
                u14.Text = l__fakeToggleKey__13.Name;
                u10.Visible = true;
            end;
            if not l__KeyboardEnabled__14 then
                u10.Visible = false;
            end;
        else
            u2:setCaption();
        end;
    end;
    local function u45(p42) --[[ Line: 274 ]]
        -- upvalues: u18 (ref), u2 (copy), u23 (copy), u24 (copy), l__TweenService__8 (copy), u4 (copy), u17 (copy), u36 (copy), l__UserInputService__5 (copy), l__Header__4 (copy), u10 (copy)
        if u18 == p42 then
        else
            local l__joinedFrame__15 = u2.joinedFrame;
            if l__joinedFrame__15 and string.match(l__joinedFrame__15.Name, "Dropdown") then
                p42 = false;
            end;
            u18 = p42;
            l__TweenService__8:Create(u4, p42 and u23 or u24, {
                GroupTransparency = p42 and 0 or 1
            }):Play();
            if p42 then
                u17:SetAttribute("ForceUpdate", true);
            end;
            u36();
            local l__KeyboardEnabled__16 = l__UserInputService__5.KeyboardEnabled;
            local v43 = u4:GetAttribute("CaptionText") or "";
            local v44 = v43 == "_hotkey_";
            if l__KeyboardEnabled__16 or not v44 then
                l__Header__4.Text = v43;
                l__Header__4.Visible = not v44;
                if not l__KeyboardEnabled__16 then
                    u10.Visible = false;
                end;
            else
                u2:setCaption();
            end;
        end;
    end;
    local l__iconModule__17 = require(u2.iconModule);
    l__captionJanitor__1:add(u2.stateChanged:Connect(function(p46) --[[ Line: 299 ]]
        -- upvalues: l__iconModule__17 (copy), u2 (copy), u45 (copy)
        if p46 == "Viewing" then
            local l__captionLastClosedClock__18 = l__iconModule__17.captionLastClosedClock;
            local v47 = (l__captionLastClosedClock__18 and os.clock() - l__captionLastClosedClock__18 or 999) < 0.3 and 0 or 0.5;
            task.delay(v47, function() --[[ Line: 304 ]]
                -- upvalues: u2 (ref), u45 (ref)
                if u2.activeState == "Viewing" then
                    u45(true);
                end;
            end);
        else
            l__iconModule__17.captionLastClosedClock = os.clock();
            u45(false);
        end;
    end));
    return u4;
end;