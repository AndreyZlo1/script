-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__CameraUtils__1 = require(script.Parent:WaitForChild("CameraUtils"));
local l__CameraInput__2 = require(script.Parent:WaitForChild("CameraInput"));
local l__Players__3 = game:GetService("Players");
local l__VRService__4 = game:GetService("VRService");
local l__BaseCamera__5 = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, l__BaseCamera__5);
u1.__index = u1;
function u1.new() --[[ Line: 43 ]]
    -- upvalues: l__BaseCamera__5 (copy), u1 (copy)
    local v2 = l__BaseCamera__5.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.changedSignalConnections = {};
    v3.refAzimuthRad = nil;
    v3.curAzimuthRad = nil;
    v3.minAzimuthAbsoluteRad = nil;
    v3.maxAzimuthAbsoluteRad = nil;
    v3.useAzimuthLimits = nil;
    v3.curElevationRad = nil;
    v3.minElevationRad = nil;
    v3.maxElevationRad = nil;
    v3.curDistance = nil;
    v3.minDistance = nil;
    v3.maxDistance = nil;
    v3.gamepadDollySpeedMultiplier = 1;
    v3.lastUserPanCamera = tick();
    v3.externalProperties = {};
    v3.externalProperties.InitialDistance = 25;
    v3.externalProperties.MinDistance = 10;
    v3.externalProperties.MaxDistance = 100;
    v3.externalProperties.InitialElevation = 35;
    v3.externalProperties.MinElevation = 35;
    v3.externalProperties.MaxElevation = 35;
    v3.externalProperties.ReferenceAzimuth = -45;
    v3.externalProperties.CWAzimuthTravel = 90;
    v3.externalProperties.CCWAzimuthTravel = 90;
    v3.externalProperties.UseAzimuthLimits = false;
    v3:LoadNumberValueParameters();
    return v3;
end;
function u1.LoadOrCreateNumberValueParameter(u4, u5, p6, u7) --[[ Line: 82 ]]
    local v8 = script:FindFirstChild(u5);
    if v8 and v8:isA(p6) then
        u4.externalProperties[u5] = v8.Value;
    else
        if u4.externalProperties[u5] == nil then
            return;
        end;
        v8 = Instance.new(p6);
        v8.Name = u5;
        v8.Parent = script;
        v8.Value = u4.externalProperties[u5];
    end;
    if u7 then
        if u4.changedSignalConnections[u5] then
            u4.changedSignalConnections[u5]:Disconnect();
        end;
        u4.changedSignalConnections[u5] = v8.Changed:Connect(function(p9) --[[ Line: 102 ]]
            -- upvalues: u4 (copy), u5 (copy), u7 (copy)
            u4.externalProperties[u5] = p9;
            u7(u4);
        end);
    end;
end;
function u1.SetAndBoundsCheckAzimuthValues(p10) --[[ Line: 109 ]]
    local v11 = math.rad(p10.externalProperties.ReferenceAzimuth);
    local v12 = math.rad(p10.externalProperties.CWAzimuthTravel);
    p10.minAzimuthAbsoluteRad = v11 - math.abs(v12);
    local v13 = math.rad(p10.externalProperties.ReferenceAzimuth);
    local v14 = math.rad(p10.externalProperties.CCWAzimuthTravel);
    p10.maxAzimuthAbsoluteRad = v13 + math.abs(v14);
    p10.useAzimuthLimits = p10.externalProperties.UseAzimuthLimits;
    if p10.useAzimuthLimits then
        p10.curAzimuthRad = math.max(p10.curAzimuthRad, p10.minAzimuthAbsoluteRad);
        p10.curAzimuthRad = math.min(p10.curAzimuthRad, p10.maxAzimuthAbsoluteRad);
    end;
end;
function u1.SetAndBoundsCheckElevationValues(p15) --[[ Line: 119 ]]
    local v16 = math.max(p15.externalProperties.MinElevation, -80);
    local v17 = math.min(p15.externalProperties.MaxElevation, 80);
    local v18 = math.min(v16, v17);
    p15.minElevationRad = math.rad(v18);
    local v19 = math.max(v16, v17);
    p15.maxElevationRad = math.rad(v19);
    p15.curElevationRad = math.max(p15.curElevationRad, p15.minElevationRad);
    p15.curElevationRad = math.min(p15.curElevationRad, p15.maxElevationRad);
end;
function u1.SetAndBoundsCheckDistanceValues(p20) --[[ Line: 135 ]]
    p20.minDistance = p20.externalProperties.MinDistance;
    p20.maxDistance = p20.externalProperties.MaxDistance;
    p20.curDistance = math.max(p20.curDistance, p20.minDistance);
    p20.curDistance = math.min(p20.curDistance, p20.maxDistance);
end;
function u1.LoadNumberValueParameters(p21) --[[ Line: 143 ]]
    p21:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil);
    p21:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil);
    p21:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", p21.SetAndBoundsCheckAzimuthValue);
    p21:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", p21.SetAndBoundsCheckAzimuthValues);
    p21:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", p21.SetAndBoundsCheckAzimuthValues);
    p21:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", p21.SetAndBoundsCheckElevationValues);
    p21:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", p21.SetAndBoundsCheckElevationValues);
    p21:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", p21.SetAndBoundsCheckDistanceValues);
    p21:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", p21.SetAndBoundsCheckDistanceValues);
    p21:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", p21.SetAndBoundsCheckAzimuthValues);
    p21.curAzimuthRad = math.rad(p21.externalProperties.ReferenceAzimuth);
    p21.curElevationRad = math.rad(p21.externalProperties.InitialElevation);
    p21.curDistance = p21.externalProperties.InitialDistance;
    p21:SetAndBoundsCheckAzimuthValues();
    p21:SetAndBoundsCheckElevationValues();
    p21:SetAndBoundsCheckDistanceValues();
end;
function u1.GetModuleName(_) --[[ Line: 168 ]]
    return "OrbitalCamera";
end;
function u1.SetInitialOrientation(p22, p23) --[[ Line: 172 ]]
    -- upvalues: l__CameraUtils__1 (copy)
    if p23 and p23.RootPart then
        assert(p23.RootPart, "");
        local l__Unit__6 = (p23.RootPart.CFrame.LookVector - Vector3.new(0, 0.23, 0)).Unit;
        local v24 = l__CameraUtils__1.GetAngleBetweenXZVectors(l__Unit__6, p22:GetCameraLookVector());
        local l__Y__7 = p22:GetCameraLookVector().Y;
        local v25 = math.asin(l__Y__7) - math.asin(l__Unit__6.Y);
        l__CameraUtils__1.IsFinite(v24);
        l__CameraUtils__1.IsFinite(v25);
    else
        warn("OrbitalCamera could not set initial orientation due to missing humanoid");
    end;
end;
function u1.GetCameraToSubjectDistance(p26) --[[ Line: 190 ]]
    return p26.curDistance;
end;
function u1.SetCameraToSubjectDistance(p27, p28) --[[ Line: 194 ]]
    -- upvalues: l__Players__3 (copy)
    if l__Players__3.LocalPlayer then
        p27.currentSubjectDistance = math.clamp(p28, p27.minDistance, p27.maxDistance);
        p27.currentSubjectDistance = math.max(p27.currentSubjectDistance, p27.FIRST_PERSON_DISTANCE_THRESHOLD);
    end;
    p27.inFirstPerson = false;
    p27:UpdateMouseBehavior();
    return p27.currentSubjectDistance;
end;
function u1.CalculateNewLookVector(p29, p30, p31) --[[ Line: 207 ]]
    local v32 = p30 or p29:GetCameraLookVector();
    local v33 = math.asin(v32.Y);
    local v34 = math.clamp(p31.Y, v33 - 1.3962634015954636, v33 - -1.3962634015954636);
    local v35 = Vector2.new(p31.X, v34);
    local v36 = CFrame.new(Vector3.new(0, 0, 0), v32);
    return (CFrame.Angles(0, -v35.X, 0) * v36 * CFrame.Angles(-v35.Y, 0, 0)).LookVector;
end;
function u1.Update(p37, _) --[[ Line: 218 ]]
    -- upvalues: l__CameraInput__2 (copy), l__Players__3 (copy), l__VRService__4 (copy)
    local v38 = tick();
    local v39 = v38 - p37.lastUpdate;
    local v40 = l__CameraInput__2.getRotation() ~= Vector2.new();
    local l__CurrentCamera__8 = workspace.CurrentCamera;
    local l__CFrame__9 = l__CurrentCamera__8.CFrame;
    local l__Focus__10 = l__CurrentCamera__8.Focus;
    local l__LocalPlayer__11 = l__Players__3.LocalPlayer;
    local v41;
    if l__CurrentCamera__8 then
        v41 = l__CurrentCamera__8.CameraSubject;
    else
        v41 = l__CurrentCamera__8;
    end;
    local v42;
    if v41 then
        v42 = v41:IsA("VehicleSeat");
    else
        v42 = v41;
    end;
    local v43;
    if v41 then
        v43 = v41:IsA("SkateboardPlatform");
    else
        v43 = v41;
    end;
    if p37.lastUpdate == nil or v39 > 1 then
        p37.lastCameraTransform = nil;
    end;
    if v40 then
        p37.lastUserPanCamera = tick();
    end;
    local v44 = p37:GetSubjectPosition();
    if v44 and (l__LocalPlayer__11 and l__CurrentCamera__8) then
        if p37.gamepadDollySpeedMultiplier ~= 1 then
            p37:SetCameraToSubjectDistance(p37.currentSubjectDistance * p37.gamepadDollySpeedMultiplier);
        end;
        local l__VREnabled__12 = l__VRService__4.VREnabled;
        l__Focus__10 = l__VREnabled__12 and p37:GetVRFocus(v44, v39) or CFrame.new(v44);
        local v45 = l__CameraInput__2.getRotation();
        local l__p__13 = l__Focus__10.p;
        if l__VREnabled__12 and not p37:IsInFirstPerson() then
            local v46 = p37:GetCameraHeight();
            local v47 = v44 - l__CurrentCamera__8.CFrame.p;
            local l__Magnitude__14 = v47.Magnitude;
            if p37.currentSubjectDistance < l__Magnitude__14 or v45.X ~= 0 then
                local v48 = math.min(l__Magnitude__14, p37.currentSubjectDistance);
                local v49 = p37:CalculateNewLookVector(v47.Unit * Vector3.new(1, 0, 1), Vector2.new(v45.X, 0)) * v48;
                local v50 = l__p__13 - v49;
                local l__LookVector__15 = l__CurrentCamera__8.CFrame.LookVector;
                if v45.X == 0 then
                    v49 = l__LookVector__15;
                end;
                local v51 = Vector3.new(v50.X + v49.X, v50.Y, v50.Z + v49.Z);
                l__CFrame__9 = CFrame.new(v50, v51) + Vector3.new(0, v46, 0);
            end;
        else
            p37.curAzimuthRad = p37.curAzimuthRad - v45.X;
            if p37.useAzimuthLimits then
                p37.curAzimuthRad = math.clamp(p37.curAzimuthRad, p37.minAzimuthAbsoluteRad, p37.maxAzimuthAbsoluteRad);
            else
                p37.curAzimuthRad = p37.curAzimuthRad == 0 and 0 or (math.sign(p37.curAzimuthRad) * (math.abs(p37.curAzimuthRad) % 6.283185307179586) or 0);
            end;
            p37.curElevationRad = math.clamp(p37.curElevationRad + v45.Y, p37.minElevationRad, p37.maxElevationRad);
            local v52 = v44 + p37.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(-p37.curElevationRad, p37.curAzimuthRad, 0) * Vector3.new(0, 0, 1));
            l__CFrame__9 = CFrame.new(v52, v44);
        end;
        p37.lastCameraTransform = l__CFrame__9;
        p37.lastCameraFocus = l__Focus__10;
        if (v42 or v43) and v41:IsA("BasePart") then
            p37.lastSubjectCFrame = v41.CFrame;
        else
            p37.lastSubjectCFrame = nil;
        end;
    end;
    p37.lastUpdate = v38;
    return l__CFrame__9, l__Focus__10;
end;
return u1;