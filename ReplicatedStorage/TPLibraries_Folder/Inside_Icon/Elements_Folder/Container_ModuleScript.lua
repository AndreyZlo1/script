-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Container
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = false;
local u2 = 0;
return function(u3) --[[ Line: 3 ]]
    -- upvalues: u1 (ref), u2 (ref)
    local l__GuiService__1 = game:GetService("GuiService");
    local l__Players__2 = game:GetService("Players");
    local l__UserInputService__3 = game:GetService("UserInputService");
    local v4 = {};
    local u5 = require(script.Parent.Parent.Packages.GoodSignal).new();
    local u6 = l__GuiService__1:GetGuiInset();
    local u7 = 0;
    local u8 = 0;
    local u9 = 0;
    local u10 = 0;
    local u11 = false;
    local u12 = false;
    local function u16(p13) --[[ Line: 20 ]]
        -- upvalues: l__GuiService__1 (copy), u11 (ref), u12 (ref), l__UserInputService__3 (copy), u3 (copy), u10 (ref), u16 (copy), l__Players__2 (copy), u1 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u5 (copy), u2 (ref)
        local l__Height__4 = l__GuiService__1.TopbarInset.Height;
        local v14 = l__Height__4 <= 36;
        u11 = l__GuiService__1:IsTenFootInterface();
        u12 = l__UserInputService__3.VREnabled;
        u3.isOldTopbar = v14;
        u10 = u10 + 1;
        if l__Height__4 == 0 and p13 == nil then
            task.defer(function() --[[ Line: 33 ]]
                -- upvalues: u16 (ref)
                task.wait(8);
                u16("ForceConvertToOld");
            end);
        elseif u10 == 1 then
            task.delay(5, function() --[[ Line: 38 ]]
                -- upvalues: l__Players__2 (ref), u10 (ref), u16 (ref)
                l__Players__2.LocalPlayer:WaitForChild("PlayerGui");
                if u10 == 1 then
                    u16();
                end;
            end);
        end;
        if u3.isOldTopbar and (not u11 and (not u12 and (u1 == false and (l__Height__4 ~= 0 or p13 == "ForceConvertToOld")))) then
            u1 = true;
            task.defer(function() --[[ Line: 50 ]]
                -- upvalues: u3 (ref), l__GuiService__1 (ref)
                local l__Classic__5 = require(script.Parent.Parent.Features.Themes.Classic);
                u3.modifyBaseTheme(l__Classic__5);
                local function v15() --[[ Line: 57 ]]
                    -- upvalues: l__GuiService__1 (ref), u3 (ref)
                    if l__GuiService__1.MenuIsOpen then
                        u3.setTopbarEnabled(false, true);
                    else
                        u3.setTopbarEnabled();
                    end;
                end;
                l__GuiService__1:GetPropertyChangedSignal("MenuIsOpen"):Connect(v15);
                if l__GuiService__1.MenuIsOpen then
                    u3.setTopbarEnabled(false, true);
                else
                    u3.setTopbarEnabled();
                end;
            end);
        end;
        u6 = l__GuiService__1:GetGuiInset();
        u7 = v14 and 12 or u6.Y - 50;
        u8 = v14 and 2 or 0;
        u9 = -2;
        if u11 then
            u7 = 10;
            u8 = 0;
        end;
        if l__GuiService__1.TopbarInset.Height == 0 and not u1 then
            u8 = u8 + 13;
            u9 = 50;
        end;
        u5:Fire(u6);
        local l__Y__6 = u6.Y;
        if l__Y__6 ~= u2 then
            u2 = l__Y__6;
            task.defer(function() --[[ Line: 88 ]]
                -- upvalues: u3 (ref), l__Y__6 (copy)
                u3.insetHeightChanged:Fire(l__Y__6);
            end);
        end;
    end;
    l__GuiService__1:GetPropertyChangedSignal("TopbarInset"):Connect(u16);
    u16("FirstTime");
    local u17 = Instance.new("ScreenGui");
    u5:Connect(function() --[[ Line: 98 ]]
        -- upvalues: u17 (copy), u7 (ref)
        u17:SetAttribute("StartInset", u7);
    end);
    u17.Name = "TopbarStandard";
    u17.Enabled = true;
    u17.DisplayOrder = u3.baseDisplayOrder;
    u17.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    u17.IgnoreGuiInset = true;
    u17.ResetOnSpawn = false;
    u17.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets;
    v4[u17.Name] = u17;
    u3.baseDisplayOrderChanged:Connect(function() --[[ Line: 109 ]]
        -- upvalues: u17 (copy), u3 (copy)
        u17.DisplayOrder = u3.baseDisplayOrder;
    end);
    local u18 = Instance.new("Frame");
    u18.Name = "Holders";
    u18.BackgroundTransparency = 1;
    u5:Connect(function() --[[ Line: 116 ]]
        -- upvalues: u12 (ref), u11 (ref), u9 (ref), u18 (copy), u8 (ref)
        local v19 = u12 and 36 or 56;
        local v20;
        if u11 then
            v20 = UDim2.new(1, 0, 0, v19);
        else
            v20 = UDim2.new(1, 0, 1, u9);
        end;
        u18.Position = UDim2.new(0, 0, 0, u8);
        u18.Size = v20;
    end);
    u18.Visible = true;
    u18.ZIndex = 1;
    u18.Parent = u17;
    local u21 = u17:Clone();
    local l__Holders__7 = u21.Holders;
    local function v22() --[[ Line: 128 ]]
        -- upvalues: l__Holders__7 (copy), l__GuiService__1 (copy), u9 (ref)
        l__Holders__7.Size = UDim2.new(1, 0, 0, l__GuiService__1.TopbarInset.Height + u9);
    end;
    u21.Name = "TopbarCentered";
    u21.DisplayOrder = u3.baseDisplayOrder;
    u21.ScreenInsets = Enum.ScreenInsets.None;
    u3.baseDisplayOrderChanged:Connect(function() --[[ Line: 134 ]]
        -- upvalues: u21 (copy), u3 (copy)
        u21.DisplayOrder = u3.baseDisplayOrder;
    end);
    v4[u21.Name] = u21;
    u5:Connect(v22);
    l__Holders__7.Size = UDim2.new(1, 0, 0, l__GuiService__1.TopbarInset.Height + u9);
    local u23 = u17:Clone();
    u23.Name = u23.Name .. "Clipped";
    u23.DisplayOrder = u3.baseDisplayOrder + 1;
    u3.baseDisplayOrderChanged:Connect(function() --[[ Line: 145 ]]
        -- upvalues: u23 (copy), u3 (copy)
        u23.DisplayOrder = u3.baseDisplayOrder + 1;
    end);
    v4[u23.Name] = u23;
    local u24 = u21:Clone();
    u24.Name = u24.Name .. "Clipped";
    u24.DisplayOrder = u3.baseDisplayOrder + 1;
    u3.baseDisplayOrderChanged:Connect(function() --[[ Line: 153 ]]
        -- upvalues: u24 (copy), u3 (copy)
        u24.DisplayOrder = u3.baseDisplayOrder + 1;
    end);
    v4[u24.Name] = u24;
    local u25 = Instance.new("ScrollingFrame");
    u25:SetAttribute("IsAHolder", true);
    u25.Name = "Left";
    u5:Connect(function() --[[ Line: 162 ]]
        -- upvalues: u25 (copy), u7 (ref)
        u25.Position = UDim2.fromOffset(u7, 0);
    end);
    u25.Size = UDim2.new(1, -24, 1, 0);
    u25.BackgroundTransparency = 1;
    u25.Visible = true;
    u25.ZIndex = 1;
    u25.Active = false;
    u25.ClipsDescendants = true;
    u25.HorizontalScrollBarInset = Enum.ScrollBarInset.None;
    u25.CanvasSize = UDim2.new(0, 0, 1, -1);
    u25.AutomaticCanvasSize = Enum.AutomaticSize.X;
    u25.ScrollingDirection = Enum.ScrollingDirection.X;
    u25.ScrollBarThickness = 0;
    u25.BorderSizePixel = 0;
    u25.Selectable = false;
    u25.ScrollingEnabled = false;
    u25.ElasticBehavior = Enum.ElasticBehavior.Never;
    u25.Parent = u18;
    local u26 = Instance.new("UIListLayout");
    u5:Connect(function() --[[ Line: 183 ]]
        -- upvalues: u26 (copy), u7 (ref)
        u26.Padding = UDim.new(0, u7);
    end);
    u26.FillDirection = Enum.FillDirection.Horizontal;
    u26.SortOrder = Enum.SortOrder.LayoutOrder;
    u26.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    u26.HorizontalAlignment = Enum.HorizontalAlignment.Left;
    u26.Parent = u25;
    local u27 = u25:Clone();
    u5:Connect(function() --[[ Line: 193 ]]
        -- upvalues: u27 (copy), u7 (ref)
        u27.UIListLayout.Padding = UDim.new(0, u7);
    end);
    u27.ScrollingEnabled = false;
    u27.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    u27.Name = "Center";
    u27.Parent = l__Holders__7;
    local u28 = u25:Clone();
    u5:Connect(function() --[[ Line: 202 ]]
        -- upvalues: u28 (copy), u7 (ref)
        u28.UIListLayout.Padding = UDim.new(0, u7);
    end);
    u28.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    u28.Name = "Right";
    u28.AnchorPoint = Vector2.new(1, 0);
    u28.Position = UDim2.new(1, -12, 0, 0);
    u28.Parent = u18;
    u5:Fire(u6);
    return v4;
end;