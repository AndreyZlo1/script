-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = "rbxasset://textures/ui/traildot.png";
local u3 = "rbxasset://textures/ui/waypoint.png";
local u4 = false;
local u5 = UDim2.new(0, 42, 0, 50);
local u6 = Vector2.new(0, 0.5);
local u7 = Vector2.new(0, 1);
local u8 = Vector2.new(0, 0.5);
local u9 = Vector2.new(0.1, 0.5);
local u10 = Vector2.new(-0.1, 0.5);
local u11 = Vector2.new(1.5, 1.5);
local l__Players__1 = game:GetService("Players");
local l__TweenService__2 = game:GetService("TweenService");
local l__RunService__3 = game:GetService("RunService");
local l__Workspace__4 = game:GetService("Workspace");
local l__LocalPlayer__5 = l__Players__1.LocalPlayer;
local function u23() --[[ Line: 44 ]]
    -- upvalues: u11 (ref), u4 (ref), u2 (ref), u5 (copy), u6 (copy), u3 (ref), u8 (copy)
    local v12 = Instance.new("Part");
    v12.Size = Vector3.new(1, 1, 1);
    v12.Anchored = true;
    v12.CanCollide = false;
    v12.Name = "TrailDot";
    v12.Transparency = 1;
    local v13 = Instance.new("ImageHandleAdornment");
    v13.Name = "TrailDotImage";
    v13.Size = u11;
    v13.SizeRelativeOffset = Vector3.new(0, 0, -0.1);
    v13.AlwaysOnTop = u4;
    v13.Image = u2;
    v13.Adornee = v12;
    v13.Parent = v12;
    local v14 = Instance.new("Part");
    v14.Size = Vector3.new(2, 2, 2);
    v14.Anchored = true;
    v14.CanCollide = false;
    v14.Name = "EndWaypoint";
    v14.Transparency = 1;
    local v15 = Instance.new("ImageHandleAdornment");
    v15.Name = "TrailDotImage";
    v15.Size = u11;
    v15.SizeRelativeOffset = Vector3.new(0, 0, -0.1);
    v15.AlwaysOnTop = u4;
    v15.Image = u2;
    v15.Adornee = v14;
    v15.Parent = v14;
    local v16 = Instance.new("BillboardGui");
    v16.Name = "EndWaypointBillboard";
    v16.Size = u5;
    v16.LightInfluence = 0;
    v16.SizeOffset = u6;
    v16.AlwaysOnTop = true;
    v16.Adornee = v14;
    v16.Parent = v14;
    local v17 = Instance.new("ImageLabel");
    v17.Image = u3;
    v17.BackgroundTransparency = 1;
    v17.Size = UDim2.new(1, 0, 1, 0);
    v17.Parent = v16;
    local v18 = Instance.new("Part");
    v18.Size = Vector3.new(2, 2, 2);
    v18.Anchored = true;
    v18.CanCollide = false;
    v18.Name = "FailureWaypoint";
    v18.Transparency = 1;
    local v19 = Instance.new("ImageHandleAdornment");
    v19.Name = "TrailDotImage";
    v19.Size = u11;
    v19.SizeRelativeOffset = Vector3.new(0, 0, -0.1);
    v19.AlwaysOnTop = u4;
    v19.Image = u2;
    v19.Adornee = v18;
    v19.Parent = v18;
    local v20 = Instance.new("BillboardGui");
    v20.Name = "FailureWaypointBillboard";
    v20.Size = u5;
    v20.LightInfluence = 0;
    v20.SizeOffset = u8;
    v20.AlwaysOnTop = true;
    v20.Adornee = v18;
    v20.Parent = v18;
    local v21 = Instance.new("Frame");
    v21.BackgroundTransparency = 1;
    v21.Size = UDim2.new(0, 0, 0, 0);
    v21.Position = UDim2.new(0.5, 0, 1, 0);
    v21.Parent = v20;
    local v22 = Instance.new("ImageLabel");
    v22.Image = u3;
    v22.BackgroundTransparency = 1;
    v22.Position = UDim2.new(0, -u5.X.Offset / 2, 0, -u5.Y.Offset);
    v22.Size = u5;
    v22.Parent = v21;
    return v12, v14, v18;
end;
local u24, u25, u26 = u23();
local function u33(p27, p28) --[[ Line: 141 ]]
    -- upvalues: l__Workspace__4 (copy), l__LocalPlayer__5 (copy)
    local v29, v30, v31 = l__Workspace__4:FindPartOnRayWithIgnoreList(Ray.new(p28 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)), { l__Workspace__4.CurrentCamera, l__LocalPlayer__5.Character });
    if v29 then
        p27.CFrame = CFrame.new(v30, v30 + v31);
        local l__CurrentCamera__6 = l__Workspace__4.CurrentCamera;
        local v32 = l__CurrentCamera__6:FindFirstChild("ClickToMoveDisplay");
        if not v32 then
            v32 = Instance.new("Model");
            v32.Name = "ClickToMoveDisplay";
            v32.Parent = l__CurrentCamera__6;
        end;
        p27.Parent = v32;
    end;
end;
local u34 = {};
u34.__index = u34;
function u34.Destroy(p35) --[[ Line: 156 ]]
    p35.DisplayModel:Destroy();
end;
function u34.NewDisplayModel(_, p36) --[[ Line: 160 ]]
    -- upvalues: u24 (ref), u33 (copy)
    local v37 = u24:Clone();
    u33(v37, p36);
    return v37;
end;
function u34.new(p38, p39) --[[ Line: 166 ]]
    -- upvalues: u34 (copy)
    local v40 = setmetatable({}, u34);
    v40.DisplayModel = v40:NewDisplayModel(p38);
    v40.ClosestWayPoint = p39;
    return v40;
end;
local u41 = {};
u41.__index = u41;
function u41.Destroy(p42) --[[ Line: 178 ]]
    p42.Destroyed = true;
    p42.Tween:Cancel();
    p42.DisplayModel:Destroy();
end;
function u41.NewDisplayModel(_, p43) --[[ Line: 184 ]]
    -- upvalues: u25 (ref), u33 (copy)
    local v44 = u25:Clone();
    u33(v44, p43);
    return v44;
end;
function u41.CreateTween(p45) --[[ Line: 190 ]]
    -- upvalues: l__TweenService__2 (copy), u7 (copy)
    local v46 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true);
    local v47 = l__TweenService__2:Create(p45.DisplayModel.EndWaypointBillboard, v46, {
        SizeOffset = u7
    });
    v47:Play();
    return v47;
end;
function u41.TweenInFrom(p48, p49) --[[ Line: 201 ]]
    -- upvalues: l__TweenService__2 (copy)
    p48.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, (p49 - p48.DisplayModel.Position).Y, 0);
    local v50 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local v51 = l__TweenService__2:Create(p48.DisplayModel.EndWaypointBillboard, v50, {
        StudsOffset = Vector3.new(0, 0, 0)
    });
    v51:Play();
    return v51;
end;
function u41.new(p52, p53, p54) --[[ Line: 215 ]]
    -- upvalues: u41 (copy)
    local u55 = setmetatable({}, u41);
    u55.DisplayModel = u55:NewDisplayModel(p52);
    u55.Destroyed = false;
    if p54 and (p54 - p52).Magnitude > 5 then
        u55.Tween = u55:TweenInFrom(p54);
        coroutine.wrap(function() --[[ Line: 222 ]]
            -- upvalues: u55 (copy)
            u55.Tween.Completed:Wait();
            if not u55.Destroyed then
                u55.Tween = u55:CreateTween();
            end;
        end)();
    else
        u55.Tween = u55:CreateTween();
    end;
    u55.ClosestWayPoint = p53;
    return u55;
end;
local u56 = {};
u56.__index = u56;
function u56.Hide(p57) --[[ Line: 239 ]]
    p57.DisplayModel.Parent = nil;
end;
function u56.Destroy(p58) --[[ Line: 243 ]]
    p58.DisplayModel:Destroy();
end;
function u56.NewDisplayModel(_, p59) --[[ Line: 247 ]]
    -- upvalues: u26 (ref), u33 (copy), l__Workspace__4 (copy), l__LocalPlayer__5 (copy)
    local v60 = u26:Clone();
    u33(v60, p59);
    local v61, v62, v63 = l__Workspace__4:FindPartOnRayWithIgnoreList(Ray.new(p59 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)), { l__Workspace__4.CurrentCamera, l__LocalPlayer__5.Character });
    if v61 then
        v60.CFrame = CFrame.new(v62, v62 + v63);
        local l__CurrentCamera__7 = l__Workspace__4.CurrentCamera;
        local v64 = l__CurrentCamera__7:FindFirstChild("ClickToMoveDisplay");
        if not v64 then
            v64 = Instance.new("Model");
            v64.Name = "ClickToMoveDisplay";
            v64.Parent = l__CurrentCamera__7;
        end;
        v60.Parent = v64;
    end;
    return v60;
end;
function u56.RunFailureTween(p65) --[[ Line: 261 ]]
    -- upvalues: l__TweenService__2 (copy), u9 (copy), u10 (copy), u8 (copy)
    wait(0.125);
    local v66 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local v67 = l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard, v66, {
        SizeOffset = u9
    });
    v67:Play();
    l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard.Frame, v66, {
        Rotation = 10
    }):Play();
    v67.Completed:wait();
    local v68 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true);
    local v69 = l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard, v68, {
        SizeOffset = u10
    });
    v69:Play();
    local v70 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true);
    l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, v70, {
        ImageColor3 = Color3.new(0.75, 0.75, 0.75)
    }):Play();
    l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard.Frame, v70, {
        Rotation = -10
    }):Play();
    v69.Completed:wait();
    local v71 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local v72 = l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard, v71, {
        SizeOffset = u8
    });
    v72:Play();
    l__TweenService__2:Create(p65.DisplayModel.FailureWaypointBillboard.Frame, v71, {
        Rotation = 0
    }):Play();
    v72.Completed:wait();
    wait(0.125);
end;
function u56.new(p73) --[[ Line: 310 ]]
    -- upvalues: u56 (copy)
    local v74 = setmetatable({}, u56);
    v74.DisplayModel = v74:NewDisplayModel(p73);
    return v74;
end;
local u75 = Instance.new("Animation");
u75.AnimationId = "rbxassetid://2874840706";
local u76 = nil;
local function u88(p77, p78) --[[ Line: 342 ]]
    -- upvalues: u34 (copy), u41 (copy)
    local v79 = {};
    local v80 = 1;
    for v81 = 1, #p77 - 1 do
        local v82 = (p77[v81].Position - p77[#p77].Position).Magnitude < 3;
        local v83;
        if v81 % 2 == 0 then
            v83 = not v82;
        else
            v83 = false;
        end;
        if v83 then
            v79[v80] = u34.new(p77[v81].Position, v81);
            v80 = v80 + 1;
        end;
    end;
    local v84 = u41.new(p77[#p77].Position, #p77, p78);
    table.insert(v79, v84);
    local v85 = {};
    local v86 = 1;
    for v87 = #v79, 1, -1 do
        v85[v86] = v79[v87];
        v86 = v86 + 1;
    end;
    return v85;
end;
local u89 = 0;
function v1.CreatePathDisplay(u90, p91) --[[ Line: 376 ]]
    -- upvalues: u89 (ref), u88 (copy), l__RunService__3 (copy), l__Workspace__4 (copy), u11 (ref)
    u89 = u89 + 1;
    local u92 = u88(u90, p91);
    local function u96(p93) --[[ Line: 380 ]]
        -- upvalues: u92 (copy)
        for v94 = #u92, 1, -1 do
            local v95 = u92[v94];
            if v95.ClosestWayPoint > p93 then
                break;
            end;
            v95:Destroy();
            u92[v94] = nil;
        end;
    end;
    local u97 = "ClickToMoveResizeTrail" .. u89;
    l__RunService__3:BindToRenderStep(u97, Enum.RenderPriority.Camera.Value - 1, function() --[[ Name: resizeTrailDots, Line 394 ]]
        -- upvalues: u92 (copy), l__RunService__3 (ref), u97 (copy), l__Workspace__4 (ref), u11 (ref)
        if #u92 == 0 then
            l__RunService__3:UnbindFromRenderStep(u97);
        else
            local l__p__8 = l__Workspace__4.CurrentCamera.CFrame.p;
            for v98 = 1, #u92 do
                local v99 = u92[v98].DisplayModel:FindFirstChild("TrailDotImage");
                if v99 then
                    v99.Size = u11 * (math.clamp((u92[v98].DisplayModel.Position - l__p__8).Magnitude - 10, 0, 90) / 90 * 1.5 + 1);
                end;
            end;
        end;
    end);
    return function() --[[ Name: removePath, Line 410 ]]
        -- upvalues: u96 (copy), u90 (copy)
        u96(#u90);
    end, u96;
end;
local u100 = nil;
function v1.DisplayFailureWaypoint(p101) --[[ Line: 418 ]]
    -- upvalues: u100 (ref), u56 (copy)
    if u100 then
        u100:Hide();
    end;
    local u102 = u56.new(p101);
    u100 = u102;
    coroutine.wrap(function() --[[ Line: 424 ]]
        -- upvalues: u102 (ref)
        u102:RunFailureTween();
        u102:Destroy();
        u102 = nil;
    end)();
end;
function v1.CreateEndWaypoint(p103) --[[ Line: 431 ]]
    -- upvalues: u41 (copy)
    return u41.new(p103);
end;
function v1.PlayFailureAnimation() --[[ Line: 435 ]]
    -- upvalues: l__LocalPlayer__5 (copy), u76 (ref), u75 (copy)
    local l__Character__9 = l__LocalPlayer__5.Character;
    local v104;
    if l__Character__9 then
        v104 = l__Character__9:FindFirstChildOfClass("Humanoid");
    else
        v104 = nil;
    end;
    if v104 then
        local v105;
        if v104 == nil then
            v105 = u76;
        else
            u76 = v104:LoadAnimation(u75);
            assert(u76, "");
            u76.Priority = Enum.AnimationPriority.Action;
            u76.Looped = false;
            v105 = u76;
        end;
        v105:Play();
    end;
end;
function v1.CancelFailureAnimation() --[[ Line: 443 ]]
    -- upvalues: u76 (ref)
    if u76 ~= nil and u76.IsPlaying then
        u76:Stop();
    end;
end;
function v1.SetWaypointTexture(p106) --[[ Line: 449 ]]
    -- upvalues: u2 (ref), u24 (ref), u25 (ref), u26 (ref), u23 (copy)
    u2 = p106;
    local v107, v108, v109 = u23();
    u24 = v107;
    u25 = v108;
    u26 = v109;
end;
function v1.GetWaypointTexture() --[[ Line: 454 ]]
    -- upvalues: u2 (ref)
    return u2;
end;
function v1.SetWaypointRadius(p110) --[[ Line: 458 ]]
    -- upvalues: u11 (ref), u24 (ref), u25 (ref), u26 (ref), u23 (copy)
    u11 = Vector2.new(p110, p110);
    local v111, v112, v113 = u23();
    u24 = v111;
    u25 = v112;
    u26 = v113;
end;
function v1.GetWaypointRadius() --[[ Line: 463 ]]
    -- upvalues: u11 (ref)
    return u11.X;
end;
function v1.SetEndWaypointTexture(p114) --[[ Line: 467 ]]
    -- upvalues: u3 (ref), u24 (ref), u25 (ref), u26 (ref), u23 (copy)
    u3 = p114;
    local v115, v116, v117 = u23();
    u24 = v115;
    u25 = v116;
    u26 = v117;
end;
function v1.GetEndWaypointTexture() --[[ Line: 472 ]]
    -- upvalues: u3 (ref)
    return u3;
end;
function v1.SetWaypointsAlwaysOnTop(p118) --[[ Line: 476 ]]
    -- upvalues: u4 (ref), u24 (ref), u25 (ref), u26 (ref), u23 (copy)
    u4 = p118;
    local v119, v120, v121 = u23();
    u24 = v119;
    u25 = v120;
    u26 = v121;
end;
function v1.GetWaypointsAlwaysOnTop() --[[ Line: 481 ]]
    -- upvalues: u4 (ref)
    return u4;
end;
return v1;