-- Roblox: ReplicatedStorage.Planes.F4 Phantom II.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    Weapons = {
        {
            Name = "Vulcan 30mm",
            Abbreviation = "VULC",
            MuzzleVelocity = 1800,
            PredictFire = true,
            CannonSound = true,
            ShellGravity = Vector3.new(0, 0, 0),
            Ammo = 40,
            ReloadTime = 15,
            ShootRate = 1200,
            FireMode = "Auto",
            DamageFallOf = 0,
            ShellType = "Explosive",
            Explosive = true,
            VehicleDamageMultiplier = 0.5,
            MinDamage = 60,
            AmmoInGun = 30,
            FOV = 70,
            AimFOV = 40,
            Spread = 25,
            ShotImpulse = 2000,
            FXAttName = "FireFX",
            TorsoDamage = { 90, 90 },
            LimbDamage = { 90, 90 },
            HeadDamage = { 90, 90 },
            HardpointData = {
                Name = "Vulcan",
                Mode = "Single"
            },
            Explosion = {
                Radius = 2,
                Damage = 20,
                LightScale = 0.4,
                DisabledFX = { "Shockwave" }
            }
        },
        {
            Name = "Heatseekers",
            Abbreviation = "HEAT",
            ShellType = "Explosive",
            ShellName = "HeliRocketShell",
            MuzzleVelocity = 300,
            Ammo = 2,
            pathType = "Air",
            ReloadTime = 15,
            SpecialType = "Heatseeker",
            ShootRate = 60,
            FireMode = "Semi",
            Explosive = true,
            DamageFallOf = 0,
            MinDamage = 60,
            AimSize = UDim2.new(0, 400, 0, 400),
            HardpointData = {
                Name = "Heatseekers",
                Mode = "Sequential"
            },
            LimbDamage = { 279, 279 },
            TorsoDamage = { 279, 279 },
            HeadDamage = { 279, 279 },
            Explosion = {
                Radius = 14,
                Damage = 70
            }
        }
    }
};