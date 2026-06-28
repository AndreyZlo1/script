-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Menu
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return function(u1) --[[ Line: 1 ]]
    local u2 = Instance.new("ScrollingFrame");
    u2.Name = "Menu";
    u2.BackgroundTransparency = 1;
    u2.Visible = true;
    u2.ZIndex = 1;
    u2.Size = UDim2.fromScale(1, 1);
    u2.ClipsDescendants = true;
    u2.TopImage = "";
    u2.BottomImage = "";
    u2.HorizontalScrollBarInset = Enum.ScrollBarInset.Always;
    u2.CanvasSize = UDim2.new(0, 0, 1, -1);
    u2.ScrollingEnabled = true;
    u2.ScrollingDirection = Enum.ScrollingDirection.X;
    u2.ZIndex = 20;
    u2.ScrollBarThickness = 3;
    u2.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255);
    u2.ScrollBarImageTransparency = 0.8;
    u2.BorderSizePixel = 0;
    u2.Selectable = false;
    local l__iconModule__1 = require(u1.iconModule);
    local u3 = l__iconModule__1.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone();
    u3.Name = "MenuUIListLayout";
    u3.VerticalAlignment = Enum.VerticalAlignment.Center;
    u3.Parent = u2;
    local v4 = Instance.new("Frame");
    v4.Name = "MenuGap";
    v4.BackgroundTransparency = 1;
    v4.Visible = false;
    v4.AnchorPoint = Vector2.new(0, 0.5);
    v4.ZIndex = 5;
    v4.Parent = u2;
    local u5 = false;
    local l__Themes__2 = require(script.Parent.Parent.Features.Themes);
    u1.menuChildAdded:Connect(function() --[[ Name: totalChildrenChanged, Line 39 ]]
        -- upvalues: u1 (copy), u5 (ref), u2 (copy), l__Themes__2 (copy), u3 (copy)
        local l__menuJanitor__3 = u1.menuJanitor;
        local v6 = #u1.menuIcons;
        if u5 then
            if v6 <= 0 then
                l__menuJanitor__3:clean();
                u5 = false;
            end;
        else
            u5 = true;
            l__menuJanitor__3:add(u1.toggled:Connect(function() --[[ Line: 53 ]]
                -- upvalues: u1 (ref)
                if #u1.menuIcons > 0 then
                    u1.updateSize:Fire();
                end;
            end));
            local _, u7 = u1:modifyTheme({
                { "Menu", "Active", true }
            });
            task.defer(function() --[[ Line: 63 ]]
                -- upvalues: l__menuJanitor__3 (copy), u1 (ref), u7 (copy)
                l__menuJanitor__3:add(function() --[[ Line: 64 ]]
                    -- upvalues: u1 (ref), u7 (ref)
                    u1:removeModification(u7);
                end);
            end);
            local l__X__4 = u2.AbsoluteCanvasSize.X;
            local function v9() --[[ Line: 73 ]]
                -- upvalues: u1 (ref), u2 (ref), l__X__4 (ref)
                if u1.alignment == "Right" then
                    local l__X__5 = u2.AbsoluteCanvasSize.X;
                    local v8 = l__X__4 - l__X__5;
                    l__X__4 = l__X__5;
                    u2.CanvasPosition = Vector2.new(u2.CanvasPosition.X - v8, 0);
                end;
            end;
            l__menuJanitor__3:add(u1.selected:Connect(v9));
            l__menuJanitor__3:add(u2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(v9));
            local v10 = u1:getStateGroup();
            if l__Themes__2.getThemeValue(v10, "IconImage", "Image", "Deselected") == l__Themes__2.getThemeValue(v10, "IconImage", "Image", "Selected") then
                local v11 = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
                u1:removeModificationWith("IconLabel", "Text", "Viewing");
                u1:removeModificationWith("IconLabel", "Image", "Viewing");
                u1:modifyTheme({
                    {
                        "IconLabel",
                        "FontFace",
                        v11,
                        "Selected"
                    },
                    {
                        "IconLabel",
                        "Text",
                        "X",
                        "Selected"
                    },
                    {
                        "IconLabel",
                        "TextSize",
                        20,
                        "Selected"
                    },
                    {
                        "IconLabel",
                        "TextStrokeTransparency",
                        0.8,
                        "Selected"
                    },
                    {
                        "IconImage",
                        "Image",
                        "",
                        "Selected"
                    }
                });
            end;
            local u12 = u1:getInstance("MenuGap");
            l__menuJanitor__3:add(u1.alignmentChanged:Connect(function() --[[ Name: updateAlignent, Line 104 ]]
                -- upvalues: u1 (ref), u12 (copy)
                local v13, v14;
                if u1.alignment == "Right" then
                    v13 = 99999;
                    v14 = 99998;
                else
                    v13 = -99999;
                    v14 = -99998;
                end;
                u1:modifyTheme({ "IconSpot", "LayoutOrder", v13 });
                u12.LayoutOrder = v14;
            end));
            local v15, v16;
            if u1.alignment == "Right" then
                v15 = 99999;
                v16 = 99998;
            else
                v15 = -99999;
                v16 = -99998;
            end;
            u1:modifyTheme({ "IconSpot", "LayoutOrder", v15 });
            u12.LayoutOrder = v16;
            u2:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function() --[[ Line: 120 ]]
                -- upvalues: u2 (ref)
                local v17 = u2:GetAttribute("MenuCanvasWidth");
                local l__Y__6 = u2.CanvasSize.Y;
                u2.CanvasSize = UDim2.new(0, v17, l__Y__6.Scale, l__Y__6.Offset);
            end);
            l__menuJanitor__3:add(u1.updateMenu:Connect(function() --[[ Line: 125 ]]
                -- upvalues: u2 (ref), u3 (ref)
                local v18 = u2:GetAttribute("MaxIcons");
                if not v18 then
                    return;
                end;
                local v19 = {};
                for _, v20 in pairs(u2:GetChildren()) do
                    if v20:GetAttribute("WidgetUID") and v20.Visible then
                        table.insert(v19, { v20, v20.AbsolutePosition.X });
                    end;
                end;
                table.sort(v19, function(p21, p22) --[[ Line: 137 ]]
                    return p21[2] < p22[2];
                end);
                local v23 = 0;
                for v24 = 1, v18 do
                    local v25 = v19[v24];
                    if not v25 then
                        break;
                    end;
                    v23 = v23 + (v25[1].AbsoluteSize.X + u3.Padding.Offset);
                end;
                u2:SetAttribute("MenuWidth", v23);
            end));
            local function v26() --[[ Line: 152 ]]
                -- upvalues: u1 (ref)
                task.delay(0.1, function() --[[ Line: 153 ]]
                    -- upvalues: u1 (ref)
                    u1.startMenuUpdate:Fire();
                end);
            end;
            l__menuJanitor__3:add(u2.ChildAdded:Connect(v26));
            l__menuJanitor__3:add(u2.ChildRemoved:Connect(v26));
            l__menuJanitor__3:add(u2:GetAttributeChangedSignal("MaxIcons"):Connect(v26));
            l__menuJanitor__3:add(u2:GetAttributeChangedSignal("MaxWidth"):Connect(v26));
            task.delay(0.1, function() --[[ Line: 153 ]]
                -- upvalues: u1 (ref)
                u1.startMenuUpdate:Fire();
            end);
        end;
    end);
    u1.menuSet:Connect(function(p27) --[[ Line: 165 ]]
        -- upvalues: u1 (copy), l__iconModule__1 (copy)
        for _, v28 in pairs(u1.menuIcons) do
            l__iconModule__1.getIconByUID(v28):destroy();
        end;
        if type(p27) == "table" then
            for _, v29 in pairs(p27) do
                v29:joinMenu(u1);
            end;
        end;
    end);
    return u2;
end;