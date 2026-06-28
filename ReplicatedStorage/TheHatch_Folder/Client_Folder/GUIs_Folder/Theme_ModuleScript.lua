-- Roblox: ReplicatedStorage._TheHatch.Client.GUIs.Theme
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

return {
    rarities = {
        [0] = Color3.fromHex("#BAADA8"),
        [1] = Color3.fromHex("#9AC277"),
        [2] = Color3.fromHex("#7CB3CF"),
        [3] = Color3.fromHex("#E9AF57")
    },
    categories = {
        {
            name = "Connection",
            icon = "rbxassetid://129338587419433",
            color = Color3.fromHex("#E07172")
        },
        {
            name = "Light",
            icon = "rbxassetid://116200307911981",
            color = Color3.fromHex("#E9AF57")
        },
        {
            name = "Darkness",
            icon = "rbxassetid://106012263033850",
            color = Color3.fromHex("#707D9D")
        },
        {
            name = "Fire",
            icon = "rbxassetid://127041071044381",
            color = Color3.fromHex("#D7604B")
        },
        {
            name = "Earth",
            icon = "rbxassetid://137479569291069",
            color = Color3.fromHex("#8AB465")
        },
        {
            name = "Water",
            icon = "rbxassetid://77383960205620",
            color = Color3.fromHex("#6CA9C8")
        },
        {
            name = "Energy",
            icon = "rbxassetid://105429920303358",
            color = Color3.fromHex("#7CBFCF")
        },
        {
            name = "Time",
            icon = "rbxassetid://99448278816431",
            color = Color3.fromHex("#CDA085")
        },
        {
            name = "Ice",
            icon = "rbxassetid://117346785021495",
            color = Color3.fromHex("#93B6B8")
        },
        {
            name = "Air",
            icon = "rbxassetid://115034420912779",
            color = Color3.fromHex("#87AD94")
        }
    },
    colors = {
        lightGreen = Color3.fromHex("#9AD8AC")
    },
    darken = function(p1, p2) --[[ Name: darken, Line 74 ]]
        return Color3.new(p1.R * (1 - p2), p1.G * (1 - p2), p1.B * (1 - p2));
    end,
    lighten = function(p3, p4) --[[ Name: lighten, Line 78 ]]
        return Color3.new(math.lerp(p3.R, 1, p4), math.lerp(p3.G, 1, p4), (math.lerp(p3.B, 1, p4)));
    end,
    plusDarker = function(p5, p6) --[[ Name: plusDarker, Line 86 ]]
        return Color3.new(math.max(p5.R - p6, 0), math.max(p5.G - p6, 0), (math.max(p5.B - p6, 0)));
    end,
    plusLighter = function(p7, p8) --[[ Name: plusLighter, Line 94 ]]
        return Color3.new(math.min(p7.R + p8, 1), math.min(p7.G + p8, 1), (math.min(p7.B + p8, 1)));
    end,
    desaturate = function(p9, p10) --[[ Name: desaturate, Line 102 ]]
        local v11, v12, v13 = p9:ToHSV();
        return Color3.fromHSV(v11, v12 * (1 - p10), v13);
    end,
    saturate = function(p14, p15) --[[ Name: saturate, Line 107 ]]
        local v16, v17, v18 = p14:ToHSV();
        return Color3.fromHSV(v16, math.lerp(v17, 1, p15), v18);
    end
};