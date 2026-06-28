-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local v1, v2 = pcall(function() --[[ Line: 10 ]]
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding");
end);
local u3 = v1 and v2;
local v4, v5 = pcall(function() --[[ Line: 14 ]]
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2");
end);
local u6 = v4 and v5;
local l__UserInputService__1 = game:GetService("UserInputService");
local l__PathfindingService__2 = game:GetService("PathfindingService");
local l__Players__3 = game:GetService("Players");
game:GetService("Debris");
local l__StarterGui__4 = game:GetService("StarterGui");
local l__Workspace__5 = game:GetService("Workspace");
local l__CollectionService__6 = game:GetService("CollectionService");
local l__GuiService__7 = game:GetService("GuiService");
local u7 = true;
local u8 = true;
local u9 = false;
local u10 = 1;
local u11 = 8;
local u12 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true
};
local l__LocalPlayer__8 = l__Players__3.LocalPlayer;
local l__ClickToMoveDisplay__9 = require(script.Parent:WaitForChild("ClickToMoveDisplay"));
local u13 = {};
local function u16(p14) --[[ Line: 56 ]]
    -- upvalues: u16 (copy)
    if p14 then
        local v15 = p14:FindFirstChildOfClass("Humanoid");
        if v15 then
            return p14, v15;
        else
            return u16(p14.Parent);
        end;
    end;
end;
u13.FindCharacterAncestor = u16;
local function u27(p17, p18, p19) --[[ Line: 68 ]]
    -- upvalues: l__Workspace__5 (copy), u16 (copy), u27 (copy)
    local v20 = p19 or {};
    local v21, v22, v23, v24 = l__Workspace__5:FindPartOnRayWithIgnoreList(p17, v20);
    if not v21 then
        return nil, nil;
    end;
    if p18 and v21.CanCollide == false then
        local v25;
        if v21 then
            v25 = v21:FindFirstChildOfClass("Humanoid");
            if not v25 then
                local v26;
                v26, v25 = u16(v21.Parent);
            end;
        else
            v25 = nil;
        end;
        if v25 == nil then
            table.insert(v20, v21);
            return u27(p17, p18, v20);
        end;
    end;
    return v21, v22, v23, v24;
end;
u13.Raycast = u27;
local u28 = {};
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local function u41(p33) --[[ Line: 117 ]]
    -- upvalues: u30 (ref), u31 (ref), u32 (ref), u29 (ref), l__LocalPlayer__8 (copy), l__CollectionService__6 (copy)
    if p33 == u30 then
    else
        if u31 then
            u31:Disconnect();
            u31 = nil;
        end;
        if u32 then
            u32:Disconnect();
            u32 = nil;
        end;
        u30 = p33;
        local v34 = {};
        local v35 = l__LocalPlayer__8;
        if v35 then
            v35 = l__LocalPlayer__8.Character;
        end;
        v34[1] = v35;
        u29 = v34;
        if u30 ~= nil then
            local v36 = l__CollectionService__6:GetTagged(u30);
            for _, v37 in ipairs(v36) do
                table.insert(u29, v37);
            end;
            u31 = l__CollectionService__6:GetInstanceAddedSignal(u30):Connect(function(p38) --[[ Line: 137 ]]
                -- upvalues: u29 (ref)
                table.insert(u29, p38);
            end);
            u32 = l__CollectionService__6:GetInstanceRemovedSignal(u30):Connect(function(p39) --[[ Line: 141 ]]
                -- upvalues: u29 (ref)
                for v40 = 1, #u29 do
                    if u29[v40] == p39 then
                        u29[v40] = u29[#u29];
                        table.remove(u29);
                        return;
                    end;
                end;
            end);
        end;
    end;
end;
local function u59(p42) --[[ Line: 169 ]]
    if p42 == nil or p42.PrimaryPart == nil then
    else
        assert(p42, "");
        assert(p42.PrimaryPart, "");
        local v43 = p42.PrimaryPart.CFrame:Inverse();
        local v44 = Vector3.new(inf, inf, inf);
        local v45 = Vector3.new(-inf, -inf, -inf);
        for _, v46 in pairs(p42:GetDescendants()) do
            if v46:IsA("BasePart") and v46.CanCollide then
                local v47 = v43 * v46.CFrame;
                local v48 = Vector3.new(v46.Size.X / 2, v46.Size.Y / 2, v46.Size.Z / 2);
                local v49 = {
                    Vector3.new(v48.X, v48.Y, v48.Z),
                    Vector3.new(v48.X, v48.Y, -v48.Z),
                    Vector3.new(v48.X, -v48.Y, v48.Z),
                    Vector3.new(v48.X, -v48.Y, -v48.Z),
                    Vector3.new(-v48.X, v48.Y, v48.Z),
                    Vector3.new(-v48.X, v48.Y, -v48.Z),
                    Vector3.new(-v48.X, -v48.Y, v48.Z),
                    (Vector3.new(-v48.X, -v48.Y, -v48.Z))
                };
                for _, v50 in ipairs(v49) do
                    local v51 = v47 * v50;
                    local v52 = math.min(v44.X, v51.X);
                    local v53 = math.min(v44.Y, v51.Y);
                    local v54 = math.min(v44.Z, v51.Z);
                    v44 = Vector3.new(v52, v53, v54);
                    local v55 = math.max(v45.X, v51.X);
                    local v56 = math.max(v45.Y, v51.Y);
                    local v57 = math.max(v45.Z, v51.Z);
                    v45 = Vector3.new(v55, v56, v57);
                end;
            end;
        end;
        local v58 = v45 - v44;
        if v58.X < 0 or (v58.Y < 0 or v58.Z < 0) then
            return nil;
        else
            return v58;
        end;
    end;
end;
local function u110(p60, p61, p62) --[[ Line: 204 ]]
    -- upvalues: u9 (ref), l__LocalPlayer__8 (copy), u28 (copy), u10 (ref), u3 (copy), u59 (copy), u6 (copy), l__PathfindingService__2 (copy), u7 (ref), l__ClickToMoveDisplay__9 (copy), u11 (ref), l__Workspace__5 (copy), u29 (ref)
    local u63 = {};
    local v64;
    if p62 == nil then
        v64 = u9;
        p62 = true;
    else
        v64 = p62;
    end;
    u63.Cancelled = false;
    u63.Started = false;
    u63.Finished = Instance.new("BindableEvent");
    u63.PathFailed = Instance.new("BindableEvent");
    u63.PathComputing = false;
    u63.PathComputed = false;
    u63.OriginalTargetPoint = p60;
    u63.TargetPoint = p60;
    u63.TargetSurfaceNormal = p61;
    u63.DiedConn = nil;
    u63.SeatedConn = nil;
    u63.BlockedConn = nil;
    u63.TeleportedConn = nil;
    u63.CurrentPoint = 0;
    u63.HumanoidOffsetFromPath = Vector3.new(0, 0, 0);
    u63.CurrentWaypointPosition = nil;
    u63.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
    u63.CurrentWaypointPlaneDistance = 0;
    u63.CurrentWaypointNeedsJump = false;
    u63.CurrentHumanoidPosition = Vector3.new(0, 0, 0);
    u63.CurrentHumanoidVelocity = 0;
    u63.NextActionMoveDirection = Vector3.new(0, 0, 0);
    u63.NextActionJump = false;
    u63.Timeout = 0;
    local v65 = l__LocalPlayer__8;
    local v66;
    if v65 then
        v66 = v65.Character;
    else
        v66 = v65;
    end;
    local v67;
    if v66 then
        v67 = u28[v65];
        if not v67 or v67.Parent ~= v66 then
            u28[v65] = nil;
            v67 = v66:FindFirstChildOfClass("Humanoid");
            if v67 then
                u28[v65] = v67;
            end;
        end;
    else
        v67 = nil;
    end;
    u63.Humanoid = v67;
    u63.OriginPoint = nil;
    u63.AgentCanFollowPath = false;
    u63.DirectPath = false;
    u63.DirectPathRiseFirst = false;
    u63.stopTraverseFunc = nil;
    u63.setPointFunc = nil;
    u63.pointList = nil;
    local l__Humanoid__10 = u63.Humanoid;
    if l__Humanoid__10 then
        l__Humanoid__10 = u63.Humanoid.RootPart;
    end;
    if l__Humanoid__10 then
        u63.OriginPoint = l__Humanoid__10.CFrame.Position;
        local v68 = 2;
        local v69 = 5;
        local v70 = true;
        local l__SeatPart__11 = u63.Humanoid.SeatPart;
        if l__SeatPart__11 and l__SeatPart__11:IsA("VehicleSeat") then
            local v71 = l__SeatPart__11:FindFirstAncestorOfClass("Model");
            if v71 then
                local l__PrimaryPart__12 = v71.PrimaryPart;
                v71.PrimaryPart = l__SeatPart__11;
                if p62 then
                    local v72 = v71:GetExtentsSize();
                    v68 = u10 * 0.5 * math.sqrt(v72.X * v72.X + v72.Z * v72.Z);
                    v69 = u10 * v72.Y;
                    u63.AgentCanFollowPath = true;
                    u63.DirectPath = p62;
                    v70 = false;
                end;
                v71.PrimaryPart = l__PrimaryPart__12;
            end;
        else
            local v73 = nil;
            if u3 then
                local v74 = l__LocalPlayer__8;
                if v74 then
                    v74 = l__LocalPlayer__8.Character;
                end;
                if v74 ~= nil then
                    v73 = u59(v74);
                end;
            end;
            if v73 == nil then
                local v75 = l__LocalPlayer__8;
                if v75 then
                    v75 = l__LocalPlayer__8.Character;
                end;
                v73 = v75:GetExtentsSize();
            end;
            assert(v73, "");
            v68 = u10 * 0.5 * math.sqrt(v73.X * v73.X + v73.Z * v73.Z);
            v69 = u10 * v73.Y;
            v70 = u63.Humanoid.JumpPower > 0;
            u63.AgentCanFollowPath = true;
            u63.DirectPath = v64;
            u63.DirectPathRiseFirst = u63.Humanoid.Sit;
        end;
        if u6 then
            u63.pathResult = l__PathfindingService__2:CreatePath({
                AgentCanClimb = true,
                AgentRadius = v68,
                AgentHeight = v69,
                AgentCanJump = v70
            });
        else
            u63.pathResult = l__PathfindingService__2:CreatePath({
                AgentRadius = v68,
                AgentHeight = v69,
                AgentCanJump = v70
            });
        end;
    end;
    function u63.Cleanup(_) --[[ Line: 322 ]]
        -- upvalues: u63 (copy)
        if u63.stopTraverseFunc then
            u63.stopTraverseFunc();
            u63.stopTraverseFunc = nil;
        end;
        if u63.BlockedConn then
            u63.BlockedConn:Disconnect();
            u63.BlockedConn = nil;
        end;
        if u63.DiedConn then
            u63.DiedConn:Disconnect();
            u63.DiedConn = nil;
        end;
        if u63.SeatedConn then
            u63.SeatedConn:Disconnect();
            u63.SeatedConn = nil;
        end;
        if u63.TeleportedConn then
            u63.TeleportedConn:Disconnect();
            u63.TeleportedConn = nil;
        end;
        u63.Started = false;
    end;
    function u63.Cancel(_) --[[ Line: 351 ]]
        -- upvalues: u63 (copy)
        u63.Cancelled = true;
        u63:Cleanup();
    end;
    function u63.IsActive(_) --[[ Line: 356 ]]
        -- upvalues: u63 (copy)
        local v76 = u63.AgentCanFollowPath and u63.Started;
        if v76 then
            v76 = not u63.Cancelled;
        end;
        return v76;
    end;
    function u63.OnPathInterrupted(_) --[[ Line: 360 ]]
        -- upvalues: u63 (copy)
        u63.Cancelled = true;
        u63:OnPointReached(false);
    end;
    function u63.ComputePath(_) --[[ Line: 366 ]]
        -- upvalues: u63 (copy)
        if u63.OriginPoint then
            if u63.PathComputed or u63.PathComputing then
                return;
            end;
            u63.PathComputing = true;
            if u63.AgentCanFollowPath then
                if u63.DirectPath then
                    u63.pointList = { PathWaypoint.new(u63.OriginPoint, Enum.PathWaypointAction.Walk), PathWaypoint.new(u63.TargetPoint, u63.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk) };
                    u63.PathComputed = true;
                else
                    u63.pathResult:ComputeAsync(u63.OriginPoint, u63.TargetPoint);
                    u63.pointList = u63.pathResult:GetWaypoints();
                    u63.BlockedConn = u63.pathResult.Blocked:Connect(function(p77) --[[ Line: 380 ]]
                        -- upvalues: u63 (ref)
                        u63:OnPathBlocked(p77);
                    end);
                    u63.PathComputed = u63.pathResult.Status == Enum.PathStatus.Success;
                end;
            end;
            u63.PathComputing = false;
        end;
    end;
    function u63.IsValidPath(_) --[[ Line: 388 ]]
        -- upvalues: u63 (copy)
        u63:ComputePath();
        local l__PathComputed__13 = u63.PathComputed;
        if l__PathComputed__13 then
            l__PathComputed__13 = u63.AgentCanFollowPath;
        end;
        return l__PathComputed__13;
    end;
    u63.Recomputing = false;
    function u63.OnPathBlocked(_, p78) --[[ Line: 394 ]]
        -- upvalues: u63 (copy), u7 (ref), l__ClickToMoveDisplay__9 (ref)
        if u63.CurrentPoint <= p78 and not u63.Recomputing then
            u63.Recomputing = true;
            if u63.stopTraverseFunc then
                u63.stopTraverseFunc();
                u63.stopTraverseFunc = nil;
            end;
            u63.OriginPoint = u63.Humanoid.RootPart.CFrame.p;
            u63.pathResult:ComputeAsync(u63.OriginPoint, u63.TargetPoint);
            u63.pointList = u63.pathResult:GetWaypoints();
            if #u63.pointList > 0 then
                u63.HumanoidOffsetFromPath = u63.pointList[1].Position - u63.OriginPoint;
            end;
            u63.PathComputed = u63.pathResult.Status == Enum.PathStatus.Success;
            if u7 then
                local v79 = u63;
                local v80 = u63;
                local v81, v82 = l__ClickToMoveDisplay__9.CreatePathDisplay(u63.pointList);
                v79.stopTraverseFunc = v81;
                v80.setPointFunc = v82;
            end;
            if u63.PathComputed then
                u63.CurrentPoint = 1;
                u63:OnPointReached(true);
            else
                u63.PathFailed:Fire();
                u63:Cleanup();
            end;
            u63.Recomputing = false;
        end;
    end;
    function u63.OnRenderStepped(_, p83) --[[ Line: 430 ]]
        -- upvalues: u63 (copy), u11 (ref)
        if u63.Started and not u63.Cancelled then
            u63.Timeout = u63.Timeout + p83;
            if u11 < u63.Timeout then
                u63:OnPointReached(false);
                return;
            end;
            u63.CurrentHumanoidPosition = u63.Humanoid.RootPart.Position + u63.HumanoidOffsetFromPath;
            u63.CurrentHumanoidVelocity = u63.Humanoid.RootPart.Velocity;
            while u63.Started and u63:IsCurrentWaypointReached() do
                u63:OnPointReached(true);
            end;
            if u63.Started then
                u63.NextActionMoveDirection = u63.CurrentWaypointPosition - u63.CurrentHumanoidPosition;
                if u63.NextActionMoveDirection.Magnitude > 1e-6 then
                    u63.NextActionMoveDirection = u63.NextActionMoveDirection.Unit;
                else
                    u63.NextActionMoveDirection = Vector3.new(0, 0, 0);
                end;
                if u63.CurrentWaypointNeedsJump then
                    u63.NextActionJump = true;
                    u63.CurrentWaypointNeedsJump = false;
                    return;
                end;
                u63.NextActionJump = false;
            end;
        end;
    end;
    function u63.IsCurrentWaypointReached(_) --[[ Line: 468 ]]
        -- upvalues: u63 (copy)
        local v84;
        if u63.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            v84 = true;
        else
            local v85 = u63.CurrentWaypointPlaneNormal:Dot(u63.CurrentHumanoidPosition) - u63.CurrentWaypointPlaneDistance;
            local v86 = 0.0625 * -u63.CurrentWaypointPlaneNormal:Dot(u63.CurrentHumanoidVelocity);
            v84 = v85 < math.max(1, v86);
        end;
        if v84 then
            u63.CurrentWaypointPosition = nil;
            u63.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u63.CurrentWaypointPlaneDistance = 0;
        end;
        return v84;
    end;
    function u63.OnPointReached(_, p87) --[[ Line: 494 ]]
        -- upvalues: u63 (copy)
        if p87 and not u63.Cancelled then
            if u63.setPointFunc then
                u63.setPointFunc(u63.CurrentPoint);
            end;
            local v88 = u63.CurrentPoint + 1;
            if #u63.pointList < v88 then
                if u63.stopTraverseFunc then
                    u63.stopTraverseFunc();
                end;
                u63.Finished:Fire();
                u63:Cleanup();
            else
                local v89 = u63.pointList[u63.CurrentPoint];
                local v90 = u63.pointList[v88];
                local v91 = u63.Humanoid:GetState();
                if (v91 == Enum.HumanoidStateType.FallingDown or v91 == Enum.HumanoidStateType.Freefall) and true or v91 == Enum.HumanoidStateType.Jumping then
                    local v92 = v90.Action == Enum.PathWaypointAction.Jump;
                    if not v92 and u63.CurrentPoint > 1 then
                        local v93 = v89.Position - u63.pointList[u63.CurrentPoint - 1].Position;
                        local v94 = v90.Position - v89.Position;
                        v92 = Vector2.new(v93.x, v93.z).Unit:Dot(Vector2.new(v94.x, v94.z).Unit) < 0.996;
                    end;
                    if v92 then
                        u63.Humanoid.FreeFalling:Wait();
                        wait(0.1);
                    end;
                end;
                u63:MoveToNextWayPoint(v89, v90, v88);
            end;
        else
            u63.PathFailed:Fire();
            u63:Cleanup();
        end;
    end;
    function u63.MoveToNextWayPoint(_, p95, p96, p97) --[[ Line: 557 ]]
        -- upvalues: u63 (copy), u6 (ref)
        u63.CurrentWaypointPlaneNormal = p95.Position - p96.Position;
        if not u6 or p96.Label ~= "Climb" then
            u63.CurrentWaypointPlaneNormal = Vector3.new(u63.CurrentWaypointPlaneNormal.X, 0, u63.CurrentWaypointPlaneNormal.Z);
        end;
        if u63.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
            u63.CurrentWaypointPlaneNormal = u63.CurrentWaypointPlaneNormal.Unit;
            u63.CurrentWaypointPlaneDistance = u63.CurrentWaypointPlaneNormal:Dot(p96.Position);
        else
            u63.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u63.CurrentWaypointPlaneDistance = 0;
        end;
        u63.CurrentWaypointNeedsJump = p96.Action == Enum.PathWaypointAction.Jump;
        u63.CurrentWaypointPosition = p96.Position;
        u63.CurrentPoint = p97;
        u63.Timeout = 0;
    end;
    function u63.Start(_, p98) --[[ Line: 589 ]]
        -- upvalues: u63 (copy), l__ClickToMoveDisplay__9 (ref), u7 (ref)
        if u63.AgentCanFollowPath then
            if u63.Started then
            else
                u63.Started = true;
                l__ClickToMoveDisplay__9.CancelFailureAnimation();
                if u7 and (p98 == nil or p98) then
                    local v99 = u63;
                    local v100 = u63;
                    local v101, v102 = l__ClickToMoveDisplay__9.CreatePathDisplay(u63.pointList, u63.OriginalTargetPoint);
                    v99.stopTraverseFunc = v101;
                    v100.setPointFunc = v102;
                end;
                if #u63.pointList > 0 then
                    u63.HumanoidOffsetFromPath = Vector3.new(0, u63.pointList[1].Position.Y - u63.OriginPoint.Y, 0);
                    u63.CurrentHumanoidPosition = u63.Humanoid.RootPart.Position + u63.HumanoidOffsetFromPath;
                    u63.CurrentHumanoidVelocity = u63.Humanoid.RootPart.Velocity;
                    u63.SeatedConn = u63.Humanoid.Seated:Connect(function(_, _) --[[ Line: 616 ]]
                        -- upvalues: u63 (ref)
                        u63:OnPathInterrupted();
                    end);
                    u63.DiedConn = u63.Humanoid.Died:Connect(function() --[[ Line: 617 ]]
                        -- upvalues: u63 (ref)
                        u63:OnPathInterrupted();
                    end);
                    u63.TeleportedConn = u63.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() --[[ Line: 618 ]]
                        -- upvalues: u63 (ref)
                        u63:OnPathInterrupted();
                    end);
                    u63.CurrentPoint = 1;
                    u63:OnPointReached(true);
                else
                    u63.PathFailed:Fire();
                    if u63.stopTraverseFunc then
                        u63.stopTraverseFunc();
                    end;
                end;
            end;
        else
            u63.PathFailed:Fire();
        end;
    end;
    local v103 = Ray.new(u63.TargetPoint + u63.TargetSurfaceNormal * 1.5, Vector3.new(0, -50, 0));
    local v104 = l__Workspace__5;
    local v105;
    if u29 then
        v105 = u29;
    else
        u29 = {};
        assert(u29, "");
        local v106 = u29;
        local v107 = l__LocalPlayer__8;
        if v107 then
            v107 = l__LocalPlayer__8.Character;
        end;
        table.insert(v106, v107);
        v105 = u29;
    end;
    local v108, v109 = v104:FindPartOnRayWithIgnoreList(v103, v105);
    if v108 then
        u63.TargetPoint = v109;
    end;
    u63:ComputePath();
    return u63;
end;
local function u113(p111) --[[ Line: 650 ]]
    if p111 ~= nil then
        for _, v112 in pairs(p111:GetChildren()) do
            if v112:IsA("Tool") then
                return v112;
            end;
        end;
    end;
end;
local u114 = nil;
local u115 = nil;
local u116 = nil;
local function u125(p117, u118, u119, u120, u121) --[[ Line: 683 ]]
    -- upvalues: u114 (ref), u115 (ref), u116 (ref), u113 (copy), u8 (ref), l__ClickToMoveDisplay__9 (copy)
    if u114 then
        if u114 then
            u114:Cancel();
            u114 = nil;
        end;
        if u115 then
            u115:Disconnect();
            u115 = nil;
        end;
        if u116 then
            u116:Disconnect();
            u116 = nil;
        end;
    end;
    u114 = p117;
    p117:Start(u121);
    u115 = p117.Finished.Event:Connect(function() --[[ Line: 690 ]]
        -- upvalues: u114 (ref), u115 (ref), u116 (ref), u119 (copy), u113 (ref), u120 (copy)
        if u114 then
            u114:Cancel();
            u114 = nil;
        end;
        if u115 then
            u115:Disconnect();
            u115 = nil;
        end;
        if u116 then
            u116:Disconnect();
            u116 = nil;
        end;
        local v122 = u119 and u113(u120);
        if v122 then
            v122:Activate();
        end;
    end);
    u116 = p117.PathFailed.Event:Connect(function() --[[ Line: 699 ]]
        -- upvalues: u114 (ref), u115 (ref), u116 (ref), u121 (copy), u8 (ref), l__ClickToMoveDisplay__9 (ref), u118 (copy)
        if u114 then
            u114:Cancel();
            u114 = nil;
        end;
        if u115 then
            u115:Disconnect();
            u115 = nil;
        end;
        if u116 then
            u116:Disconnect();
            u116 = nil;
        end;
        if u121 == nil or u121 then
            local v123 = u8;
            if v123 then
                local v124 = u114;
                if v124 then
                    v124 = u114:IsActive();
                end;
                v123 = not v124;
            end;
            if v123 then
                l__ClickToMoveDisplay__9.PlayFailureAnimation();
            end;
            l__ClickToMoveDisplay__9.DisplayFailureWaypoint(u118);
        end;
    end);
end;
function OnTap(p126, p127, p128)
    -- upvalues: l__Workspace__5 (copy), l__LocalPlayer__8 (copy), u28 (copy), u13 (copy), u29 (ref), l__StarterGui__4 (copy), l__Players__3 (copy), u114 (ref), u115 (ref), u116 (ref), u110 (copy), u125 (copy), u8 (ref), l__ClickToMoveDisplay__9 (copy), u113 (copy)
    local l__CurrentCamera__14 = l__Workspace__5.CurrentCamera;
    local l__Character__15 = l__LocalPlayer__8.Character;
    local v129 = l__LocalPlayer__8;
    local v130;
    if v129 then
        v130 = v129.Character;
    else
        v130 = v129;
    end;
    local v131;
    if v130 then
        v131 = u28[v129];
        if not v131 or v131.Parent ~= v130 then
            u28[v129] = nil;
            v131 = v130:FindFirstChildOfClass("Humanoid");
            if v131 then
                u28[v129] = v131;
            end;
        end;
    else
        v131 = nil;
    end;
    local v132;
    if v131 == nil then
        v132 = false;
    else
        v132 = v131.Health > 0;
    end;
    if v132 then
        if #p126 == 1 or p127 then
            if l__CurrentCamera__14 then
                local v133 = l__CurrentCamera__14:ScreenPointToRay(p126[1].X, p126[1].Y);
                local v134 = Ray.new(v133.Origin, v133.Direction * 1000);
                local v135 = l__LocalPlayer__8;
                local v136;
                if v135 then
                    v136 = v135.Character;
                else
                    v136 = v135;
                end;
                if v136 then
                    local v137 = u28[v135];
                    if not v137 or v137.Parent ~= v136 then
                        u28[v135] = nil;
                        local v138 = v136:FindFirstChildOfClass("Humanoid");
                        if v138 then
                            u28[v135] = v138;
                        end;
                    end;
                end;
                local l__Raycast__16 = u13.Raycast;
                local v139 = true;
                local v140;
                if u29 then
                    v140 = u29;
                else
                    u29 = {};
                    assert(u29, "");
                    local v141 = u29;
                    local v142 = l__LocalPlayer__8;
                    if v142 then
                        v142 = l__LocalPlayer__8.Character;
                    end;
                    table.insert(v141, v142);
                    v140 = u29;
                end;
                local v143, v144, v145 = l__Raycast__16(v134, v139, v140);
                local v146, v147 = u13.FindCharacterAncestor(v143);
                if p128 and (v147 and (l__StarterGui__4:GetCore("AvatarContextMenuEnabled") and l__Players__3:GetPlayerFromCharacter(v147.Parent))) then
                    if u114 then
                        u114:Cancel();
                        u114 = nil;
                    end;
                    if u115 then
                        u115:Disconnect();
                        u115 = nil;
                    end;
                    if u116 then
                        u116:Disconnect();
                        u116 = nil;
                    end;
                    return;
                end;
                if p127 then
                    v146 = nil;
                else
                    p127 = v144;
                end;
                if p127 and l__Character__15 then
                    if u114 then
                        u114:Cancel();
                        u114 = nil;
                    end;
                    if u115 then
                        u115:Disconnect();
                        u115 = nil;
                    end;
                    if u116 then
                        u116:Disconnect();
                        u116 = nil;
                    end;
                    local v148 = u110(p127, v145);
                    if v148:IsValidPath() then
                        u125(v148, p127, v146, l__Character__15);
                    else
                        v148:Cleanup();
                        if u114 and u114:IsActive() then
                            u114:Cancel();
                        end;
                        if u8 then
                            l__ClickToMoveDisplay__9.PlayFailureAnimation();
                        end;
                        l__ClickToMoveDisplay__9.DisplayFailureWaypoint(p127);
                    end;
                end;
            end;
        else
            local v149 = #p126 >= 2 and (l__CurrentCamera__14 and u113(l__Character__15));
            if v149 then
                v149:Activate();
            end;
        end;
    end;
end;
local l__Keyboard__17 = require(script.Parent:WaitForChild("Keyboard"));
local u150 = setmetatable({}, l__Keyboard__17);
u150.__index = u150;
function u150.new(p151) --[[ Line: 785 ]]
    -- upvalues: l__Keyboard__17 (copy), u150 (copy)
    local v152 = l__Keyboard__17.new(p151);
    local v153 = setmetatable(v152, u150);
    v153.fingerTouches = {};
    v153.numUnsunkTouches = 0;
    v153.mouse1Down = tick();
    v153.mouse1DownPos = Vector2.new();
    v153.mouse2DownTime = tick();
    v153.mouse2DownPos = Vector2.new();
    v153.mouse2UpTime = tick();
    v153.keyboardMoveVector = Vector3.new(0, 0, 0);
    v153.tapConn = nil;
    v153.inputBeganConn = nil;
    v153.inputChangedConn = nil;
    v153.inputEndedConn = nil;
    v153.humanoidDiedConn = nil;
    v153.characterChildAddedConn = nil;
    v153.onCharacterAddedConn = nil;
    v153.characterChildRemovedConn = nil;
    v153.renderSteppedConn = nil;
    v153.menuOpenedConnection = nil;
    v153.running = false;
    v153.wasdEnabled = false;
    return v153;
end;
function u150.DisconnectEvents(p154) --[[ Line: 817 ]]
    local l__tapConn__18 = p154.tapConn;
    if l__tapConn__18 then
        l__tapConn__18:Disconnect();
    end;
    local l__inputBeganConn__19 = p154.inputBeganConn;
    if l__inputBeganConn__19 then
        l__inputBeganConn__19:Disconnect();
    end;
    local l__inputChangedConn__20 = p154.inputChangedConn;
    if l__inputChangedConn__20 then
        l__inputChangedConn__20:Disconnect();
    end;
    local l__inputEndedConn__21 = p154.inputEndedConn;
    if l__inputEndedConn__21 then
        l__inputEndedConn__21:Disconnect();
    end;
    local l__humanoidDiedConn__22 = p154.humanoidDiedConn;
    if l__humanoidDiedConn__22 then
        l__humanoidDiedConn__22:Disconnect();
    end;
    local l__characterChildAddedConn__23 = p154.characterChildAddedConn;
    if l__characterChildAddedConn__23 then
        l__characterChildAddedConn__23:Disconnect();
    end;
    local l__onCharacterAddedConn__24 = p154.onCharacterAddedConn;
    if l__onCharacterAddedConn__24 then
        l__onCharacterAddedConn__24:Disconnect();
    end;
    local l__renderSteppedConn__25 = p154.renderSteppedConn;
    if l__renderSteppedConn__25 then
        l__renderSteppedConn__25:Disconnect();
    end;
    local l__characterChildRemovedConn__26 = p154.characterChildRemovedConn;
    if l__characterChildRemovedConn__26 then
        l__characterChildRemovedConn__26:Disconnect();
    end;
    local l__menuOpenedConnection__27 = p154.menuOpenedConnection;
    if l__menuOpenedConnection__27 then
        l__menuOpenedConnection__27:Disconnect();
    end;
end;
function u150.OnTouchBegan(p155, p156, p157) --[[ Line: 830 ]]
    if p155.fingerTouches[p156] == nil and not p157 then
        p155.numUnsunkTouches = p155.numUnsunkTouches + 1;
    end;
    p155.fingerTouches[p156] = p157;
end;
function u150.OnTouchChanged(p158, p159, p160) --[[ Line: 837 ]]
    if p158.fingerTouches[p159] == nil then
        p158.fingerTouches[p159] = p160;
        if not p160 then
            p158.numUnsunkTouches = p158.numUnsunkTouches + 1;
        end;
    end;
end;
function u150.OnTouchEnded(p161, p162, _) --[[ Line: 846 ]]
    if p161.fingerTouches[p162] ~= nil and p161.fingerTouches[p162] == false then
        p161.numUnsunkTouches = p161.numUnsunkTouches - 1;
    end;
    p161.fingerTouches[p162] = nil;
end;
function u150.OnCharacterAdded(u163, p164) --[[ Line: 854 ]]
    -- upvalues: l__UserInputService__1 (copy), u12 (copy), u114 (ref), u115 (ref), u116 (ref), l__ClickToMoveDisplay__9 (copy), l__GuiService__7 (copy)
    u163:DisconnectEvents();
    u163.inputBeganConn = l__UserInputService__1.InputBegan:Connect(function(p165, p166) --[[ Line: 857 ]]
        -- upvalues: u163 (copy), u12 (ref), u114 (ref), u115 (ref), u116 (ref), l__ClickToMoveDisplay__9 (ref)
        if p165.UserInputType == Enum.UserInputType.Touch then
            u163:OnTouchBegan(p165, p166);
        end;
        if u163.wasdEnabled and (p166 == false and (p165.UserInputType == Enum.UserInputType.Keyboard and u12[p165.KeyCode])) then
            if u114 then
                u114:Cancel();
                u114 = nil;
            end;
            if u115 then
                u115:Disconnect();
                u115 = nil;
            end;
            if u116 then
                u116:Disconnect();
                u116 = nil;
            end;
            l__ClickToMoveDisplay__9.CancelFailureAnimation();
        end;
        if p165.UserInputType == Enum.UserInputType.MouseButton1 then
            u163.mouse1DownTime = tick();
            u163.mouse1DownPos = p165.Position;
        end;
        if p165.UserInputType == Enum.UserInputType.MouseButton2 then
            u163.mouse2DownTime = tick();
            u163.mouse2DownPos = p165.Position;
        end;
    end);
    u163.inputChangedConn = l__UserInputService__1.InputChanged:Connect(function(p167, p168) --[[ Line: 878 ]]
        -- upvalues: u163 (copy)
        if p167.UserInputType == Enum.UserInputType.Touch then
            u163:OnTouchChanged(p167, p168);
        end;
    end);
    u163.inputEndedConn = l__UserInputService__1.InputEnded:Connect(function(p169, p170) --[[ Line: 884 ]]
        -- upvalues: u163 (copy), u114 (ref)
        if p169.UserInputType == Enum.UserInputType.Touch then
            u163:OnTouchEnded(p169, p170);
        end;
        if p169.UserInputType == Enum.UserInputType.MouseButton2 then
            u163.mouse2UpTime = tick();
            local l__Position__28 = p169.Position;
            if u163.mouse2UpTime - u163.mouse2DownTime < 0.25 and ((l__Position__28 - u163.mouse2DownPos).magnitude < 5 and (u114 or u163.keyboardMoveVector.Magnitude <= 0)) then
                OnTap({ l__Position__28 });
            end;
        end;
    end);
    u163.tapConn = l__UserInputService__1.TouchTap:Connect(function(p171, p172) --[[ Line: 901 ]]
        if not p172 then
            OnTap(p171, nil, true);
        end;
    end);
    u163.menuOpenedConnection = l__GuiService__7.MenuOpened:Connect(function() --[[ Line: 907 ]]
        -- upvalues: u114 (ref), u115 (ref), u116 (ref)
        if u114 then
            u114:Cancel();
            u114 = nil;
        end;
        if u115 then
            u115:Disconnect();
            u115 = nil;
        end;
        if u116 then
            u116:Disconnect();
            u116 = nil;
        end;
    end);
    local function u174(p173) --[[ Line: 911 ]]
        -- upvalues: l__UserInputService__1 (ref), u163 (copy)
        if l__UserInputService__1.TouchEnabled and p173:IsA("Tool") then
            p173.ManualActivationOnly = true;
        end;
        if p173:IsA("Humanoid") then
            local l__humanoidDiedConn__29 = u163.humanoidDiedConn;
            if l__humanoidDiedConn__29 then
                l__humanoidDiedConn__29:Disconnect();
            end;
            u163.humanoidDiedConn = p173.Died:Connect(function() --[[ Line: 919 ]] end);
        end;
    end;
    u163.characterChildAddedConn = p164.ChildAdded:Connect(function(p175) --[[ Line: 927 ]]
        -- upvalues: u174 (copy)
        u174(p175);
    end);
    u163.characterChildRemovedConn = p164.ChildRemoved:Connect(function(p176) --[[ Line: 930 ]]
        -- upvalues: l__UserInputService__1 (ref)
        if l__UserInputService__1.TouchEnabled and p176:IsA("Tool") then
            p176.ManualActivationOnly = false;
        end;
    end);
    for _, v177 in pairs(p164:GetChildren()) do
        u174(v177);
    end;
end;
function u150.Start(p178) --[[ Line: 942 ]]
    p178:Enable(true);
end;
function u150.Stop(p179) --[[ Line: 946 ]]
    p179:Enable(false);
end;
function u150.CleanupPath(_) --[[ Line: 950 ]]
    -- upvalues: u114 (ref), u115 (ref), u116 (ref)
    if u114 then
        u114:Cancel();
        u114 = nil;
    end;
    if u115 then
        u115:Disconnect();
        u115 = nil;
    end;
    if u116 then
        u116:Disconnect();
        u116 = nil;
    end;
end;
function u150.Enable(u180, p181, p182, p183) --[[ Line: 954 ]]
    -- upvalues: l__LocalPlayer__8 (copy), u114 (ref), u115 (ref), u116 (ref), l__UserInputService__1 (copy)
    if p181 then
        if not u180.running then
            if l__LocalPlayer__8.Character then
                u180:OnCharacterAdded(l__LocalPlayer__8.Character);
            end;
            u180.onCharacterAddedConn = l__LocalPlayer__8.CharacterAdded:Connect(function(p184) --[[ Line: 960 ]]
                -- upvalues: u180 (copy)
                u180:OnCharacterAdded(p184);
            end);
            u180.running = true;
        end;
        u180.touchJumpController = p183;
        if u180.touchJumpController then
            u180.touchJumpController:Enable(u180.jumpEnabled);
        end;
    else
        if u180.running then
            u180:DisconnectEvents();
            if u114 then
                u114:Cancel();
                u114 = nil;
            end;
            if u115 then
                u115:Disconnect();
                u115 = nil;
            end;
            if u116 then
                u116:Disconnect();
                u116 = nil;
            end;
            if l__UserInputService__1.TouchEnabled then
                local l__Character__30 = l__LocalPlayer__8.Character;
                if l__Character__30 then
                    for _, v185 in pairs(l__Character__30:GetChildren()) do
                        if v185:IsA("Tool") then
                            v185.ManualActivationOnly = false;
                        end;
                    end;
                end;
            end;
            u180.running = false;
        end;
        if u180.touchJumpController and not u180.jumpEnabled then
            u180.touchJumpController:Enable(true);
        end;
        u180.touchJumpController = nil;
    end;
    if l__UserInputService__1.KeyboardEnabled and p181 ~= u180.enabled then
        u180.forwardValue = 0;
        u180.backwardValue = 0;
        u180.leftValue = 0;
        u180.rightValue = 0;
        u180.moveVector = Vector3.new(0, 0, 0);
        if p181 then
            u180:BindContextActions();
            u180:ConnectFocusEventListeners();
        else
            u180:UnbindContextActions();
            u180:DisconnectFocusEventListeners();
        end;
    end;
    u180.wasdEnabled = p181 and p182 and p182 or false;
    u180.enabled = p181;
end;
function u150.OnRenderStepped(p186, p187) --[[ Line: 1015 ]]
    -- upvalues: u114 (ref)
    p186.isJumping = false;
    if u114 then
        u114:OnRenderStepped(p187);
        if u114 then
            p186.moveVector = u114.NextActionMoveDirection;
            p186.moveVectorIsCameraRelative = false;
            if u114.NextActionJump then
                p186.isJumping = true;
            end;
        else
            p186.moveVector = p186.keyboardMoveVector;
            p186.moveVectorIsCameraRelative = true;
        end;
    else
        p186.moveVector = p186.keyboardMoveVector;
        p186.moveVectorIsCameraRelative = true;
    end;
    if p186.jumpRequested then
        p186.isJumping = true;
    end;
end;
function u150.UpdateMovement(p188, p189) --[[ Line: 1050 ]]
    if p189 == Enum.UserInputState.Cancel then
        p188.keyboardMoveVector = Vector3.new(0, 0, 0);
    else
        if p188.wasdEnabled then
            p188.keyboardMoveVector = Vector3.new(p188.leftValue + p188.rightValue, 0, p188.forwardValue + p188.backwardValue);
        end;
    end;
end;
function u150.UpdateJump(_) --[[ Line: 1059 ]] end;
function u150.SetShowPath(_, p190) --[[ Line: 1064 ]]
    -- upvalues: u7 (ref)
    u7 = p190;
end;
function u150.GetShowPath(_) --[[ Line: 1068 ]]
    -- upvalues: u7 (ref)
    return u7;
end;
function u150.SetWaypointTexture(_, p191) --[[ Line: 1072 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    l__ClickToMoveDisplay__9.SetWaypointTexture(p191);
end;
function u150.GetWaypointTexture(_) --[[ Line: 1076 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    return l__ClickToMoveDisplay__9.GetWaypointTexture();
end;
function u150.SetWaypointRadius(_, p192) --[[ Line: 1080 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    l__ClickToMoveDisplay__9.SetWaypointRadius(p192);
end;
function u150.GetWaypointRadius(_) --[[ Line: 1084 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    return l__ClickToMoveDisplay__9.GetWaypointRadius();
end;
function u150.SetEndWaypointTexture(_, p193) --[[ Line: 1088 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    l__ClickToMoveDisplay__9.SetEndWaypointTexture(p193);
end;
function u150.GetEndWaypointTexture(_) --[[ Line: 1092 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    return l__ClickToMoveDisplay__9.GetEndWaypointTexture();
end;
function u150.SetWaypointsAlwaysOnTop(_, p194) --[[ Line: 1096 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    l__ClickToMoveDisplay__9.SetWaypointsAlwaysOnTop(p194);
end;
function u150.GetWaypointsAlwaysOnTop(_) --[[ Line: 1100 ]]
    -- upvalues: l__ClickToMoveDisplay__9 (copy)
    return l__ClickToMoveDisplay__9.GetWaypointsAlwaysOnTop();
end;
function u150.SetFailureAnimationEnabled(_, p195) --[[ Line: 1104 ]]
    -- upvalues: u8 (ref)
    u8 = p195;
end;
function u150.GetFailureAnimationEnabled(_) --[[ Line: 1108 ]]
    -- upvalues: u8 (ref)
    return u8;
end;
function u150.SetIgnoredPartsTag(_, p196) --[[ Line: 1112 ]]
    -- upvalues: u41 (copy)
    u41(p196);
end;
function u150.GetIgnoredPartsTag(_) --[[ Line: 1116 ]]
    -- upvalues: u30 (ref)
    return u30;
end;
function u150.SetUseDirectPath(_, p197) --[[ Line: 1120 ]]
    -- upvalues: u9 (ref)
    u9 = p197;
end;
function u150.GetUseDirectPath(_) --[[ Line: 1124 ]]
    -- upvalues: u9 (ref)
    return u9;
end;
function u150.SetAgentSizeIncreaseFactor(_, p198) --[[ Line: 1128 ]]
    -- upvalues: u10 (ref)
    u10 = p198 / 100 + 1;
end;
function u150.GetAgentSizeIncreaseFactor(_) --[[ Line: 1132 ]]
    -- upvalues: u10 (ref)
    return (u10 - 1) * 100;
end;
function u150.SetUnreachableWaypointTimeout(_, p199) --[[ Line: 1136 ]]
    -- upvalues: u11 (ref)
    u11 = p199;
end;
function u150.GetUnreachableWaypointTimeout(_) --[[ Line: 1140 ]]
    -- upvalues: u11 (ref)
    return u11;
end;
function u150.SetUserJumpEnabled(p200, p201) --[[ Line: 1144 ]]
    p200.jumpEnabled = p201;
    if p200.touchJumpController then
        p200.touchJumpController:Enable(p201);
    end;
end;
function u150.GetUserJumpEnabled(p202) --[[ Line: 1151 ]]
    return p202.jumpEnabled;
end;
function u150.MoveTo(_, p203, p204, p205) --[[ Line: 1155 ]]
    -- upvalues: l__LocalPlayer__8 (copy), u110 (copy), u125 (copy)
    local l__Character__31 = l__LocalPlayer__8.Character;
    if l__Character__31 == nil then
        return false;
    end;
    local v206 = u110(p203, Vector3.new(0, 1, 0), p205);
    if not (v206 and v206:IsValidPath()) then
        return false;
    end;
    u125(v206, p203, nil, l__Character__31, p204);
    return true;
end;
return u150;