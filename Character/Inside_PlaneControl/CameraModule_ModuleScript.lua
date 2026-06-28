-- Roblox: Workspace.SilverAce293026.PlaneControl.CameraModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__RunService__1 = game:GetService("RunService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__Players__3 = game:GetService("Players");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local l__LocalPlayer__5 = l__Players__3.LocalPlayer;
l__LocalPlayer__5:WaitForChild("PlayerGui");
local l__InputModule__6 = require(script.Parent:WaitForChild("InputModule"));
local l__UtilModule__7 = require(script.Parent:WaitForChild("UtilModule"));
function u1.CameraLoop(_) --[[ Line: 23 ]]
    -- upvalues: u1 (copy), l__UtilModule__7 (copy)
    local l__CurrentCamera__8 = workspace.CurrentCamera;
    l__CurrentCamera__8.CameraType = Enum.CameraType.Scriptable;
    l__CurrentCamera__8.CameraSubject = nil;
    local v2 = u1.AlignPart.CFrame.UpVector.Y >= 0 and 1 or -1;
    u1._yawSign = v2;
    u1.AlignPart.Position = u1._plane.Required.GasTank.Position;
    u1.AlignPart.CFrame = CFrame.new(u1.AlignPart.CFrame.Position) * CFrame.Angles(0, math.rad(u1.xRot * v2), 0) * CFrame.Angles(math.rad(u1.yRot), 0, 0) * CFrame.Angles(0, 0, (math.rad(u1.zRot)));
    u1.CamAlign.Position = u1.AlignPart.Position;
    local _, _ = l__UtilModule__7.IsOnGround();
    local l__LookVector__9 = u1.AlignPart.CFrame.LookVector;
    local _ = u1._seat.CFrame.LookVector;
    local v3 = (Vector3.new(0, 1, 0)):Angle(l__LookVector__9);
    local _ = u1.gas.CFrame;
    if v3 < 0.3 or v3 > 2.8415926535897933 then
        u1.DoingFlip = true;
    else
        u1.DoingFlip = false;
        local l__AlignPart__10 = u1.AlignPart;
        local l__CFrame__11 = u1.AlignPart.CFrame;
        local l__LookVector__12 = l__CFrame__11.LookVector;
        local l__Unit__13 = l__LookVector__12:Cross(Vector3.new(0, 1, 0)).Unit;
        local l__Unit__14 = l__Unit__13:Cross(l__LookVector__12).Unit;
        l__AlignPart__10.CFrame = CFrame.fromMatrix(l__CFrame__11.Position, l__Unit__13, l__Unit__14);
    end;
    local _ = u1.AlignPart.CFrame;
    l__CurrentCamera__8.CFrame = u1.CamAlign.CFrame * CFrame.new(0, 27, -88) * CFrame.Angles(0, 3.141592653589793, 0);
end;
function u1.SetPlane(p4) --[[ Line: 65 ]]
    -- upvalues: u1 (copy), l__UserInputService__2 (copy), l__ReplicatedStorage__4 (copy), l__InputModule__6 (copy), l__RunService__1 (copy)
    u1._plane = p4;
    u1._seat = p4.Required.PlaneSeat;
    u1.gas = p4.Required.GasTank;
    u1.xRot = 0;
    u1.yRot = 0;
    u1.zRot = 0;
    l__UserInputService__2.MouseBehavior = Enum.MouseBehavior.LockCenter;
    l__UserInputService__2.MouseIconEnabled = false;
    u1.AlignPart = l__ReplicatedStorage__4.PlaneAssets.CameraAlign:Clone();
    u1.AlignPart.Parent = p4.Required.GasTank;
    u1.CamAlign = u1.AlignPart:Clone();
    u1.CamAlign.Parent = p4.Required.GasTank;
    local v5 = Instance.new("Attachment");
    v5.Parent = u1.AlignPart;
    local v6 = Instance.new("Attachment");
    v6.Parent = u1.CamAlign;
    local v7 = Instance.new("AlignOrientation");
    v7.Parent = u1.CamAlign;
    v7.Attachment0 = v6;
    v7.Attachment1 = v5;
    u1._scheme = l__InputModule__6.GetBoundScheme("Plane");
    u1._scheme:SubscribeToControl("DirectionPointer", function(p8, _) --[[ Line: 95 ]]
        -- upvalues: u1 (ref)
        if p8.Input == Enum.UserInputType.MouseMovement then
            local l__Delta__15 = p8.Delta;
            local v9 = u1;
            v9.xRot = v9.xRot - l__Delta__15.X / 12 * u1._yawSign;
            local v10 = u1;
            v10.yRot = v10.yRot + l__Delta__15.Y / 12;
        else
            if p8.Input == Enum.UserInputType.Touch then
                local l__Delta__16 = p8.Delta;
                if math.abs(l__Delta__16.X) > 0.15 then
                    local v11 = u1;
                    v11.xRot = v11.xRot - l__Delta__16.X * u1._yawSign / 2;
                end;
                if math.abs(l__Delta__16.Y) > 0.15 then
                    local v12 = u1;
                    v12.yRot = v12.yRot + l__Delta__16.Y / 2;
                end;
            else
                local l__Position__17 = p8.Position;
                if math.abs(l__Position__17.X) > 0.15 then
                    local v13 = u1;
                    v13.xRot = v13.xRot - l__Position__17.X * u1._yawSign;
                end;
                if math.abs(l__Position__17.Y) > 0.15 then
                    local v14 = u1;
                    v14.yRot = v14.yRot - l__Position__17.Y;
                end;
            end;
        end;
    end);
    u1._cameraConnection = l__RunService__1.Heartbeat:Connect(u1.CameraLoop);
end;
function u1.UnsetPlane() --[[ Line: 132 ]]
    -- upvalues: u1 (copy), l__LocalPlayer__5 (copy), l__UserInputService__2 (copy)
    u1._plane = nil;
    u1._cameraConnection:Disconnect();
    u1._cameraConnection = nil;
    local l__CurrentCamera__18 = workspace.CurrentCamera;
    l__CurrentCamera__18.CameraType = Enum.CameraType.Custom;
    l__CurrentCamera__18.CameraSubject = l__LocalPlayer__5.Character:WaitForChild("Humanoid");
    l__UserInputService__2.MouseBehavior = Enum.MouseBehavior.Default;
    l__UserInputService__2.MouseIconEnabled = true;
end;
return u1;