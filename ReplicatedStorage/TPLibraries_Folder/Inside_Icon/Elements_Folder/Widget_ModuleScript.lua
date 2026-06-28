-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Widget
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return function(u1, u2) --[[ Line: 6 ]]
    local u3 = Instance.new("Frame");
    u3:SetAttribute("WidgetUID", u1.UID);
    u3.Name = "Widget";
    u3.BackgroundTransparency = 1;
    u3.Visible = true;
    u3.ZIndex = 20;
    u3.Active = false;
    u3.ClipsDescendants = true;
    local u4 = Instance.new("Frame");
    u4.Name = "IconButton";
    u4.Visible = true;
    u4.ZIndex = 2;
    u4.BorderSizePixel = 0;
    u4.Parent = u3;
    u4.ClipsDescendants = true;
    u4.Active = false;
    u1.deselected:Connect(function() --[[ Line: 25 ]]
        -- upvalues: u4 (copy), u1 (copy)
        u4.ClipsDescendants = true;
        task.delay(0.2, function() --[[ Line: 27 ]]
            -- upvalues: u1 (ref), u4 (ref)
            if u1.isSelected then
                u4.ClipsDescendants = false;
            end;
        end);
    end);
    local l__GuiService__1 = game:GetService("GuiService");
    u1:setBehaviour("IconButton", "BackgroundTransparency", function(p5) --[[ Line: 36 ]]
        -- upvalues: l__GuiService__1 (copy)
        local v6 = p5 * l__GuiService__1.PreferredTransparency;
        if p5 == 1 then
            return p5;
        else
            return v6;
        end;
    end);
    u1.janitor:add(l__GuiService__1:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() --[[ Line: 44 ]]
        -- upvalues: u1 (copy), u4 (copy)
        u1:refreshAppearance(u4, "BackgroundTransparency");
    end));
    local v7 = Instance.new("UICorner");
    v7:SetAttribute("Collective", "IconCorners");
    v7.Name = "UICorner";
    v7.Parent = u4;
    local u8 = require(script.Parent.Menu)(u1);
    local l__MenuUIListLayout__2 = u8.MenuUIListLayout;
    local l__MenuGap__3 = u8.MenuGap;
    u8.Parent = u4;
    local u9 = Instance.new("Frame");
    u9.Name = "IconSpot";
    u9.BackgroundColor3 = Color3.fromRGB(225, 225, 225);
    u9.BackgroundTransparency = 0.9;
    u9.Visible = true;
    u9.AnchorPoint = Vector2.new(0, 0.5);
    u9.ZIndex = 5;
    u9.Parent = u8;
    v7:Clone().Parent = u9;
    local v10 = u9:Clone();
    v10.UICorner.Name = "OverlayUICorner";
    v10.Name = "IconOverlay";
    v10.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    v10.ZIndex = u9.ZIndex + 1;
    v10.Size = UDim2.new(1, 0, 1, 0);
    v10.Position = UDim2.new(0, 0, 0, 0);
    v10.AnchorPoint = Vector2.new(0, 0);
    v10.Visible = false;
    v10.Parent = u9;
    local u11 = Instance.new("TextButton");
    u11:SetAttribute("CorrespondingIconUID", u1.UID);
    u11.Name = "ClickRegion";
    u11.BackgroundTransparency = 1;
    u11.Visible = true;
    u11.Text = "";
    u11.ZIndex = 20;
    u11.Selectable = true;
    u11.SelectionGroup = true;
    u11.Parent = u9;
    require(script.Parent.Parent.Features.Gamepad).registerButton(u11);
    v7:Clone().Parent = u11;
    local u12 = Instance.new("Frame");
    u12.Name = "Contents";
    u12.BackgroundTransparency = 1;
    u12.Size = UDim2.fromScale(1, 1);
    u12.Parent = u9;
    local u13 = Instance.new("UIListLayout");
    u13.Name = "ContentsList";
    u13.FillDirection = Enum.FillDirection.Horizontal;
    u13.VerticalAlignment = Enum.VerticalAlignment.Center;
    u13.SortOrder = Enum.SortOrder.LayoutOrder;
    u13.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly;
    u13.Padding = UDim.new(0, 3);
    u13.Parent = u12;
    local u14 = Instance.new("Frame");
    u14.Name = "PaddingLeft";
    u14.LayoutOrder = 1;
    u14.ZIndex = 5;
    u14.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u14.BackgroundTransparency = 1;
    u14.BorderSizePixel = 0;
    u14.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u14.Parent = u12;
    local u15 = Instance.new("Frame");
    u15.Name = "PaddingCenter";
    u15.LayoutOrder = 3;
    u15.ZIndex = 5;
    u15.Size = UDim2.new(0, 0, 1, 0);
    u15.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u15.BackgroundTransparency = 1;
    u15.BorderSizePixel = 0;
    u15.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u15.Parent = u12;
    local u16 = Instance.new("Frame");
    u16.Name = "PaddingRight";
    u16.LayoutOrder = 5;
    u16.ZIndex = 5;
    u16.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u16.BackgroundTransparency = 1;
    u16.BorderSizePixel = 0;
    u16.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u16.Parent = u12;
    local u17 = Instance.new("Frame");
    u17.Name = "IconLabelContainer";
    u17.LayoutOrder = 4;
    u17.ZIndex = 3;
    u17.AnchorPoint = Vector2.new(0, 0.5);
    u17.Size = UDim2.new(0, 0, 0.5, 0);
    u17.BackgroundTransparency = 1;
    u17.Position = UDim2.new(0.5, 0, 0.5, 0);
    u17.Parent = u12;
    local u18 = Instance.new("TextLabel");
    local u19 = workspace.CurrentCamera.ViewportSize.X + 200;
    u18.Name = "IconLabel";
    u18.LayoutOrder = 4;
    u18.ZIndex = 15;
    u18.AnchorPoint = Vector2.new(0, 0);
    u18.Size = UDim2.new(0, u19, 1, 0);
    u18.ClipsDescendants = false;
    u18.BackgroundTransparency = 1;
    u18.Position = UDim2.fromScale(0, 0);
    u18.RichText = true;
    u18.TextColor3 = Color3.fromRGB(255, 255, 255);
    u18.TextXAlignment = Enum.TextXAlignment.Left;
    u18.Text = "";
    u18.TextWrapped = true;
    u18.TextWrap = true;
    u18.TextScaled = false;
    u18.Active = false;
    u18.AutoLocalize = true;
    u18.Parent = u17;
    local u20 = Instance.new("ImageLabel");
    u20.Name = "IconImage";
    u20.LayoutOrder = 2;
    u20.ZIndex = 15;
    u20.AnchorPoint = Vector2.new(0, 0.5);
    u20.Size = UDim2.new(0, 0, 0.5, 0);
    u20.BackgroundTransparency = 1;
    u20.Position = UDim2.new(0, 11, 0.5, 0);
    u20.ScaleType = Enum.ScaleType.Stretch;
    u20.Active = false;
    u20.Parent = u12;
    local v21 = v7:Clone();
    v21:SetAttribute("Collective", nil);
    v21.CornerRadius = UDim.new(0, 0);
    v21.Name = "IconImageCorner";
    v21.Parent = u20;
    local l__TweenService__4 = game:GetService("TweenService");
    local u22 = 0;
    local function v51(_) --[[ Line: 195 ]]
        -- upvalues: u1 (copy), u18 (copy), u20 (copy), u17 (copy), u14 (copy), u15 (copy), u16 (copy), u4 (copy), u13 (copy), u12 (copy), u3 (copy), u19 (copy), u8 (copy), u9 (copy), l__MenuUIListLayout__2 (copy), l__MenuGap__3 (copy), l__TweenService__4 (copy), u11 (copy), u22 (ref), u2 (copy)
        task.defer(function() --[[ Line: 202 ]]
            -- upvalues: u1 (ref), u18 (ref), u20 (ref), u17 (ref), u14 (ref), u15 (ref), u16 (ref), u4 (ref), u13 (ref), u12 (ref), u3 (ref), u19 (ref), u8 (ref), u9 (ref), l__MenuUIListLayout__2 (ref), l__MenuGap__3 (ref), l__TweenService__4 (ref), u11 (ref), u22 (ref), u2 (ref)
            local l__indicator__5 = u1.indicator;
            if l__indicator__5 then
                l__indicator__5 = l__indicator__5.Visible;
            end;
            local v23 = l__indicator__5 or u18.Text ~= "";
            local v24;
            if u20.Image == "" then
                v24 = false;
            else
                v24 = u20.Image ~= nil;
            end;
            local _ = Enum.HorizontalAlignment.Center;
            local v25 = UDim2.fromScale(1, 1);
            if v24 and not v23 then
                u17.Visible = false;
                u20.Visible = true;
                u14.Visible = false;
                u15.Visible = false;
                u16.Visible = false;
            elseif v24 or not v23 then
                if v24 and v23 then
                    u17.Visible = true;
                    u20.Visible = true;
                    u14.Visible = true;
                    u15.Visible = not l__indicator__5;
                    u16.Visible = not l__indicator__5;
                    local _ = Enum.HorizontalAlignment.Left;
                end;
            else
                u17.Visible = true;
                u20.Visible = false;
                u14.Visible = true;
                u15.Visible = false;
                u16.Visible = true;
            end;
            u4.Size = v25;
            local l__Offset__6 = u13.Padding.Offset;
            u17.Size = UDim2.new(0, u18.TextBounds.X, u18.Size.Y.Scale, 0);
            local v26 = l__Offset__6;
            for _, v27 in pairs(u12:GetChildren()) do
                if v27:IsA("GuiObject") and v27.Visible == true then
                    v26 = v26 + ((v27:GetAttribute("TargetWidth") or v27.AbsoluteSize.X) + l__Offset__6);
                end;
            end;
            local v28 = u3:GetAttribute("MinimumWidth");
            local v29 = u3:GetAttribute("MinimumHeight");
            local v30 = u3:GetAttribute("BorderSize");
            local v31 = math.clamp(v26, v28, u19);
            local v32 = 0;
            local v33 = #u1.menuIcons > 0;
            if v33 then
                v33 = u1.isSelected;
            end;
            if v33 then
                for _, v34 in pairs(u8:GetChildren()) do
                    if v34 ~= u9 and (v34:IsA("GuiObject") and v34.Visible) then
                        v32 = v32 + ((v34:GetAttribute("TargetWidth") or v34.AbsoluteSize.X) + l__MenuUIListLayout__2.Padding.Offset);
                    end;
                end;
                if not u9.Visible then
                    local v35 = u9;
                    v31 = v31 - ((v35:GetAttribute("TargetWidth") or v35.AbsoluteSize.X) + l__MenuUIListLayout__2.Padding.Offset * 2 + v30);
                end;
                v32 = v32 - v30 * 0.5;
                v31 = v31 + (v32 - v30 * 0.75);
            end;
            local v36 = l__MenuGap__3;
            if v33 then
                v33 = u9.Visible;
            end;
            v36.Visible = v33;
            local v37 = u3:GetAttribute("DesiredWidth");
            if v37 then
                if v31 >= v37 then
                    v37 = v31;
                end;
            else
                v37 = v31;
            end;
            u1.updateMenu:Fire();
            local v38 = math.max(v37 - v32, v28) - v30 * 2;
            local v39 = u8:GetAttribute("MenuWidth");
            if v39 then
                v39 = v39 + v38 + l__MenuUIListLayout__2.Padding.Offset + 10;
            end;
            if v39 then
                local v40 = u8:GetAttribute("MaxWidth");
                if v40 then
                    v39 = math.max(v40, v28);
                end;
                u8:SetAttribute("MenuCanvasWidth", v37);
                if v39 >= v37 then
                    v39 = v37;
                end;
            else
                v39 = v37;
            end;
            local l__Quint__7 = Enum.EasingStyle.Quint;
            local l__Out__8 = Enum.EasingDirection.Out;
            local v41 = u9;
            local v42 = v41:GetAttribute("TargetWidth") or v41.AbsoluteSize.X;
            local v43 = math.max(v38, v42, u9.AbsoluteSize.X);
            local v44 = u3;
            local v45 = v44:GetAttribute("TargetWidth") or v44.AbsoluteSize.X;
            local v46 = math.max(v39, v45, u3.AbsoluteSize.X);
            local v47 = TweenInfo.new(v43 / 750, l__Quint__7, l__Out__8);
            local v48 = TweenInfo.new(v46 / 750, l__Quint__7, l__Out__8);
            l__TweenService__4:Create(u9, v47, {
                Position = UDim2.new(0, v30, 0.5, 0),
                Size = UDim2.new(0, v38, 1, -v30 * 2)
            }):Play();
            l__TweenService__4:Create(u11, v47, {
                Size = UDim2.new(0, v38, 1, 0)
            }):Play();
            local v49 = UDim2.fromOffset(v39, v29);
            if u3.Size.Y.Offset ~= v29 then
                u3.Size = v49;
            end;
            u3:SetAttribute("TargetWidth", v49.X.Offset);
            l__TweenService__4:Create(u3, v48, {
                Size = v49
            }):Play();
            u22 = u22 + 1;
            for v50 = 1, v48.Time * 100 do
                task.delay(v50 / 100, function() --[[ Line: 314 ]]
                    -- upvalues: u2 (ref), u1 (ref)
                    u2.iconChanged:Fire(u1);
                end);
            end;
            task.delay(v48.Time - 0.2, function() --[[ Line: 318 ]]
                -- upvalues: u22 (ref), u1 (ref)
                u22 = u22 - 1;
                task.defer(function() --[[ Line: 320 ]]
                    -- upvalues: u22 (ref), u1 (ref)
                    if u22 == 0 then
                        u1.resizingComplete:Fire();
                    end;
                end);
            end);
            u1:updateParent();
        end);
    end;
    local u52 = require(script.Parent.Parent.Utility).createStagger(0.01, v51);
    local u53 = true;
    u1:setBehaviour("IconLabel", "Text", u52);
    u1:setBehaviour("IconLabel", "FontFace", function(p54) --[[ Line: 333 ]]
        -- upvalues: u18 (copy), u52 (copy), u53 (ref)
        if u18.FontFace == p54 then
        else
            task.spawn(function() --[[ Line: 338 ]]
                -- upvalues: u52 (ref), u53 (ref)
                u52();
                if u53 then
                    u53 = false;
                    for _ = 1, 10 do
                        task.wait(1);
                        u52();
                    end;
                end;
            end);
        end;
    end);
    local function v57() --[[ Line: 360 ]]
        -- upvalues: u3 (copy), u1 (copy), u9 (copy), u8 (copy), l__MenuGap__3 (copy), l__MenuUIListLayout__2 (copy), u52 (copy)
        task.defer(function() --[[ Line: 361 ]]
            -- upvalues: u3 (ref), u1 (ref), u9 (ref), u8 (ref), l__MenuGap__3 (ref), l__MenuUIListLayout__2 (ref), u52 (ref)
            local v55 = u3:GetAttribute("BorderSize");
            local l__alignment__9 = u1.alignment;
            local v56;
            if u9.Visible == false then
                v56 = 0;
            elseif l__alignment__9 == "Right" then
                v56 = -v55 or v55;
            else
                v56 = v55;
            end;
            u8.Position = UDim2.new(0, v56, 0, 0);
            l__MenuGap__3.Size = UDim2.fromOffset(v55, 0);
            l__MenuUIListLayout__2.Padding = UDim.new(0, 0);
            u52();
        end);
    end;
    u1:setBehaviour("Widget", "BorderSize", v57);
    u1:setBehaviour("IconSpot", "Visible", v57);
    u1.startMenuUpdate:Connect(u52);
    u1.updateSize:Connect(u52);
    u1:setBehaviour("ContentsList", "HorizontalAlignment", u52);
    u1:setBehaviour("Widget", "Visible", u52);
    u1:setBehaviour("Widget", "DesiredWidth", u52);
    u1:setBehaviour("Widget", "MinimumWidth", u52);
    u1:setBehaviour("Widget", "MinimumHeight", u52);
    u1:setBehaviour("Indicator", "Visible", u52);
    u1:setBehaviour("IconImageRatio", "AspectRatio", u52);
    u1:setBehaviour("IconImage", "Image", function(p58) --[[ Line: 382 ]]
        -- upvalues: u20 (copy), u52 (copy)
        local v59 = tonumber(p58) and "http://www.roblox.com/asset/?id=" .. p58 or (p58 or "");
        if u20.Image ~= v59 then
            u52();
        end;
        return v59;
    end);
    u1.alignmentChanged:Connect(function(p60) --[[ Line: 389 ]]
        -- upvalues: l__MenuUIListLayout__2 (copy), u3 (copy), u1 (copy), u9 (copy), u8 (copy), l__MenuGap__3 (copy), u52 (copy)
        l__MenuUIListLayout__2.HorizontalAlignment = Enum.HorizontalAlignment[p60 == "Center" and "Left" or p60];
        task.defer(function() --[[ Line: 361 ]]
            -- upvalues: u3 (ref), u1 (ref), u9 (ref), u8 (ref), l__MenuGap__3 (ref), l__MenuUIListLayout__2 (ref), u52 (ref)
            local v61 = u3:GetAttribute("BorderSize");
            local l__alignment__10 = u1.alignment;
            local v62;
            if u9.Visible == false then
                v62 = 0;
            elseif l__alignment__10 == "Right" then
                v62 = -v61 or v61;
            else
                v62 = v61;
            end;
            u8.Position = UDim2.new(0, v62, 0, 0);
            l__MenuGap__3.Size = UDim2.fromOffset(v61, 0);
            l__MenuUIListLayout__2.Padding = UDim.new(0, 0);
            u52();
        end);
    end);
    local l__LocalPlayer__11 = game:GetService("Players").LocalPlayer;
    local l__LocaleId__12 = l__LocalPlayer__11.LocaleId;
    u1.janitor:add(l__LocalPlayer__11:GetPropertyChangedSignal("LocaleId"):Connect(function() --[[ Line: 401 ]]
        -- upvalues: l__LocalPlayer__11 (copy), l__LocaleId__12 (ref), u1 (copy)
        task.delay(0.2, function() --[[ Line: 402 ]]
            -- upvalues: l__LocalPlayer__11 (ref), l__LocaleId__12 (ref), u1 (ref)
            local l__LocaleId__13 = l__LocalPlayer__11.LocaleId;
            if l__LocaleId__13 ~= l__LocaleId__12 then
                l__LocaleId__12 = l__LocaleId__13;
                u1:refresh();
                task.wait(0.5);
                u1:refresh();
            end;
        end);
    end));
    local u63 = Instance.new("NumberValue");
    u63.Name = "IconImageScale";
    u63.Parent = u20;
    u63:GetPropertyChangedSignal("Value"):Connect(function() --[[ Line: 416 ]]
        -- upvalues: u20 (copy), u63 (copy)
        u20.Size = UDim2.new(u63.Value, 0, u63.Value, 0);
    end);
    local v64 = Instance.new("UIAspectRatioConstraint");
    v64.Name = "IconImageRatio";
    v64.AspectType = Enum.AspectType.FitWithinMaxSize;
    v64.DominantAxis = Enum.DominantAxis.Height;
    v64.Parent = u20;
    local v65 = Instance.new("UIGradient");
    v65.Name = "IconGradient";
    v65.Enabled = true;
    v65.Parent = u4;
    local v66 = Instance.new("UIGradient");
    v66.Name = "IconSpotGradient";
    v66.Enabled = true;
    v66.Parent = u9;
    return u3;
end;