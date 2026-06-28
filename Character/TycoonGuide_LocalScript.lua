-- Roblox: Workspace.SilverAce293026.TycoonGuide
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__Players__2 = game:GetService("Players");
game:GetService("RunService");
local l__ReplicatedConfig__3 = require(l__ReplicatedStorage__1:WaitForChild("ReplicatedConfig"));
local l__LocalPlayer__4 = l__Players__2.LocalPlayer;
local l__PlayerGui__5 = l__LocalPlayer__4:WaitForChild("PlayerGui");
local l__Modules__6 = l__ReplicatedStorage__1:WaitForChild("Modules");
local l__ContextArrowModule__7 = require(l__Modules__6:WaitForChild("ContextArrowModule"));
local l__AreaModule__8 = require(l__Modules__6:WaitForChild("AreaModule"));
if l__ReplicatedConfig__3.Mode ~= "Tycoon" then
    return;
end;
repeat
    task.wait();
until not l__PlayerGui__5:FindFirstChild("TutorialGui");
local l__Value__9 = l__LocalPlayer__4:WaitForChild("AssociatedTycoon").Value;
local u1 = workspace:WaitForChild(l__Value__9);
local l__RootPart__10 = u1:WaitForChild("RootPart");
local l__BuyButtons__11 = u1:WaitForChild("BuyButtons");
local l__AutoCollect__12 = u1:WaitForChild("Params"):WaitForChild("AutoCollect");
local l__Money__13 = l__LocalPlayer__4:WaitForChild("leaderstats"):WaitForChild("Money");
local u2 = false;
local function u10(p3, p4) --[[ Line: 35 ]]
    -- upvalues: u2 (ref), u10 (copy), l__BuyButtons__11 (copy), l__ContextArrowModule__7 (copy), l__Money__13 (copy), l__AutoCollect__12 (copy), u1 (copy)
    if u2 or p4 then
        if p3 and p3:IsA("Folder") then
        else
            if p3 and p3:IsA("Model") then
                p3:GetPropertyChangedSignal("Name"):Connect(u10);
            end;
            if p4 then
            else
                local v5 = {};
                for _, v6 in l__BuyButtons__11:GetChildren() do
                    if v6:IsA("Model") and v6.Name ~= "[BOUGHT]" then
                        table.insert(v5, v6);
                    end;
                end;
                if #v5 == 0 then
                    l__ContextArrowModule__7.Clear();
                else
                    table.sort(v5, function(p7, p8) --[[ Line: 57 ]]
                        return (p7:GetAttribute("Cost") or 100000000) < (p8:GetAttribute("Cost") or 100000000);
                    end);
                    local v9 = v5[1];
                    if v9:GetAttribute("Cost") > l__Money__13.Value and not l__AutoCollect__12.Value then
                        local l__CashCollectButton__14 = u1:WaitForChild("CashGiver"):WaitForChild("CashCollectButton");
                        l__ContextArrowModule__7.SetTarget(l__CashCollectButton__14);
                    else
                        l__ContextArrowModule__7.SetTarget(v9:FindFirstChild("ButtonPart"));
                    end;
                end;
            end;
        end;
    end;
end;
l__Money__13.Changed:Connect(function() --[[ Line: 79 ]]
    -- upvalues: u10 (copy)
    u10();
end);
l__BuyButtons__11.ChildAdded:Connect(u10);
l__BuyButtons__11.ChildRemoved:Connect(function() --[[ Line: 83 ]]
    -- upvalues: u10 (copy)
    u10();
end);
local u11 = u2;
for _, v12 in l__BuyButtons__11:GetChildren() do
    if not (v12 and v12:IsA("Folder")) then
        if v12 and v12:IsA("Model") then
            v12:GetPropertyChangedSignal("Name"):Connect(u10);
        end;
    end;
end;
local l__HumanoidRootPart__15 = (l__LocalPlayer__4.Character or l__LocalPlayer__4.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart");
local u13 = true;
local function v14() --[[ Line: 96 ]]
    -- upvalues: u13 (ref), l__LocalPlayer__4 (copy), u11 (ref), l__ContextArrowModule__7 (copy)
    u13 = l__LocalPlayer__4:GetAttribute("GuideOn");
    u11 = false;
    l__ContextArrowModule__7.Clear();
end;
l__LocalPlayer__4:GetAttributeChangedSignal("GuideOn"):Connect(v14);
u13 = l__LocalPlayer__4:GetAttribute("GuideOn");
u2 = false;
l__ContextArrowModule__7.Clear();
local v15 = u2;
while true do
    repeat
        task.wait(1);
    until u13;
    u2 = l__AreaModule__8(l__RootPart__10, l__HumanoidRootPart__15);
    if v15 or not u2 then
        if v15 and not u2 then
            print("clearing");
            l__ContextArrowModule__7.Clear();
            v15 = u2;
        else
            v15 = u2;
        end;
    else
        u10();
        v15 = u2;
    end;
end;