-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.Maid
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {
    ClassName = "Maid"
};
function u1.new() --[[ Line: 39 ]]
    -- upvalues: u1 (copy)
    return setmetatable({
        _tasks = {}
    }, u1);
end;
function u1.isMaid(p2) --[[ Line: 56 ]]
    local v3;
    if type(p2) == "table" then
        v3 = p2.ClassName == "Maid";
    else
        v3 = false;
    end;
    return v3;
end;
function u1.__index(p4, p5) --[[ Line: 75 ]]
    -- upvalues: u1 (copy)
    if u1[p5] then
        return u1[p5];
    else
        return p4._tasks[p5];
    end;
end;
function u1.__newindex(p6, p7, p8) --[[ Line: 102 ]]
    -- upvalues: u1 (copy)
    if u1[p7] ~= nil then
        error(("Cannot use \'%s\' as a Maid key"):format((tostring(p7))), 2);
    end;
    local l___tasks__1 = p6._tasks;
    local u9 = l___tasks__1[p7];
    if u9 == p8 then
    else
        l___tasks__1[p7] = p8;
        if u9 then
            if type(u9) == "function" then
                u9();
                return;
            end;
            if type(u9) == "thread" then
                local v10;
                if coroutine.running() == u9 then
                    v10 = nil;
                else
                    v10 = pcall(function() --[[ Line: 122 ]]
                        -- upvalues: u9 (copy)
                        task.cancel(u9);
                    end);
                end;
                if not v10 then
                    task.defer(function() --[[ Line: 128 ]]
                        -- upvalues: u9 (copy)
                        task.cancel(u9);
                    end);
                end;
            else
                if typeof(u9) == "RBXScriptConnection" then
                    u9:Disconnect();
                    return;
                end;
                if u9.Destroy then
                    u9:Destroy();
                end;
            end;
        end;
    end;
end;
function u1.Add(p11, p12) --[[ Line: 146 ]]
    if not p12 then
        error("Task cannot be false or nil", 2);
    end;
    p11[#p11._tasks + 1] = p12;
    if type(p12) == "table" and not p12.Destroy then
        warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback());
    end;
    return p12;
end;
function u1.GiveTask(p13, p14) --[[ Line: 166 ]]
    if not p14 then
        error("Task cannot be false or nil", 2);
    end;
    local v15 = #p13._tasks + 1;
    p13[v15] = p14;
    if type(p14) == "table" and not p14.Destroy then
        warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback());
    end;
    return v15;
end;
function u1.GivePromise(u16, p17) --[[ Line: 187 ]]
    if not p17:IsPending() then
        return p17;
    end;
    local v18 = p17.resolved(p17);
    local u19 = u16:GiveTask(v18);
    v18:Finally(function() --[[ Line: 196 ]]
        -- upvalues: u16 (copy), u19 (copy)
        u16[u19] = nil;
    end);
    return v18;
end;
function u1.DoCleaning(p20) --[[ Line: 219 ]]
    local l___tasks__2 = p20._tasks;
    for v21, v22 in pairs(l___tasks__2) do
        if typeof(v22) == "RBXScriptConnection" then
            l___tasks__2[v21] = nil;
            v22:Disconnect();
        end;
    end;
    local v23, u24 = next(l___tasks__2);
    while u24 ~= nil do
        l___tasks__2[v23] = nil;
        if type(u24) == "function" then
            u24();
        elseif type(u24) == "thread" then
            local v25;
            if coroutine.running() == u24 then
                v25 = nil;
            else
                v25 = pcall(function() --[[ Line: 239 ]]
                    -- upvalues: u24 (ref)
                    task.cancel(u24);
                end);
            end;
            if not v25 then
                task.defer(function() --[[ Line: 246 ]]
                    -- upvalues: u24 (copy)
                    task.cancel(u24);
                end);
            end;
        elseif typeof(u24) == "RBXScriptConnection" then
            u24:Disconnect();
        elseif u24.Destroy then
            u24:Destroy();
        end;
        v23, u24 = next(l___tasks__2);
    end;
end;
u1.Destroy = u1.DoCleaning;
return u1;