-- Roblox: Workspace.SilverAce293026.G19X.ACS_Animations
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__TweenService__1 = game:GetService("TweenService");
local u1 = {
    MainCFrame = CFrame.new(0.5, -0.85, -0.75),
    GunModelFixed = false,
    GunCFrame = CFrame.new(0.15, -0.2, 1) * CFrame.Angles(1.5707963267948966, 0, 0),
    LArmCFrame = CFrame.new(-0.6, -0.3, 0) * CFrame.Angles(1.5707963267948966, 0.4363323129985824, 0.2617993877991494),
    RArmCFrame = CFrame.new(0, -0.15, 0) * CFrame.Angles(1.5707963267948966, 0, 0),
    Keyframes = true,
    IsFirstEquip = true,
    KFGunCFrame = CFrame.new(0.05, -0.1, 0)
};
function u1.EquipAnim(p2) --[[ Line: 17 ]]
    -- upvalues: l__TweenService__1 (copy), u1 (copy)
    l__TweenService__1:Create(p2[1], TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
        C1 = (CFrame.new(1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p2[2], TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(0.25);
    l__TweenService__1:Create(p2[1], TweenInfo.new(0.35, Enum.EasingStyle.Sine), {
        C1 = u1.RArmCFrame:Inverse()
    }):Play();
    l__TweenService__1:Create(p2[2], TweenInfo.new(0.35, Enum.EasingStyle.Sine), {
        C1 = u1.LArmCFrame:Inverse()
    }):Play();
    wait(0.35);
end;
function u1.IdleAnim(p3) --[[ Line: 26 ]]
    -- upvalues: l__TweenService__1 (copy), u1 (copy)
    l__TweenService__1:Create(p3[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.RArmCFrame:Inverse()
    }):Play();
    l__TweenService__1:Create(p3[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.LArmCFrame:Inverse()
    }):Play();
end;
function u1.LowReady(p4) --[[ Line: 31 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p4[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0, -0.15, 0.1) * CFrame.Angles(1.2217304763960306, 0, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p4[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.55, -0.45, 0) * CFrame.Angles(1.3089969389957472, 0.4363323129985824, 0.2617993877991494)):inverse()
    }):Play();
    wait(0.25);
end;
function u1.HighReady(p5) --[[ Line: 37 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p5[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0.15, -0.1, 0.5) * CFrame.Angles(2.530727415391778, 0, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p5[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.2, -0.25, 0) * CFrame.Angles(2.705260340591211, 0.9599310885968813, 0.2617993877991494)):inverse()
    }):Play();
    wait(0.25);
end;
function u1.Patrol(p6) --[[ Line: 43 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p6[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0, -0.15, 0.5) * CFrame.Angles(0.9599310885968813, 0, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p6[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.55, -0.45, 0.4) * CFrame.Angles(1.0471975511965976, 0.4363323129985824, 0.2617993877991494)):inverse()
    }):Play();
    wait(0.25);
end;
function u1.SprintAnim(p7) --[[ Line: 49 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p7[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0.5, -0.15, 0) * CFrame.Angles(3.0543261909900767, 0, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p7[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(0.25);
end;
function u1.ReloadAnim(p8) --[[ Line: 55 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p8[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0, -0.15, 0) * CFrame.Angles(1.5707963267948966, -0.4363323129985824, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p8[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.6, -0.3, 0) * CFrame.Angles(1.0471975511965976, 0.8726646259971648, 0.5235987755982988)):inverse()
    }):Play();
    wait(0.3);
    l__TweenService__1:Create(p8[1], TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        C1 = (CFrame.new(0, -0.15, 0) * CFrame.Angles(1.4835298641951802, -0.2617993877991494, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p8[2], TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-1.5, -0.5, 0.75) * CFrame.Angles(0, 0.8726646259971648, 0.2617993877991494)):inverse()
    }):Play();
    wait(0.05);
    p8[4].Handle.MagOut:Play();
    p8[4].Mag.Transparency = 1;
    wait(0.5);
    p8[4].Handle.AimUp:Play();
    wait(0.75);
    l__TweenService__1:Create(p8[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.6, -0.3, 0) * CFrame.Angles(1.0471975511965976, 0.8726646259971648, 0.5235987755982988)):inverse()
    }):Play();
    wait(0.25);
    p8[4].Handle.MagIn:Play();
    l__TweenService__1:Create(p8[1], TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0, -0.15, 0) * CFrame.Angles(1.5707963267948966, -0.4363323129985824, 0)):inverse()
    }):Play();
    p8[4].Mag.Transparency = 0;
    wait(0.15);
end;
function u1.TacticalReloadAnim(p9) --[[ Line: 76 ]]
    -- upvalues: l__TweenService__1 (copy)
    l__TweenService__1:Create(p9[1], TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        C1 = (CFrame.new(0, -0.15, 0) * CFrame.Angles(1.6580627893946132, 0.7853981633974483, 0)):inverse()
    }):Play();
    l__TweenService__1:Create(p9[2], TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-1.5, -1, 1) * CFrame.Angles(0, 0.8726646259971648, 0.2617993877991494)):inverse()
    }):Play();
    wait(0.2);
    l__TweenService__1:Create(p9[1], TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        C1 = (CFrame.new(0, -0.15, 0) * CFrame.Angles(1.4835298641951802, -0.4363323129985824, 0)):inverse()
    }):Play();
    p9[4].Handle.MagOut:Play();
    p9[4].Mag.Transparency = 1;
    local v10 = p9[4]:WaitForChild("Mag"):Clone();
    v10:ClearAllChildren();
    v10.Transparency = 0;
    v10.Parent = p9[4];
    v10.Anchored = false;
    v10.RotVelocity = Vector3.new(0, 0, 0);
    v10:ApplyImpulse(v10.CFrame.RightVector * 1);
    wait(0.5);
    p9[4].Handle.AimUp:Play();
    wait(0.25);
    l__TweenService__1:Create(p9[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.6, -0.3, 0) * CFrame.Angles(1.0471975511965976, 0.8726646259971648, 0.5235987755982988)):inverse()
    }):Play();
    wait(0.25);
    p9[4].Handle.MagIn:Play();
    l__TweenService__1:Create(p9[1], TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0, -0.15, 0) * CFrame.Angles(1.5707963267948966, -0.4363323129985824, 0)):inverse()
    }):Play();
    p9[4].Mag.Transparency = 0;
    wait(0.25);
    p9[4].Bolt.SlideRelease:Play();
    l__TweenService__1:Create(p9[4].Handle.Slide, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
        C0 = CFrame.new():inverse()
    }):Play();
    wait(0.1);
end;
function u1.JammedAnim(p11) --[[ Line: 107 ]]
    -- upvalues: l__TweenService__1 (copy), u1 (copy)
    l__TweenService__1:Create(p11[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = u1.RArmCFrame:Inverse()
    }):Play();
    l__TweenService__1:Create(p11[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.8, 0.1, 0) * CFrame.Angles(2.007128639793479, -0.4363323129985824, 0.5235987755982988)):inverse()
    }):Play();
    wait(0.25);
    p11[4].Bolt.SlidePull:Play();
    l__TweenService__1:Create(p11[4].Handle.Slide, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C0 = CFrame.new(0, 0, -0.4):inverse()
    }):Play();
    l__TweenService__1:Create(p11[2], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(-0.8, 0.1, 0.4) * CFrame.Angles(2.007128639793479, -0.4363323129985824, 0.5235987755982988)):inverse()
    }):Play();
    wait(0.35);
    p11[4].Bolt.SlideRelease:Play();
    l__TweenService__1:Create(p11[4].Handle.Slide, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
        C0 = CFrame.new():inverse()
    }):Play();
end;
function u1.PumpAnim(_) --[[ Line: 119 ]] end;
function u1.MagCheck(p12) --[[ Line: 123 ]]
    -- upvalues: l__TweenService__1 (copy)
    p12[4].Handle.AimUp:Play();
    l__TweenService__1:Create(p12[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0.5, -0.15, 0) * CFrame.Angles(1.7453292519943295, 0, -0.7853981633974483)):inverse()
    }):Play();
    l__TweenService__1:Create(p12[2], TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(2.5);
    p12[4].Handle.AimDown:Play();
    l__TweenService__1:Create(p12[1], TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
        C1 = (CFrame.new(0.5, -0.15, 0) * CFrame.Angles(2.792526803190927, 1.0471975511965976, -0.7853981633974483)):inverse()
    }):Play();
    l__TweenService__1:Create(p12[2], TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
        C1 = (CFrame.new(-1, -1, 1) * CFrame.Angles(0, 0, 0)):inverse()
    }):Play();
    wait(2.5);
    p12[4].Handle.AimUp:Play();
end;
function u1.meleeAttack(_) --[[ Line: 135 ]] end;
function u1.GrenadeReady(_) --[[ Line: 139 ]] end;
function u1.GrenadeThrow(_) --[[ Line: 143 ]] end;
u1.SV_GunPos = CFrame.new(-0.3, -0.2, -0.4) * CFrame.Angles(-1.5707963267948966, 0, 0);
u1.SV_RightArmPos = CFrame.new(-0.575, 0.65, -1.185) * CFrame.Angles(-1.5707963267948966, 0, 0);
u1.SV_LeftArmPos = CFrame.new(1.15, 0.25, -1.3) * CFrame.Angles(-1.6580627893946132, 0.3490658503988659, -0.4363323129985824);
u1.SV_RightElbowPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.SV_LeftElbowPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.SV_RightWristPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.SV_LeftWristPos = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightHighReady = CFrame.new(-1, 0.45, -1.15) * CFrame.Angles(-1.5707963267948966, 0, 0);
u1.LeftHighReady = CFrame.new(0.75, 0.45, -1.15) * CFrame.Angles(-1.5707963267948966, 0.7853981633974483, 0);
u1.RightElbowHighReady = CFrame.new(0, -0.45, -0.45) * CFrame.Angles(-1.3089969389957472, 0, 0);
u1.LeftElbowHighReady = CFrame.new(0, -0.4, -0.4) * CFrame.Angles(-1.0471975511965976, 0.5235987755982988, 0);
u1.RightWristHighReady = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftWristHighReady = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightLowReady = CFrame.new(-1, 1.1, -0.5) * CFrame.Angles(-0.5235987755982988, 0, 0);
u1.LeftLowReady = CFrame.new(1, 1, -0.9) * CFrame.Angles(-0.5235987755982988, 0.6108652381980153, -0.4363323129985824);
u1.RightElbowLowReady = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftElbowLowReady = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightWristLowReady = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftWristLowReady = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightPatrol = CFrame.new(-1, 1.1, -0.5) * CFrame.Angles(-0.5235987755982988, 0, 0);
u1.LeftPatrol = CFrame.new(1, 1, -0.9) * CFrame.Angles(-0.5235987755982988, 0.6108652381980153, -0.4363323129985824);
u1.RightElbowPatrol = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftElbowPatrol = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightWristPatrol = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftWristPatrol = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightAim = CFrame.new(-0.575, 0.45, -1.15) * CFrame.Angles(-1.8325957145940461, 0, 0);
u1.LeftAim = CFrame.new(1.3, 0.2, -0.85) * CFrame.Angles(-1.6580627893946132, 0.6108652381980153, -0.4363323129985824);
u1.RightElbowAim = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftElbowAim = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightWristAim = CFrame.new(0, 0, 0.1) * CFrame.Angles(0.2617993877991494, 0, 0);
u1.LeftWristAim = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightSprint = CFrame.new(-1, 1.1, -0.5) * CFrame.Angles(-0.5235987755982988, 0, 0);
u1.LeftSprint = CFrame.new(1, 1, -0.9) * CFrame.Angles(-0.5235987755982988, 0.6108652381980153, -0.4363323129985824);
u1.RightElbowSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftElbowSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.RightWristSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
u1.LeftWristSprint = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0);
return u1;