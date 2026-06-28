-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule.Gamepad
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__UserInputService__1 = game:GetService("UserInputService");
local l__ContextActionService__2 = game:GetService("ContextActionService");
local l__None__3 = Enum.UserInputType.None;
local l__BaseCharacterController__4 = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, l__BaseCharacterController__4);
u1.__index = u1;
function u1.new(p2) --[[ Line: 21 ]]
    -- upvalues: l__BaseCharacterController__4 (copy), u1 (copy), l__None__3 (copy)
    local v3 = l__BaseCharacterController__4.new();
    local v4 = setmetatable(v3, u1);
    v4.CONTROL_ACTION_PRIORITY = p2;
    v4.forwardValue = 0;
    v4.backwardValue = 0;
    v4.leftValue = 0;
    v4.rightValue = 0;
    v4.activeGamepad = l__None__3;
    v4.gamepadConnectedConn = nil;
    v4.gamepadDisconnectedConn = nil;
    return v4;
end;
function u1.Enable(p5, p6) --[[ Line: 37 ]]
    -- upvalues: l__UserInputService__1 (copy), l__None__3 (copy)
    if not l__UserInputService__1.GamepadEnabled then
        return false;
    end;
    if p6 == p5.enabled then
        return true;
    end;
    p5.forwardValue = 0;
    p5.backwardValue = 0;
    p5.leftValue = 0;
    p5.rightValue = 0;
    p5.moveVector = Vector3.new(0, 0, 0);
    p5.isJumping = false;
    if p6 then
        p5.activeGamepad = p5:GetHighestPriorityGamepad();
        if p5.activeGamepad == l__None__3 then
            return false;
        end;
        p5:BindContextActions();
        p5:ConnectGamepadConnectionListeners();
    else
        p5:UnbindContextActions();
        p5:DisconnectGamepadConnectionListeners();
        p5.activeGamepad = l__None__3;
    end;
    p5.enabled = p6;
    return true;
end;
function u1.GetHighestPriorityGamepad(_) --[[ Line: 77 ]]
    -- upvalues: l__UserInputService__1 (copy), l__None__3 (copy)
    local v7 = l__UserInputService__1:GetConnectedGamepads();
    local v8 = l__None__3;
    for _, v9 in pairs(v7) do
        if v9.Value < v8.Value then
            v8 = v9;
        end;
    end;
    return v8;
end;
function u1.BindContextActions(u10) --[[ Line: 88 ]]
    -- upvalues: l__None__3 (copy), l__ContextActionService__2 (copy)
    if u10.activeGamepad == l__None__3 then
        return false;
    end;
    l__ContextActionService__2:BindActivate(u10.activeGamepad, Enum.KeyCode.ButtonR2);
    l__ContextActionService__2:BindActionAtPriority("jumpAction", function(_, p11, _) --[[ Line: 95 ]]
        -- upvalues: u10 (copy)
        u10.isJumping = p11 == Enum.UserInputState.Begin;
        return Enum.ContextActionResult.Sink;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA);
    l__ContextActionService__2:BindActionAtPriority("moveThumbstick", function(_, p12, p13) --[[ Line: 100 ]]
        -- upvalues: u10 (copy)
        if p12 == Enum.UserInputState.Cancel then
            u10.moveVector = Vector3.new(0, 0, 0);
            return Enum.ContextActionResult.Sink;
        end;
        if u10.activeGamepad ~= p13.UserInputType then
            return Enum.ContextActionResult.Pass;
        end;
        if p13.KeyCode == Enum.KeyCode.Thumbstick1 then
            if p13.Position.magnitude > 0.2 then
                u10.moveVector = Vector3.new(p13.Position.X, 0, -p13.Position.Y);
            else
                u10.moveVector = Vector3.new(0, 0, 0);
            end;
            return Enum.ContextActionResult.Sink;
        end;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1);
    return true;
end;
function u1.UnbindContextActions(p14) --[[ Line: 129 ]]
    -- upvalues: l__None__3 (copy), l__ContextActionService__2 (copy)
    if p14.activeGamepad ~= l__None__3 then
        l__ContextActionService__2:UnbindActivate(p14.activeGamepad, Enum.KeyCode.ButtonR2);
    end;
    l__ContextActionService__2:UnbindAction("moveThumbstick");
    l__ContextActionService__2:UnbindAction("jumpAction");
end;
function u1.OnNewGamepadConnected(p15) --[[ Line: 137 ]]
    -- upvalues: l__None__3 (copy)
    local v16 = p15:GetHighestPriorityGamepad();
    if v16 == p15.activeGamepad then
    elseif v16 == l__None__3 then
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads");
        p15:UnbindContextActions();
    else
        if p15.activeGamepad ~= l__None__3 then
            p15:UnbindContextActions();
        end;
        p15.activeGamepad = v16;
        p15:BindContextActions();
    end;
end;
function u1.OnCurrentGamepadDisconnected(p17) --[[ Line: 164 ]]
    -- upvalues: l__None__3 (copy), l__ContextActionService__2 (copy)
    if p17.activeGamepad ~= l__None__3 then
        l__ContextActionService__2:UnbindActivate(p17.activeGamepad, Enum.KeyCode.ButtonR2);
    end;
    local v18 = p17:GetHighestPriorityGamepad();
    if p17.activeGamepad == l__None__3 or v18 ~= p17.activeGamepad then
        if v18 == l__None__3 then
            p17:UnbindContextActions();
            p17.activeGamepad = l__None__3;
        else
            p17.activeGamepad = v18;
            l__ContextActionService__2:BindActivate(p17.activeGamepad, Enum.KeyCode.ButtonR2);
        end;
    else
        warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.");
        p17:UnbindContextActions();
        p17.activeGamepad = l__None__3;
    end;
end;
function u1.ConnectGamepadConnectionListeners(u19) --[[ Line: 189 ]]
    -- upvalues: l__UserInputService__1 (copy)
    u19.gamepadConnectedConn = l__UserInputService__1.GamepadConnected:Connect(function(_) --[[ Line: 190 ]]
        -- upvalues: u19 (copy)
        u19:OnNewGamepadConnected();
    end);
    u19.gamepadDisconnectedConn = l__UserInputService__1.GamepadDisconnected:Connect(function(p20) --[[ Line: 194 ]]
        -- upvalues: u19 (copy)
        if u19.activeGamepad == p20 then
            u19:OnCurrentGamepadDisconnected();
        end;
    end);
end;
function u1.DisconnectGamepadConnectionListeners(p21) --[[ Line: 202 ]]
    if p21.gamepadConnectedConn then
        p21.gamepadConnectedConn:Disconnect();
        p21.gamepadConnectedConn = nil;
    end;
    if p21.gamepadDisconnectedConn then
        p21.gamepadDisconnectedConn:Disconnect();
        p21.gamepadDisconnectedConn = nil;
    end;
end;
return u1;