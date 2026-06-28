-- Roblox: Workspace.SilverAce293026.BeaconTest
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__RunService__2 = game:GetService("RunService");
local l__LocalPlayer__3 = l__Players__1.LocalPlayer;
local l__Parttttt__4 = workspace:WaitForChild("Parttttt");
local l__CurrentCamera__5 = workspace.CurrentCamera;
local l__TutorialGuiWIP__6 = l__LocalPlayer__3.PlayerGui:WaitForChild("TutorialGuiWIP");
local l__ObjectFrame__7 = l__TutorialGuiWIP__6:WaitForChild("ObjectFrame");
local l__ArrowFrame__8 = l__ObjectFrame__7:WaitForChild("ArrowFrame");
local l__TextLabel__9 = l__ObjectFrame__7:WaitForChild("TextLabel");
require(l__TutorialGuiWIP__6:WaitForChild("TutorialModule")).animate();
local function u12(p1) --[[ Line: 27 ]]
    -- upvalues: l__ObjectFrame__7 (copy), l__TutorialGuiWIP__6 (copy)
    local v2 = l__ObjectFrame__7.Size.X.Scale * l__TutorialGuiWIP__6.AbsoluteSize.X / 2;
    local v3 = math.min(l__TutorialGuiWIP__6.AbsoluteSize.X, l__TutorialGuiWIP__6.AbsoluteSize.Y);
    local v4 = l__TutorialGuiWIP__6.AbsoluteSize.X / 2;
    local v5 = l__TutorialGuiWIP__6.AbsoluteSize.Y / 2;
    local v6 = math.rad(p1);
    local v7 = v4 + v3 * math.cos(v6);
    local v8 = math.clamp(v7, v2, l__TutorialGuiWIP__6.AbsoluteSize.X - v2);
    local v9 = math.rad(p1);
    local v10 = v5 + v3 * math.sin(v9);
    local v11 = math.clamp(v10, v2, l__TutorialGuiWIP__6.AbsoluteSize.Y - v2);
    return UDim2.new(0, v8, 0, v11);
end;
l__RunService__2.RenderStepped:Connect(function(_) --[[ Line: 39 ]]
    -- upvalues: l__ObjectFrame__7 (copy), l__TutorialGuiWIP__6 (copy), l__CurrentCamera__5 (copy), l__Parttttt__4 (copy), l__ArrowFrame__8 (copy), l__TextLabel__9 (copy), u12 (copy)
    local v13 = l__ObjectFrame__7.Size.X.Scale * l__TutorialGuiWIP__6.AbsoluteSize.X / 2;
    local v14, _ = l__CurrentCamera__5:WorldToViewportPoint(l__Parttttt__4.Position);
    local v15 = (v14.Z <= 0 or (v14.X > l__TutorialGuiWIP__6.AbsoluteSize.X - v13 or (v14.X < v13 or v14.Y > l__TutorialGuiWIP__6.AbsoluteSize.Y - v13))) and true or v14.Y < v13;
    l__ArrowFrame__8.Visible = v15;
    l__TextLabel__9.Visible = not v15;
    if v15 then
        local l__Position__10 = l__Parttttt__4.Position;
        local l__CFrame__11 = l__CurrentCamera__5.CFrame;
        local v16 = CFrame.new(l__CFrame__11.Position, l__CFrame__11.Position + l__CFrame__11.LookVector * Vector3.new(1, 0, 1)):PointToObjectSpace(l__Position__10);
        local v17 = math.atan2(v16.Z, v16.X);
        local v18 = math.deg(v17);
        l__ArrowFrame__8.Rotation = v18 + 90;
        l__ObjectFrame__7.Position = u12(v18);
    else
        l__ObjectFrame__7.Position = UDim2.new(0, v14.X, 0, v14.Y);
    end;
end);