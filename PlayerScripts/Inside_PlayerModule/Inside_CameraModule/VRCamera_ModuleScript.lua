-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.VRCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__VRService__2 = game:GetService("VRService");
UserSettings():GetService("UserGameSettings");
require(script.Parent:WaitForChild("CameraInput"));
require(script.Parent:WaitForChild("CameraUtils"));
local l__VRBaseCamera__3 = require(script.Parent:WaitForChild("VRBaseCamera"));
local u1 = setmetatable({}, l__VRBaseCamera__3);
u1.__index = u1;
function u1.new() --[[ Line: 25 ]]
    -- upvalues: l__VRBaseCamera__3 (copy), u1 (copy)
    local v2 = l__VRBaseCamera__3.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.focusOffset = CFrame.new();
    v3:Reset();
    return v3;
end;
function u1.Reset(p4) --[[ Line: 35 ]]
    -- upvalues: l__VRBaseCamera__3 (copy)
    p4.needsReset = true;
    p4.needsBlackout = true;
    p4.motionDetTime = 0;
    p4.blackOutTimer = 0;
    p4.lastCameraResetPosition = nil;
    l__VRBaseCamera__3.Reset(p4);
end;
function u1.Update(p5, p6) --[[ Line: 44 ]]
    -- upvalues: l__Players__1 (copy), l__VRService__2 (copy)
    local l__CurrentCamera__4 = workspace.CurrentCamera;
    local l__CFrame__5 = l__CurrentCamera__4.CFrame;
    local l__Focus__6 = l__CurrentCamera__4.Focus;
    local l__LocalPlayer__7 = l__Players__1.LocalPlayer;
    p5:GetHumanoid();
    local _ = l__CurrentCamera__4.CameraSubject;
    if p5.lastUpdate == nil or p6 > 1 then
        p5.lastCameraTransform = nil;
    end;
    p5:UpdateFadeFromBlack(p6);
    p5:UpdateEdgeBlur(l__LocalPlayer__7, p6);
    local l__lastSubjectPosition__8 = p5.lastSubjectPosition;
    local v7 = p5:GetSubjectPosition();
    if p5.needsBlackout then
        p5:StartFadeFromBlack();
        local v8 = math.clamp(p6, 0.0001, 0.1);
        p5.blackOutTimer = p5.blackOutTimer + v8;
        if p5.blackOutTimer > 0.1 and game:IsLoaded() then
            p5.needsBlackout = false;
            p5.needsReset = true;
        end;
    end;
    if v7 and (l__LocalPlayer__7 and l__CurrentCamera__4) then
        local v9 = p5:GetVRFocus(v7, p6);
        if p5:IsInFirstPerson() then
            l__CFrame__5, l__Focus__6 = p5:UpdateFirstPersonTransform(p6, l__CFrame__5, v9, l__lastSubjectPosition__8, v7);
        elseif l__VRService__2.ThirdPersonFollowCamEnabled then
            l__CFrame__5, l__Focus__6 = p5:UpdateThirdPersonFollowTransform(p6, l__CFrame__5, v9, l__lastSubjectPosition__8, v7);
        else
            l__CFrame__5, l__Focus__6 = p5:UpdateThirdPersonComfortTransform(p6, l__CFrame__5, v9, l__lastSubjectPosition__8, v7);
        end;
        p5.lastCameraTransform = l__CFrame__5;
        p5.lastCameraFocus = l__Focus__6;
    end;
    p5.lastUpdate = tick();
    return l__CFrame__5, l__Focus__6;
end;
function u1.GetAvatarFeetWorldYValue(_) --[[ Line: 101 ]]
    local l__CameraSubject__9 = workspace.CurrentCamera.CameraSubject;
    if not l__CameraSubject__9 then
        return nil;
    end;
    if not (l__CameraSubject__9:IsA("Humanoid") and l__CameraSubject__9.RootPart) then
        return nil;
    end;
    local l__RootPart__10 = l__CameraSubject__9.RootPart;
    return l__RootPart__10.Position.Y - l__RootPart__10.Size.Y / 2 - l__CameraSubject__9.HipHeight;
end;
function u1.UpdateFirstPersonTransform(p10, p11, _, p12, p13, p14) --[[ Line: 116 ]]
    -- upvalues: l__Players__1 (copy)
    if p10.needsReset then
        p10:StartFadeFromBlack();
        p10.needsReset = false;
    end;
    local l__LocalPlayer__11 = l__Players__1.LocalPlayer;
    if (p13 - p14).magnitude > 0.01 then
        p10:StartVREdgeBlur(l__LocalPlayer__11);
    end;
    local l__p__12 = p12.p;
    local v15 = p10:GetCameraLookVector();
    local l__Unit__13 = Vector3.new(v15.X, 0, v15.Z).Unit;
    local v16 = p10:getRotation(p11);
    local v17 = p10:CalculateNewLookVectorFromArg(l__Unit__13, Vector2.new(v16, 0));
    return CFrame.new(l__p__12 - 0.5 * v17, l__p__12), p12;
end;
function u1.UpdateThirdPersonComfortTransform(p18, p19, p20, p21, p22, p23) --[[ Line: 142 ]]
    -- upvalues: l__Players__1 (copy), l__VRService__2 (copy)
    local v24 = p18:GetCameraToSubjectDistance();
    local v25 = v24 < 0.5 and 0.5 or v24;
    if p22 ~= nil and p18.lastCameraFocus ~= nil then
        local l__LocalPlayer__14 = l__Players__1.LocalPlayer;
        local v26 = p22 - p23;
        local v27 = require(l__LocalPlayer__14:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule")):GetMoveVector();
        local v28 = v26.magnitude > 0.01 and true or v27.magnitude > 0.01;
        if v28 then
            p18.motionDetTime = 0.1;
        end;
        p18.motionDetTime = p18.motionDetTime - p19;
        if (p18.motionDetTime > 0 and true or v28) and not p18.needsReset then
            local l__lastCameraFocus__15 = p18.lastCameraFocus;
            p18.VRCameraFocusFrozen = true;
            return p20, l__lastCameraFocus__15;
        end;
        local v29 = p18.lastCameraResetPosition == nil and true or (p23 - p18.lastCameraResetPosition).Magnitude > 1;
        local v30 = p18:getRotation(p19);
        if math.abs(v30) > 0 then
            local v31 = p21:ToObjectSpace(p20);
            p20 = p21 * CFrame.Angles(0, -v30, 0) * v31;
        end;
        if p18.VRCameraFocusFrozen and v29 or p18.needsReset then
            l__VRService__2:RecenterUserHeadCFrame();
            p18.VRCameraFocusFrozen = false;
            p18.needsReset = false;
            p18.lastCameraResetPosition = p23;
            p18:ResetZoom();
            p18:StartFadeFromBlack();
            local v32 = p18:GetHumanoid();
            local v33 = v32.Torso and v32.Torso.CFrame.lookVector or Vector3.new(1, 0, 0);
            local v34 = Vector3.new(v33.X, 0, v33.Z);
            local v35 = p21.Position - v34 * v25;
            local v36 = Vector3.new(p21.Position.X, v35.Y, p21.Position.Z);
            p20 = CFrame.new(v35, v36);
        end;
    end;
    return p20, p21;
end;
function u1.UpdateThirdPersonFollowTransform(p37, p38, _, _, p39, p40) --[[ Line: 209 ]]
    -- upvalues: l__VRService__2 (copy), l__Players__1 (copy)
    local l__CurrentCamera__16 = workspace.CurrentCamera;
    local v41 = p37:GetCameraToSubjectDistance();
    local v42 = p37:GetVRFocus(p40, p38);
    if p37.needsReset then
        p37.needsReset = false;
        l__VRService__2:RecenterUserHeadCFrame();
        p37:ResetZoom();
        p37:StartFadeFromBlack();
    end;
    if p37.recentered then
        local v43 = p37:GetSubjectCFrame();
        if not v43 then
            return l__CurrentCamera__16.CFrame, l__CurrentCamera__16.Focus;
        end;
        local v44 = v42 * v43.Rotation * CFrame.new(0, 0, v41);
        p37.focusOffset = v42:ToObjectSpace(v44);
        p37.recentered = false;
        return v44, v42;
    end;
    local v45 = v42:ToWorldSpace(p37.focusOffset);
    local l__LocalPlayer__17 = l__Players__1.LocalPlayer;
    local v46 = p39 - p40;
    local l__ControlModule__18 = require(l__LocalPlayer__17:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"));
    local v47 = l__ControlModule__18:GetMoveVector();
    if v46.magnitude > 0.01 or v47.magnitude > 0 then
        local v48 = l__ControlModule__18:GetEstimatedVRTorsoFrame();
        local v49 = l__CurrentCamera__16.CFrame * (v48.Rotation + v48.Position * l__CurrentCamera__16.HeadScale);
        local l__LookVector__19 = v49.LookVector;
        local v50 = Vector3.new(l__LookVector__19.X, 0, l__LookVector__19.Z).Unit * v41;
        v45 = v45:Lerp(CFrame.new(l__CurrentCamera__16.CFrame.Position + (v42.Position - v50) - v49.Position) * v45.Rotation, 0.01);
    end;
    local v51 = p37:getRotation(p38);
    if math.abs(v51) > 0 then
        local v52 = v42:ToObjectSpace(v45);
        v45 = v42 * CFrame.Angles(0, -v51, 0) * v52;
    end;
    p37.focusOffset = v42:ToObjectSpace(v45);
    local v53 = v45 * CFrame.new(0, 0, -v41);
    if (v53.Position - l__CurrentCamera__16.Focus.Position).Magnitude > 0.01 then
        p37:StartVREdgeBlur(l__Players__1.LocalPlayer);
    end;
    return v45, v53;
end;
function u1.LeaveFirstPerson(p54) --[[ Line: 287 ]]
    -- upvalues: l__VRBaseCamera__3 (copy)
    l__VRBaseCamera__3.LeaveFirstPerson(p54);
    p54.needsReset = true;
    if p54.VRBlur then
        p54.VRBlur.Visible = false;
    end;
end;
return u1;