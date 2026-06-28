-- Roblox: ReplicatedStorage.TPLibraries.Icon.Packages.GoodSignal
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = nil;
local function u4(p2, ...) --[[ Line: 34 ]]
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;
local function u5() --[[ Line: 45 ]]
    -- upvalues: u4 (copy)
    while true do
        u4(coroutine.yield());
    end;
end;
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8) --[[ Line: 60 ]]
    -- upvalues: u6 (copy)
    return setmetatable({
        _connected = true,
        _next = false,
        _signal = p7,
        _fn = p8
    }, u6);
end;
function u6.Disconnect(p9) --[[ Line: 69 ]]
    p9._connected = false;
    if p9._signal._handlerListHead == p9 then
        p9._signal._handlerListHead = p9._next;
    else
        local l___handlerListHead__1 = p9._signal._handlerListHead;
        while l___handlerListHead__1 and l___handlerListHead__1._next ~= p9 do
            l___handlerListHead__1 = l___handlerListHead__1._next;
        end;
        if l___handlerListHead__1 then
            l___handlerListHead__1._next = p9._next;
        end;
    end;
end;
u6.Destroy = u6.Disconnect;
setmetatable(u6, {
    __index = function(_, p10) --[[ Name: __index, Line 92 ]]
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p10))), 2);
    end,
    __newindex = function(_, p11, _) --[[ Name: __newindex, Line 95 ]]
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p11))), 2);
    end
});
local u12 = {};
u12.__index = u12;
function u12.new() --[[ Line: 104 ]]
    -- upvalues: u12 (copy)
    return setmetatable({
        _handlerListHead = false
    }, u12);
end;
function u12.Connect(p13, p14) --[[ Line: 110 ]]
    -- upvalues: u6 (copy)
    local v15 = u6.new(p13, p14);
    if not p13._handlerListHead then
        p13._handlerListHead = v15;
        return v15;
    end;
    v15._next = p13._handlerListHead;
    p13._handlerListHead = v15;
    return v15;
end;
function u12.DisconnectAll(p16) --[[ Line: 123 ]]
    p16._handlerListHead = false;
end;
u12.Destroy = u12.DisconnectAll;
function u12.Fire(p17, ...) --[[ Line: 132 ]]
    -- upvalues: u1 (ref), u5 (copy)
    local l___handlerListHead__2 = p17._handlerListHead;
    while l___handlerListHead__2 do
        if l___handlerListHead__2._connected then
            if not u1 then
                u1 = coroutine.create(u5);
                coroutine.resume(u1);
            end;
            task.spawn(u1, l___handlerListHead__2._fn, ...);
        end;
        l___handlerListHead__2 = l___handlerListHead__2._next;
    end;
end;
function u12.Wait(p18) --[[ Line: 149 ]]
    local u19 = coroutine.running();
    local u20 = nil;
    u20 = p18:Connect(function(...) --[[ Line: 152 ]]
        -- upvalues: u20 (ref), u19 (copy)
        u20:Disconnect();
        task.spawn(u19, ...);
    end);
    return coroutine.yield();
end;
function u12.Once(p21, u22) --[[ Line: 161 ]]
    local u23 = nil;
    u23 = p21:Connect(function(...) --[[ Line: 163 ]]
        -- upvalues: u23 (ref), u22 (copy)
        if u23._connected then
            u23:Disconnect();
        end;
        u22(...);
    end);
    return u23;
end;
setmetatable(u12, {
    __index = function(_, p24) --[[ Name: __index, Line 174 ]]
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p24))), 2);
    end,
    __newindex = function(_, p25, _) --[[ Name: __newindex, Line 177 ]]
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p25))), 2);
    end
});
return u12;