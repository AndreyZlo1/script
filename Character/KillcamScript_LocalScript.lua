-- Roblox: Workspace.SilverAce293026.KillcamScript
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__Lighting__3 = game:GetService("Lighting");
local l__Debris__4 = game:GetService("Debris");
local l__Modules__5 = l__ReplicatedStorage__2:WaitForChild("Modules");
local l__VehicleModule__6 = require(l__Modules__5:WaitForChild("VehicleModule"));
local l__TaggingModule__7 = require(l__Modules__5:WaitForChild("TaggingModule"));
local l__LocalPlayer__8 = l__Players__1.LocalPlayer;
local l__Humanoid__9 = (l__LocalPlayer__8.Character or l__LocalPlayer__8.CharacterAdded:Wait()):WaitForChild("Humanoid");
local l__KillcamGui__10 = l__LocalPlayer__8.PlayerGui:WaitForChild("KillcamGui");
local l__KillcamModule__11 = require(l__KillcamGui__10:WaitForChild("KillcamModule"));
local l__KillcamDoF__12 = script:WaitForChild("KillcamDoF");
l__Humanoid__9.Died:Connect(function() --[[ Line: 21 ]]
    -- upvalues: l__TaggingModule__7 (copy), l__Humanoid__9 (copy), l__KillcamModule__11 (copy), l__VehicleModule__6 (copy), l__Debris__4 (copy), l__KillcamDoF__12 (copy), l__Players__1 (copy), l__LocalPlayer__8 (copy), l__Lighting__3 (copy)
    local v1 = l__TaggingModule__7.GetKillDetails(l__Humanoid__9.Parent);
    if v1 then
        l__KillcamModule__11.display(v1.Player.DisplayName, v1.WeaponName, v1.Distance);
        local l__Character__13 = v1.Player.Character;
        local v2;
        if l__Character__13 then
            v2 = l__Character__13:FindFirstChild("Head");
        else
            v2 = l__Character__13;
        end;
        if v2 then
            local v3 = l__Character__13:FindFirstChild("Humanoid");
            if v3 then
                v3 = l__Character__13.Humanoid.SeatPart;
            end;
            local v4 = l__VehicleModule__6.checkAndVehicleFromAnySeat(v3);
            if v4 then
                v2 = v4.PrimaryPart;
            end;
            l__Debris__4:AddItem(l__KillcamDoF__12, l__Players__1.RespawnTime);
            task.wait(l__KillcamModule__11.InitialDelay);
            workspace.CurrentCamera.CameraSubject = v2;
            l__LocalPlayer__8.CameraMaxZoomDistance = 15;
            l__LocalPlayer__8.CameraMinZoomDistance = 15;
            l__KillcamDoF__12.Parent = l__Lighting__3;
        end;
    end;
end);