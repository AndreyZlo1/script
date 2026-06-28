-- Roblox: Workspace.SilverAce293026.ACS_Client.ACS_Framework.DraggableObject
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__new__1 = UDim2.new;
local l__UserInputService__2 = game:GetService("UserInputService");
local u1 = {};
u1.__index = u1;
function u1.new(p2) --[[ Line: 17 ]]
    -- upvalues: u1 (copy)
    local v3 = {
        Object = p2,
        DragStarted = nil,
        DragEnded = nil,
        Dragged = nil,
        Dragging = false
    };
    setmetatable(v3, u1);
    return v3;
end;
function u1.Enable(u4) --[[ Line: 31 ]]
    -- upvalues: l__new__1 (copy), l__UserInputService__2 (copy)
    local l__Object__3 = u4.Object;
    local u5 = nil;
    local u6 = nil;
    local u7 = nil;
    local u8 = false;
    u4.InputBegan = l__Object__3.InputBegan:Connect(function(u9) --[[ Line: 47 ]]
        -- upvalues: u8 (ref), u4 (copy)
        if u9.UserInputType == Enum.UserInputType.MouseButton1 or u9.UserInputType == Enum.UserInputType.Touch then
            u8 = true;
            local u10 = nil;
            u10 = u9.Changed:Connect(function() --[[ Line: 60 ]]
                -- upvalues: u9 (copy), u4 (ref), u8 (ref), u10 (ref)
                if u9.UserInputState == Enum.UserInputState.End and (u4.Dragging or u8) then
                    u4.Dragging = false;
                    u10:Disconnect();
                    if u4.DragEnded and not u8 then
                        u4.DragEnded();
                    end;
                    u8 = false;
                end;
            end);
        end;
    end);
    u4.InputChanged = l__Object__3.InputChanged:Connect(function(p11) --[[ Line: 75 ]]
        -- upvalues: u5 (ref)
        if p11.UserInputType == Enum.UserInputType.MouseMovement or p11.UserInputType == Enum.UserInputType.Touch then
            u5 = p11;
        end;
    end);
    u4.InputChanged2 = l__UserInputService__2.InputChanged:Connect(function(p12) --[[ Line: 81 ]]
        -- upvalues: l__Object__3 (copy), u4 (copy), u8 (ref), u6 (ref), u7 (ref), u5 (ref), l__new__1 (ref)
        if l__Object__3.Parent == nil then
            u4:Disable();
        else
            if u8 then
                u8 = false;
                if u4.DragStarted then
                    u4.DragStarted();
                end;
                u4.Dragging = true;
                u6 = p12.Position;
                u7 = l__Object__3.Position;
            end;
            if p12 == u5 and u4.Dragging then
                local v13 = p12.Position - u6;
                local v14 = l__new__1(u7.X.Scale, u7.X.Offset + v13.X, u7.Y.Scale, u7.Y.Offset + v13.Y);
                l__Object__3.Position = v14;
                if u4.Dragged then
                    u4.Dragged(v14);
                end;
            end;
        end;
    end);
end;
function u1.Disable(p15) --[[ Line: 110 ]]
    p15.InputBegan:Disconnect();
    p15.InputChanged:Disconnect();
    p15.InputChanged2:Disconnect();
    if p15.Dragging then
        p15.Dragging = false;
        if p15.DragEnded then
            p15.DragEnded();
        end;
    end;
end;
return u1;