-- Roblox: ReplicatedStorage.Vehicles.M4 Sherman.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    DriverWeapons = {
        {
            Name = "75mm M3",
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
                Damage = 270
            },
            TorsoDamage = { 350, 350 },
            LimbDamage = { 350, 350 },
            HeadDamage = { 350, 350 }
        },
        {
            Name = "7.62mm MG",
            MuzzleVelocity = 1710,
            ShootRate = 450,
            DamageFallOf = 1,
            MinDamage = 5,
            FireMode = "Auto",
            Ammo = 40,
            AmmoInGun = 100,
            ReloadTime = 10,
            FOV = 60,
            AimFOV = 30,
            Spread = 5,
            FireSound = "SecondaryFire",
            FXAttName = "Attachment",
            Dome = "Coax",
            LimbDamage = { 20, 22 },
            TorsoDamage = { 20, 22 },
            HeadDamage = { 30, 33 }
        }
    }
};