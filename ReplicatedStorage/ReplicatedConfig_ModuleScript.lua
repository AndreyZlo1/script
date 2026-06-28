-- Roblox: ReplicatedStorage.ReplicatedConfig
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local l__RunService__1 = game:GetService("RunService");
local l__GetServerOwner__2 = game:GetService("ReplicatedStorage"):WaitForChild("PlayerEvents"):WaitForChild("GetServerOwner");
v1.IsTutorialEnabled = true;
v1.ModeIds = {
    Deathmatch = {
        Prod = 15887744763,
        Beta = 15815075437
    },
    Tycoon = {
        Prod = 31490825,
        Beta = 14887444129
    },
    GroundWar = {
        Prod = 18769917761,
        Beta = 18769876138
    }
};
v1.IsStudio = l__RunService__1:IsStudio();
v1.MaxSquadSize = 4;
v1.MaxImbalancedPlayers = 2;
v1.Mode = "Tycoon";
for v2, v3 in pairs(v1.ModeIds) do
    for v4, v5 in v3 do
        if game.PlaceId == v5 then
            v1.Mode = v2;
            v1.IsProd = v4 == "Prod";
            break;
        end;
    end;
end;
if game.PrivateServerOwnerId == 3260546579 or workspace:GetAttribute("IsTournament") then
    v1.IsKhlsServ = true;
elseif l__RunService__1:IsClient() and l__GetServerOwner__2:InvokeServer() == true then
    v1.IsKhlsServ = true;
end;
local _ = v1.IsStudio;
v1.OnboardingSteps = {
    "Tutorial started",
    "Built first oil rig",
    "Collected first money",
    "Built loadout station",
    "Wall 1/4",
    "Wall 2/4",
    "Wall 3/4",
    "Wall 4/4"
};
v1.RepairTorchAmount = 75;
v1.StudioPopType = 0;
v1.AttachmentsDebug = {
    ShortLevels = false,
    EverythingUnlocked = false
};
v1.FeatureToggles = {
    AttachmentsEnabled = true,
    CamosEnabled = false,
    DeathDropsEnabled = true,
    AirdropsEnabled = true,
    SlidingEnabled = true,
    WeaponVisualisation = true
};
v1.DailySpinRewards = {
    {
        Type = "Gamepass",
        Value = 177694027,
        Chance = 0.5,
        Image = "rbxassetid://17216490645"
    },
    {
        Type = "EventWeapon",
        Value = "Intervention",
        Chance = 2,
        Image = "rbxassetid://18245976406",
        Color = "Purple"
    },
    {
        Type = "DoubleMoney",
        Value = 60,
        Chance = 8,
        Image = "rbxassetid://17224532957",
        Color = "Blue"
    },
    {
        Type = "DoubleMoney",
        Value = 15,
        Chance = 34,
        Image = "rbxassetid://17224532957",
        Color = "Green"
    },
    {
        Type = "DoubleXP",
        Value = 15,
        Chance = 39,
        Image = "rbxassetid://17224565797",
        Color = "Green"
    },
    {
        Type = "DoubleXP",
        Value = 60,
        Chance = 12.5,
        Image = "rbxassetid://17224565797",
        Color = "Blue"
    },
    {
        Type = "Money",
        Value = 1000000,
        Chance = 2.5,
        Image = "rbxassetid://17216499501",
        Color = "Purple"
    },
    {
        Type = "Gamepass",
        Value = 15468952,
        Chance = 1.5,
        Image = "rbxassetid://17216505240"
    }
};
return v1;