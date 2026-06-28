-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.Tween
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3, p4, p5, p6) --[[ Line: 4 ]]
    local v7 = p5 or Enum.EasingStyle.Quad;
    local v8 = p6 or Enum.EasingDirection.Out;
    local v9 = type(p3) == "table";
    local v10 = {};
    local v11 = p4 or 0.5;
    for v12, v13 in pairs(p2) do
        local v14;
        if v9 then
            v14 = p3[v12] or p3;
        else
            v14 = p3;
        end;
        v10[v13] = v14;
    end;
    local v15 = TweenInfo.new(v11, v7, v8);
    local v16 = game:GetService("TweenService"):Create(p1, v15, v10);
    v16:Play();
    return v16;
end;