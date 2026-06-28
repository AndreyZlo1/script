-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.trackPreferredInput
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__UserInputService__1 = game:GetService("UserInputService");
return function(u1) --[[ Name: trackPreferredInput, Line 3 ]]
    -- upvalues: l__UserInputService__1 (copy)
    u1(l__UserInputService__1.PreferredInput);
    return l__UserInputService__1:GetPropertyChangedSignal("PreferredInput"):Connect(function() --[[ Line: 6 ]]
        -- upvalues: u1 (copy), l__UserInputService__1 (ref)
        u1(l__UserInputService__1.PreferredInput);
    end);
end;