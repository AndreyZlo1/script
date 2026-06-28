-- Roblox: ReplicatedStorage.Planes.P51.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    Weapons = {
        {
            Name = ".50 Cal MG\'s",
            Abbreviation = "MG",
            MuzzleVelocity = 900,
            PredictFire = true,
            CannonSound = true,
            ShellGravity = Vector3.new(0, 0, 0),
            Ammo = 120,
            ReloadTime = 15,
            ShootRate = 600,
            FireMode = "Auto",
            DamageFallOf = 0,
            ShellType = "Bullet",
            VehicleDamageMultiplier = 0.3,
            MinDamage = 60,
            AmmoInGun = 120,
            FOV = 70,
            AimFOV = 40,
            Spread = 25,
            ShotImpulse = 2000,
            FXAttName = "FireFX",
            TorsoDamage = { 30, 40 },
            LimbDamage = { 30, 40 },
            HeadDamage = { 30, 40 },
            HardpointData = {
                Name = "MG",
                Mode = "Many"
            }
        },
        {
            Name = "100lb bombs",
            Abbreviation = "BOMB",
            ShellType = "Explosive",
            ShellName = "PlaneBombShell",
            MuzzleVelocity = 300,
            Ammo = 2,
            ReloadTime = 15,
            SpecialType = "Bomb",
            ShootRate = 40,
            FireMode = "Auto",
            Explosive = true,
            DamageFallOf = 0,
            MinDamage = 60,
            HardpointData = {
                Name = "Bombs",
                Mode = "Sequential",
                Cosmetic = true
            },
            LimbDamage = { 279, 279 },
            TorsoDamage = { 279, 279 },
            HeadDamage = { 279, 279 },
            Explosion = {
                Radius = 28,
                Damage = 70
            }
        }
    }
};