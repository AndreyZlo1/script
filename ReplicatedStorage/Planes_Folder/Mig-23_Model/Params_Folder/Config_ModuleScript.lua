-- Roblox: ReplicatedStorage.Planes.Mig-23.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    Weapons = {
        {
            Name = "S-8 Rockets",
            Abbreviation = "S-8",
            ShellType = "Explosive",
            ShellName = "HeliRocketShell",
            MuzzleVelocity = 600,
            Ammo = 14,
            ReloadTime = 15,
            ShootRate = 500,
            FireMode = "Auto",
            Explosive = true,
            DamageFallOf = 0,
            HardpointData = {
                Name = "Heatseekers",
                Mode = "Sequential"
            },
            Explosion = {
                Radius = 20,
                Damage = 120
            },
            TorsoDamage = { 90, 90 },
            LimbDamage = { 90, 90 },
            HeadDamage = { 90, 90 }
        },
        {
            Name = "Heatseekers",
            Abbreviation = "HEAT",
            ShellType = "Explosive",
            ShellName = "HeliRocketShell",
            MuzzleVelocity = 300,
            Ammo = 2,
            ReloadTime = 15,
            SpecialType = "Heatseeker",
            ShootRate = 60,
            FireMode = "Semi",
            pathType = "Air",
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