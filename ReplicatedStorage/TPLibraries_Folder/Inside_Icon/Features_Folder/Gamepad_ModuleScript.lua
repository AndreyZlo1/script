-- Roblox: ReplicatedStorage.TPLibraries.Icon.Features.Gamepad
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__GamepadService__1 = game:GetService("GamepadService");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__GuiService__3 = game:GetService("GuiService");
local l__DPadUp__4 = Enum.KeyCode.DPadUp;
local l__Gamepad__5 = Enum.PreferredInput.Gamepad;
local u1 = {};
local u2 = nil;
function u1.start(p3) --[[ Line: 26 ]]
    -- upvalues: u2 (ref), l__DPadUp__4 (copy), l__GuiService__3 (copy), l__UserInputService__2 (copy), l__Gamepad__5 (copy), u1 (copy), l__GamepadService__1 (copy)
    u2 = p3;
    local v4 = u2;
    local v5;
    if u2.highlightKey == nil then
        v5 = l__DPadUp__4;
    else
        v5 = u2.highlightKey;
    end;
    v4.highlightKey = v5;
    u2.highlightIcon = false;
    task.delay(1, function() --[[ Line: 35 ]]
        -- upvalues: u2 (ref), l__GuiService__3 (ref), l__DPadUp__4 (ref), l__UserInputService__2 (ref), l__Gamepad__5 (ref), u1 (ref), l__GamepadService__1 (ref)
        local l__iconsDictionary__6 = u2.iconsDictionary;
        local u6 = nil;
        local u7 = l__DPadUp__4 ~= u2.highlightKey;
        local u8 = l__DPadUp__4 ~= u2.highlightKey;
        local l__Selection__7 = require(script.Parent.Parent.Elements.Selection);
        local function u13() --[[ Line: 50 ]]
            -- upvalues: l__GuiService__3 (ref), l__iconsDictionary__6 (copy), l__UserInputService__2 (ref), l__Gamepad__5 (ref), l__Selection__7 (copy), u2 (ref), u6 (ref), u8 (ref), u7 (ref), u1 (ref)
            local l__SelectedObject__8 = l__GuiService__3.SelectedObject;
            if l__SelectedObject__8 then
                l__SelectedObject__8 = l__SelectedObject__8:GetAttribute("CorrespondingIconUID");
            end;
            if l__SelectedObject__8 then
                l__SelectedObject__8 = l__iconsDictionary__6[l__SelectedObject__8];
            end;
            local v9 = l__UserInputService__2.PreferredInput == l__Gamepad__5;
            if l__SelectedObject__8 then
                if v9 then
                    local v10 = l__SelectedObject__8:getInstance("ClickRegion");
                    local l__selection__9 = l__SelectedObject__8.selection;
                    if not l__selection__9 then
                        l__selection__9 = l__SelectedObject__8.janitor:add(l__Selection__7(u2));
                        l__selection__9:SetAttribute("IgnoreVisibilityUpdater", true);
                        l__selection__9.Parent = l__SelectedObject__8.widget;
                        l__SelectedObject__8.selection = l__selection__9;
                        l__SelectedObject__8:refreshAppearance(l__selection__9);
                    end;
                    v10.SelectionImageObject = l__selection__9.Selection;
                end;
                if u6 and u6 ~= l__SelectedObject__8 then
                    u6:setIndicator();
                end;
                local v11;
                if v9 and not (u8 or l__SelectedObject__8.parentIconUID) then
                    v11 = Enum.KeyCode.ButtonB;
                else
                    v11 = nil;
                end;
                u6 = l__SelectedObject__8;
                u2.lastHighlightedIcon = l__SelectedObject__8;
                l__SelectedObject__8:setIndicator(v11);
            else
                local v12;
                if v9 and not u7 then
                    v12 = u2.highlightKey;
                else
                    v12 = nil;
                end;
                if not u6 then
                    u6 = u1.getIconToHighlight();
                end;
                if v12 == u2.highlightKey then
                    u7 = true;
                end;
                if u6 then
                    u6:setIndicator(v12);
                end;
            end;
        end;
        l__GuiService__3:GetPropertyChangedSignal("SelectedObject"):Connect(u13);
        local function v14() --[[ Line: 93 ]]
            -- upvalues: l__UserInputService__2 (ref), l__Gamepad__5 (ref), u7 (ref), u8 (ref), u13 (copy)
            if l__UserInputService__2.PreferredInput ~= l__Gamepad__5 then
                u7 = false;
                u8 = false;
            end;
            u13();
        end;
        l__UserInputService__2:GetPropertyChangedSignal("PreferredInput"):Connect(v14);
        if l__UserInputService__2.PreferredInput ~= l__Gamepad__5 then
            local _ = false;
            u8 = false;
        end;
        u13();
        l__UserInputService__2.InputBegan:Connect(function(p15, _) --[[ Line: 109 ]]
            -- upvalues: l__GuiService__3 (ref), l__iconsDictionary__6 (copy), u2 (ref), u1 (ref), l__GamepadService__1 (ref)
            if p15.UserInputType == Enum.UserInputType.MouseButton1 then
                local l__SelectedObject__10 = l__GuiService__3.SelectedObject;
                if l__SelectedObject__10 then
                    l__SelectedObject__10 = l__SelectedObject__10:GetAttribute("CorrespondingIconUID");
                end;
                if l__SelectedObject__10 then
                    l__SelectedObject__10 = l__iconsDictionary__6[l__SelectedObject__10];
                end;
                if l__SelectedObject__10 then
                    l__GuiService__3.SelectedObject = nil;
                end;
            elseif p15.KeyCode == u2.highlightKey then
                local v16 = u1.getIconToHighlight();
                if v16 then
                    if l__GamepadService__1.GamepadCursorEnabled then
                        task.wait(0.2);
                        l__GamepadService__1:DisableGamepadCursor();
                    end;
                    l__GuiService__3.SelectedObject = v16:getInstance("ClickRegion");
                end;
            end;
        end);
    end);
end;
function u1.getIconToHighlight() --[[ Line: 136 ]]
    -- upvalues: u2 (ref)
    local l__iconsDictionary__11 = u2.iconsDictionary;
    local v17 = u2.highlightIcon or u2.lastHighlightedIcon;
    if not v17 then
        local v18 = nil;
        for _, v19 in pairs(l__iconsDictionary__11) do
            if not v19.parentIconUID and (not v18 or v19.widget.AbsolutePosition.X < v18) then
                v18 = v19.widget.AbsolutePosition.X;
                v17 = v19;
            end;
        end;
    end;
    return v17;
end;
function u1.registerButton(u20) --[[ Line: 158 ]]
    -- upvalues: l__UserInputService__2 (copy), l__GamepadService__1 (copy), l__GuiService__3 (copy)
    local u21 = false;
    u20.InputBegan:Connect(function(_) --[[ Line: 164 ]]
        -- upvalues: u21 (ref)
        u21 = true;
        task.wait();
        task.wait();
        u21 = false;
    end);
    local u24 = l__UserInputService__2.InputBegan:Connect(function(p22) --[[ Line: 173 ]]
        -- upvalues: u21 (ref), l__GamepadService__1 (ref), l__GuiService__3 (ref), u20 (copy)
        task.wait();
        if p22.KeyCode == Enum.KeyCode.ButtonA and u21 then
            task.wait(0.2);
            l__GamepadService__1:DisableGamepadCursor();
            l__GuiService__3.SelectedObject = u20;
        else
            local v23 = l__GuiService__3.SelectedObject == u20;
            local l__Name__12 = p22.KeyCode.Name;
            if table.find({ "ButtonB", "ButtonSelect" }, l__Name__12) and (v23 and (l__Name__12 ~= "ButtonSelect" or l__GamepadService__1.GamepadCursorEnabled)) then
                l__GuiService__3.SelectedObject = nil;
            end;
        end;
    end);
    u20.Destroying:Once(function() --[[ Line: 194 ]]
        -- upvalues: u24 (copy)
        u24:Disconnect();
    end);
end;
return u1;