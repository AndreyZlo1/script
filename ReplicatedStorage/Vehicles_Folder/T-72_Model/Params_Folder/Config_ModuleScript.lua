-- Roblox: ReplicatedStorage.Vehicles.T-72.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    DriverWeapons = {
        {
            Name = "120mm Smoothbore",
            ShellType = "Explosive",
            ShellName = "TankShell",
            MuzzleVelocity = 700,
            ShootRate = 99999,
            Explosive = true,
            VehicleDamageMultiplier = 1,
            DamageFallOf = 0,
            MinDamage = 60,
            FireMode = "Semi",
            Ammo = 1,
            AmmoInGun = 1,
            ReloadTime = 7,
            FOV = 70,
            AimFOV = 40,
            Spread = 1,
            ShotImpulse = 15000,
            FXAttName = "FireFX",
            Explosion = {
                Radius = 30,
                Damage = 350
            },
            TorsoDamage = { 450, 450 },
            LimbDamage = { 450, 450 },
            HeadDamage = { 450, 450 }
        },
        {
            Name = "7.62mm PKT",
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
            Dome = "Coax",
            LimbDamage = { 20, 22 },
            TorsoDamage = { 20, 22 },
            HeadDamage = { 35, 37 }
        }
    }
};