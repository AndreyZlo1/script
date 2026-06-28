-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule.Keyboard
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__UserInputService__1 = game:GetService("UserInputService");
local l__ContextActionService__2 = game:GetService("ContextActionService");
local l__BaseCharacterController__3 = require(script.Parent:WaitForChild("BaseCharacterController"));
local u1 = setmetatable({}, l__BaseCharacterController__3);
u1.__index = u1;
function u1.new(p2) --[[ Line: 20 ]]
    -- upvalues: l__BaseCharacterController__3 (copy), u1 (copy)
    local v3 = l__BaseCharacterController__3.new();
    local v4 = setmetatable(v3, u1);
    v4.CONTROL_ACTION_PRIORITY = p2;
    v4.textFocusReleasedConn = nil;
    v4.textFocusGainedConn = nil;
    v4.windowFocusReleasedConn = nil;
    v4.forwardValue = 0;
    v4.backwardValue = 0;
    v4.leftValue = 0;
    v4.rightValue = 0;
    v4.jumpEnabled = true;
    return v4;
end;
function u1.Enable(p5, p6) --[[ Line: 39 ]]
    -- upvalues: l__UserInputService__1 (copy)
    if not l__UserInputService__1.KeyboardEnabled then
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
    p5.jumpRequested = false;
    p5:UpdateJump();
    if p6 then
        p5:BindContextActions();
        p5:ConnectFocusEventListeners();
    else
        p5:UnbindContextActions();
        p5:DisconnectFocusEventListeners();
    end;
    p5.enabled = p6;
    return true;
end;
function u1.UpdateMovement(p7, p8) --[[ Line: 71 ]]
    if p8 == Enum.UserInputState.Cancel then
        p7.moveVector = Vector3.new(0, 0, 0);
    else
        p7.moveVector = Vector3.new(p7.leftValue + p7.rightValue, 0, p7.forwardValue + p7.backwardValue);
    end;
end;
function u1.UpdateJump(p9) --[[ Line: 79 ]]
    p9.isJumping = p9.jumpRequested;
end;
function u1.BindContextActions(u10) --[[ Line: 83 ]]
    -- upvalues: l__ContextActionService__2 (copy)
    l__ContextActionService__2:BindActionAtPriority("moveForwardAction", function(_, p11, _) --[[ Line: 89 ]]
        -- upvalues: u10 (copy)
        u10.forwardValue = p11 == Enum.UserInputState.Begin and -1 or 0;
        u10:UpdateMovement(p11);
        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward);
    l__ContextActionService__2:BindActionAtPriority("moveBackwardAction", function(_, p12, _) --[[ Line: 95 ]]
        -- upvalues: u10 (copy)
        u10.backwardValue = p12 == Enum.UserInputState.Begin and 1 or 0;
        u10:UpdateMovement(p12);
        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward);
    l__ContextActionService__2:BindActionAtPriority("moveLeftAction", function(_, p13, _) --[[ Line: 101 ]]
        -- upvalues: u10 (copy)
        u10.leftValue = p13 == Enum.UserInputState.Begin and -1 or 0;
        u10:UpdateMovement(p13);
        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft);
    l__ContextActionService__2:BindActionAtPriority("moveRightAction", function(_, p14, _) --[[ Line: 107 ]]
        -- upvalues: u10 (copy)
        u10.rightValue = p14 == Enum.UserInputState.Begin and 1 or 0;
        u10:UpdateMovement(p14);
        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight);
    l__ContextActionService__2:BindActionAtPriority("jumpAction", function(_, p15, _) --[[ Line: 113 ]]
        -- upvalues: u10 (copy)
        local v16 = u10;
        local l__jumpEnabled__4 = u10.jumpEnabled;
        if l__jumpEnabled__4 then
            l__jumpEnabled__4 = p15 == Enum.UserInputState.Begin;
        end;
        v16.jumpRequested = l__jumpEnabled__4;
        u10:UpdateJump();
        return Enum.ContextActionResult.Pass;
    end, false, u10.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump);
end;
function u1.UnbindContextActions(_) --[[ Line: 133 ]]
    -- upvalues: l__ContextActionService__2 (copy)
    l__ContextActionService__2:UnbindAction("moveForwardAction");
    l__ContextActionService__2:UnbindAction("moveBackwardAction");
    l__ContextActionService__2:UnbindAction("moveLeftAction");
    l__ContextActionService__2:UnbindAction("moveRightAction");
    l__ContextActionService__2:UnbindAction("jumpAction");
end;
function u1.ConnectFocusEventListeners(u17) --[[ Line: 141 ]]
    -- upvalues: l__UserInputService__1 (copy)
    local function v18() --[[ Line: 142 ]]
        -- upvalues: u17 (copy)
        u17.moveVector = Vector3.new(0, 0, 0);
        u17.forwardValue = 0;
        u17.backwardValue = 0;
        u17.leftValue = 0;
        u17.rightValue = 0;
        u17.jumpRequested = false;
        u17:UpdateJump();
    end;
    u17.textFocusReleasedConn = l__UserInputService__1.TextBoxFocusReleased:Connect(v18);
    u17.textFocusGainedConn = l__UserInputService__1.TextBoxFocused:Connect(function(_) --[[ Name: onTextFocusGained, Line 152 ]]
        -- upvalues: u17 (copy)
        u17.jumpRequested = false;
        u17:UpdateJump();
    end);
    u17.windowFocusReleasedConn = l__UserInputService__1.WindowFocused:Connect(v18);
end;
function u1.DisconnectFocusEventListeners(p19) --[[ Line: 162 ]]
    if p19.textFocusReleasedConn then
        p19.textFocusReleasedConn:Disconnect();
        p19.textFocusReleasedConn = nil;
    end;
    if p19.textFocusGainedConn then
        p19.textFocusGainedConn:Disconnect();
        p19.textFocusGainedConn = nil;
    end;
    if p19.windowFocusReleasedConn then
        p19.windowFocusReleasedConn:Disconnect();
        p19.windowFocusReleasedConn = nil;
    end;
end;
return u1;