-- Roblox: Workspace.SilverAce293026.TycoonAnimations
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
if require(l__ReplicatedStorage__2:WaitForChild("ReplicatedConfig")).Mode == "Tycoon" then
    local l__AssociatedTycoon__3 = l__Players__1.LocalPlayer:WaitForChild("AssociatedTycoon");
    local l__AnimateConstruction__4 = l__ReplicatedStorage__2:WaitForChild("TycoonEvents"):WaitForChild("AnimateConstruction");
    local l__Modules__5 = l__ReplicatedStorage__2:WaitForChild("Modules");
    local l__AnimationModule__6 = require(l__Modules__5:WaitForChild("AnimationModule"));
    local l__GuiModule__7 = require(l__Modules__5:WaitForChild("GuiModule"));
    l__AnimateConstruction__4.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 19 ]]
        -- upvalues: l__AssociatedTycoon__3 (copy), l__GuiModule__7 (copy), l__AnimationModule__6 (copy)
        if p2 == l__AssociatedTycoon__3.Value then
            local v5 = workspace[p2][p3 .. "s"]:WaitForChild(p1, 10);
            if v5 then
                if p4 then
                    if p4 == "Server" then
                        l__GuiModule__7.Sounds.serverBuild();
                    else
                        l__GuiModule__7.Sounds.equipmentBuild();
                    end;
                else
                    l__GuiModule__7.Sounds.genericBuild();
                end;
                l__AnimationModule__6.makeObjectTransparent(v5);
                l__AnimationModule__6.animateObjectAppearance(v5);
            else
                warn("TycoonAnimations | " .. p1 .. " not found");
            end;
        end;
    end);
end;