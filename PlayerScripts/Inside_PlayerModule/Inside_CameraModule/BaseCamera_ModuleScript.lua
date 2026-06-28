-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.BaseCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1, v2 = pcall(function() --[[ Line: 12 ]]
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom");
end);
local u3 = v1 and v2;
Vector2.new(0.2617993877991494, 0);
Vector2.new(0.7853981633974483, 0);
Vector2.new(0, 0);
local l__CameraUtils__1 = require(script.Parent:WaitForChild("CameraUtils"));
local l__ZoomController__2 = require(script.Parent:WaitForChild("ZoomController"));
local l__CameraToggleStateController__3 = require(script.Parent:WaitForChild("CameraToggleStateController"));
local l__CameraInput__4 = require(script.Parent:WaitForChild("CameraInput"));
local l__CameraUI__5 = require(script.Parent:WaitForChild("CameraUI"));
local l__Players__6 = game:GetService("Players");
local l__ReplicatedStorage__7 = game:GetService("ReplicatedStorage");
local l__UserInputService__8 = game:GetService("UserInputService");
game:GetService("StarterGui");
local l__VRService__9 = game:GetService("VRService");
local l__UserGameSettings__10 = UserSettings():GetService("UserGameSettings");
local l__LocalPlayer__11 = l__Players__6.LocalPlayer;
local u4 = nil;
local u5 = {};
u5.__index = u5;
function u5.new() --[[ Line: 70 ]]
    -- upvalues: u5 (copy), l__LocalPlayer__11 (copy), l__UserGameSettings__10 (copy)
    local u6 = setmetatable({}, u5);
    u6.gamepadZoomLevels = { 0, 10, 20 };
    u6.FIRST_PERSON_DISTANCE_THRESHOLD = 1;
    u6.cameraType = nil;
    u6.cameraMovementMode = nil;
    u6.lastCameraTransform = nil;
    u6.lastUserPanCamera = tick();
    u6.humanoidRootPart = nil;
    u6.humanoidCache = {};
    u6.lastSubject = nil;
    u6.lastSubjectPosition = Vector3.new(0, 5, 0);
    u6.lastSubjectCFrame = CFrame.new(u6.lastSubjectPosition);
    u6.currentSubjectDistance = math.clamp(12.5, l__LocalPlayer__11.CameraMinZoomDistance, l__LocalPlayer__11.CameraMaxZoomDistance);
    u6.inFirstPerson = false;
    u6.inMouseLockedMode = false;
    u6.portraitMode = false;
    u6.isSmallTouchScreen = false;
    u6.resetCameraAngle = true;
    u6.enabled = false;
    u6.PlayerGui = nil;
    u6.cameraChangedConn = nil;
    u6.viewportSizeChangedConn = nil;
    u6.shouldUseVRRotation = false;
    u6.VRRotationIntensityAvailable = false;
    u6.lastVRRotationIntensityCheckTime = 0;
    u6.lastVRRotationTime = 0;
    u6.vrRotateKeyCooldown = {};
    u6.cameraTranslationConstraints = Vector3.new(1, 1, 1);
    u6.humanoidJumpOrigin = nil;
    u6.trackingHumanoid = nil;
    u6.cameraFrozen = false;
    u6.subjectStateChangedConn = nil;
    u6.gamepadZoomPressConnection = nil;
    u6.mouseLockOffset = Vector3.new(0, 0, 0);
    if l__LocalPlayer__11.Character then
        u6:OnCharacterAdded(l__LocalPlayer__11.Character);
    end;
    l__LocalPlayer__11.CharacterAdded:Connect(function(p7) --[[ Line: 135 ]]
        -- upvalues: u6 (copy)
        u6:OnCharacterAdded(p7);
    end);
    if u6.playerCameraModeChangeConn then
        u6.playerCameraModeChangeConn:Disconnect();
    end;
    u6.playerCameraModeChangeConn = l__LocalPlayer__11:GetPropertyChangedSignal("CameraMode"):Connect(function() --[[ Line: 140 ]]
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end);
    if u6.minDistanceChangeConn then
        u6.minDistanceChangeConn:Disconnect();
    end;
    u6.minDistanceChangeConn = l__LocalPlayer__11:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() --[[ Line: 145 ]]
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end);
    if u6.maxDistanceChangeConn then
        u6.maxDistanceChangeConn:Disconnect();
    end;
    u6.maxDistanceChangeConn = l__LocalPlayer__11:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() --[[ Line: 150 ]]
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end);
    if u6.playerDevTouchMoveModeChangeConn then
        u6.playerDevTouchMoveModeChangeConn:Disconnect();
    end;
    u6.playerDevTouchMoveModeChangeConn = l__LocalPlayer__11:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() --[[ Line: 155 ]]
        -- upvalues: u6 (copy)
        u6:OnDevTouchMovementModeChanged();
    end);
    u6:OnDevTouchMovementModeChanged();
    if u6.gameSettingsTouchMoveMoveChangeConn then
        u6.gameSettingsTouchMoveMoveChangeConn:Disconnect();
    end;
    u6.gameSettingsTouchMoveMoveChangeConn = l__UserGameSettings__10:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() --[[ Line: 161 ]]
        -- upvalues: u6 (copy)
        u6:OnGameSettingsTouchMovementModeChanged();
    end);
    u6:OnGameSettingsTouchMovementModeChanged();
    l__UserGameSettings__10:SetCameraYInvertVisible();
    l__UserGameSettings__10:SetGamepadCameraSensitivityVisible();
    u6.hasGameLoaded = game:IsLoaded();
    if not u6.hasGameLoaded then
        u6.gameLoadedConn = game.Loaded:Connect(function() --[[ Line: 171 ]]
            -- upvalues: u6 (copy)
            u6.hasGameLoaded = true;
            u6.gameLoadedConn:Disconnect();
            u6.gameLoadedConn = nil;
        end);
    end;
    u6:OnPlayerCameraPropertyChange();
    return u6;
end;
function u5.GetModuleName(_) --[[ Line: 183 ]]
    return "BaseCamera";
end;
function u5.OnCharacterAdded(u8, p9) --[[ Line: 187 ]]
    -- upvalues: l__UserInputService__8 (copy), l__LocalPlayer__11 (copy)
    u8.resetCameraAngle = u8.resetCameraAngle or u8:GetEnabled();
    u8.humanoidRootPart = nil;
    if l__UserInputService__8.TouchEnabled then
        u8.PlayerGui = l__LocalPlayer__11:WaitForChild("PlayerGui");
        for _, v10 in ipairs(p9:GetChildren()) do
            if v10:IsA("Tool") then
                u8.isAToolEquipped = true;
            end;
        end;
        p9.ChildAdded:Connect(function(p11) --[[ Line: 197 ]]
            -- upvalues: u8 (copy)
            if p11:IsA("Tool") then
                u8.isAToolEquipped = true;
            end;
        end);
        p9.ChildRemoved:Connect(function(p12) --[[ Line: 202 ]]
            -- upvalues: u8 (copy)
            if p12:IsA("Tool") then
                u8.isAToolEquipped = false;
            end;
        end);
    end;
end;
function u5.GetHumanoidRootPart(p13) --[[ Line: 210 ]]
    -- upvalues: l__LocalPlayer__11 (copy)
    local v14 = (not p13.humanoidRootPart and l__LocalPlayer__11.Character and true or false) and l__LocalPlayer__11.Character:FindFirstChildOfClass("Humanoid");
    if v14 then
        p13.humanoidRootPart = v14.RootPart;
    end;
    return p13.humanoidRootPart;
end;
function u5.GetBodyPartToFollow(_, p15, _) --[[ Line: 222 ]]
    if p15:GetState() == Enum.HumanoidStateType.Dead then
        local l__Parent__12 = p15.Parent;
        if l__Parent__12 and l__Parent__12:IsA("Model") then
            return l__Parent__12:FindFirstChild("Head") or p15.RootPart;
        end;
    end;
    return p15.RootPart;
end;
function u5.GetSubjectCFrame(p16) --[[ Line: 234 ]]
    local l__lastSubjectCFrame__13 = p16.lastSubjectCFrame;
    local l__CurrentCamera__14 = workspace.CurrentCamera;
    if l__CurrentCamera__14 then
        l__CurrentCamera__14 = l__CurrentCamera__14.CameraSubject;
    end;
    if not l__CurrentCamera__14 then
        return l__lastSubjectCFrame__13;
    end;
    if l__CurrentCamera__14:IsA("Humanoid") then
        local v17 = l__CurrentCamera__14:GetState() == Enum.HumanoidStateType.Dead;
        local l__RootPart__15 = l__CurrentCamera__14.RootPart;
        if v17 and (l__CurrentCamera__14.Parent and l__CurrentCamera__14.Parent:IsA("Model")) then
            l__RootPart__15 = l__CurrentCamera__14.Parent:FindFirstChild("Head") or l__RootPart__15;
        end;
        if l__RootPart__15 and l__RootPart__15:IsA("BasePart") then
            local v18;
            if l__CurrentCamera__14.RigType == Enum.HumanoidRigType.R15 then
                if l__CurrentCamera__14.AutomaticScalingEnabled then
                    v18 = Vector3.new(0, 1.5, 0);
                    local l__RootPart__16 = l__CurrentCamera__14.RootPart;
                    if l__RootPart__15 == l__RootPart__16 then
                        v18 = v18 + Vector3.new(0, (l__RootPart__16.Size.Y - 2) / 2, 0);
                    end;
                else
                    v18 = Vector3.new(0, 2, 0);
                end;
            else
                v18 = Vector3.new(0, 1.5, 0);
            end;
            l__lastSubjectCFrame__13 = l__RootPart__15.CFrame * CFrame.new((v17 and Vector3.new(0, 0, 0) or v18) + l__CurrentCamera__14.CameraOffset);
        end;
    elseif l__CurrentCamera__14:IsA("BasePart") then
        l__lastSubjectCFrame__13 = l__CurrentCamera__14.CFrame;
    elseif l__CurrentCamera__14:IsA("Model") then
        if l__CurrentCamera__14.PrimaryPart then
            l__lastSubjectCFrame__13 = l__CurrentCamera__14:GetPrimaryPartCFrame();
        else
            l__lastSubjectCFrame__13 = CFrame.new();
        end;
    end;
    if l__lastSubjectCFrame__13 then
        p16.lastSubjectCFrame = l__lastSubjectCFrame__13;
    end;
    return l__lastSubjectCFrame__13;
end;
function u5.GetSubjectVelocity(_) --[[ Line: 300 ]]
    local l__CurrentCamera__17 = workspace.CurrentCamera;
    if l__CurrentCamera__17 then
        l__CurrentCamera__17 = l__CurrentCamera__17.CameraSubject;
    end;
    if not l__CurrentCamera__17 then
        return Vector3.new(0, 0, 0);
    end;
    if l__CurrentCamera__17:IsA("BasePart") then
        return l__CurrentCamera__17.Velocity;
    end;
    if l__CurrentCamera__17:IsA("Humanoid") then
        local l__RootPart__18 = l__CurrentCamera__17.RootPart;
        if l__RootPart__18 then
            return l__RootPart__18.Velocity;
        end;
    else
        local v19 = l__CurrentCamera__17:IsA("Model") and l__CurrentCamera__17.PrimaryPart;
        if v19 then
            return v19.Velocity;
        end;
    end;
    return Vector3.new(0, 0, 0);
end;
function u5.GetSubjectRotVelocity(_) --[[ Line: 329 ]]
    local l__CurrentCamera__19 = workspace.CurrentCamera;
    if l__CurrentCamera__19 then
        l__CurrentCamera__19 = l__CurrentCamera__19.CameraSubject;
    end;
    if not l__CurrentCamera__19 then
        return Vector3.new(0, 0, 0);
    end;
    if l__CurrentCamera__19:IsA("BasePart") then
        return l__CurrentCamera__19.RotVelocity;
    end;
    if l__CurrentCamera__19:IsA("Humanoid") then
        local l__RootPart__20 = l__CurrentCamera__19.RootPart;
        if l__RootPart__20 then
            return l__RootPart__20.RotVelocity;
        end;
    else
        local v20 = l__CurrentCamera__19:IsA("Model") and l__CurrentCamera__19.PrimaryPart;
        if v20 then
            return v20.RotVelocity;
        end;
    end;
    return Vector3.new(0, 0, 0);
end;
function u5.StepZoom(p21) --[[ Line: 358 ]]
    -- upvalues: l__CameraInput__4 (copy), l__ZoomController__2 (copy)
    local l__currentSubjectDistance__21 = p21.currentSubjectDistance;
    local v22 = l__CameraInput__4.getZoomDelta();
    if math.abs(v22) > 0 then
        local v23;
        if v22 > 0 then
            v23 = math.max(l__currentSubjectDistance__21 + v22 * (l__currentSubjectDistance__21 * 0.5 + 1), p21.FIRST_PERSON_DISTANCE_THRESHOLD);
        else
            v23 = math.max((l__currentSubjectDistance__21 + v22) / (1 - v22 * 0.5), 0.5);
        end;
        p21:SetCameraToSubjectDistance(v23 < p21.FIRST_PERSON_DISTANCE_THRESHOLD and 0.5 or v23);
    end;
    return l__ZoomController__2.GetZoomRadius();
end;
function u5.GetSubjectPosition(p24) --[[ Line: 383 ]]
    local l__lastSubjectPosition__22 = p24.lastSubjectPosition;
    local l__CurrentCamera__23 = game.Workspace.CurrentCamera;
    if l__CurrentCamera__23 then
        l__CurrentCamera__23 = l__CurrentCamera__23.CameraSubject;
    end;
    if not l__CurrentCamera__23 then
        return nil;
    end;
    if l__CurrentCamera__23:IsA("Humanoid") then
        local v25 = l__CurrentCamera__23:GetState() == Enum.HumanoidStateType.Dead;
        local l__RootPart__24 = l__CurrentCamera__23.RootPart;
        if v25 and (l__CurrentCamera__23.Parent and l__CurrentCamera__23.Parent:IsA("Model")) then
            l__RootPart__24 = l__CurrentCamera__23.Parent:FindFirstChild("Head") or l__RootPart__24;
        end;
        if l__RootPart__24 and l__RootPart__24:IsA("BasePart") then
            local v26;
            if l__CurrentCamera__23.RigType == Enum.HumanoidRigType.R15 then
                if l__CurrentCamera__23.AutomaticScalingEnabled then
                    v26 = Vector3.new(0, 1.5, 0);
                    if l__RootPart__24 == l__CurrentCamera__23.RootPart then
                        v26 = v26 + Vector3.new(0, l__CurrentCamera__23.RootPart.Size.Y / 2 - 1, 0);
                    end;
                else
                    v26 = Vector3.new(0, 2, 0);
                end;
            else
                v26 = Vector3.new(0, 1.5, 0);
            end;
            l__lastSubjectPosition__22 = l__RootPart__24.CFrame.p + l__RootPart__24.CFrame:vectorToWorldSpace((v25 and Vector3.new(0, 0, 0) or v26) + l__CurrentCamera__23.CameraOffset);
        end;
    elseif l__CurrentCamera__23:IsA("VehicleSeat") then
        l__lastSubjectPosition__22 = l__CurrentCamera__23.CFrame.p + l__CurrentCamera__23.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0));
    elseif l__CurrentCamera__23:IsA("SkateboardPlatform") then
        l__lastSubjectPosition__22 = l__CurrentCamera__23.CFrame.p + Vector3.new(0, 5, 0);
    elseif l__CurrentCamera__23:IsA("BasePart") then
        l__lastSubjectPosition__22 = l__CurrentCamera__23.CFrame.p;
    elseif l__CurrentCamera__23:IsA("Model") then
        if l__CurrentCamera__23.PrimaryPart then
            l__lastSubjectPosition__22 = l__CurrentCamera__23:GetPrimaryPartCFrame().p;
        else
            l__lastSubjectPosition__22 = l__CurrentCamera__23:GetModelCFrame().p;
        end;
    end;
    p24.lastSubject = l__CurrentCamera__23;
    p24.lastSubjectPosition = l__lastSubjectPosition__22;
    return l__lastSubjectPosition__22;
end;
function u5.OnViewportSizeChanged(p27) --[[ Line: 453 ]]
    -- upvalues: l__UserInputService__8 (copy)
    local l__ViewportSize__25 = game.Workspace.CurrentCamera.ViewportSize;
    p27.portraitMode = l__ViewportSize__25.X < l__ViewportSize__25.Y;
    local l__TouchEnabled__26 = l__UserInputService__8.TouchEnabled;
    if l__TouchEnabled__26 then
        l__TouchEnabled__26 = l__ViewportSize__25.Y < 500 and true or l__ViewportSize__25.X < 700;
    end;
    p27.isSmallTouchScreen = l__TouchEnabled__26;
end;
function u5.OnCurrentCameraChanged(u28) --[[ Line: 461 ]]
    -- upvalues: l__UserInputService__8 (copy)
    if l__UserInputService__8.TouchEnabled then
        if u28.viewportSizeChangedConn then
            u28.viewportSizeChangedConn:Disconnect();
            u28.viewportSizeChangedConn = nil;
        end;
        local l__CurrentCamera__27 = game.Workspace.CurrentCamera;
        if l__CurrentCamera__27 then
            u28:OnViewportSizeChanged();
            u28.viewportSizeChangedConn = l__CurrentCamera__27:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 472 ]]
                -- upvalues: u28 (copy)
                u28:OnViewportSizeChanged();
            end);
        end;
    end;
    if u28.cameraSubjectChangedConn then
        u28.cameraSubjectChangedConn:Disconnect();
        u28.cameraSubjectChangedConn = nil;
    end;
    local l__CurrentCamera__28 = game.Workspace.CurrentCamera;
    if l__CurrentCamera__28 then
        u28.cameraSubjectChangedConn = l__CurrentCamera__28:GetPropertyChangedSignal("CameraSubject"):Connect(function() --[[ Line: 486 ]]
            -- upvalues: u28 (copy)
            u28:OnNewCameraSubject();
        end);
        u28:OnNewCameraSubject();
    end;
end;
function u5.OnDynamicThumbstickEnabled(p29) --[[ Line: 493 ]]
    -- upvalues: l__UserInputService__8 (copy)
    if l__UserInputService__8.TouchEnabled then
        p29.isDynamicThumbstickEnabled = true;
    end;
end;
function u5.OnDynamicThumbstickDisabled(p30) --[[ Line: 499 ]]
    p30.isDynamicThumbstickEnabled = false;
end;
function u5.OnGameSettingsTouchMovementModeChanged(p31) --[[ Line: 503 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__UserGameSettings__10 (copy)
    if l__LocalPlayer__11.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        if l__UserGameSettings__10.TouchMovementMode == Enum.TouchMovementMode.DynamicThumbstick or l__UserGameSettings__10.TouchMovementMode == Enum.TouchMovementMode.Default then
            p31:OnDynamicThumbstickEnabled();
            return;
        end;
        p31:OnDynamicThumbstickDisabled();
    end;
end;
function u5.OnDevTouchMovementModeChanged(p32) --[[ Line: 514 ]]
    -- upvalues: l__LocalPlayer__11 (copy)
    if l__LocalPlayer__11.DevTouchMovementMode == Enum.DevTouchMovementMode.DynamicThumbstick then
        p32:OnDynamicThumbstickEnabled();
    else
        p32:OnGameSettingsTouchMovementModeChanged();
    end;
end;
function u5.OnPlayerCameraPropertyChange(p33) --[[ Line: 522 ]]
    p33:SetCameraToSubjectDistance(p33.currentSubjectDistance);
end;
function u5.InputTranslationToCameraAngleChange(_, p34, p35) --[[ Line: 527 ]]
    return p34 * p35;
end;
function u5.GamepadZoomPress(p36) --[[ Line: 533 ]]
    -- upvalues: l__LocalPlayer__11 (copy), u3 (ref)
    local v37 = p36:GetCameraToSubjectDistance();
    local l__CameraMaxZoomDistance__29 = l__LocalPlayer__11.CameraMaxZoomDistance;
    for v38 = #p36.gamepadZoomLevels, 1, -1 do
        local v39 = p36.gamepadZoomLevels[v38];
        if l__CameraMaxZoomDistance__29 >= v39 then
            if v39 < l__LocalPlayer__11.CameraMinZoomDistance then
                v39 = l__LocalPlayer__11.CameraMinZoomDistance;
                if u3 and l__CameraMaxZoomDistance__29 == v39 then
                    break;
                end;
            end;
            if not u3 and l__CameraMaxZoomDistance__29 == v39 then
                break;
            end;
            if v39 + (l__CameraMaxZoomDistance__29 - v39) / 2 < v37 then
                p36:SetCameraToSubjectDistance(v39);
                return;
            end;
            l__CameraMaxZoomDistance__29 = v39;
        end;
    end;
    p36:SetCameraToSubjectDistance(p36.gamepadZoomLevels[#p36.gamepadZoomLevels]);
end;
function u5.Enable(p40, p41) --[[ Line: 578 ]]
    if p40.enabled ~= p41 then
        p40.enabled = p41;
        p40:OnEnabledChanged();
    end;
end;
function u5.OnEnabledChanged(u42) --[[ Line: 586 ]]
    -- upvalues: l__CameraInput__4 (copy), l__LocalPlayer__11 (copy)
    if u42.enabled then
        l__CameraInput__4.setInputEnabled(true);
        u42.gamepadZoomPressConnection = l__CameraInput__4.gamepadZoomPress:Connect(function() --[[ Line: 590 ]]
            -- upvalues: u42 (copy)
            u42:GamepadZoomPress();
        end);
        if l__LocalPlayer__11.CameraMode == Enum.CameraMode.LockFirstPerson then
            u42.currentSubjectDistance = 0.5;
            if not u42.inFirstPerson then
                u42:EnterFirstPerson();
            end;
        end;
        if u42.cameraChangedConn then
            u42.cameraChangedConn:Disconnect();
            u42.cameraChangedConn = nil;
        end;
        u42.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() --[[ Line: 602 ]]
            -- upvalues: u42 (copy)
            u42:OnCurrentCameraChanged();
        end);
        u42:OnCurrentCameraChanged();
    else
        l__CameraInput__4.setInputEnabled(false);
        if u42.gamepadZoomPressConnection then
            u42.gamepadZoomPressConnection:Disconnect();
            u42.gamepadZoomPressConnection = nil;
        end;
        u42:Cleanup();
    end;
end;
function u5.GetEnabled(p43) --[[ Line: 618 ]]
    return p43.enabled;
end;
function u5.Cleanup(p44) --[[ Line: 622 ]]
    -- upvalues: l__CameraUtils__1 (copy)
    if p44.subjectStateChangedConn then
        p44.subjectStateChangedConn:Disconnect();
        p44.subjectStateChangedConn = nil;
    end;
    if p44.viewportSizeChangedConn then
        p44.viewportSizeChangedConn:Disconnect();
        p44.viewportSizeChangedConn = nil;
    end;
    if p44.cameraChangedConn then
        p44.cameraChangedConn:Disconnect();
        p44.cameraChangedConn = nil;
    end;
    p44.lastCameraTransform = nil;
    p44.lastSubjectCFrame = nil;
    l__CameraUtils__1.restoreMouseBehavior();
end;
function u5.UpdateMouseBehavior(p45) --[[ Line: 643 ]]
    -- upvalues: l__UserGameSettings__10 (copy), l__CameraUI__5 (copy), l__CameraInput__4 (copy), l__CameraToggleStateController__3 (copy), l__CameraUtils__1 (copy), l__LocalPlayer__11 (copy)
    if p45.isCameraToggle and l__UserGameSettings__10.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        l__CameraUI__5.setCameraModeToastEnabled(true);
        l__CameraInput__4.enableCameraToggleInput();
        l__CameraToggleStateController__3(p45.inFirstPerson);
    else
        l__CameraUI__5.setCameraModeToastEnabled(false);
        l__CameraInput__4.disableCameraToggleInput();
        if p45.inFirstPerson or p45.inMouseLockedMode then
            l__CameraUtils__1.setRotationTypeOverride(Enum.RotationType.CameraRelative);
            local v46 = l__LocalPlayer__11.PlayerGui:FindFirstChild("DialogGui");
            if v46 and (v46.Enabled and v46:WaitForChild("JoinHub").Visible) then
                l__CameraUtils__1.setMouseBehaviorOverride(Enum.MouseBehavior.Default);
            else
                l__CameraUtils__1.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
            end;
        else
            l__CameraUtils__1.restoreRotationType();
            if l__CameraInput__4.getRotationActivated() then
                l__CameraUtils__1.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition);
            else
                l__CameraUtils__1.restoreMouseBehavior();
            end;
        end;
    end;
end;
function u5.UpdateForDistancePropertyChange(p47) --[[ Line: 676 ]]
    p47:SetCameraToSubjectDistance(p47.currentSubjectDistance);
end;
function u5.SetCameraToSubjectDistance(p48, p49) --[[ Line: 682 ]]
    -- upvalues: l__LocalPlayer__11 (copy), l__ZoomController__2 (copy)
    local l__currentSubjectDistance__30 = p48.currentSubjectDistance;
    if l__LocalPlayer__11.CameraMode == Enum.CameraMode.LockFirstPerson then
        p48.currentSubjectDistance = 0.5;
        if not p48.inFirstPerson then
            p48:EnterFirstPerson();
        end;
    else
        local v50 = math.clamp(p49, l__LocalPlayer__11.CameraMinZoomDistance, l__LocalPlayer__11.CameraMaxZoomDistance);
        if v50 < 1 then
            p48.currentSubjectDistance = 0.5;
            if not p48.inFirstPerson then
                p48:EnterFirstPerson();
            end;
        else
            p48.currentSubjectDistance = v50;
            if p48.inFirstPerson then
                p48:LeaveFirstPerson();
            end;
        end;
    end;
    l__ZoomController__2.SetZoomParameters(p48.currentSubjectDistance, (math.sign(p49 - l__currentSubjectDistance__30)));
    return p48.currentSubjectDistance;
end;
function u5.SetCameraType(p51, p52) --[[ Line: 716 ]]
    p51.cameraType = p52;
end;
function u5.GetCameraType(p53) --[[ Line: 721 ]]
    return p53.cameraType;
end;
function u5.SetCameraMovementMode(p54, p55) --[[ Line: 726 ]]
    p54.cameraMovementMode = p55;
end;
function u5.GetCameraMovementMode(p56) --[[ Line: 730 ]]
    return p56.cameraMovementMode;
end;
function u5.SetIsMouseLocked(p57, p58) --[[ Line: 734 ]]
    p57.inMouseLockedMode = p58;
end;
function u5.GetIsMouseLocked(p59) --[[ Line: 738 ]]
    return p59.inMouseLockedMode;
end;
function u5.SetMouseLockOffset(p60, p61) --[[ Line: 742 ]]
    p60.mouseLockOffset = p61;
end;
function u5.GetMouseLockOffset(p62) --[[ Line: 746 ]]
    return p62.mouseLockOffset;
end;
function u5.InFirstPerson(p63) --[[ Line: 750 ]]
    return p63.inFirstPerson;
end;
function u5.EnterFirstPerson(p64) --[[ Line: 754 ]]
    p64.inFirstPerson = true;
    p64:UpdateMouseBehavior();
end;
function u5.LeaveFirstPerson(p65) --[[ Line: 759 ]]
    p65.inFirstPerson = false;
    p65:UpdateMouseBehavior();
end;
function u5.GetCameraToSubjectDistance(p66) --[[ Line: 765 ]]
    return p66.currentSubjectDistance;
end;
function u5.GetMeasuredDistanceToFocus(_) --[[ Line: 772 ]]
    local l__CurrentCamera__31 = game.Workspace.CurrentCamera;
    if l__CurrentCamera__31 then
        return (l__CurrentCamera__31.CoordinateFrame.p - l__CurrentCamera__31.Focus.p).magnitude;
    else
        return nil;
    end;
end;
function u5.GetCameraLookVector(_) --[[ Line: 780 ]]
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
end;
function u5.CalculateNewLookCFrameFromArg(p67, p68, p69) --[[ Line: 784 ]]
    -- upvalues: u4 (ref), l__ReplicatedStorage__7 (copy)
    local v70 = 0;
    local v71 = 0;
    if u4 and u4.CurrentTargetInfo then
        v70, v71 = u4:GetAngularDifferences();
    else
        task.spawn(function() --[[ Line: 793 ]]
            -- upvalues: u4 (ref), l__ReplicatedStorage__7 (ref)
            u4 = require(l__ReplicatedStorage__7:WaitForChild("Modules"):WaitForChild("AimAssist"));
        end);
    end;
    local v72 = p68 or p67:GetCameraLookVector();
    local v73 = math.asin(v72.Y);
    local v74 = math.clamp(p69.Y, v73 + -1.3962634015954636, v73 + 1.3962634015954636);
    local v75 = Vector2.new(p69.X + v70, v74 + v71);
    local v76 = CFrame.new(Vector3.new(0, 0, 0), v72);
    return CFrame.Angles(0, -v75.X, 0) * v76 * CFrame.Angles(-v75.Y, 0, 0);
end;
function u5.CalculateNewLookVectorFromArg(p77, p78, p79) --[[ Line: 815 ]]
    return p77:CalculateNewLookCFrameFromArg(p78, p79).LookVector;
end;
function u5.CalculateNewLookVectorVRFromArg(p80, p81) --[[ Line: 820 ]]
    local l__unit__32 = ((p80:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit;
    local v82 = Vector2.new(p81.X, 0);
    local v83 = CFrame.new(Vector3.new(0, 0, 0), l__unit__32);
    return ((CFrame.Angles(0, -v82.X, 0) * v83 * CFrame.Angles(-v82.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit;
end;
function u5.GetHumanoid(p84) --[[ Line: 830 ]]
    -- upvalues: l__LocalPlayer__11 (copy)
    local v85 = l__LocalPlayer__11;
    if v85 then
        v85 = l__LocalPlayer__11.Character;
    end;
    if not v85 then
        return nil;
    end;
    local v86 = p84.humanoidCache[l__LocalPlayer__11];
    if v86 and v86.Parent == v85 then
        return v86;
    end;
    p84.humanoidCache[l__LocalPlayer__11] = nil;
    local v87 = v85:FindFirstChildOfClass("Humanoid");
    if v87 then
        p84.humanoidCache[l__LocalPlayer__11] = v87;
    end;
    return v87;
end;
function u5.GetHumanoidPartToFollow(_, p88, p89) --[[ Line: 848 ]]
    if p89 == Enum.HumanoidStateType.Dead then
        local l__Parent__33 = p88.Parent;
        if l__Parent__33 then
            return l__Parent__33:FindFirstChild("Head") or p88.Torso;
        else
            return p88.Torso;
        end;
    else
        return p88.Torso;
    end;
end;
function u5.OnNewCameraSubject(p90) --[[ Line: 862 ]]
    if p90.subjectStateChangedConn then
        p90.subjectStateChangedConn:Disconnect();
        p90.subjectStateChangedConn = nil;
    end;
end;
function u5.IsInFirstPerson(p91) --[[ Line: 869 ]]
    return p91.inFirstPerson;
end;
function u5.Update(_, _) --[[ Line: 873 ]]
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2);
end;
function u5.GetCameraHeight(p92) --[[ Line: 877 ]]
    -- upvalues: l__VRService__9 (copy)
    return (not l__VRService__9.VREnabled or p92.inFirstPerson) and 0 or 0.25881904510252074 * p92.currentSubjectDistance;
end;
return u5;