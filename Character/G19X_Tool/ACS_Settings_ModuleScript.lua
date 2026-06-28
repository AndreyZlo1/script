-- Roblox: Workspace.SilverAce293026.G19X.ACS_Settings
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("TweenService");
local v1 = {
    SlideEx = CFrame.new(0, 0, -0.3),
    SlideLock = true,
    canAim = true,
    Zoom = 70,
    Zoom2 = 70,
    adsTime = 0.18,
    gunName = script.Parent.Name,
    Type = "Gun",
    EnableHUD = true,
    IncludeChamberedBullet = true,
    Ammo = 17,
    StoredAmmo = 204
};
v1.AmmoInGun = v1.Ammo;
v1.MaxStoredAmmo = 408;
v1.CanCheckMag = true;
v1.MagCount = true;
v1.ShellInsert = false;
v1.ShootRate = 700;
v1.Bullets = 1;
v1.BurstShot = 3;
v1.ShootType = 1;
v1.FireModes = {
    ChangeFiremode = false,
    Semi = false,
    Burst = false,
    Auto = false
};
v1.MobileAutoFire = true;
v1.LimbDamage = { 24, 24 };
v1.TorsoDamage = { 24, 24 };
v1.HeadDamage = { 28, 30 };
v1.DamageFallOf = 1;
v1.MinDamage = 5;
v1.IgnoreProtection = false;
v1.BulletPenetration = 40;
v1.CrossHair = true;
v1.CenterDot = false;
v1.CrosshairOffset = 0;
v1.CanBreachDoor = false;
v1.SightAtt = "";
v1.BarrelAtt = "";
v1.UnderBarrelAtt = "";
v1.OtherAtt = "";
v1.camRecoil = {
    camRecoilUp = { 0, 0 },
    camRecoilTilt = { 0, 0 },
    camRecoilLeft = { 5, 8 },
    camRecoilRight = { 5, 8 }
};
v1.gunRecoil = {
    gunRecoilUp = { 110, 120 },
    gunRecoilTilt = { 25, 40 },
    gunRecoilLeft = { 10, 15 },
    gunRecoilRight = { 10, 15 }
};
v1.AimRecoilReduction = 4;
v1.AimSpreadReduction = 35;
v1.MinRecoilPower = 0.5;
v1.MaxRecoilPower = 1.5;
v1.RecoilPowerStepAmount = 0.1;
v1.MinSpread = 5;
v1.MaxSpread = 10;
v1.WalkMult = 0.5;
v1.BulletType = "9x19mm";
v1.MuzzleVelocity = 1000;
v1.BulletDrop = 0.25;
v1.InfraRed = false;
v1.CanBreak = false;
v1.Jammed = false;
return v1;