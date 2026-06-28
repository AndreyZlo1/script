-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.ClassicCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

Vector2.new(0, 0);
local u1 = 0;
local u2 = CFrame.fromOrientation(-0.2617993877991494, 0, 0);
local l__Players__1 = game:GetService("Players");
local l__VRService__2 = game:GetService("VRService");
local l__CameraInput__3 = require(script.Parent:WaitForChild("CameraInput"));
local l__CameraUtils__4 = require(script.Parent:WaitForChild("CameraUtils"));
local l__BaseCamera__5 = require(script.Parent:WaitForChild("BaseCamera"));
local u3 = setmetatable({}, l__BaseCamera__5);
u3.__index = u3;
function u3.new() --[[ Line: 35 ]]
    -- upvalues: l__BaseCamera__5 (copy), u3 (copy), l__CameraUtils__4 (copy)
    local v4 = l__BaseCamera__5.new();
    local v5 = setmetatable(v4, u3);
    v5.isFollowCamera = false;
    v5.isCameraToggle = false;
    v5.lastUpdate = tick();
    v5.cameraToggleSpring = l__CameraUtils__4.Spring.new(5, 0);
    return v5;
end;
function u3.GetCameraToggleOffset(p6, p7) --[[ Line: 46 ]]
    -- upvalues: l__CameraInput__3 (copy), l__CameraUtils__4 (copy)
    if not p6.isCameraToggle then
        return Vector3.new();
    end;
    local l__currentSubjectDistance__6 = p6.currentSubjectDistance;
    if l__CameraInput__3.getTogglePan() then
        local l__cameraToggleSpring__7 = p6.cameraToggleSpring;
        local v8 = l__CameraUtils__4.map(l__currentSubjectDistance__6, 0.5, p6.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1);
        l__cameraToggleSpring__7.goal = math.clamp(v8, 0, 1);
    else
        p6.cameraToggleSpring.goal = 0;
    end;
    local v9 = l__CameraUtils__4.map(l__currentSubjectDistance__6, 0.5, 64, 0, 1);
    local v10 = math.clamp(v9, 0, 1) + 1;
    local v11 = p6.cameraToggleSpring:step(p7) * v10;
    return Vector3.new(0, v11, 0);
end;
function u3.SetCameraMovementMode(p12, p13) --[[ Line: 64 ]]
    -- upvalues: l__BaseCamera__5 (copy)
    l__BaseCamera__5.SetCameraMovementMode(p12, p13);
    p12.isFollowCamera = p13 == Enum.ComputerCameraMovementMode.Follow;
    p12.isCameraToggle = p13 == Enum.ComputerCameraMovementMode.CameraToggle;
end;
function u3.Update(p14) --[[ Line: 71 ]]
    -- upvalues: u2 (copy), l__Players__1 (copy), l__CameraInput__3 (copy), u1 (ref), l__CameraUtils__4 (copy), l__VRService__2 (copy)
    local v15 = tick();
    local v16 = v15 - p14.lastUpdate;
    local l__CurrentCamera__8 = workspace.CurrentCamera;
    local l__CFrame__9 = l__CurrentCamera__8.CFrame;
    local l__Focus__10 = l__CurrentCamera__8.Focus;
    local v17;
    if p14.resetCameraAngle then
        local v18 = p14:GetHumanoidRootPart();
        if v18 then
            v17 = (v18.CFrame * u2).lookVector;
        else
            v17 = u2.lookVector;
        end;
        p14.resetCameraAngle = false;
    else
        v17 = nil;
    end;
    local l__LocalPlayer__11 = l__Players__1.LocalPlayer;
    local v19 = p14:GetHumanoid();
    local l__CameraSubject__12 = l__CurrentCamera__8.CameraSubject;
    local v20;
    if l__CameraSubject__12 then
        v20 = l__CameraSubject__12:IsA("VehicleSeat");
    else
        v20 = l__CameraSubject__12;
    end;
    local v21;
    if l__CameraSubject__12 then
        v21 = l__CameraSubject__12:IsA("SkateboardPlatform");
    else
        v21 = l__CameraSubject__12;
    end;
    local v22;
    if v19 then
        v22 = v19:GetState() == Enum.HumanoidStateType.Climbing;
    else
        v22 = v19;
    end;
    if p14.lastUpdate == nil or v16 > 1 then
        p14.lastCameraTransform = nil;
    end;
    local v23 = l__CameraInput__3.getRotation();
    p14:StepZoom();
    local v24 = p14:GetCameraHeight();
    if l__CameraInput__3.getRotation() ~= Vector2.new() then
        u1 = 0;
        p14.lastUserPanCamera = tick();
    end;
    local v25 = v15 - p14.lastUserPanCamera < 2;
    local v26 = p14:GetSubjectPosition();
    if v26 and (l__LocalPlayer__11 and l__CurrentCamera__8) then
        local v27 = p14:GetCameraToSubjectDistance();
        local v28 = v27 < 0.5 and 0.5 or v27;
        if p14:GetIsMouseLocked() and not p14:IsInFirstPerson() then
            local v29 = p14:CalculateNewLookCFrameFromArg(v17, v23);
            local v30 = p14:GetMouseLockOffset();
            local v31 = v30.X * v29.RightVector + v30.Y * v29.UpVector + v30.Z * v29.LookVector;
            if l__CameraUtils__4.IsFiniteVector3(v31) then
                v26 = v26 + v31;
            end;
        elseif l__CameraInput__3.getRotation() == Vector2.new() and p14.lastCameraTransform then
            local v32 = p14:IsInFirstPerson();
            if (v20 or (v21 or p14.isFollowCamera and v22)) and (p14.lastUpdate and (v19 and v19.Torso)) then
                if v32 then
                    if p14.lastSubjectCFrame and (v20 or v21) and l__CameraSubject__12:IsA("BasePart") then
                        local v33 = -l__CameraUtils__4.GetAngleBetweenXZVectors(p14.lastSubjectCFrame.lookVector, l__CameraSubject__12.CFrame.lookVector);
                        if l__CameraUtils__4.IsFinite(v33) then
                            v23 = v23 + Vector2.new(v33, 0);
                        end;
                        u1 = 0;
                    end;
                elseif not v25 then
                    local l__lookVector__13 = v19.Torso.CFrame.lookVector;
                    u1 = math.clamp(u1 + 3.839724354387525 * v16, 0, 4.363323129985824);
                    local v34 = math.clamp(u1 * v16, 0, 1);
                    local v35 = p14:IsInFirstPerson() and not (p14.isFollowCamera and p14.isClimbing) and 1 or v34;
                    local v36 = l__CameraUtils__4.GetAngleBetweenXZVectors(l__lookVector__13, p14:GetCameraLookVector());
                    if l__CameraUtils__4.IsFinite(v36) and math.abs(v36) > 0.0001 then
                        v23 = v23 + Vector2.new(v36 * v35, 0);
                    end;
                end;
            elseif p14.isFollowCamera and not (v32 or (v25 or l__VRService__2.VREnabled)) then
                local v37 = l__CameraUtils__4.GetAngleBetweenXZVectors(-(p14.lastCameraTransform.p - v26), p14:GetCameraLookVector());
                if l__CameraUtils__4.IsFinite(v37) and (math.abs(v37) > 0.0001 and math.abs(v37) > 0.4 * v16) then
                    v23 = v23 + Vector2.new(v37, 0);
                end;
            end;
        end;
        local v38;
        if p14.isFollowCamera then
            local v39 = p14:CalculateNewLookVectorFromArg(v17, v23);
            if l__VRService__2.VREnabled then
                v38 = p14:GetVRFocus(v26, v16);
            else
                v38 = CFrame.new(v26);
            end;
            l__CFrame__9 = CFrame.new(v38.p - v28 * v39, v38.p) + Vector3.new(0, v24, 0);
        else
            local l__VREnabled__14 = l__VRService__2.VREnabled;
            if l__VREnabled__14 then
                v38 = p14:GetVRFocus(v26, v16);
            else
                v38 = CFrame.new(v26);
            end;
            local l__p__15 = v38.p;
            if l__VREnabled__14 and not p14:IsInFirstPerson() then
                local l__magnitude__16 = (v26 - l__CurrentCamera__8.CFrame.p).magnitude;
                if v28 < l__magnitude__16 or v23.x ~= 0 then
                    local v40 = math.min(l__magnitude__16, v28);
                    local v41 = p14:CalculateNewLookVectorFromArg(nil, v23) * v40;
                    local v42 = l__p__15 - v41;
                    local l__lookVector__17 = l__CurrentCamera__8.CFrame.lookVector;
                    if v23.x == 0 then
                        v41 = l__lookVector__17;
                    end;
                    local v43 = Vector3.new(v42.x + v41.x, v42.y, v42.z + v41.z);
                    l__CFrame__9 = CFrame.new(v42, v43) + Vector3.new(0, v24, 0);
                end;
            else
                local v44 = p14:CalculateNewLookVectorFromArg(v17, v23);
                l__CFrame__9 = CFrame.new(l__p__15 - v28 * v44, l__p__15);
            end;
        end;
        local v45 = p14:GetCameraToggleOffset(v16);
        l__Focus__10 = v38 + v45;
        l__CFrame__9 = l__CFrame__9 + v45;
        p14.lastCameraTransform = l__CFrame__9;
        p14.lastCameraFocus = l__Focus__10;
        if (v20 or v21) and l__CameraSubject__12:IsA("BasePart") then
            p14.lastSubjectCFrame = l__CameraSubject__12.CFrame;
        else
            p14.lastSubjectCFrame = nil;
        end;
    end;
    p14.lastUpdate = v15;
    return l__CFrame__9, l__Focus__10;
end;
return u3;