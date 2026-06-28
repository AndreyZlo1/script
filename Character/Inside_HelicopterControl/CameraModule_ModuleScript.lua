-- Roblox: Workspace.SilverAce293026.HelicopterControl.CameraModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__RunService__1 = game:GetService("RunService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__Players__3 = game:GetService("Players");
local l__TweenService__4 = game:GetService("TweenService");
local u2 = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
local l__InputModule__5 = require(script.Parent:WaitForChild("InputModule"));
local l__Character__6 = l__Players__3.LocalPlayer.Character;
function u1.CameraLoop(p3) --[[ Line: 21 ]]
    -- upvalues: u1 (copy), l__UserInputService__2 (copy)
    if u1.helicopterModel then
        l__UserInputService__2.MouseBehavior = Enum.MouseBehavior.LockCenter;
        l__UserInputService__2.MouseIconEnabled = false;
        local l__CurrentCamera__7 = workspace.CurrentCamera;
        l__CurrentCamera__7.CameraType = Enum.CameraType.Scriptable;
        l__CurrentCamera__7.CameraSubject = nil;
        local v4 = u1.cameraViews[u1.viewIndex];
        local l__CFrame__8 = v4.OriginPart.CFrame;
        local v5 = math.sin(u1.targetYaw);
        local v6 = math.cos(u1.targetYaw);
        local v7 = math.sin(u1.targetPitch);
        local v8 = math.cos(u1.targetPitch);
        local v9;
        if v4.KeepInPlace then
            local v10 = l__CFrame__8 * CFrame.new(0, v4.Height, v4.Distance) * CFrame.new(v4.RelativePosOffset or Vector3.new());
            local v11 = v10 * CFrame.new(v4.LookOffset);
            local v12 = CFrame.new(v10.Position, v11.Position);
            local v13 = v12 * CFrame.new(v5, 0, v6);
            local v14 = CFrame.new(v12.Position, v13.Position) * CFrame.new(0, v8, v7);
            v9 = CFrame.new(v12.Position, v14.Position);
        else
            local u15 = l__CFrame__8 * CFrame.new(v5, 0, v6);
            local v16 = CFrame.new(u15.Position, l__CFrame__8.Position);
            local v17 = CFrame.new(l__CFrame__8.Position, v16.Position) * CFrame.new(0, v8, v7);
            local v18 = CFrame.new(v17.Position, l__CFrame__8.Position);
            local v19 = u15.Position + (l__CFrame__8.Position - v18.Position) * (u1.speedDistance + v4.Distance) + Vector3.new(0, v4.Height, 0);
            local u20 = l__CFrame__8 * CFrame.new(v4.LookOffset);
            local u21 = Vector3.new(0, v4.Height or 0, 0);
            local u22 = CFrame.new(v19, u20.Position + u21);
            local function v24() --[[ Line: 67 ]]
                -- upvalues: u15 (copy), u22 (ref), u1 (ref), u20 (copy), u21 (copy)
                local l__Position__9 = u15.Position;
                local v23 = workspace:Raycast(l__Position__9, u22.Position - l__Position__9, u1.popperParams);
                if v23 and v23.Instance then
                    if v23.Instance.Transparency == 1 then
                    else
                        u22 = CFrame.new(v23.Position, u20.Position + u21);
                    end;
                end;
            end;
            if u1.viewIndex == 2 then
                v9 = u22;
            else
                v24();
                v9 = u22;
            end;
        end;
        l__CurrentCamera__7.CFrame = l__CurrentCamera__7.CFrame:Lerp(v9, (v4.SkipLerp or u1.freelook) and 1 or p3 * 4);
    end;
end;
function u1.SetSpeedDistance(p25) --[[ Line: 86 ]]
    -- upvalues: u1 (copy)
    u1.speedDistance = p25;
end;
function u1.SetHeli(p26) --[[ Line: 90 ]]
    -- upvalues: u1 (copy), l__Character__6 (copy), l__RunService__1 (copy), l__InputModule__5 (copy), l__TweenService__4 (copy), u2 (copy)
    u1.helicopterModel = p26;
    u1.seat = u1.helicopterModel.Required.HeliSeat;
    u1.popperParams = RaycastParams.new();
    u1.popperParams.FilterType = Enum.RaycastFilterType.Exclude;
    u1.popperParams.CollisionGroup = "CamCast";
    u1.popperParams.FilterDescendantsInstances = { u1.helicopterModel, l__Character__6 };
    u1.isZoomed = false;
    u1.camConn = l__RunService__1.RenderStepped:Connect(u1.CameraLoop);
    u1.speedDistance = 0;
    u1.targetPitch = 1.7207963267948965;
    u1.targetYaw = 6.283185307179586;
    u1.interpolatedPitch = 0;
    u1.interpolatedYaw = 0;
    local v27 = u1.seat:FindFirstChild("Views");
    local v28;
    if v27 then
        v28 = require(v27)(u1.helicopterModel, l__Character__6);
    else
        v28 = nil;
    end;
    u1.cameraViews = v28 or {
        {
            OriginPart = u1.helicopterModel.Required.Engine,
            LookOffset = Vector3.new(),
            Distance = u1.helicopterModel:GetAttribute("ExternalZoom") or 30,
            Height = 7 + (u1.helicopterModel:GetAttribute("ExternalHeight") or 0)
        },
        {
            LookOffset = Vector3.new(0, 0, -5),
            Distance = -1.5,
            Height = 2,
            KeepInPlace = true,
            SkipLerp = true,
            OriginPart = l__Character__6.HumanoidRootPart
        }
    };
    u1.viewIndex = 1;
    local v29 = l__InputModule__5.GetBoundScheme("Heli");
    v29:SubscribeToControl("PitchAndYaw", function(p30, _) --[[ Line: 145 ]]
        -- upvalues: u1 (ref)
        if u1.freelook then
            if p30.Input == Enum.UserInputType.MouseMovement then
                local l__Delta__10 = p30.Delta;
                local v31 = u1;
                v31.targetYaw = v31.targetYaw - l__Delta__10.X / 130;
                local v32 = u1;
                v32.targetPitch = v32.targetPitch + l__Delta__10.Y / 130;
            else
                local l__Position__11 = p30.Position;
                if math.abs(l__Position__11.X) > 0.15 then
                    local v33 = u1;
                    v33.targetYaw = v33.targetYaw - l__Position__11.X / 25;
                end;
                if math.abs(l__Position__11.Y) > 0.15 then
                    local v34 = u1;
                    v34.targetPitch = v34.targetPitch - l__Position__11.Y / 25;
                end;
            end;
            u1.targetPitch = math.clamp(u1.targetPitch, 0.14, 3);
        end;
    end);
    v29:SubscribeToControl("Freelook", function(p35, p36) --[[ Line: 168 ]]
        -- upvalues: u1 (ref)
        if p36 == Enum.UserInputState.Change then
        elseif p35.Pressed or p35.Unpressed then
            if p35.Pressed then
                u1.freelook = true;
            else
                if p35.Unpressed then
                    u1.freelook = false;
                    u1.targetPitch = 1.7207963267948965;
                    u1.targetYaw = 6.283185307179586;
                end;
            end;
        end;
    end);
    v29:SubscribeToControl("SwapView", function(p37, _) --[[ Line: 179 ]]
        -- upvalues: u1 (ref)
        if p37.Pressed then
            local v38 = u1;
            v38.viewIndex = v38.viewIndex + 1;
            if u1.viewIndex > #u1.cameraViews then
                u1.viewIndex = 1;
            end;
        end;
    end);
    v29:SubscribeToControl("Zoom", function(p39, _) --[[ Line: 187 ]]
        -- upvalues: u1 (ref), l__TweenService__4 (ref), u2 (ref)
        if p39.Pressed then
            u1.isZoomed = not u1.isZoomed;
            l__TweenService__4:Create(workspace.CurrentCamera, u2, {
                FieldOfView = u1.isZoomed and 45 or 70
            }):Play();
        end;
    end);
end;
function u1.UnsetHeli() --[[ Line: 199 ]]
    -- upvalues: u1 (copy), l__RunService__1 (copy), l__UserInputService__2 (copy), l__Character__6 (copy)
    u1.helicopterModel = nil;
    u1.camConn:Disconnect();
    u1.camConn = nil;
    l__RunService__1.RenderStepped:Wait();
    l__UserInputService__2.MouseBehavior = Enum.MouseBehavior.Default;
    l__UserInputService__2.MouseIconEnabled = true;
    local l__CurrentCamera__12 = workspace.CurrentCamera;
    l__CurrentCamera__12.CameraType = Enum.CameraType.Custom;
    l__CurrentCamera__12.CameraSubject = l__Character__6:FindFirstChild("Humanoid");
    l__CurrentCamera__12.FieldOfView = 70;
    u1.cameraViews = nil;
end;
return u1;