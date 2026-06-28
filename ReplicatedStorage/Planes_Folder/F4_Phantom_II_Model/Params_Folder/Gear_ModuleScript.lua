-- Roblox: ReplicatedStorage.Planes.F4 Phantom II.Params.Gear
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local v2 = {};
local v3 = {};
local v4 = {};
local v5 = math.rad(-90);
local v6 = math.rad(180);
local v7 = math.rad(0);
v4.OrientCF = CFrame.new(1.319, -2.641, 0.048) * CFrame.Angles(v5, v6, v7);
v4.MountCF = CFrame.new(-0.11, -3.733, 27.961);
v3.Down = v4;
local v8 = {};
local v9 = math.rad(-3.514);
local v10 = math.rad(-180);
local v11 = math.rad(0);
v8.OrientCF = CFrame.new(1.319, -2.641, 0.048) * CFrame.Angles(v9, v10, v11);
v8.MountCF = CFrame.new(-0.11, 3, 18.961);
v3.Up = v8;
v2.Wheel1 = v3;
v1.Front = v2;
local v12 = {};
local v13 = {};
local v14 = {};
local v15 = math.rad(-0.225);
local v16 = math.rad(151.996);
local v17 = math.rad(0.02);
v14.OrientCF = CFrame.new(8.8, -3.119, 18.392) * CFrame.Angles(v15, v16, v17);
v14.MountCF = CFrame.new(5.936, 0.5, -3.134);
v13.Up = v14;
local v18 = {};
local v19 = math.rad(28.003);
local v20 = math.rad(179.745);
local v21 = math.rad(89.9);
v18.OrientCF = CFrame.new(8.8, -3.119, 18.392) * CFrame.Angles(v19, v20, v21);
v18.MountCF = CFrame.new(10.936, -4.129, -3.134);
v13.Down = v18;
v12.Wheel1 = v13;
local v22 = {};
local v23 = {};
local v24 = math.rad(0.225);
local v25 = math.rad(-151.997);
local v26 = math.rad(-179.981);
v23.OrientCF = CFrame.new(8.8, -3.119, 18.392) * CFrame.Angles(v24, v25, v26);
v23.MountCF = CFrame.new(-5.066, 0.5, -3.134);
v22.Up = v23;
local v27 = {};
local v28 = math.rad(28.003);
local v29 = math.rad(179.745);
local v30 = math.rad(89.9);
v27.OrientCF = CFrame.new(8.8, -3.119, 18.392) * CFrame.Angles(v28, v29, v30);
v27.MountCF = CFrame.new(-11.066, -4.129, -3.134);
v22.Down = v27;
v12.Wheel2 = v22;
v1.Back = v12;
return v1;