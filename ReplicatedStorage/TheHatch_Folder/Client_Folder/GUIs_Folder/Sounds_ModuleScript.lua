-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.Sounds
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__SoundService__1 = game:GetService("SoundService");
local u1 = {
    hover = "rbxassetid://113689360542235",
    click = "rbxassetid://121599382015752",
    close = "rbxassetid://117813861539182",
    eggCompletion = "rbxassetid://76792378839432",
    eggButton = "rbxassetid://97905145002343",
    eggPlusOne = "rbxassetid://83497033244211",
    claim = "rbxassetid://102265987478332",
    notification = "rbxassetid://82852698917139"
};
local u2 = {};
return {
    assets = u1,
    configure = function(p3, p4) --[[ Name: configure, Line 53 ]]
        -- upvalues: u2 (copy), u1 (copy), l__SoundService__1 (copy)
        if not next(u2) then
            for _, v5 in u1 do
                if not u2[v5] then
                    local v6 = Instance.new("Sound");
                    v6.Name = v5;
                    v6.SoundId = v5;
                    v6.Parent = l__SoundService__1;
                    u2[v5] = v6;
                end;
                local _ = u2[v5];
            end;
        end;
        if not u2[p3] then
            local v7 = Instance.new("Sound");
            v7.Name = p3;
            v7.SoundId = p3;
            v7.Parent = l__SoundService__1;
            u2[p3] = v7;
        end;
        local v8 = u2[p3];
        v8.PlaybackSpeed = p4.speed or v8.PlaybackSpeed;
        v8.Volume = p4.volume or v8.Volume;
        return v8;
    end,
    play = function(p9) --[[ Name: play, Line 37 ]]
        -- upvalues: u2 (copy), u1 (copy), l__SoundService__1 (copy)
        if not next(u2) then
            for _, v10 in u1 do
                if not u2[v10] then
                    local v11 = Instance.new("Sound");
                    v11.Name = v10;
                    v11.SoundId = v10;
                    v11.Parent = l__SoundService__1;
                    u2[v10] = v11;
                end;
                local _ = u2[v10];
            end;
        end;
        if not u2[p9] then
            local v12 = Instance.new("Sound");
            v12.Name = p9;
            v12.SoundId = p9;
            v12.Parent = l__SoundService__1;
            u2[p9] = v12;
        end;
        u2[p9]:Play();
    end,
    playStoppable = function(p13) --[[ Name: playStoppable, Line 43 ]]
        -- upvalues: u2 (copy), u1 (copy), l__SoundService__1 (copy)
        if not next(u2) then
            for _, v14 in u1 do
                if not u2[v14] then
                    local v15 = Instance.new("Sound");
                    v15.Name = v14;
                    v15.SoundId = v14;
                    v15.Parent = l__SoundService__1;
                    u2[v14] = v15;
                end;
                local _ = u2[v14];
            end;
        end;
        if not u2[p13] then
            local v16 = Instance.new("Sound");
            v16.Name = p13;
            v16.SoundId = p13;
            v16.Parent = l__SoundService__1;
            u2[p13] = v16;
        end;
        u2[p13]:Play();
    end,
    stop = function(p17) --[[ Name: stop, Line 48 ]]
        -- upvalues: u2 (copy), u1 (copy), l__SoundService__1 (copy)
        if not next(u2) then
            for _, v18 in u1 do
                if not u2[v18] then
                    local v19 = Instance.new("Sound");
                    v19.Name = v18;
                    v19.SoundId = v18;
                    v19.Parent = l__SoundService__1;
                    u2[v18] = v19;
                end;
                local _ = u2[v18];
            end;
        end;
        if not u2[p17] then
            local v20 = Instance.new("Sound");
            v20.Name = p17;
            v20.SoundId = p17;
            v20.Parent = l__SoundService__1;
            u2[p17] = v20;
        end;
        u2[p17]:Stop();
    end
};