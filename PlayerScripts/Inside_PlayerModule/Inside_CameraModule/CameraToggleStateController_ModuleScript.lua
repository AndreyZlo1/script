-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.CameraToggleStateController
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("Players");
game:GetService("UserInputService");
UserSettings():GetService("UserGameSettings");
local l__CameraInput__1 = require(script.Parent:WaitForChild("CameraInput"));
local l__CameraUI__2 = require(script.Parent:WaitForChild("CameraUI"));
local l__CameraUtils__3 = require(script.Parent:WaitForChild("CameraUtils"));
local u1 = false;
local u2 = tick();
local u3 = false;
local u4 = false;
local u5 = false;
l__CameraUI__2.setCameraModeToastEnabled(false);
return function(p6) --[[ Line: 20 ]]
    -- upvalues: l__CameraInput__1 (copy), u1 (ref), u3 (ref), u2 (ref), l__CameraUI__2 (copy), u5 (ref), u4 (ref), l__CameraUtils__3 (copy)
    local v7 = l__CameraInput__1.getTogglePan();
    if p6 and v7 ~= u1 then
        u3 = true;
    end;
    if u1 ~= v7 or tick() - u2 > 3 then
        local v8;
        if v7 then
            v8 = tick() - u2 < 3;
        else
            v8 = v7;
        end;
        l__CameraUI__2.setCameraModeToastOpen(v8);
        if v7 then
            u3 = false;
        end;
        u2 = tick();
        u1 = v7;
    end;
    if p6 ~= u5 then
        if p6 then
            u4 = l__CameraInput__1.getTogglePan();
            l__CameraInput__1.setTogglePan(true);
        elseif not u3 then
            l__CameraInput__1.setTogglePan(u4);
        end;
    end;
    if p6 then
        if l__CameraInput__1.getTogglePan() then
            l__CameraUtils__3.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png");
            l__CameraUtils__3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
            l__CameraUtils__3.setRotationTypeOverride(Enum.RotationType.CameraRelative);
        else
            l__CameraUtils__3.restoreMouseIcon();
            l__CameraUtils__3.restoreMouseBehavior();
            l__CameraUtils__3.setRotationTypeOverride(Enum.RotationType.CameraRelative);
        end;
    elseif l__CameraInput__1.getTogglePan() then
        l__CameraUtils__3.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png");
        l__CameraUtils__3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
        l__CameraUtils__3.setRotationTypeOverride(Enum.RotationType.MovementRelative);
    elseif l__CameraInput__1.getHoldPan() then
        l__CameraUtils__3.restoreMouseIcon();
        l__CameraUtils__3.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition);
        l__CameraUtils__3.setRotationTypeOverride(Enum.RotationType.MovementRelative);
    else
        l__CameraUtils__3.restoreMouseIcon();
        l__CameraUtils__3.restoreMouseBehavior();
        l__CameraUtils__3.restoreRotationType();
    end;
    u5 = p6;
end;