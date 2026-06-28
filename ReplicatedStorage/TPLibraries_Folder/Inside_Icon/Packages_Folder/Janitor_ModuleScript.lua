-- Roblox: ReplicatedStorage.TPLibraries.Icon.Packages.Janitor
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Heartbeat__1 = game:GetService("RunService").Heartbeat;
local u1 = newproxy(true);
getmetatable(u1).__tostring = function() --[[ Line: 31 ]]
    return "IndicesReference";
end;
local u2 = newproxy(true);
getmetatable(u2).__tostring = function() --[[ Line: 36 ]]
    return "LinkToInstanceIndex";
end;
local u3 = {
    IGNORE_MEMORY_DEBUG = true,
    ClassName = "Janitor",
    __index = {
        CurrentlyCleaning = true,
        [u1] = nil
    }
};
local u4 = {
    ["function"] = true,
    Promise = "cancel",
    RBXScriptConnection = "Disconnect"
};
function u3.new() --[[ Line: 58 ]]
    -- upvalues: u1 (copy), u3 (copy)
    return setmetatable({
        CurrentlyCleaning = false,
        [u1] = nil
    }, u3);
end;
function u3.Is(p5) --[[ Line: 65 ]]
    -- upvalues: u3 (copy)
    local v6;
    if type(p5) == "table" then
        v6 = getmetatable(p5) == u3;
    else
        v6 = false;
    end;
    return v6;
end;
u3.is = u3.Is;
function u3.__index.Add(p7, p8, p9, p10) --[[ Line: 71 ]]
    -- upvalues: u1 (copy), u4 (copy)
    if p10 then
        p7:Remove(p10);
        local v11 = p7[u1];
        if not v11 then
            v11 = {};
            p7[u1] = v11;
        end;
        v11[p10] = p8;
    end;
    local v12 = typeof(p8);
    local v13 = p9 or (u4[v12 == "table" and string.match(tostring(p8), "Promise") and "Promise" or v12] or "Destroy");
    if type(p8) ~= "function" and not p8[v13] then
        warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p8), tostring(v13), debug.traceback(nil, 2)));
    end;
    p7[p8] = { v13, (debug.traceback("")) };
    return p8;
end;
u3.__index.Give = u3.__index.Add;
function u3.__index.AddPromise(p14, u15) --[[ Line: 103 ]]
    local v16 = false;
    if not v16 then
        return u15;
    end;
    if not v16.is(u15) then
        error(string.format("Invalid argument #1 to \'Janitor:AddPromise\' (Promise expected, got %s (%s))", typeof(u15), (tostring(u15))));
    end;
    if u15:getStatus() ~= v16.Status.Started then
        return u15;
    end;
    local v17 = newproxy(false);
    local v20 = p14:Add(v16.new(function(p18, _, p19) --[[ Line: 111 ]]
        -- upvalues: u15 (copy)
        if p19(function() --[[ Line: 112 ]]
            -- upvalues: u15 (ref)
            u15:cancel();
        end) then
        else
            p18(u15);
        end;
    end), "cancel", v17);
    v20:finallyCall(p14.Remove, p14, v17);
    return v20;
end;
u3.__index.GivePromise = u3.__index.AddPromise;
function u3.__index.AddObject(p21, p22) --[[ Line: 133 ]]
    local v23 = newproxy(false);
    local v24 = false;
    if not (v24 and v24.is(p22)) then
        return p21:Add(p22, false, v23), v23;
    end;
    if p22:getStatus() ~= v24.Status.Started then
        return p22;
    end;
    local v25 = p21:Add(v24.resolve(p22), "cancel", v23);
    v25:finallyCall(p21.Remove, p21, v23);
    return v25, v23;
end;
u3.__index.GiveObject = u3.__index.AddObject;
function u3.__index.Remove(p26, p27) --[[ Line: 151 ]]
    -- upvalues: u1 (copy)
    local v28 = p26[u1];
    local v29 = v28 and v28[p27];
    if v29 then
        local v30 = p26[v29];
        if v30 then
            v30 = v30[1];
        end;
        if v30 then
            if v30 == true then
                v29();
            else
                local v31 = v29[v30];
                if v31 then
                    v31(v29);
                end;
            end;
            p26[v29] = nil;
        end;
        v28[p27] = nil;
    end;
    return p26;
end;
function u3.__index.Get(p32, p33) --[[ Line: 180 ]]
    -- upvalues: u1 (copy)
    local v34 = p32[u1];
    if v34 then
        return v34[p33];
    else
        return nil;
    end;
end;
function u3.__index.Cleanup(p35) --[[ Line: 188 ]]
    -- upvalues: u1 (copy)
    if not p35.CurrentlyCleaning then
        p35.CurrentlyCleaning = nil;
        for v36, v37 in next, p35 do
            if v36 ~= u1 then
                local v38 = type(v36);
                if v38 == "string" or v38 == "number" then
                    p35[v36] = nil;
                else
                    local v39 = v37[1];
                    local v40 = v37[2];
                    if v39 == true then
                        local v41, v42 = pcall(v36);
                        if not v41 then
                            local v43 = debug.traceback("", 3);
                            warn("-------- Janitor Error --------" .. "\n" .. tostring(v42) .. "\n" .. v43 .. "" .. v40);
                        end;
                    else
                        local v44 = v36[v39];
                        if v44 then
                            local v45, v46 = pcall(v44, v36);
                            local v47;
                            if typeof(v36) == "Instance" then
                                v47 = v44 == "Destroy";
                            else
                                v47 = false;
                            end;
                            if not (v45 or v47) then
                                local v48 = debug.traceback("", 3);
                                warn("-------- Janitor Error --------" .. "\n" .. tostring(v46) .. "\n" .. v48 .. "" .. v40);
                            end;
                        end;
                    end;
                    p35[v36] = nil;
                end;
            end;
        end;
        local v49 = p35[u1];
        if v49 then
            for v50 in next, v49 do
                v49[v50] = nil;
            end;
            p35[u1] = {};
        end;
        p35.CurrentlyCleaning = false;
    end;
end;
u3.__index.Clean = u3.__index.Cleanup;
function u3.__index.Destroy(p51) --[[ Line: 244 ]]
    p51:Cleanup();
end;
u3.__call = u3.__index.Cleanup;
local u52 = {
    Connected = true
};
u52.__index = u52;
function u52.Disconnect(p53) --[[ Line: 254 ]]
    if p53.Connected then
        p53.Connected = false;
        p53.Connection:Disconnect();
    end;
end;
function u52.__tostring(p54) --[[ Line: 261 ]]
    return "Disconnect<" .. tostring(p54.Connected) .. ">";
end;
function u3.__index.LinkToInstance(u55, p56, p57) --[[ Line: 265 ]]
    -- upvalues: u2 (copy), u52 (copy), l__Heartbeat__1 (copy)
    local u58 = nil;
    local v59 = p57 and newproxy(false) or u2;
    local u60 = p56.Parent == nil;
    local u61 = setmetatable({}, u52);
    local u63 = p56.AncestryChanged:Connect(function(_, p62) --[[ Name: ChangedFunction, Line 271 ]]
        -- upvalues: u61 (copy), u60 (ref), l__Heartbeat__1 (ref), u58 (ref), u55 (copy)
        u60 = u61.Connected and p62 == nil;
        if u60 then
            coroutine.wrap(function() --[[ Line: 277 ]]
                -- upvalues: l__Heartbeat__1 (ref), u61 (ref), u58 (ref), u55 (ref), u60 (ref)
                l__Heartbeat__1:Wait();
                if u61.Connected then
                    if u58.Connected then
                        while u60 and (u58.Connected and u61.Connected) do
                            l__Heartbeat__1:Wait();
                        end;
                        if u61.Connected and u60 then
                            u55:Cleanup();
                        end;
                    else
                        u55:Cleanup();
                    end;
                end;
            end)();
        end;
    end);
    u61.Connection = u63;
    if u60 then
        local l__Parent__2 = p56.Parent;
        if u61.Connected then
            if l__Parent__2 == nil then
                u60 = true;
            else
                u60 = false;
            end;
            if u60 then
                coroutine.wrap(function() --[[ Line: 277 ]]
                    -- upvalues: l__Heartbeat__1 (ref), u61 (copy), u63 (ref), u55 (copy), u60 (ref)
                    l__Heartbeat__1:Wait();
                    if u61.Connected then
                        if u63.Connected then
                            while u60 and (u63.Connected and u61.Connected) do
                                l__Heartbeat__1:Wait();
                            end;
                            if u61.Connected and u60 then
                                u55:Cleanup();
                            end;
                        else
                            u55:Cleanup();
                        end;
                    end;
                end)();
            end;
        end;
    end;
    return u55:Add(u61, "Disconnect", v59);
end;
function u3.__index.LinkToInstances(p64, ...) --[[ Line: 308 ]]
    -- upvalues: u3 (copy)
    local v65 = u3.new();
    for _, v66 in ipairs({ ... }) do
        v65:Add(p64:LinkToInstance(v66, true), "Disconnect");
    end;
    return v65;
end;
for v67, v68 in next, u3.__index do
    local v69 = string.lower(v67);
    local v70 = string.sub(v69, 1, 1) .. string.sub(v67, 2);
    u3.__index[v70] = v68;
end;
return u3;