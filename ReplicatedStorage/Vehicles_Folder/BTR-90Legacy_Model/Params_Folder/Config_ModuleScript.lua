-- Roblox: ReplicatedStorage.Vehicles.BTR-90Legacy.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    DriverWeapons = {
        {
            Name = "30mm 2A44",
            ShellType = "Explosive",
            MuzzleVelocity = 1920,
            ShootRate = 310,
            Explosive = true,
            VehicleDamageMultiplier = 1,
            DamageFallOf = 0,
            MinDamage = 60,
            FireMode = "Auto",
            Ammo = 30,
            AmmoInGun = 30,
            ReloadTime = 7,
            FOV = 70,
            AimFOV = 40,
            Spread = 25,
            ShotImpulse = 10000,
            FXAttName = "FireFX",
            Explosion = {
                Radius = 3.5,
                Damage = 24,
                LightScale = 0.4,
                DisabledFX = { "Shockwave" }
            },
            LimbDamage = { 24, 24 },
            TorsoDamage = { 24, 24 },
            HeadDamage = { 56, 56 }
        },
        {
            Name = "7.62mm PKT coaxial",
            MuzzleVelocity = 1710,
            ShootRate = 650,
            DamageFallOf = 1,
            MinDamage = 5,
            FireMode = "Auto",
            Ammo = 100,
            AmmoInGun = 100,
            ReloadTime = 10,
            FOV = 60,
            AimFOV = 30,
            Spread = 5,
            FireSound = "SecondaryFire",
            FXAttName = "SecondaryFireFX",
            LimbDamage = { 20, 22 },
            TorsoDamage = { 20, 22 },
            HeadDamage = { 35, 37 }
        }
    }
};