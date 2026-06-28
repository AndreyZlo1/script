-- Roblox: ReplicatedStorage.WeaponProgression.CamoChallenges.AR
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    camoChallenges = {
        {
            levelRequired = 0,
            progression = {
                class = "kills",
                steps = {
                    {
                        amount = 1,
                        reward = "f1"
                    }
                }
            }
        },
        {
            levelRequired = 0,
            progression = {
                class = "double kills",
                steps = {
                    {
                        amount = 1,
                        reward = "f2"
                    }
                }
            }
        },
        {
            levelRequired = 0,
            progression = {
                class = "kills in one life",
                suffixAmount = true,
                steps = {
                    {
                        amount = 1,
                        killsRequired = 1,
                        reward = "f2"
                    }
                }
            }
        }
    },
    longshotDistance = 50
};