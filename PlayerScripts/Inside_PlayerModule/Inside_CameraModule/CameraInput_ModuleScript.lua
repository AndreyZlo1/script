-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.CameraInput
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ContextActionService__1 = game:GetService("ContextActionService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__Players__3 = game:GetService("Players");
local l__RunService__4 = game:GetService("RunService");
local l__UserGameSettings__5 = UserSettings():GetService("UserGameSettings");
local l__VRService__6 = game:GetService("VRService");
game:GetService("StarterGui");
local l__LocalPlayer__7 = l__Players__3.LocalPlayer;
local l__Value__8 = Enum.ContextActionPriority.Medium.Value;
local u1 = Vector2.new(1, 0.77) * 0.008726646259971648;
local u2 = Vector2.new(1, 0.77) * 0.12217304763960307;
local u3 = Vector2.new(1, 0.66) * 0.017453292519943295;
local u4 = Vector2.new(1, 0.77) * 0.06981317007977318;
local v5, v6 = pcall(function() --[[ Line: 29 ]]
    return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen");
end);
local u7 = v5 and v6;
local u8 = Instance.new("BindableEvent");
local u9 = Instance.new("BindableEvent");
local l__Event__9 = u8.Event;
local l__Event__10 = u9.Event;
l__UserInputService__2.InputBegan:Connect(function(p10, p11) --[[ Line: 43 ]]
    -- upvalues: u8 (copy)
    if not p11 and p10.UserInputType == Enum.UserInputType.MouseButton2 then
        u8:Fire();
    end;
end);
l__UserInputService__2.InputEnded:Connect(function(p12, _) --[[ Line: 49 ]]
    -- upvalues: u9 (copy)
    if p12.UserInputType == Enum.UserInputType.MouseButton2 then
        u9:Fire();
    end;
end);
local function u16(p13) --[[ Line: 60 ]]
    local v14 = (math.abs(p13) - 0.1) / 0.9 * 2;
    local v15 = (math.exp(v14) - 1) / 6.38905609893065;
    return math.sign(p13) * math.clamp(v15, 0, 1);
end;
local function u20(p17) --[[ Line: 74 ]]
    local l__CurrentCamera__11 = workspace.CurrentCamera;
    if not l__CurrentCamera__11 then
        return p17;
    end;
    local v18 = l__CurrentCamera__11.CFrame:ToEulerAnglesYXZ();
    if p17.Y * v18 >= 0 then
        return p17;
    end;
    local v19 = (1 - (math.abs(v18) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25;
    return Vector2.new(1, v19) * p17;
end;
local function u26(p21) --[[ Line: 100 ]]
    -- upvalues: l__LocalPlayer__7 (copy)
    local v22 = l__LocalPlayer__7:FindFirstChildOfClass("PlayerGui");
    if v22 then
        v22 = v22:FindFirstChild("TouchGui");
    end;
    local v23;
    if v22 then
        v23 = v22:FindFirstChild("TouchControlFrame");
    else
        v23 = v22;
    end;
    if v23 then
        v23 = v23:FindFirstChild("DynamicThumbstickFrame");
    end;
    if not v23 then
        return false;
    end;
    if not v22.Enabled then
        return false;
    end;
    local l__AbsolutePosition__12 = v23.AbsolutePosition;
    local v24 = l__AbsolutePosition__12 + v23.AbsoluteSize;
    local v25;
    if p21.X >= l__AbsolutePosition__12.X and (p21.Y >= l__AbsolutePosition__12.Y and p21.X <= v24.X) then
        v25 = p21.Y <= v24.Y;
    else
        v25 = false;
    end;
    return v25;
end;
local u27 = 0.016666666666666666;
l__RunService__4.Stepped:Connect(function(_, p28) --[[ Line: 125 ]]
    -- upvalues: u27 (ref)
    u27 = p28;
end);
local v29 = {};
local u30 = {};
local u31 = 0;
local u32 = {
    Thumbstick2 = Vector2.new()
};
local u33 = {
    Left = 0,
    Right = 0,
    I = 0,
    O = 0
};
local u34 = {
    Wheel = 0,
    Pinch = 0,
    Movement = Vector2.new(),
    Pan = Vector2.new()
};
local u35 = {
    Pinch = 0,
    Move = Vector2.new()
};
local u36 = Instance.new("BindableEvent");
v29.gamepadZoomPress = u36.Event;
local u37 = l__VRService__6.VREnabled and Instance.new("BindableEvent") or nil;
if l__VRService__6.VREnabled then
    v29.gamepadReset = u37.Event;
end;
function v29.getRotationActivated() --[[ Line: 176 ]]
    -- upvalues: u31 (ref), u32 (copy)
    return u31 > 0 and true or u32.Thumbstick2.Magnitude > 0;
end;
function v29.getRotation(p38) --[[ Line: 180 ]]
    -- upvalues: l__UserGameSettings__5 (copy), u33 (copy), u27 (ref), u32 (copy), u34 (copy), u20 (copy), u35 (copy), u4 (copy), u1 (copy), u2 (copy), u3 (copy)
    local v39 = Vector2.new(1, l__UserGameSettings__5:GetCameraYInvertValue());
    local v40 = Vector2.new(u33.Right - u33.Left, 0) * u27;
    local l__Thumbstick2__13 = u32.Thumbstick2;
    local l__Movement__14 = u34.Movement;
    local l__Pan__15 = u34.Pan;
    local v41 = u20(u35.Move);
    if p38 then
        v40 = Vector2.new();
    end;
    return (v40 * 2.0943951023931953 + l__Thumbstick2__13 * u4 + l__Movement__14 * u1 + l__Pan__15 * u2 + v41 * u3) * v39;
end;
function v29.getZoomDelta() --[[ Line: 204 ]]
    -- upvalues: u33 (copy), u34 (copy), u35 (copy)
    return (u33.O - u33.I) * 0.1 + (-u34.Wheel + u34.Pinch) * 1 + -u35.Pinch * 0.04;
end;
local function u43(_, _, p42) --[[ Line: 212 ]]
    -- upvalues: u32 (copy), u16 (ref)
    local l__Position__16 = p42.Position;
    u32[p42.KeyCode.Name] = Vector2.new(u16(l__Position__16.X), -u16(l__Position__16.Y));
    return Enum.ContextActionResult.Pass;
end;
local function u46(_, p44, p45) --[[ Line: 228 ]]
    -- upvalues: u33 (copy)
    u33[p45.KeyCode.Name] = p44 == Enum.UserInputState.Begin and 1 or 0;
end;
local function u48(_, p47, _) --[[ Line: 232 ]]
    -- upvalues: u36 (copy)
    if p47 == Enum.UserInputState.Begin then
        u36:Fire();
    end;
end;
local function u50(_, p49, _) --[[ Line: 238 ]]
    -- upvalues: u37 (copy)
    if p49 == Enum.UserInputState.Begin then
        u37:Fire();
    end;
end;
local function u54() --[[ Line: 244 ]]
    -- upvalues: u32 (copy), u33 (copy), u34 (copy), u35 (copy)
    for _, v51 in pairs({
        u32,
        u33,
        u34,
        u35
    }) do
        for v52, v53 in pairs(v51) do
            if type(v53) == "boolean" then
                v51[v52] = false;
            else
                v51[v52] = v51[v52] * 0;
            end;
        end;
    end;
end;
local u55 = {};
local u56 = nil;
local u57 = nil;
local function u60(p58, p59) --[[ Line: 268 ]]
    -- upvalues: u56 (ref), u26 (copy), u31 (ref), u55 (ref)
    assert(p58.UserInputType == Enum.UserInputType.Touch);
    assert(p58.UserInputState == Enum.UserInputState.Begin);
    if u56 == nil and (u26(p58.Position) and not p59) then
        u56 = p58;
    else
        if not p59 then
            u31 = math.max(0, u31 + 1);
        end;
        u55[p58] = p59;
    end;
end;
local function u62(p61, _) --[[ Line: 288 ]]
    -- upvalues: u56 (ref), u55 (ref), u57 (ref), u31 (ref)
    assert(p61.UserInputType == Enum.UserInputType.Touch);
    assert(p61.UserInputState == Enum.UserInputState.End);
    if p61 == u56 then
        u56 = nil;
    end;
    if u55[p61] == false then
        u57 = nil;
        u31 = math.max(0, u31 - 1);
    end;
    u55[p61] = nil;
end;
local function u70(p63, p64) --[[ Line: 307 ]]
    -- upvalues: u56 (ref), u55 (ref), u35 (copy), u57 (ref)
    assert(p63.UserInputType == Enum.UserInputType.Touch);
    assert(p63.UserInputState == Enum.UserInputState.Change);
    if p63 == u56 then
    else
        if u55[p63] == nil then
            u55[p63] = p64;
        end;
        local v65 = {};
        for v66, v67 in pairs(u55) do
            if not v67 then
                table.insert(v65, v66);
            end;
        end;
        if #v65 == 1 and u55[p63] == false then
            local l__Delta__17 = p63.Delta;
            local v68 = u35;
            v68.Move = v68.Move + Vector2.new(l__Delta__17.X, l__Delta__17.Y);
        end;
        if #v65 == 2 then
            local l__Magnitude__18 = (v65[1].Position - v65[2].Position).Magnitude;
            if u57 then
                local v69 = u35;
                v69.Pinch = v69.Pinch + (l__Magnitude__18 - u57);
            end;
            u57 = l__Magnitude__18;
        else
            u57 = nil;
        end;
    end;
end;
local function u71() --[[ Line: 351 ]]
    -- upvalues: u55 (ref), u56 (ref), u57 (ref), u7 (ref), u31 (ref)
    u55 = {};
    u56 = nil;
    u57 = nil;
    if u7 then
        u31 = 0;
    end;
end;
local function u76(p72, p73, p74, p75) --[[ Line: 361 ]]
    -- upvalues: u34 (copy)
    if not p75 then
        u34.Wheel = p72;
        u34.Pan = p73;
        u34.Pinch = -p74;
    end;
end;
local function u79(p77, p78) --[[ Line: 369 ]]
    -- upvalues: u60 (ref), u31 (ref)
    if p77.UserInputType == Enum.UserInputType.Touch then
        u60(p77, p78);
    else
        if p77.UserInputType == Enum.UserInputType.MouseButton2 and not p78 then
            u31 = math.max(0, u31 + 1);
        end;
    end;
end;
local function u82(p80, p81) --[[ Line: 378 ]]
    -- upvalues: u70 (ref), u34 (copy)
    if p80.UserInputType == Enum.UserInputType.Touch then
        u70(p80, p81);
    else
        if p80.UserInputType == Enum.UserInputType.MouseMovement then
            local l__Delta__19 = p80.Delta;
            u34.Movement = Vector2.new(l__Delta__19.X, l__Delta__19.Y);
        end;
    end;
end;
local function u85(p83, p84) --[[ Line: 387 ]]
    -- upvalues: u62 (ref), u31 (ref)
    if p83.UserInputType == Enum.UserInputType.Touch then
        u62(p83, p84);
    else
        if p83.UserInputType == Enum.UserInputType.MouseButton2 then
            u31 = math.max(0, u31 - 1);
        end;
    end;
end;
local u86 = false;
function v29.setInputEnabled(p87) --[[ Line: 398 ]]
    -- upvalues: u86 (ref), u54 (copy), u71 (ref), l__ContextActionService__1 (copy), u43 (copy), l__Value__8 (copy), u46 (copy), l__VRService__6 (copy), u50 (copy), u48 (copy), u30 (ref), l__UserInputService__2 (copy), u79 (copy), u82 (copy), u85 (copy), u76 (copy), u7 (ref)
    if u86 == p87 then
    else
        u86 = p87;
        u54();
        u71();
        if u86 then
            l__ContextActionService__1:BindActionAtPriority("RbxCameraThumbstick", u43, false, l__Value__8, Enum.KeyCode.Thumbstick2);
            l__ContextActionService__1:BindActionAtPriority("RbxCameraKeypress", u46, false, l__Value__8, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.I, Enum.KeyCode.O);
            if l__VRService__6.VREnabled then
                l__ContextActionService__1:BindAction("RbxCameraGamepadReset", u50, false, Enum.KeyCode.ButtonL3);
            end;
            l__ContextActionService__1:BindAction("RbxCameraGamepadZoom", u48, false, Enum.KeyCode.ButtonR3);
            table.insert(u30, l__UserInputService__2.InputBegan:Connect(u79));
            table.insert(u30, l__UserInputService__2.InputChanged:Connect(u82));
            table.insert(u30, l__UserInputService__2.InputEnded:Connect(u85));
            table.insert(u30, l__UserInputService__2.PointerAction:Connect(u76));
            if u7 then
                local v88 = u30;
                local l__MenuOpened__20 = game:GetService("GuiService").MenuOpened;
                table.insert(v88, l__MenuOpened__20:connect(u71));
            end;
        else
            l__ContextActionService__1:UnbindAction("RbxCameraThumbstick");
            l__ContextActionService__1:UnbindAction("RbxCameraMouseMove");
            l__ContextActionService__1:UnbindAction("RbxCameraMouseWheel");
            l__ContextActionService__1:UnbindAction("RbxCameraKeypress");
            l__ContextActionService__1:UnbindAction("RbxCameraGamepadZoom");
            if l__VRService__6.VREnabled then
                l__ContextActionService__1:UnbindAction("RbxCameraGamepadReset");
            end;
            for _, v89 in pairs(u30) do
                v89:Disconnect();
            end;
            u30 = {};
        end;
    end;
end;
function v29.getInputEnabled() --[[ Line: 470 ]]
    -- upvalues: u86 (ref)
    return u86;
end;
function v29.resetInputForFrameEnd() --[[ Line: 474 ]]
    -- upvalues: u34 (copy), u35 (copy)
    u34.Movement = Vector2.new();
    u35.Move = Vector2.new();
    u35.Pinch = 0;
    u34.Wheel = 0;
    u34.Pan = Vector2.new();
    u34.Pinch = 0;
end;
l__UserInputService__2.WindowFocused:Connect(u54);
l__UserInputService__2.WindowFocusReleased:Connect(u54);
local u90 = false;
local u91 = false;
local u92 = 0;
function v29.getHoldPan() --[[ Line: 495 ]]
    -- upvalues: u90 (ref)
    return u90;
end;
function v29.getTogglePan() --[[ Line: 499 ]]
    -- upvalues: u91 (ref)
    return u91;
end;
function v29.getPanning() --[[ Line: 503 ]]
    -- upvalues: u91 (ref), u90 (ref)
    return u91 or u90;
end;
function v29.setTogglePan(p93) --[[ Line: 507 ]]
    -- upvalues: u91 (ref)
    u91 = p93;
end;
local u94 = false;
local u95 = nil;
local u96 = nil;
function v29.enableCameraToggleInput() --[[ Line: 515 ]]
    -- upvalues: u94 (ref), u90 (ref), u91 (ref), u95 (ref), u96 (ref), l__Event__9 (ref), u92 (ref), l__Event__10 (ref), l__UserInputService__2 (copy)
    if u94 then
    else
        u94 = true;
        u90 = false;
        u91 = false;
        if u95 then
            u95:Disconnect();
        end;
        if u96 then
            u96:Disconnect();
        end;
        u95 = l__Event__9:Connect(function() --[[ Line: 532 ]]
            -- upvalues: u90 (ref), u92 (ref)
            u90 = true;
            u92 = tick();
        end);
        u96 = l__Event__10:Connect(function() --[[ Line: 537 ]]
            -- upvalues: u90 (ref), u92 (ref), u91 (ref), l__UserInputService__2 (ref)
            u90 = false;
            if tick() - u92 < 0.3 and (u91 or l__UserInputService__2:GetMouseDelta().Magnitude < 2) then
                u91 = not u91;
            end;
        end);
    end;
end;
function v29.disableCameraToggleInput() --[[ Line: 545 ]]
    -- upvalues: u94 (ref), u95 (ref), u96 (ref)
    if u94 then
        u94 = false;
        if u95 then
            u95:Disconnect();
            u95 = nil;
        end;
        if u96 then
            u96:Disconnect();
            u96 = nil;
        end;
    end;
end;
return v29;