-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.HatchingGui
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__Sounds__3 = require(script.Parent.Sounds);
local l__Maid__4 = require(script.Parent.Maid);
local l__EggData__5 = require(script.Parent.EggData);
local l__Theme__6 = require(script.Parent.Theme);
local l__Tween__7 = require(script.Parent.Tween);
local l__spr__8 = require(script.Parent.spr);
local l__trackPreferredInput__9 = require(script.Parent.trackPreferredInput);
local u1 = {};
local l__Sine__10 = Enum.EasingStyle.Sine;
local l__Quint__11 = Enum.EasingStyle.Quint;
local l__Out__12 = Enum.EasingDirection.Out;
local l__InOut__13 = Enum.EasingDirection.InOut;
local u2 = nil;
local u3 = 1;
function u1.playAnimation(p4, p5, p6) --[[ Line: 72 ]]
    -- upvalues: l__EggData__5 (copy), u2 (ref)
    local v7 = l__EggData__5.eggs[p4];
    local v8 = `Invalid category index {p4}`;
    assert(v7, v8);
    local v9 = l__EggData__5.eggs[p4][p5];
    local v10 = `Invalid egg index {p5}`;
    assert(v9, v10);
    if not u2 then
        return false;
    end;
    local v11 = not u2.locked;
    table.insert(u2.queue, {
        categoryIndex = p4,
        eggIndex = p5,
        amount = p6 or 1
    });
    u2:play();
    return v11;
end;
function u1.cancelAnimation() --[[ Line: 94 ]]
    -- upvalues: u2 (ref)
    if u2 then
        u2:clear();
    end;
end;
function u1.overrideAnimation(p12) --[[ Line: 102 ]]
    -- upvalues: u2 (ref)
    if u2 then
        u2.override = true;
        task.delay(p12 or 0.2, function() --[[ Line: 106 ]]
            -- upvalues: u2 (ref)
            u2.override = false;
            u2:clear();
        end);
        u2:clear();
    end;
end;
function u1.new(u13) --[[ Line: 115 ]]
    -- upvalues: l__Maid__4 (copy), u1 (copy), l__spr__8 (ref), l__trackPreferredInput__9 (copy), l__UserInputService__2 (copy), u3 (ref), l__Sounds__3 (copy), l__Tween__7 (copy), l__Sine__10 (copy), l__InOut__13 (copy), u2 (ref)
    local v14 = {
        locked = false,
        override = false,
        instance = u13,
        queue = {},
        maid = l__Maid__4.new()
    };
    local u15 = setmetatable(v14, {
        __index = u1
    });
    if not l__spr__8.setVelocity then
        warn("[HatchingGui] spr module is missing \'setVelocity\' function");
        l__spr__8 = table.clone(l__spr__8);
        function l__spr__8.setVelocity() --[[ Line: 129 ]] end;
    end;
    u15.maid:GiveTask(l__trackPreferredInput__9(function(p16) --[[ Line: 132 ]]
        -- upvalues: u13 (copy)
        if p16 == Enum.PreferredInput.Touch then
            u13.SpeedUp.Text = "Tap anywhere to speed up";
        elseif p16 == Enum.PreferredInput.Gamepad then
            u13.SpeedUp.Text = "Press A on your controller to speed up";
        else
            if p16 == Enum.PreferredInput.KeyboardAndMouse then
                u13.SpeedUp.Text = "Press SPACE or click to speed up";
            end;
        end;
    end));
    u15.maid:GiveTask(l__UserInputService__2.InputBegan:Connect(function(p17, p18) --[[ Line: 142 ]]
        -- upvalues: u15 (copy), u3 (ref), l__Sounds__3 (ref), l__Tween__7 (ref), u13 (copy), l__Sine__10 (ref), l__InOut__13 (ref)
        if u15.locked then
            if p17.KeyCode == Enum.KeyCode.Space and not p18 or (p17.UserInputType == Enum.UserInputType.MouseButton1 and not p18 or (p17.UserInputType == Enum.UserInputType.Touch and not p18 or p17.KeyCode == Enum.KeyCode.ButtonA)) then
                u3 = 0.25;
                l__Sounds__3.configure(l__Sounds__3.assets.eggPlusOne, {
                    speed = 4,
                    volume = 0.2
                });
                l__Tween__7(u13.SpeedUp, { "TextTransparency" }, { 1 }, 0.5, l__Sine__10, l__InOut__13);
            end;
        end;
    end));
    u13.Enabled = false;
    u2 = u15;
    return u15;
end;
function u1.play(u19) --[[ Line: 165 ]]
    -- upvalues: u3 (ref), l__Sounds__3 (copy), l__RunService__1 (copy)
    if u19.queue[1] then
        if u19.locked or u19.override then
        else
            u19.locked = true;
            u19:prepare();
            u19.maid.heartbeat = l__RunService__1.Heartbeat:Connect(function(p20) --[[ Line: 178 ]]
                -- upvalues: u19 (copy)
                local l__SunRays__14 = u19.instance.SunRays;
                l__SunRays__14.Rotation = l__SunRays__14.Rotation + p20 * 45;
                local l__HalftoneGradient__15 = u19.instance.HalftoneGradient;
                local v21 = os.clock() / 3;
                l__HalftoneGradient__15.Rotation = math.sin(v21) * 8;
            end);
            u19.maid.thread = task.spawn(function() --[[ Line: 183 ]]
                -- upvalues: u19 (copy), u3 (ref)
                local v22, v23 = pcall(function() --[[ Line: 184 ]]
                    -- upvalues: u19 (ref), u3 (ref)
                    u19:transitionIn();
                    task.wait(u3 * 0.75);
                    u19:transitionSubtleVisuals();
                    task.wait(u3 * 0.5);
                    u19:explode();
                    u19:showPlusOne();
                    task.wait(u3 * 0.75);
                    u19:showTitle();
                    task.wait(u3 * 0.25);
                    u19:showRarity();
                    task.wait(u3 * 1.25);
                    u19:transitionOut();
                    task.wait(u3 * 0.75);
                end);
                u19:stop();
                if not v22 then
                    warn((`[HatchingGui] Error during animation: {v23}`));
                end;
            end);
            table.remove(u19.queue, 1);
            l__Sounds__3.playStoppable(l__Sounds__3.assets.eggPlusOne);
        end;
    else
        u3 = 1;
        l__Sounds__3.configure(l__Sounds__3.assets.eggPlusOne, {
            speed = 1,
            volume = 0.5
        });
    end;
end;
function u1.stop(p24) --[[ Line: 218 ]]
    -- upvalues: l__spr__8 (ref), l__Sounds__3 (copy)
    p24.locked = false;
    p24.instance.Enabled = false;
    p24.maid.thread = nil;
    p24.maid.heartbeat = nil;
    l__spr__8.stop(p24.instance.Egg);
    l__Sounds__3.stop(l__Sounds__3.assets.eggPlusOne);
    p24:play();
end;
function u1.clear(p25) --[[ Line: 232 ]]
    table.clear(p25.queue);
    p25:stop();
end;
function u1.prepare(p26) --[[ Line: 237 ]]
    local l__instance__16 = p26.instance;
    local v27 = p26.queue[1];
    local l__Animated__17 = l__instance__16.Egg.Animated;
    p26:prepareEgg();
    l__Animated__17.BloomBacklight.ImageTransparency = 1;
    l__Animated__17.BloomProgressive.ImageTransparency = 1;
    l__Animated__17.BloomStar.ImageTransparency = 1;
    l__Animated__17.Icon.Visible = false;
    l__Animated__17.Placeholder.Visible = true;
    l__Animated__17.UIScale.Scale = 1;
    l__instance__16.Title.TextTransparency = 1;
    l__instance__16.Title.Fill.TextTransparency = 1;
    l__instance__16.Title.Shading.ImageTransparency = 1;
    l__instance__16.Title.UIStroke.Transparency = 1;
    l__instance__16.Rarity.TextTransparency = 1;
    l__instance__16.Rarity.Fill.TextTransparency = 1;
    l__instance__16.Rarity.UIStroke.Transparency = 1;
    l__instance__16.PlusOne.Text = `+{v27.amount}`;
    l__instance__16.PlusOne.TextTransparency = 1;
    l__instance__16.PlusOne.Fill.Text = `+{v27.amount}`;
    l__instance__16.PlusOne.Fill.TextTransparency = 1;
    l__instance__16.PlusOne.Shading.ImageTransparency = 1;
    l__instance__16.PlusOne.UIStroke.Transparency = 1;
    l__instance__16.SunRays.ImageTransparency = 1;
    l__instance__16.Vignette.ImageTransparency = 1;
    l__instance__16.HalftoneGradient.ImageTransparency = 1;
    l__instance__16.SpeedUp.TextTransparency = 1;
    l__instance__16.Enabled = true;
end;
function u1.prepareEgg(p28) --[[ Line: 280 ]]
    -- upvalues: l__EggData__5 (copy), l__Theme__6 (copy)
    local l__instance__18 = p28.instance;
    local v29 = p28.queue[1];
    local l__Animated__19 = l__instance__18.Egg.Animated;
    local v30 = l__EggData__5.eggs[v29.categoryIndex][v29.eggIndex];
    local v31 = l__Theme__6.rarities[v30.rarity];
    l__instance__18.Egg:SetAttribute("EggIndex", v29.eggIndex);
    l__instance__18.Egg:SetAttribute("CategoryIndex", v29.categoryIndex);
    l__Animated__19.Placeholder.ImageColor3 = l__Theme__6.plusDarker(v31, 0.2);
    l__Animated__19.BloomBacklight.ImageColor3 = l__Theme__6.plusLighter(v31, 0.2);
    l__Animated__19.BloomProgressive.ImageColor3 = l__Theme__6.plusLighter(v31, 0.2);
    l__Animated__19.BloomStar.ImageColor3 = l__Theme__6.plusLighter(v31, 0.2);
    l__instance__18.Title.Text = v30.name;
    l__instance__18.Title.Fill.Text = l__instance__18.Title.Text;
    l__instance__18.Rarity.Text = string.upper(l__EggData__5.rarities[v30.rarity]);
    l__instance__18.Rarity.Fill.Text = l__instance__18.Rarity.Text;
    l__instance__18.Rarity.Fill.TextColor3 = v31;
end;
function u1.explode(p32) --[[ Line: 304 ]]
    -- upvalues: l__spr__8 (ref), u3 (ref), l__Tween__7 (copy)
    local l__Animated__20 = p32.instance.Egg.Animated;
    l__spr__8.target(l__Animated__20.UIScale, 0.2, 0.8 / u3, {
        Scale = 0.75
    });
    task.wait(u3 * 0.25);
    l__spr__8.target(l__Animated__20.UIScale, 0.6, 1.5 / u3, {
        Scale = 1
    });
    l__spr__8.target(l__Animated__20.BloomBacklight, 1, 1 / u3, {
        ImageTransparency = 1
    });
    l__spr__8.target(l__Animated__20.BloomProgressive, 1, 1.5 / u3, {
        ImageTransparency = 1
    });
    l__spr__8.target(l__Animated__20.BloomStar, 1, 1.5 / u3, {
        ImageTransparency = 1
    });
    l__spr__8.setVelocity(l__Animated__20.UIScale, {
        Scale = 4
    });
    l__spr__8.setVelocity(l__Animated__20.BloomBacklight, {
        ImageTransparency = -20
    });
    l__spr__8.setVelocity(l__Animated__20.BloomProgressive, {
        ImageTransparency = -45
    });
    l__spr__8.setVelocity(l__Animated__20.BloomStar, {
        ImageTransparency = -9.000000000000002
    });
    l__Tween__7(l__Animated__20.Overlay, { "Transparency" }, 1, u3 * 0.3);
    task.defer(function() --[[ Line: 324 ]]
        -- upvalues: l__Animated__20 (copy)
        l__Animated__20.Icon.Visible = true;
        l__Animated__20.Placeholder.Visible = false;
    end);
end;
function u1.transitionIn(p33) --[[ Line: 330 ]]
    -- upvalues: l__spr__8 (ref), u3 (ref), l__Tween__7 (copy), l__Sine__10 (copy), l__InOut__13 (copy)
    local l__instance__21 = p33.instance;
    local v34 = math.random() > 0.5 and 1 or -1;
    l__instance__21.Egg.Position = UDim2.fromScale(0.5 - 0.05 * v34, 1.25);
    l__instance__21.Egg.Rotation = 15 * v34;
    l__instance__21.Egg.Animated.Overlay.BackgroundTransparency = 0.5;
    l__spr__8.target(l__instance__21.Egg, 0.6, 0.6 / u3, {
        Rotation = 0,
        Position = UDim2.fromScale(0.5, 0.5)
    });
    l__spr__8.setVelocity(l__instance__21.Egg, {
        Rotation = 100,
        Position = UDim2.fromScale(0.5 * v34, 0)
    });
    l__Tween__7(l__instance__21.Vignette, { "ImageTransparency" }, { 0.1 }, u3 * 2.5, l__Sine__10, l__InOut__13);
    if u3 == 1 then
        l__Tween__7(l__instance__21.SpeedUp, { "TextTransparency" }, { 0.5 }, u3 * 0.5, l__Sine__10, l__InOut__13);
    end;
end;
function u1.transitionSubtleVisuals(p35) --[[ Line: 355 ]]
    -- upvalues: l__Tween__7 (copy), u3 (ref), l__Sine__10 (copy), l__InOut__13 (copy)
    local l__instance__22 = p35.instance;
    l__Tween__7(l__instance__22.HalftoneGradient, { "ImageTransparency" }, { 0.7 }, u3 * 4, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__22.SunRays, { "ImageTransparency" }, { 0.7 }, u3 * 3, l__Sine__10, l__InOut__13);
end;
function u1.showTitle(p36) --[[ Line: 362 ]]
    -- upvalues: l__Tween__7 (copy), u3 (ref), l__Quint__11 (copy), l__Out__12 (copy), l__Sine__10 (copy), l__InOut__13 (copy)
    local l__instance__23 = p36.instance;
    l__instance__23.Title.Position = UDim2.new(0.5, 0, 0.5, -90);
    l__Tween__7(l__instance__23.Title, { "TextTransparency", "Position" }, { 0.9, (UDim2.new(0.5, 0, 0.5, -130)) }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__23.Title.Fill, { "TextTransparency" }, { 0.1 }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__23.Title.Shading, { "ImageTransparency" }, { 0.5 }, u3 * 1, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__23.Title.UIStroke, { "Transparency" }, { 0.6 }, u3 * 0.5, l__Quint__11, l__Out__12);
end;
function u1.showRarity(p37) --[[ Line: 373 ]]
    -- upvalues: l__Tween__7 (copy), u3 (ref), l__Quint__11 (copy), l__Out__12 (copy)
    local l__instance__24 = p37.instance;
    l__instance__24.Rarity.Position = UDim2.new(0.5, 0, 0.5, -38);
    l__Tween__7(l__instance__24.Rarity, { "TextTransparency", "Position" }, { 0.9, (UDim2.new(0.5, 0, 0.5, -98)) }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__24.Rarity.Fill, { "TextTransparency" }, { 0.1 }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__24.Rarity.UIStroke, { "Transparency" }, { 0.6 }, u3 * 0.5, l__Quint__11, l__Out__12);
end;
function u1.showPlusOne(p38) --[[ Line: 383 ]]
    -- upvalues: l__Tween__7 (copy), u3 (ref), l__Quint__11 (copy), l__Out__12 (copy), l__spr__8 (ref)
    local l__instance__25 = p38.instance;
    l__instance__25.PlusOne.Rotation = -60;
    l__instance__25.PlusOne.Position = UDim2.fromScale(0.5, 0.5);
    l__Tween__7(l__instance__25.PlusOne, { "TextTransparency", "Position" }, { 0.1, (UDim2.new(0.5, 0, 0.5, 90)) }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__25.PlusOne.Fill, { "TextTransparency" }, { 0.1 }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__25.PlusOne.Shading, { "ImageTransparency" }, { 0.5 }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__Tween__7(l__instance__25.PlusOne.UIStroke, { "Transparency" }, { 0.6 }, u3 * 0.5, l__Quint__11, l__Out__12);
    l__spr__8.target(l__instance__25.PlusOne, 0.4, 3 / u3, {
        Rotation = 0
    });
    l__spr__8.target(l__instance__25.PlusOne.UIScale, 1, 2 / u3, {
        Scale = 1
    });
    l__spr__8.setVelocity(l__instance__25.PlusOne, {
        Rotation = 2000
    });
    l__spr__8.setVelocity(l__instance__25.PlusOne.UIScale, {
        Scale = 3
    });
end;
function u1.transitionOut(p39) --[[ Line: 401 ]]
    -- upvalues: l__Tween__7 (copy), u3 (ref), l__Sine__10 (copy), l__InOut__13 (copy), l__Quint__11 (copy), l__spr__8 (ref)
    local l__instance__26 = p39.instance;
    l__Tween__7(l__instance__26.SunRays, { "ImageTransparency" }, { 1 }, u3 * 0.5, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Vignette, { "ImageTransparency" }, { 1 }, u3 * 1, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.HalftoneGradient, { "ImageTransparency" }, { 1 }, u3 * 1, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.SpeedUp, { "TextTransparency" }, { 1 }, u3 * 1, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Title, { "Position" }, { UDim2.new(0.5, 0, 0.5, -90) }, u3 * 0.5, l__Quint__11, l__InOut__13);
    l__Tween__7(l__instance__26.Title, { "TextTransparency" }, { 1 }, u3 * 0.15, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Title.Fill, { "TextTransparency" }, { 1 }, u3 * 0.3, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Title.Shading, { "ImageTransparency" }, { 1 }, u3 * 0.3, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Title.UIStroke, { "Transparency" }, { 1 }, u3 * 0.15, l__Sine__10, l__InOut__13);
    task.wait(u3 * 0.1);
    l__Tween__7(l__instance__26.Rarity, { "Position" }, { UDim2.new(0.5, 0, 0.5, -48) }, u3 * 0.5, l__Quint__11, l__InOut__13);
    l__Tween__7(l__instance__26.Rarity, { "TextTransparency" }, { 1 }, u3 * 0.15, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Rarity.Fill, { "TextTransparency" }, { 1 }, u3 * 0.3, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.Rarity.UIStroke, { "Transparency" }, { 1 }, u3 * 0.15, l__Sine__10, l__InOut__13);
    task.wait(u3 * 0.1);
    l__spr__8.target(l__instance__26.Egg, 0.01, 0.35 / u3, {
        Rotation = 5,
        Position = UDim2.fromScale(0.5, 1.5)
    });
    l__Tween__7(l__instance__26.PlusOne, { "Position" }, { UDim2.new(0.5, 0, 0.5, 130) }, u3 * 0.5, l__Quint__11, l__InOut__13);
    l__Tween__7(l__instance__26.PlusOne, { "TextTransparency" }, { 1 }, u3 * 0.15, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.PlusOne.Fill, { "TextTransparency" }, { 1 }, u3 * 0.3, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.PlusOne.Shading, { "ImageTransparency" }, { 1 }, u3 * 0.3, l__Sine__10, l__InOut__13);
    l__Tween__7(l__instance__26.PlusOne.UIStroke, { "Transparency" }, { 1 }, u3 * 0.15, l__Sine__10, l__InOut__13);
end;
function u1.Destroy(p40) --[[ Line: 436 ]]
    p40.maid:DoCleaning();
end;
return u1;