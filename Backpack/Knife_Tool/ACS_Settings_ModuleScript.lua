-- Roblox: Players.SilverAce293026.Backpack.Knife.ACS_Settings
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("TweenService");
local v1 = {
    SlideEx = CFrame.new(0, 0, 0),
    SlideLock = false,
    canAim = false,
    Zoom = 70,
    Zoom2 = 70,
    gunName = script.Parent.Name,
    Type = "Melee",
    EnableHUD = false,
    BladeRange = 7,
    IncludeChamberedBullet = false,
    Ammo = 0,
    StoredAmmo = 0
};
v1.AmmoInGun = v1.Ammo;
v1.MaxStoredAmmo = 0;
v1.CanCheckMag = false;
v1.MagCount = false;
v1.ShellInsert = false;
v1.ShootRate = 180;
v1.Bullets = 0;
v1.ShootType = 1;
v1.FireModes = {
    ChangeFiremode = false,
    Semi = false,
    Burst = false,
    Auto = false
};
v1.LimbDamage = { 120, 120 };
v1.TorsoDamage = { 120, 120 };
v1.HeadDamage = { 120, 120 };
v1.DamageFallOf = 0;
v1.MinDamage = 0;
v1.IgnoreProtection = true;
v1.BulletPenetration = 0;
v1.CrossHair = false;
v1.CenterDot = true;
v1.CrosshairOffset = 0;
v1.CanBreachDoor = false;
v1.SightAtt = "";
v1.BarrelAtt = "";
v1.UnderBarrelAtt = "";
v1.OtherAtt = "";
v1.camRecoil = {
    camRecoilUp = { 0, 0 },
    camRecoilTilt = { 0, 0 },
    camRecoilLeft = { 0, 0 },
    camRecoilRight = { 0, 0 }
};
v1.gunRecoil = {
    gunRecoilUp = { 0, 0 },
    gunRecoilTilt = { 0, 0 },
    gunRecoilLeft = { 0, 0 },
    gunRecoilRight = { 0, 0 }
};
v1.AimRecoilReduction = 1;
v1.AimSpreadReduction = 1;
v1.MinRecoilPower = 0;
v1.MaxRecoilPower = 0;
v1.RecoilPowerStepAmount = 0;
v1.MinSpread = 0;
v1.MaxSpread = 0;
v1.AimInaccuracyStepAmount = 0;
v1.AimInaccuracyDecrease = 0;
v1.WalkMult = 0;
v1.EnableZeroing = false;
v1.MaxZero = 500;
v1.ZeroIncrement = 50;
v1.CurrentZero = 0;
v1.BulletType = "";
v1.MuzzleVelocity = 0;
v1.BulletDrop = 0;
v1.Tracer = false;
v1.BulletFlare = false;
v1.TracerColor = Color3.fromRGB(255, 255, 255);
v1.RandomTracer = {
    Enabled = false,
    Chance = 25
};
v1.TracerEveryXShots = 0;
v1.RainbowMode = false;
v1.InfraRed = false;
v1.CanBreak = false;
v1.Jammed = false;
return v1;