-- Roblox: ReplicatedStorage.Planes.F14 Tomcat.Params.Gear
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {};
local v3 = {};
local v4 = {};
local v5 = math.rad(0);
local v6 = math.rad(0);
local v7 = math.rad(0);
v4.OrientCF = CFrame.new(0, 0, 0) * CFrame.Angles(v5, v6, v7);
v4.MountCF = CFrame.new(0.034, -4.715, 22.314);
v3.Down = v4;
local v8 = {};
local v9 = math.rad(-90);
local v10 = math.rad(-0);
local v11 = math.rad(0);
v8.OrientCF = CFrame.new(0, 0, 0) * CFrame.Angles(v9, v10, v11);
v8.MountCF = CFrame.new(0.034, 1, 23);
v3.Up = v8;
v2.Wheel1 = v3;
v1.Front = v2;
local v12 = {};
local v13 = {};
local v14 = {};
local v15 = math.rad(90);
local v16 = math.rad(-0);
local v17 = math.rad(0);
v14.OrientCF = CFrame.new(0, 0, 0) * CFrame.Angles(v15, v16, v17);
v14.MountCF = CFrame.new(7.276, 4, 0.267);
v13.Up = v14;
local v18 = {};
local v19 = math.rad(0);
local v20 = math.rad(0);
local v21 = math.rad(0);
v18.OrientCF = CFrame.new(0, 0, 0) * CFrame.Angles(v19, v20, v21);
v18.MountCF = CFrame.new(11.276, -2.631, -9.267);
v13.Down = v18;
v12.Wheel1 = v13;
local v22 = {};
local v23 = {};
local v24 = math.rad(90);
local v25 = math.rad(-0);
local v26 = math.rad(0);
v23.OrientCF = CFrame.new(0, 0, 0) * CFrame.Angles(v24, v25, v26);
v23.MountCF = CFrame.new(-7.276, 4, 0.267);
v22.Up = v23;
local v27 = {};
local v28 = math.rad(0);
local v29 = math.rad(0);
local v30 = math.rad(0);
v27.OrientCF = CFrame.new(0, 0, 0) * CFrame.Angles(v28, v29, v30);
v27.MountCF = CFrame.new(-11.232, -2.631, -9.267);
v22.Down = v27;
v12.Wheel2 = v22;
v1.Back = v12;
return v1;