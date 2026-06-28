-- Roblox: Workspace.SilverAce293026.ACS_Client.ACS_Framework.Animations
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {
    AnimDebounce = true
};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
function v1.AreKeyframesEnabled(_) --[[ Line: 9 ]]
    -- upvalues: u3 (ref)
    local v10 = u3 and u3.Keyframes;
    return v10 and true or v10;
end;
function v1.SetTool(_, p11) --[[ Line: 14 ]]
    -- upvalues: u4 (ref), u3 (ref)
    u4 = p11;
    u3 = require(u4:WaitForChild("ACS_Animations"));
end;
function v1.ConfigureViewport(p12, p13, p14, p15, p16, p17) --[[ Line: 20 ]]
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u2 (ref), u4 (ref)
    u5 = p13;
    u6 = p14;
    u7 = p15;
    u8 = p16;
    u9 = p17;
    if p12:AreKeyframesEnabled() then
        local l__Humanoid__1 = u9:WaitForChild("Humanoid");
        u2 = {
            Equip = l__Humanoid__1:LoadAnimation(u4.Keyframes.Equip),
            Idle = l__Humanoid__1:LoadAnimation(u4.Keyframes.Idle),
            Sprint = l__Humanoid__1:LoadAnimation(u4.Keyframes.Sprint),
            FirstEquip = l__Humanoid__1:LoadAnimation(u4.Keyframes.FirstEquip),
            Reload = l__Humanoid__1:LoadAnimation(u4.Keyframes.Reload),
            EmptyReload = l__Humanoid__1:LoadAnimation(u4.Keyframes.EmptyReload),
            AdsReload = l__Humanoid__1:LoadAnimation(u4.Keyframes.AdsReload),
            AdsEmptyReload = l__Humanoid__1:LoadAnimation(u4.Keyframes.AdsEmptyReload),
            Inspect = l__Humanoid__1:LoadAnimation(u4.Keyframes.Inspect)
        };
        if u4.Keyframes:FindFirstChild("SlideLock") then
            u2.SlideLock = l__Humanoid__1:LoadAnimation(u4.Keyframes.SlideLock);
            u2.SlideLock.Looped = true;
            u2.Idle.Priority = Enum.AnimationPriority.Action2;
        end;
        u2.Equip.Looped = false;
        u2.FirstEquip.Looped = false;
        u2.Reload.Looped = false;
        u2.EmptyReload.Looped = false;
        u2.AdsReload.Looped = false;
        u2.AdsEmptyReload.Looped = false;
        u2.Inspect.Looped = false;
        u2.Idle.Looped = true;
        u2.Sprint.Looped = true;
        u2.Idle.Priority = Enum.AnimationPriority.Idle;
        u2.Sprint.Priority = Enum.AnimationPriority.Movement;
        for _, v18 in pairs(u2) do
            v18:GetMarkerReachedSignal("Sound"):Connect(function(p19) --[[ Line: 58 ]]
                -- upvalues: u8 (ref)
                print("Sound Marker");
                if u8 then
                    local v20;
                    if p19 == "SlidePull" or p19 == "SlideRelease" then
                        v20 = u8.Bolt:FindFirstChild(p19);
                    else
                        v20 = u8.Handle:FindFirstChild(p19);
                    end;
                    if v20 then
                        v20:Play();
                    end;
                end;
            end);
        end;
    end;
end;
function v1.Clear(_) --[[ Line: 74 ]]
    -- upvalues: u4 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    u4 = nil;
    u3 = nil;
    u5 = nil;
    u6 = nil;
    u7 = nil;
    u8 = nil;
    u9 = nil;
end;
function v1.SlideAnim(_) --[[ Line: 79 ]] end;
function v1.EquipAnim(p21) --[[ Line: 83 ]]
    -- upvalues: u3 (ref), u9 (ref), u2 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    p21.AnimDebounce = false;
    if u3.IsFirstEquip and p21:AreKeyframesEnabled() then
        print("First Equip Keyframe");
        u9.Humanoid:WaitForChild("Animator");
        u2.FirstEquip:Play(0);
        u3.IsFirstEquip = false;
    elseif p21:AreKeyframesEnabled() then
        print("Equip Keyframe");
        u2.Equip:Play(0);
    else
        pcall(function() --[[ Line: 96 ]]
            -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
            u3.EquipAnim({
                u5,
                u6,
                u7,
                u8,
                u9
            });
        end);
        p21.AnimDebounce = true;
    end;
end;
function v1.IdleAnim(u22) --[[ Line: 109 ]]
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    pcall(function() --[[ Line: 110 ]]
        -- upvalues: u22 (copy), u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
        if u22:AreKeyframesEnabled() then
            u2.Sprint:Stop(0.2);
            u2.Idle:Play();
            print("Idle Keyframe");
        else
            u3.IdleAnim({
                u5,
                u6,
                u7,
                u8,
                u9
            });
        end;
    end);
    u22.AnimDebounce = true;
end;
function v1.SprintAnim(u23) --[[ Line: 128 ]]
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    u23.AnimDebounce = false;
    pcall(function() --[[ Line: 130 ]]
        -- upvalues: u23 (copy), u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
        if u23:AreKeyframesEnabled() then
            u2.Sprint:Play(0.2);
            u2.Sprint:AdjustSpeed(0);
            print("Sprint Keyframe");
        else
            u3.SprintAnim({
                u5,
                u6,
                u7,
                u8,
                u9
            });
        end;
    end);
end;
function v1.SetReload(_, p24, p25) --[[ Line: 183 ]]
    -- upvalues: u2 (ref)
    u2.Reload:AdjustWeight(p24 and 0.001 or 1, p25);
    u2.EmptyReload:AdjustWeight(p24 and 0.001 or 1, p25);
    u2.AdsReload:AdjustWeight(p24 and 1 or 0.001, p25);
    u2.AdsEmptyReload:AdjustWeight(p24 and 1 or 0.001, p25);
end;
function v1.ReloadAnim(p26, p27) --[[ Line: 190 ]]
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    if p26:AreKeyframesEnabled() then
        print("Reload Keyframe");
        if u2.SlideLock then
            u2.SlideLock:Stop(0);
        end;
        u2.AdsReload:Play();
        u2.Reload:Play();
        if p27 then
            u2.Reload:AdjustWeight(0.001, 0);
        else
            u2.AdsReload:AdjustWeight(0.001, 0);
        end;
        task.wait(u2.Reload.length * 0.8);
    else
        pcall(function() --[[ Line: 206 ]]
            -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
            u3.ReloadAnim({
                u5,
                u6,
                u7,
                u8,
                u9
            });
        end);
    end;
end;
function v1.TacticalReloadAnim(p28, p29) --[[ Line: 217 ]]
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    if p28:AreKeyframesEnabled() then
        print("Empty Reload Keyframe");
        if u2.SlideLock then
            u2.SlideLock:Stop();
        end;
        u2.AdsEmptyReload:Play();
        u2.EmptyReload:Play();
        if p29 then
            u2.EmptyReload:AdjustWeight(0.001, 0);
        else
            u2.AdsEmptyReload:AdjustWeight(0.001, 0);
        end;
        task.wait(u2.EmptyReload.length * 0.8);
    else
        pcall(function() --[[ Line: 233 ]]
            -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
            u3.TacticalReloadAnim({
                u5,
                u6,
                u7,
                u8,
                u9
            });
        end);
    end;
end;
function v1.JammedAnim(_) --[[ Line: 244 ]]
    -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    pcall(function() --[[ Line: 245 ]]
        -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
        u3.JammedAnim({
            u5,
            u6,
            u7,
            u8,
            u9
        });
    end);
end;
function v1.PumpAnim(_, p30) --[[ Line: 256 ]]
    -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    pcall(function() --[[ Line: 258 ]]
        -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
        u3.PumpAnim({
            u5,
            u6,
            u7,
            u8,
            u9
        });
    end);
    p30();
end;
function v1.MagCheckAnim(p31, p32) --[[ Line: 271 ]]
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    if p31.AreKeyframesEnabled() then
        print("Inspect Keyframe");
        u2.Inspect:Play();
        task.wait(u2.Inspect.length * 0.8);
        p32();
    else
        pcall(function() --[[ Line: 281 ]]
            -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
            u3.MagCheck({
                u5,
                u6,
                u7,
                u8,
                u9
            });
        end);
        p32();
    end;
end;
return v1;