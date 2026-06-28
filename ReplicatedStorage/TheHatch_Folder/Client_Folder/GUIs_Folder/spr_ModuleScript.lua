-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.spr
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local l__exp__2 = math.exp;
local l__sin__3 = math.sin;
local l__cos__4 = math.cos;
local l__min__5 = math.min;
local l__sqrt__6 = math.sqrt;
local l__round__7 = math.round;
local u1 = {};
u1.__index = u1;
function u1.new(p2, p3, p4, p5, p6) --[[ Line: 91 ]]
    -- upvalues: u1 (copy)
    local v7 = p6.toIntermediate(p4);
    local v8 = {
        d = p2,
        f = p3,
        g = v7,
        p = v7,
        v = table.create(#v7, 0),
        typedat = p6,
        rawGoal = p5
    };
    return setmetatable(v8, u1);
end;
function u1.setGoal(p9, p10) --[[ Line: 107 ]]
    p9.rawGoal = p10;
    p9.g = p9.typedat.toIntermediate(p10);
end;
function u1.setVelocity(p11, p12) --[[ Line: 112 ]]
    p11.v = p11.typedat.toIntermediate(p12);
end;
function u1.setDampingRatio(p13, p14) --[[ Line: 116 ]]
    p13.d = p14;
end;
function u1.setFrequency(p15, p16) --[[ Line: 120 ]]
    p15.f = p16;
end;
function u1.canSleep(p17) --[[ Line: 124 ]]
    local v18 = 0;
    for _, v19 in p17.v do
        v18 = v18 + v19 ^ 2;
    end;
    if v18 > 0.0001 then
        return false;
    end;
    local l__p__8 = p17.p;
    local l__g__9 = p17.g;
    local v20 = 0;
    for v21, v22 in l__p__8 do
        v20 = v20 + (l__g__9[v21] - v22) ^ 2;
    end;
    return v20 <= 6.781684027777778e-8;
end;
function u1.step(p23, p24) --[[ Line: 136 ]]
    -- upvalues: l__exp__2 (copy), l__sqrt__6 (copy), l__cos__4 (copy), l__sin__3 (copy)
    local l__d__10 = p23.d;
    local v25 = p23.f * 2 * 3.141592653589793;
    local l__g__11 = p23.g;
    local l__p__12 = p23.p;
    local l__v__13 = p23.v;
    if l__d__10 == 1 then
        local v26 = l__exp__2(-v25 * p24);
        local v27 = p24 * v26;
        local v28 = v26 + v27 * v25;
        local v29 = v26 - v27 * v25;
        local v30 = v27 * v25 * v25;
        for v31 = 1, #l__p__12 do
            local v32 = l__p__12[v31] - l__g__11[v31];
            l__p__12[v31] = v32 * v28 + l__v__13[v31] * v27 + l__g__11[v31];
            l__v__13[v31] = l__v__13[v31] * v29 - v32 * v30;
        end;
    elseif l__d__10 < 1 then
        local v33 = l__exp__2(-l__d__10 * v25 * p24);
        local v34 = l__sqrt__6(1 - l__d__10 * l__d__10);
        local v35 = l__cos__4(p24 * v25 * v34);
        local v36 = l__sin__3(p24 * v25 * v34);
        local v37;
        if v34 > 0.00001 then
            v37 = v36 / v34;
        else
            local v38 = p24 * v25;
            v37 = v38 + (v38 * v38 * (v34 * v34) * (v34 * v34) / 20 - v34 * v34) * (v38 * v38 * v38) / 6;
        end;
        local v39;
        if v25 * v34 > 0.00001 then
            v39 = v36 / (v25 * v34);
        else
            local v40 = v25 * v34;
            v39 = p24 + (p24 * p24 * (v40 * v40) * (v40 * v40) / 20 - v40 * v40) * (p24 * p24 * p24) / 6;
        end;
        for v41 = 1, #l__p__12 do
            local v42 = l__p__12[v41] - l__g__11[v41];
            l__p__12[v41] = (v42 * (v35 + v37 * l__d__10) + l__v__13[v41] * v39) * v33 + l__g__11[v41];
            l__v__13[v41] = (l__v__13[v41] * (v35 - v37 * l__d__10) - v42 * (v37 * v25)) * v33;
        end;
    else
        local v43 = l__sqrt__6(l__d__10 * l__d__10 - 1);
        local v44 = -v25 * (l__d__10 - v43);
        local v45 = -v25 * (l__d__10 + v43);
        local v46 = l__exp__2(v44 * p24);
        local v47 = l__exp__2(v45 * p24);
        for v48 = 1, #l__p__12 do
            local v49 = l__p__12[v48] - l__g__11[v48];
            local v50 = (l__v__13[v48] - v49 * v44) / (2 * v25 * v43);
            local v51 = v46 * (v49 - v50);
            l__p__12[v48] = v51 + v50 * v47 + l__g__11[v48];
            l__v__13[v48] = v51 * v44 + v50 * v47 * v45;
        end;
    end;
    return p23.typedat.fromIntermediate(p23.p);
end;
local u52 = {};
u52.__index = u52;
function u52.new(p53, p54, p55, p56) --[[ Line: 270 ]]
    -- upvalues: u52 (copy)
    return setmetatable({
        v = Vector3.new(0, 0, 0),
        d = p53,
        f = p54,
        g = p56,
        p = p55
    }, u52);
end;
function u52.setGoal(p57, p58) --[[ Line: 283 ]]
    p57.g = p58;
end;
function u52.setVelocity(p59, p60) --[[ Line: 287 ]]
    local v61, v62 = p60:ToAxisAngle();
    p59.v = v61 * v62;
end;
function u52.setDampingRatio(p63, p64) --[[ Line: 291 ]]
    p63.d = p64;
end;
function u52.setFrequency(p65, p66) --[[ Line: 295 ]]
    p65.f = p66;
end;
function u52.canSleep(p67) --[[ Line: 299 ]]
    local _, v68 = p67.g:ToObjectSpace(p67.p):ToAxisAngle();
    return math.abs(v68) < 0.00017453292519943296 and p67.v.Magnitude < 0.0017453292519943296;
end;
function u52.step(p69, p70) --[[ Line: 305 ]]
    -- upvalues: l__exp__2 (copy), l__sqrt__6 (copy), l__cos__4 (copy), l__sin__3 (copy)
    local l__d__14 = p69.d;
    local v71 = p69.f * 2 * 3.141592653589793;
    local l__g__15 = p69.g;
    local l__p__16 = p69.p;
    local l__v__17 = p69.v;
    local v72, v73 = (l__p__16 * l__g__15:Inverse()):ToAxisAngle();
    local v74 = v72 * v73;
    local v75 = l__exp__2(-l__d__14 * v71 * p70);
    local v76, v77;
    if l__d__14 == 1 then
        local _ = p70 * v75;
        local v78 = (v74 * (1 + v71 * p70) + l__v__17 * p70) * v75;
        local l__Magnitude__18 = v78.Magnitude;
        local v79;
        if l__Magnitude__18 > 1e-6 then
            v79 = CFrame.fromAxisAngle(v78.Unit, l__Magnitude__18);
        else
            v79 = CFrame.identity;
        end;
        v76 = v79 * l__g__15;
        v77 = (l__v__17 * (1 - p70 * v71) - v74 * (p70 * v71 * v71)) * v75;
    elseif l__d__14 < 1 then
        local v80 = l__sqrt__6(1 - l__d__14 * l__d__14);
        local v81 = l__cos__4(p70 * v71 * v80);
        local v82 = l__sin__3(p70 * v71 * v80);
        local v83 = v82 / (v71 * v80);
        local v84 = v82 / v80;
        local v85 = (v74 * (v81 + v84 * l__d__14) + l__v__17 * v83) * v75;
        local l__Magnitude__19 = v85.Magnitude;
        local v86;
        if l__Magnitude__19 > 1e-6 then
            v86 = CFrame.fromAxisAngle(v85.Unit, l__Magnitude__19);
        else
            v86 = CFrame.identity;
        end;
        v76 = v86 * l__g__15;
        v77 = (l__v__17 * (v81 - v84 * l__d__14) - v74 * (v84 * v71)) * v75;
    else
        local v87 = l__sqrt__6(l__d__14 * l__d__14 - 1);
        local v88 = -v71 * (l__d__14 - v87);
        local v89 = -v71 * (l__d__14 + v87);
        local v90 = (l__v__17 - v74 * v88) / (2 * v71 * v87);
        local v91 = (v74 - v90) * l__exp__2(v88 * p70);
        local v92 = v90 * l__exp__2(v89 * p70);
        local v93 = v91 + v92;
        local l__Magnitude__20 = v93.Magnitude;
        local v94;
        if l__Magnitude__20 > 1e-6 then
            v94 = CFrame.fromAxisAngle(v93.Unit, l__Magnitude__20);
        else
            v94 = CFrame.identity;
        end;
        v76 = v94 * l__g__15;
        v77 = v91 * v88 + v92 * v89;
    end;
    p69.p = v76;
    p69.v = v77;
    return v76;
end;
local u97 = {
    springType = u1.new,
    toIntermediate = function(p95) --[[ Name: toIntermediate, Line 363 ]]
        return { p95.X, p95.Y, p95.Z };
    end,
    fromIntermediate = function(p96) --[[ Name: fromIntermediate, Line 367 ]]
        return Vector3.new(p96[1], p96[2], p96[3]);
    end
};
local u98 = {};
u98.__index = u98;
function u98.new(p99, p100, p101, p102, _) --[[ Line: 377 ]]
    -- upvalues: u1 (copy), u97 (copy), u52 (copy), u98 (copy)
    local v103 = {
        rawGoal = p102,
        _position = u1.new(p99, p100, p101.Position, p102.Position, u97),
        _rotation = u52.new(p99, p100, p101.Rotation, p102.Rotation)
    };
    return setmetatable(v103, u98);
end;
function u98.setGoal(p104, p105) --[[ Line: 394 ]]
    p104.rawGoal = p105;
    p104._position:setGoal(p105.Position);
    p104._rotation:setGoal(p105.Rotation);
end;
function u98.setDampingRatio(p106, p107) --[[ Line: 400 ]]
    p106._position:setDampingRatio(p107);
    p106._rotation:setDampingRatio(p107);
end;
function u98.setFrequency(p108, p109) --[[ Line: 405 ]]
    p108._position:setFrequency(p109);
    p108._rotation:setFrequency(p109);
end;
function u98.canSleep(p110) --[[ Line: 410 ]]
    local v111 = p110._position:canSleep();
    if v111 then
        v111 = p110._rotation:canSleep();
    end;
    return v111;
end;
function u98.step(p112, p113) --[[ Line: 414 ]]
    local v114 = p112._position:step(p113);
    return p112._rotation:step(p113) + v114;
end;
local function u125(p115) --[[ Line: 433 ]]
    local l__R__21 = p115.R;
    local l__G__22 = p115.G;
    local l__B__23 = p115.B;
    local v116 = l__R__21 < 0.0404482362771076 and l__R__21 / 12.92 or 0.87941546140213 * (l__R__21 + 0.055) ^ 2.4;
    local v117 = l__G__22 < 0.0404482362771076 and l__G__22 / 12.92 or 0.87941546140213 * (l__G__22 + 0.055) ^ 2.4;
    local v118 = l__B__23 < 0.0404482362771076 and l__B__23 / 12.92 or 0.87941546140213 * (l__B__23 + 0.055) ^ 2.4;
    local v119 = 0.9257063972951867 * v116 - 0.8333736323779866 * v117 - 0.09209820666085898 * v118;
    local v120 = 0.2125862307855956 * v116 + 0.7151703037034108 * v117 + 0.0722004986433362 * v118;
    local v121 = 3.6590806972265884 * v116 + 11.442689580057424 * v117 + 4.114991502426484 * v118;
    local v122 = v120 > 0.008856451679035631 and 116 * v120 ^ 0.3333333333333333 - 16 or 903.296296296296 * v120;
    local v123, v124;
    if v121 > 1e-14 then
        v123 = v122 * v119 / v121;
        v124 = v122 * (9 * v120 / v121 - 0.46832);
    else
        v123 = -0.19783 * v122;
        v124 = -0.46832 * v122;
    end;
    return { v122, v123, v124 };
end;
local function u137(p126) --[[ Line: 462 ]]
    -- upvalues: l__min__5 (copy)
    local v127 = p126[1];
    if v127 < 0.0197955 then
        return Color3.new(0, 0, 0);
    end;
    local v128 = p126[2] / v127 + 0.19783;
    local v129 = p126[3] / v127 + 0.46832;
    local v130 = (v127 + 16) / 116;
    local v131 = v130 > 0.20689655172413793 and v130 * v130 * v130 or v130 * 0.12841854934601665 - 0.01771290335807126;
    local v132 = v131 * v128 / v129;
    local v133 = v131 * ((3 - v128 * 0.75) / v129 - 5);
    local v134 = v132 * 7.2914074 - v131 * 1.537208 - v133 * 0.4986286;
    local v135 = v132 * -2.180094 + v131 * 1.8757561 + v133 * 0.0415175;
    local v136 = v132 * 0.1253477 - v131 * 0.2040211 + v133 * 1.0569959;
    if v134 < 0 and (v134 < v135 and v134 < v136) then
        v135 = v135 - v134;
        v136 = v136 - v134;
        v134 = 0;
    elseif v135 < 0 and v135 < v136 then
        v134 = v134 - v135;
        v136 = v136 - v135;
        v135 = 0;
    elseif v136 < 0 then
        v134 = v134 - v136;
        v135 = v135 - v136;
        v136 = 0;
    end;
    return Color3.new(l__min__5(v134 < 0.0031306684425 and 12.92 * v134 or 1.055 * v134 ^ 0.4166666666666667 - 0.055, 1), l__min__5(v135 < 0.0031306684425 and 12.92 * v135 or 1.055 * v135 ^ 0.4166666666666667 - 0.055, 1), (l__min__5(v136 < 0.0031306684425 and 12.92 * v136 or 1.055 * v136 ^ 0.4166666666666667 - 0.055, 1)));
end;
local u154 = {
    boolean = {
        springType = u1.new,
        toIntermediate = function(p138) --[[ Name: toIntermediate, Line 508 ]]
            return { p138 and 1 or 0 };
        end,
        fromIntermediate = function(p139) --[[ Name: fromIntermediate, Line 512 ]]
            return p139[1] >= 0.5;
        end
    },
    number = {
        springType = u1.new,
        toIntermediate = function(p140) --[[ Name: toIntermediate, Line 520 ]]
            return { p140 };
        end,
        fromIntermediate = function(p141) --[[ Name: fromIntermediate, Line 524 ]]
            return p141[1];
        end
    },
    NumberRange = {
        springType = u1.new,
        toIntermediate = function(p142) --[[ Name: toIntermediate, Line 532 ]]
            return { p142.Min, p142.Max };
        end,
        fromIntermediate = function(p143) --[[ Name: fromIntermediate, Line 536 ]]
            return NumberRange.new(p143[1], p143[2]);
        end
    },
    UDim = {
        springType = u1.new,
        toIntermediate = function(p144) --[[ Name: toIntermediate, Line 544 ]]
            return { p144.Scale, p144.Offset };
        end,
        fromIntermediate = function(p145) --[[ Name: fromIntermediate, Line 548 ]]
            -- upvalues: l__round__7 (copy)
            return UDim.new(p145[1], (l__round__7(p145[2])));
        end
    },
    UDim2 = {
        springType = u1.new,
        toIntermediate = function(p146) --[[ Name: toIntermediate, Line 556 ]]
            local l__X__24 = p146.X;
            local l__Y__25 = p146.Y;
            return {
                l__X__24.Scale,
                l__X__24.Offset,
                l__Y__25.Scale,
                l__Y__25.Offset
            };
        end,
        fromIntermediate = function(p147) --[[ Name: fromIntermediate, Line 562 ]]
            -- upvalues: l__round__7 (copy)
            return UDim2.new(p147[1], l__round__7(p147[2]), p147[3], (l__round__7(p147[4])));
        end
    },
    Vector2 = {
        springType = u1.new,
        toIntermediate = function(p148) --[[ Name: toIntermediate, Line 570 ]]
            return { p148.X, p148.Y };
        end,
        fromIntermediate = function(p149) --[[ Name: fromIntermediate, Line 574 ]]
            return Vector2.new(p149[1], p149[2]);
        end
    },
    Vector3 = u97,
    Color3 = {
        springType = u1.new,
        toIntermediate = u125,
        fromIntermediate = u137
    },
    ColorSequence = {
        springType = u1.new,
        toIntermediate = function(p150) --[[ Name: toIntermediate, Line 591 ]]
            -- upvalues: u125 (ref)
            local l__Keypoints__26 = p150.Keypoints;
            local v151 = u125(l__Keypoints__26[1].Value);
            local v152 = u125(l__Keypoints__26[#l__Keypoints__26].Value);
            return {
                v151[1],
                v151[2],
                v151[3],
                v152[1],
                v152[2],
                v152[3]
            };
        end,
        fromIntermediate = function(p153) --[[ Name: fromIntermediate, Line 603 ]]
            -- upvalues: u137 (ref)
            return ColorSequence.new(u137({ p153[1], p153[2], p153[3] }), u137({ p153[4], p153[5], p153[6] }));
        end
    },
    CFrame = {
        springType = u98.new,
        toIntermediate = error,
        fromIntermediate = error
    }
};
local u161 = {
    Pivot = {
        class = "PVInstance",
        get = function(p155) --[[ Name: get, Line 629 ]]
            return p155:GetPivot();
        end,
        set = function(p156, p157) --[[ Name: set, Line 632 ]]
            p156:PivotTo(p157);
        end
    },
    Scale = {
        class = "Model",
        get = function(p158) --[[ Name: get, Line 638 ]]
            return p158:GetScale();
        end,
        set = function(p159, p160) --[[ Name: set, Line 641 ]]
            p159:ScaleTo(p160);
        end
    }
};
local u162 = {};
local u163 = {};
l__RunService__1.Heartbeat:Connect(function(p164) --[[ Line: 651 ]]
    -- upvalues: u162 (copy), u161 (copy), u163 (copy)
    for v165, v166 in u162 do
        for v167, v168 in v166 do
            local v169 = u161[v167];
            if v169 and v165:IsA(v169.class) then
                if v168:canSleep() then
                    v166[v167] = nil;
                    v169.set(v165, v168.rawGoal);
                else
                    v169.set(v165, v168:step(p164));
                end;
            elseif v168:canSleep() then
                v166[v167] = nil;
                v165[v167] = v168.rawGoal;
            else
                v165[v167] = v168:step(p164);
            end;
        end;
        if not next(v166) then
            u162[v165] = nil;
            local v170 = u163[v165];
            if v170 then
                u163[v165] = nil;
                for _, v171 in v170 do
                    task.spawn(v171);
                end;
            end;
        end;
    end;
end);
return table.freeze({
    target = function(p172, p173, p174, p175) --[[ Name: target, Line 700 ]]
        -- upvalues: u162 (copy), u161 (copy), u154 (copy)
        if not ("Instance"):find((typeof(p172))) then
            error(`bad argument #{1} to spr.target (Instance expected, got {typeof(p172)})`, 3);
        end;
        if not ("number"):find((typeof(p173))) then
            error(`bad argument #{2} to spr.target (number expected, got {typeof(p173)})`, 3);
        end;
        if not ("number"):find((typeof(p174))) then
            error(`bad argument #{3} to spr.target (number expected, got {typeof(p174)})`, 3);
        end;
        if not ("table"):find((typeof(p175))) then
            error(`bad argument #{4} to spr.target (table expected, got {typeof(p175)})`, 3);
        end;
        if p173 ~= p173 or p173 < 0 then
            error(("expected damping ratio >= 0; got %.2f"):format(p173), 2);
        end;
        if p174 ~= p174 or p174 < 0 then
            error(("expected undamped frequency >= 0; got %.2f"):format(p174), 2);
        end;
        local v176 = u162[p172];
        if not v176 then
            v176 = {};
            u162[p172] = v176;
        end;
        for v177, v178 in p175 do
            local v179 = u161[v177];
            local v180;
            if v179 and p172:IsA(v179.class) then
                v180 = v179.get(p172);
            else
                v180 = p172[v177];
            end;
            if typeof(v178) ~= typeof(v180) then
                error(`bad property {v177} to spr.target ({typeof(v180)} expected, got {typeof(v178)})`, 2);
            end;
            if p174 == (1 / 0) then
                p172[v177] = v178;
                v176[v177] = nil;
            else
                local v181 = v176[v177];
                if not v181 then
                    local v182 = u154[typeof(v178)];
                    if not v182 then
                        error("unsupported type: " .. typeof(v178), 2);
                    end;
                    v181 = v182.springType(p173, p174, v180, v178, v182);
                    v176[v177] = v181;
                end;
                v181:setGoal(v178);
                v181:setDampingRatio(p173);
                v181:setFrequency(p174);
            end;
        end;
        if not next(v176) then
            u162[p172] = nil;
        end;
    end,
    stop = function(p183, p184) --[[ Name: stop, Line 763 ]]
        -- upvalues: u162 (copy)
        if not ("Instance"):find((typeof(p183))) then
            error(`bad argument #{1} to spr.stop (Instance expected, got {typeof(p183)})`, 3);
        end;
        if not ("string|nil"):find((typeof(p184))) then
            error(`bad argument #{2} to spr.stop (string|nil expected, got {typeof(p184)})`, 3);
        end;
        if p184 then
            local v185 = u162[p183];
            if v185 then
                v185[p184] = nil;
            end;
        else
            u162[p183] = nil;
        end;
    end,
    completed = function(p186, p187) --[[ Name: completed, Line 779 ]]
        -- upvalues: u163 (copy)
        if not ("Instance"):find((typeof(p186))) then
            error(`bad argument #{1} to spr.completed (Instance expected, got {typeof(p186)})`, 3);
        end;
        if not ("function"):find((typeof(p187))) then
            error(`bad argument #{2} to spr.completed (function expected, got {typeof(p187)})`, 3);
        end;
        local v188 = u163[p186];
        if v188 then
            table.insert(v188, p187);
        else
            u163[p186] = { p187 };
        end;
    end,
    setVelocity = function(p189, p190) --[[ Name: setVelocity, Line 793 ]]
        -- upvalues: u162 (copy), u161 (copy)
        local v191 = u162[p189];
        if v191 then
            for v192, v193 in p190 do
                local v194 = u161[v192];
                local v195;
                if v194 and p189:IsA(v194.class) then
                    v195 = v194.get(p189);
                else
                    v195 = p189[v192];
                end;
                if typeof(v193) ~= typeof(v195) then
                    error(`bad property {v192} to spr.setVelocity ({typeof(v195)} expected, got {typeof(v193)})`, 2);
                end;
                local v196 = v191[v192];
                if v196 then
                    v196:setVelocity(v193);
                end;
            end;
            if not next(v191) then
                u162[p189] = nil;
            end;
        end;
    end
});