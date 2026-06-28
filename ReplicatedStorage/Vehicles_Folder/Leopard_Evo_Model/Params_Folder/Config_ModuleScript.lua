-- Roblox: ReplicatedStorage.Vehicles.Leopard Evo.Params.Config
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
            Name = ".50 cal Turret",
            MuzzleVelocity = 1710,
            ShootRate = 300,
            DamageFallOf = 1,
            MinDamage = 5,
            FireMode = "Auto",
            Ammo = 30,
            AmmoInGun = 30,
            ReloadTime = 10,
            FOV = 60,
            AimFOV = 30,
            Spread = 5,
            FireSound = "SecondaryFire",
            FXAttName = "Attachment",
            Dome = "Coax",
            LimbDamage = { 45, 47 },
            TorsoDamage = { 45, 47 },
            HeadDamage = { 115, 117 }
        }
    }
};