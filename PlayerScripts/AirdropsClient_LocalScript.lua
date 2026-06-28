-- Roblox: Players.SilverAce293026.PlayerScripts.AirdropsClient
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

game:GetService("TweenService");
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__RunService__2 = game:GetService("RunService");
local l__StarterGui__3 = game:GetService("StarterGui");
local l__C130__4 = l__ReplicatedStorage__1:WaitForChild("Airdrops"):WaitForChild("C130");
if require(l__ReplicatedStorage__1:WaitForChild("ReplicatedConfig")).FeatureToggles.AirdropsEnabled then
    workspace:WaitForChild("Airdrops");
    local l__PlayerEvents__5 = l__ReplicatedStorage__1:WaitForChild("PlayerEvents");
    ({
        newAircraft = l__PlayerEvents__5:WaitForChild("NewAirdropAircraft"),
        newAirdrop = l__PlayerEvents__5:WaitForChild("NewAirdrop")
    }).newAircraft.OnClientEvent:Connect(function(p1) --[[ Name: createAircraft, Line 26 ]]
        -- upvalues: l__C130__4 (copy), l__RunService__2 (copy), l__StarterGui__3 (copy)
        local v2 = workspace:GetServerTimeNow();
        local l__deletionTime__6 = p1.deletionTime;
        if l__deletionTime__6 <= v2 then
            warn("Tried to create an expired aircraft");
        else
            local u3 = p1.deletionTime - p1.creationTime - 4;
            local v4 = (v2 - p1.creationTime) / u3 * (p1.halfDist * 2);
            local u5 = l__C130__4:Clone();
            u5.Parent = workspace;
            local u6 = p1.startCFrame * CFrame.new(0, 0, v4) * CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.Angles(4.71238898038469, 0, 0);
            u5.Body.CFrame = u6;
            u5.Prop.Engine:Play();
            local u7 = CFrame.new(p1.goalPosition, p1.goalDirectionPoint) * CFrame.new(0, 350, -p1.halfDist) * CFrame.Angles(0, -1.5707963267948966, 0);
            local u8 = 0;
            local u10 = l__RunService__2.RenderStepped:Connect(function(p9) --[[ Line: 54 ]]
                -- upvalues: u8 (ref), u5 (copy), u3 (copy), u6 (ref), u7 (ref)
                u8 = u8 + p9;
                if u5 then
                    u5.PrimaryPart.CFrame = u6:Lerp(u7, u8 / u3);
                end;
            end);
            task.delay(l__deletionTime__6 - v2, function() --[[ Line: 61 ]]
                -- upvalues: u10 (ref), u5 (copy)
                u10:Disconnect();
                u10 = nil;
                u5:Destroy();
            end);
            l__StarterGui__3:SetCore("SendNotification", {
                Title = "Airdrop inbound",
                Text = "Wait for the plane to drop it and go claim the valuables inside!",
                Duration = 8
            });
        end;
    end);
end;