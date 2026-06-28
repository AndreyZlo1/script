-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.DevHint
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Maid__1 = require(script.Parent:WaitForChild("Maid"));
local l__AutoScale__2 = require(script.Parent:WaitForChild("AutoScale"));
local l__spr__3 = require(script.Parent:WaitForChild("spr"));
local u1 = {};
function u1.new(p2) --[[ Line: 30 ]]
    -- upvalues: l__Maid__1 (copy), u1 (copy)
    local v3 = {
        hovered = false,
        pressed = false,
        instance = p2,
        maid = l__Maid__1.new()
    };
    local v4 = setmetatable(v3, {
        __index = u1
    });
    v4:init();
    return v4;
end;
function u1.show(p5, p6) --[[ Line: 43 ]]
    -- upvalues: l__spr__3 (copy)
    p5.instance.Frame.Content.Label.Text = `Hunting for eggs?\n<font transparency="0.25" size="22">{p6}</font>`;
    p5.instance.Frame.Visible = true;
    l__spr__3.target(p5.instance.Frame, 0.8, 2, {
        Position = UDim2.new(1, -16, 1, -16)
    });
    p5.maid.hide = nil;
end;
function u1.hide(u7) --[[ Line: 54 ]]
    -- upvalues: l__spr__3 (copy)
    l__spr__3.target(u7.instance.Frame, 0.8, 2, {
        Position = UDim2.new(1, 500, 1, -16)
    });
    u7.maid.hide = task.delay(1, function() --[[ Line: 59 ]]
        -- upvalues: u7 (copy)
        u7.instance.Frame.Visible = false;
    end);
end;
function u1.updateBounds(p8) --[[ Line: 64 ]]
    -- upvalues: l__AutoScale__2 (copy)
    local l__Frame__4 = p8.instance.Frame;
    local v9 = l__Frame__4.Content.Label.TextBounds / l__AutoScale__2.scale;
    l__Frame__4.Size = UDim2.fromOffset(math.max(v9.X + 48, 330), v9.Y + 48);
    l__Frame__4.Content.Grooves.Visible = v9.Y > 82;
end;
function u1.input(p10, p11, p12) --[[ Line: 72 ]]
    -- upvalues: l__spr__3 (copy)
    if p11 == nil then
        p11 = p10.hovered;
    end;
    if p12 == nil then
        p12 = p10.pressed;
    end;
    if p11 == p10.hovered and p12 == p10.pressed then
    else
        local l__target__5 = l__spr__3.target;
        local l__Content__6 = p10.instance.Frame.Content;
        local v13 = 0.7;
        local v14 = 6;
        local v15 = {};
        local v16;
        if p11 and not p12 then
            v16 = UDim2.new(1, 16, 1, 16);
        else
            v16 = UDim2.fromScale(1, 1);
        end;
        v15.Size = v16;
        l__target__5(l__Content__6, v13, v14, v15);
        if p12 and not p10.pressed then
            l__spr__3.target(p10.instance.Frame.Content, 0.5, 6, {
                Position = UDim2.fromScale(0.5, 0.5)
            });
            l__spr__3.setVelocity(p10.instance.Frame.Content, {
                Size = UDim2.fromOffset(-2000, -2000),
                Position = UDim2.fromScale(0, 6)
            });
        end;
        p10.hovered = p11;
        p10.pressed = p12;
    end;
end;
function u1.init(u17) --[[ Line: 96 ]]
    local l__Content__7 = u17.instance.Frame.Content;
    u17.maid:GiveTask(l__Content__7.Label:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ Line: 99 ]]
        -- upvalues: u17 (copy)
        u17:updateBounds();
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.Activated:Connect(function() --[[ Line: 103 ]]
        -- upvalues: u17 (copy)
        u17:hide();
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.MouseButton1Down:Connect(function() --[[ Line: 107 ]]
        -- upvalues: u17 (copy)
        u17:input(nil, true);
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.MouseButton1Up:Connect(function() --[[ Line: 111 ]]
        -- upvalues: u17 (copy)
        u17:input(nil, false);
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.MouseEnter:Connect(function() --[[ Line: 115 ]]
        -- upvalues: u17 (copy)
        u17:input(true, nil);
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.MouseLeave:Connect(function() --[[ Line: 119 ]]
        -- upvalues: u17 (copy)
        u17:input(false, false);
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.SelectionGained:Connect(function() --[[ Line: 123 ]]
        -- upvalues: u17 (copy)
        u17:input(true, nil);
    end));
    u17.maid:GiveTask(l__Content__7.ClickableArea.SelectionLost:Connect(function() --[[ Line: 127 ]]
        -- upvalues: u17 (copy)
        u17:input(false, false);
    end));
    u17.instance.Frame.Visible = false;
    u17.instance.Frame.Position = UDim2.new(1, 500, 1, -16);
end;
function u1.Destroy(p18) --[[ Line: 135 ]]
    p18.maid:DoCleaning();
end;
return u1;