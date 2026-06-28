-- Roblox: ReplicatedStorage.Planes.A-10 Warthog.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    Weapons = {
        {
            Name = "GAU-8 Avenger",
            Abbreviation = "GAU8",
            MuzzleVelocity = 1800,
            PredictFire = true,
            CannonSound = true,
            ShellGravity = Vector3.new(0, 0, 0),
            Ammo = 150,
            ReloadTime = 20,
            ShootRate = 950,
            FireMode = "Auto",
            DamageFallOf = 0,
            ShellType = "Explosive",
            Explosive = true,
            VehicleDamageMultiplier = 0.85,
            MinDamage = 15,
            AmmoInGun = 150,
            FOV = 70,
            AimFOV = 40,
            Spread = 25,
            ShotImpulse = 2000,
            FXAttName = "FireFX",
            TorsoDamage = { 15, 15 },
            LimbDamage = { 15, 15 },
            HeadDamage = { 15, 15 },
            HardpointData = {
                Name = "MG",
                Mode = "Many"
            },
            Explosion = {
                Radius = 8,
                Damage = 8,
                LightScale = 0.4,
                DisabledFX = { "Shockwave" }
            }
        },
        {
            Name = "Hellfire Missiles",
            Abbreviation = "HELL",
            ShellType = "Explosive",
            ShellName = "PlaneRocketModern",
            MuzzleVelocity = 700,
            Ammo = 4,
            ReloadTime = 7,
            ShootRate = 200,
            FireMode = "Auto",
            Explosive = true,
            VehicleDamageMultiplier = 1,
            FireCentral = true,
            HardpointData = {
                Name = "Rockets",
                Mode = "Sequential",
                Cosmetic = true
            },
            Explosion = {
                Radius = 15,
                Damage = 125
            },
            TorsoDamage = { 125, 125 },
            LimbDamage = { 125, 125 },
            HeadDamage = { 125, 125 }
        },
        {
            Name = "500lb bombs",
            Abbreviation = "BOMB",
            ShellType = "Explosive",
            ShellName = "PlaneBombShellModern",
            MuzzleVelocity = 300,
            Ammo = 2,
            ReloadTime = 15,
            SpecialType = "Bomb",
            ShootRate = 40,
            FireMode = "Auto",
            Explosive = true,
            DamageFallOf = 0,
            MinDamage = 100,
            HardpointData = {
                Name = "Bombs",
                Mode = "Sequential",
                Cosmetic = true
            },
            LimbDamage = { 279, 279 },
            TorsoDamage = { 279, 279 },
            HeadDamage = { 279, 279 },
            Explosion = {
                Radius = 35,
                Damage = 400
            }
        }
    }
};