-- Roblox: Workspace.SilverAce293026.SkydiveHandler
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__ContextActionService__2 = game:GetService("ContextActionService");
local l__Players__3 = game:GetService("Players");
local l__RunService__4 = game:GetService("RunService");
local l__RequestParachute__5 = l__ReplicatedStorage__1:WaitForChild("PlayerEvents"):WaitForChild("RequestParachute");
local l__SkydiveGui__6 = l__Players__3.LocalPlayer.PlayerGui:WaitForChild("SkydiveGui");
local l__TapButton__7 = l__SkydiveGui__6:WaitForChild("Background"):WaitForChild("TapButton");
local l__Parent__8 = script.Parent;
local l__Humanoid__9 = l__Parent__8:WaitForChild("Humanoid");
local u1 = RaycastParams.new();
u1.FilterType = Enum.RaycastFilterType.Exclude;
u1.FilterDescendantsInstances = { l__Parent__8 };
local u2 = false;
local u3 = false;
local u4 = nil;
local function u19() --[[ Line: 54 ]]
    -- upvalues: u3 (ref), u2 (ref), l__RequestParachute__5 (copy), u4 (ref), l__ContextActionService__2 (copy), l__SkydiveGui__6 (copy), l__Parent__8 (copy), l__RunService__4 (copy), u1 (copy)
    if u3 then
    elseif u2 then
        u3 = true;
        l__RequestParachute__5:FireServer(true);
        u2 = false;
        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;
        l__ContextActionService__2:UnbindAction("SkydiveHandler_Parachute");
        local v5 = l__SkydiveGui__6;
        local v6 = u2;
        if v6 then
            v6 = not u3;
        end;
        v5.Enabled = v6;
        script.Open:Play();
        local v7 = 0;
        for _, v8 in l__Parent__8:GetDescendants() do
            if v8:IsA("BasePart") then
                v7 = v7 + v8.Mass;
            end;
        end;
        local u9 = v7 * workspace.Gravity;
        local u10 = Instance.new("Attachment");
        u10.Parent = l__Parent__8.PrimaryPart;
        local u11 = Instance.new("LinearVelocity");
        u11.Parent = l__Parent__8.PrimaryPart;
        u11.RelativeTo = Enum.ActuatorRelativeTo.World;
        u11.Attachment0 = u10;
        u11.ForceLimitsEnabled = true;
        u11.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
        local u12 = u9 * 0.5;
        u11.MaxAxesForce = Vector3.new(0, u12, 0);
        u11.VectorVelocity = Vector3.new(0, -14, 0);
        local u13 = nil;
        u13 = l__RunService__4.Heartbeat:Connect(function(_) --[[ Line: 100 ]]
            -- upvalues: u12 (ref), u9 (copy), u11 (copy), l__Parent__8 (ref), l__RequestParachute__5 (ref), u13 (ref), u10 (copy), u3 (ref), l__SkydiveGui__6 (ref), u2 (ref), u1 (ref)
            u12 = u12 + u9 / 4;
            u11.MaxAxesForce = Vector3.new(0, u12, 0);
            if l__Parent__8.Humanoid.SeatPart then
                l__RequestParachute__5:FireServer(false);
                u13:Disconnect();
                u11:Destroy();
                u10:Destroy();
                u3 = false;
                local v14 = l__SkydiveGui__6;
                local v15 = u2;
                if v15 then
                    v15 = not u3;
                end;
                v14.Enabled = v15;
            else
                local v16 = workspace:Raycast(l__Parent__8.PrimaryPart.Position, Vector3.new(0, -8, 0), u1);
                if v16 and v16.Instance then
                    local l__Instance__10 = v16.Instance;
                    if l__Instance__10.CollisionGroup == "CamCast" or l__Instance__10.CollisionGroup == "CamCastIgnore" then
                        return;
                    end;
                    if not l__Instance__10.CanCollide then
                        return;
                    end;
                    l__RequestParachute__5:FireServer(false);
                    u13:Disconnect();
                    u11:Destroy();
                    u10:Destroy();
                    u3 = false;
                    local v17 = l__SkydiveGui__6;
                    local v18 = u2;
                    if v18 then
                        v18 = not u3;
                    end;
                    v17.Enabled = v18;
                end;
            end;
        end);
    end;
end;
local function u21() --[[ Line: 129 ]]
    -- upvalues: u2 (ref), u4 (ref), l__TapButton__7 (copy), u19 (copy), l__ContextActionService__2 (copy)
    u2 = true;
    u4 = l__TapButton__7.Activated:Connect(function() --[[ Line: 132 ]]
        -- upvalues: u19 (ref)
        u19();
    end);
    l__ContextActionService__2:BindActionAtPriority("SkydiveHandler_Parachute", function(_, p20) --[[ Line: 136 ]]
        -- upvalues: u19 (ref)
        if p20 == Enum.UserInputState.End then
            u19();
        end;
    end, false, 10000000, Enum.KeyCode.Space, Enum.KeyCode.ButtonX);
end;
l__RunService__4.Heartbeat:Connect(function(_) --[[ Name: runCheck, Line 142 ]]
    -- upvalues: l__Humanoid__9 (copy), u2 (ref), u4 (ref), l__ContextActionService__2 (copy), l__SkydiveGui__6 (copy), u3 (ref), l__Parent__8 (copy), u21 (copy)
    if l__Humanoid__9.SeatPart then
        if u2 then
            u2 = false;
            if u4 then
                u4:Disconnect();
                u4 = nil;
            end;
            l__ContextActionService__2:UnbindAction("SkydiveHandler_Parachute");
            local v22 = l__SkydiveGui__6;
            local v23 = u2;
            if v23 then
                v23 = not u3;
            end;
            v22.Enabled = v23;
        end;
    elseif l__Parent__8.PrimaryPart.AssemblyLinearVelocity.Y <= -55 then
        if u2 then
        else
            u21();
            local v24 = l__SkydiveGui__6;
            local v25 = u2;
            if v25 then
                v25 = not u3;
            end;
            v24.Enabled = v25;
        end;
    elseif u2 then
        u2 = false;
        if u4 then
            u4:Disconnect();
            u4 = nil;
        end;
        l__ContextActionService__2:UnbindAction("SkydiveHandler_Parachute");
        local v26 = l__SkydiveGui__6;
        local v27 = u2;
        if v27 then
            v27 = not u3;
        end;
        v26.Enabled = v27;
    end;
end);