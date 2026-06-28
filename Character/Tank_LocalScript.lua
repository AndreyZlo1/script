-- Roblox: Workspace.SilverAce293026.Tank
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ContextActionService__2 = game:GetService("ContextActionService");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__RunService__4 = game:GetService("RunService");
local l__TweenService__5 = game:GetService("TweenService");
local l__ReplicatedStorage__6 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__7 = l__Players__1.LocalPlayer;
local l__Character__8 = l__LocalPlayer__7.Character;
local l__Humanoid__9 = l__Character__8:WaitForChild("Humanoid");
local l__CurrentCamera__10 = workspace.CurrentCamera;
local l__TankGui__11 = l__LocalPlayer__7.PlayerGui:WaitForChild("TankGui");
local u1 = l__ReplicatedStorage__6:WaitForChild("Aimpart"):Clone();
local l__Reload__12 = script:WaitForChild("Reload");
local l__ReplicatedStorage__13 = game:GetService("ReplicatedStorage");
local l__Modules__14 = l__ReplicatedStorage__13:WaitForChild("Modules");
local l__ShootModule__15 = require(l__Modules__14:WaitForChild("Projectile"):WaitForChild("ShootModule"));
local l__VehicleModule__16 = require(l__Modules__14:WaitForChild("VehicleModule"));
local l__ACS_Engine__17 = l__ReplicatedStorage__13:WaitForChild("ACS_Engine");
local l__Events__18 = l__ACS_Engine__17:WaitForChild("Events");
local l__Hitmarker__19 = require(l__ACS_Engine__17:WaitForChild("Modules"):WaitForChild("Hitmarker"));
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = false;
local u15 = false;
local u16 = {};
local u17 = {};
local u18 = RaycastParams.new();
u18.FilterType = Enum.RaycastFilterType.Exclude;
u18.CollisionGroup = "CamCast";
local u19 = nil;
local function u21(p20) --[[ Line: 71 ]]
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u19 (ref), l__Character__8 (copy)
    u2 = p20;
    u3 = u2.Required.TankSeat;
    u4 = u2.Required.Dome;
    u5 = u4.DomePart;
    u6 = u2.Required.CameraPart;
    u7 = u6.XMotor;
    u8 = u6.YMotor;
    u9 = u4.FollowPart;
    u10 = u2.Wheels.Left.Transmission:GetChildren();
    u11 = u2.Wheels.Right.Transmission:GetChildren();
    u12 = u2.Params.Speed;
    u13 = u2.Params.TurnSpeed;
    u19 = {
        shellType = "Explosive",
        shellName = "TankShell",
        shellSpeed = 700,
        weaponName = p20.Name,
        filterDescendants = { p20, l__Character__8 }
    };
end;
local function u24() --[[ Line: 140 ]]
    -- upvalues: u9 (ref)
    local l__Position__20 = u9.Position;
    local v22 = u9.CFrame.LookVector * 1000;
    RaycastParams.new();
    local v23 = Ray.new(l__Position__20, v22);
    local _, _, _ = workspace:FindPartOnRayWithWhitelist(v23, { u9 });
end;
local function u26() --[[ Line: 160 ]]
    -- upvalues: u18 (copy), u16 (ref), u17 (ref), u26 (copy)
    u18.FilterDescendantsInstances = u16;
    local l__CurrentCamera__21 = workspace.CurrentCamera;
    local v25 = workspace:Raycast(l__CurrentCamera__21.CFrame.Position, l__CurrentCamera__21.CFrame.LookVector * 1000, u18);
    if not v25 then
        return l__CurrentCamera__21.CFrame.Position + l__CurrentCamera__21.CFrame.LookVector * 10000;
    end;
    if (l__CurrentCamera__21.CFrame.Position - v25.Position).magnitude >= 40 or not v25.Instance:IsA("BasePart") then
        return v25.Position;
    end;
    table.insert(u16, v25.Instance);
    if v25.Instance.Transparency == 0 then
        v25.Instance.Transparency = 0.7;
        table.insert(u17, v25.Instance);
    end;
    return u26();
end;
l__Humanoid__9.Seated:Connect(function() --[[ Name: onSeated, Line 181 ]]
    -- upvalues: l__Humanoid__9 (copy), l__VehicleModule__16 (copy), u21 (copy), u1 (copy), l__TankGui__11 (copy), u14 (ref), l__ShootModule__15 (copy), l__LocalPlayer__7 (copy), u9 (ref), u19 (ref), l__Events__18 (copy), u6 (ref), l__Hitmarker__19 (copy), l__Reload__12 (copy), l__TweenService__5 (copy), l__UserInputService__3 (copy), u15 (ref), l__CurrentCamera__10 (copy), l__ContextActionService__2 (copy), l__RunService__4 (copy), u17 (ref), u16 (ref), u26 (copy), l__Character__8 (copy), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), u8 (ref), u10 (ref), u11 (ref), u24 (copy)
    if l__Humanoid__9.SeatPart then
        local u27 = l__VehicleModule__16.checkAndGetTank(l__Humanoid__9.SeatPart);
        if u27 and (l__Humanoid__9.SeatPart.Name == "TankSeat" and not l__Humanoid__9.SeatPart:GetAttribute("NewDrive")) then
            u21(u27);
            u1.Parent = workspace;
            u1.Aim.Enabled = true;
            l__TankGui__11.Enabled = true;
            local l__Y__22 = l__Humanoid__9.SeatPart.Orientation.Y;
            local u28 = 0;
            local u29 = 0;
            local u30 = 0;
            local function v33(_, p31, p32) --[[ Line: 201 ]]
                -- upvalues: l__Y__22 (ref), u28 (ref)
                if p31 == Enum.UserInputState.Change then
                    l__Y__22 = l__Y__22 - p32.Delta.X;
                    u28 = math.clamp(u28 - p32.Delta.Y * 0.4, -75, 75);
                end;
            end;
            local function u37(_, p34, _) --[[ Line: 208 ]]
                -- upvalues: u14 (ref), l__ShootModule__15 (ref), l__LocalPlayer__7 (ref), u9 (ref), u19 (ref), l__Events__18 (ref), u6 (ref), l__Hitmarker__19 (ref), l__Reload__12 (ref), l__TweenService__5 (ref), l__TankGui__11 (ref)
                if u14 or p34 ~= Enum.UserInputState.Begin then
                else
                    u14 = true;
                    l__ShootModule__15.fire(l__LocalPlayer__7, u9.Position, u9.CFrame.LookVector, u19);
                    l__Events__18.ServerBullet:FireServer(u9.Position, u9.CFrame.LookVector, u19);
                    u6:ApplyImpulse(-u9.CFrame.LookVector * 50000);
                    l__Hitmarker__19.tankShot(l__LocalPlayer__7);
                    l__Events__18.TankFireFX:FireServer();
                    spawn(function() --[[ Line: 219 ]]
                        -- upvalues: u14 (ref)
                        task.wait(5);
                        u14 = false;
                    end);
                    spawn(function() --[[ Line: 224 ]]
                        -- upvalues: l__Reload__12 (ref)
                        task.wait(5 - l__Reload__12.TimeLength);
                        l__Reload__12:Play();
                    end);
                    local v35 = l__TweenService__5:Create(l__TankGui__11.ReticleFrame.Reticle, TweenInfo.new(0.1), {
                        ImageTransparency = 0.9
                    });
                    local v36 = l__TweenService__5:Create(l__TankGui__11.ReticleFrame.Reticle, TweenInfo.new(4.9), {
                        ImageTransparency = 0
                    });
                    l__TankGui__11.ReticleFrame:TweenSize(UDim2.new(0.35, 0, 0.35, 0), nil, nil, 0.1, true);
                    v35:Play();
                    task.wait(0.1);
                    l__TankGui__11.ReticleFrame:TweenSize(UDim2.new(0.02, 0, 0.02, 0), nil, nil, 4.9, true);
                    v36:Play();
                end;
            end;
            local function v41(p38, p39, p40) --[[ Line: 238 ]]
                -- upvalues: l__UserInputService__3 (ref), u37 (copy)
                if l__UserInputService__3:GetLastInputType() == Enum.UserInputType.Gamepad1 then
                else
                    u37(p38, p39, p40);
                end;
            end;
            local function u44(_, p42, _) --[[ Line: 244 ]]
                -- upvalues: u15 (ref), l__TweenService__5 (ref), l__CurrentCamera__10 (ref)
                if p42 == Enum.UserInputState.Begin then
                    local v43 = u15 and 70 or 40;
                    u15 = not u15;
                    l__TweenService__5:Create(l__CurrentCamera__10, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        FieldOfView = v43
                    }):Play();
                end;
            end;
            local function v48(p45, p46, p47) --[[ Line: 253 ]]
                -- upvalues: l__UserInputService__3 (ref), u44 (copy)
                if l__UserInputService__3:GetLastInputType() == Enum.UserInputType.Gamepad1 then
                else
                    u44(p45, p46, p47);
                end;
            end;
            l__CurrentCamera__10.CameraType = Enum.CameraType.Scriptable;
            local function v50(p49, _) --[[ Line: 261 ]]
                -- upvalues: u29 (ref), u30 (ref)
                if p49.UserInputType == Enum.UserInputType.Gamepad1 and p49.KeyCode == Enum.KeyCode.Thumbstick2 then
                    u29 = p49.Position.X;
                    u30 = p49.Position.Y;
                end;
            end;
            local u51 = l__UserInputService__3.InputBegan:Connect(v50);
            local u52 = l__UserInputService__3.InputChanged:Connect(v50);
            local u53 = l__UserInputService__3.InputEnded:Connect(v50);
            l__ContextActionService__2:BindAction("PlayerInput", v33, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch);
            l__ContextActionService__2:BindAction("FireTank", u37, true, Enum.KeyCode.ButtonR1);
            l__ContextActionService__2:BindAction("TankZoom", u44, true, Enum.KeyCode.ButtonL1);
            l__ContextActionService__2:BindAction("FireTankPC", v41, false, Enum.UserInputType.MouseButton1);
            l__ContextActionService__2:BindAction("TankZoomPC", v48, false, Enum.UserInputType.MouseButton2);
            l__ContextActionService__2:SetPosition("FireTank", UDim2.new(0.81, -135, 0.05, -35));
            l__ContextActionService__2:SetImage("FireTank", "https://www.roblox.com/asset/?id=444744114");
            l__ContextActionService__2:SetPosition("TankZoom", UDim2.new(0.5, 0, 0.15, 0));
            l__ContextActionService__2:SetImage("TankZoom", "https://www.roblox.com/asset/?id=3119564478");
            local u54 = nil;
            u54 = l__RunService__4.RenderStepped:Connect(function() --[[ Line: 290 ]]
                -- upvalues: u17 (ref), u16 (ref), u27 (copy), u26 (ref), l__Humanoid__9 (ref), l__ContextActionService__2 (ref), u54 (ref), u51 (ref), u52 (ref), u53 (ref), l__TankGui__11 (ref), u1 (ref), l__CurrentCamera__10 (ref), l__UserInputService__3 (ref), l__Character__8 (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u19 (ref), l__Y__22 (ref), u29 (ref), u28 (ref), u30 (ref), u24 (ref)
                for _, v55 in ipairs(u17) do
                    v55.Transparency = 0;
                end;
                u16 = { u27 };
                u17 = {};
                local v56 = u26();
                if l__Humanoid__9.SeatPart and l__Humanoid__9.SeatPart.Name == "TankSeat" then
                    if l__CurrentCamera__10.CameraType ~= Enum.CameraType.Scriptable then
                        l__CurrentCamera__10.CameraType = Enum.CameraType.Scriptable;
                    end;
                    l__UserInputService__3.MouseBehavior = Enum.MouseBehavior.LockCenter;
                    l__UserInputService__3.MouseIconEnabled = false;
                    l__Y__22 = l__Y__22 - u29;
                    u28 = math.clamp(u28 + u30 * 0.4, -75, 75);
                    local v57 = CFrame.new(u6.CFrame.Position) * CFrame.Angles(0, math.rad(l__Y__22), 0) * CFrame.Angles(math.rad(u28), 0, 0);
                    v57:ToWorldSpace(CFrame.new(0, 7, 40));
                    v57:ToWorldSpace(CFrame.new(0, 7, -10000));
                    local v58 = u7;
                    local v59 = CFrame.new(u6.Position, v56);
                    local v60 = math.atan2(v59.LookVector.X, v59.LookVector.Z);
                    local v61 = math.deg(v60) + 180;
                    v58.TargetAngle = (v61 == 360 and 0 or v61) - u6.Orientation.Y;
                    local v62 = u8;
                    local l__Position__23 = u5.Position;
                    local v63 = -1;
                    local l__Magnitude__24 = (l__Position__23 - v56).Magnitude;
                    local v64 = v56.Y - l__Position__23.Y;
                    local v65 = math.abs(v64);
                    if v64 < 0 then
                        local _ = v63 * -1;
                    end;
                    local v66 = math.acos(v65 / l__Magnitude__24);
                    local v67 = math.deg(v66);
                    v62.TargetAngle = (v64 > 0 and -v67 or -90 - (90 - v67) * 1.5) + 90 - u5.Orientation.X;
                    if u7.CurrentAngle > 135 or u7.CurrentAngle < -135 then
                        u8.TargetAngle = math.max(0, u8.TargetAngle);
                    end;
                    u24();
                else
                    l__ContextActionService__2:UnbindAction("PlayerInput");
                    l__ContextActionService__2:UnbindAction("FocusControl");
                    l__ContextActionService__2:UnbindAction("FireTank");
                    l__ContextActionService__2:UnbindAction("TankZoom");
                    l__ContextActionService__2:UnbindAction("FireTankPC");
                    l__ContextActionService__2:UnbindAction("TankZoomPC");
                    u54:Disconnect();
                    u51:Disconnect();
                    u52:Disconnect();
                    u53:Disconnect();
                    l__TankGui__11.Enabled = false;
                    u1.Aim.Enabled = false;
                    u1.Parent = script;
                    for _, v68 in ipairs(u17) do
                        v68.Transparency = 0;
                    end;
                    u16 = {};
                    u17 = {};
                    spawn(function() --[[ Line: 324 ]]
                        -- upvalues: l__CurrentCamera__10 (ref), l__UserInputService__3 (ref), l__Character__8 (ref), l__Humanoid__9 (ref)
                        l__CurrentCamera__10.CameraType = Enum.CameraType.Custom;
                        l__CurrentCamera__10.FieldOfView = 70;
                        l__UserInputService__3.MouseBehavior = Enum.MouseBehavior.Default;
                        l__UserInputService__3.MouseIconEnabled = true;
                        local v69 = l__Character__8:FindFirstChild("HumanoidRootPart");
                        if v69 then
                            v69.CFrame = v69.CFrame + Vector3.new(0, 10.5, 0);
                            if l__Humanoid__9 then
                                l__Humanoid__9:ChangeState(Enum.HumanoidStateType.Freefall);
                            end;
                        end;
                    end);
                    u2 = nil;
                    u3 = nil;
                    u4 = nil;
                    u5 = nil;
                    u6 = nil;
                    u7 = nil;
                    u8 = nil;
                    u9 = nil;
                    u10 = nil;
                    u11 = nil;
                    u19 = nil;
                end;
            end);
        end;
    end;
end);