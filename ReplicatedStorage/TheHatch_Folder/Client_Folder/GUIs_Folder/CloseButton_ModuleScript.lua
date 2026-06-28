-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.CloseButton
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__UserInputService__1 = game:GetService("UserInputService");
local l__Sounds__2 = require(script.Parent.Sounds);
local l__trackPreferredInput__3 = require(script.Parent.trackPreferredInput);
local l__Maid__4 = require(script.Parent.Maid);
local l__spr__5 = require(script.Parent.spr);
local u1 = UDim2.fromOffset(86, 114);
local u2 = UDim.new(1, -128);
local u3 = {};
function u3.new(u4) --[[ Line: 33 ]]
    -- upvalues: l__Maid__4 (copy), u3 (copy), l__Sounds__2 (copy), l__spr__5 (copy)
    local v5 = {
        hovered = false,
        pressed = false,
        selected = false,
        instance = u4
    };
    local l__Parent__6 = u4.Parent;
    if l__Parent__6 then
        l__Parent__6 = u4.Parent:FindFirstChild("CloseRibbon");
    end;
    v5.tail = l__Parent__6;
    v5.window = u4:GetAttribute("Window");
    v5.maid = l__Maid__4.new();
    local u6 = setmetatable(v5, {
        __index = u3
    });
    u6.maid:Add(u4.Activated:Connect(function() --[[ Line: 44 ]]
        -- upvalues: u6 (copy)
        u6:close();
    end));
    u6.maid:Add(u4.MouseEnter:Connect(function() --[[ Line: 48 ]]
        -- upvalues: u6 (copy), l__Sounds__2 (ref)
        u6.hovered = true;
        u6:update();
        l__Sounds__2.play(l__Sounds__2.assets.hover);
    end));
    u6.maid:Add(u4.MouseLeave:Connect(function() --[[ Line: 54 ]]
        -- upvalues: u6 (copy)
        u6.hovered = false;
        u6.pressed = false;
        u6:update();
    end));
    u6.maid:Add(u4.SelectionGained:Connect(function() --[[ Line: 60 ]]
        -- upvalues: u6 (copy), l__Sounds__2 (ref)
        u6.selected = true;
        u6:update();
        l__Sounds__2.play(l__Sounds__2.assets.hover);
    end));
    u6.maid:Add(u4.SelectionLost:Connect(function() --[[ Line: 66 ]]
        -- upvalues: u6 (copy)
        u6.selected = false;
        u6:update();
    end));
    u6.maid:Add(u4.MouseButton1Down:Connect(function() --[[ Line: 71 ]]
        -- upvalues: u6 (copy)
        u6.pressed = true;
        u6:update();
    end));
    u6.maid:Add(u4.MouseButton1Up:Connect(function() --[[ Line: 76 ]]
        -- upvalues: u6 (copy)
        u6.pressed = false;
        u6:update();
    end));
    u6.maid:Add(function() --[[ Line: 81 ]]
        -- upvalues: l__spr__5 (ref), u4 (copy)
        l__spr__5.stop(u4);
    end);
    u6:update();
    u6:createGamepadShortcut();
    return u6;
end;
function u3.close(_) --[[ Line: 91 ]] end;
function u3.createGamepadShortcut(u7) --[[ Line: 101 ]]
    -- upvalues: l__UserInputService__1 (copy), l__trackPreferredInput__3 (copy)
    if u7.window == "None" then
    else
        local u8 = u7.maid:Add(Instance.new("ImageLabel"));
        u8.Image = l__UserInputService__1:GetImageForKeyCode(Enum.KeyCode.ButtonB);
        u8.BackgroundTransparency = 1;
        u8.AnchorPoint = Vector2.new(0.5, 0.5);
        u8.Position = UDim2.new(0.75, 0, 1, -36);
        u8.Size = UDim2.fromOffset(36, 36);
        u8.Visible = false;
        u8.Parent = u7.instance;
        u7.maid:Add(l__trackPreferredInput__3(function(p9) --[[ Line: 116 ]]
            -- upvalues: u8 (copy)
            u8.Visible = p9 == Enum.PreferredInput.Gamepad;
        end));
        u7.maid:Add(l__UserInputService__1.InputBegan:Connect(function(p10, p11) --[[ Line: 120 ]]
            -- upvalues: u7 (copy)
            if not p11 and p10.KeyCode == Enum.KeyCode.ButtonB then
                u7:close();
            end;
        end));
    end;
end;
function u3.update(p12) --[[ Line: 127 ]]
    -- upvalues: l__spr__5 (copy), u1 (copy), u2 (copy)
    local v13 = p12.hovered or p12.selected;
    l__spr__5.target(p12.instance, 0.6, 4, {
        Size = u1 + UDim2.fromOffset(0, v13 and not p12.pressed and 40 or 10)
    });
    l__spr__5.target(p12.instance.Glow, 1, 5, {
        ImageTransparency = p12.pressed and 0 or (v13 and 0.4 or 1)
    });
    if p12.tail then
        l__spr__5.target(p12.tail, 0.6, 4, {
            Position = UDim2.new(p12.tail.Position.X, u2 + UDim.new(0, v13 and not p12.pressed and -15 or 15))
        });
    end;
end;
function u3.Destroy(p14) --[[ Line: 148 ]]
    p14.maid:DoCleaning();
end;
return u3;