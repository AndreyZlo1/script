-- Roblox: Workspace.SilverAce293026.PlaneControl.InputModule
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("UserInputService");
game:GetService("RunService");
local l__ContextActionService__1 = game:GetService("ContextActionService");
local l__HttpService__2 = game:GetService("HttpService");
local l__BoundScheme__3 = require(script:WaitForChild("BoundScheme"));
l__BoundScheme__3.inputModule = v1;
local _ = {
    KeyCode = Enum.KeyCode:GetEnumItems(),
    InputType = Enum.UserInputType:GetEnumItems()
};
local u2 = {};
local u3 = {};
local function u17(u4) --[[ Line: 29 ]]
    -- upvalues: u2 (copy), l__ContextActionService__1 (copy)
    if u2[u4] then
        if u4 then
            if u4.Name then
                local v5 = "WTInputModule_" .. u4.Name;
                local u6 = u2[u4];
                local function u14(_, u7, p8) --[[ Line: 41 ]]
                    -- upvalues: u6 (copy), u4 (copy)
                    if u6 then
                        if u7 == Enum.UserInputState.Cancel then
                            u7 = Enum.UserInputState.End;
                        end;
                        local u9 = {
                            Input = u4,
                            State = u7,
                            Position = p8.Position,
                            Delta = p8.Delta,
                            Pressure = p8.Position.Z,
                            Pressed = u7 == Enum.UserInputState.Begin,
                            Unpressed = u7 == Enum.UserInputState.End
                        };
                        for _, v10 in u6 do
                            for _, u11 in v10 do
                                local v12, v13 = pcall(function() --[[ Line: 62 ]]
                                    -- upvalues: u11 (copy), u9 (copy), u7 (ref)
                                    u11(u9, u7);
                                end);
                                if not v12 and v13 then
                                    warn("Failed to call a bound scheme callback:", v13);
                                end;
                            end;
                        end;
                    end;
                end;
                if typeof(u4) == "Instance" then
                    if u4:IsA("GuiButton") then
                        u4.InputBegan:Connect(function(p15) --[[ Line: 75 ]]
                            -- upvalues: u14 (copy)
                            u14(nil, p15.UserInputState, p15);
                        end);
                        u4.InputEnded:Connect(function(p16) --[[ Line: 79 ]]
                            -- upvalues: u14 (copy)
                            u14(nil, p16.UserInputState, p16);
                        end);
                    end;
                else
                    l__ContextActionService__1:BindActionAtPriority(v5, u14, false, 1000000, u4);
                end;
            end;
        end;
    else
        warn("Will not create connection to ContextService without valid ContextBindings table entry");
    end;
end;
function v1.BindScheme(p18, p19) --[[ Line: 97 ]]
    -- upvalues: u3 (copy), l__BoundScheme__3 (copy), l__HttpService__2 (copy)
    if not u3[p18] then
        local v20 = l__BoundScheme__3.new(p18, l__HttpService__2:GenerateGUID(false), p19);
        u3[p18] = v20;
        return v20;
    end;
    warn("Cannot create duplicate BoundScheme with name", p18);
end;
function v1.UnbindScheme(p21) --[[ Line: 114 ]]
    -- upvalues: u3 (copy)
    if u3[p21] then
        u3[p21]:Dispose();
        u3[p21] = nil;
    else
        warn("Cannot unbind non-existent scheme with name", p21);
    end;
end;
function v1.GetBoundScheme(p22) --[[ Line: 124 ]]
    -- upvalues: u3 (copy)
    return u3[p22];
end;
function v1.BindToContext(p23, p24, p25) --[[ Line: 128 ]]
    -- upvalues: u2 (copy), u17 (copy)
    if not u2[p24] then
        u2[p24] = {};
        u17(p24);
    end;
    if not u2[p24][p23] then
        u2[p24][p23] = {};
    end;
    table.insert(u2[p24][p23], p25);
end;
function v1.UnbindFromContext(p26, p27) --[[ Line: 141 ]]
    -- upvalues: u2 (copy), l__ContextActionService__1 (copy)
    -- block 8
    if not u2[p27] then
        return;
    end;
    if not u2[p27][p26] then
        return;
    end;
    u2[p27][p26] = nil;
    local v28, v29, v30;
    v28, v29, v30 = u2[p27], nil, nil;
    local v31, v32, v33;
    if type(v28) == "function" then
        v31, v32 = v28(v29, v33);
    else
        v31, v32 = next(v28, v33);
    end;
    v33 = v31;
    -- block 1
    return;
end;
return v1;