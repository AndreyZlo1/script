-- Roblox: Workspace.SilverAce293026.PlaneControl.InputModule.PlaneScheme
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    DirectionPointer = {
        Bindings = {
            PC = { Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch },
            Console = { Enum.KeyCode.Thumbstick2 }
        },
        RepeatingBindings = { "Console", "Mobile" }
    },
    Zoom = {
        Bindings = {
            PC = { Enum.UserInputType.MouseButton2 },
            Console = { Enum.KeyCode.ButtonL1 }
        }
    },
    Roll = {
        Bindings = {
            PC = { Enum.KeyCode.D },
            PCFlipped = { Enum.KeyCode.A },
            Console = { Enum.KeyCode.Thumbstick1 }
        },
        RepeatingBindings = { "Console", "Mobile" }
    },
    Freelook = {
        Bindings = {
            PC = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt },
            Console = { Enum.KeyCode.ButtonR3 }
        }
    },
    SwapView = {
        Bindings = {
            PC = { Enum.KeyCode.E },
            Console = { Enum.KeyCode.DPadUp }
        }
    },
    Thrust = {
        Bindings = {
            PC = { Enum.KeyCode.W, Enum.KeyCode.LeftShift },
            PCFlipped = { Enum.KeyCode.S, Enum.KeyCode.LeftControl },
            Console = { Enum.KeyCode.ButtonR2 },
            ConsoleFlipped = { Enum.KeyCode.ButtonL2 },
            Mobile = { "ElevateUp" },
            MobileFlipped = { "ElevateDown" }
        },
        RepeatingBindings = { "Console" }
    },
    Flares = {
        Bindings = {
            PC = { Enum.KeyCode.F },
            Console = { Enum.KeyCode.DPadDown },
            Mobile = { "Flares" }
        }
    }
};