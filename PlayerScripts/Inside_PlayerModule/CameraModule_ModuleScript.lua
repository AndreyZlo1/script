-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = {
    "CameraMinZoomDistance",
    "CameraMaxZoomDistance",
    "CameraMode",
    "DevCameraOcclusionMode",
    "DevComputerCameraMode",
    "DevTouchCameraMode",
    "DevComputerMovementMode",
    "DevTouchMovementMode",
    "DevEnableMouseLock"
};
local u3 = {
    "ComputerCameraMovementMode",
    "ComputerMovementMode",
    "ControlMode",
    "GamepadCameraSensitivity",
    "MouseSensitivity",
    "RotationType",
    "TouchCameraMovementMode",
    "TouchMovementMode"
};
local l__Players__1 = game:GetService("Players");
local l__RunService__2 = game:GetService("RunService");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__VRService__4 = game:GetService("VRService");
local l__UserGameSettings__5 = UserSettings():GetService("UserGameSettings");
local l__CameraUtils__6 = require(script:WaitForChild("CameraUtils"));
local l__CameraInput__7 = require(script:WaitForChild("CameraInput"));
local l__ClassicCamera__8 = require(script:WaitForChild("ClassicCamera"));
local l__OrbitalCamera__9 = require(script:WaitForChild("OrbitalCamera"));
local l__LegacyCamera__10 = require(script:WaitForChild("LegacyCamera"));
local l__VehicleCamera__11 = require(script:WaitForChild("VehicleCamera"));
local l__VRCamera__12 = require(script:WaitForChild("VRCamera"));
local l__VRVehicleCamera__13 = require(script:WaitForChild("VRVehicleCamera"));
local l__Invisicam__14 = require(script:WaitForChild("Invisicam"));
local l__Poppercam__15 = require(script:WaitForChild("Poppercam"));
local l__TransparencyController__16 = require(script:WaitForChild("TransparencyController"));
local l__MouseLockController__17 = require(script:WaitForChild("MouseLockController"));
local u4 = {};
local u5 = {};
local l__PlayerScripts__18 = l__Players__1.LocalPlayer:WaitForChild("PlayerScripts");
l__PlayerScripts__18:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default);
l__PlayerScripts__18:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow);
l__PlayerScripts__18:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic);
l__PlayerScripts__18:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default);
l__PlayerScripts__18:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow);
l__PlayerScripts__18:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic);
l__PlayerScripts__18:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle);
function u1.new() --[[ Line: 95 ]]
    -- upvalues: u1 (copy), l__Players__1 (copy), l__TransparencyController__16 (copy), l__UserInputService__3 (copy), l__MouseLockController__17 (copy), l__RunService__2 (copy), u2 (copy), u3 (copy), l__UserGameSettings__5 (copy)
    local u6 = setmetatable({}, u1);
    u6.activeCameraController = nil;
    u6.activeOcclusionModule = nil;
    u6.activeTransparencyController = nil;
    u6.activeMouseLockController = nil;
    u6.currentComputerCameraMovementMode = nil;
    u6.cameraSubjectChangedConn = nil;
    u6.cameraTypeChangedConn = nil;
    for _, v7 in pairs(l__Players__1:GetPlayers()) do
        u6:OnPlayerAdded(v7);
    end;
    l__Players__1.PlayerAdded:Connect(function(p8) --[[ Line: 116 ]]
        -- upvalues: u6 (copy)
        u6:OnPlayerAdded(p8);
    end);
    u6.activeTransparencyController = l__TransparencyController__16.new();
    u6.activeTransparencyController:Enable(true);
    if not l__UserInputService__3.TouchEnabled then
        u6.activeMouseLockController = l__MouseLockController__17.new();
        local v9 = u6.activeMouseLockController:GetBindableToggleEvent();
        if v9 then
            v9:Connect(function() --[[ Line: 127 ]]
                -- upvalues: u6 (copy)
                u6:OnMouseLockToggled();
            end);
        end;
    end;
    u6:ActivateCameraController(u6:GetCameraControlChoice());
    u6:ActivateOcclusionModule(l__Players__1.LocalPlayer.DevCameraOcclusionMode);
    u6:OnCurrentCameraChanged();
    l__RunService__2:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(p10) --[[ Line: 136 ]]
        -- upvalues: u6 (copy)
        u6:Update(p10);
    end);
    for _, u11 in pairs(u2) do
        l__Players__1.LocalPlayer:GetPropertyChangedSignal(u11):Connect(function() --[[ Line: 140 ]]
            -- upvalues: u6 (copy), u11 (copy)
            u6:OnLocalPlayerCameraPropertyChanged(u11);
        end);
    end;
    for _, u12 in pairs(u3) do
        l__UserGameSettings__5:GetPropertyChangedSignal(u12):Connect(function() --[[ Line: 146 ]]
            -- upvalues: u6 (copy), u12 (copy)
            u6:OnUserGameSettingsPropertyChanged(u12);
        end);
    end;
    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() --[[ Line: 150 ]]
        -- upvalues: u6 (copy)
        u6:OnCurrentCameraChanged();
    end);
    return u6;
end;
function u1.GetCameraMovementModeFromSettings(_) --[[ Line: 157 ]]
    -- upvalues: l__Players__1 (copy), l__CameraUtils__6 (copy), l__UserInputService__3 (copy), l__UserGameSettings__5 (copy)
    if l__Players__1.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return l__CameraUtils__6.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic);
    else
        local v13, v14;
        if l__UserInputService__3.TouchEnabled then
            v13 = l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__Players__1.LocalPlayer.DevTouchCameraMode);
            v14 = l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__UserGameSettings__5.TouchCameraMovementMode);
        else
            v13 = l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__Players__1.LocalPlayer.DevComputerCameraMode);
            v14 = l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__UserGameSettings__5.ComputerCameraMovementMode);
        end;
        if v13 == Enum.DevComputerCameraMovementMode.UserChoice then
            return v14;
        else
            return v13;
        end;
    end;
end;
function u1.ActivateOcclusionModule(p15, p16) --[[ Line: 182 ]]
    -- upvalues: l__Poppercam__15 (copy), l__Invisicam__14 (copy), u5 (copy), l__Players__1 (copy)
    local v17;
    if p16 == Enum.DevCameraOcclusionMode.Zoom then
        v17 = l__Poppercam__15;
    else
        if p16 ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode");
            return;
        end;
        v17 = l__Invisicam__14;
    end;
    p15.occlusionMode = p16;
    if p15.activeOcclusionModule and p15.activeOcclusionModule:GetOcclusionMode() == p16 then
        if not p15.activeOcclusionModule:GetEnabled() then
            p15.activeOcclusionModule:Enable(true);
        end;
    else
        local l__activeOcclusionModule__19 = p15.activeOcclusionModule;
        p15.activeOcclusionModule = u5[v17];
        if not p15.activeOcclusionModule then
            p15.activeOcclusionModule = v17.new();
            if p15.activeOcclusionModule then
                u5[v17] = p15.activeOcclusionModule;
            end;
        end;
        if p15.activeOcclusionModule then
            if p15.activeOcclusionModule:GetOcclusionMode() ~= p16 then
                warn("CameraScript ActivateOcclusionModule mismatch: ", p15.activeOcclusionModule:GetOcclusionMode(), "~=", p16);
            end;
            if l__activeOcclusionModule__19 then
                if l__activeOcclusionModule__19 == p15.activeOcclusionModule then
                    warn("CameraScript ActivateOcclusionModule failure to detect already running correct module");
                else
                    l__activeOcclusionModule__19:Enable(false);
                end;
            end;
            if p16 == Enum.DevCameraOcclusionMode.Invisicam then
                if l__Players__1.LocalPlayer.Character then
                    p15.activeOcclusionModule:CharacterAdded(l__Players__1.LocalPlayer.Character, l__Players__1.LocalPlayer);
                end;
            else
                for _, v18 in pairs(l__Players__1:GetPlayers()) do
                    if v18 and v18.Character then
                        p15.activeOcclusionModule:CharacterAdded(v18.Character, v18);
                    end;
                end;
                p15.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject);
            end;
            p15.activeOcclusionModule:Enable(true);
        end;
    end;
end;
function u1.ShouldUseVehicleCamera(p19) --[[ Line: 261 ]]
    local l__CurrentCamera__20 = workspace.CurrentCamera;
    if not l__CurrentCamera__20 then
        return false;
    end;
    local l__CameraType__21 = l__CurrentCamera__20.CameraType;
    local l__CameraSubject__22 = l__CurrentCamera__20.CameraSubject;
    local v20 = l__CameraType__21 == Enum.CameraType.Custom and true or l__CameraType__21 == Enum.CameraType.Follow;
    local v21 = l__CameraSubject__22 and l__CameraSubject__22:IsA("VehicleSeat") or false;
    local v22 = p19.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam;
    if v21 then
        if not v20 then
            v22 = v20;
        end;
    else
        v22 = v21;
    end;
    return v22;
end;
function u1.ActivateCameraController(p23, p24, p25) --[[ Line: 279 ]]
    -- upvalues: l__LegacyCamera__10 (copy), l__VRService__4 (copy), l__VRCamera__12 (copy), l__ClassicCamera__8 (copy), l__OrbitalCamera__9 (copy), l__VRVehicleCamera__13 (copy), l__VehicleCamera__11 (copy), u4 (copy)
    local v26 = nil;
    if p25 ~= nil then
        if p25 == Enum.CameraType.Scriptable then
            if p23.activeCameraController then
                p23.activeCameraController:Enable(false);
                p23.activeCameraController = nil;
            end;
            return;
        end;
        if p25 == Enum.CameraType.Custom then
            p24 = p23:GetCameraMovementModeFromSettings();
        elseif p25 == Enum.CameraType.Track then
            p24 = Enum.ComputerCameraMovementMode.Classic;
        elseif p25 == Enum.CameraType.Follow then
            p24 = Enum.ComputerCameraMovementMode.Follow;
        elseif p25 == Enum.CameraType.Orbital then
            p24 = Enum.ComputerCameraMovementMode.Orbital;
        elseif p25 == Enum.CameraType.Attach or (p25 == Enum.CameraType.Watch or p25 == Enum.CameraType.Fixed) then
            v26 = l__LegacyCamera__10;
        else
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", p25);
        end;
    end;
    if not v26 then
        if l__VRService__4.VREnabled then
            v26 = l__VRCamera__12;
        elseif p24 == Enum.ComputerCameraMovementMode.Classic or (p24 == Enum.ComputerCameraMovementMode.Follow or (p24 == Enum.ComputerCameraMovementMode.Default or p24 == Enum.ComputerCameraMovementMode.CameraToggle)) then
            v26 = l__ClassicCamera__8;
        else
            if p24 ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.");
                return;
            end;
            v26 = l__OrbitalCamera__9;
        end;
    end;
    if p23:ShouldUseVehicleCamera() then
        if l__VRService__4.VREnabled then
            v26 = l__VRVehicleCamera__13;
        else
            v26 = l__VehicleCamera__11;
        end;
    end;
    local v27;
    if u4[v26] then
        v27 = u4[v26];
        if v27.Reset then
            v27:Reset();
        end;
    else
        v27 = v26.new();
        u4[v26] = v27;
    end;
    if p23.activeCameraController then
        if p23.activeCameraController == v27 then
            if not p23.activeCameraController:GetEnabled() then
                p23.activeCameraController:Enable(true);
            end;
        else
            p23.activeCameraController:Enable(false);
            p23.activeCameraController = v27;
            p23.activeCameraController:Enable(true);
        end;
    elseif v27 ~= nil then
        p23.activeCameraController = v27;
        p23.activeCameraController:Enable(true);
    end;
    if p23.activeCameraController then
        if p24 ~= nil then
            p23.activeCameraController:SetCameraMovementMode(p24);
            return;
        end;
        if p25 ~= nil then
            p23.activeCameraController:SetCameraType(p25);
        end;
    end;
end;
function u1.OnCameraSubjectChanged(p28) --[[ Line: 384 ]]
    local l__CurrentCamera__23 = workspace.CurrentCamera;
    local v29;
    if l__CurrentCamera__23 then
        v29 = l__CurrentCamera__23.CameraSubject;
    else
        v29 = l__CurrentCamera__23;
    end;
    if p28.activeTransparencyController then
        p28.activeTransparencyController:SetSubject(v29);
    end;
    if p28.activeOcclusionModule then
        p28.activeOcclusionModule:OnCameraSubjectChanged(v29);
    end;
    p28:ActivateCameraController(nil, l__CurrentCamera__23.CameraType);
end;
function u1.OnCameraTypeChanged(p30, p31) --[[ Line: 399 ]]
    -- upvalues: l__UserInputService__3 (copy), l__CameraUtils__6 (copy)
    if p31 == Enum.CameraType.Scriptable and l__UserInputService__3.MouseBehavior == Enum.MouseBehavior.LockCenter then
        l__CameraUtils__6.restoreMouseBehavior();
    end;
    p30:ActivateCameraController(nil, p31);
end;
function u1.OnCurrentCameraChanged(u32) --[[ Line: 411 ]]
    local l__CurrentCamera__24 = game.Workspace.CurrentCamera;
    if l__CurrentCamera__24 then
        if u32.cameraSubjectChangedConn then
            u32.cameraSubjectChangedConn:Disconnect();
        end;
        if u32.cameraTypeChangedConn then
            u32.cameraTypeChangedConn:Disconnect();
        end;
        u32.cameraSubjectChangedConn = l__CurrentCamera__24:GetPropertyChangedSignal("CameraSubject"):Connect(function() --[[ Line: 423 ]]
            -- upvalues: u32 (copy), l__CurrentCamera__24 (copy)
            u32:OnCameraSubjectChanged(l__CurrentCamera__24.CameraSubject);
        end);
        u32.cameraTypeChangedConn = l__CurrentCamera__24:GetPropertyChangedSignal("CameraType"):Connect(function() --[[ Line: 427 ]]
            -- upvalues: u32 (copy), l__CurrentCamera__24 (copy)
            u32:OnCameraTypeChanged(l__CurrentCamera__24.CameraType);
        end);
        u32:OnCameraSubjectChanged(l__CurrentCamera__24.CameraSubject);
        u32:OnCameraTypeChanged(l__CurrentCamera__24.CameraType);
    end;
end;
function u1.OnLocalPlayerCameraPropertyChanged(p33, p34) --[[ Line: 435 ]]
    -- upvalues: l__Players__1 (copy), l__CameraUtils__6 (copy)
    if p34 == "CameraMode" then
        if l__Players__1.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if l__Players__1.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                local v35 = p33:GetCameraMovementModeFromSettings();
                p33:ActivateCameraController(l__CameraUtils__6.ConvertCameraModeEnumToStandard(v35));
                return;
            else
                warn("Unhandled value for property player.CameraMode: ", l__Players__1.LocalPlayer.CameraMode);
                return;
            end;
        end;
        if not p33.activeCameraController or p33.activeCameraController:GetModuleName() ~= "ClassicCamera" then
            p33:ActivateCameraController(l__CameraUtils__6.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic));
        end;
        if p33.activeCameraController then
            p33.activeCameraController:UpdateForDistancePropertyChange();
        end;
    else
        if p34 == "DevComputerCameraMode" or p34 == "DevTouchCameraMode" then
            local v36 = p33:GetCameraMovementModeFromSettings();
            p33:ActivateCameraController(l__CameraUtils__6.ConvertCameraModeEnumToStandard(v36));
            return;
        end;
        if p34 == "DevCameraOcclusionMode" then
            p33:ActivateOcclusionModule(l__Players__1.LocalPlayer.DevCameraOcclusionMode);
            return;
        end;
        if p34 == "CameraMinZoomDistance" or p34 == "CameraMaxZoomDistance" then
            if p33.activeCameraController then
                p33.activeCameraController:UpdateForDistancePropertyChange();
            end;
        else
            if p34 == "DevTouchMovementMode" then
                return;
            end;
            if p34 == "DevComputerMovementMode" then
                return;
            end;
            local _ = p34 == "DevEnableMouseLock";
        end;
    end;
end;
function u1.OnUserGameSettingsPropertyChanged(p37, p38) --[[ Line: 479 ]]
    -- upvalues: l__CameraUtils__6 (copy)
    if p38 == "ComputerCameraMovementMode" then
        local v39 = p37:GetCameraMovementModeFromSettings();
        p37:ActivateCameraController(l__CameraUtils__6.ConvertCameraModeEnumToStandard(v39));
    end;
end;
function u1.Update(p40, p41) --[[ Line: 492 ]]
    -- upvalues: l__CameraInput__7 (copy)
    if p40.activeCameraController then
        p40.activeCameraController:UpdateMouseBehavior();
        local v42, v43 = p40.activeCameraController:Update(p41);
        if p40.activeOcclusionModule then
            v42, v43 = p40.activeOcclusionModule:Update(p41, v42, v43);
        end;
        local l__CurrentCamera__25 = game.Workspace.CurrentCamera;
        l__CurrentCamera__25.CFrame = v42;
        l__CurrentCamera__25.Focus = v43;
        if p40.activeTransparencyController then
            p40.activeTransparencyController:Update(p41);
        end;
        if l__CameraInput__7.getInputEnabled() then
            l__CameraInput__7.resetInputForFrameEnd();
        end;
    end;
end;
function u1.GetCameraControlChoice(_) --[[ Line: 520 ]]
    -- upvalues: l__Players__1 (copy), l__UserInputService__3 (copy), l__CameraUtils__6 (copy), l__UserGameSettings__5 (copy)
    local l__LocalPlayer__26 = l__Players__1.LocalPlayer;
    if l__LocalPlayer__26 then
        if l__UserInputService__3:GetLastInputType() == Enum.UserInputType.Touch or l__UserInputService__3.TouchEnabled then
            if l__LocalPlayer__26.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
                return l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__UserGameSettings__5.TouchCameraMovementMode);
            else
                return l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__LocalPlayer__26.DevTouchCameraMode);
            end;
        else
            if l__LocalPlayer__26.DevComputerCameraMode ~= Enum.DevComputerCameraMovementMode.UserChoice then
                return l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__LocalPlayer__26.DevComputerCameraMode);
            end;
            local v44 = l__CameraUtils__6.ConvertCameraModeEnumToStandard(l__UserGameSettings__5.ComputerCameraMovementMode);
            return l__CameraUtils__6.ConvertCameraModeEnumToStandard(v44);
        end;
    end;
end;
function u1.OnCharacterAdded(p45, p46, p47) --[[ Line: 543 ]]
    if p45.activeOcclusionModule then
        p45.activeOcclusionModule:CharacterAdded(p46, p47);
    end;
end;
function u1.OnCharacterRemoving(p48, p49, p50) --[[ Line: 549 ]]
    if p48.activeOcclusionModule then
        p48.activeOcclusionModule:CharacterRemoving(p49, p50);
    end;
end;
function u1.OnPlayerAdded(u51, u52) --[[ Line: 555 ]]
    u52.CharacterAdded:Connect(function(p53) --[[ Line: 556 ]]
        -- upvalues: u51 (copy), u52 (copy)
        u51:OnCharacterAdded(p53, u52);
    end);
    u52.CharacterRemoving:Connect(function(p54) --[[ Line: 559 ]]
        -- upvalues: u51 (copy), u52 (copy)
        u51:OnCharacterRemoving(p54, u52);
    end);
end;
function u1.OnMouseLockToggled(p55) --[[ Line: 564 ]]
    if p55.activeMouseLockController then
        local v56 = p55.activeMouseLockController:GetIsMouseLocked();
        local v57 = p55.activeMouseLockController:GetMouseLockOffset();
        if p55.activeCameraController then
            p55.activeCameraController:SetIsMouseLocked(v56);
            p55.activeCameraController:SetMouseLockOffset(v57);
        end;
    end;
end;
u1.new();
return {};