-- Roblox: ReplicatedStorage.TPLibraries.Icon.Elements.Selection
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return function(_) --[[ Line: 1 ]]
    local v1 = Instance.new("Frame");
    v1.Name = "SelectionContainer";
    v1.Visible = false;
    local u2 = Instance.new("Frame");
    u2.Name = "Selection";
    u2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u2.BackgroundTransparency = 1;
    u2.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u2.BorderSizePixel = 0;
    u2.Parent = v1;
    local v3 = Instance.new("UIStroke");
    v3.Name = "UIStroke";
    v3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    v3.Color = Color3.fromRGB(255, 255, 255);
    v3.Thickness = 3;
    v3.Parent = u2;
    local u4 = Instance.new("UIGradient");
    u4.Name = "SelectionGradient";
    u4.Parent = v3;
    local v5 = Instance.new("UICorner");
    v5:SetAttribute("Collective", "IconCorners");
    v5.Name = "UICorner";
    v5.CornerRadius = UDim.new(1, 0);
    v5.Parent = u2;
    local l__RunService__1 = game:GetService("RunService");
    local l__GuiService__2 = game:GetService("GuiService");
    local u6 = 1;
    u2:GetAttributeChangedSignal("RotationSpeed"):Connect(function() --[[ Line: 37 ]]
        -- upvalues: u6 (ref), u2 (copy)
        u6 = u2:GetAttribute("RotationSpeed");
    end);
    l__RunService__1.Heartbeat:Connect(function() --[[ Line: 40 ]]
        -- upvalues: l__GuiService__2 (copy), u4 (copy), u6 (ref)
        if l__GuiService__2.SelectedObject then
            u4.Rotation = os.clock() * u6 * 100 % 360;
        end;
    end);
    return v1;
end;