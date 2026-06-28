-- Roblox: Workspace.SilverAce293026.TankTreadsUpdater2
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__CollectionService__1 = game:GetService("CollectionService");
local l__RunService__2 = game:GetService("RunService");
local u1 = l__CollectionService__1:GetTagged("TankTread");
l__CollectionService__1:GetInstanceAddedSignal("Tagged"):Connect(function(p2) --[[ Line: 6 ]]
    -- upvalues: u1 (ref)
    table.insert(u1, p2);
end);
l__CollectionService__1:GetInstanceRemovedSignal("Tagged"):Connect(function(p3) --[[ Line: 10 ]]
    -- upvalues: u1 (ref)
    for v4 = 1, #u1 do
        if u1[v4] == p3 then
            table.remove(u1, v4);
            return;
        end;
    end;
end);
l__RunService__2.RenderStepped:Connect(function(_) --[[ Line: 19 ]]
    -- upvalues: u1 (ref)
    if u1 and #u1 > 0 then
        local function v9(p5) --[[ Line: 21 ]]
            if p5 and p5.Parent then
                local l__Parent__3 = p5.Parent;
                if l__Parent__3.Parent then
                    local l__Parent__4 = l__Parent__3.Parent;
                    if l__Parent__4.Parent then
                        local _ = l__Parent__4.Parent;
                        local l__Parent__5 = p5.Parent.Parent.Parent;
                        if l__Parent__5 then
                            local v6 = p5:GetAttribute("WheelName") or p5.Name;
                            local v7 = l__Parent__5:FindFirstChild(v6);
                            if v7 then
                                local v8 = v7:FindFirstChild(v6 .. "BoneAtt");
                                if v8 then
                                    local l__CFrame__6 = v7.Parent:FindFirstChild(v6 .. "Mount").CFrame;
                                    p5.WorldPosition = ((l__CFrame__6 + (v7.CFrame.Position - l__CFrame__6.Position)) * CFrame.new(v8.Position)).Position;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        for _, v10 in ipairs(u1) do
            for _, v11 in ipairs(v10:GetChildren()) do
                v9(v11);
            end;
        end;
    end;
end);
while true do
    task.wait(5);
    u1 = l__CollectionService__1:GetTagged("TankTread");
end;