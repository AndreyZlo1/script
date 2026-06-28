-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
function u1.new() --[[ Line: 14 ]]
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.enabled = false;
    v2.moveVector = Vector3.new(0, 0, 0);
    v2.moveVectorIsCameraRelative = true;
    v2.isJumping = false;
    return v2;
end;
function u1.OnRenderStepped(_, _) --[[ Line: 23 ]] end;
function u1.GetMoveVector(p3) --[[ Line: 27 ]]
    return p3.moveVector;
end;
function u1.IsMoveVectorCameraRelative(p4) --[[ Line: 31 ]]
    return p4.moveVectorIsCameraRelative;
end;
function u1.GetIsJumping(p5) --[[ Line: 35 ]]
    return p5.isJumping;
end;
function u1.Enable(_, _) --[[ Line: 41 ]]
    error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.");
    return false;
end;
return u1;