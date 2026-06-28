-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1, v2 = pcall(function() --[[ Line: 9 ]]
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2");
end);
local u3 = v1 and v2;
local u4 = { 0, 30 };
local l__UserGameSettings__1 = UserSettings():GetService("UserGameSettings");
local l__VRBaseCamera__2 = require(script.Parent:WaitForChild("VRBaseCamera"));
local l__CameraInput__3 = require(script.Parent:WaitForChild("CameraInput"));
local l__CameraUtils__4 = require(script.Parent:WaitForChild("CameraUtils"));
require(script.Parent:WaitForChild("VehicleCamera"));
local u5 = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"));
local u6 = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"));
local l__Players__5 = game:GetService("Players");
local l__RunService__6 = game:GetService("RunService");
local l__VRService__7 = game:GetService("VRService");
local l__LocalPlayer__8 = l__Players__5.LocalPlayer;
local l__Spring__9 = l__CameraUtils__4.Spring;
local l__mapClamp__10 = l__CameraUtils__4.mapClamp;
local l__sanitizeAngle__11 = l__CameraUtils__4.sanitizeAngle;
local u7 = 0.016666666666666666;
local u8 = setmetatable({}, l__VRBaseCamera__2);
u8.__index = u8;
function u8.new() --[[ Line: 59 ]]
    -- upvalues: l__VRBaseCamera__2 (copy), u8 (copy), l__RunService__6 (copy), u7 (ref)
    local v9 = l__VRBaseCamera__2.new();
    local v10 = setmetatable(v9, u8);
    v10:Reset();
    l__RunService__6.Stepped:Connect(function(_, p11) --[[ Line: 64 ]]
        -- upvalues: u7 (ref)
        u7 = p11;
    end);
    return v10;
end;
function u8.Reset(p12) --[[ Line: 72 ]]
    -- upvalues: u5 (copy), u3 (ref), l__Spring__9 (copy), u6 (copy), l__CameraUtils__4 (copy), u4 (copy)
    p12.vehicleCameraCore = u5.new(p12:GetSubjectCFrame());
    if u3 then
        p12.pitchSpring = l__Spring__9.new(0, 0);
    else
        p12.pitchSpring = l__Spring__9.new(0, -math.rad(u6.pitchBaseAngle));
    end;
    p12.yawSpring = l__Spring__9.new(0, 0);
    if u3 then
        p12.lastPanTick = 0;
        p12.currentDriftAngle = 0;
        p12.needsReset = true;
    end;
    local l__CurrentCamera__12 = workspace.CurrentCamera;
    local v13;
    if l__CurrentCamera__12 then
        v13 = l__CurrentCamera__12.CameraSubject;
    else
        v13 = l__CurrentCamera__12;
    end;
    assert(l__CurrentCamera__12, "VRVehicleCamera initialization error");
    assert(v13);
    assert(v13:IsA("VehicleSeat"));
    local v14 = v13:GetConnectedParts(true);
    local v15, v16 = l__CameraUtils__4.getLooseBoundingSphere(v14);
    p12.assemblyRadius = math.max(v16, 5);
    p12.assemblyOffset = v13.CFrame:Inverse() * v15;
    p12.gamepadZoomLevels = {};
    for _, v17 in u4 do
        table.insert(p12.gamepadZoomLevels, v17 * p12.headScale * p12.assemblyRadius / 10);
    end;
    p12.lastCameraFocus = nil;
    p12:SetCameraToSubjectDistance(p12.gamepadZoomLevels[#p12.gamepadZoomLevels]);
end;
function u8._StepRotation(p18, p19, p20) --[[ Line: 112 ]]
    -- upvalues: l__sanitizeAngle__11 (copy), l__CameraInput__3 (copy), u6 (copy), l__mapClamp__10 (copy)
    local l__yawSpring__13 = p18.yawSpring;
    local l__pitchSpring__14 = p18.pitchSpring;
    local v21 = -p18:getRotation(p19);
    l__yawSpring__13.pos = l__sanitizeAngle__11(l__yawSpring__13.pos + v21);
    l__pitchSpring__14.pos = l__sanitizeAngle__11((math.clamp(l__pitchSpring__14.pos, -1.3962634015954636, 1.3962634015954636)));
    if l__CameraInput__3.getRotationActivated() then
        p18.lastPanTick = os.clock();
    end;
    local v22 = math.rad(u6.pitchDeadzoneAngle);
    if os.clock() - p18.lastPanTick > u6.autocorrectDelay then
        local v23 = l__mapClamp__10(p20, u6.autocorrectMinCarSpeed, u6.autocorrectMaxCarSpeed, 0, u6.autocorrectResponse);
        l__yawSpring__13.freq = v23;
        l__pitchSpring__14.freq = v23;
        if l__yawSpring__13.freq < 0.001 then
            l__yawSpring__13.vel = 0;
        end;
        if l__pitchSpring__14.freq < 0.001 then
            l__pitchSpring__14.vel = 0;
        end;
        local v24 = l__sanitizeAngle__11(0 - l__pitchSpring__14.pos);
        if math.abs(v24) <= v22 then
            l__pitchSpring__14.goal = l__pitchSpring__14.pos;
        else
            l__pitchSpring__14.goal = 0;
        end;
    else
        l__yawSpring__13.freq = 0;
        l__yawSpring__13.vel = 0;
        l__pitchSpring__14.freq = 0;
        l__pitchSpring__14.vel = 0;
        l__pitchSpring__14.goal = 0;
    end;
    return CFrame.fromEulerAnglesYXZ(l__pitchSpring__14:step(p19), l__yawSpring__13:step(p19), 0);
end;
function u8._GetThirdPersonLocalOffset(p25) --[[ Line: 176 ]]
    -- upvalues: u6 (copy)
    return p25.assemblyOffset + Vector3.new(0, p25.assemblyRadius * u6.verticalCenterOffset, 0);
end;
function u8._GetFirstPersonLocalOffset(p26, p27) --[[ Line: 180 ]]
    -- upvalues: l__LocalPlayer__8 (copy)
    local l__Character__15 = l__LocalPlayer__8.Character;
    if l__Character__15 and l__Character__15.Parent then
        local v28 = l__Character__15:FindFirstChild("Head");
        if v28 and v28:IsA("BasePart") then
            return p27:Inverse() * v28.Position;
        end;
    end;
    return p26:_GetThirdPersonLocalOffset();
end;
function u8.Update(p29) --[[ Line: 194 ]]
    -- upvalues: u3 (ref), u7 (ref), l__LocalPlayer__8 (copy), l__VRService__7 (copy)
    if u3 then
        local v30 = u7;
        u7 = 0;
        p29:UpdateFadeFromBlack(v30);
        p29:UpdateEdgeBlur(l__LocalPlayer__8, v30);
        if l__VRService__7.ThirdPersonFollowCamEnabled then
            local v31, v32 = p29:UpdateStepRotation(v30);
            return v31, v32;
        else
            local v33, v34 = p29:UpdateComfortCamera(v30);
            return v33, v34;
        end;
    else
        return p29:UpdateComfortCamera();
    end;
end;
function u8.addDrift(p35, p36, p37) --[[ Line: 217 ]]
    -- upvalues: l__LocalPlayer__8 (copy), l__VRService__7 (copy)
    local l__CurrentCamera__16 = workspace.CurrentCamera;
    local v38 = p35:GetCameraToSubjectDistance();
    local v39 = p35:GetSubjectVelocity();
    local v40 = p35:GetSubjectCFrame();
    require(l__LocalPlayer__8:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"));
    if v39.Magnitude > 0.1 then
        local v41 = l__VRService__7:GetUserCFrame(Enum.UserCFrame.Head);
        local v42 = l__CurrentCamera__16.CFrame * (v41.Rotation + v41.Position * l__CurrentCamera__16.HeadScale);
        local _, v43, _ = v42:ToEulerAnglesYXZ();
        local _, v44, _ = v40:ToEulerAnglesYXZ();
        local v45 = (v43 - p35.currentDriftAngle + 12.566370614359172) % 6.283185307179586;
        if v45 > 3.141592653589793 then
            v45 = v45 - 6.283185307179586;
        end;
        local v46 = (v44 - p35.currentDriftAngle + 12.566370614359172) % 6.283185307179586;
        if v46 > 3.141592653589793 then
            v46 = v46 - 6.283185307179586;
        end;
        local v47 = math.min(v46, v45);
        local v48 = math.max(v46, v45);
        local v49 = 0;
        if v47 > 0 then
            v48 = v47;
        elseif v48 >= 0 then
            v48 = v49;
        end;
        p35.currentDriftAngle = v48 + p35.currentDriftAngle;
        local l__LookVector__17 = CFrame.fromEulerAnglesYXZ(0, p35.currentDriftAngle, 0).LookVector;
        local v50 = Vector3.new(l__LookVector__17.X, 0, l__LookVector__17.Z).Unit * v38;
        p36 = p36:Lerp(CFrame.new(l__CurrentCamera__16.CFrame.Position + (p37.Position - v50) - v42.Position) * l__CurrentCamera__16.CFrame.Rotation, 0.01);
    end;
    return p36, p37;
end;
function u8.UpdateRotationCamera(p51, p52) --[[ Line: 275 ]]
    -- upvalues: l__mapClamp__10 (copy), l__LocalPlayer__8 (copy)
    local l__CurrentCamera__18 = workspace.CurrentCamera;
    local v53;
    if l__CurrentCamera__18 then
        v53 = l__CurrentCamera__18.CameraSubject;
    else
        v53 = l__CurrentCamera__18;
    end;
    local l__vehicleCameraCore__19 = p51.vehicleCameraCore;
    assert(l__CurrentCamera__18);
    assert(v53);
    assert(v53:IsA("VehicleSeat"));
    local v54 = p51:GetSubjectCFrame();
    local v55 = p51:GetSubjectVelocity();
    local v56 = p51:GetSubjectRotVelocity();
    local v57 = v55:Dot(v54.ZVector);
    local v58 = math.abs(v57);
    local v59 = v54.YVector:Dot(v56);
    local v60 = math.abs(v59);
    local v61 = v54.XVector:Dot(v56);
    local v62 = math.abs(v61);
    local v63 = p51:GetCameraToSubjectDistance();
    local v64 = l__mapClamp__10(v63, 0.5, p51.assemblyRadius, 1, 0);
    local v65 = p51:_GetThirdPersonLocalOffset():Lerp(p51:_GetFirstPersonLocalOffset(v54), v64);
    l__vehicleCameraCore__19:setTransform(v54);
    local v66 = l__vehicleCameraCore__19:step(p52, v62, v60, v64);
    local v67 = p51:_StepRotation(p52, v58);
    local v68 = p51:GetVRFocus(v54 * v65, p52) * v66 * v67;
    local v69 = v68 * CFrame.new(0, 0, v63);
    if v55.Magnitude > 0.1 then
        p51:StartVREdgeBlur(l__LocalPlayer__8);
    end;
    return v69, v68;
end;
function u8.UpdateStepRotation(p70, p71) --[[ Line: 322 ]]
    -- upvalues: l__mapClamp__10 (copy), l__UserGameSettings__1 (copy), l__VRService__7 (copy), l__LocalPlayer__8 (copy)
    local l__CurrentCamera__20 = workspace.CurrentCamera;
    local l__lastSubjectCFrame__21 = p70.lastSubjectCFrame;
    local v72 = p70:GetSubjectCFrame();
    local v73 = p70:GetSubjectVelocity();
    local v74 = p70:GetCameraToSubjectDistance();
    local v75 = l__mapClamp__10(v74, 0.5, p70.assemblyRadius, 1, 0);
    local v76 = p70:_GetThirdPersonLocalOffset():Lerp(p70:_GetFirstPersonLocalOffset(v72), v75);
    local v77 = p70:GetVRFocus(v72 * v76, p71);
    local v78, v79 = p70:addDrift(v77:ToWorldSpace(p70:GetVRFocus(l__lastSubjectCFrame__21 * v76, p71):ToObjectSpace(l__CurrentCamera__20.CFrame)), v77);
    local v80 = p70:getRotation(p71);
    local v81;
    if math.abs(v80) > 0 then
        local v82 = v79:ToObjectSpace(v78);
        v81 = v79 * CFrame.Angles(0, -v80, 0) * v82;
        if not l__UserGameSettings__1.VRSmoothRotationEnabled then
            local v83 = l__VRService__7:GetUserCFrame(Enum.UserCFrame.Head);
            local v84 = v83.Rotation + v83.Position * l__CurrentCamera__20.HeadScale;
            local v85 = v79 * v72.Rotation;
            local v86 = v85:ToObjectSpace(v78 * v84);
            local v87 = Vector3.new(v86.X, 0, v86.Z).Unit:Dot(Vector3.new(0, 0, 1));
            local v88 = math.acos(v87);
            local v89 = v85:ToObjectSpace(v81 * v84);
            local v90 = Vector3.new(v89.X, 0, v89.Z).Unit:Dot(Vector3.new(0, 0, 1));
            if math.acos(v90) < v88 then
                if v80 < 0 then
                    v88 = v88 * -1;
                end;
                v81 = v79 * CFrame.Angles(0, -v88, 0) * v82;
            end;
        end;
    else
        v81 = v78;
    end;
    if v73.Magnitude > 0.1 then
        p70:StartVREdgeBlur(l__LocalPlayer__8);
    end;
    if p70.needsReset then
        p70.needsReset = false;
        l__VRService__7:RecenterUserHeadCFrame();
        p70:StartFadeFromBlack();
        p70:ResetZoom();
    end;
    if p70.recentered then
        v81 = v79 * v72.Rotation * CFrame.new(0, 0, v74);
        p70.recentered = false;
    end;
    return v81, v81 * CFrame.new(0, 0, -v74);
end;
function u8.UpdateComfortCamera(p91, p92) --[[ Line: 408 ]]
    -- upvalues: u3 (ref), u7 (ref), l__mapClamp__10 (copy), l__LocalPlayer__8 (copy)
    local l__CurrentCamera__22 = workspace.CurrentCamera;
    local v93;
    if l__CurrentCamera__22 then
        v93 = l__CurrentCamera__22.CameraSubject;
    else
        v93 = l__CurrentCamera__22;
    end;
    local l__vehicleCameraCore__23 = p91.vehicleCameraCore;
    assert(l__CurrentCamera__22);
    assert(v93);
    assert(v93:IsA("VehicleSeat"));
    if not u3 then
        p92 = u7;
        u7 = 0;
    end;
    local v94 = p91:GetSubjectCFrame();
    local v95 = p91:GetSubjectVelocity();
    local v96 = p91:GetSubjectRotVelocity();
    local v97 = v95:Dot(v94.ZVector);
    math.abs(v97);
    local v98 = v94.YVector:Dot(v96);
    local v99 = math.abs(v98);
    local v100 = v94.XVector:Dot(v96);
    local v101 = math.abs(v100);
    local v102 = p91:StepZoom();
    local v103 = l__mapClamp__10(v102, 0.5, p91.assemblyRadius, 1, 0);
    local v104 = p91:_GetThirdPersonLocalOffset():Lerp(p91:_GetFirstPersonLocalOffset(v94), v103);
    l__vehicleCameraCore__23:setTransform(v94);
    local v105 = l__vehicleCameraCore__23:step(p92, v101, v99, v103);
    if not u3 then
        p91:UpdateFadeFromBlack(p92);
    end;
    local v106, v107;
    if p91:IsInFirstPerson() then
        local l__Unit__24 = Vector3.new(v105.LookVector.X, 0, v105.LookVector.Z).Unit;
        local v108 = CFrame.new(v105.Position, l__Unit__24);
        v106 = CFrame.new(v94 * v104) * v108;
        v107 = v106 * CFrame.new(0, 0, v102);
        if u3 then
            if v95.Magnitude > 0.1 then
                p91:StartVREdgeBlur(l__LocalPlayer__8);
            end;
        else
            p91:StartVREdgeBlur(l__LocalPlayer__8);
        end;
    else
        v106 = CFrame.new(v94 * v104) * v105;
        v107 = v106 * CFrame.new(0, 0, v102);
        if not p91.lastCameraFocus then
            p91.lastCameraFocus = v106;
            p91.needsReset = true;
        end;
        local v109 = v106.Position - l__CurrentCamera__22.CFrame.Position;
        local l__magnitude__25 = v109.magnitude;
        if v109.Unit:Dot(l__CurrentCamera__22.CFrame.LookVector) > 0.56 and (l__magnitude__25 < 200 and not p91.needsReset) then
            v106 = p91.lastCameraFocus;
            local l__p__26 = v106.p;
            local v110 = p91:GetCameraLookVector();
            local v111 = p91:CalculateNewLookVectorFromArg(Vector3.new(v110.X, 0, v110.Z).Unit, Vector2.new(0, 0));
            v107 = CFrame.new(l__p__26 - v102 * v111, l__p__26);
        else
            p91.lastCameraFocus = p91:GetVRFocus(v94.Position, p92);
            p91.needsReset = false;
            p91:StartFadeFromBlack();
            p91:ResetZoom();
        end;
        if not u3 then
            p91:UpdateEdgeBlur(l__LocalPlayer__8, p92);
        end;
    end;
    return v107, v106;
end;
return u8;