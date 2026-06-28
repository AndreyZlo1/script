-- Roblox: Workspace.SilverAce293026.Animate
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Parent__1 = script.Parent;
local l__Humanoid__2 = l__Parent__1:WaitForChild("Humanoid");
local v1, v2 = pcall(function() --[[ Line: 5 ]]
    return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop");
end);
local v3, v4 = pcall(function() --[[ Line: 8 ]]
    return UserSettings():IsUserFeatureEnabled("UserAnimateScriptEmoteHook");
end);
local u5 = script:FindFirstChild("ScaleDampeningPercent");
local u6 = {};
local u7 = {};
local u8 = {
    idle = {
        {
            id = "http://www.roblox.com/asset/?id=507766666",
            weight = 1
        },
        {
            id = "http://www.roblox.com/asset/?id=507766951",
            weight = 1
        },
        {
            id = "http://www.roblox.com/asset/?id=507766388",
            weight = 9
        }
    },
    walk = {
        {
            id = "http://www.roblox.com/asset/?id=507777826",
            weight = 10
        }
    },
    run = {
        {
            id = "http://www.roblox.com/asset/?id=507767714",
            weight = 10
        }
    },
    swim = {
        {
            id = "http://www.roblox.com/asset/?id=507784897",
            weight = 10
        }
    },
    swimidle = {
        {
            id = "http://www.roblox.com/asset/?id=507785072",
            weight = 10
        }
    },
    jump = {
        {
            id = "http://www.roblox.com/asset/?id=507765000",
            weight = 10
        }
    },
    fall = {
        {
            id = "http://www.roblox.com/asset/?id=507767968",
            weight = 10
        }
    },
    climb = {
        {
            id = "http://www.roblox.com/asset/?id=507765644",
            weight = 10
        }
    },
    sit = {
        {
            id = "http://www.roblox.com/asset/?id=2506281703",
            weight = 10
        }
    },
    toolnone = {
        {
            id = "http://www.roblox.com/asset/?id=507768375",
            weight = 10
        }
    },
    toolslash = {
        {
            id = "http://www.roblox.com/asset/?id=522635514",
            weight = 10
        }
    },
    toollunge = {
        {
            id = "http://www.roblox.com/asset/?id=522638767",
            weight = 10
        }
    },
    wave = {
        {
            id = "http://www.roblox.com/asset/?id=507770239",
            weight = 10
        }
    },
    point = {
        {
            id = "http://www.roblox.com/asset/?id=507770453",
            weight = 10
        }
    },
    dance = {
        {
            id = "http://www.roblox.com/asset/?id=507771019",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507771955",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507772104",
            weight = 10
        }
    },
    dance2 = {
        {
            id = "http://www.roblox.com/asset/?id=507776043",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507776720",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507776879",
            weight = 10
        }
    },
    dance3 = {
        {
            id = "http://www.roblox.com/asset/?id=507777268",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507777451",
            weight = 10
        },
        {
            id = "http://www.roblox.com/asset/?id=507777623",
            weight = 10
        }
    },
    laugh = {
        {
            id = "http://www.roblox.com/asset/?id=507770818",
            weight = 10
        }
    },
    cheer = {
        {
            id = "http://www.roblox.com/asset/?id=507770677",
            weight = 10
        }
    }
};
math.randomseed(tick());
function findExistingAnimationInSet(p9, p10)
    if p9 == nil or p10 == nil then
        return 0;
    end;
    for v11 = 1, p9.count do
        if p9[v11].anim.AnimationId == p10.AnimationId then
            return v11;
        end;
    end;
    return 0;
end;
function configureAnimationSet(u12, u13)
    -- upvalues: u7 (copy), u6 (copy), l__Humanoid__2 (copy)
    if u7[u12] ~= nil then
        for _, v14 in pairs(u7[u12].connections) do
            v14:disconnect();
        end;
    end;
    u7[u12] = {};
    u7[u12].count = 0;
    u7[u12].totalWeight = 0;
    u7[u12].connections = {};
    local u15 = true;
    local v16, _ = pcall(function() --[[ Line: 130 ]]
        -- upvalues: u15 (ref)
        u15 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u15 = not v16 and true or u15;
    local v17 = script:FindFirstChild(u12);
    if u15 and v17 ~= nil then
        table.insert(u7[u12].connections, v17.ChildAdded:connect(function(_) --[[ Line: 138 ]]
            -- upvalues: u12 (copy), u13 (copy)
            configureAnimationSet(u12, u13);
        end));
        table.insert(u7[u12].connections, v17.ChildRemoved:connect(function(_) --[[ Line: 139 ]]
            -- upvalues: u12 (copy), u13 (copy)
            configureAnimationSet(u12, u13);
        end));
        for _, v18 in pairs(v17:GetChildren()) do
            if v18:IsA("Animation") then
                local v19 = v18:FindFirstChild("Weight");
                local v20 = v19 == nil and 1 or v19.Value;
                u7[u12].count = u7[u12].count + 1;
                local l__count__3 = u7[u12].count;
                u7[u12][l__count__3] = {};
                u7[u12][l__count__3].anim = v18;
                u7[u12][l__count__3].weight = v20;
                u7[u12].totalWeight = u7[u12].totalWeight + u7[u12][l__count__3].weight;
                table.insert(u7[u12].connections, v18.Changed:connect(function(_) --[[ Line: 155 ]]
                    -- upvalues: u12 (copy), u13 (copy)
                    configureAnimationSet(u12, u13);
                end));
                table.insert(u7[u12].connections, v18.ChildAdded:connect(function(_) --[[ Line: 156 ]]
                    -- upvalues: u12 (copy), u13 (copy)
                    configureAnimationSet(u12, u13);
                end));
                table.insert(u7[u12].connections, v18.ChildRemoved:connect(function(_) --[[ Line: 157 ]]
                    -- upvalues: u12 (copy), u13 (copy)
                    configureAnimationSet(u12, u13);
                end));
            end;
        end;
    end;
    if u7[u12].count <= 0 then
        for v21, v22 in pairs(u13) do
            u7[u12][v21] = {};
            u7[u12][v21].anim = Instance.new("Animation");
            u7[u12][v21].anim.Name = u12;
            u7[u12][v21].anim.AnimationId = v22.id;
            u7[u12][v21].weight = v22.weight;
            u7[u12].count = u7[u12].count + 1;
            u7[u12].totalWeight = u7[u12].totalWeight + v22.weight;
        end;
    end;
    for _, v23 in pairs(u7) do
        for v24 = 1, v23.count do
            if u6[v23[v24].anim.AnimationId] == nil then
                l__Humanoid__2:LoadAnimation(v23[v24].anim);
                u6[v23[v24].anim.AnimationId] = true;
            end;
        end;
    end;
end;
function configureAnimationSetOld(u25, u26)
    -- upvalues: u7 (copy), l__Humanoid__2 (copy)
    if u7[u25] ~= nil then
        for _, v27 in pairs(u7[u25].connections) do
            v27:disconnect();
        end;
    end;
    u7[u25] = {};
    u7[u25].count = 0;
    u7[u25].totalWeight = 0;
    u7[u25].connections = {};
    local u28 = true;
    local v29, _ = pcall(function() --[[ Line: 201 ]]
        -- upvalues: u28 (ref)
        u28 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u28 = not v29 and true or u28;
    local v30 = script:FindFirstChild(u25);
    if u28 and v30 ~= nil then
        table.insert(u7[u25].connections, v30.ChildAdded:connect(function(_) --[[ Line: 209 ]]
            -- upvalues: u25 (copy), u26 (copy)
            configureAnimationSet(u25, u26);
        end));
        table.insert(u7[u25].connections, v30.ChildRemoved:connect(function(_) --[[ Line: 210 ]]
            -- upvalues: u25 (copy), u26 (copy)
            configureAnimationSet(u25, u26);
        end));
        local v31 = 1;
        for _, v32 in pairs(v30:GetChildren()) do
            if v32:IsA("Animation") then
                table.insert(u7[u25].connections, v32.Changed:connect(function(_) --[[ Line: 214 ]]
                    -- upvalues: u25 (copy), u26 (copy)
                    configureAnimationSet(u25, u26);
                end));
                u7[u25][v31] = {};
                u7[u25][v31].anim = v32;
                local v33 = v32:FindFirstChild("Weight");
                if v33 == nil then
                    u7[u25][v31].weight = 1;
                else
                    u7[u25][v31].weight = v33.Value;
                end;
                u7[u25].count = u7[u25].count + 1;
                u7[u25].totalWeight = u7[u25].totalWeight + u7[u25][v31].weight;
                v31 = v31 + 1;
            end;
        end;
    end;
    if u7[u25].count <= 0 then
        for v34, v35 in pairs(u26) do
            u7[u25][v34] = {};
            u7[u25][v34].anim = Instance.new("Animation");
            u7[u25][v34].anim.Name = u25;
            u7[u25][v34].anim.AnimationId = v35.id;
            u7[u25][v34].weight = v35.weight;
            u7[u25].count = u7[u25].count + 1;
            u7[u25].totalWeight = u7[u25].totalWeight + v35.weight;
        end;
    end;
    for _, v36 in pairs(u7) do
        for v37 = 1, v36.count do
            l__Humanoid__2:LoadAnimation(v36[v37].anim);
        end;
    end;
end;
function scriptChildModified(p38)
    -- upvalues: u8 (copy)
    local v39 = u8[p38.Name];
    if v39 ~= nil then
        configureAnimationSet(p38.Name, v39);
    end;
end;
script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local u40 = 1;
local u41 = {
    wave = false,
    point = false,
    dance = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};
local u42 = v3 and v4;
local u43 = nil;
local u44 = nil;
local u45 = v1 and v2;
local u46 = "Standing";
local u47 = "";
local u48 = nil;
local u49 = nil;
local u50 = nil;
for v51, v52 in pairs(u8) do
    configureAnimationSet(v51, v52);
end;
local u53 = "None";
local u54 = 0;
local u55 = 0;
local u56 = false;
function stopAllAnimations()
    -- upvalues: u47 (ref), u41 (copy), u42 (copy), u56 (ref), u48 (ref), u43 (ref), u44 (ref), u49 (ref), u50 (ref)
    local v57 = u47;
    local v58 = u41[v57] ~= nil and u41[v57] == false and "idle" or v57;
    if u42 and u56 then
        v58 = "idle";
        u56 = false;
    end;
    u47 = "";
    u48 = nil;
    if u43 ~= nil then
        u43:disconnect();
    end;
    if u44 ~= nil then
        u44:Stop();
        u44:Destroy();
        u44 = nil;
    end;
    if u49 ~= nil then
        u49:disconnect();
    end;
    if u50 ~= nil then
        u50:Stop();
        u50:Destroy();
        u50 = nil;
    end;
    return v58;
end;
function getHeightScale()
    -- upvalues: l__Humanoid__2 (copy), u5 (ref)
    if not l__Humanoid__2 then
        return 1;
    end;
    if not l__Humanoid__2.AutomaticScalingEnabled then
        return 1;
    end;
    local v59 = l__Humanoid__2.HipHeight / 2;
    if u5 == nil then
        u5 = script:FindFirstChild("ScaleDampeningPercent");
    end;
    if u5 ~= nil then
        v59 = 1 + (l__Humanoid__2.HipHeight - 2) * u5.Value / 2;
    end;
    return v59;
end;
function setRunSpeed(p60)
    -- upvalues: u40 (ref), u44 (ref), u50 (ref)
    local v61 = p60 * 1 / getHeightScale();
    if v61 ~= u40 then
        if v61 < 0.35 then
            u44:AdjustWeight(1);
            u50:AdjustWeight(0.0001);
        elseif v61 < 0.66 then
            local v62 = (v61 - 0.66) / 0.66;
            u44:AdjustWeight(1 - v62 + 0.0001);
            u50:AdjustWeight(v62 + 0.0001);
        else
            u44:AdjustWeight(0.0001);
            u50:AdjustWeight(1);
        end;
        u40 = v61;
        u50:AdjustSpeed(v61);
        u44:AdjustSpeed(v61);
    end;
end;
function setAnimationSpeed(p63)
    -- upvalues: u47 (ref), u40 (ref), u44 (ref)
    if u47 == "walk" then
        setRunSpeed(p63);
    else
        if p63 ~= u40 then
            u40 = p63;
            u44:AdjustSpeed(u40);
        end;
    end;
end;
function keyFrameReachedFunc(p64)
    -- upvalues: u47 (ref), u45 (copy), u50 (ref), u44 (ref), u41 (copy), u42 (copy), u56 (ref), u40 (ref), l__Humanoid__2 (copy)
    if p64 == "End" then
        if u47 == "walk" then
            if u45 ~= true then
                u50.TimePosition = 0;
                u44.TimePosition = 0;
                return;
            end;
            if u50.Looped ~= true then
                u50.TimePosition = 0;
            end;
            if u44.Looped ~= true then
                u44.TimePosition = 0;
            end;
        else
            local v65 = u47;
            local v66 = u41[v65] ~= nil and u41[v65] == false and "idle" or v65;
            if u42 and u56 then
                if u44.Looped then
                    return;
                end;
                v66 = "idle";
                u56 = false;
            end;
            local v67 = u40;
            playAnimation(v66, 0.15, l__Humanoid__2);
            setAnimationSpeed(v67);
        end;
    end;
end;
function rollAnimation(p68)
    -- upvalues: u7 (copy)
    local v69 = math.random(1, u7[p68].totalWeight);
    local v70 = 1;
    while u7[p68][v70].weight < v69 do
        v69 = v69 - u7[p68][v70].weight;
        v70 = v70 + 1;
    end;
    return v70;
end;
local function u76(p71, p72, p73, p74) --[[ Line: 425 ]]
    -- upvalues: u48 (ref), u44 (ref), u50 (ref), u45 (copy), u40 (ref), u47 (ref), u43 (ref), u7 (copy), u49 (ref)
    if p71 ~= u48 then
        if u44 ~= nil then
            u44:Stop(p73);
            u44:Destroy();
        end;
        if u50 ~= nil then
            u50:Stop(p73);
            u50:Destroy();
            if u45 == true then
                u50 = nil;
            end;
        end;
        u40 = 1;
        u44 = p74:LoadAnimation(p71);
        u44.Priority = Enum.AnimationPriority.Core;
        u44:Play(p73);
        u47 = p72;
        u48 = p71;
        if u43 ~= nil then
            u43:disconnect();
        end;
        u43 = u44.KeyframeReached:connect(keyFrameReachedFunc);
        if p72 == "walk" then
            local v75 = rollAnimation("run");
            u50 = p74:LoadAnimation(u7.run[v75].anim);
            u50.Priority = Enum.AnimationPriority.Core;
            u50:Play(p73);
            if u49 ~= nil then
                u49:disconnect();
            end;
            u49 = u50.KeyframeReached:connect(keyFrameReachedFunc);
        end;
    end;
end;
function playAnimation(p77, p78, p79)
    -- upvalues: u7 (copy), u76 (copy), u56 (ref)
    local v80 = rollAnimation(p77);
    u76(u7[p77][v80].anim, p77, p78, p79);
    u56 = false;
end;
function playEmote(p81, p82, p83)
    -- upvalues: u76 (copy), u56 (ref)
    u76(p81, p81.Name, p82, p83);
    u56 = true;
end;
local u84 = "";
local u85 = nil;
local u86 = nil;
local u87 = nil;
function toolKeyFrameReachedFunc(p88)
    -- upvalues: u84 (ref), l__Humanoid__2 (copy)
    if p88 == "End" then
        playToolAnimation(u84, 0, l__Humanoid__2);
    end;
end;
function playToolAnimation(p89, p90, p91, p92)
    -- upvalues: u7 (copy), u86 (ref), u85 (ref), u84 (ref), u87 (ref)
    local v93 = rollAnimation(p89);
    local l__anim__4 = u7[p89][v93].anim;
    if u86 ~= l__anim__4 then
        if u85 ~= nil then
            u85:Stop();
            u85:Destroy();
            p90 = 0;
        end;
        u85 = p91:LoadAnimation(l__anim__4);
        if p92 then
            u85.Priority = p92;
        end;
        u85:Play(p90);
        u84 = p89;
        u86 = l__anim__4;
        u87 = u85.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;
function stopToolAnimations()
    -- upvalues: u84 (ref), u87 (ref), u86 (ref), u85 (ref)
    local v94 = u84;
    if u87 ~= nil then
        u87:disconnect();
    end;
    u84 = "";
    u86 = nil;
    if u85 ~= nil then
        u85:Stop();
        u85:Destroy();
        u85 = nil;
    end;
    return v94;
end;
function onRunning(p95)
    -- upvalues: l__Humanoid__2 (copy), u46 (ref), u41 (copy), u47 (ref), u56 (ref)
    if p95 > 0.75 then
        playAnimation("walk", 0.2, l__Humanoid__2);
        setAnimationSpeed(p95 / 22);
        u46 = "Running";
    else
        if u41[u47] == nil and not u56 then
            playAnimation("idle", 0.2, l__Humanoid__2);
            u46 = "Standing";
        end;
    end;
end;
function onDied()
    -- upvalues: u46 (ref)
    u46 = "Dead";
end;
function onJumping()
    -- upvalues: l__Humanoid__2 (copy), u55 (ref), u46 (ref)
    playAnimation("jump", 0.1, l__Humanoid__2);
    u55 = 0.31;
    u46 = "Jumping";
end;
function onClimbing(p96)
    -- upvalues: l__Humanoid__2 (copy), u46 (ref)
    playAnimation("climb", 0.1, l__Humanoid__2);
    setAnimationSpeed(p96 / 5);
    u46 = "Climbing";
end;
function onGettingUp()
    -- upvalues: u46 (ref)
    u46 = "GettingUp";
end;
function onFreeFall()
    -- upvalues: u55 (ref), l__Humanoid__2 (copy), u46 (ref)
    if u55 <= 0 then
        playAnimation("fall", 0.2, l__Humanoid__2);
    end;
    u46 = "FreeFall";
end;
function onFallingDown()
    -- upvalues: u46 (ref)
    u46 = "FallingDown";
end;
function onSeated()
    -- upvalues: u46 (ref)
    u46 = "Seated";
end;
function onPlatformStanding()
    -- upvalues: u46 (ref)
    u46 = "PlatformStanding";
end;
function onSwimming(p97)
    -- upvalues: l__Humanoid__2 (copy), u46 (ref)
    if p97 > 1 then
        playAnimation("swim", 0.4, l__Humanoid__2);
        setAnimationSpeed(p97 / 10);
        u46 = "Swimming";
    else
        playAnimation("swimidle", 0.4, l__Humanoid__2);
        u46 = "Standing";
    end;
end;
function animateTool()
    -- upvalues: u53 (ref), l__Humanoid__2 (copy)
    if u53 == "None" then
        playToolAnimation("toolnone", 0.1, l__Humanoid__2, Enum.AnimationPriority.Idle);
    elseif u53 == "Slash" then
        playToolAnimation("toolslash", 0, l__Humanoid__2, Enum.AnimationPriority.Action);
    elseif u53 == "Lunge" then
        playToolAnimation("toollunge", 0, l__Humanoid__2, Enum.AnimationPriority.Action);
    end;
end;
function getToolAnim(p98)
    for _, v99 in ipairs(p98:GetChildren()) do
        if v99.Name == "toolanim" and v99.className == "StringValue" then
            return v99;
        end;
    end;
    return nil;
end;
local u100 = 0;
function stepAnimate(p101)
    -- upvalues: u100 (ref), u55 (ref), u46 (ref), l__Humanoid__2 (copy), l__Parent__1 (copy), u53 (ref), u54 (ref), u86 (ref)
    local v102 = p101 - u100;
    u100 = p101;
    if u55 > 0 then
        u55 = u55 - v102;
    end;
    if u46 == "FreeFall" and u55 <= 0 then
        playAnimation("fall", 0.2, l__Humanoid__2);
    else
        if u46 == "Seated" then
            playAnimation("sit", 0.5, l__Humanoid__2);
            return;
        end;
        if u46 == "Running" then
            playAnimation("walk", 0.2, l__Humanoid__2);
        elseif u46 == "Dead" or (u46 == "GettingUp" or (u46 == "FallingDown" or (u46 == "Seated" or u46 == "PlatformStanding"))) then
            stopAllAnimations();
        end;
    end;
    local v103 = l__Parent__1:FindFirstChildOfClass("Tool");
    if v103 and v103:FindFirstChild("Handle") then
        local v104 = getToolAnim(v103);
        if v104 then
            u53 = v104.Value;
            v104.Parent = nil;
            u54 = p101 + 0.3;
        end;
        if u54 < p101 then
            u54 = 0;
            u53 = "None";
        end;
        animateTool();
    else
        stopToolAnimations();
        u53 = "None";
        u86 = nil;
        u54 = 0;
    end;
end;
l__Humanoid__2.Died:connect(onDied);
l__Humanoid__2.Running:connect(onRunning);
l__Humanoid__2.Jumping:connect(onJumping);
l__Humanoid__2.Climbing:connect(onClimbing);
l__Humanoid__2.GettingUp:connect(onGettingUp);
l__Humanoid__2.FreeFalling:connect(onFreeFall);
l__Humanoid__2.FallingDown:connect(onFallingDown);
l__Humanoid__2.Seated:connect(onSeated);
l__Humanoid__2.PlatformStanding:connect(onPlatformStanding);
l__Humanoid__2.Swimming:connect(onSwimming);
game:GetService("Players").LocalPlayer.Chatted:connect(function(p105) --[[ Line: 716 ]]
    -- upvalues: u46 (ref), u41 (copy), l__Humanoid__2 (copy)
    local v106 = "";
    if string.sub(p105, 1, 3) == "/e " then
        v106 = string.sub(p105, 4);
    elseif string.sub(p105, 1, 7) == "/emote " then
        v106 = string.sub(p105, 8);
    end;
    if u46 == "Standing" and u41[v106] ~= nil then
        playAnimation(v106, 0.1, l__Humanoid__2);
    end;
end);
if u42 then
    script:WaitForChild("PlayEmote").OnInvoke = function(p107) --[[ Line: 731 ]]
        -- upvalues: u46 (ref), u41 (copy), l__Humanoid__2 (copy)
        if u46 == "Standing" then
            if u41[p107] ~= nil then
                playAnimation(p107, 0.1, l__Humanoid__2);
                return true;
            end;
            if typeof(p107) ~= "Instance" or not p107:IsA("Animation") then
                return false;
            end;
            playEmote(p107, 0.1, l__Humanoid__2);
            return true;
        end;
    end;
end;
playAnimation("idle", 0.1, l__Humanoid__2);
local _ = "Standing";
while l__Parent__1.Parent ~= nil do
    local _, v108 = wait(0.1);
    stepAnimate(v108);
end;