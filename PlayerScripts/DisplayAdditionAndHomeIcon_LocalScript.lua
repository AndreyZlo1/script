-- Roblox: Players.SilverAce293026.PlayerScripts.DisplayAdditionAndHomeIcon
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__DisplayAdditionEvent__3 = l__ReplicatedStorage__2:WaitForChild("DisplayAdditionEvent");
local l__LocalPlayer__4 = l__Players__1.LocalPlayer;
if require(l__ReplicatedStorage__2:WaitForChild("ReplicatedConfig")).Mode == "Tycoon" then
    local l__AssociatedTycoon__5 = l__LocalPlayer__4:WaitForChild("AssociatedTycoon", (1 / 0));
    local u1 = workspace:FindFirstChild(l__AssociatedTycoon__5.Value);
    local l__Debris__6 = game:GetService("Debris");
    local l__TweenService__7 = game:GetService("TweenService");
    local u2 = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut);
    local u3 = Color3.new(0, 255, 0);
    if u1 then
        (function() --[[ Name: setHomeIcon, Line 25 ]]
            -- upvalues: l__LocalPlayer__4 (copy), l__Players__1 (copy), u1 (copy)
            local v4, _ = l__Players__1:GetUserThumbnailAsync(l__LocalPlayer__4.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            local l__ImageLabel__8 = u1:WaitForChild("RootPart"):WaitForChild("HomeGui"):WaitForChild("ImageLabel");
            l__ImageLabel__8.Image = v4;
            l__ImageLabel__8.Visible = true;
        end)();
        l__DisplayAdditionEvent__3.OnClientEvent:Connect(function(p5, p6, p7) --[[ Name: displayAdditionGui, Line 39 ]]
            -- upvalues: u1 (copy), u3 (copy), l__TweenService__7 (copy), u2 (copy), l__Debris__6 (copy)
            local v8 = u1.Constructions:FindFirstChild("Derrick" .. p5);
            if v8 == nil then
            elseif v8:FindFirstChild("DerrickIndicatorPart") then
                local v9 = Instance.new("BillboardGui", v8.DerrickIndicatorPart);
                v9.Size = UDim2.new(4, 0, 4, 0);
                v9.StudsOffset = Vector3.new(0, 5, 0);
                local v10 = Instance.new("TextLabel");
                v10.AnchorPoint = Vector2.new(0.5, 0.5);
                v10.Position = UDim2.new(0.5, 0, 0.5, 0);
                v10.TextScaled = true;
                v10.BackgroundTransparency = 1;
                v10.Text = "+" .. p6 .. "$";
                v10.Size = UDim2.new(0, 0, 0, 0);
                if p7 == nil or not p7 then
                    p7 = u3;
                end;
                v10.TextColor3 = p7;
                v10.TextStrokeColor3 = Color3.new(0, 0, 0);
                v10.TextStrokeTransparency = 0;
                v10.Parent = v9;
                v10:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3);
                task.wait(0.3);
                local v11 = l__TweenService__7:Create(v9, u2, {
                    StudsOffset = v9.StudsOffset + Vector3.new(0, 1, 0)
                });
                local v12 = l__TweenService__7:Create(v10, u2, {
                    TextTransparency = 1
                });
                v11:Play();
                v12:Play();
                l__Debris__6:AddItem(v9, 0.3);
            end;
        end);
    else
        warn("Tycoon not found! | DisplayAdditionGui");
    end;
end;