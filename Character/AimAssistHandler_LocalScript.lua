-- Roblox: Workspace.SilverAce293026.AimAssistHandler
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__RunService__3 = game:GetService("RunService");
local l__GuiService__4 = game:GetService("GuiService");
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local l__Character__6 = l__LocalPlayer__5.Character;
local l__Camera__7 = workspace.Camera;
local l__Modules__8 = l__ReplicatedStorage__1:WaitForChild("Modules");
local l__HumanoidRootPart__9 = l__Character__6:WaitForChild("HumanoidRootPart");
local l__Circle__10 = l__LocalPlayer__5:WaitForChild("PlayerGui"):WaitForChild("AimAssistGui"):WaitForChild("Circle");
local l__AimAssist__11 = require(l__Modules__8:WaitForChild("AimAssist"));
local l__Head__12 = l__Character__6:WaitForChild("Head");
local function u8(p1) --[[ Line: 18 ]]
    -- upvalues: l__GuiService__4 (copy), l__Circle__10 (copy)
    local l__Y__13 = l__GuiService__4:GetGuiInset().Y;
    local v2 = l__Circle__10.AbsolutePosition + Vector2.new(0, l__Y__13);
    local l__AbsoluteSize__14 = l__Circle__10.AbsoluteSize;
    local v3 = v2.X + l__AbsoluteSize__14.X / 2;
    local v4 = v2.Y + l__AbsoluteSize__14.Y / 2;
    local v5 = l__AbsoluteSize__14.X / 2;
    local v6 = p1.X - v3;
    local v7 = p1.Y - v4;
    return math.sqrt(v6 * v6 + v7 * v7) <= v5;
end;
local function u11(p9) --[[ Line: 36 ]]
    -- upvalues: l__Camera__7 (copy), l__LocalPlayer__5 (copy)
    local l__Position__15 = p9.Position;
    local l__Position__16 = l__Camera__7.CFrame.Position;
    local l__LookVector__17 = CFrame.new(l__Position__16, l__Position__15).LookVector;
    local l__Magnitude__18 = (l__Position__15 - l__Position__16).Magnitude;
    local v10 = RaycastParams.new();
    v10.FilterType = Enum.RaycastFilterType.Exclude;
    v10.FilterDescendantsInstances = { p9.Parent, l__LocalPlayer__5.Character };
    return workspace:Raycast(l__Position__16, l__LookVector__17 * l__Magnitude__18, v10) ~= nil;
end;
local function u23() --[[ Line: 53 ]]
    -- upvalues: l__Camera__7 (copy), l__LocalPlayer__5 (copy), u8 (copy), u11 (copy)
    local v12 = 2000000000;
    local v13 = nil;
    for _, v14 in pairs(workspace.AimAssistTest:GetChildren()) do
        local l__Head__19 = v14.Head;
        local l__Position__20 = l__Head__19.Position;
        local v15, v16 = l__Camera__7:WorldToViewportPoint(l__Position__20);
        local v17 = l__LocalPlayer__5:DistanceFromCharacter(l__Position__20);
        if v16 and (u8(v15) and (u11(l__Head__19) == false and v17 < v12)) then
            v13 = l__Head__19;
            v12 = v17;
        end;
    end;
    for _, v18 in pairs(game.Players:GetPlayers()) do
        if v18 ~= l__LocalPlayer__5 and (v18.Character ~= nil and (v18.Character:FindFirstChild("Head") ~= nil and (v18.Character:FindFirstChild("Humanoid") ~= nil and v18.Character.Humanoid.Health > 0))) then
            local v19 = v18:GetAttribute("MG_Team");
            if not v19 or v19 ~= l__LocalPlayer__5:GetAttribute("MG_Team") then
                local l__Head__21 = v18.Character.Head;
                local l__Position__22 = l__Head__21.Position;
                local v20, v21 = l__Camera__7:WorldToViewportPoint(l__Position__22);
                local v22 = l__LocalPlayer__5:DistanceFromCharacter(l__Position__22);
                if v21 and (u8(v20) and (not u11(l__Head__21) and v22 < v12)) then
                    v13 = l__Head__21;
                    v12 = v22;
                end;
            end;
        end;
    end;
    return v13;
end;
l__RunService__3.Heartbeat:Connect(function(p24) --[[ Line: 120 ]]
    -- upvalues: l__Head__12 (copy), l__Camera__7 (copy), l__UserInputService__2 (copy), l__LocalPlayer__5 (copy), l__AimAssist__11 (copy), u23 (copy), l__HumanoidRootPart__9 (copy)
    if l__Head__12 == nil or l__Head__12.Parent == nil then
    else
        local v25 = (l__Head__12.Position - l__Camera__7.CFrame.Position).Magnitude <= 1.9;
        local v26 = l__UserInputService__2:GetLastInputType();
        local v27 = false;
        local v28 = not v27 and (v26 ~= Enum.UserInputType.Touch and v26 ~= Enum.UserInputType.Gamepad1) and true or v27;
        local v29 = not v28 and (v26 == Enum.UserInputType.Touch and not l__LocalPlayer__5:GetAttribute("MobileAimAssistEnabled")) and true or v28;
        if not v29 and (v26 == Enum.UserInputType.Gamepad1 and not l__LocalPlayer__5:GetAttribute("ConsoleAimAssistEnabled")) and true or v29 or not v25 then
            l__AimAssist__11.SensitivityMultiplier = 1;
            l__AimAssist__11.CurrentTargetInfo = nil;
        else
            local v30 = u23();
            if v30 then
                l__AimAssist__11.SensitivityMultiplier = l__AimAssist__11.InCircleSensitivity;
                l__AimAssist__11.CurrentTargetInfo = {
                    TargetPosition = v30.Position,
                    TargetVelocity = v30.Velocity,
                    CurrentCameraCF = l__Camera__7.CFrame,
                    PlayerVelocity = l__HumanoidRootPart__9.Velocity,
                    DeltaTime = p24
                };
            else
                l__AimAssist__11.SensitivityMultiplier = 1;
                l__AimAssist__11.CurrentTargetInfo = nil;
            end;
        end;
    end;
end);