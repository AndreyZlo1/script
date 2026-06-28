-- Roblox: Players.SilverAce293026.Backpack.Knife.ACS_Animations
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local u1 = {
    MainCFrame = CFrame.new(0, 0, 0),
    GunModelFixed = true,
    GunCFrame = CFrame.new(0.15, 0, 0.85) * CFrame.Angles(1.5707963267948966, 0, 0),
    LArmCFrame = CFrame.new(-1, -0.85, -0.25) * CFrame.Angles(1.7453292519943295, -0.5235987755982988, 0.2617993877991494),
    RArmCFrame = CFrame.new(1, -0.85, -0.25) * CFrame.Angles(1.7453292519943295, 0.5235987755982988, -0.2617993877991494)
};
function u1.EquipAnim(p2) --[[ Line: 11 ]]
    -- upvalues: l__TweenService__1 (copy), u1 (copy)
    l__TweenService__1:Create(p2[1], TweenInfo.new(0, Enum.EasingStyle.Linear), {
        C1 = (CFrame.new(1, -1, 1) * CFrame.Angles(3.141592653589793, 0.6108652381980153, -2.0943951023931953)):inverse()
    }):Play();
    l__TweenService__1:Create(p2[2], TweenInfo.new(0, Enum.EasingStyle.Linear), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(0.15);
    l__TweenService__1:Create(p2[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.RArmCFrame:Inverse()
    }):Play();
    l__TweenService__1:Create(p2[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.LArmCFrame:Inverse()
    }):Play();
    wait(0.25);
end;
function u1.IdleAnim(p3) --[[ Line: 20 ]]
    -- upvalues: l__TweenService__1 (copy), u1 (copy)
    l__TweenService__1:Create(p3[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.RArmCFrame:Inverse()
    }):Play();
    l__TweenService__1:Create(p3[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.LArmCFrame:Inverse()
    }):Play();
end;
function u1.LowReady(_) --[[ Line: 25 ]] end;
function u1.HighReady(_) --[[ Line: 29 ]] end;
function u1.Patrol(_) --[[ Line: 33 ]] end;
function u1.SprintAnim(p4) --[[ Line: 37 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p4[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p4[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(0.25);
end;
function u1.ReloadAnim(_) --[[ Line: 43 ]] end;
function u1.TacticalReloadAnim(_) --[[ Line: 47 ]] end;
function u1.JammedAnim(_) --[[ Line: 51 ]] end;
function u1.PumpAnim(_) --[[ Line: 55 ]] end;
function u1.MagCheck(_) --[[ Line: 59 ]] end;
function u1.meleeAttack(p5) --[[ Line: 63 ]]
    -- upvalues: l__TweenService__1 (copy), u1 (copy)
    l__TweenService__1:Create(p5[1], TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-1, -0.65, 0) * CFrame.Angles(3.0543261909900767, 0.2617993877991494, -1.4835298641951802)):inverse()
    }):Play();
    l__TweenService__1:Create(p5[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(0.2);
    p5[4].Handle.Swing:Play();
    l__TweenService__1:Create(p5[1], TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        C1 = (CFrame.new(1.5, -0.85, 0) * CFrame.Angles(3.141592653589793, 2.792526803190927, -1.4835298641951802)):inverse()
    }):Play();
    wait(0.3);
    l__TweenService__1:Create(p5[1], TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        C1 = u1.RArmCFrame:Inverse()
    }):Play();
    l__TweenService__1:Create(p5[2], TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        C1 = u1.LArmCFrame:Inverse()
    }):Play();
    wait(0.1);
end;
function u1.GrenadeReady(_) --[[ Line: 75 ]] end;
function u1.GrenadeThrow(_) --[[ Line: 79 ]] end;
u1.SV_GunPos = CFrame.new(-0.15, -0.3, -0.3) * CFrame.Angles(-1.5707963267948966, 0, 0);
u1.SV_RightArmPos = CFrame.new(-1, 0.55, -1.5) * CFrame.Angles(-1.5707963267948966, -0.3490658503988659, -0.3490658503988659);
u1.SV_LeftArmPos = CFrame.new(1, 0.55, -1.5) * CFrame.Angles(-1.5707963267948966, 0.3490658503988659, 0.3490658503988659);
u1.SV_RightElbowPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.SV_LeftElbowPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.SV_RightWristPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.SV_LeftWristPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightHighReady = CFrame.new(-1, -0.5, -1.25) * CFrame.Angles(-2.792526803190927, 0, 0);
u1.LeftHighReady = CFrame.new(0.85, -0.35, -1.15) * CFrame.Angles(-2.9670597283903604, 1.0471975511965976, 0.2617993877991494);
u1.RightLowReady = CFrame.new(-1, 0.85, -1.15) * CFrame.Angles(-1.0471975511965976, 0, 0);
u1.LeftLowReady = CFrame.new(0.95, 0.75, -1.35) * CFrame.Angles(-1.0471975511965976, 0.6108652381980153, -0.4363323129985824);
u1.RightPatrol = CFrame.new(-1, 1.5, -0.45) * CFrame.Angles(-0.5235987755982988, 0, 0);
u1.LeftPatrol = CFrame.new(1, 1.35, -0.75) * CFrame.Angles(-0.5235987755982988, 0.6108652381980153, -0.4363323129985824);
u1.RightAim = CFrame.new(-0.575, 1, -0.65) * CFrame.Angles(-1.5707963267948966, 0, 0);
u1.LeftAim = CFrame.new(1.3, 0.35, -1.45) * CFrame.Angles(-2.0943951023931953, 0.6108652381980153, -0.4363323129985824);
u1.RightSprint = CFrame.new(-1, 0.55, -1.5) * CFrame.Angles(-1.5707963267948966, -0.3490658503988659, -0.3490658503988659);
u1.LeftSprint = CFrame.new(1, 0.55, -1.5) * CFrame.Angles(-1.5707963267948966, 0.3490658503988659, 0.3490658503988659);
u1.RightElbowSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftElbowSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightWristSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftWristSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
return u1;