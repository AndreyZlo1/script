-- Roblox: ReplicatedStorage.TPLibraries.Icon.Features.Themes
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__Utility__1 = require(script.Parent.Parent.Utility);
local l__Default__2 = require(script.Default);
function u1.getThemeValue(p2, p3, p4, _) --[[ Line: 16 ]]
    if p2 then
        for _, v5 in pairs(p2) do
            local v6, v7, v8 = unpack(v5);
            if p3 == v6 and p4 == v7 then
                return v8;
            end;
        end;
    end;
    return nil;
end;
function u1.getInstanceValue(u9, u10) --[[ Line: 28 ]]
    local v11, v12 = pcall(function() --[[ Line: 29 ]]
        -- upvalues: u9 (copy), u10 (copy)
        return u9[u10];
    end);
    if not v11 then
        v12 = u9:GetAttribute(u10);
    end;
    return v12;
end;
function u1.getRealInstance(p13) --[[ Line: 38 ]]
    if p13:GetAttribute("IsAClippedClone") then
        local v14 = p13:FindFirstChild("OriginalInstance");
        if v14 then
            return v14.Value;
        end;
    end;
end;
function u1.getClippedClone(p15) --[[ Line: 49 ]]
    if p15:GetAttribute("HasAClippedClone") then
        local v16 = p15:FindFirstChild("ClippedClone");
        if v16 then
            return v16.Value;
        end;
    end;
end;
function u1.refresh(p17, p18, p19) --[[ Line: 60 ]]
    -- upvalues: u1 (copy)
    if p19 then
        local v20 = p17:getStateGroup();
        local v21 = u1.getThemeValue(v20, p18.Name, p19) or u1.getInstanceValue(p18, p19);
        u1.apply(p17, p18, p19, v21, true);
    else
        local v22 = p17:getStateGroup();
        if v22 then
            local v23 = {
                [p18.Name] = p18
            };
            for _, v24 in pairs(p18:GetDescendants()) do
                local v25 = v24:GetAttribute("Collective");
                if v25 then
                    v23[v25] = v24;
                end;
                v23[v24.Name] = v24;
            end;
            for _, v26 in pairs(v22) do
                local v27, v28, v29 = unpack(v26);
                local v30 = v23[v27];
                if v30 then
                    u1.apply(p17, v30.Name, v28, v29, true);
                end;
            end;
        end;
    end;
end;
function u1.apply(p31, p32, u33, p34, p35) --[[ Line: 93 ]]
    -- upvalues: u1 (copy)
    if p31.isDestroyed then
    else
        local v36;
        if typeof(p32) == "Instance" then
            local l__Name__3 = p32.Name;
            p32 = l__Name__3;
            v36 = { p32 };
        else
            v36 = p31:getInstanceOrCollective(p32);
        end;
        local v37 = p31.customBehaviours[p32 .. "-" .. u33];
        for _, v38 in pairs(v36) do
            local v39 = u1.getClippedClone(v38);
            if v39 then
                table.insert(v36, v39);
            end;
        end;
        for _, u40 in pairs(v36) do
            if u33 ~= "Position" or not u1.getClippedClone(u40) then
                if (u33 ~= "Size" or not u1.getRealInstance(u40)) and (p35 or p34 ~= u1.getInstanceValue(u40, u33)) then
                    local u41;
                    if v37 then
                        u41 = v37(p34, u40, u33);
                        if u41 == nil then
                            u41 = p34;
                        end;
                    else
                        u41 = p34;
                    end;
                    if not pcall(function() --[[ Line: 139 ]]
                        -- upvalues: u40 (copy), u33 (copy), u41 (ref)
                        u40[u33] = u41;
                    end) then
                        u40:SetAttribute(u33, u41);
                    end;
                end;
            end;
        end;
    end;
end;
function u1.getModifications(p42) --[[ Line: 153 ]]
    return typeof(p42[1]) ~= "table" and { p42 } or p42;
end;
function u1.merge(p43, p44, p45) --[[ Line: 162 ]]
    -- upvalues: u1 (copy)
    local v46, v47, v48, v49 = table.unpack(p44);
    local v50, v51, _, v52 = table.unpack(p43);
    if v46 ~= v50 or (v47 ~= v51 or not u1.statesMatch(v49, v52)) then
        return false;
    end;
    p43[3] = v48;
    if p45 then
        p45(p43);
    end;
    return true;
end;
function u1.modify(u53, u54, u55) --[[ Line: 175 ]]
    -- upvalues: l__Utility__1 (copy), u1 (copy)
    task.spawn(function() --[[ Line: 183 ]]
        -- upvalues: u55 (ref), l__Utility__1 (ref), u54 (ref), u1 (ref), u53 (copy)
        u55 = u55 or l__Utility__1.generateUID();
        u54 = u1.getModifications(u54);
        for _, u56 in pairs(u54) do
            local u57, u58, u59, v60 = table.unpack(u56);
            if v60 == nil then
                u1.modify(u53, {
                    u57,
                    u58,
                    u59,
                    "Selected"
                }, u55);
                u1.modify(u53, {
                    u57,
                    u58,
                    u59,
                    "Viewing"
                }, u55);
            end;
            local u61 = l__Utility__1.formatStateName(v60 or "Deselected");
            local u62 = u53:getStateGroup(u61);
            (function() --[[ Name: updateRecord, Line 200 ]]
                -- upvalues: u62 (copy), u1 (ref), u56 (copy), u55 (ref), u61 (copy), u53 (ref), u57 (copy), u58 (copy), u59 (copy)
                for _, v63 in pairs(u62) do
                    if u1.merge(v63, u56, function(p64) --[[ Line: 202 ]]
                        -- upvalues: u55 (ref), u61 (ref), u53 (ref), u1 (ref), u57 (ref), u58 (ref), u59 (ref)
                        p64[5] = u55;
                        if u61 == u53.activeState then
                            u1.apply(u53, u57, u58, u59);
                        end;
                    end) then
                        return;
                    end;
                end;
                table.insert(u62, {
                    u57,
                    u58,
                    u59,
                    u61,
                    u55
                });
                if u61 == u53.activeState then
                    u1.apply(u53, u57, u58, u59);
                end;
            end)();
        end;
    end);
    return u55;
end;
function u1.remove(p65, p66) --[[ Line: 220 ]]
    -- upvalues: u1 (copy)
    for _, v67 in pairs(p65.appearance) do
        for v68 = #v67, 1, -1 do
            if v67[v68][5] == p66 then
                table.remove(v67, v68);
            end;
        end;
    end;
    u1.rebuild(p65);
end;
function u1.removeWith(p69, p70, p71, p72) --[[ Line: 233 ]]
    -- upvalues: u1 (copy)
    for v73, v74 in pairs(p69.appearance) do
        if p72 == v73 or not p72 then
            for v75 = #v74, 1, -1 do
                local v76 = v74[v75];
                if v76[1] == p70 and v76[2] == p71 then
                    table.remove(v74, v75);
                end;
            end;
        end;
    end;
    u1.rebuild(p69);
end;
function u1.change(p77) --[[ Line: 249 ]]
    -- upvalues: u1 (copy)
    local v78 = p77:getStateGroup();
    for _, v79 in pairs(v78) do
        local v80, v81, v82 = unpack(v79);
        u1.apply(p77, v80, v81, v82);
    end;
end;
function u1.set(u83, p84) --[[ Line: 259 ]]
    -- upvalues: u1 (copy)
    local l__themesJanitor__4 = u83.themesJanitor;
    l__themesJanitor__4:clean();
    l__themesJanitor__4:add(u83.stateChanged:Connect(function() --[[ Line: 265 ]]
        -- upvalues: u1 (ref), u83 (copy)
        u1.change(u83);
    end));
    if typeof(p84) == "Instance" and p84:IsA("ModuleScript") then
        p84 = require(p84);
    end;
    u83.appliedTheme = p84;
    u1.rebuild(u83);
end;
function u1.statesMatch(p85, p86) --[[ Line: 275 ]]
    local v87;
    if p85 then
        v87 = string.lower(p85);
    else
        v87 = p85;
    end;
    local v88;
    if p86 then
        v88 = string.lower(p86);
    else
        v88 = p86;
    end;
    return v87 == v88 and true or not (p85 and p86);
end;
function u1.rebuild(u89) --[[ Line: 282 ]]
    -- upvalues: u1 (copy), l__Utility__1 (copy), l__Default__2 (copy)
    local l__appliedTheme__5 = u89.appliedTheme;
    local u90 = { "Deselected", "Selected", "Viewing" };
    (function() --[[ Name: generateTheme, Line 289 ]]
        -- upvalues: u90 (copy), u1 (ref), l__Utility__1 (ref), l__Default__2 (ref), l__appliedTheme__5 (copy), u89 (copy)
        for _, v91 in pairs(u90) do
            local u92 = {};
            local function v99(p93, p94) --[[ Line: 295 ]]
                -- upvalues: u1 (ref), l__Utility__1 (ref), u92 (copy)
                if p93 then
                    for _, v95 in pairs(p93) do
                        local v96 = v95[5];
                        if u1.statesMatch(p94, v95[4]) then
                            local v97 = v95[1] .. "-" .. v95[2];
                            local v98 = l__Utility__1.copyTable(v95);
                            v98[5] = v96;
                            u92[v97] = v98;
                        end;
                    end;
                end;
            end;
            if v91 == "Selected" then
                v99(l__Default__2, "Deselected");
            end;
            v99(l__Default__2, "Empty");
            v99(l__Default__2, v91);
            if l__appliedTheme__5 ~= l__Default__2 then
                if v91 == "Selected" then
                    v99(l__appliedTheme__5, "Deselected");
                end;
                v99(l__Default__2, "Empty");
                v99(l__appliedTheme__5, v91);
            end;
            local v100 = {};
            local v101 = u89.appearance[v91];
            if v101 then
                for _, v102 in pairs(v101) do
                    local v103 = v102[5];
                    if v103 ~= nil then
                        table.insert(v100, {
                            v102[1],
                            v102[2],
                            v102[3],
                            v91,
                            v103
                        });
                    end;
                end;
            end;
            v99(v100, v91);
            local v104 = {};
            for _, v105 in pairs(u92) do
                table.insert(v104, v105);
            end;
            u89.appearance[v91] = v104;
        end;
        u1.change(u89);
    end)();
end;
return u1;