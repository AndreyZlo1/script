-- Roblox: ReplicatedFirst.LoadingScript.LoadingGuiOld.ModesBack
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {};
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local _ = require(l__ReplicatedStorage__1:WaitForChild("ReplicatedConfig")).Mode == "Tycoon";
local l__ModesFrame__2 = script.Parent:WaitForChild("Frame"):WaitForChild("ModesFrame");
u1.isModalMode = false;
function u1.closeClicked() --[[ Line: 12 ]]
    -- upvalues: u1 (copy), l__ModesFrame__2 (copy)
    if u1.isModalMode then
        l__ModesFrame__2:TweenPosition(UDim2.new(0.5, 0, 1.15, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3);
    else
        l__ModesFrame__2.Visible = false;
        l__ModesFrame__2.Parent.Menu.Visible = true;
    end;
end;
return u1;