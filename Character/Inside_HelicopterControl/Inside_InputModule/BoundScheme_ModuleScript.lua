-- Roblox: Workspace.SilverAce293026.HelicopterControl.InputModule.BoundScheme
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
game:GetService("ContextActionService");
local l__RunService__1 = game:GetService("RunService");
local l__Players__2 = game:GetService("Players");
game:GetService("UserInputService");
local l__CustomMobileGui__3 = l__Players__2.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CustomMobileGui");
local l__LeftHeliFrame__4 = l__CustomMobileGui__3:WaitForChild("LeftHeliFrame");
local l__RightHeliFrame__5 = l__CustomMobileGui__3:WaitForChild("RightHeliFrame");
local function u7(p2, p3) --[[ Line: 17 ]]
    for _, v4 in p2 do
        for _, v5 in v4.Bindings do
            for _, v6 in v5 do
                p3(v6);
            end;
        end;
    end;
end;
function u1.new(p8, p9, p10) --[[ Line: 28 ]]
    -- upvalues: u1 (copy), l__RunService__1 (copy), l__LeftHeliFrame__4 (copy), l__RightHeliFrame__5 (copy)
    local u11 = setmetatable({}, u1);
    u11.schemeName = p8;
    u11.scheme = p10;
    u11.subscriptions = {};
    u11.repeaters = {};
    u11.guid = p9;
    local l__inputModule__6 = u1.inputModule;
    for u12, v13 in u11.scheme do
        local u14 = {};
        local u15 = {};
        local u16 = {};
        local l__RepeatingBindings__7 = v13.RepeatingBindings;
        local function v23(u17, p18) --[[ Line: 44 ]]
            -- upvalues: u11 (copy), u12 (copy), u15 (copy), u14 (copy), u16 (copy), l__RunService__1 (ref)
            if u11.subscriptions[u12] then
                if type(u17.Input == "userdata") and (typeof(u17.Input) == "Instance" and u17.Input:IsA("GuiButton")) then
                    u17.Input = u17.Input.Name;
                end;
                if table.find(u15, u17.Input) then
                    u17.AnalogValue = p18 == Enum.UserInputState.End and 0 or 1;
                end;
                if table.find(u14, u17.Input) then
                    u17.Pressure = -u17.Pressure;
                    if u17.AnalogValue then
                        u17.AnalogValue = -u17.AnalogValue;
                    end;
                end;
                if table.find(u16, u17.Input) then
                    if not u11.repeaters[u12] then
                        u11.repeaters[u12] = {};
                    end;
                    if not u11.repeaters[u12][u17.Input] then
                        u11.repeaters[u12][u17.Input] = {
                            Connection = l__RunService__1.RenderStepped:Connect(function() --[[ Line: 74 ]]
                                -- upvalues: u11 (ref), u12 (ref), u17 (copy)
                                local v19 = u11.repeaters[u12][u17.Input];
                                if v19.Context then
                                    for _, v20 in u11.subscriptions[u12] do
                                        v20(v19.Context, v19.Context.State);
                                    end;
                                end;
                            end)
                        };
                    end;
                    u11.repeaters[u12][u17.Input].Context = u17;
                    l__RunService__1.RenderStepped:Wait();
                    if p18 == Enum.UserInputState.End then
                        local v21 = u11.repeaters[u12][u17.Input];
                        v21.Connection:Disconnect();
                        v21.Connection = nil;
                        v21.Context = nil;
                        u11.repeaters[u12][u17.Input] = nil;
                    end;
                else
                    for _, v22 in u11.subscriptions[u12] do
                        v22(u17, p18);
                    end;
                end;
            end;
        end;
        for v24, v25 in v13.Bindings do
            for _, v27 in v25 do
                if string.find(v24, "PC") or string.find(v24, "Mobile") then
                    table.insert(u15, v27);
                end;
                if string.find(v24, "Flipped") then
                    table.insert(u14, v27);
                end;
                if l__RepeatingBindings__7 and table.find(l__RepeatingBindings__7, v24) then
                    table.insert(u16, v27);
                end;
                if string.find(v24, "Mobile") then
                    local v27 = l__LeftHeliFrame__4.Buttons:FindFirstChild(v27) or l__RightHeliFrame__5.Buttons[v27];
                end;
                l__inputModule__6.BindToContext(u11.guid, v27, v23);
            end;
        end;
    end;
    return u11;
end;
function u1.SubscribeToControl(p28, p29, p30) --[[ Line: 141 ]]
    if not p28.subscriptions[p29] then
        p28.subscriptions[p29] = {};
    end;
    table.insert(p28.subscriptions[p29], p30);
end;
function u1.Dispose(u31) --[[ Line: 149 ]]
    -- upvalues: u1 (copy), u7 (copy)
    local l__inputModule__8 = u1.inputModule;
    u7(u31.scheme, function(p32) --[[ Line: 151 ]]
        -- upvalues: l__inputModule__8 (copy), u31 (copy)
        l__inputModule__8.UnbindFromContext(u31.guid, p32);
    end);
    for _, v33 in u31.repeaters do
        for _, v34 in v33 do
            if v34.Connection then
                v34.Connection:Disconnect();
                v34.Connection = nil;
            end;
            v34.Context = nil;
        end;
    end;
    u31.repeaters = nil;
end;
return u1;