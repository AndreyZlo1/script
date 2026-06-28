-- Roblox: ReplicatedStorage._TheHatch.Shared.Characters
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__CollectionService__1 = game:GetService("CollectionService");
return {
    getCharacterModel = function(p1) --[[ Name: getCharacterModel, Line 9 ]]
        -- upvalues: l__CollectionService__1 (copy)
        local v2 = l__CollectionService__1:GetTagged((`HatchCharacterOverride_{p1.UserId}`));
        if #v2 == 0 then
            return p1.Character;
        end;
        for _, v3 in v2 do
            if v3:IsA("Model") then
                return v3;
            end;
        end;
        return nil;
    end
};