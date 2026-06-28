-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1, v2 = pcall(function() --[[ Line: 17 ]]
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2");
end);
local u3 = v1 and v2;
local l__VRService__1 = game:GetService("VRService");
local l__CameraInput__2 = require(script.Parent:WaitForChild("CameraInput"));
local l__ZoomController__3 = require(script.Parent:WaitForChild("ZoomController"));
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
local l__Lighting__5 = game:GetService("Lighting");
local l__RunService__6 = game:GetService("RunService");
local l__UserGameSettings__7 = UserSettings():GetService("UserGameSettings");
local l__BaseCamera__8 = require(script.Parent:WaitForChild("BaseCamera"));
local u4 = setmetatable({}, l__BaseCamera__8);
u4.__index = u4;
function u4.new() --[[ Line: 41 ]]
    -- upvalues: l__BaseCamera__8 (copy), u4 (copy)
    local v5 = l__BaseCamera__8.new();
    local v6 = setmetatable(v5, u4);
    v6.gamepadZoomLevels = { 0, 7 };
    v6.headScale = 1;
    v6:SetCameraToSubjectDistance(7);
    v6.VRFadeResetTimer = 0;
    v6.VREdgeBlurTimer = 0;
    v6.gamepadResetConnection = nil;
    v6.needsReset = true;
    v6.recentered = false;
    v6:Reset();
    return v6;
end;
function u4.Reset(p7) --[[ Line: 67 ]]
    p7.stepRotateTimeout = 0;
end;
function u4.GetModuleName(_) --[[ Line: 71 ]]
    return "VRBaseCamera";
end;
function u4.GamepadZoomPress(p8) --[[ Line: 75 ]]
    -- upvalues: l__BaseCamera__8 (copy)
    l__BaseCamera__8.GamepadZoomPress(p8);
    p8:GamepadReset();
    p8:ResetZoom();
end;
function u4.GamepadReset(p9) --[[ Line: 83 ]]
    p9.stepRotateTimeout = 0;
    p9.needsReset = true;
end;
function u4.ResetZoom(p10) --[[ Line: 88 ]]
    -- upvalues: l__ZoomController__3 (copy)
    l__ZoomController__3.SetZoomParameters(p10.currentSubjectDistance, 0);
    l__ZoomController__3.ReleaseSpring();
end;
function u4.OnEnabledChanged(u11) --[[ Line: 93 ]]
    -- upvalues: l__BaseCamera__8 (copy), l__CameraInput__2 (copy), l__VRService__1 (copy), u3 (ref), l__LocalPlayer__4 (copy), l__Lighting__5 (copy)
    l__BaseCamera__8.OnEnabledChanged(u11);
    if u11.enabled then
        u11.gamepadResetConnection = l__CameraInput__2.gamepadReset:Connect(function() --[[ Line: 97 ]]
            -- upvalues: u11 (copy)
            u11:GamepadReset();
        end);
        u11.thirdPersonOptionChanged = l__VRService__1:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function() --[[ Line: 102 ]]
            -- upvalues: u3 (ref), u11 (copy)
            if u3 then
                u11:Reset();
            else
                if not u11:IsInFirstPerson() then
                    u11:Reset();
                end;
            end;
        end);
        u11.vrRecentered = l__VRService__1.UserCFrameChanged:Connect(function(p12, _) --[[ Line: 113 ]]
            -- upvalues: u11 (copy)
            if p12 == Enum.UserCFrame.Floor then
                u11.recentered = true;
            end;
        end);
    else
        if u11.inFirstPerson then
            u11:GamepadZoomPress();
        end;
        if u11.thirdPersonOptionChanged then
            u11.thirdPersonOptionChanged:Disconnect();
            u11.thirdPersonOptionChanged = nil;
        end;
        if u11.vrRecentered then
            u11.vrRecentered:Disconnect();
            u11.vrRecentered = nil;
        end;
        if u11.cameraHeadScaleChangedConn then
            u11.cameraHeadScaleChangedConn:Disconnect();
            u11.cameraHeadScaleChangedConn = nil;
        end;
        if u11.gamepadResetConnection then
            u11.gamepadResetConnection:Disconnect();
            u11.gamepadResetConnection = nil;
        end;
        u11.VREdgeBlurTimer = 0;
        u11:UpdateEdgeBlur(l__LocalPlayer__4, 1);
        local v13 = l__Lighting__5:FindFirstChild("VRFade");
        if v13 then
            v13.Brightness = 0;
        end;
    end;
end;
function u4.OnCurrentCameraChanged(u14) --[[ Line: 155 ]]
    -- upvalues: l__BaseCamera__8 (copy)
    l__BaseCamera__8.OnCurrentCameraChanged(u14);
    if u14.cameraHeadScaleChangedConn then
        u14.cameraHeadScaleChangedConn:Disconnect();
        u14.cameraHeadScaleChangedConn = nil;
    end;
    local l__CurrentCamera__9 = workspace.CurrentCamera;
    if l__CurrentCamera__9 then
        u14.cameraHeadScaleChangedConn = l__CurrentCamera__9:GetPropertyChangedSignal("HeadScale"):Connect(function() --[[ Line: 167 ]]
            -- upvalues: u14 (copy)
            u14:OnHeadScaleChanged();
        end);
        u14:OnHeadScaleChanged();
    end;
end;
function u4.OnHeadScaleChanged(p15) --[[ Line: 172 ]]
    local l__HeadScale__10 = workspace.CurrentCamera.HeadScale;
    for v16, v17 in p15.gamepadZoomLevels do
        p15.gamepadZoomLevels[v16] = v17 * l__HeadScale__10 / p15.headScale;
    end;
    p15:SetCameraToSubjectDistance(p15:GetCameraToSubjectDistance() * l__HeadScale__10 / p15.headScale);
    p15.headScale = l__HeadScale__10;
end;
function u4.GetVRFocus(p18, p19, p20) --[[ Line: 188 ]]
    local v21 = p18.lastCameraFocus or p19;
    local l__x__11 = p18.cameraTranslationConstraints.x;
    local v22 = math.min(1, p18.cameraTranslationConstraints.y + p20);
    p18.cameraTranslationConstraints = Vector3.new(l__x__11, v22, p18.cameraTranslationConstraints.z);
    local v23 = p18:GetCameraHeight();
    local v24 = Vector3.new(0, v23, 0);
    return CFrame.new(Vector3.new(p19.x, v21.y, p19.z):Lerp(p19 + v24, p18.cameraTranslationConstraints.y));
end;
function u4.StartFadeFromBlack(p25) --[[ Line: 204 ]]
    -- upvalues: l__UserGameSettings__7 (copy), l__Lighting__5 (copy)
    if l__UserGameSettings__7.VignetteEnabled == false then
    else
        local v26 = l__Lighting__5:FindFirstChild("VRFade");
        if not v26 then
            v26 = Instance.new("ColorCorrectionEffect");
            v26.Name = "VRFade";
            v26.Parent = l__Lighting__5;
        end;
        v26.Brightness = -1;
        p25.VRFadeResetTimer = 0.1;
    end;
end;
function u4.UpdateFadeFromBlack(p27, p28) --[[ Line: 219 ]]
    -- upvalues: l__Lighting__5 (copy)
    local v29 = l__Lighting__5:FindFirstChild("VRFade");
    if p27.VRFadeResetTimer > 0 then
        p27.VRFadeResetTimer = math.max(p27.VRFadeResetTimer - p28, 0);
        local v30 = l__Lighting__5:FindFirstChild("VRFade");
        if v30 and v30.Brightness < 0 then
            v30.Brightness = math.min(v30.Brightness + p28 * 10, 0);
        end;
    elseif v29 then
        v29.Brightness = 0;
    end;
end;
function u4.StartVREdgeBlur(p31, p32) --[[ Line: 235 ]]
    -- upvalues: l__UserGameSettings__7 (copy), l__RunService__6 (copy), l__VRService__1 (copy)
    if l__UserGameSettings__7.VignetteEnabled == false then
    else
        local v33 = workspace.CurrentCamera:FindFirstChild("VRBlurPart");
        if not v33 then
            local u34 = Instance.new("Part");
            u34.Name = "VRBlurPart";
            u34.Parent = workspace.CurrentCamera;
            u34.CanTouch = false;
            u34.CanCollide = false;
            u34.CanQuery = false;
            u34.Anchored = true;
            u34.Size = Vector3.new(0.44, 0.47, 1);
            u34.Transparency = 1;
            u34.CastShadow = false;
            l__RunService__6.RenderStepped:Connect(function(_) --[[ Line: 255 ]]
                -- upvalues: l__VRService__1 (ref), u34 (ref)
                local v35 = l__VRService__1:GetUserCFrame(Enum.UserCFrame.Head);
                local v36 = workspace.CurrentCamera.CFrame * (CFrame.new(v35.p * workspace.CurrentCamera.HeadScale) * (v35 - v35.p));
                u34.CFrame = v36 * CFrame.Angles(0, 3.141592653589793, 0) + v36.LookVector * (1.05 * workspace.CurrentCamera.HeadScale);
                u34.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale;
            end);
            v33 = u34;
        end;
        local v37 = p32.PlayerGui:FindFirstChild("VRBlurScreen");
        local v38;
        if v37 then
            v38 = v37:FindFirstChild("VRBlur");
        else
            v38 = nil;
        end;
        if not v38 then
            local v39 = v37 or (Instance.new("SurfaceGui") or Instance.new("ScreenGui"));
            v39.Name = "VRBlurScreen";
            v39.Parent = p32.PlayerGui;
            v39.Adornee = v33;
            v38 = Instance.new("ImageLabel");
            v38.Name = "VRBlur";
            v38.Parent = v39;
            v38.Image = "rbxasset://textures/ui/VR/edgeBlur.png";
            v38.AnchorPoint = Vector2.new(0.5, 0.5);
            v38.Position = UDim2.new(0.5, 0, 0.5, 0);
            v38.Size = UDim2.fromScale(workspace.CurrentCamera.ViewportSize.X * 2.3 / 512, workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512);
            v38.BackgroundTransparency = 1;
            v38.Active = true;
            v38.ScaleType = Enum.ScaleType.Stretch;
        end;
        v38.Visible = true;
        v38.ImageTransparency = 0;
        p31.VREdgeBlurTimer = 0.14;
    end;
end;
function u4.UpdateEdgeBlur(p40, p41, p42) --[[ Line: 304 ]]
    local v43 = p41.PlayerGui:FindFirstChild("VRBlurScreen");
    local v44;
    if v43 then
        v44 = v43:FindFirstChild("VRBlur");
    else
        v44 = nil;
    end;
    if v44 then
        if p40.VREdgeBlurTimer > 0 then
            p40.VREdgeBlurTimer = p40.VREdgeBlurTimer - p42;
            local v45 = p41.PlayerGui:FindFirstChild("VRBlurScreen");
            local v46 = v45 and v45:FindFirstChild("VRBlur");
            if v46 then
                v46.ImageTransparency = 1 - math.clamp(p40.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142;
            end;
        else
            v44.Visible = false;
        end;
    end;
end;
function u4.GetCameraHeight(p47) --[[ Line: 329 ]]
    return p47.inFirstPerson and 0 or 0.25881904510252074 * p47.currentSubjectDistance;
end;
function u4.GetSubjectCFrame(p48) --[[ Line: 336 ]]
    -- upvalues: l__BaseCamera__8 (copy)
    local v49 = l__BaseCamera__8.GetSubjectCFrame(p48);
    local l__CurrentCamera__12 = workspace.CurrentCamera;
    if l__CurrentCamera__12 then
        l__CurrentCamera__12 = l__CurrentCamera__12.CameraSubject;
    end;
    if not l__CurrentCamera__12 then
        return v49;
    end;
    if l__CurrentCamera__12:IsA("Humanoid") and (l__CurrentCamera__12:GetState() == Enum.HumanoidStateType.Dead and l__CurrentCamera__12 == p48.lastSubject) then
        v49 = p48.lastSubjectCFrame;
    end;
    if v49 then
        p48.lastSubjectCFrame = v49;
    end;
    return v49;
end;
function u4.GetSubjectPosition(p50) --[[ Line: 362 ]]
    -- upvalues: l__BaseCamera__8 (copy)
    local v51 = l__BaseCamera__8.GetSubjectPosition(p50);
    local l__CurrentCamera__13 = game.Workspace.CurrentCamera;
    if l__CurrentCamera__13 then
        l__CurrentCamera__13 = l__CurrentCamera__13.CameraSubject;
    end;
    if not l__CurrentCamera__13 then
        return nil;
    end;
    if l__CurrentCamera__13:IsA("Humanoid") then
        if l__CurrentCamera__13:GetState() == Enum.HumanoidStateType.Dead and l__CurrentCamera__13 == p50.lastSubject then
            v51 = p50.lastSubjectPosition;
        end;
    elseif l__CurrentCamera__13:IsA("VehicleSeat") then
        v51 = l__CurrentCamera__13.CFrame.p + l__CurrentCamera__13.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0));
    end;
    p50.lastSubjectPosition = v51;
    return v51;
end;
function u4.getRotation(p52, p53) --[[ Line: 391 ]]
    -- upvalues: l__CameraInput__2 (copy), l__UserGameSettings__7 (copy)
    local v54 = l__CameraInput__2.getRotation();
    local v55 = 0;
    if l__UserGameSettings__7.VRSmoothRotationEnabled then
        return v54.X * 40 * p53;
    end;
    if math.abs(v54.X) > 0.03 then
        if p52.stepRotateTimeout > 0 then
            p52.stepRotateTimeout = p52.stepRotateTimeout - p53;
        end;
        if p52.stepRotateTimeout <= 0 then
            local v56 = (v54.X < 0 and -1 or 1) * 0.5235987755982988;
            p52:StartFadeFromBlack();
            p52.stepRotateTimeout = 0.25;
            return v56;
        end;
    elseif math.abs(v54.X) < 0.02 then
        p52.stepRotateTimeout = 0;
    end;
    return v55;
end;
return u4;