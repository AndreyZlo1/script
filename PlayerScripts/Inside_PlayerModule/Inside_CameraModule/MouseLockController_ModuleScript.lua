-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.MouseLockController
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Value__1 = Enum.ContextActionPriority.Medium.Value;
local l__Players__2 = game:GetService("Players");
local l__ContextActionService__3 = game:GetService("ContextActionService");
local l__GameSettings__4 = UserSettings().GameSettings;
local l__CameraUtils__5 = require(script.Parent:WaitForChild("CameraUtils"));
local u1 = {};
u1.__index = u1;
function u1.new() --[[ Line: 26 ]]
    -- upvalues: u1 (copy), l__GameSettings__4 (copy), l__Players__2 (copy)
    local u2 = setmetatable({}, u1);
    u2.isMouseLocked = false;
    u2.savedMouseCursor = nil;
    u2.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift };
    u2.mouseLockToggledEvent = Instance.new("BindableEvent");
    local v3 = script:FindFirstChild("BoundKeys");
    if not (v3 and v3:IsA("StringValue")) then
        if v3 then
            v3:Destroy();
        end;
        v3 = Instance.new("StringValue");
        assert(v3, "");
        v3.Name = "BoundKeys";
        v3.Value = "LeftShift,RightShift";
        v3.Parent = script;
    end;
    if v3 then
        v3.Changed:Connect(function(p4) --[[ Line: 51 ]]
            -- upvalues: u2 (copy)
            u2:OnBoundKeysObjectChanged(p4);
        end);
        u2:OnBoundKeysObjectChanged(v3.Value);
    end;
    l__GameSettings__4.Changed:Connect(function(p5) --[[ Line: 58 ]]
        -- upvalues: u2 (copy)
        if p5 == "ControlMode" or p5 == "ComputerMovementMode" then
            u2:UpdateMouseLockAvailability();
        end;
    end);
    l__Players__2.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() --[[ Line: 65 ]]
        -- upvalues: u2 (copy)
        u2:UpdateMouseLockAvailability();
    end);
    l__Players__2.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() --[[ Line: 70 ]]
        -- upvalues: u2 (copy)
        u2:UpdateMouseLockAvailability();
    end);
    u2:UpdateMouseLockAvailability();
    return u2;
end;
function u1.GetIsMouseLocked(p6) --[[ Line: 79 ]]
    return p6.isMouseLocked;
end;
function u1.GetBindableToggleEvent(p7) --[[ Line: 83 ]]
    return p7.mouseLockToggledEvent.Event;
end;
function u1.GetMouseLockOffset(_) --[[ Line: 87 ]]
    local v8 = script:FindFirstChild("CameraOffset");
    if v8 and v8:IsA("Vector3Value") then
        return v8.Value;
    end;
    if v8 then
        v8:Destroy();
    end;
    local v9 = Instance.new("Vector3Value");
    assert(v9, "");
    v9.Name = "CameraOffset";
    v9.Value = Vector3.new(1.75, 0, 0);
    v9.Parent = script;
    return not (v9 and v9.Value) and Vector3.new(1.75, 0, 0) or v9.Value;
end;
function u1.UpdateMouseLockAvailability(p10) --[[ Line: 110 ]]
    -- upvalues: l__Players__2 (copy), l__GameSettings__4 (copy)
    local l__DevEnableMouseLock__6 = l__Players__2.LocalPlayer.DevEnableMouseLock;
    local v11 = l__Players__2.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable;
    local v12 = l__DevEnableMouseLock__6 and (l__GameSettings__4.ControlMode == Enum.ControlMode.MouseLockSwitch and l__GameSettings__4.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove);
    if v12 then
        v12 = not v11;
    end;
    if v12 ~= p10.enabled then
        p10:EnableMouseLock(v12);
    end;
end;
function u1.OnBoundKeysObjectChanged(p13, p14) --[[ Line: 122 ]]
    p13.boundKeys = {};
    for v15 in string.gmatch(p14, "[^%s,]+") do
        for _, v16 in pairs(Enum.KeyCode:GetEnumItems()) do
            if v15 == v16.Name then
                p13.boundKeys[#p13.boundKeys + 1] = v16;
                break;
            end;
        end;
    end;
    p13:UnbindContextActions();
    p13:BindContextActions();
end;
function u1.OnMouseLockToggled(p17) --[[ Line: 137 ]]
    -- upvalues: l__CameraUtils__5 (copy)
    p17.isMouseLocked = not p17.isMouseLocked;
    if p17.isMouseLocked then
        local v18 = script:FindFirstChild("CursorImage");
        if v18 and (v18:IsA("StringValue") and v18.Value) then
            l__CameraUtils__5.setMouseIconOverride(v18.Value);
        else
            if v18 then
                v18:Destroy();
            end;
            local v19 = Instance.new("StringValue");
            assert(v19, "");
            v19.Name = "CursorImage";
            v19.Value = "rbxasset://textures/MouseLockedCursor.png";
            v19.Parent = script;
            l__CameraUtils__5.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png");
        end;
    else
        l__CameraUtils__5.restoreMouseIcon();
    end;
    p17.mouseLockToggledEvent:Fire();
end;
function u1.DoMouseLockSwitch(p20, _, p21, _) --[[ Line: 162 ]]
    if p21 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;
    p20:OnMouseLockToggled();
    return Enum.ContextActionResult.Sink;
end;
function u1.BindContextActions(u22) --[[ Line: 170 ]]
    -- upvalues: l__ContextActionService__3 (copy), l__Value__1 (copy)
    l__ContextActionService__3:BindActionAtPriority("MouseLockSwitchAction", function(p23, p24, p25) --[[ Line: 171 ]]
        -- upvalues: u22 (copy)
        return u22:DoMouseLockSwitch(p23, p24, p25);
    end, false, l__Value__1, unpack(u22.boundKeys));
end;
function u1.UnbindContextActions(_) --[[ Line: 176 ]]
    -- upvalues: l__ContextActionService__3 (copy)
    l__ContextActionService__3:UnbindAction("MouseLockSwitchAction");
end;
function u1.IsMouseLocked(p26) --[[ Line: 180 ]]
    local l__enabled__7 = p26.enabled;
    if l__enabled__7 then
        l__enabled__7 = p26.isMouseLocked;
    end;
    return l__enabled__7;
end;
function u1.EnableMouseLock(p27, p28) --[[ Line: 184 ]]
    -- upvalues: l__CameraUtils__5 (copy)
    if p28 ~= p27.enabled then
        p27.enabled = p28;
        if p27.enabled then
            p27:BindContextActions();
            return;
        end;
        l__CameraUtils__5.restoreMouseIcon();
        p27:UnbindContextActions();
        if p27.isMouseLocked then
            p27.mouseLockToggledEvent:Fire();
        end;
        p27.isMouseLocked = false;
    end;
end;
return u1;