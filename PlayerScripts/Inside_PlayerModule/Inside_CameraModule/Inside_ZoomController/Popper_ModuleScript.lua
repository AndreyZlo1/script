-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__CurrentCamera__2 = game.Workspace.CurrentCamera;
local l__min__3 = math.min;
local l__tan__4 = math.tan;
local l__rad__5 = math.rad;
local l__new__6 = Ray.new;
local u1 = nil;
local u2 = nil;
local function v5() --[[ Line: 28 ]]
    -- upvalues: l__CurrentCamera__2 (copy), l__rad__5 (copy), u2 (ref), l__tan__4 (copy), u1 (ref)
    local v3 = l__rad__5(l__CurrentCamera__2.FieldOfView);
    local l__ViewportSize__7 = l__CurrentCamera__2.ViewportSize;
    local v4 = l__ViewportSize__7.X / l__ViewportSize__7.Y;
    u2 = l__tan__4(v3 / 2) * 2;
    u1 = v4 * u2;
end;
l__CurrentCamera__2:GetPropertyChangedSignal("FieldOfView"):Connect(v5);
l__CurrentCamera__2:GetPropertyChangedSignal("ViewportSize"):Connect(v5);
local v6 = l__rad__5(l__CurrentCamera__2.FieldOfView);
local l__ViewportSize__8 = l__CurrentCamera__2.ViewportSize;
local v7 = l__ViewportSize__8.X / l__ViewportSize__8.Y;
u2 = l__tan__4(v6 / 2) * 2;
u1 = v7 * u2;
local l__NearPlaneZ__9 = l__CurrentCamera__2.NearPlaneZ;
l__CurrentCamera__2:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() --[[ Line: 43 ]]
    -- upvalues: l__NearPlaneZ__9 (ref), l__CurrentCamera__2 (copy)
    l__NearPlaneZ__9 = l__CurrentCamera__2.NearPlaneZ;
end);
local u8 = {};
local u9 = {};
local function v19(u10) --[[ Line: 60 ]]
    -- upvalues: u9 (copy), u8 (ref)
    local function v13() --[[ Line: 65 ]]
        -- upvalues: u9 (ref), u10 (copy), u8 (ref)
        u9[u10] = nil;
        local v11 = 1;
        u8 = {};
        for _, v12 in pairs(u9) do
            u8[v11] = v12;
            v11 = v11 + 1;
        end;
    end;
    u10.CharacterAdded:Connect(function(p14) --[[ Name: characterAdded, Line 61 ]]
        -- upvalues: u9 (ref), u10 (copy), u8 (ref)
        u9[u10] = p14;
        local v15 = 1;
        u8 = {};
        for _, v16 in pairs(u9) do
            u8[v15] = v16;
            v15 = v15 + 1;
        end;
    end);
    u10.CharacterRemoving:Connect(v13);
    if u10.Character then
        u9[u10] = u10.Character;
        local v17 = 1;
        u8 = {};
        for _, v18 in pairs(u9) do
            u8[v17] = v18;
            v17 = v17 + 1;
        end;
    end;
end;
local function v23(p20) --[[ Line: 77 ]]
    -- upvalues: u9 (copy), u8 (ref)
    u9[p20] = nil;
    local v21 = 1;
    u8 = {};
    for _, v22 in pairs(u9) do
        u8[v21] = v22;
        v21 = v21 + 1;
    end;
end;
l__Players__1.PlayerAdded:Connect(v19);
l__Players__1.PlayerRemoving:Connect(v23);
local u24 = u2;
local u25 = u1;
local u26 = l__NearPlaneZ__9;
for _, v27 in ipairs(l__Players__1:GetPlayers()) do
    v19(v27);
end;
local v28 = 1;
u8 = {};
local u29 = u8;
for _, v30 in pairs(u9) do
    u29[v28] = v30;
    v28 = v28 + 1;
end;
local u31 = nil;
local u32 = nil;
l__CurrentCamera__2:GetPropertyChangedSignal("CameraSubject"):Connect(function() --[[ Line: 111 ]]
    -- upvalues: l__CurrentCamera__2 (copy), u32 (ref)
    local l__CameraSubject__10 = l__CurrentCamera__2.CameraSubject;
    if l__CameraSubject__10:IsA("Humanoid") then
        u32 = l__CameraSubject__10.RootPart;
    elseif l__CameraSubject__10:IsA("BasePart") then
        u32 = l__CameraSubject__10;
    else
        u32 = nil;
    end;
end);
local u33 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
};
local function u43(p34, p35) --[[ Line: 150 ]]
    -- upvalues: u29 (ref), l__new__6 (copy)
    local v36 = #u29;
    while true do
        local v37, v38 = workspace:FindPartOnRayWithIgnoreList(l__new__6(p34, p35), u29, false, true);
        if v37 then
            if v37.CanCollide then
                local v39 = u29;
                for v40 = #v39, v36 + 1, -1 do
                    v39[v40] = nil;
                end;
                return v38, true;
            end;
            u29[#u29 + 1] = v37;
        end;
        if not v37 then
            local v41 = u29;
            for v42 = #v41, v36 + 1, -1 do
                v41[v42] = nil;
            end;
            return p34 + p35, false;
        end;
    end;
end;
local function u65(p44, p45, p46, p47) --[[ Line: 172 ]]
    -- upvalues: u29 (ref), u26 (ref), l__new__6 (copy), u31 (ref)
    debug.profilebegin("queryPoint");
    local v48 = #u29;
    local v49 = p46 + u26;
    local v50 = p44 + p45 * v49;
    local v51 = p44;
    local v52 = 0;
    local v53 = (1 / 0);
    local v54 = (1 / 0);
    while true do
        local v55, v56 = workspace:FindPartOnRayWithIgnoreList(l__new__6(p44, v50 - p44), u29, false, true);
        v52 = v52 + 1;
        local v57;
        if v55 then
            local v58 = v52 >= 64;
            local v59;
            if 1 - (1 - v55.Transparency) * (1 - v55.LocalTransparencyModifier) < 0.25 then
                v59 = v55.CanCollide;
                if v59 then
                    if u31 == (v55:GetRootPart() or v55) then
                        v59 = false;
                    else
                        v59 = not v55:IsA("TrussPart");
                    end;
                end;
            else
                v59 = false;
            end;
            if v59 or v58 then
                local v60 = { v55 };
                local v61 = workspace:FindPartOnRayWithWhitelist(l__new__6(v50, v56 - v50), v60, true);
                v57 = (v56 - v51).Magnitude;
                if v61 and not v58 then
                    local v62;
                    if p47 then
                        v62 = workspace:FindPartOnRayWithWhitelist(l__new__6(p47, v50 - p47), v60, true) or workspace:FindPartOnRayWithWhitelist(l__new__6(v50, p47 - v50), v60, true);
                    else
                        v62 = false;
                    end;
                    if v62 then
                        v53 = v57;
                        v57 = v54;
                    elseif v49 >= v54 then
                        v57 = v54;
                    end;
                else
                    v53 = v57;
                    v57 = v54;
                end;
            else
                v57 = v54;
            end;
            u29[#u29 + 1] = v55;
            p44 = v56 - p45 * 0.001;
        else
            v57 = v54;
        end;
        if v53 < (1 / 0) or not v55 then
            local v63 = u29;
            for v64 = #v63, v48 + 1, -1 do
                v63[v64] = nil;
            end;
            debug.profileend();
            return v57 - u26, v53 - u26;
        end;
        v54 = v57;
    end;
end;
local function u76(p66, p67) --[[ Line: 232 ]]
    -- upvalues: l__CurrentCamera__2 (copy), u25 (ref), u24 (ref), u26 (ref), u65 (copy)
    debug.profilebegin("queryViewport");
    local l__p__11 = p66.p;
    local l__rightVector__12 = p66.rightVector;
    local l__upVector__13 = p66.upVector;
    local v68 = -p66.lookVector;
    local l__ViewportSize__14 = l__CurrentCamera__2.ViewportSize;
    local v69 = (1 / 0);
    local v70 = (1 / 0);
    for v71 = 0, 1 do
        local v72 = l__rightVector__12 * ((v71 - 0.5) * u25);
        for v73 = 0, 1 do
            local v74, v75 = u65(l__p__11 + u26 * (v72 + l__upVector__13 * ((v73 - 0.5) * u24)), v68, p67, l__CurrentCamera__2:ViewportPointToRay(l__ViewportSize__14.x * v71, l__ViewportSize__14.y * v73).Origin);
            if v75 >= v70 then
                v75 = v70;
            end;
            if v74 < v69 then
                v70 = v75;
                v69 = v74;
            else
                v70 = v75;
            end;
        end;
    end;
    debug.profileend();
    return v69, v70;
end;
local function u85(p77, p78, p79) --[[ Line: 273 ]]
    -- upvalues: u43 (copy), l__min__3 (copy), u65 (copy), u33 (copy)
    debug.profilebegin("testPromotion");
    local l__p__15 = p77.p;
    local l__rightVector__16 = p77.rightVector;
    local l__upVector__17 = p77.upVector;
    local v80 = -p77.lookVector;
    debug.profilebegin("extrapolate");
    local l__Magnitude__18 = (u43(l__p__15, p79.posVelocity * 1.25) - l__p__15).Magnitude;
    for v81 = 0, l__min__3(1.25, p79.rotVelocity.magnitude + l__Magnitude__18 / p79.posVelocity.magnitude), 0.0625 do
        local v82 = p79.extrapolate(v81);
        if p78 <= u65(v82.p, -v82.lookVector, p78) then
            return false;
        end;
    end;
    debug.profileend();
    debug.profilebegin("testOffsets");
    for _, v83 in ipairs(u33) do
        local v84 = u43(l__p__15, l__rightVector__16 * v83.x + l__upVector__17 * v83.y);
        if u65(v84, (l__p__15 + v80 * p78 - v84).Unit, p78) == (1 / 0) then
            return false;
        end;
    end;
    debug.profileend();
    debug.profileend();
    return true;
end;
return function(p86, p87, p88) --[[ Name: Popper, Line 322 ]]
    -- upvalues: u31 (ref), u32 (ref), u76 (copy), u85 (copy)
    debug.profilebegin("popper");
    u31 = u32 and u32:GetRootPart() or u32;
    local v89, v90 = u76(p86, p87);
    if v90 >= p87 then
        v90 = p87;
    end;
    if v89 < v90 then
        if not u85(p86, p87, p88) then
            v89 = v90;
        end;
    else
        v89 = v90;
    end;
    u31 = nil;
    debug.profileend();
    return v89;
end;