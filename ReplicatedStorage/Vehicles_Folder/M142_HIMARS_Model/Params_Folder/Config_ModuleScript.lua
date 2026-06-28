-- Roblox: ReplicatedStorage.Vehicles.M142 HIMARS.Params.Config
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    DriverWeapons = {
        {
            Name = "M26 Rockets",
            ShellType = "Explosive",
            ShellName = "ArtilleryRocket",
            Explosive = true,
            MuzzleVelocity = 300,
            ShootRate = 300,
            VehicleDamageMultiplier = 1.9,
            DamageFallOf = 0,
            MinDamage = 60,
            FireMode = "Semi",
            Ammo = 6,
            AmmoInGun = 6,
            ReloadTime = 15,
            FOV = 70,
            AimFOV = 35,
            Spread = 1,
            ShotImpulse = 3000,
            FXAttName = "FireFX",
            OneShotSound = true,
            MustBeStatic = true,
            MotorDelegate = "HIMARS",
            SpecialType = "Artillery",
            pathType = "Artillery",
            Explosion = {
                Radius = 30,
                Damage = 350,
                LightScale = 0.6,
                DisabledFX = { "Shockwave" }
            },
            shellGravity = Vector3.new(),
            LimbDamage = { 150, 150 },
            TorsoDamage = { 180, 180 },
            HeadDamage = { 200, 200 },
            ObstructionAngles = {
                Axis = "X",
                OtherAxisClearance = 15,
                InvalidArea = {
                    Min = -20,
                    Max = 20
                }
            }
        }
    }
};