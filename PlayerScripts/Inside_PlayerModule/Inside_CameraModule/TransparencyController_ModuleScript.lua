-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.CameraModule.TransparencyController
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__CameraUtils__1 = require(script.Parent:WaitForChild("CameraUtils"));
local u1 = {};
u1.__index = u1;
function u1.new() --[[ Line: 14 ]]
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.transparencyDirty = false;
    v2.enabled = false;
    v2.lastTransparency = nil;
    v2.descendantAddedConn = nil;
    v2.descendantRemovingConn = nil;
    v2.toolDescendantAddedConns = {};
    v2.toolDescendantRemovingConns = {};
    v2.cachedParts = {};
    return v2;
end;
function u1.HasToolAncestor(p3, p4) --[[ Line: 30 ]]
    if p4.Parent == nil then
        return false;
    end;
    assert(p4.Parent, "");
    return p4.Parent:IsA("Tool") or p3:HasToolAncestor(p4.Parent);
end;
function u1.IsValidPartToModify(p5, p6) --[[ Line: 36 ]]
    if p6:IsA("BasePart") or p6:IsA("Decal") then
        return not p5:HasToolAncestor(p6);
    else
        return false;
    end;
end;
function u1.CachePartsRecursive(p7, p8) --[[ Line: 43 ]]
    if p8 then
        if p7:IsValidPartToModify(p8) then
            p7.cachedParts[p8] = true;
            p7.transparencyDirty = true;
        end;
        for _, v9 in pairs(p8:GetChildren()) do
            p7:CachePartsRecursive(v9);
        end;
    end;
end;
function u1.TeardownTransparency(p10) --[[ Line: 55 ]]
    for v11, _ in pairs(p10.cachedParts) do
        v11.LocalTransparencyModifier = 0;
    end;
    p10.cachedParts = {};
    p10.transparencyDirty = true;
    p10.lastTransparency = nil;
    if p10.descendantAddedConn then
        p10.descendantAddedConn:disconnect();
        p10.descendantAddedConn = nil;
    end;
    if p10.descendantRemovingConn then
        p10.descendantRemovingConn:disconnect();
        p10.descendantRemovingConn = nil;
    end;
    for v12, v13 in pairs(p10.toolDescendantAddedConns) do
        v13:Disconnect();
        p10.toolDescendantAddedConns[v12] = nil;
    end;
    for v14, v15 in pairs(p10.toolDescendantRemovingConns) do
        v15:Disconnect();
        p10.toolDescendantRemovingConns[v14] = nil;
    end;
end;
function u1.SetupTransparency(u16, u17) --[[ Line: 81 ]]
    u16:TeardownTransparency();
    if u16.descendantAddedConn then
        u16.descendantAddedConn:disconnect();
    end;
    u16.descendantAddedConn = u17.DescendantAdded:Connect(function(p18) --[[ Line: 85 ]]
        -- upvalues: u16 (copy), u17 (copy)
        if u16:IsValidPartToModify(p18) then
            u16.cachedParts[p18] = true;
            u16.transparencyDirty = true;
        else
            if p18:IsA("Tool") then
                if u16.toolDescendantAddedConns[p18] then
                    u16.toolDescendantAddedConns[p18]:Disconnect();
                end;
                u16.toolDescendantAddedConns[p18] = p18.DescendantAdded:Connect(function(p19) --[[ Line: 93 ]]
                    -- upvalues: u16 (ref)
                    u16.cachedParts[p19] = nil;
                    if p19:IsA("BasePart") or p19:IsA("Decal") then
                        p19.LocalTransparencyModifier = 0;
                    end;
                end);
                if u16.toolDescendantRemovingConns[p18] then
                    u16.toolDescendantRemovingConns[p18]:disconnect();
                end;
                u16.toolDescendantRemovingConns[p18] = p18.DescendantRemoving:Connect(function(p20) --[[ Line: 101 ]]
                    -- upvalues: u17 (ref), u16 (ref)
                    wait();
                    if u17 and (p20 and (p20:IsDescendantOf(u17) and u16:IsValidPartToModify(p20))) then
                        u16.cachedParts[p20] = true;
                        u16.transparencyDirty = true;
                    end;
                end);
            end;
        end;
    end);
    if u16.descendantRemovingConn then
        u16.descendantRemovingConn:disconnect();
    end;
    u16.descendantRemovingConn = u17.DescendantRemoving:connect(function(p21) --[[ Line: 113 ]]
        -- upvalues: u16 (copy)
        if u16.cachedParts[p21] then
            u16.cachedParts[p21] = nil;
            p21.LocalTransparencyModifier = 0;
        end;
    end);
    u16:CachePartsRecursive(u17);
end;
function u1.Enable(p22, p23) --[[ Line: 124 ]]
    if p22.enabled ~= p23 then
        p22.enabled = p23;
    end;
end;
function u1.SetSubject(p24, p25) --[[ Line: 130 ]]
    local v26;
    if p25 and p25:IsA("Humanoid") then
        v26 = p25.Parent;
    else
        v26 = nil;
    end;
    if p25 and (p25:IsA("VehicleSeat") and p25.Occupant) then
        v26 = p25.Occupant.Parent;
    end;
    if v26 then
        p24:SetupTransparency(v26);
    else
        p24:TeardownTransparency();
    end;
end;
function u1.Update(p27, p28) --[[ Line: 145 ]]
    -- upvalues: l__CameraUtils__1 (copy)
    local l__CurrentCamera__2 = workspace.CurrentCamera;
    if l__CurrentCamera__2 and p27.enabled then
        local l__magnitude__3 = (l__CurrentCamera__2.Focus.p - l__CurrentCamera__2.CoordinateFrame.p).magnitude;
        local v29 = l__magnitude__3 < 2 and 1 - (l__magnitude__3 - 0.5) / 1.5 or 0;
        local v30 = v29 < 0.5 and 0 or v29;
        if p27.lastTransparency and (v30 < 1 and p27.lastTransparency < 0.95) then
            local v31 = v30 - p27.lastTransparency;
            local v32 = 2.8 * p28;
            local v33 = math.clamp(v31, -v32, v32);
            v30 = p27.lastTransparency + v33;
        else
            p27.transparencyDirty = true;
        end;
        local v34 = l__CameraUtils__1.Round(v30, 2);
        local v35 = math.clamp(v34, 0, 1);
        if p27.transparencyDirty or p27.lastTransparency ~= v35 then
            for v36, _ in pairs(p27.cachedParts) do
                v36.LocalTransparencyModifier = v35;
            end;
            p27.transparencyDirty = false;
            p27.lastTransparency = v35;
        end;
    end;
end;
return u1;