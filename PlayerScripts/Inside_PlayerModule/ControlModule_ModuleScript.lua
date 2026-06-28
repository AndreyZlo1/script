-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local l__Players__1 = game:GetService("Players");
local l__RunService__2 = game:GetService("RunService");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__GuiService__4 = game:GetService("GuiService");
local l__Workspace__5 = game:GetService("Workspace");
local l__UserGameSettings__6 = UserSettings():GetService("UserGameSettings");
local l__VRService__7 = game:GetService("VRService");
local l__Keyboard__8 = require(script:WaitForChild("Keyboard"));
local l__Gamepad__9 = require(script:WaitForChild("Gamepad"));
local l__DynamicThumbstick__10 = require(script:WaitForChild("DynamicThumbstick"));
local v2, v3 = pcall(function() --[[ Line: 32 ]]
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate");
end);
local u4 = v2 and v3;
local l__TouchThumbstick__11 = require(script:WaitForChild("TouchThumbstick"));
local l__ClickToMoveController__12 = require(script:WaitForChild("ClickToMoveController"));
local l__TouchJump__13 = require(script:WaitForChild("TouchJump"));
local l__VehicleController__14 = require(script:WaitForChild("VehicleController"));
local l__Value__15 = Enum.ContextActionPriority.Medium.Value;
local u5 = {
    [Enum.TouchMovementMode.DPad] = l__DynamicThumbstick__10,
    [Enum.DevTouchMovementMode.DPad] = l__DynamicThumbstick__10,
    [Enum.TouchMovementMode.Thumbpad] = l__DynamicThumbstick__10,
    [Enum.DevTouchMovementMode.Thumbpad] = l__DynamicThumbstick__10,
    [Enum.TouchMovementMode.Thumbstick] = l__TouchThumbstick__11,
    [Enum.DevTouchMovementMode.Thumbstick] = l__TouchThumbstick__11,
    [Enum.TouchMovementMode.DynamicThumbstick] = l__DynamicThumbstick__10,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = l__DynamicThumbstick__10,
    [Enum.TouchMovementMode.ClickToMove] = l__ClickToMoveController__12,
    [Enum.DevTouchMovementMode.ClickToMove] = l__ClickToMoveController__12,
    [Enum.TouchMovementMode.Default] = l__DynamicThumbstick__10,
    [Enum.ComputerMovementMode.Default] = l__Keyboard__8,
    [Enum.ComputerMovementMode.KeyboardMouse] = l__Keyboard__8,
    [Enum.DevComputerMovementMode.KeyboardMouse] = l__Keyboard__8,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = l__ClickToMoveController__12,
    [Enum.DevComputerMovementMode.ClickToMove] = l__ClickToMoveController__12
};
local u6 = {
    [Enum.UserInputType.Keyboard] = l__Keyboard__8,
    [Enum.UserInputType.MouseButton1] = l__Keyboard__8,
    [Enum.UserInputType.MouseButton2] = l__Keyboard__8,
    [Enum.UserInputType.MouseButton3] = l__Keyboard__8,
    [Enum.UserInputType.MouseWheel] = l__Keyboard__8,
    [Enum.UserInputType.MouseMovement] = l__Keyboard__8,
    [Enum.UserInputType.Gamepad1] = l__Gamepad__9,
    [Enum.UserInputType.Gamepad2] = l__Gamepad__9,
    [Enum.UserInputType.Gamepad3] = l__Gamepad__9,
    [Enum.UserInputType.Gamepad4] = l__Gamepad__9
};
local u7 = nil;
function u1.new() --[[ Line: 89 ]]
    -- upvalues: u1 (copy), l__Players__1 (copy), l__VehicleController__14 (copy), l__Value__15 (copy), l__RunService__2 (copy), l__UserInputService__3 (copy), l__UserGameSettings__6 (copy), l__GuiService__4 (copy)
    local u8 = setmetatable({}, u1);
    u8.controllers = {};
    u8.activeControlModule = nil;
    u8.activeController = nil;
    u8.touchJumpController = nil;
    u8.moveFunction = l__Players__1.LocalPlayer.Move;
    u8.humanoid = nil;
    u8.lastInputType = Enum.UserInputType.None;
    u8.controlsEnabled = true;
    u8.humanoidSeatedConn = nil;
    u8.vehicleController = nil;
    u8.touchControlFrame = nil;
    u8.currentTorsoAngle = 0;
    u8.vehicleController = l__VehicleController__14.new(l__Value__15);
    l__Players__1.LocalPlayer.CharacterAdded:Connect(function(p9) --[[ Line: 113 ]]
        -- upvalues: u8 (copy)
        u8:OnCharacterAdded(p9);
    end);
    l__Players__1.LocalPlayer.CharacterRemoving:Connect(function(p10) --[[ Line: 114 ]]
        -- upvalues: u8 (copy)
        u8:OnCharacterRemoving(p10);
    end);
    if l__Players__1.LocalPlayer.Character then
        u8:OnCharacterAdded(l__Players__1.LocalPlayer.Character);
    end;
    l__RunService__2:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p11) --[[ Line: 119 ]]
        -- upvalues: u8 (copy)
        u8:OnRenderStepped(p11);
    end);
    l__UserInputService__3.LastInputTypeChanged:Connect(function(p12) --[[ Line: 123 ]]
        -- upvalues: u8 (copy)
        u8:OnLastInputTypeChanged(p12);
    end);
    l__UserGameSettings__6:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() --[[ Line: 128 ]]
        -- upvalues: u8 (copy)
        u8:OnTouchMovementModeChange();
    end);
    l__Players__1.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() --[[ Line: 131 ]]
        -- upvalues: u8 (copy)
        u8:OnTouchMovementModeChange();
    end);
    l__UserGameSettings__6:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() --[[ Line: 135 ]]
        -- upvalues: u8 (copy)
        u8:OnComputerMovementModeChange();
    end);
    l__Players__1.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() --[[ Line: 138 ]]
        -- upvalues: u8 (copy)
        u8:OnComputerMovementModeChange();
    end);
    u8.playerGui = nil;
    u8.touchGui = nil;
    u8.playerGuiAddedConn = nil;
    l__GuiService__4:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() --[[ Line: 147 ]]
        -- upvalues: u8 (copy)
        u8:UpdateTouchGuiVisibility();
        u8:UpdateActiveControlModuleEnabled();
    end);
    if not l__UserInputService__3.TouchEnabled then
        u8:OnLastInputTypeChanged(l__UserInputService__3:GetLastInputType());
        return u8;
    end;
    u8.playerGui = l__Players__1.LocalPlayer:FindFirstChildOfClass("PlayerGui");
    if not u8.playerGui then
        u8.playerGuiAddedConn = l__Players__1.LocalPlayer.ChildAdded:Connect(function(p13) --[[ Line: 158 ]]
            -- upvalues: u8 (copy), l__UserInputService__3 (ref)
            if p13:IsA("PlayerGui") then
                u8.playerGui = p13;
                u8:CreateTouchGuiContainer();
                u8.playerGuiAddedConn:Disconnect();
                u8.playerGuiAddedConn = nil;
                u8:OnLastInputTypeChanged(l__UserInputService__3:GetLastInputType());
            end;
        end);
        return u8;
    end;
    u8:CreateTouchGuiContainer();
    u8:OnLastInputTypeChanged(l__UserInputService__3:GetLastInputType());
    return u8;
end;
function u1.GetMoveVector(p14) --[[ Line: 178 ]]
    return not p14.activeController and Vector3.new(0, 0, 0) or p14.activeController:GetMoveVector();
end;
function u1.GetEstimatedVRTorsoFrame(p15) --[[ Line: 198 ]]
    -- upvalues: l__VRService__7 (copy)
    local v16 = l__VRService__7:GetUserCFrame(Enum.UserCFrame.Head);
    local _, v17, _ = v16:ToEulerAnglesYXZ();
    local v18 = -v17;
    if l__VRService__7:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and l__VRService__7:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local v19 = l__VRService__7:GetUserCFrame(Enum.UserCFrame.LeftHand);
        local v20 = l__VRService__7:GetUserCFrame(Enum.UserCFrame.RightHand);
        local v21 = v16.Position - v19.Position;
        local v22 = v16.Position - v20.Position;
        local v23 = -math.atan2(v21.X, v21.Z);
        local v24 = (-math.atan2(v22.X, v22.Z) - v23 + 12.566370614359172) % 6.283185307179586;
        if v24 > 3.141592653589793 then
            v24 = v24 - 6.283185307179586;
        end;
        local v25 = (v23 + v24 / 2 + 12.566370614359172) % 6.283185307179586;
        if v25 > 3.141592653589793 then
            v25 = v25 - 6.283185307179586;
        end;
        local v26 = (v18 - p15.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;
        if v26 > 3.141592653589793 then
            v26 = v26 - 6.283185307179586;
        end;
        local v27 = (v25 - p15.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;
        if v27 > 3.141592653589793 then
            v27 = v27 - 6.283185307179586;
        end;
        local v28;
        if v27 > -1.5707963267948966 then
            v28 = v27 < 1.5707963267948966;
        else
            v28 = false;
        end;
        if not v28 then
            v27 = v26;
        end;
        local v29 = math.min(v27, v26);
        local v30 = math.max(v27, v26);
        local v31 = 0;
        if v29 > 0 then
            v30 = v29;
        elseif v30 >= 0 then
            v30 = v31;
        end;
        p15.currentTorsoAngle = v30 + p15.currentTorsoAngle;
    else
        p15.currentTorsoAngle = v18;
    end;
    return CFrame.new(v16.Position) * CFrame.fromEulerAnglesYXZ(0, -p15.currentTorsoAngle, 0);
end;
function u1.GetActiveController(p32) --[[ Line: 242 ]]
    return p32.activeController;
end;
function u1.UpdateActiveControlModuleEnabled(u33) --[[ Line: 247 ]]
    -- upvalues: l__Players__1 (copy), l__ClickToMoveController__12 (copy), l__GuiService__4 (copy), l__UserInputService__3 (copy), l__TouchThumbstick__11 (copy), l__DynamicThumbstick__10 (copy)
    local function v34() --[[ Line: 257 ]]
        -- upvalues: u33 (copy), l__ClickToMoveController__12 (ref), l__Players__1 (ref)
        if u33.activeControlModule == l__ClickToMoveController__12 then
            u33.activeController:Enable(true, l__Players__1.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, u33.touchJumpController);
        elseif u33.touchControlFrame then
            u33.activeController:Enable(true, u33.touchControlFrame);
        else
            u33.activeController:Enable(true);
        end;
    end;
    if u33.activeController then
        if u33.controlsEnabled then
            if l__GuiService__4.TouchControlsEnabled or (not l__UserInputService__3.TouchEnabled or u33.activeControlModule ~= l__ClickToMoveController__12 and (u33.activeControlModule ~= l__TouchThumbstick__11 and u33.activeControlModule ~= l__DynamicThumbstick__10)) then
                v34();
            else
                u33.activeController:Enable(false);
                if u33.moveFunction then
                    u33.moveFunction(l__Players__1.LocalPlayer, Vector3.new(0, 0, 0), true);
                end;
            end;
        else
            u33.activeController:Enable(false);
            if u33.moveFunction then
                u33.moveFunction(l__Players__1.LocalPlayer, Vector3.new(0, 0, 0), true);
            end;
        end;
    end;
end;
function u1.Enable(p35, p36) --[[ Line: 297 ]]
    p35.controlsEnabled = p36 == nil and true or p36;
    if p35.activeController then
        p35:UpdateActiveControlModuleEnabled();
    end;
end;
function u1.Disable(p37) --[[ Line: 311 ]]
    p37.controlsEnabled = false;
    p37:UpdateActiveControlModuleEnabled();
end;
function u1.SelectComputerMovementModule(_) --[[ Line: 319 ]]
    -- upvalues: l__UserInputService__3 (copy), l__Players__1 (copy), u6 (copy), u7 (ref), l__UserGameSettings__6 (copy), l__Keyboard__8 (copy), l__ClickToMoveController__12 (copy), u5 (copy)
    if l__UserInputService__3.KeyboardEnabled or l__UserInputService__3.GamepadEnabled then
        local l__DevComputerMovementMode__16 = l__Players__1.LocalPlayer.DevComputerMovementMode;
        local v38;
        if l__DevComputerMovementMode__16 == Enum.DevComputerMovementMode.UserChoice then
            v38 = u6[u7];
            if l__UserGameSettings__6.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v38 == l__Keyboard__8 then
                v38 = l__ClickToMoveController__12;
            end;
        else
            v38 = u5[l__DevComputerMovementMode__16];
            if not v38 and l__DevComputerMovementMode__16 ~= Enum.DevComputerMovementMode.Scriptable then
                warn("No character control module is associated with DevComputerMovementMode ", l__DevComputerMovementMode__16);
            end;
        end;
        if v38 then
            return v38, true;
        elseif l__DevComputerMovementMode__16 == Enum.DevComputerMovementMode.Scriptable then
            return nil, true;
        else
            return nil, false;
        end;
    else
        return nil, false;
    end;
end;
function u1.SelectTouchModule(_) --[[ Line: 357 ]]
    -- upvalues: l__UserInputService__3 (copy), l__Players__1 (copy), u5 (copy), l__UserGameSettings__6 (copy)
    if not l__UserInputService__3.TouchEnabled then
        return nil, false;
    end;
    local l__DevTouchMovementMode__17 = l__Players__1.LocalPlayer.DevTouchMovementMode;
    local v39;
    if l__DevTouchMovementMode__17 == Enum.DevTouchMovementMode.UserChoice then
        v39 = u5[l__UserGameSettings__6.TouchMovementMode];
    else
        if l__DevTouchMovementMode__17 == Enum.DevTouchMovementMode.Scriptable then
            return nil, true;
        end;
        v39 = u5[l__DevTouchMovementMode__17];
    end;
    return v39, true;
end;
local function u42() --[[ Line: 373 ]]
    -- upvalues: l__UserInputService__3 (copy)
    local v40 = l__UserInputService__3:GetGamepadState(Enum.UserInputType.Gamepad1);
    for _, v41 in pairs(v40) do
        if v41.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v41.Position;
        end;
    end;
    return Vector3.new(0, 0, 0);
end;
function u1.calculateRawMoveVector(p43, p44, p45) --[[ Line: 383 ]]
    -- upvalues: l__Workspace__5 (copy), l__VRService__7 (copy), u42 (copy)
    local l__CurrentCamera__18 = l__Workspace__5.CurrentCamera;
    if not l__CurrentCamera__18 then
        return p45;
    end;
    local l__CFrame__19 = l__CurrentCamera__18.CFrame;
    if l__VRService__7.VREnabled and p44.RootPart then
        l__VRService__7:GetUserCFrame(Enum.UserCFrame.Head);
        local v46 = p43:GetEstimatedVRTorsoFrame();
        if (l__CurrentCamera__18.Focus.Position - l__CFrame__19.Position).Magnitude < 3 then
            l__CFrame__19 = l__CFrame__19 * v46;
        else
            l__CFrame__19 = l__CurrentCamera__18.CFrame * (v46.Rotation + v46.Position * l__CurrentCamera__18.HeadScale);
        end;
    end;
    if p44:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, v51, v48, v49, _, _, v50, _, _, v51 = l__CFrame__19:GetComponents();
        if v50 >= 1 or v50 <= -1 then
            v49 = -v48 * math.sign(v50);
        end;
        local v52 = math.sqrt(v51 * v51 + v49 * v49);
        return Vector3.new((v51 * p45.X + v49 * p45.Z) / v52, 0, (v51 * p45.Z - v49 * p45.X) / v52);
    end;
    if not l__VRService__7.VREnabled then
        return l__CFrame__19:VectorToWorldSpace(p45);
    end;
    local v53 = Vector3.new(p45.X, 0, p45.Z);
    if v53.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0);
    end;
    local v54 = -u42().Y * 1.3962634015954636;
    local v55 = math.atan2(-v53.X, -v53.Z);
    local _, v56, _ = l__CFrame__19:ToEulerAnglesYXZ();
    return CFrame.fromEulerAnglesYXZ(v54, v55 + v56, 0).LookVector;
end;
function u1.OnRenderStepped(p57, p58) --[[ Line: 442 ]]
    -- upvalues: l__Gamepad__9 (copy), l__Players__1 (copy)
    if p57.activeController and (p57.activeController.enabled and p57.humanoid) then
        p57.activeController:OnRenderStepped(p58);
        local v59 = p57.activeController:GetMoveVector();
        local v60 = p57.activeController:IsMoveVectorCameraRelative();
        local v61 = p57:GetClickToMoveController();
        if p57.activeController ~= v61 then
            if v59.magnitude > 0 then
                v61:CleanupPath();
            else
                v61:OnRenderStepped(p58);
                v59 = v61:GetMoveVector();
                v60 = v61:IsMoveVectorCameraRelative();
            end;
        end;
        if p57.vehicleController then
            local v62;
            v59, v62 = p57.vehicleController:Update(v59, v60, p57.activeControlModule == l__Gamepad__9);
        end;
        if v60 then
            v59 = p57:calculateRawMoveVector(p57.humanoid, v59);
        end;
        p57.moveFunction(l__Players__1.LocalPlayer, v59, false);
        local l__humanoid__20 = p57.humanoid;
        local v63 = not p57.activeController:GetIsJumping() and p57.touchJumpController;
        if v63 then
            v63 = p57.touchJumpController:GetIsJumping();
        end;
        l__humanoid__20.Jump = v63;
    end;
end;
function u1.OnHumanoidSeated(p64, p65, p66) --[[ Line: 485 ]]
    -- upvalues: l__Value__15 (copy)
    if p65 then
        if p66 and p66:IsA("VehicleSeat") then
            if not p64.vehicleController then
                p64.vehicleController = p64.vehicleController.new(l__Value__15);
            end;
            p64.vehicleController:Enable(true, p66);
        end;
    elseif p64.vehicleController then
        p64.vehicleController:Enable(false, p66);
    end;
end;
function u1.OnCharacterAdded(u67, p68) --[[ Line: 500 ]]
    u67.humanoid = p68:FindFirstChildOfClass("Humanoid");
    while not u67.humanoid do
        p68.ChildAdded:wait();
        u67.humanoid = p68:FindFirstChildOfClass("Humanoid");
    end;
    u67:UpdateTouchGuiVisibility();
    if u67.humanoidSeatedConn then
        u67.humanoidSeatedConn:Disconnect();
        u67.humanoidSeatedConn = nil;
    end;
    u67.humanoidSeatedConn = u67.humanoid.Seated:Connect(function(p69, p70) --[[ Line: 513 ]]
        -- upvalues: u67 (copy)
        u67:OnHumanoidSeated(p69, p70);
    end);
end;
function u1.OnCharacterRemoving(p71, _) --[[ Line: 518 ]]
    p71.humanoid = nil;
    p71:UpdateTouchGuiVisibility();
end;
function u1.UpdateTouchGuiVisibility(p72) --[[ Line: 524 ]]
    -- upvalues: l__GuiService__4 (copy)
    if p72.touchGui then
        local l__humanoid__21 = p72.humanoid;
        if l__humanoid__21 then
            l__humanoid__21 = l__GuiService__4.TouchControlsEnabled;
        end;
        p72.touchGui.Enabled = l__humanoid__21 and true or false;
    end;
end;
function u1.SwitchToController(p73, p74) --[[ Line: 538 ]]
    -- upvalues: l__Value__15 (copy), l__ClickToMoveController__12 (copy), l__TouchThumbstick__11 (copy), l__DynamicThumbstick__10 (copy), l__TouchJump__13 (copy)
    if p74 then
        if not p73.controllers[p74] then
            p73.controllers[p74] = p74.new(l__Value__15);
        end;
        if p73.activeController ~= p73.controllers[p74] then
            if p73.activeController then
                p73.activeController:Enable(false);
            end;
            p73.activeController = p73.controllers[p74];
            p73.activeControlModule = p74;
            if p73.touchControlFrame and (p73.activeControlModule == l__ClickToMoveController__12 or (p73.activeControlModule == l__TouchThumbstick__11 or p73.activeControlModule == l__DynamicThumbstick__10)) then
                if not p73.controllers[l__TouchJump__13] then
                    p73.controllers[l__TouchJump__13] = l__TouchJump__13.new();
                end;
                p73.touchJumpController = p73.controllers[l__TouchJump__13];
                p73.touchJumpController:Enable(true, p73.touchControlFrame);
            elseif p73.touchJumpController then
                p73.touchJumpController:Enable(false);
            end;
            p73:UpdateActiveControlModuleEnabled();
        end;
    else
        if p73.activeController then
            p73.activeController:Enable(false);
        end;
        p73.activeController = nil;
        p73.activeControlModule = nil;
    end;
end;
function u1.OnLastInputTypeChanged(p75, p76) --[[ Line: 580 ]]
    -- upvalues: u7 (ref), u6 (copy)
    if u7 == p76 then
        warn("LastInputType Change listener called with current type.");
    end;
    u7 = p76;
    if u7 == Enum.UserInputType.Touch then
        local v77, v78 = p75:SelectTouchModule();
        if v78 then
            while not p75.touchControlFrame do
                wait();
            end;
            p75:SwitchToController(v77);
        end;
    elseif u6[u7] ~= nil then
        local v79 = p75:SelectComputerMovementModule();
        if v79 then
            p75:SwitchToController(v79);
        end;
    end;
    p75:UpdateTouchGuiVisibility();
end;
function u1.OnComputerMovementModeChange(p80) --[[ Line: 607 ]]
    local v81, v82 = p80:SelectComputerMovementModule();
    if v82 then
        p80:SwitchToController(v81);
    end;
end;
function u1.OnTouchMovementModeChange(p83) --[[ Line: 614 ]]
    local v84, v85 = p83:SelectTouchModule();
    if v85 then
        while not p83.touchControlFrame do
            wait();
        end;
        p83:SwitchToController(v84);
    end;
end;
function u1.CreateTouchGuiContainer(p86) --[[ Line: 624 ]]
    -- upvalues: u4 (ref)
    if p86.touchGui then
        p86.touchGui:Destroy();
    end;
    p86.touchGui = Instance.new("ScreenGui");
    p86.touchGui.Name = "TouchGui";
    p86.touchGui.ResetOnSpawn = false;
    p86.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    p86:UpdateTouchGuiVisibility();
    if u4 then
        p86.touchGui.ClipToDeviceSafeArea = false;
    end;
    p86.touchControlFrame = Instance.new("Frame");
    p86.touchControlFrame.Name = "TouchControlFrame";
    p86.touchControlFrame.Size = UDim2.new(1, 0, 1, 0);
    p86.touchControlFrame.BackgroundTransparency = 1;
    p86.touchControlFrame.Parent = p86.touchGui;
    p86.touchGui.Parent = p86.playerGui;
end;
function u1.GetClickToMoveController(p87) --[[ Line: 647 ]]
    -- upvalues: l__ClickToMoveController__12 (copy), l__Value__15 (copy)
    if not p87.controllers[l__ClickToMoveController__12] then
        p87.controllers[l__ClickToMoveController__12] = l__ClickToMoveController__12.new(l__Value__15);
    end;
    return p87.controllers[l__ClickToMoveController__12];
end;
return u1.new();