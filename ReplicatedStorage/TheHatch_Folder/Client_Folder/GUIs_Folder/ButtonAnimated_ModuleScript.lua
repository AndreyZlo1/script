-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.ButtonAnimated
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Sounds__1 = require(script.Parent.Sounds);
local l__Maid__2 = require(script.Parent.Maid);
local l__Theme__3 = require(script.Parent.Theme);
local l__spr__4 = require(script.Parent.spr);
local l__AutoScale__5 = require(script.Parent.AutoScale);
local u1 = {};
function u1.new(u2) --[[ Line: 32 ]]
    -- upvalues: l__Maid__2 (copy), u1 (copy), l__Sounds__1 (copy), l__spr__4 (copy)
    local v3 = {
        hovered = false,
        selected = false,
        instance = u2,
        highlight = u2.Animated.Box:Clone(),
        maid = l__Maid__2.new()
    };
    local u4 = setmetatable(v3, {
        __index = u1
    });
    u4.maid:Add(u2.MouseEnter:Connect(function() --[[ Line: 41 ]]
        -- upvalues: u4 (copy), l__Sounds__1 (ref)
        u4.hovered = true;
        u4:update();
        l__Sounds__1.play(l__Sounds__1.assets.hover);
    end));
    u4.maid:Add(u2.MouseLeave:Connect(function() --[[ Line: 47 ]]
        -- upvalues: u4 (copy)
        u4.hovered = false;
        u4:update();
    end));
    u4.maid:Add(u2.SelectionGained:Connect(function() --[[ Line: 52 ]]
        -- upvalues: u4 (copy), l__Sounds__1 (ref)
        u4.selected = true;
        u4:update();
        l__Sounds__1.play(l__Sounds__1.assets.hover);
    end));
    u4.maid:Add(u2.SelectionLost:Connect(function() --[[ Line: 58 ]]
        -- upvalues: u4 (copy)
        u4.selected = false;
        u4:update();
    end));
    u4.maid:Add(u2.Activated:Connect(function() --[[ Line: 63 ]]
        -- upvalues: u4 (copy), u2 (copy), l__Sounds__1 (ref)
        u4:update(true);
        if string.find(string.lower(u2.Name), "egg") then
            l__Sounds__1.play(l__Sounds__1.assets.eggButton);
        else
            l__Sounds__1.play(u2:GetAttribute("ClickSound") or l__Sounds__1.assets.click);
        end;
    end));
    u4.maid:Add(u2:GetAttributeChangedSignal("Pressed"):Connect(function() --[[ Line: 73 ]]
        -- upvalues: u2 (copy), u4 (copy), l__Sounds__1 (ref)
        if u2:GetAttribute("Pressed") then
            u2:SetAttribute("Pressed", nil);
            u4:update(true);
            l__Sounds__1.play(l__Sounds__1.assets.click);
        end;
    end));
    u4.maid:Add(function() --[[ Line: 81 ]]
        -- upvalues: l__spr__4 (ref), u2 (copy)
        l__spr__4.stop(u2);
    end);
    u4.maid:Add(u4.highlight);
    u4:prepareHighlight();
    u4:update();
    return u4;
end;
function u1.update(p5, p6) --[[ Line: 93 ]]
    -- upvalues: l__AutoScale__5 (copy), l__spr__4 (copy)
    local v7 = p5.hovered or p5.selected;
    local v8 = p5.instance.AbsoluteSize / l__AutoScale__5.scale;
    local v9 = not v7 and 0 or math.min(v8.X, v8.Y) * 0.15 // 2 * 2;
    l__spr__4.target(p5.instance.Animated, 0.7, 6, {
        Size = UDim2.new(1, v9, 1, v9)
    });
    if v7 then
        l__spr__4.target(p5.highlight, 1, 4, {
            BackgroundTransparency = 1
        });
        l__spr__4.setVelocity(p5.highlight, {
            BackgroundTransparency = -50
        });
    end;
    if p6 then
        l__spr__4.setVelocity(p5.instance.Animated, {
            Size = UDim2.fromOffset(v9 * -100, v9 * -100)
        });
    end;
end;
function u1.prepareHighlight(u10) --[[ Line: 121 ]]
    -- upvalues: l__Theme__3 (copy)
    if u10.highlight:FindFirstChild("UIStroke") then
        u10.highlight:FindFirstChild("UIStroke"):Destroy();
    end;
    local l__Box__6 = u10.instance.Animated.Box;
    u10.highlight.BackgroundColor3 = l__Theme__3.plusLighter(l__Box__6.BackgroundColor3, 0.25);
    u10.highlight.BackgroundTransparency = 1;
    u10.highlight.Size = UDim2.fromScale(1, 1);
    u10.highlight.Parent = l__Box__6;
    u10.maid:Add(l__Box__6:GetPropertyChangedSignal("BackgroundColor3"):Connect(function() --[[ Line: 133 ]]
        -- upvalues: u10 (copy), l__Theme__3 (ref), l__Box__6 (copy)
        u10.highlight.BackgroundColor3 = l__Theme__3.plusLighter(l__Box__6.BackgroundColor3, 0.25);
    end));
end;
function u1.Destroy(p11) --[[ Line: 138 ]]
    p11.maid:DoCleaning();
end;
return u1;