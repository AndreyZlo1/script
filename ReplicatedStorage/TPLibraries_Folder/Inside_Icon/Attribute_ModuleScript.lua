-- Roblox: ReplicatedStorage.TPLibraries.Icon.Attribute
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

task.defer(function() --[[ Line: 21 ]]
    local l__RunService__1 = game:GetService("RunService");
    local l__VERSION__2 = require(script.Parent.VERSION);
    local v1 = l__VERSION__2.getAppVersion();
    local v2 = l__VERSION__2.getLatestVersion();
    local v3 = not l__VERSION__2.isUpToDate();
    if not l__RunService__1:IsStudio() then
        print((`🍍 Running TopbarPlus {v1} by @ForeverHD & HD Admin`));
    end;
    if v3 then
        warn((`A new version of TopbarPlus ({v2}) is available: https://devforum.roblox.com/t/topbarplus/1017485`));
    end;
end);
return {};