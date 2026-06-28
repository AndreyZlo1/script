-- Roblox: Workspace.SilverAce293026.PlaneControl
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
game:GetService("ReplicatedStorage");
local l__UserInputService__2 = game:GetService("UserInputService");
local u1 = {
    UtilModule = require(script:WaitForChild("UtilModule")),
    CameraModule = require(script:WaitForChild("CameraModule")),
    MovementModule = require(script:WaitForChild("MovementModule")),
    UIModule = require(script:WaitForChild("UIModule")),
    WeaponModule = require(script:WaitForChild("WeaponModule")),
    CrashModule = require(script:WaitForChild("CrashModule"))
};
local l__InputModule__3 = require(script:WaitForChild("InputModule"));
local l__CustomMobileGui__4 = l__Players__1.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CustomMobileGui");
local l__RightHeliFrame__5 = l__CustomMobileGui__4:WaitForChild("RightHeliFrame");
local l__LeftHeliFrame__6 = l__CustomMobileGui__4:WaitForChild("LeftHeliFrame");
local u2 = false;
local function u6(p3, p4) --[[ Line: 41 ]]
    for _, v5 in p3:GetDescendants() do
        if v5:IsA("ProximityPrompt") then
            v5.Enabled = p4;
        end;
    end;
end;
local u7 = nil;
local function u9() --[[ Line: 67 ]]
    -- upvalues: u7 (ref), u1 (copy), l__InputModule__3 (copy), u6 (copy), l__RightHeliFrame__5 (copy), l__LeftHeliFrame__6 (copy), u2 (ref)
    if u7 == nil then
    else
        for _, v8 in u1 do
            v8.UnsetPlane();
        end;
        l__InputModule__3.UnbindScheme("Plane");
        u6(u7, true);
        u7 = nil;
        if u7 then
            l__RightHeliFrame__5.Visible = false;
            l__LeftHeliFrame__6.Visible = u2;
        else
            l__RightHeliFrame__5.Visible = false;
            l__LeftHeliFrame__6.Visible = false;
        end;
    end;
end;
local function u12(p10) --[[ Line: 78 ]]
    -- upvalues: u9 (copy), u7 (ref), u6 (copy), l__InputModule__3 (copy), u1 (copy), l__RightHeliFrame__5 (copy), l__LeftHeliFrame__6 (copy), u2 (ref)
    u9();
    u7 = p10;
    u6(p10, false);
    l__InputModule__3.BindScheme("Plane", require(script.InputModule.PlaneScheme));
    for _, v11 in u1 do
        v11.SetPlane(p10);
    end;
    if u7 then
        l__RightHeliFrame__5.Visible = false;
        l__LeftHeliFrame__6.Visible = u2;
    else
        l__RightHeliFrame__5.Visible = false;
        l__LeftHeliFrame__6.Visible = false;
    end;
end;
local function v15(p13) --[[ Line: 90 ]]
    -- upvalues: u2 (ref), u7 (ref), l__RightHeliFrame__5 (copy), l__LeftHeliFrame__6 (copy)
    local v14 = u2;
    u2 = p13.UserInputType == Enum.UserInputType.Touch;
    if v14 ~= u2 then
        if not u7 then
            l__RightHeliFrame__5.Visible = false;
            l__LeftHeliFrame__6.Visible = false;
            return;
        end;
        l__RightHeliFrame__5.Visible = false;
        l__LeftHeliFrame__6.Visible = u2;
    end;
end;
l__UserInputService__2.InputChanged:Connect(v15);
l__UserInputService__2.InputBegan:Connect(v15);
l__Players__1.LocalPlayer.Character:WaitForChild("Humanoid").Seated:Connect(function(_, p16) --[[ Line: 106 ]]
    -- upvalues: l__RightHeliFrame__5 (copy), u9 (copy), u6 (copy), u12 (copy)
    if p16 then
        local v17 = p16:FindFirstAncestorOfClass("Model");
        if v17 then
            local v18 = v17:FindFirstChild("Required");
            if v18 then
                if v18:FindFirstChild("PlaneSeat") == nil then
                    v17 = nil;
                end;
            else
                v17 = nil;
            end;
        else
            v17 = nil;
        end;
        if v17 then
            u6(v17, false);
            u12(v17);
        end;
    else
        l__RightHeliFrame__5.Visible = false;
        l__RightHeliFrame__5.Visible = false;
        u9();
    end;
end);