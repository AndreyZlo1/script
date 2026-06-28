-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.CameraUI
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__StarterGui__1 = game:GetService("StarterGui");
local u1 = false;
local u2 = {};
function u2.setCameraModeToastEnabled(p3) --[[ Line: 10 ]]
    -- upvalues: u1 (ref), u2 (copy)
    if p3 or u1 then
        if not u1 then
            u1 = true;
        end;
        if not p3 then
            u2.setCameraModeToastOpen(false);
        end;
    end;
end;
function u2.setCameraModeToastOpen(p4) --[[ Line: 24 ]]
    -- upvalues: u1 (ref), l__StarterGui__1 (copy)
    assert(u1);
    if p4 then
        l__StarterGui__1:SetCore("SendNotification", {
            Title = "Camera Control Enabled",
            Text = "Right click to toggle",
            Duration = 3
        });
    end;
end;
return u2;