-- Roblox: ReplicatedStorage.Rig.Animate
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Parent__1 = script.Parent;
local l__Humanoid__2 = l__Parent__1:WaitForChild("Humanoid");
local u1 = "Standing";
UserSettings():GetService("UserGameSettings");
local _, _ = pcall(function() --[[ Line: 9 ]]
    return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop");
end);
local v2, v3 = pcall(function() --[[ Line: 12 ]]
    return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun");
end);
local u4 = v2 and v3;
local u5 = script:FindFirstChild("ScaleDampeningPercent");
local u6 = 0;
local u7 = 0;
local u8 = {
    x = 0,
    y = 0
};
local u9 = 0;
local u10 = "";
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = 1;
local u15 = {};
local u16 = {};
local u17 = {
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
local u18 = {};
local u19 = {};
local u20 = u18;
local u21 = {
    wave = false,
    point = false,
    dance = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};
math.randomseed(tick());
function findExistingAnimationInSet(p22, p23)
    if p22 == nil or p23 == nil then
        return 0;
    end;
    for v24 = 1, p22.count do
        if p22[v24].anim.AnimationId == p23.AnimationId then
            return v24;
        end;
    end;
    return 0;
end;
local function u27() --[[ Line: 131 ]]
    -- upvalues: u18 (copy), u19 (copy), u7 (ref)
    for _, v25 in pairs(u18) do
        if v25.track then
            v25.track:Stop();
            v25.track:Destroy();
            v25.track = nil;
        end;
    end;
    for _, v26 in pairs(u19) do
        if v26.track then
            v26.track:Stop();
            v26.track:Destroy();
            v26.track = nil;
        end;
    end;
    u7 = 0;
end;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local function u32(_) --[[ Line: 168 ]]
    -- upvalues: u28 (ref), u29 (ref), u30 (ref), u31 (ref), u20 (ref), u18 (copy), u19 (copy)
    if u28 == 0 or (u29 == 0 or (u30 == 0 or u31 == 0)) then
        if u20 == u18 then
            warn("Strafe blending disabled.  Not all quadrants of motion represented.");
        end;
        u20 = u19;
    elseif u18.run and u18.walk then
        if u20 ~= u18 then
            u20 = u18;
            warn("Strafing reenabled");
        end;
    else
        if u20 == u18 then
            warn("Strafe blending disabled.  Run and walk must be strafing-friendly.");
        end;
        u20 = u19;
    end;
end;
local function u36() --[[ Line: 187 ]]
    -- upvalues: u29 (ref), u28 (ref), u31 (ref), u30 (ref), u18 (copy), u32 (copy), u20 (ref), l__Humanoid__2 (copy), u16 (copy)
    u29 = 0;
    u28 = 0;
    u31 = 0;
    u30 = 0;
    for _, v33 in pairs(u18) do
        local l__lv__3 = v33.lv;
        if l__lv__3 then
            if u28 < l__lv__3.x then
                u28 = l__lv__3.x;
            end;
            if u30 < l__lv__3.y then
                u30 = l__lv__3.y;
            end;
            if l__lv__3.x < u29 then
                u29 = l__lv__3.x;
            end;
            if l__lv__3.y < u31 then
                u31 = l__lv__3.y;
            end;
        end;
    end;
    u32();
    for v34, v35 in pairs(u20) do
        v35.track = l__Humanoid__2:LoadAnimation(u16[v34][1].anim);
        v35.track.Priority = Enum.AnimationPriority.Core;
    end;
end;
local function u41(p37, p38) --[[ Line: 200 ]]
    -- upvalues: u10 (ref), u20 (ref), u27 (copy), u18 (copy), u19 (copy), u36 (copy), u9 (ref)
    local v39;
    if u10 == "walk" and u20[p37] then
        u27();
        v39 = true;
    else
        v39 = false;
    end;
    if p38 then
        u18[p37] = {
            lv = p38,
            speed = p38.Magnitude
        };
    else
        u18[p37] = nil;
    end;
    if p37 == "run" or p37 == "walk" then
        if p38 then
            u19[p37] = u18[p37];
        else
            local v40 = p37 == "run" and 12.8 or 6.4;
            u19[p37] = {
                lv = Vector2.new(0, v40),
                speed = v40
            };
            u18[p37] = nil;
        end;
    end;
    if v39 then
        u36();
        u9 = 0;
    end;
end;
function configureAnimationSet(u42, u43)
    -- upvalues: u16 (copy), u41 (copy), u15 (copy), l__Humanoid__2 (copy)
    if u16[u42] ~= nil then
        for _, v44 in pairs(u16[u42].connections) do
            v44:disconnect();
        end;
    end;
    u16[u42] = {};
    u16[u42].count = 0;
    u16[u42].totalWeight = 0;
    u16[u42].connections = {};
    local v45 = script:FindFirstChild(u42);
    if v45 ~= nil then
        table.insert(u16[u42].connections, v45.ChildAdded:connect(function(_) --[[ Line: 242 ]]
            -- upvalues: u42 (copy), u43 (copy)
            configureAnimationSet(u42, u43);
        end));
        table.insert(u16[u42].connections, v45.ChildRemoved:connect(function(_) --[[ Line: 243 ]]
            -- upvalues: u42 (copy), u43 (copy)
            configureAnimationSet(u42, u43);
        end));
        for _, v46 in pairs(v45:GetChildren()) do
            if v46:IsA("Animation") then
                local v47 = v46:FindFirstChild("Weight");
                local v48 = v47 == nil and 1 or v47.Value;
                u16[u42].count = u16[u42].count + 1;
                local l__count__4 = u16[u42].count;
                u16[u42][l__count__4] = {};
                u16[u42][l__count__4].anim = v46;
                u16[u42][l__count__4].weight = v48;
                u16[u42].totalWeight = u16[u42].totalWeight + u16[u42][l__count__4].weight;
                table.insert(u16[u42].connections, v46.Changed:connect(function(_) --[[ Line: 260 ]]
                    -- upvalues: u42 (copy), u43 (copy)
                    configureAnimationSet(u42, u43);
                end));
                table.insert(u16[u42].connections, v46.ChildAdded:connect(function(_) --[[ Line: 261 ]]
                    -- upvalues: u42 (copy), u43 (copy)
                    configureAnimationSet(u42, u43);
                end));
                table.insert(u16[u42].connections, v46.ChildRemoved:connect(function(_) --[[ Line: 262 ]]
                    -- upvalues: u42 (copy), u43 (copy)
                    configureAnimationSet(u42, u43);
                end));
                u41(u42, (v46:GetAttribute("LinearVelocity")));
            end;
        end;
    end;
    if u16[u42].count <= 0 then
        for v49, v50 in pairs(u43) do
            u16[u42][v49] = {};
            u16[u42][v49].anim = Instance.new("Animation");
            u16[u42][v49].anim.Name = u42;
            u16[u42][v49].anim.AnimationId = v50.id;
            u16[u42][v49].weight = v50.weight;
            u16[u42].count = u16[u42].count + 1;
            u16[u42].totalWeight = u16[u42].totalWeight + v50.weight;
        end;
    end;
    for _, v51 in pairs(u16) do
        for v52 = 1, v51.count do
            if u15[v51[v52].anim.AnimationId] == nil then
                l__Humanoid__2:LoadAnimation(v51[v52].anim);
                u15[v51[v52].anim.AnimationId] = true;
            end;
        end;
    end;
end;
function scriptChildModified(p53)
    -- upvalues: u17 (copy)
    local v54 = u17[p53.Name];
    if v54 == nil then
        if p53:isA("StringValue") then
            u17[p53.Name] = {};
            configureAnimationSet(p53.Name, u17[p53.Name]);
        end;
    else
        configureAnimationSet(p53.Name, v54);
    end;
end;
script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local v55;
if l__Humanoid__2 then
    v55 = l__Humanoid__2:FindFirstChildOfClass("Animator");
else
    v55 = nil;
end;
local u56, u57, u58, u59;
if v55 then
    local v60 = v55:GetPlayingAnimationTracks();
    u56 = u10;
    u57 = u9;
    u58 = u7;
    u59 = u20;
    for _, v61 in ipairs(v60) do
        v61:Stop(0);
        v61:Destroy();
    end;
else
    u56 = u10;
    u57 = u9;
    u58 = u7;
    u59 = u20;
end;
for v62, v63 in pairs(u17) do
    configureAnimationSet(v62, v63);
end;
for _, v64 in script:GetChildren() do
    if v64:isA("StringValue") then
        u17[v64.Name] = {};
        configureAnimationSet(v64.Name, u17[v64.Name]);
    end;
end;
local u65 = "None";
local u66 = 0;
local u67 = 0;
local u68 = false;
function stopAllAnimations()
    -- upvalues: u56 (ref), u21 (copy), u68 (ref), u11 (ref), u13 (ref), u12 (ref), u59 (ref)
    local v69 = u56;
    local v70 = u21[v69] ~= nil and u21[v69] == false and "idle" or v69;
    if u68 then
        v70 = "idle";
        u68 = false;
    end;
    u56 = "";
    u11 = nil;
    if u13 ~= nil then
        u13:disconnect();
    end;
    if u12 ~= nil then
        u12:Stop();
        u12:Destroy();
        u12 = nil;
    end;
    for _, v71 in pairs(u59) do
        if v71.track then
            v71.track:Stop();
            v71.track:Destroy();
            v71.track = nil;
        end;
    end;
    return v70;
end;
local function u72() --[[ Line: 383 ]]
    -- upvalues: u4 (copy), l__Parent__1 (copy)
    return not u4 and 1 or l__Parent__1:GetScale();
end;
function getHeightScale()
    -- upvalues: l__Humanoid__2 (copy), u72 (copy), u5 (ref)
    if not l__Humanoid__2 then
        return u72();
    end;
    if not l__Humanoid__2.AutomaticScalingEnabled then
        return u72();
    end;
    local v73 = l__Humanoid__2.HipHeight / 2;
    if u5 == nil then
        u5 = script:FindFirstChild("ScaleDampeningPercent");
    end;
    if u5 ~= nil then
        v73 = 1 + (l__Humanoid__2.HipHeight - 2) * u5.Value / 2;
    end;
    return v73;
end;
local function u83(p74, p75, p76, p77, p78, p79) --[[ Line: 417 ]]
    local v80 = 0.5 * (p78 + p79);
    local v81 = {
        x = (p77 - p78) / v80,
        y = 2 * -math.atan2(p75.x * p74.y - p75.y * p74.x, p75.x * p74.x + p75.y * p74.y)
    };
    local v82 = {
        x = (p79 - p78) / v80,
        y = 2 * -math.atan2(p75.x * p76.y - p75.y * p76.x, p75.x * p76.x + p75.y * p76.y)
    };
    return math.clamp(1 - (v81.x * v82.x + v81.y * v82.y) / (0.0001 + (v82.x * v82.x + v82.y * v82.y)), 0, 1);
end;
local function u106(p84, p85) --[[ Line: 428 ]]
    -- upvalues: u4 (copy), u59 (ref), u83 (copy)
    if u4 then
        local v86 = getHeightScale();
        p84 = p84 / v86;
        p85 = p85 / v86;
    end;
    local v87 = {};
    local v88 = 0;
    for v89, v90 in pairs(u59) do
        if p84.x * v90.lv.x < 0 or p84.y * v90.lv.y < 0 then
            v87[v89] = 0;
        else
            v87[v89] = (1 / 0);
            for _, v91 in pairs(u59) do
                if p84.x * v91.lv.x >= 0 and p84.y * v91.lv.y >= 0 then
                    local v92 = v87[v89];
                    local v93 = u83(p84, v90.lv, v91.lv, p85, v90.speed, v91.speed);
                    v87[v89] = math.min(v92, v93);
                end;
            end;
            v88 = v88 + v87[v89];
        end;
    end;
    local v94 = 0;
    local v95 = 0;
    local v96 = 0;
    for v97, v98 in pairs(u59) do
        if v87[v97] / v88 > 0.1 then
            v94 = v94 + v87[v97];
            v95 = v95 + v87[v97] * v98.lv.x;
            v96 = v96 + v87[v97] * v98.lv.y;
        else
            v87[v97] = 0;
        end;
    end;
    local v99 = v95 * v95 + v96 * v96;
    local v100 = v99 <= 0.0001 and 0 or math.sqrt(p85 * p85 / v99);
    if not u4 then
        v100 = v100 / getHeightScale();
    end;
    local v101 = 0;
    for _, v102 in pairs(u59) do
        if v102.track.IsPlaying then
            v101 = v102.track.TimePosition;
            break;
        end;
    end;
    for v103, v104 in pairs(u59) do
        if v87[v103] > 0 then
            if not v104.track.IsPlaying then
                v104.track:Play(0.2);
                v104.track.TimePosition = v101;
            end;
            local v105 = math.max(0.0001, v87[v103] / v94);
            v104.track:AdjustWeight(v105, 0.2);
            v104.track:AdjustSpeed(v100);
        else
            v104.track:Stop(0.2);
        end;
    end;
end;
local function u109() --[[ Line: 504 ]]
    -- upvalues: l__Humanoid__2 (copy)
    local l__WalkToPoint__5 = l__Humanoid__2.WalkToPoint;
    local l__WalkToPart__6 = l__Humanoid__2.WalkToPart;
    if l__Humanoid__2.MoveDirection ~= Vector3.new(0, 0, 0) then
        return l__Humanoid__2.MoveDirection;
    end;
    if not l__WalkToPart__6 and l__WalkToPoint__5 == Vector3.new(0, 0, 0) then
        return l__Humanoid__2.MoveDirection;
    end;
    if l__WalkToPart__6 then
        l__WalkToPoint__5 = l__WalkToPart__6.CFrame:PointToWorldSpace(l__WalkToPoint__5);
    end;
    local v107;
    if l__Humanoid__2.RootPart then
        local v108 = l__WalkToPoint__5 - l__Humanoid__2.RootPart.CFrame.Position;
        v107 = Vector3.new(v108.x, 0, v108.z);
        local l__Magnitude__7 = v107.Magnitude;
        if l__Magnitude__7 > 0.01 then
            v107 = v107 / l__Magnitude__7;
        end;
    else
        v107 = Vector3.new(0, 0, 0);
    end;
    return v107;
end;
local function u118(p110) --[[ Line: 531 ]]
    -- upvalues: u59 (ref), u18 (copy), u109 (copy), l__Humanoid__2 (copy), u1 (ref), u6 (ref), u8 (ref), u58 (ref), u57 (ref), u106 (copy)
    if u59 == u18 then
        local v111 = u109();
        if not l__Humanoid__2.RootPart then
            return;
        end;
        local l__CFrame__8 = l__Humanoid__2.RootPart.CFrame;
        if math.abs(l__CFrame__8.UpVector.Y) < 0.0001 or (u1 ~= "Running" or u6 < 0.001) then
            for _, v112 in pairs(u59) do
                if v112.track then
                    v112.track:AdjustWeight(0.0001, 0.2);
                end;
            end;
            return;
        end;
        local l__LookVector__9 = l__CFrame__8.LookVector;
        local v113 = Vector3.new(l__LookVector__9.X, 0, l__LookVector__9.Z);
        local v114 = v113 / v113.Magnitude;
        local v115 = v111:Dot(v114);
        local v116 = Vector2.new(v114.X * v111.Z - v114.Z * v111.X, v115 <= 0 and v115 > -0.05 and 0.0001 or v115);
        local v117 = Vector2.new(v116.x - u8.x, v116.y - u8.y);
        if v117:Dot(v117) > 0.001 or (math.abs(u6 - u58) > 0.01 or p110 - u57 > 1) then
            u8 = v116;
            u58 = u6;
            u57 = p110;
            u106(u8, u58);
        end;
    elseif math.abs(u6 - u58) > 0.01 or p110 - u57 > 1 then
        u58 = u6;
        u57 = p110;
        u106(Vector2.yAxis, u58);
    end;
end;
function setAnimationSpeed(p119)
    -- upvalues: u56 (ref), u14 (ref), u12 (ref)
    if u56 ~= "walk" and p119 ~= u14 then
        u14 = p119;
        u12:AdjustSpeed(u14);
    end;
end;
function keyFrameReachedFunc(p120)
    -- upvalues: u56 (ref), u21 (copy), u68 (ref), u12 (ref), u14 (ref), l__Humanoid__2 (copy)
    if p120 == "End" then
        local v121 = u56;
        local v122 = u21[v121] ~= nil and u21[v121] == false and "idle" or v121;
        if u68 then
            if u12.Looped then
                return;
            end;
            v122 = "idle";
            u68 = false;
        end;
        local v123 = u14;
        playAnimation(v122, 0.15, l__Humanoid__2);
        setAnimationSpeed(v123);
    end;
end;
function rollAnimation(p124)
    -- upvalues: u16 (copy)
    local v125 = math.random(1, u16[p124].totalWeight);
    local v126 = 1;
    while u16[p124][v126].weight < v125 do
        v125 = v125 - u16[p124][v126].weight;
        v126 = v126 + 1;
    end;
    return v126;
end;
local function u131(p127, p128, p129, p130) --[[ Line: 623 ]]
    -- upvalues: u11 (ref), u12 (ref), u13 (ref), u14 (ref), u56 (ref), u36 (copy), u27 (copy)
    if p127 ~= u11 then
        if u12 ~= nil then
            u12:Stop(p129);
            u12:Destroy();
        end;
        if u13 ~= nil then
            u13:disconnect();
        end;
        u14 = 1;
        u56 = p128;
        u11 = p127;
        if p128 == "walk" then
            u36();
            return;
        end;
        u27();
        u12 = p130:LoadAnimation(p127);
        u12.Priority = Enum.AnimationPriority.Core;
        u12:Play(p129);
        u13 = u12.KeyframeReached:connect(keyFrameReachedFunc);
    end;
end;
function playAnimation(p132, p133, p134)
    -- upvalues: u16 (copy), u131 (copy), u68 (ref)
    local v135 = rollAnimation(p132);
    u131(u16[p132][v135].anim, p132, p133, p134);
    u68 = false;
end;
function playEmote(p136, p137, p138)
    -- upvalues: u131 (copy), u68 (ref)
    u131(p136, p136.Name, p137, p138);
    u68 = true;
end;
local u139 = "";
local u140 = nil;
local u141 = nil;
local u142 = nil;
function toolKeyFrameReachedFunc(p143)
    -- upvalues: u139 (ref), l__Humanoid__2 (copy)
    if p143 == "End" then
        playToolAnimation(u139, 0, l__Humanoid__2);
    end;
end;
function playToolAnimation(p144, p145, p146, p147)
    -- upvalues: u16 (copy), u141 (ref), u140 (ref), u139 (ref), u142 (ref)
    local v148 = rollAnimation(p144);
    local l__anim__10 = u16[p144][v148].anim;
    if u141 ~= l__anim__10 then
        if u140 ~= nil then
            u140:Stop();
            u140:Destroy();
            p145 = 0;
        end;
        u140 = p146:LoadAnimation(l__anim__10);
        if p147 then
            u140.Priority = p147;
        end;
        u140:Play(p145);
        u139 = p144;
        u141 = l__anim__10;
        u142 = u140.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;
function stopToolAnimations()
    -- upvalues: u139 (ref), u142 (ref), u141 (ref), u140 (ref)
    local v149 = u139;
    if u142 ~= nil then
        u142:disconnect();
    end;
    u139 = "";
    u141 = nil;
    if u140 ~= nil then
        u140:Stop();
        u140:Destroy();
        u140 = nil;
    end;
    return v149;
end;
function onRunning(p150)
    -- upvalues: u4 (copy), u68 (ref), l__Humanoid__2 (copy), u6 (ref), u1 (ref), u118 (copy), u21 (copy), u56 (ref)
    local v151 = not u4 and 1 or getHeightScale();
    local v152 = u68;
    if v152 then
        v152 = l__Humanoid__2.MoveDirection == Vector3.new(0, 0, 0);
    end;
    local v153 = v152 and (l__Humanoid__2.WalkSpeed / v151 or 0.75) or 0.75;
    u6 = p150;
    if v153 * v151 < p150 then
        playAnimation("walk", 0.2, l__Humanoid__2);
        if u1 ~= "Running" then
            u1 = "Running";
            u118(0);
        end;
    elseif u21[u56] == nil and not u68 then
        playAnimation("idle", 0.2, l__Humanoid__2);
        u1 = "Standing";
    end;
end;
function onDied()
    -- upvalues: u1 (ref)
    u1 = "Dead";
end;
function onJumping()
    -- upvalues: l__Humanoid__2 (copy), u67 (ref), u1 (ref)
    playAnimation("jump", 0.1, l__Humanoid__2);
    u67 = 0.31;
    u1 = "Jumping";
end;
function onClimbing(p154)
    -- upvalues: u4 (copy), l__Humanoid__2 (copy), u1 (ref)
    if u4 then
        p154 = p154 / getHeightScale();
    end;
    playAnimation("climb", 0.1, l__Humanoid__2);
    setAnimationSpeed(p154 / 5);
    u1 = "Climbing";
end;
function onGettingUp()
    -- upvalues: u1 (ref)
    u1 = "GettingUp";
end;
function onFreeFall()
    -- upvalues: u67 (ref), l__Humanoid__2 (copy), u1 (ref)
    if u67 <= 0 then
        playAnimation("fall", 0.2, l__Humanoid__2);
    end;
    u1 = "FreeFall";
end;
function onFallingDown()
    -- upvalues: u1 (ref)
    u1 = "FallingDown";
end;
function onSeated()
    -- upvalues: u1 (ref)
    u1 = "Seated";
end;
function onPlatformStanding()
    -- upvalues: u1 (ref)
    u1 = "PlatformStanding";
end;
function onSwimming(p155)
    -- upvalues: u4 (copy), l__Humanoid__2 (copy), u1 (ref)
    if u4 then
        p155 = p155 / getHeightScale();
    end;
    if p155 > 1 then
        playAnimation("swim", 0.4, l__Humanoid__2);
        setAnimationSpeed(p155 / 10);
        u1 = "Swimming";
    else
        playAnimation("swimidle", 0.4, l__Humanoid__2);
        u1 = "Standing";
    end;
end;
function animateTool()
    -- upvalues: u65 (ref), l__Humanoid__2 (copy)
    if u65 == "None" then
        playToolAnimation("toolnone", 0.1, l__Humanoid__2, Enum.AnimationPriority.Idle);
    elseif u65 == "Slash" then
        playToolAnimation("toolslash", 0, l__Humanoid__2, Enum.AnimationPriority.Action);
    elseif u65 == "Lunge" then
        playToolAnimation("toollunge", 0, l__Humanoid__2, Enum.AnimationPriority.Action);
    end;
end;
function getToolAnim(p156)
    for _, v157 in ipairs(p156:GetChildren()) do
        if v157.Name == "toolanim" and v157.className == "StringValue" then
            return v157;
        end;
    end;
    return nil;
end;
local u158 = 0;
function stepAnimate(p159)
    -- upvalues: u158 (ref), u67 (ref), u1 (ref), l__Humanoid__2 (copy), u118 (copy), l__Parent__1 (copy), u65 (ref), u66 (ref), u141 (ref)
    local v160 = p159 - u158;
    u158 = p159;
    if u67 > 0 then
        u67 = u67 - v160;
    end;
    if u1 == "FreeFall" and u67 <= 0 then
        playAnimation("fall", 0.2, l__Humanoid__2);
    else
        if u1 == "Seated" then
            playAnimation("sit", 0.5, l__Humanoid__2);
            return;
        end;
        if u1 == "Running" then
            playAnimation("walk", 0.2, l__Humanoid__2);
            u118(p159);
        elseif u1 == "Dead" or (u1 == "GettingUp" or (u1 == "FallingDown" or (u1 == "Seated" or u1 == "PlatformStanding"))) then
            stopAllAnimations();
        end;
    end;
    local v161 = l__Parent__1:FindFirstChildOfClass("Tool");
    if v161 and v161:FindFirstChild("Handle") then
        local v162 = getToolAnim(v161);
        if v162 then
            u65 = v162.Value;
            v162.Parent = nil;
            u66 = p159 + 0.3;
        end;
        if u66 < p159 then
            u66 = 0;
            u65 = "None";
        end;
        animateTool();
    else
        stopToolAnimations();
        u65 = "None";
        u141 = nil;
        u66 = 0;
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
game:GetService("Players").LocalPlayer.Chatted:connect(function(p163) --[[ Line: 914 ]]
    -- upvalues: u1 (ref), u21 (copy), l__Humanoid__2 (copy)
    local v164 = "";
    if string.sub(p163, 1, 3) == "/e " then
        v164 = string.sub(p163, 4);
    elseif string.sub(p163, 1, 7) == "/emote " then
        v164 = string.sub(p163, 8);
    end;
    if u1 == "Standing" and u21[v164] ~= nil then
        playAnimation(v164, 0.1, l__Humanoid__2);
    end;
end);
script:WaitForChild("PlayEmote").OnInvoke = function(p165) --[[ Line: 928 ]]
    -- upvalues: u1 (ref), u21 (copy), l__Humanoid__2 (copy), u12 (ref)
    if u1 == "Standing" then
        if u21[p165] ~= nil then
            playAnimation(p165, 0.1, l__Humanoid__2);
            return true, u12;
        end;
        if typeof(p165) ~= "Instance" or not p165:IsA("Animation") then
            return false;
        end;
        playEmote(p165, 0.1, l__Humanoid__2);
        return true, u12;
    end;
end;
if l__Parent__1.Parent ~= nil then
    playAnimation("idle", 0.1, l__Humanoid__2);
    local _ = "Standing";
end;
while l__Parent__1.Parent ~= nil do
    local _, v166 = wait(0.1);
    stepAnimate(v166);
end;