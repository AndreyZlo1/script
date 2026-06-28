-- Roblox: Workspace.SilverAce293026.VehicleDrive4.Util
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local u1 = {
    Constants = {}
};
u1.Constants.HOUR_SECONDS = 3600;
u1.Constants.STUDS_PER_MILE = 5280;
function u1.Lerp(p2, p3, p4) --[[ Line: 9 ]]
    return p2 * (1 - p4) + p3 * p4;
end;
function u1.StudsToMiles(p5) --[[ Line: 13 ]]
    -- upvalues: u1 (copy)
    return p5 / u1.Constants.STUDS_PER_MILE;
end;
function u1.MilesToStuds(p6) --[[ Line: 17 ]]
    -- upvalues: u1 (copy)
    return p6 * u1.Constants.STUDS_PER_MILE;
end;
function u1.StudsPerSecToMph(p7) --[[ Line: 21 ]]
    -- upvalues: u1 (copy)
    return u1.StudsToMiles(p7) * u1.Constants.HOUR_SECONDS;
end;
function u1.MphToStudsPerSec(p8) --[[ Line: 27 ]]
    -- upvalues: u1 (copy)
    return u1.MilesToStuds(p8) / u1.Constants.HOUR_SECONDS;
end;
local u9 = { "X", "Y", "Z" };
function u1.GetForwardSpeed(p10) --[[ Line: 39 ]]
    -- upvalues: u9 (copy), u1 (copy)
    local l__MassPart__1 = p10.Required.MassPart;
    local v11 = l__MassPart__1.CFrame:VectorToObjectSpace(l__MassPart__1.AssemblyLinearVelocity) * (p10:GetAttribute("ForwardSpeedVectorMult") or Vector3.new(-1, 0, 0));
    local v12 = 0;
    for _, v13 in u9 do
        v12 = v12 + v11[v13];
    end;
    return u1.StudsPerSecToMph(v12);
end;
function u1.EditMotors(p14, p15) --[[ Line: 54 ]]
    for _, v16 in p14 do
        for v17, v18 in p15 do
            v16[v17] = v18;
        end;
    end;
end;
function u1.EditRacks(p19, p20) --[[ Line: 62 ]]
    for _, v21 in p19 do
        for v22, v23 in p20 do
            v21[v22] = v23;
        end;
    end;
end;
function u1.GetMotors(p24) --[[ Line: 71 ]]
    local v25 = {
        Left = {},
        Right = {}
    };
    for _, v26 in p24.Motor:GetChildren() do
        v25[v26.Attachment0.Parent.Parent.Name][v26.Attachment1.Parent.Name] = v26;
    end;
    return v25;
end;
function u1.GetRacks(p27) --[[ Line: 84 ]]
    return p27.Steering:GetChildren();
end;
function u1.GetWheels(p28) --[[ Line: 89 ]]
    local v29 = {
        Left = {},
        Right = {}
    };
    for _, v30 in p28.Wheels:GetChildren() do
        for _, v31 in v30:GetChildren() do
            if v31:IsA("BasePart") then
                v29[v30.Name][v31.Name] = v31;
            end;
        end;
    end;
    return v29;
end;
local u32 = {
    VehicleSeat = "Wheels",
    ApcSeat = "Wheels",
    TankSeat = "Tracks"
};
function u1.GetLocomotionType(p33) --[[ Line: 108 ]]
    -- upvalues: u32 (copy)
    if u32[p33.Name] then
        return u32[p33.Name];
    else
        return nil;
    end;
end;
return u1;