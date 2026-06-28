-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.AutoScale
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Maid__1 = require(script.Parent.Maid);
local u1 = {
    scale = 1
};
local u2 = {
    {
        w = 500,
        h = 250,
        scale = 0.5
    },
    {
        w = 600,
        h = 370,
        scale = 0.6666666666666666
    },
    {
        w = 750,
        h = 500,
        scale = 0.75
    },
    {
        w = 1000,
        h = 650,
        scale = 1
    },
    {
        w = 1800,
        h = 1300,
        scale = 1.5
    },
    {
        w = 3400,
        h = 1800,
        scale = 2
    }
};
local function u6(p3, p4) --[[ Line: 24 ]]
    -- upvalues: u2 (copy), u1 (copy)
    local l__scale__2 = u2[1].scale;
    for _, v5 in u2 do
        if p3.Y < v5.h or p3.X < v5.w then
            break;
        end;
        l__scale__2 = v5.scale;
    end;
    u1.scale = l__scale__2;
    if p4 then
        if l__scale__2 < 1 then
            return math.lerp(l__scale__2, 1 / l__scale__2, p4);
        end;
        l__scale__2 = 1;
    end;
    return l__scale__2;
end;
function u1.new(p7) --[[ Line: 43 ]]
    -- upvalues: l__Maid__1 (copy), u1 (copy)
    local v8 = {
        instance = p7,
        maid = l__Maid__1.new()
    };
    local u9 = setmetatable(v8, {
        __index = u1
    });
    u9.maid:Add(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() --[[ Line: 49 ]]
        -- upvalues: u9 (copy)
        u9:connect(workspace.CurrentCamera);
    end));
    u9:connect(workspace.CurrentCamera);
    return u9;
end;
function u1.connect(u10, u11) --[[ Line: 58 ]]
    -- upvalues: u6 (copy)
    if u11 then
        local u12 = u10.instance:GetAttribute("UndoDownscale");
        u10.maid.viewport = u11:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 65 ]]
            -- upvalues: u10 (copy), u6 (ref), u11 (copy), u12 (copy)
            u10.instance.Scale = u6(u11.ViewportSize, u12);
        end);
        u10.instance.Scale = u6(u11.ViewportSize, u12);
    end;
end;
function u1.Destroy(p13) --[[ Line: 72 ]]
    p13.maid:DoCleaning();
end;
return u1;