-- Roblox: Workspace.SilverAce293026.ACS_Client.ACS_Framework
-- Class: LocalScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
repeat
    task.wait();
until l__Players__1.LocalPlayer.Character;
local l__LocalPlayer__2 = l__Players__1.LocalPlayer;
local u1 = l__LocalPlayer__2.Character or l__LocalPlayer__2.CharacterAdded:Wait();
l__LocalPlayer__2:GetMouse();
local l__CurrentCamera__3 = workspace.CurrentCamera;
local l__UserInputService__4 = game:GetService("UserInputService");
local l__ContextActionService__5 = game:GetService("ContextActionService");
local l__RunService__6 = game:GetService("RunService");
local l__TweenService__7 = game:GetService("TweenService");
local l__Debris__8 = game:GetService("Debris");
game:GetService("PhysicsService");
game:GetService("GuiService");
local l__ReplicatedStorage__9 = game:GetService("ReplicatedStorage");
local l__ACS_WorkSpace__10 = workspace:WaitForChild("ACS_WorkSpace");
local l__ACS_Engine__11 = l__ReplicatedStorage__9:WaitForChild("ACS_Engine");
local l__Events__12 = l__ACS_Engine__11:WaitForChild("Events");
local l__Modules__13 = l__ACS_Engine__11:WaitForChild("Modules");
local l__HUD__14 = l__ACS_Engine__11:WaitForChild("HUD");
local l__Essential__15 = l__ACS_Engine__11:WaitForChild("Essential");
local l__ArmModel__16 = l__ACS_Engine__11:WaitForChild("ArmModel");
local l__GunModels__17 = l__ACS_Engine__11:WaitForChild("GunModels");
local l__GameRules__18 = l__ACS_Engine__11:WaitForChild("GameRules");
l__ACS_Engine__11:WaitForChild("FX");
local l__Config__19 = require(l__GameRules__18:WaitForChild("Config"));
local l__Spring__20 = require(l__Modules__13:WaitForChild("Spring"));
local l__SpringV3__21 = require(l__Modules__13:WaitForChild("SpringV3"));
local l__Thread__22 = require(l__Modules__13:WaitForChild("Thread"));
local l__Utilities__23 = require(l__Modules__13:WaitForChild("Utilities"));
local l__AttachmentsUtil__24 = require(l__Modules__13:WaitForChild("AttachmentsUtil"));
local l__CamosUtil__25 = require(l__Modules__13:WaitForChild("CamosUtil"));
local l__ACS_Client__26 = u1:WaitForChild("ACS_Client");
local l__ReplicatedConfig__27 = require(l__ReplicatedStorage__9:WaitForChild("ReplicatedConfig"));
local l__WeaponProgression__28 = l__ReplicatedStorage__9:WaitForChild("WeaponProgression");
local l__Attachments__29 = require(l__WeaponProgression__28:WaitForChild("Attachments"));
local l__PlayerEvents__30 = l__ReplicatedStorage__9:WaitForChild("PlayerEvents");
l__PlayerEvents__30:WaitForChild("GetEquippedAttachments");
local l__MuzzleFlash__31 = l__ReplicatedStorage__9:WaitForChild("VFX"):WaitForChild("MuzzleFlash");
require(l__ReplicatedStorage__9:WaitForChild("Modules"):WaitForChild("VehicleModule"));
local l__GuiModule__32 = require(l__ReplicatedStorage__9.Modules:WaitForChild("GuiModule"));
local l__ShootModule__33 = require(l__ReplicatedStorage__9.Modules:WaitForChild("Projectile"):WaitForChild("ShootModule"));
local l__HeatseekModule__34 = require(l__ReplicatedStorage__9.Modules:WaitForChild("HeatseekModule"));
local l__CameraRotation__35 = require(l__ReplicatedStorage__9:WaitForChild("Modules"):WaitForChild("CameraRotation"));
local l__Control__36 = require(script:WaitForChild("Control"));
local l__JavelinGui__37 = l__LocalPlayer__2:WaitForChild("PlayerGui"):WaitForChild("JavelinGui");
l__CameraRotation__35.SensMultiplier = 1;
l__CameraRotation__35.IsTurret = false;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = time();
local u19 = l__Events__12.AcessId:InvokeServer(l__LocalPlayer__2.UserId .. "v3");
local u20 = UDim2.new();
local u21 = UDim2.new();
local u22 = UDim2.new();
local u23 = UDim2.new();
local u24 = 0;
local u25 = false;
local u26 = false;
local u27 = false;
local u28 = false;
local u29 = 0;
local u30 = 1;
local u31 = nil;
local u32 = nil;
local u33 = false;
local u34 = false;
local u35 = false;
local u36 = false;
local u37 = false;
local u38 = false;
local u39 = 0;
local u40 = nil;
local u41 = false;
local u42 = false;
local u43 = false;
local u44 = false;
local u45 = false;
local u46 = nil;
local l__HumanoidRootPart__38 = u1:WaitForChild("HumanoidRootPart");
local u47 = Instance.new("LinearVelocity");
u47.MaxAxesForce = Vector3.new(10000000, 0, 10000000);
u47.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
u47.Enabled = false;
local v48 = Instance.new("Attachment", l__HumanoidRootPart__38);
u47.Parent = l__HumanoidRootPart__38;
u47.Attachment0 = v48;
local u49 = RaycastParams.new();
u49.FilterType = Enum.RaycastFilterType.Exclude;
u49.FilterDescendantsInstances = { u1, workspace.CurrentCamera };
local u50 = 0;
local u51 = {
    Mult = 1,
    RecoveryRate = 2
};
local u53 = {
    __index = function(_, p52) --[[ Name: __index, Line 137 ]]
        if p52 == "ZoomValue" or p52 == "Zoom2Value" then
            return 70;
        elseif p52 == "AmmoCountOverride" then
            return nil;
        else
            return p52 ~= "CustomAnimations" and 1 or nil;
        end;
    end
};
local u54 = setmetatable({}, u53);
local u55 = CFrame.new();
local u56 = CFrame.new();
local u57 = CFrame.new();
local u58 = CFrame.new();
local u59 = CFrame.new();
local u60 = {
    l__CurrentCamera__3,
    u1,
    l__ACS_WorkSpace__10.Client,
    l__ACS_WorkSpace__10.Server
};
local u61 = {
    AnimFinished = true,
    Progress = 0
};
local u62 = l__HUD__14:WaitForChild("StatusUI"):Clone();
u62.Parent = l__LocalPlayer__2.PlayerGui;
local l__PlayerGui__39 = l__LocalPlayer__2:WaitForChild("PlayerGui");
local v63 = l__TweenService__7:Create(u62.Effects.Health, TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut, -1, true), {
    Size = UDim2.new(1.2, 0, 1.4, 0)
});
local l__Crosshair__40 = u62.Crosshair;
local u64 = {
    LastShot = 0,
    BurstBullets = 0,
    NextShot = DateTime.now().UnixTimestampMillis,
    NextMobileShot = DateTime.now().UnixTimestampMillis
};
local u65 = {
    GunRecoil = l__SpringV3__21:create(5, 25, 3, 20),
    Cam = l__SpringV3__21:create(nil, 5, 2, 10),
    Sway = l__SpringV3__21:create(50, nil, 1, 10),
    Jump = l__SpringV3__21:create(100, nil, 0.4, 20)
};
local u66 = CFrame.new();
local u67 = 0;
local u68 = 0;
local u69 = 0;
local u70 = 0;
local u71 = true;
local l__Humanoid__41 = u1:WaitForChild("Humanoid");
local l__Head__42 = u1:WaitForChild("Head");
u1:WaitForChild("UpperTorso");
u1.LowerTorso:WaitForChild("Root");
local l__Neck__43 = l__Head__42:WaitForChild("Neck");
u1.RightUpperArm:WaitForChild("RightShoulder");
u1.LeftUpperArm:WaitForChild("LeftShoulder");
u1:WaitForChild("RightUpperLeg");
u1:WaitForChild("LeftUpperLeg");
u1.RightUpperLeg:WaitForChild("RightHip");
u1.LeftUpperLeg:WaitForChild("LeftHip");
local l__Y__44 = l__Neck__43.C0.Y;
local _ = l__Neck__43.C0.Y;
local l__PlayerGui__45 = l__LocalPlayer__2:WaitForChild("PlayerGui");
local l__CustomMobileGui__46 = l__PlayerGui__45:WaitForChild("CustomMobileGui");
local l__LeftFrame__47 = l__CustomMobileGui__46:WaitForChild("LeftFrame");
local l__RightFrame__48 = l__CustomMobileGui__46:WaitForChild("RightFrame");
local l__Buttons__49 = l__LeftFrame__47:WaitForChild("Buttons");
local l__Buttons__50 = l__RightFrame__48:WaitForChild("Buttons");
local l__ShootFrame__51 = l__CustomMobileGui__46:WaitForChild("ShootFrame");
local l__SprintButton__52 = l__CustomMobileGui__46:WaitForChild("SprintButton");
local l__ShopModule__53 = require(l__PlayerGui__45:WaitForChild("ShopGui"):WaitForChild("ShopModule"));
require(script:WaitForChild("DraggableObject"));
local u72 = {
    Jump = nil,
    Crouch = nil,
    NVG = nil,
    LeftShoot = nil,
    RightShoot = nil,
    ADS = nil,
    Reload = nil
};
local u73 = {
    Jump = l__Buttons__50:WaitForChild("Jump"),
    Crouch = l__Buttons__50:WaitForChild("Crouch"),
    NVG = l__Buttons__50:WaitForChild("NVG"),
    LeftShoot = l__Buttons__49:WaitForChild("Shoot"),
    RightShoot = l__Buttons__50:WaitForChild("Shoot"),
    ADS = l__Buttons__50:WaitForChild("ADS"),
    Reload = l__Buttons__50:WaitForChild("Reload")
};
local u74 = {
    FireAtAimOut = false,
    FireAfterAim = false,
    FireStarted = false,
    NormalAimInProgress = l__LocalPlayer__2:GetAttribute("adsShoot") or false
};
l__LocalPlayer__2:GetAttributeChangedSignal("adsShoot"):Connect(function() --[[ Line: 281 ]]
    -- upvalues: u74 (copy), l__LocalPlayer__2 (copy)
    u74.NormalAimInProgress = l__LocalPlayer__2:GetAttribute("adsShoot") or false;
end);
local u75 = require(l__LocalPlayer__2:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls();
local u76 = l__Humanoid__41:WaitForChild("Animator"):LoadAnimation(script:WaitForChild("SlideAnim"));
u76.Priority = Enum.AnimationPriority.Action;
u76.Looped = true;
l__UserInputService__4.MouseIconEnabled = true;
l__LocalPlayer__2.CameraMode = Enum.CameraMode.Classic;
l__CurrentCamera__3.CameraType = Enum.CameraType.Custom;
l__CurrentCamera__3.CameraSubject = l__Humanoid__41;
l__LocalPlayer__2.CameraMaxZoomDistance = game:GetService("StarterPlayer").CameraMaxZoomDistance;
l__LocalPlayer__2.CameraMinZoomDistance = game:GetService("StarterPlayer").CameraMinZoomDistance;
if l__Config__19.TeamTags then
    local v77 = l__Essential__15.TeamTag:clone();
    v77.Parent = u1;
    v77.Disabled = false;
end;
local function u80(p78, p79) --[[ Line: 310 ]]
    local l__Icon__54 = p78:WaitForChild("CircleButton"):WaitForChild("InnerFrame"):WaitForChild("Icon");
    local l__IconGradient__55 = l__Icon__54:WaitForChild("IconGradient");
    local l__TappedGradient__56 = l__Icon__54:WaitForChild("TappedGradient");
    l__IconGradient__55.Enabled = not p79;
    l__TappedGradient__56.Enabled = p79;
    p78:SetAttribute("Highlighted", p79);
end;
(function() --[[ Name: setupMobileButtons, Line 322 ]]
    -- upvalues: u80 (copy), u73 (copy)
    local function v86(u81) --[[ Line: 323 ]]
        -- upvalues: u80 (ref)
        if u81.Name == "Shoot" then
            local _ = u81.Position;
            u81:SetAttribute("AbsX", u81.AbsolutePosition.X);
            u81:SetAttribute("AbsY", u81.AbsolutePosition.Y);
            u81.InputChanged:Connect(function(p82, p83) --[[ Line: 329 ]]
                -- upvalues: u81 (copy)
                if p83 or (p82.UserInputType ~= Enum.UserInputType.Touch or not u81:GetAttribute("Highlighted")) then
                else
                    local l__Position__57 = p82.Position;
                    local v84 = u81:GetAttribute("AbsX");
                    local v85 = u81:GetAttribute("AbsY");
                    local l__AbsoluteSize__58 = u81.AbsoluteSize;
                    u81.Position = UDim2.new(u81.Position.X.Scale, l__Position__57.X - v84 - l__AbsoluteSize__58.X / 2, u81.Position.Y.Scale, l__Position__57.Y - v85 - l__AbsoluteSize__58.Y / 2);
                end;
            end);
        end;
        u81.MouseButton1Down:Connect(function() --[[ Line: 341 ]]
            -- upvalues: u80 (ref), u81 (copy)
            u80(u81, true);
        end);
        u81.InputEnded:Connect(function() --[[ Line: 344 ]]
            -- upvalues: u80 (ref), u81 (copy)
            u80(u81, false);
            u81.Position = UDim2.new(u81.Position.X.Scale, 0, u81.Position.Y.Scale, 0);
        end);
    end;
    for _, v87 in pairs(u73) do
        v87.Visible = false;
        v86(v87);
    end;
end)();
local function v91(p88) --[[ Line: 356 ]]
    -- upvalues: l__LeftFrame__47 (copy), l__RightFrame__48 (copy), u62 (ref)
    local v89 = p88 == Enum.UserInputType.Touch;
    l__LeftFrame__47.Visible = v89;
    l__RightFrame__48.Visible = v89;
    u62.MainFrame.Position = v89 and UDim2.new(1, -10, 0, 30) or UDim2.new(1, -10, 1, -10);
    local v90 = 1;
    u62.MainFrame.AnchorPoint = Vector2.new(v90, 1);
end;
v91(l__UserInputService__4:GetLastInputType());
l__UserInputService__4.LastInputTypeChanged:Connect(v91);
local function u102(p92, p93) --[[ Line: 370 ]]
    -- upvalues: u73 (copy), u7 (ref), u72 (copy)
    local function v97(p94, u95) --[[ Line: 371 ]]
        local u96 = {
            UserInputType = Enum.UserInputType.Touch
        };
        return {
            Tap = p94.MouseButton1Down:Connect(function() --[[ Line: 375 ]]
                -- upvalues: u95 (copy), u96 (copy)
                handleAction(u95, Enum.UserInputState.Begin, u96);
            end),
            Untap = p94.InputEnded:Connect(function() --[[ Line: 378 ]]
                -- upvalues: u95 (copy), u96 (copy)
                handleAction(u95, Enum.UserInputState.End, u96);
            end)
        };
    end;
    for _, v98 in ipairs(p92) do
        local v99 = u73[v98];
        v99.Visible = p93;
        if p93 then
            local v100 = v98 == "LeftShoot" and "Fire" or v98;
            u72[v98] = v97(v99, v100 == "RightShoot" and (u7.Type == "Grenade" and "Fire" or "ADSAndFire") or v100);
        else
            local v101 = u72[v98];
            if v101 then
                v101.Tap:Disconnect();
                v101.Untap:Disconnect();
                u72[v98] = nil;
            end;
        end;
    end;
end;
local function u103() --[[ Line: 416 ]]
    -- upvalues: u46 (ref), u50 (ref), u76 (copy), l__Control__36 (copy), u47 (copy), u70 (ref)
    if u46 then
        u50 = os.clock();
        u46:Disconnect();
        u46 = nil;
        u76:Stop(0.2);
        script:WaitForChild("Slide"):Stop();
        l__Control__36.setInProgress("Slide", false);
        u47.Enabled = false;
        u47.VectorVelocity = Vector3.new();
        u70 = 0;
        animateCameraOffset();
    end;
end;
function toggleRun(p104)
    -- upvalues: u103 (copy), l__Humanoid__41 (copy), l__CurrentCamera__3 (copy), l__LocalPlayer__2 (copy), l__Control__36 (copy), u25 (ref), u29 (ref), l__Events__12 (copy), u8 (ref), u80 (copy), l__SprintButton__52 (copy)
    if p104 then
        u103();
        local v105 = l__Humanoid__41.MoveDirection:Dot(l__CurrentCamera__3.CFrame.LookVector);
        if l__Humanoid__41.MoveDirection.Magnitude <= 0 or v105 <= 0.5 and l__LocalPlayer__2.CameraMode == Enum.CameraMode.LockFirstPerson then
            l__Control__36.queue("Sprint");
        else
            u25 = true;
            setWalkSpeed();
            u29 = 3;
            l__Events__12.GunStance:FireServer(u29, u8);
            SprintAnim();
        end;
    else
        u80(l__SprintButton__52, false);
        u25 = false;
        setWalkSpeed();
        u29 = 0;
        l__Events__12.GunStance:FireServer(u29, u8);
        IdleAnim();
    end;
end;
game:GetService("Players");
function isTouchInFrame(p106, p107)
    local l__Offset__59 = p107.Position.X.Offset;
    local l__Offset__60 = p107.Position.Y.Offset;
    return l__Offset__59 <= p106.Position.X and (p106.Position.X <= l__Offset__59 + p107.Size.X.Offset and (l__Offset__60 <= p106.Position.Y and p106.Position.Y <= l__Offset__60 + p107.Size.Y.Offset));
end;
function onTouch(p108, p109)
    -- upvalues: l__Humanoid__41 (copy), l__SprintButton__52 (copy), l__Control__36 (copy), u74 (copy), u80 (copy)
    if p108.UserInputType == Enum.UserInputType.Touch then
        if l__Humanoid__41 and (l__Humanoid__41.MoveDirection ~= Vector3.new() and (not l__SprintButton__52.Visible and p109)) then
            l__SprintButton__52.Visible = true;
            l__SprintButton__52.Position = UDim2.new(0, p108.Position.X - l__SprintButton__52.Size.X.Offset / 2, 0, p108.Position.Y - 125 - l__SprintButton__52.Size.Y.Offset / 2);
        else
            local _ = l__SprintButton__52.Position.X.Offset;
            local _ = l__SprintButton__52.Position.Y.Offset;
            if l__SprintButton__52.Visible and (isTouchInFrame(p108, l__SprintButton__52) and l__Control__36.performIfPossible("Sprint").canPerform) then
                u74.FireAfterAim = false;
                u80(l__SprintButton__52, true);
            end;
        end;
    end;
end;
function onTouchEnded(_, _)
    -- upvalues: u75 (copy), l__SprintButton__52 (copy), l__Control__36 (copy)
    if u75:GetMoveVector() == Vector3.new() then
        l__SprintButton__52.Visible = false;
        l__Control__36.stop("Sprint");
    end;
end;
l__UserInputService__4.TouchStarted:Connect(onTouch);
l__UserInputService__4.TouchMoved:Connect(onTouch);
l__UserInputService__4.TouchEnded:Connect(onTouchEnded);
function handleAction(p110, p111, p112)
    -- upvalues: u7 (ref), l__Control__36 (copy), u26 (ref), u50 (ref), l__ReplicatedConfig__27 (copy), u74 (copy), l__Players__1 (copy)
    if p110 == "Reload" and p111 == Enum.UserInputState.Begin then
        if u7.ShellInsert and l__Control__36.isInProgress("Reload") then
            l__Control__36.stop("Reload");
        else
            l__Control__36.performOrQueue("Reload");
        end;
    elseif p110 == "Sprint" and p111 == Enum.UserInputState.Begin then
        if p112.UserInputType ~= Enum.UserInputType.Gamepad1 then
            u26 = true;
        end;
        l__Control__36.performOrQueue("Sprint");
    elseif p110 == "Sprint" and (p111 == Enum.UserInputState.End or p111 == Enum.UserInputState.Cancel) then
        if p112.UserInputType ~= Enum.UserInputType.Gamepad1 then
            u26 = false;
            l__Control__36.stop("Sprint");
        end;
    else
        if p110 == "Jump" then
            l__Control__36.stop("Slide");
        else
            if p110 == "Crouch" and p111 == Enum.UserInputState.Begin then
                local v113;
                if os.clock() - u50 >= 1 then
                    v113 = l__ReplicatedConfig__27.FeatureToggles.SlidingEnabled;
                else
                    v113 = false;
                end;
                if u7 then
                    if v113 then
                        v113 = not u7.disableSlide;
                    end;
                end;
                if l__Control__36.isInProgress("Sprint") and (not l__Control__36.isInProgress("Slide") and v113) then
                    u50 = os.clock();
                    l__Control__36.performOrQueue("Slide");
                    return;
                elseif l__Control__36.isInProgress("Slide") then
                    l__Control__36.stop("Slide");
                    return;
                else
                    l__Control__36.performOrQueue("Crouch");
                    return;
                end;
            end;
            if p110 == "ADSAndFire" then
                if u74.NormalAimInProgress then
                    p110 = "Fire";
                elseif p111 == Enum.UserInputState.Begin then
                    if u7.ShootType == 3 or (u7.ShootType == 2 or u7.MobileAutoFire) then
                        u74.FireAfterAim = true;
                    else
                        u74.FireAtAimOut = true;
                    end;
                end;
            elseif p110 == "ADS" and p111 == Enum.UserInputState.Begin then
                u74.FireAfterAim = false;
                u74.FireAtAimOut = false;
            end;
        end;
        local v114 = ({
            CheckMag = "Inspect",
            CycleADS = "ADS",
            CycleAimpart = "AltAim",
            CycleFiremode = "CycleFireMode",
            ADSAndFire = "ADS"
        })[p110] or p110;
        if l__Control__36.exists(v114) then
            local v115 = {
                "Fire",
                "Sprint",
                "CycleADS",
                "CheckMag",
                "ADSAndFire"
            };
            if l__Players__1.LocalPlayer:GetAttribute("HoldAimEnabled") and (p112.UserInputType ~= Enum.UserInputType.Gamepad1 and p112.UserInputType ~= Enum.UserInputType.Touch) then
                table.insert(v115, "ADS");
            end;
            if p111 == Enum.UserInputState.Begin then
                l__Control__36.performOrQueue(v114);
            else
                if table.find(v115, p110) and (p111 == Enum.UserInputState.End or p111 == Enum.UserInputState.Cancel) then
                    if p110 == "Fire" and u7.Type == "Grenade" then
                        if l__Control__36.isInProgress("GrenadeThrow") then
                            return;
                        end;
                        if not l__Control__36.isInProgress("GrenadeCook") then
                            return;
                        end;
                        l__Control__36.performIfPossible("GrenadeThrow");
                    end;
                    if p110 == "Fire" and (u7 and (u7.ShootType == 2 and l__Control__36.isInProgress("Fire"))) then
                        return;
                    end;
                    l__Control__36.stop(v114);
                end;
            end;
        else
            warn(v114 .. " does not exist in ControlModule");
        end;
    end;
end;
local function u120(p116) --[[ Line: 619 ]]
    -- upvalues: u54 (ref), u35 (ref), u41 (ref), u38 (ref), u33 (ref), u34 (ref)
    for v117, v118 in pairs(p116.Mult or {}) do
        u54[v117] = u54[v117] * v118;
    end;
    local v119 = u54;
    v119.AimSens = v119.AimSens * (p116.AimSensMod == nil and 1 or (p116.AimSensMod or 1));
    if p116.AmmoCountOverride then
        u54.AmmoCountOverride = p116.AmmoCountOverride;
    end;
    if p116.CustomAnimations then
        u54.CustomAnimations = p116.CustomAnimations;
    end;
    if p116.SightZoom > 0 then
        u54.ZoomValue = p116.SightZoom;
    end;
    if p116.SightZoom2 > 0 then
        u54.Zoom2Value = p116.SightZoom2;
    end;
    if p116.EnableLaser then
        u35 = true;
    end;
    if p116.EnableFlashlight then
        u41 = true;
    end;
    if p116.InfraRed then
        u38 = true;
    end;
    if p116.IsSuppressor then
        u33 = true;
    end;
    if p116.IsFlashHider then
        u34 = true;
    end;
end;
function SetLaser()
    -- upvalues: u35 (ref), l__Config__19 (copy), u38 (ref), u36 (ref), u37 (ref), u40 (ref), u5 (ref), l__Events__12 (copy), u6 (ref)
    if not u35 then
        return;
    end;
    if l__Config__19.RealisticLaser and u38 then
        if u36 or u37 then
            if u36 and u37 then
                u37 = false;
            else
                u36 = false;
                u37 = false;
            end;
        else
            u36 = true;
            u37 = true;
        end;
    else
        u36 = not u36;
    end;
    if u36 and not u40 then
        for _, v121 in pairs(u5:GetDescendants()) do
            if v121:IsA("BasePart") and v121.Name == "LaserPoint" then
                local v122 = Instance.new("Part", v121);
                v122.Shape = "Ball";
                v122.Size = Vector3.new(0.2, 0.2, 0.2);
                v122.CanCollide = false;
                v122.Color = v121.Color;
                v122.Material = Enum.Material.Neon;
                local v123 = Instance.new("Attachment", v121);
                local v124 = Instance.new("Attachment", v122);
                local v125 = Instance.new("Beam", v122);
                v125.Transparency = NumberSequence.new(0);
                v125.LightEmission = 1;
                v125.LightInfluence = 1;
                v125.Attachment0 = v123;
                v125.Attachment1 = v124;
                v125.Color = ColorSequence.new(v121.Color);
                v125.FaceCamera = true;
                v125.Width0 = 0.01;
                v125.Width1 = 0.01;
                if l__Config__19.RealisticLaser then
                    v125.Enabled = false;
                end;
                u40 = v122;
                break;
            end;
        end;
    else
        for _, v126 in pairs(u5:GetDescendants()) do
            if v126:IsA("BasePart") and v126.Name == "LaserPoint" then
                v126:ClearAllChildren();
                break;
            end;
        end;
        u40 = nil;
        if l__Config__19.ReplicatedLaser then
            l__Events__12.SVLaser:FireServer(nil, 2, nil, false, u6);
        end;
    end;
    u5.Handle.Click:play();
end;
function SetTorch()
    -- upvalues: u41 (ref), u42 (ref), u5 (ref), l__Events__12 (copy), u6 (ref)
    if u41 then
        u42 = not u42;
        if u42 then
            for _, v127 in pairs(u5:GetDescendants()) do
                if v127:IsA("BasePart") and v127.Name == "FlashPoint" then
                    v127.Light.Enabled = true;
                end;
            end;
        else
            for _, v128 in pairs(u5:GetDescendants()) do
                if v128:IsA("BasePart") and v128.Name == "FlashPoint" then
                    v128.Light.Enabled = false;
                end;
            end;
        end;
        l__Events__12.SVFlash:FireServer(u6, u42);
        u5.Handle.Click:play();
    end;
end;
function ADS(p129)
    -- upvalues: l__CameraRotation__35 (copy), l__Control__36 (copy), u7 (ref), u5 (ref), u54 (ref), u61 (copy), l__Events__12 (copy), u29 (ref), u8 (ref), l__TweenService__7 (copy), l__Crosshair__40 (copy), l__Config__19 (copy), u74 (copy)
    l__CameraRotation__35.IsAimingDownSights = p129;
    if l__CameraRotation__35.IsTurret then
        l__Control__36.setInProgress("ADS", p129);
    elseif u7 and (u5 and u7.canAim ~= false) then
        local v130 = (u7.adsTime or 0.2) / u54.AdsTime;
        u61.AnimFinished = false;
        l__Control__36.setInProgress("ADS", p129);
        l__Control__36.isInProgress("NVG");
        l__Events__12.EditKillConditions:FireServer("Aiming", p129);
        if p129 then
            l__CameraRotation__35.SensMultiplier = 0.5 * u54.AimSens;
            u5.Handle.AimDown:Play();
            u29 = 2;
            l__Events__12.GunStance:FireServer(u29, u8);
            l__TweenService__7:Create(l__Crosshair__40.Up, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Down, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Left, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Right, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Center, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                ImageTransparency = 1
            }):Play();
        else
            l__CameraRotation__35.SensMultiplier = 1;
            if u5:FindFirstChild("Handle") == nil then
            else
                u5.Handle.AimUp:Play();
                u29 = 0;
                l__Events__12.GunStance:FireServer(u29, u8);
                if u7.CrossHair then
                    l__TweenService__7:Create(l__Crosshair__40.Up, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0
                    }):Play();
                    l__TweenService__7:Create(l__Crosshair__40.Down, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0
                    }):Play();
                    l__TweenService__7:Create(l__Crosshair__40.Left, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0
                    }):Play();
                    l__TweenService__7:Create(l__Crosshair__40.Right, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0
                    }):Play();
                end;
                if u7.CenterDot or l__Config__19.ForceCenterDot then
                    l__TweenService__7:Create(l__Crosshair__40.Center, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                        ImageTransparency = 0
                    }):Play();
                else
                    l__TweenService__7:Create(l__Crosshair__40.Center, TweenInfo.new(v130, Enum.EasingStyle.Linear), {
                        ImageTransparency = 1
                    }):Play();
                end;
                if u74.FireAtAimOut and u61.Progress >= 1 then
                    u74.FireAtAimOut = false;
                    l__Control__36.performIfPossible("Fire");
                end;
            end;
        end;
    end;
end;
function SetAimpart()
    -- upvalues: u30 (ref), u5 (ref), u31 (ref)
    if u30 == 1 then
        u30 = 2;
        if u5:FindFirstChild("AimPart2") then
            u31 = u5:FindFirstChild("AimPart2");
        end;
    else
        u30 = 1;
        u31 = u5:FindFirstChild("AimPart");
    end;
end;
function Firemode()
    -- upvalues: u5 (ref), u7 (ref)
    u5.Handle.SafetyClick:Play();
    if u7.ShootType == 1 and u7.FireModes.Burst == true then
        u7.ShootType = 2;
    elseif u7.ShootType == 1 and (u7.FireModes.Burst == false and u7.FireModes.Auto == true) then
        u7.ShootType = 3;
    elseif u7.ShootType == 2 and u7.FireModes.Auto == true then
        u7.ShootType = 3;
    elseif u7.ShootType == 2 and (u7.FireModes.Semi == true and u7.FireModes.Auto == false) then
        u7.ShootType = 1;
    elseif u7.ShootType == 3 and u7.FireModes.Semi == true then
        u7.ShootType = 1;
    else
        if u7.ShootType == 3 and (u7.FireModes.Semi == false and u7.FireModes.Burst == true) then
            u7.ShootType = 2;
        end;
    end;
end;
local u131 = nil;
local u132 = {
    Normal = nil,
    ADS = nil
};
task.spawn(function() --[[ Line: 837 ]]
    -- upvalues: l__UserInputService__4 (copy)
    local l__DialogGui__61 = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("DialogGui", 9999);
    if l__DialogGui__61 then
        repeat
            task.wait();
        until l__DialogGui__61.Enabled;
        repeat
            task.wait();
            l__UserInputService__4.MouseIconEnabled = true;
        until not l__DialogGui__61.Enabled;
        l__UserInputService__4.MouseIconEnabled = false;
    end;
end);
function setup(p133)
    -- upvalues: u1 (copy), u45 (ref), l__UserInputService__4 (copy), l__LocalPlayer__2 (copy), u6 (ref), u7 (ref), u8 (ref), u5 (ref), l__GunModels__17 (copy), l__Config__19 (copy), l__Events__12 (copy), l__Attachments__29 (copy), u54 (ref), u38 (ref), l__AttachmentsUtil__24 (copy), u120 (copy), u9 (ref), l__ArmModel__16 (copy), u10 (ref), u11 (ref), u12 (ref), u15 (ref), l__CurrentCamera__3 (copy), u131 (ref), u4 (ref), u3 (ref), l__PlayerGui__39 (copy), u13 (ref), u14 (ref), u55 (ref), u56 (ref), u57 (ref), u58 (ref), l__MuzzleFlash__31 (copy), l__TweenService__7 (copy), l__Crosshair__40 (copy), l__ContextActionService__5 (copy), u102 (copy), u16 (ref), u17 (ref), u31 (ref), l__Utilities__23 (copy), u32 (ref), l__CamosUtil__25 (copy), u35 (ref)
    if u1 and (u1:WaitForChild("Humanoid").Health > 0 and p133 ~= nil) then
        u45 = true;
        l__UserInputService__4.MouseIconEnabled = false;
        l__LocalPlayer__2.CameraMode = Enum.CameraMode.LockFirstPerson;
        u6 = p133;
        u7 = require(p133:WaitForChild("ACS_Settings"));
        u8 = require(p133:WaitForChild("ACS_Animations"));
        u5 = l__GunModels__17:WaitForChild(p133.Name):Clone();
        u5.PrimaryPart = u5:WaitForChild("Handle");
        if l__Config__19.ZeroCamRecoil then
            u7.camRecoil = {
                camRecoilUp = { 0, 0 },
                camRecoilTilt = { 0, 0 },
                camRecoilLeft = { 0, 0 },
                camRecoilRight = { 0, 0 }
            };
        end;
        if l__Config__19.NoAimSpreadMod then
            u7.AimSpreadMod = 1;
        end;
        l__Events__12.Equip:FireServer(p133.Name, 1);
        local function v141(p134) --[[ Line: 881 ]]
            -- upvalues: l__Attachments__29 (ref)
            local v135 = {
                "Optic",
                "Muzzle",
                "Foregrip",
                "Laser",
                "Ammo",
                "Barrel",
                "Stock",
                "Rear Grip"
            };
            local v136 = {};
            local v137 = p134:FindFirstChild("Customization");
            if not v137 then
                return {};
            end;
            for _, v138 in ipairs(v135) do
                local v139 = v137:GetAttribute(v138);
                if v139 then
                    local v140 = l__Attachments__29.attachments[v139];
                    if v140 then
                        v136[v138] = {
                            Name = v140.name,
                            Folder = v140.folder
                        };
                    end;
                end;
            end;
            return v136, v137:GetAttribute("Camo");
        end;
        u54.ZoomValue = u7.Zoom or l__Config__19.DefaultFOV;
        u54.Zoom2Value = u7.Zoom2 or l__Config__19.DefaultFOV;
        u38 = u7.InfraRed or false;
        local v142, v143 = v141(p133);
        u7.Attachments = v142;
        if p133.Name == "Kar98k" then
            u7.ShellInsert = u7.Attachments.Optic ~= nil;
        end;
        local v144 = {};
        for v145, v146 in pairs(u7.Attachments or {}) do
            local v147 = typeof(v146) == "string" and {
                Name = v146
            } or v146;
            local v148 = {
                Name = v147.Name,
                Folder = v147.Folder,
                Category = v145
            };
            table.insert(v144, v148);
            u120((require(l__AttachmentsUtil__24.getAttachmentModule(v148))));
        end;
        local v149 = u8 and u8.Keyframes;
        if v149 and true or v149 then
            u9 = l__ArmModel__16:WaitForChild(u54.CustomRig ~= 1 and u54.CustomRig or (u8.KeyframeRig or "KFArms")):Clone();
            u9.Name = "Viewmodel";
            u10 = u9.PrimaryPart;
            u11 = u9:WaitForChild("Left Arm");
            u12 = u9:WaitForChild("Right Arm");
            u11.CanCollide = false;
            u12.CanCollide = false;
            u15 = u9:WaitForChild("HumanoidRootPart"):WaitForChild("Handle");
            u10.Anchored = true;
            u9.Parent = l__CurrentCamera__3;
            local l__Animator__62 = u9:WaitForChild("Humanoid"):WaitForChild("Animator");
            local v150 = p133[u54.CustomAnimations or "Keyframes"];
            u131 = {};
            local v151 = {
                Gun = {
                    Equip = {},
                    FirstEquip = {},
                    Idle = { true, Enum.AnimationPriority.Idle },
                    Sprint = { true, Enum.AnimationPriority.Movement },
                    Inspect = {},
                    Reload = {},
                    EmptyReload = {}
                }
            };
            v151.Launcher = v151.Gun;
            v151.Stinger = v151.Launcher;
            v151.Grenade = {
                Equip = {},
                Idle = { true, Enum.AnimationPriority.Idle },
                RemovePin = {},
                ThrowIdle = { true, Enum.AnimationPriority.Idle },
                Throw = {}
            };
            for v152, v153 in v151[u7.Type] or v151.Gun do
                local v154, v155 = unpack(v153);
                if not v150:FindFirstChild(v152) then
                    error(v152 .. " not found for " .. u5.Name .. " | ACS_Framework");
                end;
                u131[v152] = l__Animator__62:LoadAnimation(v150[v152]);
                u131[v152].Looped = v154;
                if v155 == nil then
                    v155 = Enum.AnimationPriority.Action;
                end;
                u131[v152].Priority = v155;
            end;
            if v150:FindFirstChild("AdsReload") then
                local v156 = nil;
                u131.AdsReload = l__Animator__62:LoadAnimation(v150.AdsReload);
                u131.AdsReload.Looped = nil;
                if v156 == nil then
                    v156 = Enum.AnimationPriority.Action;
                end;
                u131.AdsReload.Priority = v156;
            end;
            if v150:FindFirstChild("AdsEmptyReload") then
                local v157 = nil;
                u131.AdsEmptyReload = l__Animator__62:LoadAnimation(v150.AdsEmptyReload);
                u131.AdsEmptyReload.Looped = nil;
                if v157 == nil then
                    v157 = Enum.AnimationPriority.Action;
                end;
                u131.AdsEmptyReload.Priority = v157;
            end;
            local l__Movement__63 = Enum.AnimationPriority.Movement;
            if v150:FindFirstChild("SlideLock") then
                u131.SlideLock = l__Animator__62:LoadAnimation(v150.SlideLock);
                u131.SlideLock.Looped = true;
                if l__Movement__63 == nil then
                    l__Movement__63 = Enum.AnimationPriority.Action;
                end;
                u131.SlideLock.Priority = l__Movement__63;
            end;
            if v150:FindFirstChild("Pump") then
                local v158 = nil;
                u131.Pump = l__Animator__62:LoadAnimation(v150.Pump);
                u131.Pump.Looped = nil;
                if v158 == nil then
                    v158 = Enum.AnimationPriority.Action;
                end;
                u131.Pump.Priority = v158;
            end;
            if v150:FindFirstChild("AdsPump") then
                local v159 = nil;
                u131.AdsPump = l__Animator__62:LoadAnimation(v150.AdsPump);
                u131.AdsPump.Looped = nil;
                if v159 == nil then
                    v159 = Enum.AnimationPriority.Action;
                end;
                u131.AdsPump.Priority = v159;
            end;
            local l__Action2__64 = Enum.AnimationPriority.Action2;
            if v150:FindFirstChild("Fire") then
                u131.Fire = l__Animator__62:LoadAnimation(v150.Fire);
                u131.Fire.Looped = false;
                if l__Action2__64 == nil then
                    l__Action2__64 = Enum.AnimationPriority.Action;
                end;
                u131.Fire.Priority = l__Action2__64;
            end;
            if v150:FindFirstChild("Reload2") then
                local v160 = nil;
                u131.Reload2 = l__Animator__62:LoadAnimation(v150.Reload2);
                u131.Reload2.Looped = nil;
                if v160 == nil then
                    v160 = Enum.AnimationPriority.Action;
                end;
                u131.Reload2.Priority = v160;
            end;
            if v150:FindFirstChild("Reload3") then
                local v161 = nil;
                u131.Reload3 = l__Animator__62:LoadAnimation(v150.Reload3);
                u131.Reload3.Looped = nil;
                if v161 == nil then
                    v161 = Enum.AnimationPriority.Action;
                end;
                u131.Reload3.Priority = v161;
            end;
            if v150:FindFirstChild("AdsReload2") then
                local v162 = nil;
                u131.AdsReload2 = l__Animator__62:LoadAnimation(v150.AdsReload2);
                u131.AdsReload2.Looped = nil;
                if v162 == nil then
                    v162 = Enum.AnimationPriority.Action;
                end;
                u131.AdsReload2.Priority = v162;
            end;
            if v150:FindFirstChild("AdsReload3") then
                local v163 = nil;
                u131.AdsReload3 = l__Animator__62:LoadAnimation(v150.AdsReload3);
                u131.AdsReload3.Looped = nil;
                if v163 == nil then
                    v163 = Enum.AnimationPriority.Action;
                end;
                u131.AdsReload3.Priority = v163;
            end;
            if v150:FindFirstChild("EmptyReload2") then
                local v164 = nil;
                u131.EmptyReload2 = l__Animator__62:LoadAnimation(v150.EmptyReload2);
                u131.EmptyReload2.Looped = nil;
                if v164 == nil then
                    v164 = Enum.AnimationPriority.Action;
                end;
                u131.EmptyReload2.Priority = v164;
            end;
            if v150:FindFirstChild("AdsEmptyReload2") then
                local v165 = nil;
                u131.AdsEmptyReload2 = l__Animator__62:LoadAnimation(v150.AdsEmptyReload2);
                u131.AdsEmptyReload2.Looped = nil;
                if v165 == nil then
                    v165 = Enum.AnimationPriority.Action;
                end;
                u131.AdsEmptyReload2.Priority = v165;
            end;
            if v150:FindFirstChild("ReloadLoop") then
                local v166 = nil;
                u131.ReloadLoop = l__Animator__62:LoadAnimation(v150.ReloadLoop);
                u131.ReloadLoop.Looped = nil;
                if v166 == nil then
                    v166 = Enum.AnimationPriority.Action;
                end;
                u131.ReloadLoop.Priority = v166;
            end;
            if v150:FindFirstChild("AdsReloadLoop") then
                local v167 = nil;
                u131.AdsReloadLoop = l__Animator__62:LoadAnimation(v150.AdsReloadLoop);
                u131.AdsReloadLoop.Looped = nil;
                if v167 == nil then
                    v167 = Enum.AnimationPriority.Action;
                end;
                u131.AdsReloadLoop.Priority = v167;
            end;
            if v150:FindFirstChild("ReloadOut") then
                local v168 = nil;
                u131.ReloadOut = l__Animator__62:LoadAnimation(v150.ReloadOut);
                u131.ReloadOut.Looped = nil;
                if v168 == nil then
                    v168 = Enum.AnimationPriority.Action;
                end;
                u131.ReloadOut.Priority = v168;
            end;
            if v150:FindFirstChild("AdsReloadOut") then
                local v169 = nil;
                u131.AdsReloadOut = l__Animator__62:LoadAnimation(v150.AdsReloadOut);
                u131.AdsReloadOut.Looped = nil;
                if v169 == nil then
                    v169 = Enum.AnimationPriority.Action;
                end;
                u131.AdsReloadOut.Priority = v169;
            end;
            if v150:FindFirstChild("ReloadIn") then
                local v170 = nil;
                u131.ReloadIn = l__Animator__62:LoadAnimation(v150.ReloadIn);
                u131.ReloadIn.Looped = nil;
                if v170 == nil then
                    v170 = Enum.AnimationPriority.Action;
                end;
                u131.ReloadIn.Priority = v170;
            end;
            if v150:FindFirstChild("AdsReloadIn") then
                local v171 = nil;
                u131.AdsReloadIn = l__Animator__62:LoadAnimation(v150.AdsReloadIn);
                u131.AdsReloadIn.Looped = nil;
                if v171 == nil then
                    v171 = Enum.AnimationPriority.Action;
                end;
                u131.AdsReloadIn.Priority = v171;
            end;
            local function u176(p172, p173) --[[ Line: 1017 ]]
                -- upvalues: u5 (ref)
                if u5 then
                    local v174 = u5:FindFirstChild("Animated") and u5.Animated:FindFirstChild(p173) or u5:FindFirstChild(p173);
                    if v174 then
                        if v174:IsA("BasePart") then
                            v174.Transparency = p172;
                        else
                            if v174:IsA("Model") or v174:IsA("Folder") then
                                for _, v175 in ipairs(v174:GetChildren()) do
                                    v175.Transparency = p172;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            for _, v177 in ipairs({
                "Reload",
                "Reload2",
                "Reload3",
                "EmptyReload",
                "EmptyReload2",
                "ReloadLoop",
                "ReloadOut"
            }) do
                local v178 = u131[v177];
                if v178 then
                    v178:GetMarkerReachedSignal("Sound"):Connect(function(p179) --[[ Line: 1035 ]]
                        -- upvalues: u7 (ref), u131 (ref), u4 (ref), u3 (ref), u6 (ref), l__PlayerGui__39 (ref)
                        if u7 then
                            if (p179 == "SlidePull" or p179 == "SlideRelease") and (u7.SlideLock and u131.SlideLock) then
                                u131.SlideLock:Stop(0);
                            end;
                            if p179 == "MagIn" then
                                local l__Ammo__65 = u7.Ammo;
                                if u4 <= 0 then
                                elseif u7.ShellInsert then
                                    u3 = u3 + 1;
                                    if u6 and u3 then
                                        l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                                    end;
                                    u4 = u4 - 1;
                                else
                                    if u7.IncludeChamberedBullet and u3 > 0 then
                                        l__Ammo__65 = l__Ammo__65 + 1;
                                    end;
                                    local v180 = math.min(u4, l__Ammo__65 - u3);
                                    u3 = u3 + v180;
                                    if u6 and u3 then
                                        l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                                    end;
                                    u4 = u4 - v180;
                                end;
                            end;
                        end;
                    end);
                end;
            end;
            for _, v181 in pairs(u131) do
                v181:GetMarkerReachedSignal("Sound"):Connect(function(p182) --[[ Line: 1061 ]]
                    -- upvalues: u5 (ref)
                    if u5 then
                        local v183 = u5:FindFirstChild("Bolt");
                        if p182 == "SlidePull" or p182 == "SlideRelease" then
                            v183 = v183 and v183:FindFirstChild(p182) or u5.Handle:FindFirstChild(p182);
                        else
                            local v184 = u5.Handle:FindFirstChild(p182);
                            if v184 then
                                v183 = v184;
                            elseif v183 then
                                v183 = v183:FindFirstChild(p182);
                            end;
                        end;
                        if v183 and v183:IsA("Sound") then
                            v183.TimePosition = v183:GetAttribute("StartFrom") or 0;
                            v183:Play();
                        end;
                    end;
                end);
                v181:GetMarkerReachedSignal("Transparency0"):Connect(function(p185) --[[ Line: 1078 ]]
                    -- upvalues: u176 (copy)
                    u176(0, p185);
                end);
                v181:GetMarkerReachedSignal("Transparency1"):Connect(function(p186) --[[ Line: 1081 ]]
                    -- upvalues: u176 (copy)
                    u176(1, p186);
                end);
            end;
        else
            u9 = l__ArmModel__16:WaitForChild("Arms"):Clone();
            u9.Name = "Viewmodel";
            u10 = Instance.new("Part", u9);
            u10.Size = Vector3.new(0.1, 0.1, 0.1);
            u10.Anchored = true;
            u10.CanCollide = false;
            u10.Transparency = 1;
            u9.PrimaryPart = u10;
            u13 = Instance.new("Motor6D", u10);
            u13.Name = "LeftArm";
            u13.Part0 = u10;
            u14 = Instance.new("Motor6D", u10);
            u14.Name = "RightArm";
            u14.Part0 = u10;
            u15 = Instance.new("Motor6D", u10);
            u15.Name = "Handle";
            u9.Parent = l__CurrentCamera__3;
            u55 = u8.MainCFrame;
            u56 = u8.GunCFrame;
            u57 = u8.LArmCFrame;
            u58 = u8.RArmCFrame;
            u11 = u9:WaitForChild("Left Arm");
            u13.Part1 = u11;
            u13.C0 = CFrame.new();
            u13.C1 = CFrame.new(1, -1, -5) * CFrame.Angles(0, 0, 0):inverse();
            u12 = u9:WaitForChild("Right Arm");
            u14.Part1 = u12;
            u14.C0 = CFrame.new();
            u14.C1 = CFrame.new(-1, -1, -5) * CFrame.Angles(0, 0, 0):inverse();
            u15.Part0 = u12;
            u11.Anchored = false;
            u12.Anchored = false;
        end;
        if l__Config__19.AirsoftBullets ~= true and u5.Handle:FindFirstChild("Muzzle") then
            for _, v187 in ipairs(l__MuzzleFlash__31:GetChildren()) do
                v187:Clone().Parent = u5.Handle.Muzzle;
            end;
        end;
        if u1:FindFirstChild("Body Colors") ~= nil then
            u1:WaitForChild("Body Colors"):Clone().Parent = u9;
        end;
        if u1:FindFirstChild("Shirt") ~= nil then
            u1:FindFirstChild("Shirt"):Clone().Parent = u9;
        end;
        local v188 = p133.Name == "Turret" and 1 or 0;
        u11.Transparency = v188;
        u12.Transparency = v188;
        if u7.CrossHair then
            l__TweenService__7:Create(l__Crosshair__40.Up, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 0
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Down, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 0
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Left, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 0
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Right, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 0
            }):Play();
            if u7.Bullets > 1 then
                l__Crosshair__40.Up.Rotation = 90;
                l__Crosshair__40.Down.Rotation = 90;
                l__Crosshair__40.Left.Rotation = 90;
                l__Crosshair__40.Right.Rotation = 90;
            else
                l__Crosshair__40.Up.Rotation = 0;
                l__Crosshair__40.Down.Rotation = 0;
                l__Crosshair__40.Left.Rotation = 0;
                l__Crosshair__40.Right.Rotation = 0;
            end;
        else
            l__TweenService__7:Create(l__Crosshair__40.Up, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Down, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Left, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
            l__TweenService__7:Create(l__Crosshair__40.Right, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                BackgroundTransparency = 1
            }):Play();
        end;
        if u7.CenterDot or l__Config__19.ForceCenterDot then
            l__TweenService__7:Create(l__Crosshair__40.Center, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                ImageTransparency = 0
            }):Play();
        else
            l__TweenService__7:Create(l__Crosshair__40.Center, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                ImageTransparency = 1
            }):Play();
        end;
        l__ContextActionService__5:BindAction("Fire", handleAction, false, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2);
        l__ContextActionService__5:BindAction("CycleADS", handleAction, false, Enum.KeyCode.ButtonL2);
        l__ContextActionService__5:BindAction("ADS", handleAction, false, Enum.UserInputType.MouseButton2);
        l__ContextActionService__5:BindAction("Reload", handleAction, false, Enum.KeyCode.R, Enum.KeyCode.ButtonX);
        l__ContextActionService__5:BindAction("CycleAimpart", handleAction, false, Enum.KeyCode.T, Enum.KeyCode.ButtonR3);
        l__ContextActionService__5:BindAction("CycleLaser", handleAction, false, Enum.KeyCode.H);
        l__ContextActionService__5:BindAction("CycleFlashlight", handleAction, false, Enum.KeyCode.J);
        l__ContextActionService__5:BindAction("CycleFiremode", handleAction, false, Enum.KeyCode.V);
        l__ContextActionService__5:BindAction("CheckMag", handleAction, false, Enum.KeyCode.M, Enum.KeyCode.ButtonY);
        local v189 = { "LeftShoot", "RightShoot", "Reload" };
        if u7.canAim then
            table.insert(v189, "ADS");
        end;
        u102(v189, true);
        if u7.MinSpread and (u7.MaxSpread and (u7.MinRecoilPower and u7.MaxRecoilPower)) then
            u16 = math.min(u7.MinSpread, u7.MaxSpread) * u54.HipSpread;
            u17 = math.min(u7.MinRecoilPower, u7.MaxRecoilPower);
        end;
        if u54.AmmoCountOverride and not u7.AmmoOverridden then
            u7.StoredAmmo = math.ceil(u7.StoredAmmo * u54.AmmoCountOverride / u7.Ammo);
            u7.Ammo = u54.AmmoCountOverride;
            u7.AmmoInGun = u54.AmmoCountOverride;
        end;
        u7.AmmoOverridden = true;
        u3 = u7.AmmoInGun;
        if u6 and u3 then
            l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
        end;
        u4 = l__Config__19.InfiniteAmmo and 999999999 or u7.StoredAmmo;
        u31 = u5:FindFirstChild("AimPart");
        for _, v190 in ipairs(u5:GetDescendants()) do
            if v190.Name == "MagWeld" then
                v190:Destroy();
            end;
            if v190:IsA("BasePart") then
                v190.Anchored = false;
                v190.CanCollide = false;
                local v191 = u8 and u8.Keyframes;
                if (not (v191 or v191) or v190.Parent.Name ~= "Animated" and (not v190.Parent.Parent or v190.Parent.Parent.Name ~= "Animated")) and (v190.Name ~= "Mag" and (v190.Name ~= "Handle" and (v190.Name ~= "RopeCrutch" and (v190.Name ~= "AimPart" and v190.Parent.Name ~= "Nodes")))) then
                    if v190.Name ~= "Bolt" and v190.Name ~= "Slide" then
                        local l__Handle__66 = u5.Handle;
                        if v190:FindFirstChild("WeldsToSlide") and u5:FindFirstChild("Slide") then
                            l__Handle__66 = u5.Slide;
                        elseif v190:FindFirstChild("WeldsToBolt") and u5:FindFirstChild("Bolt") then
                            l__Handle__66 = u5.Bolt;
                        end;
                        l__Utilities__23.Weld(l__Handle__66, v190);
                    end;
                    if v190.Name == "Bolt" or v190.Name == "Slide" then
                        local v192 = u8 and u8.Keyframes;
                        if not (v192 or v192) then
                            l__Utilities__23.WeldComplex(u5:WaitForChild("Handle"), v190, v190.Name);
                        end;
                    end;
                end;
            end;
        end;
        local v193 = l__AttachmentsUtil__24.loadAttachments(u5, v144);
        if v193 then
            u32 = v193.Optic;
        end;
        if v143 then
            l__CamosUtil__25.applyCamoToGun(u5, v143);
        end;
        local v194 = u8 and u8.Keyframes;
        if v194 and true or v194 then
            local v195 = false;
            local v196 = nil;
            for _, v197 in ipairs(u5:GetDescendants()) do
                if v197.Name == "Mag" then
                    if v197:IsA("BasePart") and not v195 then
                        v196 = v197;
                    elseif not (v195 or v197:IsA("Model")) then
                        v195 = true;
                        v196 = nil;
                    end;
                end;
                if v197.Parent.Name == "Nodes" or v197.Name == "AimPart" then
                    local l__Handle__67 = u5.Handle;
                    if v197:FindFirstChild("WeldsToSlide") and u5:FindFirstChild("Slide") then
                        l__Handle__67 = u5.Slide;
                    elseif v197:FindFirstChild("WeldsToBolt") and u5:FindFirstChild("Bolt") then
                        l__Handle__67 = u5.Bolt;
                    end;
                    l__Utilities__23.Weld(l__Handle__67, v197);
                end;
            end;
            local v198 = u5.Name == "Barrett 50C" and true or u5.Name == "P90";
            local l__Handle__68 = u5.Handle;
            for _, v199 in { u5:FindFirstChild("Slide"), u5:FindFirstChild("Bolt"), v196 } do
                if v199 and not l__Handle__68:FindFirstChild(v199.Name) then
                    l__Utilities__23.WeldKf(l__Handle__68, v199, v198);
                end;
            end;
            if v196 and (u8.UseTwoMags and not u54.CustomAnimations) then
                local v200 = u5:FindFirstChild("Animated") or Instance.new("Folder", u5);
                v200.Name = "Animated";
                local v201 = v196:Clone();
                v201.Parent = v200;
                v201.Name = "Mag2";
                v201.Anchored = false;
                v201.CanCollide = false;
            end;
            if u5:FindFirstChild("Animated") then
                for _, v202 in ipairs(u5.Animated:GetDescendants()) do
                    if v202:IsA("BasePart") and not (u5.Handle:FindFirstChild(v202.Name) or u5:FindFirstChild("Slide") and u5.Slide:FindFirstChild(v202.Name)) then
                        l__Utilities__23.WeldKf(l__Handle__68, v202, v198);
                    end;
                end;
            end;
            if u5.Handle:FindFirstChild("Speedloader") then
                u5.Handle.Speedloader.Part0 = u9.HumanoidRootPart;
            end;
        end;
        u15.Part1 = u5:WaitForChild("Handle");
        local v203 = u8 and u8.Keyframes;
        if v203 and true or v203 then
            u15.C1 = u8.KFGunCFrame or CFrame.new();
        else
            u15.C1 = u56;
        end;
        u5.Parent = u9;
        if u3 > 0 or u7.Type ~= "Gun" then
            if u7 and (u7.Type == "Launcher" or u7.Type == "Stinger") and u3 <= 0 then
                if u5:FindFirstChild("Rocket") then
                    u5.Rocket.Transparency = 1;
                end;
            elseif u7 and (u7.Type == "Grapple Hook" and u3 <= 0) then
                u5.Hook.Transparency = 1;
            end;
        end;
        if u5.Handle:FindFirstChild("Muzzle") then
            for _, v204 in ipairs(l__MuzzleFlash__31:GetChildren()) do
                v204:Clone().Parent = u5.Handle.Muzzle;
            end;
        end;
        if u35 then
            SetLaser();
        end;
        EquipAnim();
        if u7 then
            RunCheck();
        end;
    end;
end;
function unset(p205)
    -- upvalues: u6 (ref), u45 (ref), l__PlayerGui__45 (copy), l__JavelinGui__37 (copy), l__Events__12 (copy), u7 (ref), l__HeatseekModule__34 (copy), l__Control__36 (copy), u64 (copy), l__ContextActionService__5 (copy), u102 (copy), u74 (copy), l__ShootFrame__51 (copy), l__TweenService__7 (copy), l__CurrentCamera__3 (copy), l__Crosshair__40 (copy), l__UserInputService__4 (copy), l__CameraRotation__35 (copy), l__LocalPlayer__2 (copy), u5 (ref), u3 (ref), u4 (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u8 (ref), u32 (ref), u35 (ref), u36 (ref), u37 (ref), u41 (ref), u42 (ref), u39 (ref), u40 (ref), u16 (ref), u17 (ref), u33 (ref), u34 (ref), u43 (ref), u44 (ref), u29 (ref), u54 (ref), u53 (copy), u30 (ref), u131 (ref), u132 (ref), l__Config__19 (copy), u61 (copy)
    local v206 = p205 or u6;
    if v206 then
        u45 = false;
        if l__PlayerGui__45:FindFirstChild("JavelinNoise") then
            l__PlayerGui__45.JavelinNoise:Destroy();
        end;
        game.Lighting.JavelinCorrection.Enabled = false;
        l__JavelinGui__37.Enabled = false;
        l__Events__12.Equip:FireServer(v206.Name, 2);
        if v206.Name == "Grapple Hook" then
            l__Events__12.StopGrappling:FireServer();
        end;
        if u7.Type == "Stinger" then
            l__HeatseekModule__34.adsStopped();
        end;
        local v207 = l__PlayerGui__45:FindFirstChild("CustomToolbar");
        if v207 and u7.Type ~= "Grenade" then
            v207.Handler.ReloadState:Fire(v206, nil);
        end;
        l__Control__36.setInProgress("GrenadeCook", false);
        l__Control__36.setInProgress("GrenadeThrow", false);
        u64.Throwing = false;
        u64.BurstBullets = 0;
        l__ContextActionService__5:UnbindAction("Fire");
        l__ContextActionService__5:UnbindAction("ADS");
        l__ContextActionService__5:UnbindAction("CycleADS");
        l__ContextActionService__5:UnbindAction("Reload");
        l__ContextActionService__5:UnbindAction("CycleLaser");
        l__ContextActionService__5:UnbindAction("CycleLight");
        l__ContextActionService__5:UnbindAction("CycleFiremode");
        l__ContextActionService__5:UnbindAction("CycleAimpart");
        l__ContextActionService__5:UnbindAction("ZeroUp");
        l__ContextActionService__5:UnbindAction("ZeroDown");
        l__ContextActionService__5:UnbindAction("CheckMag");
        u102({
            "LeftShoot",
            "RightShoot",
            "ADS",
            "Reload"
        }, false);
        u74.FireAfterAim = false;
        u74.FireStarted = false;
        u74.FireAtAimOut = false;
        l__Control__36.reset();
        l__ShootFrame__51.Visible = false;
        l__TweenService__7:Create(l__CurrentCamera__3, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
            FieldOfView = 70
        }):Play();
        l__TweenService__7:Create(l__Crosshair__40.Up, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
            BackgroundTransparency = 1
        }):Play();
        l__TweenService__7:Create(l__Crosshair__40.Down, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
            BackgroundTransparency = 1
        }):Play();
        l__TweenService__7:Create(l__Crosshair__40.Left, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
            BackgroundTransparency = 1
        }):Play();
        l__TweenService__7:Create(l__Crosshair__40.Right, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
            BackgroundTransparency = 1
        }):Play();
        l__TweenService__7:Create(l__Crosshair__40.Center, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
            ImageTransparency = 1
        }):Play();
        l__UserInputService__4.MouseIconEnabled = true;
        l__CameraRotation__35.SensMultiplier = 1;
        l__CurrentCamera__3.CameraType = Enum.CameraType.Custom;
        l__LocalPlayer__2.CameraMode = Enum.CameraMode.Classic;
        if u5 then
            u7.AmmoInGun = u3;
            u7.StoredAmmo = u4;
            u9:Destroy();
            u9 = nil;
            u5 = nil;
            u6 = nil;
            u11 = nil;
            u12 = nil;
            u13 = nil;
            u14 = nil;
            u7 = nil;
            u8 = nil;
            u32 = nil;
            u35 = false;
            u36 = false;
            u37 = false;
            u41 = false;
            u42 = false;
            u39 = 0;
            u40 = nil;
            u16 = nil;
            u17 = nil;
            u33 = false;
            u34 = false;
            u43 = false;
            u44 = false;
            u29 = 0;
            u54 = setmetatable({}, u53);
            u30 = 1;
            u131 = nil;
            u132 = {};
            if l__Config__19.ReplicatedLaser then
                l__Events__12.SVLaser:FireServer(nil, 2, nil, false, u6);
            end;
            u61.Progress = 0;
            u61.AnimFinished = true;
        end;
    end;
end;
local u208 = false;
function HeadMovement()
    -- upvalues: u1 (copy), l__CurrentCamera__3 (copy), l__Neck__43 (copy), u208 (ref), l__Y__44 (copy), l__TweenService__7 (copy), l__Events__12 (copy)
    if u1.Humanoid.Health > 0 then
        local l__lookVector__69 = u1.HumanoidRootPart.CFrame:toObjectSpace(l__CurrentCamera__3.CFrame).lookVector;
        if l__Neck__43 and (u1.Humanoid.RigType == Enum.HumanoidRigType.R15 and (u1.Humanoid.Health > 0 and u1.Humanoid.PlatformStand == false)) then
            u208 = not u208;
            local v209 = CFrame.new(0, l__Y__44, 0) * CFrame.Angles(-math.asin(u1.UpperTorso.CFrame.lookVector.Y), -math.asin(l__lookVector__69.X / 1.15), 0) * CFrame.Angles(math.asin(l__lookVector__69.Y), 0, 0);
            l__TweenService__7:Create(l__Neck__43, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {
                C0 = v209
            }):Play();
            if u208 then
                l__Events__12.HeadRot:FireServer(v209);
            end;
        end;
    end;
end;
function renderCam()
    -- upvalues: l__CameraRotation__35 (copy), l__Humanoid__41 (copy), l__LocalPlayer__2 (copy), l__CurrentCamera__3 (copy)
    if not l__CameraRotation__35.IsTurret and (l__Humanoid__41.SeatPart and (l__LocalPlayer__2.CameraMode == Enum.CameraMode.LockFirstPerson or (l__CurrentCamera__3.CFrame.p - l__CurrentCamera__3.Focus.p).Magnitude < 0.6)) then
        local l__SeatPart__70 = l__Humanoid__41.SeatPart;
        local _, _, v210 = (l__SeatPart__70.CFrame - l__SeatPart__70.Position):toObjectSpace(l__CurrentCamera__3.CFrame - l__CurrentCamera__3.CFrame.Position):ToEulerAnglesYXZ();
        l__CurrentCamera__3.CFrame = l__CurrentCamera__3.CFrame * CFrame.Angles(0, 0, -v210);
    end;
    if l__CameraRotation__35.IsTurret then
        local l__Value__71 = (l__Humanoid__41.SeatPart:FindFirstChild("MaxRotAngle") or {}).Value;
        if not l__Value__71 then
            return;
        end;
        local v211 = l__Humanoid__41.SeatPart.Parent:FindFirstChild("AnchorPoint");
        local _, v212, _ = (v211.CFrame - v211.Position):toObjectSpace(l__CurrentCamera__3.CFrame - l__CurrentCamera__3.CFrame.Position):ToEulerAnglesYXZ();
        local v213 = math.rad(l__Value__71);
        local v214 = math.abs(v212) - v213;
        if v214 <= 0 then
            return;
        end;
        l__CurrentCamera__3.CFrame = l__CurrentCamera__3.CFrame * CFrame.Angles(0, v212 < 0 and v214 and v214 or -v214, 0);
    end;
end;
function Recoil()
    -- upvalues: u7 (ref), u54 (ref), l__Control__36 (copy), u65 (copy), u17 (ref)
    local v215 = math.random(u7.camRecoil.camRecoilUp[1], u7.camRecoil.camRecoilUp[2]) / 2 * u54.VerticalRecoil;
    local v216 = math.random(u7.camRecoil.camRecoilLeft[1], u7.camRecoil.camRecoilLeft[2]) * u54.HorizontalRecoil;
    local v217 = math.random(u7.camRecoil.camRecoilRight[1], u7.camRecoil.camRecoilRight[2]) * u54.HorizontalRecoil;
    local v218 = math.random(-v217, v216) / 2;
    local v219 = math.random(u7.camRecoil.camRecoilTilt[1], u7.camRecoil.camRecoilTilt[2]) / 2;
    local v220 = v215 * (math.random(10, 10) / 10);
    local v221 = math.rad(v220);
    local v222 = v218 * (math.random(-10, 10) / 10);
    local v223 = math.rad(v222);
    local v224 = v219 * (math.random(-10, 10) / 10);
    local v225 = math.rad(v224);
    local v226 = math.random(u7.gunRecoil.gunRecoilUp[1], u7.gunRecoil.gunRecoilUp[2]) / 10 * u54.VerticalRecoil;
    local v227 = math.random(-1, 1) * math.random(u7.gunRecoil.gunRecoilTilt[1], u7.gunRecoil.gunRecoilTilt[2]) / 10;
    local v228 = math.random(u7.gunRecoil.gunRecoilLeft[1], u7.gunRecoil.gunRecoilLeft[2]) * u54.HorizontalRecoil;
    local v229 = math.random(u7.gunRecoil.gunRecoilRight[1], u7.gunRecoil.gunRecoilRight[2]) * u54.HorizontalRecoil;
    local v230 = math.random(-v229, v228) / 10;
    local v231 = l__Control__36.isInProgress("ADS") and u7.AimRecoilReduction or 1;
    u65.Cam:shove((Vector3.new(v221 / 1.5, v223, v225)));
    local l__GunRecoil__72 = u65.GunRecoil;
    local v232 = math.rad(v226 * u17 / v231);
    local v233 = math.rad(v230 * u17 / v231);
    local v234 = math.rad(v227 / v231);
    l__GunRecoil__72:shove((Vector3.new(v232, v233, v234)));
end;
local function u250(p235) --[[ Line: 1554 ]]
    -- upvalues: l__CurrentCamera__3 (copy), u5 (ref), u7 (ref), u6 (ref), l__Players__1 (copy), u1 (copy), u9 (ref), l__HeatseekModule__34 (copy), u61 (copy), u16 (ref), l__Config__19 (copy), u24 (ref), u10 (ref), l__ShootModule__33 (copy), l__LocalPlayer__2 (copy), l__Events__12 (copy)
    local v236 = p235 and l__CurrentCamera__3.CFrame or u5.Handle.Muzzle.WorldCFrame;
    local l__Position__73 = v236.Position;
    local v237 = p235 and (not u7.CustomShellType or u7.CustomShellType == "Bullet") and "Invisible" or u7.CustomShellName;
    local v238 = {
        currentPenetrationCount = 0,
        weaponName = u6.Name,
        bulletID = l__Players__1.LocalPlayer.Name .. l__Players__1.LocalPlayer.UserId .. tick() .. math.random(111, 999) .. math.random(111, 999),
        maxPenetrationCount = u7.maxPenetrationCount or 3,
        penetrationMultiplier = u7.penetrationMultiplier or 0.8,
        shellType = u7.CustomShellType or "Bullet",
        shellName = u7.CustomShellName,
        localShellName = v237,
        shellSpeed = u7.MuzzleVelocity,
        shellMaxDist = u7.ShellMaxDist or 7000,
        filterDescendants = { u1, u9 },
        origin = l__Position__73
    };
    if u7.Type == "Stinger" then
        local v239 = l__HeatseekModule__34.getLockedTarget();
        if not v239 then
            return;
        end;
        v238.moverType = u6:GetAttribute("PathType") or "Stinger";
        v238.lockedTarget = v239;
        l__HeatseekModule__34.tellTargetAboutIncomingProjectile();
    end;
    local l__WalkMult__74 = u7.WalkMult;
    local v240 = math.min(1, 1 - u61.Progress + (u7.AimSpreadMod or 0));
    local v241 = u16 / 10;
    if not l__Config__19.SpreadModsAreOnlyVisual then
        v241 = v241 + u24 * l__WalkMult__74 / 10;
    end;
    local l__Angles__75 = CFrame.Angles;
    local v242 = math.random(-v241 * 1, v241 * 1) / 1 * v240;
    local v243 = math.rad(v242);
    local v244 = math.random(-v241 * 1, v241 * 1) / 1 * v240;
    local v245 = math.rad(v244);
    local v246 = math.random(-v241 * 1, v241 * 1) / 1 * v240;
    local v247 = l__Angles__75(v243, v245, (math.rad(v246)));
    local v248;
    if u6.Name == ".44 Magnum" then
        v248 = false;
    else
        v248 = (v236.LookVector - u10.CFrame.LookVector).Magnitude < 0.2;
    end;
    if v248 then
        v236 = u10.CFrame or v236;
    end;
    local v249 = v247 * v236.LookVector;
    l__ShootModule__33.fire(l__LocalPlayer__2, l__Position__73, v249, v238);
    l__Events__12.ServerBullet:FireServer(l__Position__73, v249, v238);
end;
local function u261(p251) --[[ Line: 1606 ]]
    -- upvalues: l__CurrentCamera__3 (copy), u7 (ref), u6 (ref), l__Players__1 (copy), u1 (copy), u9 (ref), u5 (ref), u61 (copy), u16 (ref), l__Config__19 (copy), u24 (ref), u10 (ref), l__Events__12 (copy)
    local l__CFrame__76 = l__CurrentCamera__3.CFrame;
    local l__Position__77 = l__CFrame__76.Position;
    local l__CustomShellName__78 = u7.CustomShellName;
    local v252 = {
        maxPenetrationCount = 0,
        currentPenetrationCount = 0,
        penetrationMultiplier = 0,
        shellType = "Grenade",
        bounceCount = 1,
        shellMaxDist = 1000,
        weaponName = u6.Name,
        bulletID = l__Players__1.LocalPlayer.Name .. l__Players__1.LocalPlayer.UserId .. tick() .. math.random(111, 999) .. math.random(111, 999),
        shellName = u7.CustomShellName,
        localShellName = l__CustomShellName__78,
        shellSpeed = u7.MuzzleVelocity,
        filterDescendants = { u1, u9 },
        origin = u5.Handle.Position,
        explodeTime = p251
    };
    local l__WalkMult__79 = u7.WalkMult;
    local v253 = math.min(1, 1 - u61.Progress + (u7.AimSpreadMod or 0));
    local v254 = u16 / 10;
    if not l__Config__19.SpreadModsAreOnlyVisual then
        v254 = v254 + u24 * l__WalkMult__79 / 10;
    end;
    local l__Angles__80 = CFrame.Angles;
    local v255 = math.random(-v254 * 1, v254 * 1) / 1 * v253;
    local v256 = math.rad(v255);
    local v257 = math.random(-v254 * 1, v254 * 1) / 1 * v253;
    local v258 = math.rad(v257);
    local v259 = math.random(-v254 * 1, v254 * 1) / 1 * v253;
    local v260 = l__Angles__80(v256, v258, (math.rad(v259)));
    if (l__CFrame__76.LookVector - u10.CFrame.LookVector).Magnitude < 0.2 then
        l__CFrame__76 = u10.CFrame or l__CFrame__76;
    end;
    l__Events__12.ServerGrenade:FireServer(l__Position__77, v260 * l__CFrame__76.LookVector, v252);
end;
function meleeCast()
    -- upvalues: u6 (ref), u1 (copy), u9 (ref), l__ShootModule__33 (copy), l__LocalPlayer__2 (copy), l__Events__12 (copy)
    local l__Position__81 = workspace.CurrentCamera.CFrame.Position;
    local l__LookVector__82 = workspace.CurrentCamera.CFrame.LookVector;
    local v262 = {
        shellType = "Melee",
        shellName = "DefaultMelee",
        shellSpeed = 100,
        shellMaxDist = 4,
        weaponName = u6.Name,
        filterDescendants = { u1, u9 },
        origin = l__Position__81
    };
    l__ShootModule__33.fire(l__LocalPlayer__2, l__Position__81, l__LookVector__82, v262);
    l__Events__12.ServerBullet:FireServer(l__Position__81, l__LookVector__82, v262);
end;
function stopGrapple()
    -- upvalues: l__Events__12 (copy)
    l__Events__12.StopGrappling:FireServer();
end;
local u263 = {
    "ApcSeat",
    "HeliSeat",
    "TankSeat",
    "GunnerSeat"
};
function UpdateGui()
    -- upvalues: l__Humanoid__41 (copy), u263 (copy), u62 (ref), u7 (ref), u3 (ref), u64 (copy), l__Config__19 (copy), u4 (ref)
    local l__SeatPart__83 = l__Humanoid__41.SeatPart;
    if l__SeatPart__83 then
        l__SeatPart__83 = table.find(u263, l__Humanoid__41.SeatPart.Name);
    end;
    if l__SeatPart__83 then
    elseif u62 then
        local l__Gun__84 = u62.MainFrame.Gun;
        local v264 = u7;
        if v264 then
            v264 = u7.EnableHUD;
        end;
        l__Gun__84.Visible = v264;
        if u7 then
            local v265 = (u7.Jammed or u3 == 0) and 0 or 255;
            l__Gun__84.Ammo.TextColor3 = Color3.fromRGB(255, v265, v265);
            if u7.Type == "Grenade" then
                l__Gun__84.Ammo.Text = (u64.NextGrenade or 0) > workspace:GetServerTimeNow() and "0" or "1";
                l__Gun__84.StoredAmmo.Text = "1";
            elseif u7.HideAmmo then
                l__Gun__84.Ammo.Text = "";
                l__Gun__84.StoredAmmo.Text = "";
            else
                l__Gun__84.Ammo.Text = u3 or 0;
                l__Gun__84.StoredAmmo.Text = l__Config__19.InfiniteAmmo and u7.Ammo or (u4 or 0);
            end;
        end;
    end;
end;
function CheckMagFunction()
    -- upvalues: u29 (ref), l__Events__12 (copy), u8 (ref)
    u29 = 0;
    l__Events__12.GunStance:FireServer(u29, u8);
    MagCheckAnim();
    local v266 = u8 and u8.Keyframes;
    if not (v266 or v266) then
        RunCheck();
    end;
end;
function Grenade()
    -- upvalues: u43 (ref), u44 (ref)
    if not u43 then
        u43 = true;
        GrenadeReady();
        repeat
            task.wait();
        until not u44;
        TossGrenade();
    end;
end;
function TossGrenade()
    -- upvalues: u6 (ref), u7 (ref), u43 (ref), u19 (copy), l__LocalPlayer__2 (copy), l__Events__12 (copy), l__CurrentCamera__3 (copy)
    if u6 and (u7 and u43 == true) then
        local v267 = u19 .. "-" .. l__LocalPlayer__2.UserId;
        GrenadeThrow();
        if u6 and u7 then
            l__Events__12.Grenade:FireServer(u6, u7, l__CurrentCamera__3.CFrame, l__CurrentCamera__3.CFrame.LookVector, 150, v267);
            unset();
        end;
    end;
end;
function JamChance()
    -- upvalues: u7 (ref), u3 (ref), u5 (ref)
    if u7.CanBreak == true and (not u7.Jammed and (u3 - 1 > 0 and math.random(1000) <= 2)) then
        u7.Jammed = true;
        u5.Handle.Click:Play();
    end;
end;
function Jammed()
    -- upvalues: u7 (ref), l__Control__36 (copy), u29 (ref), l__Events__12 (copy), u8 (ref)
    if u7.Type == "Gun" and u7.Jammed then
        l__Control__36.setInProgress("Reload", true);
        u29 = 0;
        l__Events__12.GunStance:FireServer(u29, u8);
        JammedAnim();
        u7.Jammed = false;
        l__Control__36.setInProgress("Reload", false);
        local v268 = u8 and u8.Keyframes;
        if not (v268 or v268) then
            RunCheck();
        end;
    end;
end;
function Reload()
    -- upvalues: u7 (ref), u4 (ref), u3 (ref), l__Control__36 (copy), u64 (copy), u29 (ref), l__Events__12 (copy), u8 (ref), u132 (ref), u131 (ref), u54 (ref), u6 (ref), l__PlayerGui__39 (copy), u27 (ref)
    if (u7.Type == "Gun" or (u7.Type == "Stinger" or (u7.Type == "Launcher" or u7.Type == "Grapple Hook"))) and (u4 > 0 and (u3 < u7.Ammo or u7.IncludeChamberedBullet and u3 < u7.Ammo + 1)) then
        if u7.Type == "Grapple Hook" then
            stopGrapple();
        end;
        l__Control__36.setInProgress("Reload", true);
        u64.BurstBullets = 0;
        u29 = 0;
        l__Events__12.GunStance:FireServer(u29, u8);
        if u7.ShellInsert then
            local function v275(p269, p270, p271) --[[ Line: 1773 ]]
                -- upvalues: u132 (ref), u131 (ref), l__Control__36 (ref), u54 (ref)
                u132.Normal = u131[p269.normal];
                u132.ADS = u131[p269.ads];
                if p271 then
                    u131[p269.normal].Looped = true;
                    (u131[p269.ads] or {}).Looped = true;
                end;
                local v272 = l__Control__36.isInProgress("ADS");
                local v273 = not u132.ADS and 1 or (v272 and 0.001 or 1);
                local v274 = v272 and 1 or 0.001;
                local l__ReloadSpeed__85 = u54.ReloadSpeed;
                u131[p269.normal]:Play(0.01, v273, l__ReloadSpeed__85);
                if u132.ADS then
                    u131[p269.ads]:Play(0.01, v274, l__ReloadSpeed__85);
                end;
                if p270 then
                    u131[p269.normal].Stopped:Wait();
                end;
            end;
            local v276 = u8 and u8.Keyframes;
            if v276 and true or v276 then
                if u3 > 0 or u7.NoTacticalReload then
                    ReloadAnim();
                else
                    TacticalReloadAnim();
                end;
                v275({
                    normal = "ReloadLoop",
                    ads = "AdsReloadLoop"
                }, false, true);
                while u4 > 0 and (u3 < u7.Ammo and not u27) do
                    task.wait();
                end;
                u131.ReloadLoop.Looped = false;
                u131.AdsReloadLoop.Looped = false;
                u131.ReloadLoop.Stopped:Wait();
                v275({
                    normal = "ReloadOut",
                    ads = "AdsReloadOut"
                }, true);
            elseif u3 > 0 then
                for _ = 1, u7.Ammo - u3 do
                    if u4 > 0 and u3 < u7.Ammo then
                        if u27 then
                            break;
                        end;
                        ReloadAnim();
                        local v277 = u8 and u8.Keyframes;
                        if not (v277 or v277) then
                            u3 = u3 + 1;
                            if u6 and u3 then
                                l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                            end;
                            u4 = u4 - 1;
                        end;
                    end;
                end;
            else
                TacticalReloadAnim();
                local v278 = u8 and u8.Keyframes;
                if not (v278 or v278) then
                    u3 = u3 + 1;
                    if u6 and u3 then
                        l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                    end;
                    u4 = u4 - 1;
                end;
                for _ = 1, u7.Ammo - u3 do
                    if u4 > 0 and u3 < u7.Ammo then
                        if u27 then
                            break;
                        end;
                        ReloadAnim();
                        local v279 = u8 and u8.Keyframes;
                        if not (v279 or v279) then
                            u3 = u3 + 1;
                            if u6 and u3 then
                                l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                            end;
                            u4 = u4 - 1;
                        end;
                    end;
                end;
            end;
        else
            if u3 > 0 then
                ReloadAnim();
            else
                TacticalReloadAnim();
            end;
            local v280 = u8 and u8.Keyframes;
            if not (v280 or v280) then
                local l__Ammo__86 = u7.Ammo;
                if u7.IncludeChamberedBullet and u3 > 0 then
                    l__Ammo__86 = l__Ammo__86 + 1;
                end;
                local v281 = math.min(u4, l__Ammo__86 - u3);
                u3 = u3 + v281;
                if u6 and u3 then
                    l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                end;
                u4 = u4 - v281;
            end;
        end;
        u27 = false;
        l__Control__36.setInProgress("Reload", false);
        local v282 = u8 and u8.Keyframes;
        if not (v282 or v282) then
            RunCheck();
        end;
    end;
end;
function GunFx()
    -- upvalues: l__CameraRotation__35 (copy), l__Humanoid__41 (copy), u5 (ref), l__Config__19 (copy), u33 (ref), u34 (ref), u16 (ref), u7 (ref), u17 (ref), u18 (ref), u8 (ref), u3 (ref), l__TweenService__7 (copy), u131 (ref)
    local v283 = l__CameraRotation__35.IsTurret and l__Humanoid__41.SeatPart.Parent.Parent.gun.base or u5.Handle;
    local l__Muzzle__87 = v283.Muzzle;
    if l__Config__19.AirsoftBullets or u33 == true then
        local v284 = l__Muzzle__87.Supressor:Clone();
        v284.PlaybackSpeed = v284.PlaybackSpeed * 0.95 + math.random() * 0.1 * v284.PlaybackSpeed;
        v284.Parent = script;
        v284.PlayOnRemove = true;
        v284:Destroy();
    else
        local v285 = l__Muzzle__87.Fire:Clone();
        v285.PlaybackSpeed = v285.PlaybackSpeed * 0.95 + math.random() * 0.1 * v285.PlaybackSpeed;
        v285.Parent = script;
        v285.PlayOnRemove = true;
        v285:Destroy();
    end;
    if u34 and l__Muzzle__87:FindFirstChild("RealisticSmoke") then
        local l__RealisticSmoke__88 = l__Muzzle__87.RealisticSmoke;
        local u286 = l__RealisticSmoke__88:GetAttribute("EmitCount");
        local v287 = l__RealisticSmoke__88:GetAttribute("EmitDelay");
        delay(v287, function(_) --[[ Line: 1890 ]]
            -- upvalues: l__RealisticSmoke__88 (copy), u286 (copy)
            l__RealisticSmoke__88:Emit(u286);
        end);
    elseif not u33 then
        for _, u288 in ipairs({ l__Muzzle__87:FindFirstChild("Flare"), l__Muzzle__87:FindFirstChild("Muzzle"), l__Muzzle__87:FindFirstChild("RealisticSmoke") }) do
            if u288 then
                local u289 = u288:GetAttribute("EmitCount");
                local v290 = u288:GetAttribute("EmitDelay");
                delay(v290, function(_) --[[ Line: 1900 ]]
                    -- upvalues: u288 (copy), u289 (copy)
                    u288:Emit(u289);
                end);
            end;
        end;
    end;
    if u16 then
        u16 = math.min(u7.MaxSpread, u16 + (u7.AimInaccuracyStepAmount or 0));
        u17 = math.min(u7.MaxRecoilPower, u17 + u7.RecoilPowerStepAmount);
    end;
    u18 = time();
    if not l__CameraRotation__35.IsTurret then
        local v291 = u8 and u8.Keyframes;
        if not (v291 or v291) then
            if u3 > 0 or not u7.SlideLock then
                l__TweenService__7:Create(u5.Handle.Slide, TweenInfo.new(30 / u7.ShootRate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true, 0), {
                    C0 = u7.SlideEx:inverse()
                }):Play();
            elseif u3 <= 0 and u7.SlideLock then
                l__TweenService__7:Create(u5.Handle.Slide, TweenInfo.new(30 / u7.ShootRate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
                    C0 = u7.SlideEx:inverse()
                }):Play();
            end;
        end;
    end;
    local v292 = u8 and u8.Keyframes;
    if (v292 and true or v292) and u131.SlideLock then
        local u293 = 30 / math.max(u7.ShootRate, 900);
        if u3 > 0 or not u7.SlideLock then
            u131.SlideLock:Stop(0);
            u131.SlideLock:Play(u293);
            task.spawn(function() --[[ Line: 1926 ]]
                -- upvalues: u293 (copy), u131 (ref)
                task.wait(u293);
                if u131 and (u131.SlideLock and u131.SlideLock.IsPlaying) then
                    u131.SlideLock:Stop(u293);
                end;
            end);
        elseif u3 <= 0 and u7.SlideLock then
            u131.SlideLock:Stop(0);
            u131.SlideLock:Play(u293);
        end;
    end;
    if not l__Config__19.AirsoftBullets then
        if v283.Chamber:FindFirstChild("Smoke") then
            v283.Chamber.Smoke:Emit(10);
        end;
        if v283.Chamber:FindFirstChild("Shell") then
            v283.Chamber.Shell:Emit(1);
        end;
    end;
end;
function GrappleFx()
    -- upvalues: u5 (ref)
    u5.Hook.Transparency = 1;
    u5.Handle.Muzzle.Fire:Play();
end;
function LauncherFx()
    -- upvalues: u5 (ref)
    u5.Handle.Muzzle.Fire:Play();
    u5.Handle.Muzzle.Smoke:Emit(10);
    if u5:FindFirstChild("Rocket") then
        u5.Rocket.Transparency = 1;
    end;
end;
local u294 = {
    Length = 5,
    Params = RaycastParams.new()
};
u294.Params.CollisionGroup = "CamCast";
u294.Params.FilterType = Enum.RaycastFilterType.Exclude;
u294.Params.FilterDescendantsInstances = { workspace:WaitForChild("CosmeticShellsFolder"), u1 };
u294.Params.IgnoreWater = true;
function Shoot()
    -- upvalues: u7 (ref), l__UserInputService__4 (copy), l__Control__36 (copy), l__CurrentCamera__3 (copy), u294 (copy), u64 (copy), u3 (ref), u5 (ref), l__Events__12 (copy), u6 (ref), u33 (ref), u34 (ref), u250 (copy), l__PlayerGui__39 (copy), l__Thread__22 (copy), l__HeatseekModule__34 (copy)
    if u7 then
        local l__TouchEnabled__89 = l__UserInputService__4.TouchEnabled;
        if l__TouchEnabled__89 then
            l__TouchEnabled__89 = not l__UserInputService__4.MouseEnabled;
        end;
        local v295 = l__Control__36.isInProgress("ADS");
        if not v295 then
            local v296 = workspace:Raycast(l__CurrentCamera__3.CFrame.Position, l__CurrentCamera__3.CFrame.LookVector * u294.Length, u294.Params);
            if v296 and v296.Position then
                v295 = v296 and v296.Position;
                if v295 then
                    v295 = (v296.Position - l__CurrentCamera__3.CFrame.Position).Magnitude < u294.Length;
                end;
            end;
        end;
        if u7.Type == "Grenade" or (l__TouchEnabled__89 and u64.NextMobileShot or u64.NextShot) <= DateTime.now().UnixTimestampMillis then
            if u7.Type == "Gun" then
                if u3 <= 0 or u7.Jammed then
                    u5.Handle.Click:Play();
                    l__Control__36.performOrQueue("Reload");
                    return;
                end;
                l__Control__36.setInProgress("Fire", true);
                local v297 = 60000 / u7.ShootRate;
                local v298 = u7.ShootType == 1 and u7.MobileAutoFire and 2 or 1;
                local l__UnixTimestampMillis__90 = DateTime.now().UnixTimestampMillis;
                u64.NextShot = l__UnixTimestampMillis__90 + v297;
                u64.NextMobileShot = l__UnixTimestampMillis__90 + v297 * v298;
                u64.LastShot = l__UnixTimestampMillis__90;
                if u7.ShootType == 2 then
                    if u64.BurstBullets <= 0 then
                        u64.BurstBullets = u7.BurstShot - 1;
                    else
                        local v299 = u64;
                        v299.BurstBullets = v299.BurstBullets - 1;
                    end;
                end;
                l__Events__12.Atirar:FireServer(u6, u33, u34);
                for _ = 1, u7.Bullets do
                    u250(v295);
                end;
                u3 = u3 - 1;
                if u6 and u3 then
                    l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                end;
                GunFx();
                JamChance();
                l__Thread__22:Spawn(Recoil);
                if u3 <= 0 then
                    l__Control__36.setInProgress("Fire", false);
                    l__Control__36.performOrQueue("Reload");
                    return;
                end;
                if u7.ShootType == 4 or u7.ShootType == 5 then
                    l__Control__36.setInProgress("Fire", false);
                    l__Control__36.performOrQueue("Pump");
                end;
                if u7.ShootType == 2 and u64.BurstBullets == 0 then
                    l__Control__36.setInProgress("Fire", false);
                end;
                if u64.BurstBullets > 0 or (u7.ShootType == 3 or l__TouchEnabled__89 and u7.MobileAutoFire) then
                    l__Control__36.queue("Fire");
                end;
            else
                if u7.Type == "Melee" then
                    l__Control__36.setInProgress("Fire", true);
                    local v300 = 60000 / u7.ShootRate;
                    u64.NextShot = DateTime.now().UnixTimestampMillis + v300;
                    meleeCast();
                    meleeAttack();
                    l__Control__36.setInProgress("Fire", false);
                    return;
                end;
                if u7.Type == "Launcher" or u7.Type == "Stinger" then
                    if u3 <= 0 or u7.Jammed then
                        u5.Handle.Click:Play();
                        l__Control__36.setInProgress("Fire", false);
                        l__Control__36.performOrQueue("Reload");
                        return;
                    end;
                    if u7.Type == "Stinger" and not l__HeatseekModule__34.getLockedTarget() then
                        return;
                    end;
                    l__Control__36.setInProgress("Fire", true);
                    u250(v295);
                    u3 = u3 - 1;
                    if u6 and u3 then
                        l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                    end;
                    LauncherFx();
                    JamChance();
                    l__Thread__22:Spawn(Recoil);
                    u64.NextShot = os.time() + 60 / u7.ShootRate;
                    l__Control__36.setInProgress("Fire", false);
                    if u5.Name ~= "DevRPG" then
                        l__Control__36.performOrQueue("Reload");
                    end;
                else
                    if u7.Type == "Grapple Hook" then
                        if u3 <= 0 or u7.Jammed then
                            u5.Handle.Click:Play();
                            stopGrapple();
                            return;
                        else
                            l__Control__36.setInProgress("Fire", true);
                            u250(v295);
                            u3 = u3 - 1;
                            GrappleFx();
                            if u6 and u3 then
                                l__PlayerGui__39:WaitForChild("CustomToolbar").Handler.UpdateBullets:Fire(u6, u3);
                            end;
                            JamChance();
                            l__Thread__22:Spawn(Recoil);
                            u64.NextShot = os.time() + 60 / u7.ShootRate;
                            l__Control__36.setInProgress("Fire", false);
                            return;
                        end;
                    end;
                    if u7.Type == "Grenade" then
                        if workspace:GetServerTimeNow() < (u64.NextGrenade or 0) then
                            return;
                        end;
                        u3 = u3 - 1;
                        l__Control__36.performIfPossible("GrenadeCook");
                    end;
                end;
            end;
        else
            if u64.BurstBullets > 0 or (u7.ShootType == 3 or l__TouchEnabled__89 and u7.MobileAutoFire) then
                l__Control__36.queue("Fire");
            end;
        end;
    end;
end;
local v301 = {};
local u302 = {
    cornerPeek = l__Spring__20.new(0)
};
u302.cornerPeek.d = 1;
u302.cornerPeek.s = 20;
u302.peekFactor = -0.2617993877991494;
u302.moveX = l__Spring__20.new(0);
u302.moveX.d = 1;
u302.moveX.s = 20;
u302.moveFactor = -0.017453292519943295;
u302.slideFactor = 0.5235987755982988;
local u303 = CFrame.new();
local u304 = true;
function v301.Update() --[[ Line: 2125 ]]
    -- upvalues: u304 (ref), u302 (copy), u68 (ref), l__CurrentCamera__3 (copy), l__Control__36 (copy), l__HumanoidRootPart__38 (copy), u303 (ref), u50 (ref), l__Crosshair__40 (copy)
    if u304 then
        u302.cornerPeek.t = u302.peekFactor * u68;
        local v305 = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), u302.cornerPeek.p);
        l__CurrentCamera__3.CFrame = l__CurrentCamera__3.CFrame * v305;
        local v306 = l__Control__36.isInProgress("Slide");
        local v307 = v306 and u302.slideFactor or 0;
        local v308 = l__HumanoidRootPart__38.AssemblyLinearVelocity:Dot(l__CurrentCamera__3.CFrame.RightVector);
        u302.moveX.t = u302.moveFactor * v308 + v307;
        u303 = CFrame.new(-u302.moveX.p * 0.7, -u302.moveX.p * 0.4, 0) * CFrame.fromAxisAngle(Vector3.new(0, 0, 1), u302.moveX.p);
        local v309 = DateTime.now().UnixTimestampMillis - u50;
        local v310 = v306 and 1 or math.max(200 - v309, 0) / 200;
        l__Crosshair__40.Rotation = math.deg(-u302.moveX.p * v310);
    end;
end;
game:GetService("RunService"):BindToRenderStep("Camera Update", 200, v301.Update);
local u311 = {
    Freeze = false,
    Snap = {
        X = Instance.new("NumberValue"),
        Z = Instance.new("NumberValue")
    },
    CamCFrame = Instance.new("CFrameValue")
};
local function u318(p312, p313) --[[ Line: 2152 ]]
    -- upvalues: u311 (copy), l__HumanoidRootPart__38 (copy), l__TweenService__7 (copy)
    local v314 = p313 or 1;
    u311.Freeze = true;
    u311.Snap.X.Value = l__HumanoidRootPart__38.Velocity.X * v314;
    u311.Snap.Z.Value = l__HumanoidRootPart__38.Velocity.Z * v314;
    if p312 then
        u311.CamCFrame.Value = CFrame.Angles(0, 0.2617993877991494, 0.5235987755982988);
        local v315 = {
            Value = 0
        };
        local v316 = TweenInfo.new(p312, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
        local v317 = TweenInfo.new(p312 / 2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
        u311.XTween = l__TweenService__7:Create(u311.Snap.X, v316, v315);
        u311.ZTween = l__TweenService__7:Create(u311.Snap.Z, v316, v315);
        u311.XTween:Play();
        u311.ZTween:Play();
        u311.CamTween = l__TweenService__7:Create(u311.CamCFrame, v317, {
            Value = CFrame.Angles(0, 0, 0.5235987755982988)
        });
        u311.CamTween:Play();
    end;
end;
function RunCheck()
    -- upvalues: u25 (ref), u29 (ref), l__Events__12 (copy), u8 (ref), l__Control__36 (copy)
    if u25 then
        u29 = 3;
        l__Events__12.GunStance:FireServer(u29, u8);
        SprintAnim();
    elseif u25 or not l__Control__36.isInProgress("ADS") then
        if not (u25 or l__Control__36.isInProgress("ADS")) then
            u29 = 0;
            l__Events__12.GunStance:FireServer(u29, u8);
            IdleAnim();
        end;
    else
        u29 = 2;
        l__Events__12.GunStance:FireServer(u29, u8);
        IdleAnim();
    end;
end;
function Stand()
    -- upvalues: l__Control__36 (copy), u67 (ref), u70 (ref), l__Events__12 (copy), u68 (ref)
    l__Control__36.setInProgress("Crouch", false);
    l__Control__36.setInProgress("Prone", false);
    u67 = 0;
    u70 = 0;
    l__Events__12.Stance:FireServer(u67, u68);
    animateCameraOffset();
end;
function Crouch()
    -- upvalues: l__Control__36 (copy), u67 (ref), u70 (ref), l__Events__12 (copy), u68 (ref)
    l__Control__36.setInProgress("Crouch", true);
    l__Control__36.setInProgress("Prone", false);
    u67 = 1;
    u70 = -1;
    l__Events__12.Stance:FireServer(u67, u68);
    animateCameraOffset();
end;
function SetSliding(p319, _)
    -- upvalues: u103 (copy), l__Humanoid__41 (copy), l__Control__36 (copy), u76 (copy), u70 (ref), l__HumanoidRootPart__38 (copy), u47 (copy), u46 (ref), l__RunService__6 (copy), u49 (copy)
    if p319 then
        if l__Humanoid__41:GetState() == Enum.HumanoidStateType.Running then
            l__Control__36.setInProgress("Slide", true);
            u76:Play(0.2);
            script:WaitForChild("Slide"):Play();
            u70 = -1;
            animateCameraOffset();
            local u320 = 36;
            local l__MoveDirection__91 = l__Humanoid__41.MoveDirection;
            if l__MoveDirection__91.X == 0 and l__MoveDirection__91.Z == 0 then
                l__MoveDirection__91 = l__HumanoidRootPart__38.CFrame.LookVector;
            end;
            local l__Unit__92 = Vector3.new(l__MoveDirection__91.X, 0, l__MoveDirection__91.Z).Unit;
            local l__Unit__93 = Vector3.new(l__MoveDirection__91.X, -1, l__MoveDirection__91.Z).Unit;
            u47.VectorVelocity = l__Unit__92 * u320;
            u46 = l__RunService__6.RenderStepped:Connect(function(p321) --[[ Line: 2228 ]]
                -- upvalues: l__Unit__92 (copy), u320 (ref), l__HumanoidRootPart__38 (ref), l__Unit__93 (copy), u49 (ref), u47 (ref), u103 (ref)
                local v322 = l__Unit__92 * u320;
                local v323 = workspace:Raycast(l__HumanoidRootPart__38.Position, l__Unit__93 * 3, u49);
                local v324 = l__HumanoidRootPart__38.Velocity.Y == 0 and 0 or -l__HumanoidRootPart__38.AssemblyLinearVelocity.Y / 7 * 0.016 / p321;
                local v325 = u320;
                u320 = v325 + (0 - v325) * (p321 * 1.3);
                u320 = math.clamp(u320 + v324, 0, 45);
                if v323 then
                    local v326 = u320;
                    u320 = v326 + (0 - v326) * (p321 * 25);
                end;
                u47.VectorVelocity = Vector3.new(v322.X, 0, v322.Z);
                u47.Enabled = true;
                if u320 <= 3 then
                    u103();
                end;
            end);
        end;
    else
        u103();
    end;
end;
function Prone()
    -- upvalues: l__Control__36 (copy), u67 (ref), u70 (ref), l__Events__12 (copy), u68 (ref)
    l__Control__36.setInProgress("Prone", true);
    l__Control__36.setInProgress("Crouch", false);
    u67 = 2;
    u70 = -2.75;
    l__Events__12.Stance:FireServer(u67, u68);
    animateCameraOffset();
end;
function Lean()
    -- upvalues: l__Events__12 (copy), u67 (ref), u68 (ref)
    animateCameraOffset();
    l__Events__12.Stance:FireServer(u67, u68);
end;
function EquipAnim()
    -- upvalues: u8 (ref), u9 (ref), l__Config__19 (copy), u131 (ref), l__Control__36 (copy), u14 (ref), u13 (ref), u15 (ref), u5 (ref)
    local v327 = u8 and u8.Keyframes;
    if v327 and true or v327 then
        u9.Humanoid:WaitForChild("Animator");
        if l__Config__19.DisableFirstEquip == true or not u8.IsFirstEquip then
            u131.Equip:Play(0);
            task.wait(u131.Equip.Length * 0.8);
        else
            u131.FirstEquip:Play(0);
            u8.IsFirstEquip = false;
            repeat
                task.wait();
            until u131.FirstEquip.Length ~= 0;
            task.wait(u131.FirstEquip.Length * 0.8);
        end;
        l__Control__36.setInProgress("Equip", false);
    else
        pcall(function() --[[ Line: 2292 ]]
            -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
            u8.EquipAnim({
                u14,
                u13,
                u15,
                u5,
                u9
            });
        end);
        l__Control__36.setInProgress("Equip", false);
    end;
end;
function IdleAnim()
    -- upvalues: u8 (ref), u131 (ref), l__Control__36 (copy), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    local v328 = u8 and u8.Keyframes;
    if v328 and true or v328 then
        if u131.Sprint then
            u131.Sprint:Stop(0.2);
        end;
        u131.Idle:Play();
        task.wait(0.2);
        l__Control__36.setInProgress("Sprint", false);
    else
        pcall(function() --[[ Line: 2315 ]]
            -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
            u8.IdleAnim({
                u14,
                u13,
                u15,
                u5,
                u9
            });
        end);
        l__Control__36.setInProgress("Sprint", false);
    end;
end;
function SprintAnim()
    -- upvalues: l__Control__36 (copy), u8 (ref), u131 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    l__Control__36.setInProgress("Sprint", true);
    local v329 = u8 and u8.Keyframes;
    if v329 and true or v329 then
        if u131.Sprint then
            u131.Sprint:Play(0.2);
            u131.Sprint:AdjustSpeed(0);
        end;
    else
        pcall(function() --[[ Line: 2335 ]]
            -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
            u8.SprintAnim({
                u14,
                u13,
                u15,
                u5,
                u9
            });
        end);
    end;
end;
local function u336(u330) --[[ Line: 2346 ]]
    -- upvalues: u8 (ref), u131 (ref), u7 (ref), u3 (ref), u132 (ref), l__Control__36 (copy), u54 (ref), l__PlayerGui__45 (copy), u6 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    local v331 = u8 and u8.Keyframes;
    if v331 and true or v331 then
        local v332 = u330 and "Empty" or "";
        local v333 = u131.ReloadIn and (not u330 and u7.ShellInsert) and {
            normal = "ReloadIn",
            ads = "AdsReloadIn"
        } or {
            normal = v332 .. "Reload",
            ads = "Ads" .. v332 .. "Reload"
        };
        if u8.customReloadFunction then
            v333 = u8.customReloadFunction(u3);
        end;
        u132.Normal = u131[v333.normal];
        u132.ADS = u131[v333.ads];
        local v334 = u132.ADS ~= nil;
        if not v334 then
            l__Control__36.performOrQueue("ADSBlocker");
        end;
        local l__ReloadSpeed__94 = u54.ReloadSpeed;
        u131[v333.normal]:Play(0.3, 1, l__ReloadSpeed__94);
        local l__Length__95 = u131[v333.normal].Length;
        local v335 = l__PlayerGui__45:FindFirstChild("CustomToolbar");
        if v335 then
            v335.Handler.ReloadState:Fire(u6, l__Length__95 * 0.8);
        end;
        if v334 then
            u131[v333.ads]:Play(0.3, 0.001, l__ReloadSpeed__94);
        end;
        if u7.ShellInsert then
            u131[v333.normal].Stopped:Wait();
        else
            task.wait(u131[v333.normal].length * 0.8 / l__ReloadSpeed__94);
            l__Control__36.setInProgress("ADSBlocker", false);
        end;
    else
        pcall(function() --[[ Line: 2393 ]]
            -- upvalues: u330 (copy), u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
            (u330 and u8.TacticalReloadAnim or u8.ReloadAnim)({
                u14,
                u13,
                u15,
                u5,
                u9
            });
        end);
    end;
end;
function ReloadAnim()
    -- upvalues: u336 (copy)
    u336(false);
end;
function TacticalReloadAnim()
    -- upvalues: u336 (copy)
    u336(true);
end;
function JammedAnim()
    -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    pcall(function() --[[ Line: 2415 ]]
        -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
        u8.JammedAnim({
            u14,
            u13,
            u15,
            u5,
            u9
        });
    end);
end;
function PumpAnim()
    -- upvalues: l__Control__36 (copy), u8 (ref), u61 (copy), u131 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    l__Control__36.setInProgress("Pump", true);
    local v337 = u8 and u8.Keyframes;
    if v337 and true or v337 then
        if u61.Progress >= 0.9 and u131.AdsPump then
            u131.AdsPump:Play();
            task.wait(u131.AdsPump.length * 0.8);
        elseif u131.Pump then
            u131.Pump:Play();
            task.wait(u131.Pump.length * 0.8);
        end;
        l__Control__36.setInProgress("Pump", false);
    else
        pcall(function() --[[ Line: 2439 ]]
            -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
            u8.PumpAnim({
                u14,
                u13,
                u15,
                u5,
                u9
            });
        end);
        l__Control__36.setInProgress("Pump", false);
    end;
end;
function MagCheckAnim()
    -- upvalues: l__Control__36 (copy), u8 (ref), u131 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    l__Control__36.setInProgress("Inspect", true);
    local v338 = u8 and u8.Keyframes;
    if v338 and true or v338 then
        u131.Inspect:Play();
        task.wait(u131.Inspect.length * 0.8);
        l__Control__36.setInProgress("Inspect", false);
    else
        pcall(function() --[[ Line: 2459 ]]
            -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
            u8.MagCheck({
                u14,
                u13,
                u15,
                u5,
                u9
            });
        end);
        l__Control__36.setInProgress("Inspect", false);
    end;
end;
function meleeAttack()
    -- upvalues: l__Control__36 (copy), u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    l__Control__36.setInProgress("Fire", true);
    pcall(function() --[[ Line: 2473 ]]
        -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
        u8.meleeAttack({
            u14,
            u13,
            u15,
            u5,
            u9
        });
    end);
    l__Control__36.setInProgress("Fire", false);
end;
function GrenadeReady()
    -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
    pcall(function() --[[ Line: 2486 ]]
        -- upvalues: u8 (ref), u14 (ref), u13 (ref), u15 (ref), u5 (ref), u9 (ref)
        u8.GrenadeReady({
            u14,
            u13,
            u15,
            u5,
            u9
        });
    end);
end;
function GrenadeThrow()
    -- upvalues: u64 (copy), u131 (ref), l__Control__36 (copy), u5 (ref), u261 (copy), u7 (ref), l__PlayerGui__45 (copy), u6 (ref)
    u64.Throwing = true;
    if u131 then
        l__Control__36.setInProgress("GrenadeCook", false);
        if u131.RemovePin.IsPlaying then
            u131.RemovePin.Stopped:Wait();
        end;
        l__Control__36.setInProgress("GrenadeThrow", true);
        local l__ExpTime__96 = u64.ExpTime;
        u64.ExpTime = nil;
        u131.ThrowIdle:Stop();
        u131.Idle:Play();
        u131.Throw:GetMarkerReachedSignal("Thrown"):Once(function() --[[ Line: 2510 ]]
            -- upvalues: u5 (ref), u261 (ref), l__ExpTime__96 (copy)
            for _, v339 in pairs(u5:GetChildren()) do
                if v339:IsA("BasePart") then
                    v339.Transparency = 1;
                end;
            end;
            u261(l__ExpTime__96);
        end);
        u131.Throw.Stopped:Once(function() --[[ Line: 2518 ]]
            -- upvalues: u5 (ref), u64 (ref), l__Control__36 (ref)
            for _, v340 in pairs(u5:GetChildren()) do
                if v340:IsA("BasePart") then
                    v340.Transparency = 0;
                    u64.Throwing = false;
                    l__Control__36.setInProgress("GrenadeThrow", false);
                end;
            end;
        end);
        u131.Throw:Play();
        u64.NextGrenade = workspace:GetServerTimeNow() + u7.TimeBetweenNades;
        local v341 = l__PlayerGui__45:FindFirstChild("CustomToolbar");
        if v341 then
            v341.Handler.ReloadState:Fire(u6, u7.TimeBetweenNades);
        end;
    end;
end;
function GrenadeCook()
    -- upvalues: u131 (ref), u64 (copy), l__Control__36 (copy), u5 (ref), u7 (ref), l__Events__12 (copy)
    if u131.RemovePin.IsPlaying or (u131.ThrowIdle.IsPlaying or (u131.Throw.IsPlaying or u64.Throwing)) then
        l__Control__36.dequeue("GrenadeCook");
    else
        l__Control__36.setInProgress("GrenadeCook", true);
        u131.RemovePin:GetMarkerReachedSignal("PinRemoved"):Once(function() --[[ Line: 2541 ]]
            -- upvalues: u5 (ref), u64 (ref), u7 (ref), l__Events__12 (ref)
            u5.Pin.Transparency = 1;
            u64.NadePrepped = true;
            local u342 = workspace:GetServerTimeNow() + u7.FuseTime;
            u64.ExpTime = u342;
            task.delay(u7.FuseTime, function() --[[ Line: 2546 ]]
                -- upvalues: u64 (ref), u342 (copy), u5 (ref), l__Events__12 (ref)
                if u64.ExpTime == u342 then
                    if u5 and u5.Name then
                        l__Events__12.GrenadeCookoff:FireServer(u5.Name);
                    end;
                end;
            end);
        end);
        u131.Idle:Stop();
        u131.RemovePin:Play();
        u131.ThrowIdle:Play();
    end;
end;
l__ContextActionService__5:BindAction("Sprint", handleAction, false, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonL3);
l__ContextActionService__5:BindAction("Stand", handleAction, false, Enum.KeyCode.X);
l__ContextActionService__5:BindAction("Crouch", handleAction, false, Enum.KeyCode.C, Enum.KeyCode.ButtonB);
l__ContextActionService__5:BindAction("Jump", handleAction, false, Enum.KeyCode.Space, Enum.KeyCode.ButtonA);
l__ContextActionService__5:BindAction("ToggleWalk", handleAction, false, Enum.KeyCode.Z);
l__ContextActionService__5:BindAction("LeanLeft", handleAction, false, Enum.KeyCode.Q, Enum.KeyCode.DPadLeft);
l__ContextActionService__5:BindAction("LeanRight", handleAction, false, Enum.KeyCode.E, Enum.KeyCode.DPadRight);
l__ContextActionService__5:BindAction("NVG", handleAction, false, Enum.KeyCode.N, Enum.KeyCode.DPadUp);
u102({ "Jump", "Crouch" }, true);
local function v343() --[[ Line: 2574 ]]
    -- upvalues: u102 (copy), l__LocalPlayer__2 (copy)
    u102({ "NVG" }, l__LocalPlayer__2:GetAttribute("NVGType") ~= nil);
end;
v343();
l__LocalPlayer__2:GetAttributeChangedSignal("NVGType"):Connect(v343);
local function u346(u344) --[[ Line: 2582 ]]
    -- upvalues: u45 (ref), l__Humanoid__41 (copy), u1 (copy), l__Control__36 (copy), l__ShopModule__53 (copy)
    if u344 then
        local v345 = not u45 and u344:FindFirstChild("ACS_Settings");
        if v345 then
            v345 = require(u344.ACS_Settings);
        end;
        if u344:IsA("Tool") and (l__Humanoid__41.Health > 0 and (v345 and (v345.Type == "Gun" or (v345.Type == "Melee" or (v345.Type == "Grenade" or (v345.Type == "Launcher" or (v345.Type == "Grapple Hook" or v345.Type == "Stinger"))))))) then
            if u1:WaitForChild("Humanoid").Sit and (u1.Humanoid.SeatPart:IsA("VehicleSeat") or (u1.Humanoid.SeatPart.Name == "GunnerSeat" or u1.Humanoid.SeatPart:GetAttribute("NoWeapons"))) then
                return;
            end;
            l__Control__36.setInProgress("Equip", true);
            l__ShopModule__53.toggleLeftMenu(false);
            if not u45 then
                setup(u344);
                return;
            end;
            if u45 then
                pcall(function() --[[ Line: 2599 ]]
                    -- upvalues: u344 (copy)
                    unset();
                    setup(u344);
                end);
            end;
        end;
    end;
end;
u1.ChildAdded:connect(u346);
u1.ChildRemoved:connect(function(p347) --[[ Line: 2609 ]]
    -- upvalues: u6 (ref), u45 (ref), l__ShopModule__53 (copy)
    if p347 == u6 and u45 then
        l__ShopModule__53.toggleLeftMenu(true);
        unset(p347);
    end;
end);
l__Humanoid__41.Running:Connect(function(p348) --[[ Line: 2618 ]]
    -- upvalues: u24 (ref), l__Control__36 (copy)
    u24 = p348;
    l__Control__36.setInProgress("Walk", p348 > 0.1);
end);
l__Humanoid__41.Swimming:Connect(function(p349) --[[ Line: 2623 ]]
    -- upvalues: l__Control__36 (copy), u24 (ref)
    if l__Control__36.isInProgress("Swim") then
        u24 = p349;
        l__Control__36.setInProgress("Walk", p349 > 0.1);
    end;
end);
l__Humanoid__41.Died:Connect(function(_) --[[ Line: 2630 ]]
    -- upvalues: l__Events__12 (copy), l__Control__36 (copy), l__PlayerGui__45 (copy), l__TweenService__7 (copy), u1 (copy), u67 (ref), u68 (ref), u69 (ref), u70 (ref), l__LocalPlayer__2 (copy), u103 (copy)
    l__Events__12.NVG:FireServer(false);
    l__Control__36.setInProgress("NVG", false);
    for _, v350 in ipairs(game:GetService("Lighting"):GetChildren()) do
        if string.match(v350.Name, "^NVG") then
            v350:Destroy();
        end;
    end;
    local v351 = l__PlayerGui__45:FindFirstChild("NVGOverlay");
    if v351 then
        v351:Destroy();
    end;
    if l__PlayerGui__45:FindFirstChild("JavelinNoise") then
        l__PlayerGui__45.JavelinNoise:Destroy();
    end;
    game:GetService("Lighting").JavelinCorrection.Enabled = false;
    l__Control__36.setInProgress("ActionBlocker");
    l__TweenService__7:Create(u1.Humanoid, TweenInfo.new(1), {
        CameraOffset = Vector3.new(0, 0, 0)
    }):Play();
    Stand();
    u67 = 0;
    u68 = 0;
    u69 = 0;
    u70 = 0;
    Lean();
    unset();
    l__LocalPlayer__2.Backpack:ClearAllChildren();
    u103();
end);
if l__ReplicatedConfig__27.Mode == "Tycoon" and l__PlayerGui__45:WaitForChild("LoadingGui"):GetAttribute("HasClickedPlay") then
    l__ShopModule__53.toggleLeftMenu(true);
end;
l__Humanoid__41.Seated:Connect(function(p352, p353) --[[ Line: 2665 ]]
    -- upvalues: l__ShopModule__53 (copy), l__Humanoid__41 (copy), l__LocalPlayer__2 (copy), l__Config__19 (copy), u2 (ref), l__HumanoidRootPart__38 (copy), l__Control__36 (copy), u67 (ref), u68 (ref), u69 (ref), u70 (ref)
    if p352 and p353 then
        if p353:IsA("VehicleSeat") or (p353.Name == "GunnerSeat" or p353:GetAttribute("NoWeapons")) then
            l__ShopModule__53.toggleLeftMenu(false);
            unset();
            l__Humanoid__41:UnequipTools();
        end;
        l__LocalPlayer__2.CameraMaxZoomDistance = l__Config__19.VehicleMaxZoom;
        local v354 = p353:GetAttribute("CamMinZoom");
        local v355 = p353.Name == "HeliSeat" and 50 or v354;
        if v355 then
            l__LocalPlayer__2.CameraMinZoomDistance = v355;
        end;
        u2 = p353;
    else
        l__ShopModule__53.toggleLeftMenu(true);
        l__LocalPlayer__2.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance;
        l__LocalPlayer__2.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance;
        if u2 then
            local v356 = u2:GetAttribute("Height");
            if v356 then
                local v357 = l__HumanoidRootPart__38;
                v357.CFrame = v357.CFrame + Vector3.new(0, v356, 0);
            end;
            u2 = nil;
        end;
    end;
    if p352 then
        l__Control__36.setInProgress("Sit", true);
        u67 = 0;
        u68 = 0;
        u69 = 0;
        u70 = 0;
        Stand();
        Lean();
    else
        l__Control__36.setInProgress("Sit", false);
    end;
end);
l__Humanoid__41.StateChanged:connect(function(_, p358) --[[ Line: 2726 ]]
    -- upvalues: l__Events__12 (copy), u71 (ref), u28 (ref), u103 (copy), l__CurrentCamera__3 (copy), l__Control__36 (copy), u5 (ref), u65 (copy), l__Config__19 (copy), u67 (ref), u68 (ref), u69 (ref), u70 (ref), u318 (copy), l__HumanoidRootPart__38 (copy), l__Thread__22 (copy), u19 (copy), l__LocalPlayer__2 (copy)
    l__Events__12.EditKillConditions:FireServer("InAir", p358 == Enum.HumanoidStateType.Jumping and true or p358 == Enum.HumanoidStateType.Freefall);
    if p358 == Enum.HumanoidStateType.Jumping then
        local v359 = u71;
        if v359 then
            v359 = not u28;
        end;
        if v359 then
            u103();
            if (l__CurrentCamera__3.CFrame.p - l__CurrentCamera__3.Focus.p).Magnitude < 0.6 then
                local v360 = l__Control__36.isInProgress("ADS") and 0.1 or 1;
                if u5 then
                    u65.Jump:shove((Vector3.new(-0.03 * v360, 0, 0)));
                    u65.Cam:shove(Vector3.new(-0.15, 0, 0));
                end;
            end;
            u71 = false;
            coroutine.wrap(function() --[[ Line: 2741 ]]
                -- upvalues: l__Config__19 (ref), u28 (ref)
                task.wait(l__Config__19.JumpCoolDown);
                u28 = false;
            end)();
        end;
        if l__Config__19.AntiBunnyHop then
            u28 = true;
        end;
    elseif p358 == Enum.HumanoidStateType.Climbing or (p358 == Enum.HumanoidStateType.Seated or (p358 == Enum.HumanoidStateType.RunningNoPhysics or (p358 == Enum.HumanoidStateType.Running or p358 == Enum.HumanoidStateType.Landed))) then
        u71 = true;
        l__Control__36.setInProgress("Fall", false);
        SetSliding(false, true);
    else
        u71 = false;
    end;
    if p358 == Enum.HumanoidStateType.Swimming then
        l__Control__36.setInProgress("Swim", true);
        u67 = 0;
        u68 = 0;
        u69 = 0;
        u70 = 0;
        Stand();
        Lean();
    else
        l__Control__36.setInProgress("Swim", false);
    end;
    if (p358 == Enum.HumanoidStateType.Jumping or p358 == Enum.HumanoidStateType.Freefall) and not l__Control__36.isInProgress("Fall") then
        if l__Config__19.JumpInertionEnabled then
            u318();
        end;
        l__Control__36.setInProgress("Fall", true);
        local v361 = 0;
        local v362 = 0;
        while l__Control__36.isInProgress("Fall") do
            v362 = -math.min(l__HumanoidRootPart__38.Velocity.Y, 0);
            v361 = v361 + 1;
            l__Thread__22:Wait();
        end;
        if (v362 - l__Config__19.MaxVelocity) * l__Config__19.DamageMult > 5 and v361 > 20 then
            local _ = u19 .. "-" .. l__LocalPlayer__2.UserId;
            local _ = l__Config__19.EnableFallDamage;
        end;
        if (l__CurrentCamera__3.CFrame.p - l__CurrentCamera__3.Focus.p).Magnitude < 0.6 then
            local v363 = math.clamp(v362, 0, 80);
            local v364 = 0.03 * (l__Control__36.isInProgress("ADS") and 0.1 or 1);
            if u5 then
                u65.Jump:shove((Vector3.new(-(v364 + v363 / 40 * v364), 0, 0)));
                u65.Cam:shove((Vector3.new(-(v363 / 40 * 0.1 + 0.1), 0, 0)));
            end;
        end;
    end;
end);
function animateCameraOffset(p365)
    -- upvalues: l__TweenService__7 (copy), u1 (copy), u69 (ref), u70 (ref)
    l__TweenService__7:Create(u1.Humanoid, TweenInfo.new(p365 or 0.3), {
        CameraOffset = Vector3.new(u69, u70, 0)
    }):Play();
end;
v63:Play();
local function v368() --[[ Line: 2818 ]]
    -- upvalues: l__Humanoid__41 (copy), u62 (ref), l__Config__19 (copy)
    local l__Health__97 = l__Humanoid__41.Health;
    local _ = u62.Effects.Health;
    u62.Effects.Health.ImageTransparency = l__Health__97 > 0 and (l__Health__97 - 50) / 50 or 1;
    local v366 = math.min(l__Humanoid__41.Health, 100);
    if l__Config__19.OneHitKillEnabled then
        u62.MainFrame.Health.Visible = false;
    else
        u62.MainFrame.Health.Bar.Percent.Size = UDim2.new(v366 / 100, 0, 0.5, 0);
    end;
    if l__Humanoid__41:GetAttribute("Armor") then
        u62.MainFrame.Health.ArmorBar.Visible = true;
        local v367 = l__Humanoid__41:GetAttribute("Armor");
        u62.MainFrame.Health.ArmorBar.Percent.Size = UDim2.new(v367 / 60, 0, 0.3, 0);
    else
        u62.MainFrame.Health.ArmorBar.Visible = false;
    end;
end;
l__Humanoid__41.HealthChanged:Connect(v368);
l__Humanoid__41:GetAttributeChangedSignal("Armor"):Connect(v368);
v368();
function setWalkSpeed()
    -- upvalues: l__Control__36 (copy), l__Config__19 (copy), u54 (ref), l__ACS_Client__26 (copy), u51 (copy), u7 (ref), u1 (copy)
    local v369, v370;
    if l__Control__36.isInProgress("ADS") then
        v369 = l__Config__19.AimWalkSpeed * u54.AdsMoveSpeed;
        v370 = l__Config__19.JumpPower;
    elseif l__Control__36.isInProgress("Crouch") then
        v369 = l__Config__19.CrouchWalkSpeed;
        v370 = 0;
    elseif l__Control__36.isInProgress("Prone") then
        v369 = l__ACS_Client__26:GetAttribute("Surrender") and 0 or l__Config__19.ProneWalksSpeed;
        v370 = 0;
    elseif l__Control__36.isInProgress("Sprint") then
        v369 = l__Config__19.RunWalkSpeed;
        v370 = l__Config__19.JumpPower;
    else
        v369 = l__Config__19.NormalWalkSpeed;
        v370 = l__Config__19.JumpPower;
    end;
    u1.Humanoid.WalkSpeed = v369 * (u51.Mult * (u7 and u7.WalkSpeedMult or 1) * u54.MoveSpeed);
    u1.Humanoid.JumpPower = v370;
end;
local function u373() --[[ Line: 2877 ]]
    -- upvalues: l__Humanoid__41 (copy), l__CameraRotation__35 (copy), l__CurrentCamera__3 (copy), l__Events__12 (copy)
    local l__SeatPart__98 = l__Humanoid__41.SeatPart;
    if l__CameraRotation__35.IsTurret and l__SeatPart__98.Name ~= "GunnerSeat" then
        local v371, v372, _ = l__SeatPart__98.Parent.AnchorPoint.CFrame:toObjectSpace(l__CurrentCamera__3.CFrame):ToEulerAnglesYXZ();
        CFrame.Angles(-v371, -v372, 0);
        l__Events__12.TurretAngleChanged:FireServer(l__SeatPart__98, v372, v371);
        l__SeatPart__98.YMotor.C0 = CFrame.new() * CFrame.Angles(-v371, 0, 0);
        l__SeatPart__98.XMotor.C0 = CFrame.new() * CFrame.Angles(0, v372, 0);
    end;
end;
local function u374() --[[ Line: 2896 ]]
    -- upvalues: l__Control__36 (copy), u311 (copy), l__HumanoidRootPart__38 (copy)
    if l__Control__36.isInProgress("Slide") then
    elseif math.abs(u311.Snap.X.Value) + math.abs(u311.Snap.Z.Value) < 3 then
        u311.Freeze = false;
    else
        if u311.Freeze then
            l__HumanoidRootPart__38.Velocity = Vector3.new(u311.Snap.X.Value, l__HumanoidRootPart__38.Velocity.Y, u311.Snap.Z.Value);
        end;
    end;
end;
local u375 = {
    X = 0,
    Y = 0,
    Z = 0
};
local function u390(p376, p377) --[[ Line: 2908 ]]
    -- upvalues: u65 (copy), u7 (ref), l__Crosshair__40 (copy), l__CurrentCamera__3 (copy), u375 (ref)
    local v378 = CFrame.new();
    local v379 = u65.Sway:update(p376);
    local v380 = math.min(1.1 - p377, 1);
    local v381 = v378 * CFrame.Angles(-v379.Y / 8 * v380, -v379.X / 8 * v380, 0);
    if u7.CrossHair then
        l__Crosshair__40.Position = UDim2.new(0.5 + v379.X / 70, 0, 0.5 + v379.Y / 70, 0);
    end;
    local v382 = u65.GunRecoil:update(p376);
    local v383 = v381 * CFrame.Angles(v382.X, v382.Y, v382.Z);
    local v384 = (math.abs(v382.Y) + math.abs(v382.X)) * 5;
    local v385 = v383 + Vector3.new(0, 0, v384);
    local v386 = u65.Jump:update(p376);
    local v387 = v385 * CFrame.Angles(v386.X, v386.Y, v386.Z);
    local v388 = u65.Cam:update(p376);
    local v389 = l__CurrentCamera__3;
    v389.CFrame = v389.CFrame * CFrame.Angles(v388.X - u375.X, v388.Y - u375.Y, v388.Z - u375.Z);
    u375 = {
        X = v388.X,
        Y = v388.Y,
        Z = v388.Z
    };
    return v387;
end;
(function() --[[ Name: firstTimeCall, Line 2937 ]]
    -- upvalues: u1 (copy), u346 (copy), l__Humanoid__41 (copy), u68 (ref), l__Control__36 (copy), u69 (ref), l__PlayerGui__45 (copy), u304 (ref), u67 (ref), u28 (ref), u71 (ref), l__Config__19 (copy), u103 (copy), l__LocalPlayer__2 (copy), l__Events__12 (copy), l__HUD__14 (copy), l__TweenService__7 (copy), u64 (copy), u27 (ref)
    u346((u1:FindFirstChildOfClass("Tool")));
    local function v391() --[[ Line: 2941 ]]
        -- upvalues: l__Humanoid__41 (ref), u68 (ref), l__Control__36 (ref), u69 (ref)
        if l__Humanoid__41.SeatPart == nil then
            if u68 == 0 or u68 == 1 then
                l__Control__36.setInProgress("LeanLeft", true);
                u68 = -1;
                u69 = -1.25;
            else
                l__Control__36.setInProgress("LeanLeft", false);
                u68 = 0;
                u69 = 0;
            end;
            Lean();
        end;
    end;
    local function v392() --[[ Line: 2957 ]]
        -- upvalues: l__Humanoid__41 (ref), u68 (ref), l__Control__36 (ref), u69 (ref)
        if l__Humanoid__41.SeatPart == nil then
            if u68 == 0 or u68 == -1 then
                l__Control__36.setInProgress("LeanRight", true);
                u68 = 1;
                u69 = 1.25;
            else
                l__Control__36.setInProgress("LeanRight", false);
                u68 = 0;
                u69 = 0;
            end;
            Lean();
        end;
    end;
    local function v393() --[[ Line: 2973 ]]
        -- upvalues: u68 (ref), u69 (ref), l__Control__36 (ref)
        u68 = 0;
        u69 = 0;
        l__Control__36.setInProgress("LeanRight", false);
        l__Control__36.setInProgress("LeanLeft", false);
        Lean();
    end;
    local u394 = {};
    for _, u395 in { l__PlayerGui__45.GameUI.LoadoutUI, l__PlayerGui__45.MinigameGui.ContentArea.EndText, l__PlayerGui__45.MinigameGui.EndFrame } do
        if u395:IsA("ScreenGui") then
            u395:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 2997 ]]
                -- upvalues: u395 (copy), u394 (copy), u304 (ref)
                if u395.Enabled then
                    if not table.find(u394, u395) then
                        table.insert(u394, u395);
                    end;
                    u304 = false;
                else
                    if table.find(u394, u395) then
                        table.remove(u394, table.find(u394, u395));
                    end;
                    if #u394 == 0 then
                        u304 = true;
                    end;
                end;
            end);
        else
            u395:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 3009 ]]
                -- upvalues: u395 (copy), u394 (copy), u304 (ref)
                if u395.Visible then
                    if not table.find(u394, u395) then
                        table.insert(u394, u395);
                    end;
                    u304 = false;
                else
                    if table.find(u394, u395) then
                        table.remove(u394, table.find(u394, u395));
                    end;
                    if #u394 == 0 then
                        u304 = true;
                    end;
                end;
            end);
        end;
    end;
    l__Control__36.configureAction("Sprint", toggleRun, toggleRun);
    l__Control__36.configureAction("Slide", function() --[[ Line: 3025 ]]
        SetSliding(true, false);
    end, function() --[[ Line: 3025 ]]
        SetSliding(false, false);
    end);
    l__Control__36.configureAction("LeanLeft", v391, v393, true);
    l__Control__36.configureAction("LeanRight", v392, v393, true);
    l__Control__36.configureAction("Crouch", function(p396) --[[ Line: 3029 ]]
        if p396 then
            Crouch();
        else
            Stand();
        end;
    end, function() --[[ Line: 3036 ]]
        -- upvalues: u67 (ref)
        if u67 == 2 then
            Crouch();
        else
            if u67 == 1 then
                Stand();
            end;
        end;
    end, true);
    l__Control__36.configureAction("Stand", function() --[[ Line: 3044 ]]
        -- upvalues: u67 (ref)
        if u67 == 2 then
            Crouch();
        else
            if u67 == 1 then
                Stand();
            end;
        end;
    end);
    l__Control__36.configureAction("Jump", function() --[[ Line: 3052 ]]
        -- upvalues: u28 (ref), u71 (ref), l__Control__36 (ref), l__Config__19 (ref), u103 (ref), l__Humanoid__41 (ref)
        if u28 or not u71 then
        else
            if l__Control__36.isInProgress("Slide") and l__Config__19.SlideCancellingJump then
                u103();
                Stand();
            end;
            l__Humanoid__41.Jump = true;
            l__Humanoid__41:ChangeState(Enum.HumanoidStateType.Jumping);
            if l__Control__36.isInProgress("Crouch") then
                Stand();
            end;
        end;
    end);
    l__Control__36.configureAction("NVG", function(p397) --[[ Line: 3065 ]]
        -- upvalues: l__LocalPlayer__2 (ref), l__Control__36 (ref), l__Events__12 (ref), l__HUD__14 (ref), l__PlayerGui__45 (ref), l__TweenService__7 (ref)
        local v398 = l__LocalPlayer__2;
        if v398 then
            v398 = l__LocalPlayer__2:GetAttribute("NVGType");
        end;
        if v398 then
            l__Control__36.setInProgress("NVGAnim", true);
            l__Control__36.setInProgress("NVG", p397);
            script:WaitForChild("NVGToggle"):Play();
            l__Events__12.NVG:FireServer(p397);
            if p397 then
                script:WaitForChild("NVGOn"):Play();
                local v399 = l__HUD__14:WaitForChild("NVGOverlay"):Clone();
                v399.Parent = l__PlayerGui__45;
                v399.Enabled = true;
                local v400 = v399:WaitForChild("LightingFX"):WaitForChild(v398);
                for _, v401 in ipairs(v400:GetChildren()) do
                    v401.Parent = game:GetService("Lighting");
                    if v401.Name == "NVGAnim" then
                        v401.Brightness = 0.8;
                        l__TweenService__7:Create(v401, TweenInfo.new(3, Enum.EasingStyle.Quad), {
                            Brightness = 0
                        }):Play();
                    end;
                end;
            else
                for _, u402 in ipairs(game:GetService("Lighting"):GetChildren()) do
                    if string.match(u402.Name, "^NVG") then
                        if u402.Name == "NVGAnim" then
                            u402:Clone();
                            u402.Parent = game:GetService("Lighting");
                            u402.Name = "NVGOffAnim";
                            u402.Brightness = -0.7;
                            spawn(function() --[[ Line: 3094 ]]
                                -- upvalues: l__TweenService__7 (ref), u402 (copy)
                                l__TweenService__7:Create(u402, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                                    Brightness = 0
                                }):Play();
                                task.wait(0.5);
                                u402:Destroy();
                            end);
                        end;
                        u402:Destroy();
                    end;
                end;
                local v403 = l__PlayerGui__45:FindFirstChild("NVGOverlay");
                if v403 then
                    v403:Destroy();
                end;
            end;
            l__Control__36.setInProgress("NVGAnim", false);
        end;
    end, function() --[[ Line: 3108 ]]
        -- upvalues: l__Events__12 (ref), l__Control__36 (ref), l__PlayerGui__45 (ref)
        l__Events__12.NVG:FireServer(false);
        l__Control__36.setInProgress("NVG", false);
        for _, v404 in ipairs(game:GetService("Lighting"):GetChildren()) do
            if string.match(v404.Name, "^NVG") then
                v404:Destroy();
            end;
        end;
        local v405 = l__PlayerGui__45:FindFirstChild("NVGOverlay");
        if v405 then
            v405:Destroy();
        end;
    end, true);
    l__Control__36.configureAction("Fire", Shoot, function() --[[ Line: 3121 ]]
        -- upvalues: u64 (ref), l__Control__36 (ref)
        u64.NextMobileShot = u64.NextShot;
        l__Control__36.setInProgress("Fire", false);
        l__Control__36.stop("Fire");
    end);
    l__Control__36.configureAction("GrenadeCook", function() --[[ Line: 3126 ]]
        GrenadeCook();
    end, function() --[[ Line: 3126 ]] end, true);
    l__Control__36.configureAction("GrenadeThrow", function() --[[ Line: 3128 ]]
        GrenadeThrow();
    end);
    l__Control__36.configureAction("FireAfterADS", Shoot, function() --[[ Line: 3132 ]]
        -- upvalues: l__Control__36 (ref)
        l__Control__36.setInProgress("FireAfterADS", false);
    end);
    l__Control__36.configureAction("ADS", ADS, ADS, true);
    l__Control__36.configureAction("Reload", Reload, function() --[[ Line: 3134 ]]
        -- upvalues: u27 (ref)
        u27 = true;
    end);
    l__Control__36.configureAction("Pump", PumpAnim);
    l__Control__36.configureAction("Inspect", CheckMagFunction);
    l__Control__36.configureAction("AltAim", SetAimpart);
    l__Control__36.configureAction("CycleFireMode", Firemode);
    l__Control__36.configureAction("CycleLaser", SetLaser);
    l__Control__36.configureAction("CycleFlashlight", SetTorch);
    l__Control__36.configureAction("ADSBlocker", function() --[[ Line: 3141 ]]
        -- upvalues: l__Control__36 (ref)
        l__Control__36.setInProgress("ADSBlocker", true);
    end);
end)();
local function u410() --[[ Line: 3150 ]]
    -- upvalues: l__HeatseekModule__34 (copy), l__JavelinGui__37 (copy)
    local v406 = l__HeatseekModule__34.getLockState();
    if v406 then
        if v406 == "Locking" then
            local v407 = Color3.fromRGB(255, 255, 0);
            l__JavelinGui__37.Black.Lock.ImageColor3 = v407;
            l__JavelinGui__37.Black.Lock.Label.TextColor3 = v407;
        else
            if v406 == "Locked" then
                local v408 = Color3.fromRGB(85, 255, 127);
                l__JavelinGui__37.Black.Lock.ImageColor3 = v408;
                l__JavelinGui__37.Black.Lock.Label.TextColor3 = v408;
            end;
        end;
    else
        local v409 = Color3.fromRGB(131, 131, 131);
        l__JavelinGui__37.Black.Lock.ImageColor3 = v409;
        l__JavelinGui__37.Black.Lock.Label.TextColor3 = v409;
    end;
end;
l__RunService__6.RenderStepped:Connect(function(p411) --[[ Line: 3166 ]]
    -- upvalues: l__Control__36 (copy), l__Humanoid__41 (copy), l__CameraRotation__35 (copy), l__CurrentCamera__3 (copy), l__LocalPlayer__2 (copy), u26 (ref), u51 (copy), u373 (copy), u374 (copy), u9 (ref), u11 (ref), u12 (ref), u5 (ref), u7 (ref), u61 (copy), u74 (copy), l__UserInputService__4 (copy), u8 (ref), u65 (copy), u10 (ref), u55 (ref), u59 (ref), u56 (ref), u24 (ref), u54 (ref), u31 (ref), u132 (ref), u32 (ref), l__TweenService__7 (copy), u311 (copy), u390 (copy), l__Config__19 (copy), u25 (ref), u30 (ref), u66 (ref), u303 (ref), u64 (copy), u16 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), l__Crosshair__40 (copy), l__PlayerGui__45 (copy), l__HUD__14 (copy), l__HeatseekModule__34 (copy), l__JavelinGui__37 (copy), u410 (copy), u18 (ref), u17 (ref), u36 (ref), u40 (ref), u37 (ref), u60 (copy), u208 (ref), l__Events__12 (copy), u6 (ref), u62 (ref), l__GuiModule__32 (copy)
    l__Control__36.resolveQueue();
    UpdateGui();
    local l__SeatPart__99 = l__Humanoid__41.SeatPart;
    local v412 = l__CameraRotation__35;
    if l__SeatPart__99 then
        l__SeatPart__99 = l__SeatPart__99.Name == "TurretSeat" and l__SeatPart__99.Parent.Parent:FindFirstChild("gun") or l__SeatPart__99.Name == "GunnerSeat";
    end;
    v412.IsTurret = l__SeatPart__99;
    local v413 = l__Humanoid__41.MoveDirection:Dot(l__CurrentCamera__3.CFrame.LookVector);
    local v414 = l__LocalPlayer__2.CameraMode ~= Enum.CameraMode.LockFirstPerson;
    if l__Control__36.isInProgress("Sprint") and (l__Humanoid__41.MoveDirection.Magnitude <= 0 or v413 <= 0.5 and not v414) then
        coroutine.wrap(function() --[[ Line: 3174 ]]
            -- upvalues: l__Control__36 (ref), u26 (ref)
            l__Control__36.stop("Sprint", u26);
        end)();
    end;
    u51.Mult = math.min(1, u51.Mult + p411 * u51.RecoveryRate);
    setWalkSpeed();
    HeadMovement();
    renderCam();
    u373();
    u374(p411);
    if u9 and (u11 and (u12 and u5)) then
        local v415 = u7.adsTime or 0.2;
        if l__Control__36.isInProgress("ADS") then
            u61.Progress = math.min(u61.Progress + p411 / v415, 1);
        else
            u61.Progress = math.max(u61.Progress - p411 / v415, 0);
        end;
        if u74.FireAfterAim then
            local v416 = {
                UserInputType = Enum.UserInputType.Touch
            };
            if u61.Progress >= 1 and not u74.FireStarted then
                u74.FireStarted = true;
                handleAction("Fire", Enum.UserInputState.Begin, v416);
            elseif u61.Progress < 1 and u74.FireStarted then
                u74.FireAfterAim = false;
                u74.FireStarted = false;
                handleAction("Fire", Enum.UserInputState.End, v416);
            end;
        end;
        local v417 = l__UserInputService__4:GetMouseDelta();
        local v418 = l__Control__36.isInProgress("ADS") and 0.3 or 1;
        local v419 = u8 and u8.Keyframes;
        local v420 = v418 * ((v419 and true or v419) and 1 or 0.2);
        local v421 = {
            X = math.clamp(v417.X, -10, 10) * v420 * p411,
            Y = math.clamp(v417.Y, -10, 10) * v420 * p411
        };
        u65.Sway:shove(Vector3.new(v421.X, v421.Y, 0) * 0.015);
        local v422 = u8 and u8.Keyframes;
        if v422 and true or v422 then
            u10.CFrame = l__CurrentCamera__3.CFrame * u55 * u59;
        else
            u10.CFrame = l__CurrentCamera__3.CFrame * CFrame.new(0, 0, -0.5) * u55 * u59;
        end;
        if not u8.GunModelFixed then
            local v423 = u8 and u8.Keyframes;
            if not (v423 or v423) then
                u5:SetPrimaryPartCFrame(u10.CFrame * u56);
            end;
        end;
        if l__Humanoid__41:GetState() == Enum.HumanoidStateType.Running then
            if l__Control__36.isInProgress("Sprint") then
                local v424 = (u51.Mult == 1 and (u24 or 7) or 7) * 1.1;
                local v425 = u59;
                local l__new__100 = CFrame.new;
                local v426 = -0.045 * (v424 / 3);
                local v427 = tick() * 8 * v424 / 16;
                local v428 = v426 * math.sin(v427);
                local v429 = 0.04 * (v424 / 10);
                local v430 = tick() * 8 / 2.7;
                local v431 = v428 + v429 * math.sin(v430);
                local v432 = 0.025 * (v424 / 3);
                local v433 = tick() * 16 * v424 / 16 + 70;
                local v434 = v432 * math.cos(v433);
                local v435 = 0.02 * (v424 / 10);
                local v436 = tick() * 8 / 5;
                local v437 = l__new__100(v431, v434 + v435 * math.cos(v436), 0);
                local l__Angles__101 = CFrame.Angles;
                local v438 = 1 * (v424 / 3);
                local v439 = tick() * 16 * v424 / 16;
                local v440 = v438 * math.sin(v439);
                local v441 = math.rad(v440);
                local v442 = 1 * (v424 * 1);
                local v443 = tick() * 8 * v424 / 16 - 105;
                local v444 = v442 * math.cos(v443);
                u59 = v425:Lerp(v437 * l__Angles__101(v441, math.rad(v444), 0), p411 / 0.17);
            elseif l__Control__36.isInProgress("Slide") then
                local v445 = u51.Mult == 1 and (u24 or 7) or 7;
                u59 = u59:Lerp(CFrame.new(v445 * 0.003 * (0.5 - math.random()), v445 * 0.003 * (0.5 - math.random()), 0), p411 * 4);
            elseif l__Control__36.isInProgress("ADS") then
                local v446 = u51.Mult == 1 and (u24 or 7) or 7;
                local v447 = l__CurrentCamera__3;
                local l__CFrame__102 = l__CurrentCamera__3.CFrame;
                local l__Angles__103 = CFrame.Angles;
                local v448 = p411 * 7 * (v446 / 15);
                local v449 = tick() * 16 * v446 / 16;
                local v450 = v448 * math.sin(v449);
                local v451 = math.rad(v450);
                local v452 = p411 * 7 * (v446 / 30);
                local v453 = tick() * 8 * v446 / 16 - 90;
                local v454 = v452 * math.cos(v453);
                v447.CFrame = l__CFrame__102 * l__Angles__103(v451, math.rad(v454), 0);
                local v455 = l__CurrentCamera__3;
                local l__CFrame__104 = l__CurrentCamera__3.CFrame;
                local l__Angles__105 = CFrame.Angles;
                local v456 = tick() * 2.5 - 2.356194490192345;
                local v457 = math.cos(v456) * 0.002;
                v455.CFrame = l__CFrame__104 * l__Angles__105(math.rad(v457), 0, 0);
                if not u7.IsAimingStill then
                    local v458 = u59;
                    local l__new__106 = CFrame.new;
                    local v459 = tick() * 1.5;
                    local v460 = math.sin(v459) * 0.004;
                    local v461 = tick() * 2.5;
                    u59 = v458:Lerp(l__new__106(v460, math.cos(v461) * 0.004, 0), p411 * 5);
                end;
            elseif l__Control__36.isInProgress("Walk") then
                local v462 = (u51.Mult == 1 and (u24 or 7) or 7) * 1.3;
                local v463 = u59;
                local l__new__107 = CFrame.new;
                local v464 = 0.025 * (v462 / 10);
                local v465 = tick() * 8 * v462 / 16;
                local v466 = v464 * math.sin(v465);
                local v467 = 0.025 * (v462 / 10);
                local v468 = tick() * 16 * v462 / 16;
                local v469 = l__new__107(v466, v467 * math.cos(v468), 0);
                local l__Angles__108 = CFrame.Angles;
                local v470 = 1 * (v462 / 10);
                local v471 = tick() * 16 * v462 / 16;
                local v472 = v470 * math.sin(v471);
                local v473 = math.rad(v472);
                local v474 = 1 * (v462 / 10);
                local v475 = tick() * 8 * v462 / 16;
                local v476 = v474 * math.cos(v475);
                u59 = v463:Lerp(v469 * l__Angles__108(v473, math.rad(v476), 0), p411 * 4);
            else
                local v477 = u59;
                local l__new__109 = CFrame.new;
                local v478 = tick() * 1.5;
                local v479 = math.sin(v478) * 0.01;
                local v480 = tick() * 2.5;
                u59 = v477:Lerp(l__new__109(v479, math.cos(v480) * 0.01, 0), p411 * 4);
            end;
        else
            u59 = u59:Lerp(CFrame.new(), 0.1);
        end;
        local _ = (u7.adsTime or 0.2) / u54.AdsTime;
        local v481 = u31;
        if v481 then
            v481 = l__Control__36.isInProgress("ADS");
        end;
        local v482 = u8 and u8.Keyframes;
        if (v482 and true or v482) and (l__Control__36.isInProgress("Reload") and (u132 and u132.ADS)) then
            local l__Normal__110 = u132.Normal;
            local l__ADS__111 = u132.ADS;
            if not l__Control__36.isInProgress("Sprint") then
                l__Normal__110:AdjustWeight(math.max(0.001, 1 - u61.Progress), 0);
                l__ADS__111:AdjustWeight(math.max(0.001, u61.Progress), 0);
            end;
        end;
        local function v488(p483, p484) --[[ Line: 3301 ]]
            -- upvalues: u5 (ref), u32 (ref)
            local v485 = not (p484 and u5:GetDescendants()) and u32;
            if v485 then
                v485 = u32:GetDescendants();
            end;
            if v485 then
                for _, v486 in ipairs(v485) do
                    if v486.Name == "GetsHidden" and v486:IsA("BasePart") then
                        v486.Transparency = p483;
                        for _, v487 in ipairs(v486:GetChildren()) do
                            if v487:IsA("Texture") then
                                v487.Transparency = p483;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        local v489 = l__TweenService__7:GetValue(u61.Progress, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
        local v490 = u8 and u8.Keyframes;
        local v491 = (v490 and true or v490) and CFrame.new() or u8.MainCFrame;
        if l__Control__36.isInProgress("Slide") then
            v491 = v491 * u311.CamCFrame.Value;
        end;
        local v492 = u390(p411, v489);
        local v493 = l__Control__36.isInProgress("Slide") and l__Config__19.SlideFOV or (u25 and l__Config__19.SprintFOV or l__Config__19.DefaultFOV);
        local v494;
        if l__Control__36.isInProgress("NVG") and u5.AimPart:FindFirstChild("NVAim") or u30 ~= 1 then
            v494 = v493;
        else
            v494 = u54.ZoomValue;
        end;
        if l__Control__36.isInProgress("Reload") or l__Control__36.isInProgress("Pump") then
            v494 = math.min(v493, v494 + 5);
        end;
        if u61.AnimFinished then
            local v495 = l__CurrentCamera__3;
            local l__FieldOfView__112 = l__CurrentCamera__3.FieldOfView;
            if v481 then
                v493 = v494 or v493;
            end;
            v495.FieldOfView = l__FieldOfView__112 + (v493 - l__FieldOfView__112) * 0.14;
            u55 = (u55 * u66:Inverse()):Lerp(v481 and u55 * CFrame.new(0, 0, -0.5) * u31.CFrame:toObjectSpace(l__CurrentCamera__3.CFrame) or v491 * u303, 0.14) * v492;
        else
            local v497 = CFrame.fromAxisAngle(Vector3.new(0, 0, 1), ((function() --[[ Name: getAimCamber, Line 3355 ]]
                -- upvalues: u61 (ref)
                local l__Progress__113 = u61.Progress;
                local v496 = 0 + 0.1 * l__Progress__113;
                return (v496 + (0.1 + 0.9 * l__Progress__113 - v496) * l__Progress__113) * 0.5;
            end)()));
            local v498 = l__CurrentCamera__3;
            local v499 = math.max(l__CurrentCamera__3.FieldOfView, v493);
            v498.FieldOfView = v499 + (v494 - v499) * v489;
            u55 = (v491 * u303 * v497):Lerp(u55 * CFrame.new(0, 0, -0.5) * u31.CFrame:toObjectSpace(l__CurrentCamera__3.CFrame), v489) * v492;
        end;
        u66 = v492;
        v488(u61.Progress >= 0.75 and 1 or 0, u7.Type == "Stinger");
        u61.AnimFinished = u61.Progress == 0 and true or u61.Progress == 1;
        for _, v500 in pairs(u5:GetDescendants()) do
            if v500:IsA("BasePart") and v500.Name == "SightMark" then
                local v501 = v500.CFrame:pointToObjectSpace(l__CurrentCamera__3.CFrame.Position) / v500.Size;
                v500.SurfaceGui.Border.Scope.Position = UDim2.new(0.5 + v501.x, 0, 0.5 - v501.y, 0);
            end;
        end;
        if u7.CrossHair then
            local v502 = DateTime.now().UnixTimestampMillis - u64.LastShot;
            local v503 = math.min(100, v502) / 100;
            local v504 = 1 + -0.9 * v503;
            local v505 = (u7.CrosshairOffset + (u16 or 0) + u24 * u7.WalkMult) / 500 + (v504 + (0.1 + -0.1 * v503 - v504) * v503) / 70;
            local v506 = UDim2.new(0.5, 0, 0.5, 0);
            u20 = UDim2.new(0.5, 0, 0.5 - v505, 0):Lerp(v506, v489);
            u21 = UDim2.new(0.5, 0, 0.5 + v505, 0):Lerp(v506, v489);
            u22 = UDim2.new(0.5 - v505, 0, 0.5, 0):Lerp(v506, v489);
            u23 = UDim2.new(0.5 + v505, 0, 0.5, 0):Lerp(v506, v489);
        else
            u20 = u20:Lerp(UDim2.new(0.5, 0, 0.5, 0), 0.2);
            u21 = u21:Lerp(UDim2.new(0.5, 0, 0.5, 0), 0.2);
            u22 = u22:Lerp(UDim2.new(0.5, 0, 0.5, 0), 0.2);
            u23 = u23:Lerp(UDim2.new(0.5, 0, 0.5, 0), 0.2);
        end;
        l__Crosshair__40.Up.Position = u20;
        l__Crosshair__40.Down.Position = u21;
        l__Crosshair__40.Left.Position = u22;
        l__Crosshair__40.Right.Position = u23;
        if u7.Type == "Stinger" then
            if l__Control__36.isInProgress("ADS") and not l__Control__36.isInProgress("Reload") then
                local v507 = u61.Progress >= 1;
                if not l__PlayerGui__45:FindFirstChild("JavelinNoise") then
                    local v508 = l__HUD__14:WaitForChild("NVGOverlay"):Clone();
                    v508.Parent = l__PlayerGui__45;
                    v508.Enabled = false;
                    v508.Name = "JavelinNoise";
                end;
                local l__JavelinNoise__114 = l__PlayerGui__45.JavelinNoise;
                l__HeatseekModule__34.aimTick(u7.HeatseekTarget or "Air", nil, nil, u5.Name);
                if u7.gunName == "Javelin" then
                    l__JavelinGui__37.Enabled = v507;
                    u410();
                    game:GetService("Lighting").JavelinCorrection.Enabled = v507;
                    l__JavelinNoise__114.Enabled = v507;
                end;
            else
                if l__PlayerGui__45:FindFirstChild("JavelinNoise") then
                    l__PlayerGui__45.JavelinNoise:Destroy();
                end;
                l__HeatseekModule__34.adsStopped();
                l__JavelinGui__37.Enabled = false;
                game:GetService("Lighting").JavelinCorrection.Enabled = false;
            end;
        end;
        if u16 then
            local v509 = time();
            if v509 - u18 > 60 / u7.ShootRate * 2 and (not l__Control__36.isInProgress("Fire") and u16 > u7.MinSpread * u54.HipSpread) then
                u16 = math.max(u7.MinSpread * u54.HipSpread, u16 - u7.AimInaccuracyDecrease or 0);
            end;
            if v509 - u18 > 60 / u7.ShootRate * 1.5 and (not l__Control__36.isInProgress("Fire") and u17 > u7.MinRecoilPower) then
                u17 = math.max(u7.MinRecoilPower, u17 - u7.RecoilPowerStepAmount);
            end;
        end;
        if u36 and u40 ~= nil then
            if l__Control__36.isInProgress("NVG") then
                u40.Transparency = 0;
                u40.Beam.Enabled = true;
            else
                if l__Config__19.RealisticLaser then
                    u40.Beam.Enabled = false;
                else
                    u40.Beam.Enabled = true;
                end;
                if u37 then
                    u40.Transparency = 1;
                else
                    u40.Transparency = 0;
                end;
            end;
            for _, v510 in pairs(u5:GetDescendants()) do
                if v510:IsA("BasePart") and v510.Name == "LaserPoint" then
                    local v511 = Ray.new(v510.CFrame.Position, v510.CFrame.LookVector * 1000);
                    local v512, v513, v514 = workspace:FindPartOnRayWithIgnoreList(v511, u60, false, true);
                    if v512 then
                        u40.CFrame = CFrame.new(v513, v513 + v514);
                    else
                        u40.CFrame = CFrame.new(l__CurrentCamera__3.CFrame.Position + v510.CFrame.LookVector * 2000, v510.CFrame.LookVector);
                    end;
                    if u208 and l__Config__19.ReplicatedLaser then
                        l__Events__12.SVLaser:FireServer(v513, 1, u40.Color, u37, u6);
                    end;
                    break;
                end;
            end;
        end;
    end;
    if not l__Config__19.OneHitKillEnabled then
        local l__Indicators__115 = u62:WaitForChild("HitFrame"):WaitForChild("Indicators");
        for _, v515 in ipairs(l__Indicators__115:GetChildren()) do
            v515.Rotation = l__GuiModule__32.calculateAngle(v515:GetAttribute("Position"));
        end;
    end;
end);
l__ReplicatedStorage__9.GameplayEvents:WaitForChild("DamagedEvent").OnClientEvent:Connect(function(p516, p517, p518) --[[ Line: 3531 ]]
    -- upvalues: l__Config__19 (copy), u62 (ref), l__TweenService__7 (copy), l__Debris__8 (copy)
    if l__Config__19.HitIndicator then
        local v519 = p518 and Color3.new(0.9372549019607843, 0.9215686274509803, 0.9137254901960784) or Color3.new(1, 0.27058823529411763, 0);
        local l__HitFrame__116 = u62:WaitForChild("HitFrame");
        local l__Indicators__117 = l__HitFrame__116:WaitForChild("Indicators");
        local v520 = l__HitFrame__116:WaitForChild("OriginalHitIndicator"):Clone();
        v520:SetAttribute("Position", p516);
        v520.Parent = l__Indicators__117;
        local l__Image__118 = v520:WaitForChild("Image");
        l__Image__118.Visible = true;
        l__Image__118.ImageColor3 = v519;
        local v521 = math.max(p517 / 70, 1);
        l__Image__118.ImageTransparency = 1 - v521;
        l__TweenService__7:Create(l__Image__118, TweenInfo.new(v521 * 2.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 1, false, 2.5), {
            ImageTransparency = 1
        }):Play();
        l__Debris__8:AddItem(v520, 5);
    end;
end);
l__Events__12.Refil.OnClientEvent:Connect(function(p522, _, p523) --[[ Line: 3561 ]]
    -- upvalues: u6 (ref), u7 (ref), u4 (ref)
    local l__Value__119 = p523.Value;
    if p522:FindFirstChild("ACS_Settings") then
        local l__ACS_Settings__120 = require(p522.ACS_Settings);
        local v524 = math.min(l__ACS_Settings__120.MaxStoredAmmo - l__ACS_Settings__120.StoredAmmo, l__Value__119);
        l__ACS_Settings__120.StoredAmmo = l__ACS_Settings__120.StoredAmmo + v524;
        if u6 == p522 and u7 then
            u4 = l__ACS_Settings__120.StoredAmmo;
        end;
    end;
end);
if l__Config__19.DropAmmoEnabled then
    l__PlayerEvents__30:WaitForChild("DropGiveAmmo").OnClientEvent:Connect(function(u525) --[[ Line: 3566 ]]
        -- upvalues: l__LocalPlayer__2 (copy), u1 (copy), u6 (ref), u7 (ref), u4 (ref)
        local l__Backpack__121 = l__LocalPlayer__2.Backpack;
        local v526 = u1:FindFirstChildOfClass("Tool");
        local v527 = l__Backpack__121:GetChildren();
        local function v532(p528) --[[ Line: 3572 ]]
            -- upvalues: u525 (copy), u6 (ref), u7 (ref), u4 (ref)
            if p528 then
                local v529 = p528:FindFirstChild("Type") and (p528.Type.Value or "Primary") or "Primary";
                if table.find(u525, v529) then
                    local v530 = p528:FindFirstChild("ACS_Settings");
                    if v530 then
                        local l__Ammo__122 = require(v530).Ammo;
                        if p528:FindFirstChild("ACS_Settings") then
                            local l__ACS_Settings__123 = require(p528.ACS_Settings);
                            local v531 = math.min(l__ACS_Settings__123.MaxStoredAmmo - l__ACS_Settings__123.StoredAmmo, l__Ammo__122);
                            l__ACS_Settings__123.StoredAmmo = l__ACS_Settings__123.StoredAmmo + v531;
                            if u6 == p528 and u7 then
                                u4 = l__ACS_Settings__123.StoredAmmo;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        v532(v526);
        for _, v533 in v527 do
            v532(v533);
        end;
    end);
end;
l__ReplicatedStorage__9:WaitForChild("PlayerEvents"):WaitForChild("ShouldEquip").OnClientEvent:Connect(function(p534) --[[ Line: 3595 ]]
    -- upvalues: l__LocalPlayer__2 (copy)
    local v535 = l__LocalPlayer__2.Backpack:WaitForChild(p534, 7);
    if v535 then
        v535:Equip();
    end;
end);