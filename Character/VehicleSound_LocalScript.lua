-- Roblox: Workspace.SilverAce293026.VehicleSound
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__RunService__2 = game:GetService("RunService");
local l__Character__3 = l__LocalPlayer__1.Character;
if not (l__Character__3 and l__Character__3.Parent) then
    l__Character__3 = l__LocalPlayer__1.CharacterAdded:Wait();
end;
local function u4() --[[ Line: 8 ]]
    -- upvalues: l__Character__3 (ref)
    for _, v1 in pairs(game.Workspace:GetChildren()) do
        if string.split(v1.Name, "n")[1] == "Tycoo" then
            for _, v2 in pairs(v1.SpawnedVehicles:GetChildren()) do
                if v2.Required:FindFirstChild("VehicleSeat") then
                    local v3 = v2.Required.VehicleSeat:FindFirstChild("Engine");
                    if v3 then
                        if v2.Required.VehicleSeat.Occupant then
                            if v2.Required.VehicleSeat.Occupant.Parent == l__Character__3 then
                                v3.PlaybackSpeed = math.abs(v2.Wheels.Right.Transmission.Wheel1Trans.HingeConstraint.AngularVelocity) / 80 + 0.6;
                                if not v3.Playing then
                                    v3:Play();
                                end;
                            else
                                v3.PlaybackSpeed = v2.Required.VehicleSeat.AssemblyLinearVelocity.Magnitude / 80 + 0.6;
                                if not v3.Playing then
                                    v3:Play();
                                end;
                            end;
                        else
                            v3.PlaybackSpeed = v2.Required.VehicleSeat.AssemblyLinearVelocity.Magnitude / 80 + 0.6;
                            if not v3.Playing then
                                v3:Play();
                            end;
                        end;
                    end;
                elseif v2.Required:FindFirstChild("TankSeat") and v2.Required.VehicleSeat:FindFirstChild("Engine") then
                    local _ = v2.Required.TankSeat.Engine;
                    local l__Tracks__4 = v2.Required.TankSeat.Tracks;
                    local l__Volume__5 = l__Tracks__4.Volume;
                    if v2.Required.TankSeat.Occupant then
                        if v2.Required.TankSeat.Occupant.Parent == l__Character__3 then
                            local l__AngularVelocity__6 = v2.Wheels.Right.Transmission.BackGearTrans.HingeConstraint.AngularVelocity;
                            l__Tracks__4.PlaybackSpeed = l__AngularVelocity__6 / 150 + 0.5;
                            l__Tracks__4.Volume = math.min(25, l__AngularVelocity__6) / 25 * l__Volume__5;
                            if l__AngularVelocity__6 >= 7 and not l__Tracks__4.Playing then
                                l__Tracks__4:Play();
                            elseif l__AngularVelocity__6 < 7 and l__Tracks__4.Playing then
                                l__Tracks__4:Stop();
                            end;
                        else
                            local l__Magnitude__7 = v2.Required.TankSeat.AssemblyLinearVelocity.Magnitude;
                            l__Tracks__4.PlaybackSpeed = l__Magnitude__7 / 150 + 0.5;
                            l__Tracks__4.Volume = math.min(25, l__Magnitude__7) / 25 * l__Volume__5;
                            if l__Magnitude__7 >= 7 and not l__Tracks__4.Playing then
                                l__Tracks__4:Play();
                            elseif l__Magnitude__7 < 7 and l__Tracks__4.Playing then
                                l__Tracks__4:Stop();
                            end;
                        end;
                    else
                        local l__Magnitude__8 = v2.Required.TankSeat.AssemblyLinearVelocity.Magnitude;
                        l__Tracks__4.PlaybackSpeed = l__Magnitude__8 / 150 + 0.5;
                        l__Tracks__4.Volume = math.min(25, l__Magnitude__8) / 25 * l__Volume__5;
                        if l__Magnitude__8 >= 7 and not l__Tracks__4.Playing then
                            l__Tracks__4:Play();
                        elseif l__Magnitude__8 < 7 and l__Tracks__4.Playing then
                            l__Tracks__4:Stop();
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
l__RunService__2.RenderStepped:Connect(function() --[[ Line: 92 ]]
    -- upvalues: u4 (copy)
    u4();
end);