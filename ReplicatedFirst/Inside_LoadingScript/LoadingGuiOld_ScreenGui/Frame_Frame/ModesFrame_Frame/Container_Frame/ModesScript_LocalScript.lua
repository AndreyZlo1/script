-- Roblox: ReplicatedFirst.LoadingScript.LoadingGuiOld.Frame.ModesFrame.Container.ModesScript
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__ReplicatedConfig__2 = require(l__ReplicatedStorage__1:WaitForChild("ReplicatedConfig"));
local l__Mode__3 = l__ReplicatedConfig__2.Mode;
local l__RequestTeleport__4 = l__ReplicatedStorage__1:WaitForChild("PlayerEvents"):WaitForChild("RequestTeleport");
local v1 = {
    Tycoon = script.Parent:WaitForChild("Tycoon"),
    Deathmatch = script.Parent:WaitForChild("Deathmatch")
};
local v2 = (l__Mode__3 == nil or l__Mode__3 == "") and "Tycoon" or l__Mode__3;
local l__Parent__5 = script.Parent.Parent.Parent.Parent;
for u3, v4 in v1 do
    local l__JoinBtn__6 = v4:WaitForChild("Background"):WaitForChild("JoinBtnFrame"):WaitForChild("BtnFrame"):WaitForChild("JoinBtn");
    if v2 == u3 then
        l__JoinBtn__6.Text = "You are here";
        l__JoinBtn__6.Parent.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
        l__JoinBtn__6.AutoButtonColor = false;
    else
        l__JoinBtn__6.Activated:Connect(function() --[[ Line: 28 ]]
            -- upvalues: l__Parent__5 (copy), l__ReplicatedConfig__2 (copy), l__RequestTeleport__4 (copy), u3 (copy)
            l__Parent__5.Enabled = false;
            local v5, v6 = pcall(function() --[[ Line: 30 ]]
                -- upvalues: l__ReplicatedConfig__2 (ref), l__RequestTeleport__4 (ref), u3 (ref)
                return l__RequestTeleport__4:InvokeServer(l__ReplicatedConfig__2.ModeIds[u3][l__ReplicatedConfig__2.IsProd and "Prod" or "Beta"]);
            end);
            if not (v5 and v6) then
                warn("Failed to teleport player to mode:", v6);
                l__Parent__5.Enabled = true;
            end;
        end);
    end;
end;