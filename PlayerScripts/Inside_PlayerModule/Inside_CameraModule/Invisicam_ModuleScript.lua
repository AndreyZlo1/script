-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.Invisicam
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local u1 = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9
};
local u2 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true
};
local u3 = {
    Vector3.new(1, 1, -1),
    Vector3.new(1, -1, -1),
    Vector3.new(-1, -1, -1),
    Vector3.new(-1, 1, -1)
};
local function u9(p4, ...) --[[ Line: 59 ]]
    local v5 = {};
    local v6 = "";
    for _, v7 in pairs({ ... }) do
        v5[v7] = true;
        v6 = v6 .. (v6 == "" and "" or " or ") .. v7;
    end;
    local v8 = type(p4);
    assert(v5[v8], v6 .. " type expected, got: " .. v8);
end;
local function u29(p10, p11, p12, p13) --[[ Line: 79 ]]
    local v14 = p11:Cross(p13);
    local v15 = p12.X - p10.X;
    local v16 = p12.Y - p10.Y;
    local v17 = p12.Z - p10.Z;
    local l__X__2 = p11.X;
    local v18 = -p13.X;
    local l__X__3 = v14.X;
    local l__Y__4 = p11.Y;
    local v19 = -p13.Y;
    local l__Y__5 = v14.Y;
    local l__Z__6 = p11.Z;
    local v20 = -p13.Z;
    local l__Z__7 = v14.Z;
    local v21 = l__X__2 * (v19 * l__Z__7 - l__Y__5 * v20) - v18 * (l__Y__4 * l__Z__7 - l__Y__5 * l__Z__6) + l__X__3 * (l__Y__4 * v20 - v19 * l__Z__6);
    if v21 == 0 then
        return Vector3.new(0, 0, 0);
    end;
    local v22 = -p13.X;
    local l__X__8 = v14.X;
    local v23 = -p13.Y;
    local l__Y__9 = v14.Y;
    local v24 = -p13.Z;
    local l__Z__10 = v14.Z;
    local v25 = (v15 * (v23 * l__Z__10 - l__Y__9 * v24) - v22 * (v16 * l__Z__10 - l__Y__9 * v17) + l__X__8 * (v16 * v24 - v23 * v17)) / v21;
    local l__X__11 = p11.X;
    local l__X__12 = v14.X;
    local l__Y__13 = p11.Y;
    local l__Y__14 = v14.Y;
    local l__Z__15 = p11.Z;
    local l__Z__16 = v14.Z;
    local v26 = (l__X__11 * (v16 * l__Z__16 - l__Y__14 * v17) - v15 * (l__Y__13 * l__Z__16 - l__Y__14 * l__Z__15) + l__X__12 * (l__Y__13 * v17 - v16 * l__Z__15)) / v21;
    local v27 = p10 + v25 * p11;
    local v28 = p12 + v26 * p13;
    return (v28 - v27).Magnitude >= 0.25 and Vector3.new(0, 0, 0) or v27 + (v28 - v27) * 0.5;
end;
local l__BaseOcclusion__17 = require(script.Parent:WaitForChild("BaseOcclusion"));
local u30 = setmetatable({}, l__BaseOcclusion__17);
u30.__index = u30;
function u30.new() --[[ Line: 112 ]]
    -- upvalues: l__BaseOcclusion__17 (copy), u30 (copy), u1 (copy)
    local v31 = l__BaseOcclusion__17.new();
    local v32 = setmetatable(v31, u30);
    v32.char = nil;
    v32.humanoidRootPart = nil;
    v32.torsoPart = nil;
    v32.headPart = nil;
    v32.childAddedConn = nil;
    v32.childRemovedConn = nil;
    v32.behaviors = {};
    v32.behaviors[u1.LIMBS] = v32.LimbBehavior;
    v32.behaviors[u1.MOVEMENT] = v32.MoveBehavior;
    v32.behaviors[u1.CORNERS] = v32.CornerBehavior;
    v32.behaviors[u1.CIRCLE1] = v32.CircleBehavior;
    v32.behaviors[u1.CIRCLE2] = v32.CircleBehavior;
    v32.behaviors[u1.LIMBMOVE] = v32.LimbMoveBehavior;
    v32.behaviors[u1.SMART_CIRCLE] = v32.SmartCircleBehavior;
    v32.behaviors[u1.CHAR_OUTLINE] = v32.CharacterOutlineBehavior;
    v32.mode = u1.SMART_CIRCLE;
    v32.behaviorFunction = v32.SmartCircleBehavior;
    v32.savedHits = {};
    v32.trackedLimbs = {};
    v32.camera = game.Workspace.CurrentCamera;
    v32.enabled = false;
    return v32;
end;
function u30.Enable(p33, p34) --[[ Line: 145 ]]
    p33.enabled = p34;
    if not p34 then
        p33:Cleanup();
    end;
end;
function u30.GetOcclusionMode(_) --[[ Line: 153 ]]
    return Enum.DevCameraOcclusionMode.Invisicam;
end;
function u30.LimbBehavior(p35, p36) --[[ Line: 158 ]]
    for v37, _ in pairs(p35.trackedLimbs) do
        p36[#p36 + 1] = v37.Position;
    end;
end;
function u30.MoveBehavior(p38, p39) --[[ Line: 164 ]]
    for v40 = 1, 3 do
        local l__Position__18 = p38.humanoidRootPart.Position;
        local l__Velocity__19 = p38.humanoidRootPart.Velocity;
        local v41 = Vector3.new(l__Velocity__19.X, 0, l__Velocity__19.Z).Magnitude / 2;
        p39[#p39 + 1] = l__Position__18 + (v40 - 1) * p38.humanoidRootPart.CFrame.lookVector * v41;
    end;
end;
function u30.CornerBehavior(p42, p43) --[[ Line: 173 ]]
    -- upvalues: u3 (copy)
    local l__CFrame__20 = p42.humanoidRootPart.CFrame;
    local l__Position__21 = l__CFrame__20.Position;
    local v44 = l__CFrame__20 - l__Position__21;
    local v45 = p42.char:GetExtentsSize() / 2;
    p43[#p43 + 1] = l__Position__21;
    for v46 = 1, #u3 do
        p43[#p43 + 1] = l__Position__21 + v44 * (v45 * u3[v46]);
    end;
end;
function u30.CircleBehavior(p47, p48) --[[ Line: 184 ]]
    -- upvalues: u1 (copy)
    local v49;
    if p47.mode == u1.CIRCLE1 then
        v49 = p47.humanoidRootPart.CFrame;
    else
        local l__CoordinateFrame__22 = p47.camera.CoordinateFrame;
        v49 = l__CoordinateFrame__22 - l__CoordinateFrame__22.Position + p47.humanoidRootPart.Position;
    end;
    p48[#p48 + 1] = v49.Position;
    for v50 = 0, 9 do
        local v51 = 0.6283185307179586 * v50;
        local v52 = math.cos(v51);
        local v53 = math.sin(v51);
        local v54 = Vector3.new(v52, v53, 0) * 3;
        p48[#p48 + 1] = v49 * v54;
    end;
end;
function u30.LimbMoveBehavior(p55, p56) --[[ Line: 200 ]]
    p55:LimbBehavior(p56);
    p55:MoveBehavior(p56);
end;
function u30.CharacterOutlineBehavior(p57, p58) --[[ Line: 205 ]]
    local l__unit__23 = p57.torsoPart.CFrame.upVector.unit;
    local l__unit__24 = p57.torsoPart.CFrame.rightVector.unit;
    p58[#p58 + 1] = p57.torsoPart.CFrame.p;
    p58[#p58 + 1] = p57.torsoPart.CFrame.p + l__unit__23;
    p58[#p58 + 1] = p57.torsoPart.CFrame.p - l__unit__23;
    p58[#p58 + 1] = p57.torsoPart.CFrame.p + l__unit__24;
    p58[#p58 + 1] = p57.torsoPart.CFrame.p - l__unit__24;
    if p57.headPart then
        p58[#p58 + 1] = p57.headPart.CFrame.p;
    end;
    local v59 = CFrame.new(Vector3.new(0, 0, 0), (Vector3.new(p57.camera.CoordinateFrame.lookVector.X, 0, p57.camera.CoordinateFrame.lookVector.Z)));
    local v60 = p57.torsoPart and p57.torsoPart.Position or p57.humanoidRootPart.Position;
    local v61 = { p57.torsoPart };
    if p57.headPart then
        v61[#v61 + 1] = p57.headPart;
    end;
    for v62 = 1, 24 do
        local v63 = 6.283185307179586 * v62 / 24;
        local v64 = math.cos(v63);
        local v65 = math.sin(v63);
        local v66 = v59 * (Vector3.new(v64, v65, 0) * 3);
        local l__X__25 = v66.X;
        local v67 = math.max(v66.Y, -2.25);
        local v68 = Vector3.new(l__X__25, v67, v66.Z);
        local v69 = Ray.new(v60 + v68, -3 * v68);
        local v70, v71 = game.Workspace:FindPartOnRayWithWhitelist(v69, v61, false);
        if v70 then
            p58[#p58 + 1] = v71 + 0.2 * (v60 - v71).unit;
        end;
    end;
end;
function u30.SmartCircleBehavior(p72, p73) --[[ Line: 244 ]]
    -- upvalues: u29 (copy)
    local l__unit__26 = p72.torsoPart.CFrame.upVector.unit;
    local l__unit__27 = p72.torsoPart.CFrame.rightVector.unit;
    p73[#p73 + 1] = p72.torsoPart.CFrame.p;
    p73[#p73 + 1] = p72.torsoPart.CFrame.p + l__unit__26;
    p73[#p73 + 1] = p72.torsoPart.CFrame.p - l__unit__26;
    p73[#p73 + 1] = p72.torsoPart.CFrame.p + l__unit__27;
    p73[#p73 + 1] = p72.torsoPart.CFrame.p - l__unit__27;
    if p72.headPart then
        p73[#p73 + 1] = p72.headPart.CFrame.p;
    end;
    local v74 = p72.camera.CFrame - p72.camera.CFrame.p;
    local v75 = Vector3.new(0, 0.5, 0) + (p72.torsoPart and p72.torsoPart.Position or p72.humanoidRootPart.Position);
    for v76 = 1, 24 do
        local v77 = 0.2617993877991494 * v76 - 1.5707963267948966;
        local v78 = math.cos(v77);
        local v79 = math.sin(v77);
        local v80 = v75 + v74 * (Vector3.new(v78, v79, 0) * 2.5);
        local v81 = v80 - p72.camera.CFrame.p;
        local v82 = Ray.new(v75, v80 - v75);
        local v83, v84, v85 = game.Workspace:FindPartOnRayWithIgnoreList(v82, { p72.char }, false, false);
        if v83 then
            local v86 = v84 + 0.1 * v85.unit;
            local v87 = v86 - v75;
            local l__unit__28 = v87:Cross(v81).unit:Cross(v85).unit;
            local l__unit__29 = (v86 - p72.camera.CFrame.p).unit;
            if v87.unit:Dot(-l__unit__28) < v87.unit:Dot(l__unit__29) then
                v80 = u29(v86, l__unit__28, v80, v81);
                if v80.Magnitude > 0 then
                    local v88 = Ray.new(v86, v80 - v86);
                    local v89, v90, v91 = game.Workspace:FindPartOnRayWithIgnoreList(v88, { p72.char }, false, false);
                    if v89 then
                        v80 = v90 + 0.1 * v91.unit;
                    end;
                else
                    v80 = v86;
                end;
            else
                v80 = v86;
            end;
            local v92 = Ray.new(v75, v80 - v75);
            local v93, v94, _ = game.Workspace:FindPartOnRayWithIgnoreList(v92, { p72.char }, false, false);
            if v93 then
                v80 = v94 - 0.1 * (v80 - v75).unit;
            end;
        end;
        p73[#p73 + 1] = v80;
    end;
end;
function u30.CheckTorsoReference(p95) --[[ Line: 329 ]]
    if p95.char then
        p95.torsoPart = p95.char:FindFirstChild("Torso");
        if not p95.torsoPart then
            p95.torsoPart = p95.char:FindFirstChild("UpperTorso");
            if not p95.torsoPart then
                p95.torsoPart = p95.char:FindFirstChild("HumanoidRootPart");
            end;
        end;
        p95.headPart = p95.char:FindFirstChild("Head");
    end;
end;
function u30.CharacterAdded(u96, p97, p98) --[[ Line: 343 ]]
    -- upvalues: l__Players__1 (copy), u2 (copy)
    if p98 == l__Players__1.LocalPlayer then
        if u96.childAddedConn then
            u96.childAddedConn:Disconnect();
            u96.childAddedConn = nil;
        end;
        if u96.childRemovedConn then
            u96.childRemovedConn:Disconnect();
            u96.childRemovedConn = nil;
        end;
        u96.char = p97;
        u96.trackedLimbs = {};
        u96.childAddedConn = p97.ChildAdded:Connect(function(p99) --[[ Name: childAdded, Line 359 ]]
            -- upvalues: u2 (ref), u96 (copy)
            if p99:IsA("BasePart") then
                if u2[p99.Name] then
                    u96.trackedLimbs[p99] = true;
                end;
                if p99.Name == "Torso" or p99.Name == "UpperTorso" then
                    u96.torsoPart = p99;
                end;
                if p99.Name == "Head" then
                    u96.headPart = p99;
                end;
            end;
        end);
        u96.childRemovedConn = p97.ChildRemoved:Connect(function(p100) --[[ Name: childRemoved, Line 375 ]]
            -- upvalues: u96 (copy)
            u96.trackedLimbs[p100] = nil;
            u96:CheckTorsoReference();
        end);
        for _, v101 in pairs(u96.char:GetChildren()) do
            if v101:IsA("BasePart") then
                if u2[v101.Name] then
                    u96.trackedLimbs[v101] = true;
                end;
                if v101.Name == "Torso" or v101.Name == "UpperTorso" then
                    u96.torsoPart = v101;
                end;
                if v101.Name == "Head" then
                    u96.headPart = v101;
                end;
            end;
        end;
    end;
end;
function u30.SetMode(p102, p103) --[[ Line: 389 ]]
    -- upvalues: u9 (copy), u1 (copy)
    u9(p103, "number");
    for _, v104 in pairs(u1) do
        if v104 == p103 then
            p102.mode = p103;
            p102.behaviorFunction = p102.behaviors[p102.mode];
            return;
        end;
    end;
    error("Invalid mode number");
end;
function u30.GetObscuredParts(p105) --[[ Line: 401 ]]
    return p105.savedHits;
end;
function u30.Cleanup(p106) --[[ Line: 406 ]]
    for v107, v108 in pairs(p106.savedHits) do
        v107.LocalTransparencyModifier = v108;
    end;
end;
function u30.Update(u109, _, p110, p111) --[[ Line: 412 ]]
    if not (u109.enabled and u109.char) then
        return p110, p111;
    end;
    u109.camera = game.Workspace.CurrentCamera;
    if not u109.humanoidRootPart then
        local v112 = u109.char:FindFirstChildOfClass("Humanoid");
        if v112 and v112.RootPart then
            u109.humanoidRootPart = v112.RootPart;
        else
            u109.humanoidRootPart = u109.char:FindFirstChild("HumanoidRootPart");
            if not u109.humanoidRootPart then
                return p110, p111;
            end;
        end;
        local u113 = nil;
        u113 = u109.humanoidRootPart.AncestryChanged:Connect(function(p114, p115) --[[ Line: 437 ]]
            -- upvalues: u109 (copy), u113 (ref)
            if p114 == u109.humanoidRootPart and not p115 then
                u109.humanoidRootPart = nil;
                if u113 and u113.Connected then
                    u113:Disconnect();
                    u113 = nil;
                end;
            end;
        end);
    end;
    if not u109.torsoPart then
        u109:CheckTorsoReference();
        if not u109.torsoPart then
            return p110, p111;
        end;
    end;
    local v116 = {};
    u109.behaviorFunction(u109, v116);
    local v117 = { u109.char };
    local v118 = u109.camera:GetPartsObscuringTarget({ u109.headPart and u109.headPart.CFrame.p or v116[1], u109.torsoPart and u109.torsoPart.CFrame.p or v116[2] }, v117);
    local v119 = 0;
    local v120 = {};
    local v121 = 0.75;
    local v122 = {};
    local v123 = 0.75;
    for v124 = 1, #v118 do
        local v125 = v118[v124];
        v119 = v119 + 1;
        v120[v125] = true;
        for _, v126 in pairs(v125:GetChildren()) do
            if v126:IsA("Decal") or v126:IsA("Texture") then
                v119 = v119 + 1;
                break;
            end;
        end;
    end;
    if v119 > 0 then
        v121 = math.pow(0.375 / v119 + 0.375, 1 / v119);
        v123 = math.pow(0.25 / v119 + 0.25, 1 / v119);
    end;
    local v127 = u109.camera:GetPartsObscuringTarget(v116, v117);
    local v128 = {};
    for v129 = 1, #v127 do
        local v130 = v127[v129];
        v128[v130] = v120[v130] and v121 and v121 or v123;
        if v130.Transparency < v128[v130] then
            v122[v130] = true;
            if not u109.savedHits[v130] then
                u109.savedHits[v130] = v130.LocalTransparencyModifier;
            end;
        end;
        for _, v131 in pairs(v130:GetChildren()) do
            if (v131:IsA("Decal") or v131:IsA("Texture")) and v131.Transparency < v128[v130] then
                v128[v131] = v128[v130];
                v122[v131] = true;
                if not u109.savedHits[v131] then
                    u109.savedHits[v131] = v131.LocalTransparencyModifier;
                end;
            end;
        end;
    end;
    for v132, v133 in pairs(u109.savedHits) do
        if v122[v132] then
            v132.LocalTransparencyModifier = v132.Transparency < 1 and ((v128[v132] - v132.Transparency) / (1 - v132.Transparency) or 0) or 0;
        else
            v132.LocalTransparencyModifier = v133;
            u109.savedHits[v132] = nil;
        end;
    end;
    return p110, p111;
end;
return u30;