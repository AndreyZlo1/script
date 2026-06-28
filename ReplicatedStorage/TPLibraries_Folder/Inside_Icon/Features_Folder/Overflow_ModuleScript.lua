-- Roblox: ReplicatedStorage.TPLibraries.Icon.Features.Overflow
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
local u3 = {};
local u4 = nil;
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u5 = {};
local u6 = {};
local l__Utility__2 = require(script.Parent.Parent.Utility);
local u7 = false;
local u8 = false;
local u9 = nil;
function u1.start(p10) --[[ Line: 25 ]]
    -- upvalues: u9 (ref), u4 (ref), u2 (copy), l__Utility__2 (copy), u1 (copy), u7 (ref), l__CurrentCamera__1 (copy)
    u9 = p10;
    u4 = u9.iconsDictionary;
    local v11 = nil;
    for _, v12 in pairs(u9.container) do
        if v11 == nil then
            if v12.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
                v11 = v12;
            end;
        end;
        for _, v13 in pairs(v12.Holders:GetChildren()) do
            if v13:GetAttribute("IsAHolder") then
                u2[v13.Name] = v13;
            end;
        end;
    end;
    local u14 = false;
    local u16 = l__Utility__2.createStagger(0.1, function(p15) --[[ Line: 43 ]]
        -- upvalues: u14 (ref), u1 (ref)
        if u14 then
            if not p15 then
                u1.updateAvailableIcons("Center");
            end;
            u1.updateBoundary("Left");
            u1.updateBoundary("Right");
        end;
    end);
    task.delay(0.5, function() --[[ Line: 53 ]]
        -- upvalues: u14 (ref), u16 (copy)
        u14 = true;
        u16();
    end);
    task.delay(2, function() --[[ Line: 57 ]]
        -- upvalues: u7 (ref), u16 (copy)
        u7 = true;
        u16();
    end);
    u9.iconAdded:Connect(u16);
    u9.iconRemoved:Connect(u16);
    u9.iconChanged:Connect(u16);
    l__CurrentCamera__1:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 67 ]]
        -- upvalues: u16 (copy)
        u16(true);
    end);
    v11:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 70 ]]
        -- upvalues: u16 (copy)
        u16(true);
    end);
end;
function u1.getWidth(p17, _) --[[ Line: 75 ]]
    local l__widget__3 = p17.widget;
    return l__widget__3:GetAttribute("TargetWidth") or l__widget__3.AbsoluteSize.X;
end;
function u1.getAvailableIcons(p18) --[[ Line: 80 ]]
    -- upvalues: u3 (copy), u1 (copy)
    return u3[p18] or u1.updateAvailableIcons(p18);
end;
function u1.updateAvailableIcons(p19) --[[ Line: 88 ]]
    -- upvalues: u4 (ref), u6 (copy), u3 (copy)
    local v20 = 0;
    local v21 = {};
    for _, v22 in pairs(u4) do
        local l__parentIconUID__4 = v22.parentIconUID;
        if (not l__parentIconUID__4 or u6[l__parentIconUID__4]) and (v22.alignment == p19 and (not u6[v22.UID] and v22.isEnabled)) then
            table.insert(v21, v22);
            v20 = v20 + 1;
        end;
    end;
    if v20 <= 0 then
        return {};
    end;
    table.sort(v21, function(p23, p24) --[[ Line: 110 ]]
        local l__LayoutOrder__5 = p23.widget.LayoutOrder;
        local l__LayoutOrder__6 = p24.widget.LayoutOrder;
        local l__parentIconUID__7 = p23.parentIconUID;
        local l__parentIconUID__8 = p24.parentIconUID;
        if l__parentIconUID__7 == l__parentIconUID__8 then
            if l__LayoutOrder__5 < l__LayoutOrder__6 then
                return true;
            elseif l__LayoutOrder__6 < l__LayoutOrder__5 then
                return false;
            else
                return p23.widget.AbsolutePosition.X < p24.widget.AbsolutePosition.X;
            end;
        elseif l__parentIconUID__8 then
            return false;
        else
            return l__parentIconUID__7 and true or nil;
        end;
    end);
    u3[p19] = v21;
    return v21;
end;
function u1.getRealXPositions(p25, p26) --[[ Line: 137 ]]
    -- upvalues: u2 (copy), l__Utility__2 (copy), u1 (copy)
    local v27 = p25 == "Left";
    local v28 = u2[p25];
    local l__X__9 = v28.AbsolutePosition.X;
    local l__X__10 = v28.AbsoluteSize.X;
    local l__Offset__11 = v28.UIListLayout.Padding.Offset;
    local v29 = v27 and l__X__9 and l__X__9 or l__X__9 + l__X__10;
    local v30 = {};
    if v27 then
        l__Utility__2.reverseTable(p26);
    end;
    for v31 = #p26, 1, -1 do
        local v32 = p26[v31];
        local v33 = u1.getWidth(v32);
        if not v27 then
            v29 = v29 - v33;
        end;
        v30[v32.UID] = v29;
        if v27 then
            v29 = v29 + v33;
        end;
        v29 = v29 + (v27 and l__Offset__11 and l__Offset__11 or -l__Offset__11);
    end;
    return v30;
end;
function u1.updateBoundary(u34) --[[ Line: 166 ]]
    -- upvalues: u2 (copy), u1 (copy), u5 (copy), u9 (ref), u6 (copy), u8 (ref), u7 (ref), l__Utility__2 (copy)
    local v35 = u2[u34];
    local l__UIListLayout__12 = v35.UIListLayout;
    local l__X__13 = v35.AbsolutePosition.X;
    local l__X__14 = v35.AbsoluteSize.X;
    local l__Offset__15 = l__UIListLayout__12.Padding.Offset;
    local l__Offset__16 = l__UIListLayout__12.Padding.Offset;
    local u36 = u1.updateAvailableIcons(u34);
    local v37 = 0;
    local v38 = 0;
    for _, v39 in pairs(u36) do
        v37 = v37 + (u1.getWidth(v39) + l__Offset__16);
        v38 = v38 + 1;
    end;
    if v38 <= 0 then
    else
        local v40 = u34 == "Center";
        local u41 = u34 == "Left";
        local u42 = not u41;
        local v43 = u5[u34];
        if not v43 and (not v40 and #u36 > 0) then
            v43 = u9.new();
            v43:setImage(6069276526, "Deselected");
            v43:setName("Overflow" .. u34);
            v43:setOrder(u41 and -9999999 or 9999999);
            v43:setAlignment(u34);
            v43:autoDeselect(false);
            v43.isAnOverflow = true;
            v43:select("OverflowStart", v43);
            v43:setEnabled(false);
            u5[u34] = v43;
            u6[v43.UID] = true;
            if not u9.closeableOverflowMenus then
                v43:getInstance("IconSpot").Visible = false;
            end;
        end;
        local v44 = u34 == "Left" and "Right" or "Left";
        local v45 = u1.updateAvailableIcons(v44);
        local v46 = u41 and v45[1];
        if not v46 then
            if u42 then
                v46 = v45[#v45];
            else
                v46 = u42;
            end;
        end;
        local v47 = u5[v44];
        local v48;
        if u41 then
            v48 = l__X__13 + l__X__14 or l__X__13;
        else
            v48 = l__X__13;
        end;
        if v46 then
            local v49 = u1.getRealXPositions(v44, v45)[v46.UID];
            local v50 = u1.getWidth(v46);
            v48 = u41 and v49 - l__Offset__15 or v49 + v50 + l__Offset__15;
        end;
        local u51 = 0;
        local function u58() --[[ Line: 233 ]]
            -- upvalues: u1 (ref), u41 (copy), u8 (ref), u34 (copy), u36 (copy), u42 (copy), l__Offset__15 (copy), u7 (ref), u51 (ref), u58 (copy)
            local v52 = u1.getAvailableIcons("Center");
            local v53 = v52[u41 and 1 or #v52];
            if v53 and not v53.hasRelocatedInOverflow then
                local v54 = not (u41 and u36[#u36]) and u42;
                if v54 then
                    v54 = u36[1];
                end;
                local l__X__17 = v53.widget.AbsolutePosition.X;
                local l__X__18 = v54.widget.AbsolutePosition.X;
                local v55 = u1.getWidth(v54);
                local v56 = u41 and l__X__17 - l__Offset__15 or l__X__17 + u1.getWidth(v53) + l__Offset__15;
                if u41 then
                    l__X__18 = l__X__18 + v55 or l__X__18;
                end;
                local v57 = false;
                if u41 then
                    if v56 < l__X__18 then
                        if not u7 then
                            if not u8 then
                                u8 = true;
                                task.delay(3, u1.updateBoundary, u34);
                            end;
                            return;
                        end;
                        v53:align("Left");
                        v53.hasRelocatedInOverflow = true;
                        v57 = true;
                    end;
                elseif u42 and l__X__18 < v56 then
                    if not u7 or l__X__18 < 0 then
                        if not u8 then
                            u8 = true;
                            task.delay(3, u1.updateBoundary, u34);
                        end;
                        return;
                    end;
                    v53:align("Right");
                    v53.hasRelocatedInOverflow = true;
                    v57 = true;
                end;
                if v57 then
                    u51 = u51 + 1;
                    if u51 <= 4 then
                        u1.updateAvailableIcons("Center");
                        u58();
                    end;
                end;
            end;
        end;
        u58();
        if v43 then
            local v59 = v43:getInstance("Menu");
            local v60 = l__X__13 + l__X__14;
            if v59 and v47 then
                local l__X__19 = v47.widget.AbsolutePosition.X;
                local v61 = u1.getWidth(v47);
                local v62 = u41 and l__X__19 - l__Offset__15 or l__X__19 + v61 + l__Offset__15;
                local v63 = v47:getInstance("Menu");
                local v64 = v59.AbsoluteCanvasSize.X >= v63.AbsoluteCanvasSize.X;
                local v65 = l__X__13 + l__X__14 / 2;
                local v66 = u41 and v65 - l__Offset__15 / 2 or v65 + l__Offset__15 / 2;
                if v64 then
                    v66 = v62;
                end;
                l__X__14 = u41 and v66 - l__X__13 or v60 - v66;
            end;
            local v67;
            if v59 then
                v67 = v59:GetAttribute("MaxWidth");
            else
                v67 = v59;
            end;
            local v68 = l__Utility__2.round(l__X__14);
            if v59 and v67 ~= v68 then
                v59:SetAttribute("MaxWidth", v68);
            end;
        end;
        local v69 = u1.getRealXPositions(u34, u36);
        local v70 = false;
        for v71 = #u36, 1, -1 do
            local v72 = u36[v71];
            local v73 = u1.getWidth(v72);
            local v74 = v69[v72.UID];
            if u41 and v48 <= v74 + v73 or u42 and v74 <= v48 then
                v70 = true;
            end;
        end;
        for v75 = #u36, 1, -1 do
            local v76 = u36[v75];
            if not u6[v76.UID] then
                if v70 and not v76.parentIconUID then
                    v76:joinMenu(v43);
                elseif not v70 and v76.parentIconUID then
                    v76:leave();
                end;
            end;
        end;
        if v43.isEnabled ~= v70 then
            v43:setEnabled(v70);
        end;
        if v43.isEnabled and not v43.overflowAlreadyOpened then
            v43.overflowAlreadyOpened = true;
            v43:select();
        end;
    end;
end;
return u1;