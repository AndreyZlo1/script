-- Roblox: ReplicatedStorage.Vehicles.L-ATV.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    DriverWeapons = {
        {
            Name = "20mm Chain Gun",
            ShellType = "Explosive",
            Explosive = true,
            MuzzleVelocity = 1920,
            ShootRate = 560,
            VehicleDamageMultiplier = 0.5,
            DamageFallOf = 0,
            MinDamage = 60,
            FireMode = "Auto",
            Ammo = 30,
            AmmoInGun = 30,
            ReloadTime = 7,
            FOV = 70,
            AimFOV = 40,
            Spread = 25,
            ShotImpulse = 2000,
            FXAttName = "FireFX",
            Explosion = {
                Radius = 2.3,
                Damage = 20,
                LightScale = 0.4,
                DisabledFX = { "Shockwave" }
            },
            LimbDamage = { 20, 20 },
            TorsoDamage = { 20, 20 },
            HeadDamage = { 45, 45 }
        },
        {
            Name = "Javelin AT Missile",
            ShellType = "Explosive",
            ShellName = "HeliRocketShell",
            pathType = "Javelin",
            SpecialType = "Heatseeker",
            MuzzleVelocity = 300,
            ShootRate = 400,
            FireMode = "Semi",
            Explosive = true,
            DamageFallOf = 0,
            MinDamage = 60,
            Ammo = 1,
            AmmoInGun = 1,
            ReloadTime = 10,
            FOV = 60,
            AimFOV = 30,
            Spread = 5,
            FireSound = "SecondaryFire",
            FXAttName = "SecondaryFireFX",
            LimbDamage = { 550, 550 },
            TorsoDamage = { 550, 550 },
            HeadDamage = { 550, 550 },
            Explosion = {
                Radius = 14,
                Damage = 140
            }
        }
    }
};