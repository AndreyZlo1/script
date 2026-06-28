-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Dropdown
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local l__RunService__2 = game:GetService("RunService");
local l__Themes__3 = require(script.Parent.Parent.Features.Themes);
return function(u1) --[[ Line: 5 ]]
    -- upvalues: l__Themes__3 (copy), l__TweenService__1 (copy), l__RunService__2 (copy)
    local u2 = Instance.new("Frame");
    u2.Name = "Dropdown";
    u2.AutomaticSize = Enum.AutomaticSize.X;
    u2.BackgroundTransparency = 1;
    u2.BorderSizePixel = 0;
    u2.AnchorPoint = Vector2.new(0.5, 0);
    u2.Position = UDim2.new(0.5, 0, 1, 10);
    u2.ZIndex = -2;
    u2.ClipsDescendants = true;
    u2.Parent = u1.widget;
    local l__GuiService__4 = game:GetService("GuiService");
    u1:setBehaviour("Dropdown", "BackgroundTransparency", function(p3) --[[ Line: 20 ]]
        -- upvalues: l__GuiService__4 (copy)
        local v4 = p3 * l__GuiService__4.PreferredTransparency;
        if p3 == 1 then
            return p3;
        else
            return v4;
        end;
    end);
    u1.janitor:add(l__GuiService__4:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() --[[ Line: 28 ]]
        -- upvalues: u1 (copy), u2 (copy)
        u1:refreshAppearance(u2, "BackgroundTransparency");
    end));
    local v5 = Instance.new("UICorner");
    v5.Name = "DropdownCorner";
    v5.CornerRadius = UDim.new(0, 10);
    v5.Parent = u2;
    local u6 = Instance.new("ScrollingFrame");
    u6.Name = "DropdownScroller";
    u6.AutomaticSize = Enum.AutomaticSize.X;
    u6.BackgroundTransparency = 1;
    u6.BorderSizePixel = 0;
    u6.AnchorPoint = Vector2.new(0, 0);
    u6.Position = UDim2.new(0, 0, 0, 0);
    u6.ZIndex = -1;
    u6.ClipsDescendants = true;
    u6.Visible = true;
    u6.VerticalScrollBarInset = Enum.ScrollBarInset.None;
    u6.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right;
    u6.Active = false;
    u6.ScrollingEnabled = true;
    u6.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u6.ScrollBarThickness = 5;
    u6.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255);
    u6.ScrollBarImageTransparency = 0.8;
    u6.CanvasSize = UDim2.new(0, 0, 0, 0);
    u6.Selectable = false;
    u6.Active = true;
    u6.Parent = u2;
    local u7 = Instance.new("NumberValue");
    u7.Name = "DropdownSpeed";
    u7.Value = 0.07;
    u7.Parent = u2;
    local u8 = Instance.new("UIPadding");
    u8.Name = "DropdownPadding";
    u8.PaddingTop = UDim.new(0, 0);
    u8.PaddingBottom = UDim.new(0, 0);
    u8.Parent = u6;
    local v9 = Instance.new("UIListLayout");
    v9.Name = "DropdownList";
    v9.FillDirection = Enum.FillDirection.Vertical;
    v9.SortOrder = Enum.SortOrder.LayoutOrder;
    v9.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    v9.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly;
    v9.Parent = u6;
    local l__dropdownJanitor__5 = u1.dropdownJanitor;
    local l__iconModule__6 = require(u1.iconModule);
    u1.dropdownChildAdded:Connect(function(u10) --[[ Line: 81 ]]
        local _, u11 = u10:modifyTheme({
            { "Widget", "BorderSize", 0 },
            { "IconCorners", "CornerRadius", UDim.new(0, 10) },
            { "Widget", "MinimumWidth", 190 },
            { "Widget", "MinimumHeight", 58 },
            { "IconLabel", "TextSize", 20 },
            { "IconOverlay", "Size", UDim2.new(1, 0, 1, 0) },
            { "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
            { "Notice", "Position", UDim2.new(1, -24, 0, 5) },
            { "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
            { "Selection", "Size", UDim2.new(1, -0, 1, -0) },
            { "Selection", "Position", UDim2.new(0, 0, 0, 0) }
        });
        task.defer(function() --[[ Line: 95 ]]
            -- upvalues: u10 (copy), u11 (copy)
            u10.joinJanitor:add(function() --[[ Line: 96 ]]
                -- upvalues: u10 (ref), u11 (ref)
                u10:removeModification(u11);
            end);
        end);
    end);
    u1.dropdownSet:Connect(function(p12) --[[ Line: 101 ]]
        -- upvalues: u1 (copy), l__iconModule__6 (copy)
        for _, v13 in pairs(u1.dropdownIcons) do
            l__iconModule__6.getIconByUID(v13):destroy();
        end;
        if type(p12) == "table" then
            for _, v14 in pairs(p12) do
                v14:joinDropdown(u1);
            end;
        end;
    end);
    local function u25() --[[ Line: 113 ]]
        -- upvalues: u2 (copy), u6 (copy), u8 (copy)
        local v15 = u2:GetAttribute("MaxIcons");
        if not v15 then
            return 0;
        end;
        local v16 = {};
        for _, v17 in pairs(u6:GetChildren()) do
            if v17:IsA("GuiObject") and v17.Visible then
                table.insert(v16, v17);
            end;
        end;
        table.sort(v16, function(p18, p19) --[[ Line: 124 ]]
            return p18.AbsolutePosition.Y < p19.AbsolutePosition.Y;
        end);
        local v20 = math.ceil(v15);
        local v21 = 0;
        for v22 = 1, v20 do
            local v23 = v16[v22];
            if not v23 then
                break;
            end;
            local l__Y__7 = v23.AbsoluteSize.Y;
            local v24;
            if v22 == v20 then
                v24 = v20 ~= v15;
            else
                v24 = false;
            end;
            if v24 then
                l__Y__7 = l__Y__7 * (v15 - v20 + 1);
            end;
            v21 = v21 + l__Y__7;
        end;
        return v21 + (u8.PaddingTop.Offset + u8.PaddingBottom.Offset);
    end;
    local u26 = nil;
    local u27 = nil;
    local u28 = nil;
    local u29 = nil;
    local function v33() --[[ Line: 159 ]]
        -- upvalues: l__Themes__3 (ref), u2 (copy), u28 (ref), u29 (ref), u7 (copy), u26 (ref), u27 (ref), u1 (copy), u25 (copy), l__TweenService__1 (ref)
        local v30 = l__Themes__3.getInstanceValue(u2, "MaxIcons") or 1;
        local v31;
        if u28 and (u28 == v30 and u29) then
            v31 = u29;
        else
            v31 = TweenInfo.new(u7.Value * v30, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
            u29 = v31;
            u28 = v30;
        end;
        if u26 then
            u26:Cancel();
            u26 = nil;
        end;
        if u27 then
            u27:Cancel();
            u27 = nil;
        end;
        if u1.isSelected then
            local v32 = u25();
            u2.Visible = true;
            u2.BackgroundTransparency = 0;
            u2.Size = UDim2.new(0, u2.Size.X.Offset, 0, 0);
            u26 = l__TweenService__1:Create(u2, v31, {
                Size = UDim2.new(0, u2.Size.X.Offset, 0, v32)
            });
            u26:Play();
            u26.Completed:Connect(function() --[[ Line: 180 ]]
                -- upvalues: u26 (ref)
                u26 = nil;
            end);
        else
            u27 = l__TweenService__1:Create(u2, TweenInfo.new(0), {
                Size = UDim2.new(0, u2.Size.X.Offset, 0, 0)
            });
            u27:Play();
            u27.Completed:Connect(function() --[[ Line: 187 ]]
                -- upvalues: u27 (ref)
                u27 = nil;
            end);
        end;
    end;
    l__dropdownJanitor__5:add(u1.toggled:Connect(v33));
    v33();
    local function u37() --[[ Line: 197 ]]
        -- upvalues: l__Themes__3 (ref), u2 (copy), u28 (ref), u29 (ref), u7 (copy), u1 (copy), u26 (ref), u27 (ref), l__RunService__2 (ref), u25 (copy), l__TweenService__1 (ref)
        local v34 = l__Themes__3.getInstanceValue(u2, "MaxIcons") or 1;
        local v35;
        if u28 and (u28 == v34 and u29) then
            v35 = u29;
        else
            v35 = TweenInfo.new(u7.Value * v34, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
            u29 = v35;
            u28 = v34;
        end;
        if u1.isSelected then
            if u26 then
                u26:Cancel();
                u26 = nil;
            end;
            if u27 then
                u27:Cancel();
                u27 = nil;
            end;
            l__RunService__2.Heartbeat:Wait();
            local v36 = u25();
            u26 = l__TweenService__1:Create(u2, v35, {
                Size = UDim2.new(0, u2.Size.X.Offset, 0, v36)
            });
            u26:Play();
            u26.Completed:Connect(function() --[[ Line: 215 ]]
                -- upvalues: u26 (ref)
                u26 = nil;
            end);
        end;
    end;
    l__dropdownJanitor__5:add(u1.toggled:Connect(v33));
    local u38 = 0;
    local u39 = false;
    local function u55() --[[ Line: 228 ]]
        -- upvalues: u38 (ref), u39 (ref), u55 (copy), u2 (copy), u6 (copy), l__iconModule__6 (copy), u1 (copy), u8 (copy)
        u38 = u38 + 1;
        if u39 then
            return;
        end;
        local u40 = u38;
        u39 = true;
        task.defer(function() --[[ Line: 233 ]]
            -- upvalues: u39 (ref), u38 (ref), u40 (copy), u55 (ref)
            u39 = false;
            if u38 ~= u40 then
                u55();
            end;
        end);
        local v41 = u2:GetAttribute("MaxIcons");
        if not v41 then
            return;
        end;
        local v42 = {};
        for _, v43 in pairs(u6:GetChildren()) do
            if v43:IsA("GuiObject") and v43.Visible then
                table.insert(v42, { v43, v43.AbsolutePosition.Y });
            end;
        end;
        table.sort(v42, function(p44, p45) --[[ Line: 248 ]]
            return p44[2] < p45[2];
        end);
        local v46 = math.ceil(v41);
        local v47 = 0;
        local v48 = false;
        for v49 = 1, v46 do
            local v50 = v42[v49];
            if not v50 then
                break;
            end;
            local v51 = v50[1];
            local l__Y__8 = v51.AbsoluteSize.Y;
            local v52;
            if v49 == v46 then
                v52 = v46 ~= v41;
            else
                v52 = false;
            end;
            if v52 then
                l__Y__8 = l__Y__8 * (v41 - v46 + 1);
            end;
            v47 = v47 + l__Y__8;
            if not v52 then
                local v53 = v51:GetAttribute("WidgetUID");
                if v53 then
                    v53 = l__iconModule__6.getIconByUID(v53);
                end;
                if v53 then
                    local v54;
                    if v48 then
                        v54 = nil;
                    else
                        v54 = u1:getInstance("ClickRegion");
                        v48 = true;
                    end;
                    v53:getInstance("ClickRegion").NextSelectionUp = v54;
                end;
            end;
        end;
        u6.Size = UDim2.fromOffset(0, v47 + (u8.PaddingTop.Offset + u8.PaddingBottom.Offset));
    end;
    l__dropdownJanitor__5:add(u6:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(u55));
    l__dropdownJanitor__5:add(u6.ChildAdded:Connect(u55));
    l__dropdownJanitor__5:add(u6.ChildRemoved:Connect(u37));
    l__dropdownJanitor__5:add(u6.ChildRemoved:Connect(u55));
    l__dropdownJanitor__5:add(u2:GetAttributeChangedSignal("MaxIcons"):Connect(u55));
    l__dropdownJanitor__5:add(u2:GetAttributeChangedSignal("MaxIcons"):Connect(u37));
    l__dropdownJanitor__5:add(u1.childThemeModified:Connect(u55));
    u55();
    for _, v56 in pairs(u6:GetChildren()) do
        if v56:IsA("GuiObject") then
            v56:GetPropertyChangedSignal("Visible"):Connect(u37);
            v56:GetPropertyChangedSignal("Size"):Connect(u37);
        end;
    end;
    u6.ChildAdded:Connect(function(p57) --[[ Line: 305 ]]
        -- upvalues: l__RunService__2 (ref), u37 (copy)
        l__RunService__2.Heartbeat:Wait();
        if p57:IsA("GuiObject") then
            p57:GetPropertyChangedSignal("Visible"):Connect(u37);
            p57:GetPropertyChangedSignal("Size"):Connect(u37);
        end;
        u37();
    end);
    u2.Visible = false;
    return u2;
end;