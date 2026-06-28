-- Roblox: Players.SilverAce293026.PlayerScripts.MinigameClient.GroundWar
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local l__Players__2 = game:GetService("Players");
local l__TweenService__3 = game:GetService("TweenService");
local l__KillMe__4 = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("KillMe");
local l__Common__5 = require(script.Parent:WaitForChild("Common"));
local u1 = {
    InterfaceElements = { "Teams", "Countdown", "NotificationStack" }
};
local l__LocalPlayer__6 = l__Players__2.LocalPlayer;
local l__OutOfBounds__7 = game:GetService("Lighting"):WaitForChild("OutOfBounds");
local u2 = TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = nil;
function u1.StateReplication(p7) --[[ Line: 24 ]]
    -- upvalues: u3 (ref), l__Common__5 (copy), u4 (ref), l__RunService__1 (copy), u1 (copy)
    u3 = p7;
    l__Common__5.MinigameGui.UpdateTeams(p7.ScoreGoal, p7.Teams.Blue.Score, p7.Teams.Red.Score);
    l__Common__5.MinigameGui.SetCountdownGoal(p7.EndTimestamp);
    if not u4 then
        u4 = l__RunService__1.Heartbeat:Connect(u1.RunLoop);
    end;
end;
function u1.UpdateScores(p8, p9) --[[ Line: 34 ]]
    -- upvalues: u3 (ref), l__Common__5 (copy)
    if u3 then
        l__Common__5.MinigameGui.UpdateTeams(u3.ScoreGoal, p8, p9);
    end;
end;
function u1.PlayerAssignedTeam(p10, _) --[[ Line: 39 ]]
    -- upvalues: l__Players__2 (copy)
    if p10 == l__Players__2.LocalPlayer then
    end;
end;
function u1.DoOutOfBoundsFX() --[[ Line: 44 ]]
    -- upvalues: u5 (ref), l__TweenService__3 (copy), l__OutOfBounds__7 (copy), u2 (copy), l__Common__5 (copy)
    l__TweenService__3:Create(l__OutOfBounds__7, u2, {
        Saturation = u5 and -1 or 0
    }):Play();
    l__Common__5.MinigameGui.SetBoundsText(u5);
end;
function u1.RunLoop() --[[ Line: 53 ]]
    -- upvalues: l__LocalPlayer__6 (copy), u5 (ref), u6 (ref), u1 (copy), l__KillMe__4 (copy)
    local v11 = l__LocalPlayer__6:GetAttribute("MG_Team");
    if v11 then
        local v12 = workspace:FindFirstChild("FOB" .. (v11 == "Red" and "Blue" or "Red"));
        if v12 then
            local l__Character__8 = l__LocalPlayer__6.Character;
            if l__Character__8 then
                local l__PrimaryPart__9 = l__Character__8.PrimaryPart;
                if l__PrimaryPart__9 then
                    local l__Magnitude__10 = (l__PrimaryPart__9.Position - v12.Ground.Position).Magnitude;
                    local v13 = l__Character__8.Humanoid.Health > 0;
                    if l__Magnitude__10 <= 500 and (not u5 and v13) then
                        u5 = true;
                        u6 = os.time();
                        u1.DoOutOfBoundsFX();
                    elseif l__Magnitude__10 <= 500 and (u5 and os.time() - u6 == 10) then
                        u5 = false;
                        u6 = nil;
                        l__KillMe__4:FireServer();
                        u1.DoOutOfBoundsFX();
                    else
                        if l__Magnitude__10 > 500 and (u5 and v13) then
                            u5 = false;
                            u6 = nil;
                            u1.DoOutOfBoundsFX();
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function u1.Cleanup() --[[ Line: 90 ]]
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;
return u1;