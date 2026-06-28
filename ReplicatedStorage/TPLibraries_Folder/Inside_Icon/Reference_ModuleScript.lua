-- Roblox: ReplicatedStorage.TPLibraries.Icon.Reference
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = {
    objectName = "TopbarPlusReference"
};
function u1.addToReplicatedStorage() --[[ Line: 10 ]]
    -- upvalues: l__ReplicatedStorage__1 (copy), u1 (copy)
    if l__ReplicatedStorage__1:FindFirstChild(u1.objectName) then
        return false;
    end;
    local v2 = Instance.new("ObjectValue");
    v2.Name = u1.objectName;
    v2.Value = script.Parent;
    v2.Parent = l__ReplicatedStorage__1;
    return v2;
end;
function u1.getObject() --[[ Line: 22 ]]
    -- upvalues: l__ReplicatedStorage__1 (copy), u1 (copy)
    return l__ReplicatedStorage__1:FindFirstChild(u1.objectName) or false;
end;
return u1;