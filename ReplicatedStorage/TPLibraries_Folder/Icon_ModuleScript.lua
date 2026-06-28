-- Roblox: ReplicatedStorage.TPLibraries.Icon
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__UserInputService__1 = game:GetService("UserInputService");
local l__ContentProvider__2 = game:GetService("ContentProvider");
local l__StarterGui__3 = game:GetService("StarterGui");
local l__Players__4 = game:GetService("Players");
require(script.Types);
local u1 = script;
local l__Reference__5 = require(u1.Reference);
local v2 = l__Reference__5.getObject();
local v3;
if v2 then
    v3 = v2.Value;
else
    v3 = v2;
end;
if v3 and v3 ~= u1 then
    return require(v3);
end;
if not v2 then
    l__Reference__5.addToReplicatedStorage();
end;
local l__GoodSignal__6 = require(u1.Packages.GoodSignal);
local l__Janitor__7 = require(u1.Packages.Janitor);
local l__Utility__8 = require(u1.Utility);
local l__Themes__9 = require(u1.Features.Themes);
local l__Gamepad__10 = require(u1.Features.Gamepad);
local l__Overflow__11 = require(u1.Features.Overflow);
local u4 = {};
u4.__index = u4;
local l__LocalPlayer__12 = l__Players__4.LocalPlayer;
local l__Themes__13 = u1.Features.Themes;
local u5 = {};
local u6 = l__GoodSignal__6.new();
local l__Elements__14 = u1.Elements;
local u7 = 0;
local u8 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
};
u4.baseDisplayOrderChanged = l__GoodSignal__6.new();
u4.baseDisplayOrder = 10;
u4.baseTheme = require(l__Themes__13.Default);
u4.isOldTopbar = false;
u4.iconsDictionary = u5;
u4.insetHeightChanged = l__GoodSignal__6.new();
u4.container = require(l__Elements__14.Container)(u4);
u4.topbarEnabled = true;
u4.iconAdded = l__GoodSignal__6.new();
u4.iconRemoved = l__GoodSignal__6.new();
u4.iconChanged = l__GoodSignal__6.new();
function u4.getIcons() --[[ Line: 110 ]]
    -- upvalues: u4 (copy)
    return u4.iconsDictionary;
end;
function u4.getIconByUID(p9) --[[ Line: 114 ]]
    -- upvalues: u4 (copy)
    return u4.iconsDictionary[p9] or nil;
end;
function u4.getIcon(p10) --[[ Line: 122 ]]
    -- upvalues: u4 (copy), u5 (copy)
    local v11 = u4.getIconByUID(p10);
    if v11 then
        return v11;
    end;
    for _, v12 in pairs(u5) do
        if v12.name == p10 then
            return v12;
        end;
    end;
    return nil;
end;
function u4.setTopbarEnabled(p13, p14) --[[ Line: 135 ]]
    -- upvalues: u4 (copy)
    if typeof(p13) ~= "boolean" then
        p13 = u4.topbarEnabled;
    end;
    if not p14 then
        u4.topbarEnabled = p13;
    end;
    for _, v15 in pairs(u4.container) do
        v15.Enabled = p13;
    end;
end;
function u4.modifyBaseTheme(p16) --[[ Line: 147 ]]
    -- upvalues: l__Themes__9 (copy), u4 (copy), u5 (copy)
    local v17 = l__Themes__9.getModifications(p16);
    for _, v18 in pairs(v17) do
        for _, v19 in pairs(u4.baseTheme) do
            l__Themes__9.merge(v19, v18);
        end;
    end;
    for _, v20 in pairs(u5) do
        v20:setTheme(u4.baseTheme);
    end;
end;
function u4.setDisplayOrder(p21) --[[ Line: 159 ]]
    -- upvalues: u4 (copy)
    u4.baseDisplayOrder = p21;
    u4.baseDisplayOrderChanged:Fire(p21);
end;
task.defer(l__Gamepad__10.start, u4);
task.defer(l__Overflow__11.start, u4);
task.defer(function() --[[ Line: 169 ]]
    -- upvalues: l__LocalPlayer__12 (copy), u4 (copy), u1 (copy)
    local l__PlayerGui__15 = l__LocalPlayer__12:WaitForChild("PlayerGui");
    for _, v22 in pairs(u4.container) do
        v22.Parent = l__PlayerGui__15;
    end;
    require(u1.Attribute);
end);
function u4.new() --[[ Line: 180 ]]
    -- upvalues: u4 (copy), l__Janitor__7 (copy), l__Utility__8 (copy), u5 (copy), l__GoodSignal__6 (copy), u1 (copy), l__Elements__14 (copy), u7 (ref), l__UserInputService__1 (copy), u8 (copy), u6 (copy), l__StarterGui__3 (copy)
    local u23 = {};
    setmetatable(u23, u4);
    local v24 = l__Janitor__7.new();
    u23.janitor = v24;
    u23.themesJanitor = v24:add(l__Janitor__7.new());
    u23.singleClickJanitor = v24:add(l__Janitor__7.new());
    u23.captionJanitor = v24:add(l__Janitor__7.new());
    u23.joinJanitor = v24:add(l__Janitor__7.new());
    u23.menuJanitor = v24:add(l__Janitor__7.new());
    u23.dropdownJanitor = v24:add(l__Janitor__7.new());
    local u25 = l__Utility__8.generateUID();
    u5[u25] = u23;
    v24:add(function() --[[ Line: 197 ]]
        -- upvalues: u5 (ref), u25 (copy)
        u5[u25] = nil;
    end);
    u23.selected = v24:add(l__GoodSignal__6.new());
    u23.deselected = v24:add(l__GoodSignal__6.new());
    u23.toggled = v24:add(l__GoodSignal__6.new());
    u23.viewingStarted = v24:add(l__GoodSignal__6.new());
    u23.viewingEnded = v24:add(l__GoodSignal__6.new());
    u23.stateChanged = v24:add(l__GoodSignal__6.new());
    u23.notified = v24:add(l__GoodSignal__6.new());
    u23.noticeStarted = v24:add(l__GoodSignal__6.new());
    u23.noticeChanged = v24:add(l__GoodSignal__6.new());
    u23.endNotices = v24:add(l__GoodSignal__6.new());
    u23.toggleKeyAdded = v24:add(l__GoodSignal__6.new());
    u23.fakeToggleKeyChanged = v24:add(l__GoodSignal__6.new());
    u23.alignmentChanged = v24:add(l__GoodSignal__6.new());
    u23.updateSize = v24:add(l__GoodSignal__6.new());
    u23.resizingComplete = v24:add(l__GoodSignal__6.new());
    u23.joinedParent = v24:add(l__GoodSignal__6.new());
    u23.menuSet = v24:add(l__GoodSignal__6.new());
    u23.dropdownSet = v24:add(l__GoodSignal__6.new());
    u23.updateMenu = v24:add(l__GoodSignal__6.new());
    u23.startMenuUpdate = v24:add(l__GoodSignal__6.new());
    u23.childThemeModified = v24:add(l__GoodSignal__6.new());
    u23.indicatorSet = v24:add(l__GoodSignal__6.new());
    u23.dropdownChildAdded = v24:add(l__GoodSignal__6.new());
    u23.menuChildAdded = v24:add(l__GoodSignal__6.new());
    u23.iconModule = u1;
    u23.UID = u25;
    u23.isEnabled = true;
    u23.enabled = u23.isEnabled;
    u23.isSelected = false;
    u23.isViewing = false;
    u23.joinedFrame = false;
    u23.parentIconUID = false;
    u23.deselectWhenOtherIconSelected = true;
    u23.totalNotices = 0;
    u23.activeState = "Deselected";
    u23.alignment = "";
    u23.originalAlignment = "";
    u23.appliedTheme = {};
    u23.appearance = {};
    u23.cachedInstances = {};
    u23.cachedNamesToInstances = {};
    u23.cachedCollectives = {};
    u23.bindedToggleKeys = {};
    u23.customBehaviours = {};
    u23.toggleItems = {};
    u23.bindedEvents = {};
    u23.notices = {};
    u23.menuIcons = {};
    u23.dropdownIcons = {};
    u23.childIconsDict = {};
    u23.creationTime = os.clock();
    u23.widget = v24:add(require(l__Elements__14.Widget)(u23, u4));
    u23:setAlignment();
    u7 = u7 + 1;
    local v26 = u7 * 0.01 + 1;
    u23:setOrder(v26, "deselected");
    u23:setOrder(v26, "selected");
    u23:setTheme(u4.baseTheme);
    local v27 = u23:getInstance("ClickRegion");
    local u28 = false;
    local u29 = 0;
    v27.MouseButton1Click:Connect(function() --[[ Line: 296 ]]
        -- upvalues: u28 (ref), u23 (copy), u29 (ref)
        u28 = true;
        if u23.locked then
        else
            local v30 = tick();
            if v30 - u29 < 0.1 then
            else
                u29 = v30;
                if u23.isSelected then
                    u23:deselect("User", u23);
                else
                    u23:select("User", u23);
                end;
            end;
        end;
    end);
    v27.TouchTap:Connect(function() --[[ Line: 301 ]]
        -- upvalues: u28 (ref), u23 (copy), u29 (ref)
        if not u28 then
            if u23.locked then
                return;
            end;
            local v31 = tick();
            if v31 - u29 < 0.1 then
                return;
            end;
            u29 = v31;
            if u23.isSelected then
                u23:deselect("User", u23);
                return;
            end;
            u23:select("User", u23);
        end;
    end);
    v24:add(l__UserInputService__1.InputBegan:Connect(function(p32, p33) --[[ Line: 314 ]]
        -- upvalues: u23 (copy), u29 (ref)
        if u23.locked then
        else
            if u23.bindedToggleKeys[p32.KeyCode] and not p33 then
                if u23.locked then
                    return;
                end;
                local v34 = tick();
                if v34 - u29 < 0.1 then
                    return;
                end;
                u29 = v34;
                if u23.isSelected then
                    u23:deselect("User", u23);
                    return;
                end;
                u23:select("User", u23);
            end;
        end;
    end));
    local function v35() --[[ Line: 336 ]]
        -- upvalues: u23 (copy)
        if u23.locked then
        else
            u23.isViewing = false;
            u23.viewingEnded:Fire(true);
            u23:setState(nil, "User", u23);
        end;
    end;
    u23.joinedParent:Connect(function() --[[ Line: 344 ]]
        -- upvalues: u23 (copy)
        if u23.isViewing then
            if u23.locked then
                return;
            end;
            u23.isViewing = false;
            u23.viewingEnded:Fire(true);
            u23:setState(nil, "User", u23);
        end;
    end);
    v27.MouseEnter:Connect(function() --[[ Line: 349 ]]
        -- upvalues: l__UserInputService__1 (ref), u8 (ref), u23 (copy)
        local v36 = l__UserInputService__1.PreferredInput ~= u8.desktop;
        if u23.locked then
        else
            u23.isViewing = true;
            u23.viewingStarted:Fire(true);
            if not v36 then
                u23:setState("Viewing", "User", u23);
            end;
        end;
    end);
    local u37 = 0;
    v24:add(l__UserInputService__1.TouchEnded:Connect(v35));
    v27.MouseLeave:Connect(v35);
    v27.SelectionGained:Connect(function(p38) --[[ Name: viewingStarted, Line 326 ]]
        -- upvalues: u23 (copy)
        if u23.locked then
        else
            u23.isViewing = true;
            u23.viewingStarted:Fire(true);
            if not p38 then
                u23:setState("Viewing", "User", u23);
            end;
        end;
    end);
    v27.SelectionLost:Connect(v35);
    v27.MouseButton1Down:Connect(function() --[[ Line: 358 ]]
        -- upvalues: u23 (copy), l__UserInputService__1 (ref), u8 (ref), u37 (ref)
        if not u23.locked and l__UserInputService__1.PreferredInput == u8.mobile then
            u37 = u37 + 1;
            local u39 = u37;
            task.delay(0.2, function() --[[ Line: 362 ]]
                -- upvalues: u39 (copy), u37 (ref), u23 (ref)
                if u39 == u37 then
                    if u23.locked then
                        return;
                    end;
                    u23.isViewing = true;
                    u23.viewingStarted:Fire(true);
                    u23:setState("Viewing", "User", u23);
                end;
            end);
        end;
    end);
    v27.MouseButton1Up:Connect(function() --[[ Line: 369 ]]
        -- upvalues: u37 (ref)
        u37 = u37 + 1;
    end);
    local u40 = u23:getInstance("IconOverlay");
    u23.viewingStarted:Connect(function() --[[ Line: 375 ]]
        -- upvalues: u40 (copy), u23 (copy)
        u40.Visible = not u23.overlayDisabled;
    end);
    u23.viewingEnded:Connect(function() --[[ Line: 378 ]]
        -- upvalues: u40 (copy)
        u40.Visible = false;
    end);
    v24:add(u6:Connect(function(p41) --[[ Line: 383 ]]
        -- upvalues: u23 (copy)
        if p41 ~= u23 and (u23.deselectWhenOtherIconSelected and p41.deselectWhenOtherIconSelected) then
            u23:deselect("AutoDeselect", p41);
        end;
    end));
    local v42 = debug.info(2, "s");
    local v43 = string.split(v42, ".");
    local v44 = game;
    local v45 = nil;
    for _, v46 in pairs(v43) do
        v44 = v44:FindFirstChild(v46);
        if not v44 then
            break;
        end;
        if v44:IsA("ScreenGui") then
            v45 = v44;
        end;
    end;
    if v44 and (v45 and v45.ResetOnSpawn == true) then
        u23.originsScreenGui = v45;
        l__Utility__8.localPlayerRespawned(function() --[[ Line: 409 ]]
            -- upvalues: u23 (copy)
            u23:destroy();
        end);
    end;
    u23.toggled:Connect(function(p47) --[[ Line: 415 ]]
        -- upvalues: u23 (copy), u4 (ref)
        u23.noticeChanged:Fire(u23.totalNotices);
        for v48, _ in pairs(u23.childIconsDict) do
            local v49 = u4.getIconByUID(v48);
            v49.noticeChanged:Fire(v49.totalNotices);
            if not p47 and v49.isSelected then
                for _, _ in pairs(v49.childIconsDict) do
                    v49:deselect("HideParentFeature", u23);
                end;
            end;
        end;
    end);
    u23.selected:Connect(function() --[[ Line: 438 ]]
        -- upvalues: u23 (copy), l__StarterGui__3 (ref)
        if #u23.dropdownIcons > 0 then
            if l__StarterGui__3:GetCore("ChatActive") and u23.alignment ~= "Right" then
                u23.chatWasPreviouslyActive = true;
                l__StarterGui__3:SetCore("ChatActive", false);
            end;
            if l__StarterGui__3:GetCoreGuiEnabled("PlayerList") and u23.alignment ~= "Left" then
                u23.playerlistWasPreviouslyActive = true;
                l__StarterGui__3:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
            end;
        end;
    end);
    u23.deselected:Connect(function() --[[ Line: 451 ]]
        -- upvalues: u23 (copy), l__StarterGui__3 (ref)
        if u23.chatWasPreviouslyActive then
            u23.chatWasPreviouslyActive = nil;
            l__StarterGui__3:SetCore("ChatActive", true);
        end;
        if u23.playerlistWasPreviouslyActive then
            u23.playerlistWasPreviouslyActive = nil;
            l__StarterGui__3:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true);
        end;
    end);
    task.delay(0.1, function() --[[ Line: 465 ]]
        -- upvalues: u23 (copy)
        if u23.activeState == "Deselected" then
            u23.stateChanged:Fire("Deselected");
            u23:refresh();
        end;
    end);
    u4.iconAdded:Fire(u23);
    return u23;
end;
function u4.setName(p50, p51) --[[ Line: 481 ]]
    p50.widget.Name = p51;
    p50.name = p51;
    return p50;
end;
function u4.setState(p52, p53, p54, p55) --[[ Line: 487 ]]
    -- upvalues: l__Utility__8 (copy), u6 (copy)
    local v56 = l__Utility__8.formatStateName(p53 or (p52.isSelected and "Selected" or "Deselected"));
    if p52.activeState == v56 then
    else
        local l__isSelected__16 = p52.isSelected;
        p52.activeState = v56;
        if v56 == "Deselected" then
            p52.isSelected = false;
            if l__isSelected__16 then
                p52.toggled:Fire(false, p54, p55);
                p52.deselected:Fire(p54, p55);
            end;
            p52:_setToggleItemsVisible(false, p54, p55);
        elseif v56 == "Selected" then
            p52.isSelected = true;
            if not l__isSelected__16 then
                p52.toggled:Fire(true, p54, p55);
                p52.selected:Fire(p54, p55);
                u6:Fire(p52, p54, p55);
            end;
            p52:_setToggleItemsVisible(true, p54, p55);
        end;
        p52.stateChanged:Fire(v56, p54, p55);
    end;
end;
function u4.getInstance(u57, u58) --[[ Line: 520 ]]
    -- upvalues: l__Themes__9 (copy)
    local v59 = u57.cachedNamesToInstances[u58];
    if v59 then
        return v59;
    end;
    local function u63(u60, u61) --[[ Line: 528 ]]
        -- upvalues: u57 (copy)
        if not u57.cachedInstances[u61] then
            local v62 = u61:GetAttribute("Collective");
            if v62 then
                v62 = u57.cachedCollectives[v62];
            end;
            if v62 then
                table.insert(v62, u61);
            end;
            u57.cachedNamesToInstances[u60] = u61;
            u57.cachedInstances[u61] = true;
            u61.Destroying:Once(function() --[[ Line: 538 ]]
                -- upvalues: u57 (ref), u60 (copy), u61 (copy)
                u57.cachedNamesToInstances[u60] = nil;
                u57.cachedInstances[u61] = nil;
            end);
        end;
    end;
    local l__widget__17 = u57.widget;
    u63("Widget", l__widget__17);
    if u58 == "Widget" then
        return l__widget__17;
    end;
    local u64 = nil;
    local function u69(p65) --[[ Line: 551 ]]
        -- upvalues: u57 (copy), l__Themes__9 (ref), u69 (copy), u63 (copy), u58 (copy), u64 (ref)
        for _, v66 in pairs(p65:GetChildren()) do
            local v67 = v66:GetAttribute("WidgetUID");
            if not v67 or v67 == u57.UID then
                local v68 = l__Themes__9.getRealInstance(v66) or v66;
                u69(v68);
                if v68:IsA("GuiBase") or (v68:IsA("UIBase") or v68:IsA("ValueBase")) then
                    local l__Name__18 = v68.Name;
                    u63(l__Name__18, v68);
                    if l__Name__18 == u58 then
                        u64 = v68;
                    end;
                end;
            end;
        end;
    end;
    u69(l__widget__17);
    return u64;
end;
function u4.getCollective(p70, p71) --[[ Line: 580 ]]
    local v72 = p70.cachedCollectives[p71];
    if v72 then
        return v72;
    end;
    local v73 = {};
    for v74, _ in pairs(p70.cachedInstances) do
        if v74:GetAttribute("Collective") == p71 then
            table.insert(v73, v74);
        end;
    end;
    p70.cachedCollectives[p71] = v73;
    return v73;
end;
function u4.getInstanceOrCollective(p75, p76) --[[ Line: 601 ]]
    local v77 = {};
    local v78 = p75:getInstance(p76);
    if v78 then
        table.insert(v77, v78);
    end;
    if #v77 == 0 then
        v77 = p75:getCollective(p76);
    end;
    return v77;
end;
function u4.getStateGroup(p79, p80) --[[ Line: 615 ]]
    local v81 = p80 or p79.activeState;
    local v82 = p79.appearance[v81];
    if not v82 then
        v82 = {};
        p79.appearance[v81] = v82;
    end;
    return v82;
end;
function u4.refreshAppearance(p83, p84, p85) --[[ Line: 625 ]]
    -- upvalues: l__Themes__9 (copy)
    l__Themes__9.refresh(p83, p84, p85);
    return p83;
end;
function u4.refresh(p86) --[[ Line: 630 ]]
    p86:refreshAppearance(p86.widget);
    p86.updateSize:Fire();
    return p86;
end;
function u4.updateParent(p87) --[[ Line: 636 ]]
    -- upvalues: u4 (copy)
    local v88 = u4.getIconByUID(p87.parentIconUID);
    if v88 then
        v88.updateSize:Fire();
    end;
end;
function u4.setBehaviour(p89, p90, p91, p92, p93) --[[ Line: 643 ]]
    p89.customBehaviours[p90 .. "-" .. p91] = p92;
    if p93 then
        local v94 = p89:getInstanceOrCollective(p90);
        for _, v95 in pairs(v94) do
            p89:refreshAppearance(v95, p91);
        end;
    end;
end;
function u4.modifyTheme(p96, p97, p98) --[[ Line: 656 ]]
    -- upvalues: l__Themes__9 (copy)
    return p96, l__Themes__9.modify(p96, p97, p98);
end;
function u4.modifyChildTheme(p99, p100, p101) --[[ Line: 661 ]]
    -- upvalues: u4 (copy)
    p99.childModifications = p100;
    p99.childModificationsUID = p101;
    for v102, _ in pairs(p99.childIconsDict) do
        u4.getIconByUID(v102):modifyTheme(p100, p101);
    end;
    p99.childThemeModified:Fire();
    return p99;
end;
function u4.removeModification(p103, p104) --[[ Line: 674 ]]
    -- upvalues: l__Themes__9 (copy)
    l__Themes__9.remove(p103, p104);
    return p103;
end;
function u4.removeModificationWith(p105, p106, p107, p108) --[[ Line: 679 ]]
    -- upvalues: l__Themes__9 (copy)
    l__Themes__9.removeWith(p105, p106, p107, p108);
    return p105;
end;
function u4.setTheme(p109, p110) --[[ Line: 684 ]]
    -- upvalues: l__Themes__9 (copy)
    l__Themes__9.set(p109, p110);
    return p109;
end;
function u4.setEnabled(p111, p112) --[[ Line: 689 ]]
    p111.isEnabled = p112;
    p111.enabled = p111.isEnabled;
    p111.widget.Visible = p112;
    p111:updateParent();
    return p111;
end;
function u4.select(p113, p114, p115) --[[ Line: 697 ]]
    p113:setState("Selected", p114, p115);
    return p113;
end;
function u4.deselect(p116, p117, p118) --[[ Line: 702 ]]
    p116:setState("Deselected", p117, p118);
    return p116;
end;
function u4.notify(p119, p120, p121) --[[ Line: 707 ]]
    -- upvalues: l__Elements__14 (copy), u4 (copy)
    if not p119.notice then
        p119.notice = require(l__Elements__14.Notice)(p119, u4);
    end;
    p119.noticeStarted:Fire(p120, p121);
    return p119;
end;
function u4.clearNotices(p122) --[[ Line: 721 ]]
    p122.endNotices:Fire();
    return p122;
end;
function u4.disableOverlay(p123, p124) --[[ Line: 726 ]]
    p123.overlayDisabled = p124;
    return p123;
end;
u4.disableStateOverlay = u4.disableOverlay;
function u4.setImage(p125, u126, p127) --[[ Line: 732 ]]
    -- upvalues: l__ContentProvider__2 (copy)
    p125:modifyTheme({
        "IconImage",
        "Image",
        u126,
        p127
    });
    task.spawn(function() --[[ Line: 736 ]]
        -- upvalues: u126 (copy), l__ContentProvider__2 (ref)
        local v128;
        if tonumber(u126) then
            v128 = `rbxassetid://{u126}`;
        else
            v128 = u126;
        end;
        if l__ContentProvider__2:GetAssetFetchStatus(v128) ~= Enum.AssetFetchStatus.Success then
            pcall(l__ContentProvider__2.PreloadAsync, l__ContentProvider__2, { v128 });
        end;
    end);
    return p125;
end;
function u4.setLabel(p129, p130, p131) --[[ Line: 748 ]]
    p129:modifyTheme({
        "IconLabel",
        "Text",
        p130,
        p131
    });
    return p129;
end;
function u4.setOrder(p132, p133, p134) --[[ Line: 753 ]]
    local v135 = p133 * 100;
    p132:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v135,
        p134
    });
    p132:modifyTheme({
        "Widget",
        "LayoutOrder",
        v135,
        p134
    });
    return p132;
end;
function u4.setCornerRadius(p136, p137, p138) --[[ Line: 762 ]]
    p136:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p137,
        p138
    });
    return p136;
end;
function u4.align(p139, p140, p141) --[[ Line: 767 ]]
    -- upvalues: u4 (copy)
    local v142 = tostring(p140):lower();
    local v143 = (v142 == "mid" or v142 == "centre") and "center" or v142;
    local v144 = v143 ~= "left" and (v143 ~= "center" and v143 ~= "right") and "left" or v143;
    local v145 = v144 == "center" and u4.container.TopbarCentered or u4.container.TopbarStandard;
    local l__Holders__19 = v145.Holders;
    local v146 = string.upper((string.sub(v144, 1, 1))) .. string.sub(v144, 2);
    if not p141 then
        p139.originalAlignment = v146;
    end;
    local l__joinedFrame__20 = p139.joinedFrame;
    local v147 = l__Holders__19[v146];
    p139.screenGui = v145;
    p139.alignmentHolder = v147;
    if not p139.isDestroyed then
        p139.widget.Parent = l__joinedFrame__20 or v147;
    end;
    p139.alignment = v146;
    p139.alignmentChanged:Fire(v146);
    u4.iconChanged:Fire(p139);
    return p139;
end;
u4.setAlignment = u4.align;
function u4.setLeft(p148) --[[ Line: 796 ]]
    p148:setAlignment("Left");
    return p148;
end;
function u4.setMid(p149) --[[ Line: 801 ]]
    p149:setAlignment("Center");
    return p149;
end;
function u4.setRight(p150) --[[ Line: 806 ]]
    p150:setAlignment("Right");
    return p150;
end;
function u4.setWidth(p151, p152, p153) --[[ Line: 811 ]]
    p151:modifyTheme({
        "Widget",
        "DesiredWidth",
        p152,
        p153
    });
    return p151;
end;
function u4.setImageScale(p154, p155, p156) --[[ Line: 819 ]]
    p154:modifyTheme({
        "IconImageScale",
        "Value",
        p155,
        p156
    });
    return p154;
end;
function u4.setImageRatio(p157, p158, p159) --[[ Line: 824 ]]
    p157:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p158,
        p159
    });
    return p157;
end;
function u4.setTextSize(p160, p161, p162) --[[ Line: 829 ]]
    p160:modifyTheme({
        "IconLabel",
        "TextSize",
        p161,
        p162
    });
    return p160;
end;
function u4.setTextFont(p163, p164, p165, p166, p167) --[[ Line: 834 ]]
    local v168 = p165 or Enum.FontWeight.Regular;
    local v169 = p166 or Enum.FontStyle.Normal;
    local v170 = nil;
    local v171 = typeof(p164);
    if v171 == "number" then
        v170 = Font.fromId(p164, v168, v169);
    elseif v171 == "EnumItem" then
        v170 = Font.fromEnum(p164);
    elseif v171 == "string" and not p164:match("rbxasset") then
        v170 = Font.fromName(p164, v168, v169);
    end;
    p163:modifyTheme({
        "IconLabel",
        "FontFace",
        v170 or Font.new(p164, v168, v169),
        p167
    });
    return p163;
end;
function u4.setTextColor(p172, p173, p174) --[[ Line: 855 ]]
    if p173 == nil or (p173 == "" or (type(p173) ~= "userdata" or typeof(p173) ~= "Color3")) then
        if p173 ~= nil and p173 ~= "" then
            warn("setTextColor item must be a Color3 value! Changed the color to white.");
        end;
        p173 = Color3.fromRGB(255, 255, 255);
    end;
    p172:modifyTheme({
        "IconLabel",
        "TextColor3",
        p173,
        p174
    });
    return p172;
end;
function u4.bindToggleItem(p175, p176) --[[ Line: 867 ]]
    if not (p176:IsA("GuiObject") or p176:IsA("LayerCollector")) then
        error("Toggle item must be a GuiObject or LayerCollector!");
    end;
    p175.toggleItems[p176] = true;
    p175:_updateSelectionInstances();
    return p175;
end;
function u4.unbindToggleItem(p177, p178) --[[ Line: 876 ]]
    p177.toggleItems[p178] = nil;
    p177:_updateSelectionInstances();
    return p177;
end;
function u4._updateSelectionInstances(p179) --[[ Line: 882 ]]
    for v180, _ in pairs(p179.toggleItems) do
        local v181 = {};
        for _, v182 in pairs(v180:GetDescendants()) do
            if (v182:IsA("TextButton") or v182:IsA("ImageButton")) and v182.Active then
                table.insert(v181, v182);
            end;
        end;
        p179.toggleItems[v180] = v181;
    end;
end;
function u4._setToggleItemsVisible(p183, p184, _, p185) --[[ Line: 896 ]]
    for v186, _ in pairs(p183.toggleItems) do
        if not p185 or (p185 == p183 or p185.toggleItems[v186] == nil) then
            v186[v186:IsA("LayerCollector") and "Enabled" or "Visible"] = p184;
        end;
    end;
end;
function u4.bindEvent(u187, p188, u189) --[[ Line: 908 ]]
    local v190 = u187[p188];
    local v191;
    if v190 then
        if typeof(v190) == "table" then
            v191 = v190.Connect;
        else
            v191 = false;
        end;
    else
        v191 = v190;
    end;
    assert(v191, "argument[1] must be a valid topbarplus icon event name!");
    local v192 = typeof(u189) == "function";
    assert(v192, "argument[2] must be a function!");
    u187.bindedEvents[p188] = v190:Connect(function(...) --[[ Line: 912 ]]
        -- upvalues: u189 (copy), u187 (copy)
        u189(u187, ...);
    end);
    return u187;
end;
function u4.unbindEvent(p193, p194) --[[ Line: 918 ]]
    local v195 = p193.bindedEvents[p194];
    if v195 then
        v195:Disconnect();
        p193.bindedEvents[p194] = nil;
    end;
    return p193;
end;
function u4.bindToggleKey(p196, p197) --[[ Line: 927 ]]
    local v198 = typeof(p197) == "EnumItem";
    assert(v198, "argument[1] must be a KeyCode EnumItem!");
    p196.bindedToggleKeys[p197] = true;
    p196.toggleKeyAdded:Fire(p197);
    p196:setCaption("_hotkey_");
    return p196;
end;
function u4.unbindToggleKey(p199, p200) --[[ Line: 935 ]]
    local v201 = typeof(p200) == "EnumItem";
    assert(v201, "argument[1] must be a KeyCode EnumItem!");
    p199.bindedToggleKeys[p200] = nil;
    return p199;
end;
function u4.call(u202, u203, ...) --[[ Line: 941 ]]
    local u204 = table.pack(...);
    task.spawn(function() --[[ Line: 943 ]]
        -- upvalues: u203 (copy), u202 (copy), u204 (copy)
        u203(u202, table.unpack(u204));
    end);
    return u202;
end;
function u4.addToJanitor(p205, p206, p207, p208) --[[ Line: 949 ]]
    p205.janitor:add(p206, p207, p208);
    return p205;
end;
function u4.lock(p209) --[[ Line: 954 ]]
    p209:getInstance("ClickRegion").Visible = false;
    p209.locked = true;
    return p209;
end;
function u4.unlock(p210) --[[ Line: 962 ]]
    p210:getInstance("ClickRegion").Visible = true;
    p210.locked = false;
    return p210;
end;
function u4.debounce(p211, p212) --[[ Line: 969 ]]
    p211:lock();
    task.wait(p212);
    p211:unlock();
    return p211;
end;
function u4.autoDeselect(p213, p214) --[[ Line: 976 ]]
    p213.deselectWhenOtherIconSelected = p214 == nil and true or p214;
    return p213;
end;
function u4.oneClick(u215, p216) --[[ Line: 986 ]]
    local l__singleClickJanitor__21 = u215.singleClickJanitor;
    l__singleClickJanitor__21:clean();
    if p216 or p216 == nil then
        l__singleClickJanitor__21:add(u215.selected:Connect(function() --[[ Line: 992 ]]
            -- upvalues: u215 (copy)
            u215:deselect("OneClick", u215);
        end));
    end;
    u215.oneClickEnabled = true;
    return u215;
end;
function u4.setCaption(p217, p218) --[[ Line: 1000 ]]
    -- upvalues: l__Elements__14 (copy)
    if p218 == "_hotkey_" and p217.captionText then
        return p217;
    end;
    local l__captionJanitor__22 = p217.captionJanitor;
    p217.captionJanitor:clean();
    if not p218 or p218 == "" then
        p217.caption = nil;
        p217.captionText = nil;
        return p217;
    end;
    local v219 = l__captionJanitor__22:add(require(l__Elements__14.Caption)(p217));
    v219:SetAttribute("CaptionText", p218);
    p217.caption = v219;
    p217.captionText = p218;
    return p217;
end;
function u4.setCaptionHint(p220, p221) --[[ Line: 1018 ]]
    local v222 = typeof(p221) == "EnumItem";
    assert(v222, "argument[1] must be a KeyCode EnumItem!");
    p220.fakeToggleKey = p221;
    p220.fakeToggleKeyChanged:Fire(p221);
    p220:setCaption("_hotkey_");
    return p220;
end;
function u4.leave(p223) --[[ Line: 1026 ]]
    p223.joinJanitor:clean();
    return p223;
end;
function u4.joinMenu(p224, p225) --[[ Line: 1032 ]]
    -- upvalues: l__Utility__8 (copy)
    l__Utility__8.joinFeature(p224, p225, p225.menuIcons, p225:getInstance("Menu"));
    p225.menuChildAdded:Fire(p224);
    return p224;
end;
function u4.setMenu(p226, p227) --[[ Line: 1038 ]]
    p226.menuSet:Fire(p227);
    return p226;
end;
function u4.setFixedMenu(p228, p229) --[[ Line: 1043 ]]
    p228:freezeMenu(p229);
    p228:setMenu(p229);
end;
u4.setFrozenMenu = u4.setFixedMenu;
function u4.freezeMenu(u230) --[[ Line: 1049 ]]
    u230:select("FrozenMenu", u230);
    u230:bindEvent("deselected", function(p231) --[[ Line: 1053 ]]
        -- upvalues: u230 (copy)
        p231:select("FrozenMenu", u230);
    end);
    u230:modifyTheme({ "IconSpot", "Visible", false });
end;
function u4.joinDropdown(p232, p233) --[[ Line: 1059 ]]
    -- upvalues: l__Utility__8 (copy)
    p233:getDropdown();
    l__Utility__8.joinFeature(p232, p233, p233.dropdownIcons, p233:getInstance("DropdownScroller"));
    p233.dropdownChildAdded:Fire(p232);
    return p232;
end;
function u4.getDropdown(p234) --[[ Line: 1066 ]]
    -- upvalues: l__Elements__14 (copy)
    local l__dropdown__23 = p234.dropdown;
    if not l__dropdown__23 then
        l__dropdown__23 = require(l__Elements__14.Dropdown)(p234);
        p234.dropdown = l__dropdown__23;
        p234:clipOutside(l__dropdown__23);
    end;
    return l__dropdown__23;
end;
function u4.setDropdown(p235, p236) --[[ Line: 1076 ]]
    p235:getDropdown();
    p235.dropdownSet:Fire(p236);
    return p235;
end;
function u4.clipOutside(p237, p238) --[[ Line: 1082 ]]
    -- upvalues: l__Utility__8 (copy)
    local v239 = l__Utility__8.clipOutside(p237, p238);
    p237:refreshAppearance(p238);
    return p237, v239;
end;
function u4.setIndicator(p240, p241) --[[ Line: 1093 ]]
    -- upvalues: l__Elements__14 (copy), u4 (copy)
    if not p240.indicator then
        p240.indicator = p240.janitor:add(require(l__Elements__14.Indicator)(p240, u4));
    end;
    p240.indicatorSet:Fire(p241);
end;
function u4.convertLabelToNumberSpinner(u242, u243, u244) --[[ Line: 1105 ]]
    task.defer(function() --[[ Line: 1106 ]]
        -- upvalues: u242 (copy), u243 (copy), u244 (copy)
        local u245 = u242:getInstance("IconLabel");
        u245.Transparency = 1;
        u243.Parent = u245.Parent;
        u243.Size = UDim2.fromScale(1, 1);
        u243.AnchorPoint = Vector2.new(0.5, 0.5);
        u243.Position = UDim2.new(0.5, 0, 0.5, 0);
        u243.TextXAlignment = Enum.TextXAlignment.Center;
        u243.ClipsDescendants = false;
        for _, u246 in ipairs({
            "FontFace",
            "BorderSizePixel",
            "BorderColor3",
            "Rotation",
            "TextStrokeTransparency",
            "TextStrokeColor3",
            "TextStrokeTransparency",
            "TextColor3"
        }) do
            u243[u246] = u245[u246];
            u242:addToJanitor(u245:GetPropertyChangedSignal(u246):Connect(function() --[[ Line: 1129 ]]
                -- upvalues: u243 (ref), u246 (copy), u245 (copy)
                u243[u246] = u245[u246];
            end));
        end;
        local function u251() --[[ Line: 1136 ]]
            -- upvalues: u243 (ref)
            local v247 = 0;
            local v248 = 0;
            for _, v249 in u243.Frame:GetChildren() do
                local v250 = string.lower(v249.Name);
                if v250 == "digit" then
                    v247 = v247 + v249.AbsoluteSize.X;
                    v248 = v248 + 1;
                elseif (v250 == "prefix" or (v250 == "suffix" or v250 == "comma")) and v249.Text ~= "" then
                    v247 = v247 + v249.AbsoluteSize.X;
                    v248 = v248 + 1;
                end;
            end;
            return v247, v248;
        end;
        local function u257() --[[ Line: 1170 ]]
            -- upvalues: u251 (copy), u242 (ref), u243 (ref), u245 (copy)
            local v252, v253 = u251();
            if v253 < 18 then
                u242:setLabel(u243.Value);
            end;
            local l__X__24 = u243.Frame.AbsoluteSize.X;
            while v252 < l__X__24 and u242.isDestroyed ~= true do
                task.wait(0.05);
                if v253 > 0 and v253 < 8 then
                    u243.TextSize = u245.TextSize;
                    break;
                end;
                local v254 = u243;
                v254.TextSize = v254.TextSize + 1;
                l__X__24 = u243.Frame.AbsoluteSize.X;
                v252, v253 = u251();
            end;
            local l__Parent__25 = u245.Parent;
            if l__Parent__25 then
                l__Parent__25 = l__Parent__25.Parent;
            end;
            local v255;
            if l__Parent__25 == nil then
                v255 = 0;
            elseif l__Parent__25.IconImage.Visible == true then
                v255 = u243.Frame.AbsoluteSize.X + u245.Parent.Parent.IconImage.AbsoluteSize.X;
            else
                v255 = l__Parent__25.AbsoluteSize.X;
            end;
            while v255 < v252 and u242.isDestroyed ~= true do
                task.wait(0.05);
                if v253 < 8 and v253 > 0 then
                    u243.TextSize = u245.TextSize;
                    return;
                end;
                local v256 = u243;
                v256.TextSize = v256.TextSize - 1;
                local l__Parent__26 = u245.Parent;
                if l__Parent__26 then
                    l__Parent__26 = l__Parent__26.Parent;
                end;
                if l__Parent__26 == nil then
                    v255 = 0;
                elseif l__Parent__26.IconImage.Visible == true then
                    v255 = u243.Frame.AbsoluteSize.X + u245.Parent.Parent.IconImage.AbsoluteSize.X;
                else
                    v255 = l__Parent__26.AbsoluteSize.X;
                end;
                v252, v253 = u251();
            end;
        end;
        u242:addToJanitor(u243.Frame.ChildAdded:Connect(u257));
        u242:addToJanitor(u243.Frame.ChildRemoved:Connect(u257));
        u242:addToJanitor(u242.iconAdded:Connect(function() --[[ Line: 1208 ]]
            -- upvalues: u257 (copy)
            task.wait(1);
            u257();
        end));
        u242:updateParent();
        u243.Name = "LabelSpinner";
        u243.Prefix = "$";
        u243.Commas = true;
        u243.Decimals = 0;
        u243.Duration = 0.25;
        u243.Value = 10;
        task.wait(0.2);
        if typeof(u244) == "function" then
            u244();
        end;
    end);
    return u242;
end;
function u4.destroy(p258) --[[ Line: 1235 ]]
    -- upvalues: u4 (copy)
    if p258.isDestroyed then
    else
        p258:clearNotices();
        if p258.parentIconUID then
            p258:leave();
        end;
        p258.isDestroyed = true;
        p258.janitor:clean();
        u4.iconRemoved:Fire(p258);
    end;
end;
u4.Destroy = u4.destroy;
return u4;