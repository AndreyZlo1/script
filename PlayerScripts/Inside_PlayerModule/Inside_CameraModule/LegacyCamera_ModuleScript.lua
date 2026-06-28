-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.LegacyCamera
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

Vector2.new();
require(script.Parent:WaitForChild("CameraUtils"));
local l__CameraInput__1 = require(script.Parent:WaitForChild("CameraInput"));
local l__Players__2 = game:GetService("Players");
local l__BaseCamera__3 = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, l__BaseCamera__3);
u1.__index = u1;
function u1.new() --[[ Line: 21 ]]
    -- upvalues: l__BaseCamera__3 (copy), u1 (copy)
    local v2 = l__BaseCamera__3.new();
    local v3 = setmetatable(v2, u1);
    v3.cameraType = Enum.CameraType.Fixed;
    v3.lastUpdate = tick();
    v3.lastDistanceToSubject = nil;
    return v3;
end;
function u1.GetModuleName(_) --[[ Line: 31 ]]
    return "LegacyCamera";
end;
function u1.SetCameraToSubjectDistance(p4, p5) --[[ Line: 36 ]]
    -- upvalues: l__BaseCamera__3 (copy)
    return l__BaseCamera__3.SetCameraToSubjectDistance(p4, p5);
end;
function u1.Update(p6, _) --[[ Line: 40 ]]
    -- upvalues: l__Players__2 (copy), l__CameraInput__1 (copy)
    if not p6.cameraType then
        return nil, nil;
    end;
    local v7 = tick();
    local v8 = v7 - p6.lastUpdate;
    local l__CurrentCamera__4 = workspace.CurrentCamera;
    local l__CFrame__5 = l__CurrentCamera__4.CFrame;
    local l__Focus__6 = l__CurrentCamera__4.Focus;
    local l__LocalPlayer__7 = l__Players__2.LocalPlayer;
    if p6.lastUpdate == nil or v8 > 1 then
        p6.lastDistanceToSubject = nil;
    end;
    local v9 = p6:GetSubjectPosition();
    if p6.cameraType == Enum.CameraType.Fixed then
        if v9 and (l__LocalPlayer__7 and l__CurrentCamera__4) then
            local v10 = p6:GetCameraToSubjectDistance();
            local v11 = p6:CalculateNewLookVectorFromArg(nil, l__CameraInput__1.getRotation());
            l__Focus__6 = l__CurrentCamera__4.Focus;
            l__CFrame__5 = CFrame.new(l__CurrentCamera__4.CFrame.p, l__CurrentCamera__4.CFrame.p + v10 * v11);
        end;
    elseif p6.cameraType == Enum.CameraType.Attach then
        local v12 = p6:GetSubjectCFrame();
        local v13 = l__CurrentCamera__4.CFrame:ToEulerAnglesYXZ();
        local _, v14 = v12:ToEulerAnglesYXZ();
        local v15 = v13 - l__CameraInput__1.getRotation().Y;
        local v16 = math.clamp(v15, -1.3962634015954636, 1.3962634015954636);
        l__Focus__6 = CFrame.new(v12.p) * CFrame.fromEulerAnglesYXZ(v16, v14, 0);
        l__CFrame__5 = l__Focus__6 * CFrame.new(0, 0, p6:StepZoom());
    else
        if p6.cameraType ~= Enum.CameraType.Watch then
            return l__CurrentCamera__4.CFrame, l__CurrentCamera__4.Focus;
        end;
        if v9 and (l__LocalPlayer__7 and l__CurrentCamera__4) then
            local v17 = nil;
            if v9 == l__CurrentCamera__4.CFrame.p then
                warn("Camera cannot watch subject in same position as itself");
                return l__CurrentCamera__4.CFrame, l__CurrentCamera__4.Focus;
            end;
            local v18 = p6:GetHumanoid();
            if v18 and v18.RootPart then
                local v19 = v9 - l__CurrentCamera__4.CFrame.p;
                v17 = v19.unit;
                if p6.lastDistanceToSubject and p6.lastDistanceToSubject == p6:GetCameraToSubjectDistance() then
                    p6:SetCameraToSubjectDistance(v19.magnitude);
                end;
            end;
            local v20 = p6:GetCameraToSubjectDistance();
            local v21 = p6:CalculateNewLookVectorFromArg(v17, l__CameraInput__1.getRotation());
            l__Focus__6 = CFrame.new(v9);
            l__CFrame__5 = CFrame.new(v9 - v20 * v21, v9);
            p6.lastDistanceToSubject = v20;
        end;
    end;
    p6.lastUpdate = v7;
    return l__CFrame__5, l__Focus__6;
end;
return u1;