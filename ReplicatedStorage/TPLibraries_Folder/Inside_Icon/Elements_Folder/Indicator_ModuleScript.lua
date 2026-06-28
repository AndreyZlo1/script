-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Indicator
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return function(u1, _) --[[ Line: 1 ]]
    local l__widget__1 = u1.widget;
    local v2 = u1:getInstance("Contents");
    local u3 = Instance.new("Frame");
    u3.Name = "Indicator";
    u3.LayoutOrder = 9999999;
    u3.ZIndex = 6;
    u3.Size = UDim2.new(0, 42, 0, 42);
    u3.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u3.BackgroundTransparency = 1;
    u3.Position = UDim2.new(1, 0, 0.5, 0);
    u3.BorderSizePixel = 0;
    u3.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    u3.Parent = v2;
    local u4 = Instance.new("Frame");
    u4.Name = "IndicatorButton";
    u4.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u4.AnchorPoint = Vector2.new(0.5, 0.5);
    u4.BorderSizePixel = 0;
    u4.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    u4.Parent = u3;
    local l__GuiService__2 = game:GetService("GuiService");
    local l__GamepadService__3 = game:GetService("GamepadService");
    local u5 = u1:getInstance("ClickRegion");
    local function v6() --[[ Line: 28 ]]
        -- upvalues: l__GuiService__2 (copy), u5 (copy), u4 (copy)
        if l__GuiService__2.SelectedObject == u5 then
            u4.BackgroundTransparency = 1;
            u4.Position = UDim2.new(0.5, -2, 0.5, 0);
            u4.Size = UDim2.fromScale(1.2, 1.2);
        else
            u4.BackgroundTransparency = 0.75;
            u4.Position = UDim2.new(0.5, 2, 0.5, 0);
            u4.Size = UDim2.fromScale(1, 1);
        end;
    end;
    u1.janitor:add(l__GuiService__2:GetPropertyChangedSignal("SelectedObject"):Connect(v6));
    v6();
    local u7 = Instance.new("ImageLabel");
    u7.LayoutOrder = 2;
    u7.ZIndex = 15;
    u7.AnchorPoint = Vector2.new(0.5, 0.5);
    u7.Size = UDim2.new(0.5, 0, 0.5, 0);
    u7.BackgroundTransparency = 1;
    u7.Position = UDim2.new(0.5, 0, 0.5, 0);
    u7.Image = "rbxasset://textures/ui/Controls/XboxController/DPadUp@2x.png";
    u7.Parent = u4;
    local v8 = Instance.new("UICorner");
    v8.CornerRadius = UDim.new(1, 0);
    v8.Parent = u4;
    local l__UserInputService__4 = game:GetService("UserInputService");
    local function u10(p9) --[[ Line: 58 ]]
        -- upvalues: u3 (copy), l__GamepadService__3 (copy), u1 (copy)
        if p9 == nil then
            p9 = u3.Visible;
        end;
        if l__GamepadService__3.GamepadCursorEnabled then
            p9 = false;
        end;
        if p9 then
            u1:modifyTheme({ "PaddingRight", "Size", UDim2.new(0, 0, 1, 0) }, "IndicatorPadding");
        elseif u3.Visible then
            u1:removeModification("IndicatorPadding");
        end;
        u1:modifyTheme({ "Indicator", "Visible", p9 });
        u1.updateSize:Fire();
    end;
    u1.janitor:add(l__GamepadService__3:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(u10));
    u1.indicatorSet:Connect(function(p11) --[[ Line: 74 ]]
        -- upvalues: u7 (copy), l__UserInputService__4 (copy), u10 (copy)
        local v12;
        if p11 then
            u7.Image = l__UserInputService__4:GetImageForKeyCode(p11);
            v12 = true;
        else
            v12 = false;
        end;
        u10(v12);
    end);
    l__widget__1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Name: updateSize, Line 83 ]]
        -- upvalues: l__widget__1 (copy), u3 (copy)
        local v13 = l__widget__1.AbsoluteSize.Y * 0.96;
        u3.Size = UDim2.new(0, v13, 0, v13);
    end);
    local v14 = l__widget__1.AbsoluteSize.Y * 0.96;
    u3.Size = UDim2.new(0, v14, 0, v14);
    return u3;
end;