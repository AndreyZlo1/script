-- Roblox: Players.SilverAce293026.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick
-- Class: ModuleScript
-- Method: bytecode

-- Decompiled with Potassium's decompiler.

local l__Value__1 = Enum.ContextActionPriority.High.Value;
local u1 = {
    0.10999999999999999,
    0.30000000000000004,
    0.4,
    0.5,
    0.6,
    0.7,
    0.75
};
local u2 = #u1;
local u3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local l__Players__2 = game:GetService("Players");
local l__GuiService__3 = game:GetService("GuiService");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__ContextActionService__5 = game:GetService("ContextActionService");
local l__RunService__6 = game:GetService("RunService");
local l__TweenService__7 = game:GetService("TweenService");
local v4, v5 = pcall(function() --[[ Line: 37 ]]
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2");
end);
local u6 = v4 and v5;
local v7, v8 = pcall(function() --[[ Line: 44 ]]
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate");
end);
local u9 = v7 and v8;
local l__LocalPlayer__8 = l__Players__2.LocalPlayer;
if not l__LocalPlayer__8 then
    l__Players__2:GetPropertyChangedSignal("LocalPlayer"):Wait();
    l__LocalPlayer__8 = l__Players__2.LocalPlayer;
end;
local l__BaseCharacterController__9 = require(script.Parent:WaitForChild("BaseCharacterController"));
local u10 = setmetatable({}, l__BaseCharacterController__9);
u10.__index = u10;
function u10.new() --[[ Line: 61 ]]
    -- upvalues: l__BaseCharacterController__9 (copy), u10 (copy)
    local v11 = l__BaseCharacterController__9.new();
    local v12 = setmetatable(v11, u10);
    v12.moveTouchObject = nil;
    v12.moveTouchLockedIn = false;
    v12.moveTouchFirstChanged = false;
    v12.moveTouchStartPosition = nil;
    v12.startImage = nil;
    v12.endImage = nil;
    v12.middleImages = {};
    v12.startImageFadeTween = nil;
    v12.endImageFadeTween = nil;
    v12.middleImageFadeTweens = {};
    v12.isFirstTouch = true;
    v12.thumbstickFrame = nil;
    v12.onRenderSteppedConn = nil;
    v12.fadeInAndOutBalance = 0.5;
    v12.fadeInAndOutHalfDuration = 0.3;
    v12.hasFadedBackgroundInPortrait = false;
    v12.hasFadedBackgroundInLandscape = false;
    v12.tweenInAlphaStart = nil;
    v12.tweenOutAlphaStart = nil;
    return v12;
end;
function u10.GetIsJumping(p13) --[[ Line: 96 ]]
    local l__isJumping__10 = p13.isJumping;
    p13.isJumping = false;
    return l__isJumping__10;
end;
function u10.Enable(p14, p15, p16) --[[ Line: 102 ]]
    -- upvalues: u6 (ref), l__ContextActionService__5 (copy)
    if p15 == nil then
        return false;
    end;
    local v17 = p15 and true or false;
    if p14.enabled == v17 then
        return true;
    end;
    if v17 then
        if not p14.thumbstickFrame then
            p14:Create(p16);
        end;
        p14:BindContextActions();
    else
        if u6 then
            p14:UnbindContextActions();
        else
            l__ContextActionService__5:UnbindAction("DynamicThumbstickAction");
        end;
        p14:OnInputEnded();
    end;
    p14.enabled = v17;
    p14.thumbstickFrame.Visible = v17;
    return nil;
end;
function u10.OnInputEnded(p18) --[[ Line: 131 ]]
    p18.moveTouchObject = nil;
    p18.moveVector = Vector3.new(0, 0, 0);
    p18:FadeThumbstick(false);
end;
function u10.FadeThumbstick(p19, p20) --[[ Line: 137 ]]
    -- upvalues: l__TweenService__7 (copy), u3 (copy), u1 (copy)
    if p20 or not p19.moveTouchObject then
        if p19.isFirstTouch then
        else
            if p19.startImageFadeTween then
                p19.startImageFadeTween:Cancel();
            end;
            if p19.endImageFadeTween then
                p19.endImageFadeTween:Cancel();
            end;
            for v21 = 1, #p19.middleImages do
                if p19.middleImageFadeTweens[v21] then
                    p19.middleImageFadeTweens[v21]:Cancel();
                end;
            end;
            if p20 then
                p19.startImageFadeTween = l__TweenService__7:Create(p19.startImage, u3, {
                    ImageTransparency = 0
                });
                p19.startImageFadeTween:Play();
                p19.endImageFadeTween = l__TweenService__7:Create(p19.endImage, u3, {
                    ImageTransparency = 0.2
                });
                p19.endImageFadeTween:Play();
                for v22 = 1, #p19.middleImages do
                    p19.middleImageFadeTweens[v22] = l__TweenService__7:Create(p19.middleImages[v22], u3, {
                        ImageTransparency = u1[v22]
                    });
                    p19.middleImageFadeTweens[v22]:Play();
                end;
            else
                p19.startImageFadeTween = l__TweenService__7:Create(p19.startImage, u3, {
                    ImageTransparency = 1
                });
                p19.startImageFadeTween:Play();
                p19.endImageFadeTween = l__TweenService__7:Create(p19.endImage, u3, {
                    ImageTransparency = 1
                });
                p19.endImageFadeTween:Play();
                for v23 = 1, #p19.middleImages do
                    p19.middleImageFadeTweens[v23] = l__TweenService__7:Create(p19.middleImages[v23], u3, {
                        ImageTransparency = 1
                    });
                    p19.middleImageFadeTweens[v23]:Play();
                end;
            end;
        end;
    end;
end;
function u10.FadeThumbstickFrame(p24, p25, p26) --[[ Line: 180 ]]
    p24.fadeInAndOutHalfDuration = p25 * 0.5;
    p24.fadeInAndOutBalance = p26;
    p24.tweenInAlphaStart = tick();
end;
function u10.InputInFrame(p27, p28) --[[ Line: 186 ]]
    local l__AbsolutePosition__11 = p27.thumbstickFrame.AbsolutePosition;
    local v29 = l__AbsolutePosition__11 + p27.thumbstickFrame.AbsoluteSize;
    local l__Position__12 = p28.Position;
    return l__Position__12.X >= l__AbsolutePosition__11.X and (l__Position__12.Y >= l__AbsolutePosition__11.Y and (l__Position__12.X <= v29.X and l__Position__12.Y <= v29.Y));
end;
function u10.DoFadeInBackground(p30) --[[ Line: 198 ]]
    -- upvalues: l__LocalPlayer__8 (ref)
    local v31 = l__LocalPlayer__8:FindFirstChildOfClass("PlayerGui");
    local v32 = false;
    if v31 then
        if v31.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or v31.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            v32 = p30.hasFadedBackgroundInLandscape;
            p30.hasFadedBackgroundInLandscape = true;
        elseif v31.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            v32 = p30.hasFadedBackgroundInPortrait;
            p30.hasFadedBackgroundInPortrait = true;
        end;
    end;
    if not v32 then
        p30.fadeInAndOutHalfDuration = 0.3;
        p30.fadeInAndOutBalance = 0.5;
        p30.tweenInAlphaStart = tick();
    end;
end;
function u10.DoMove(p33, p34) --[[ Line: 221 ]]
    local v35;
    if p34.Magnitude < p33.radiusOfDeadZone then
        v35 = Vector3.new(0, 0, 0);
    else
        local v36 = p34.Unit * (1 - math.max(0, (p33.radiusOfMaxSpeed - p34.Magnitude) / p33.radiusOfMaxSpeed));
        v35 = Vector3.new(v36.X, 0, v36.Y);
    end;
    p33.moveVector = v35;
end;
function u10.LayoutMiddleImages(p37, p38, p39) --[[ Line: 239 ]]
    -- upvalues: u2 (copy)
    local v40 = p37.thumbstickSize / 2 + p37.middleSize;
    local v41 = p39 - p38;
    local v42 = v41.Magnitude - p37.thumbstickRingSize / 2 - p37.middleSize;
    local l__Unit__13 = v41.Unit;
    local v43 = p37.middleSpacing * u2;
    local l__middleSpacing__14 = p37.middleSpacing;
    if v43 < v42 then
        l__middleSpacing__14 = v42 / u2;
    end;
    for v44 = 1, u2 do
        local v45 = p37.middleImages[v44];
        local v46 = v40 + l__middleSpacing__14 * (v44 - 2);
        local v47 = v40 + l__middleSpacing__14 * (v44 - 1);
        if v46 < v42 then
            local v48 = p39 - l__Unit__13 * v47;
            local v49 = math.clamp(1 - (v47 - v42) / l__middleSpacing__14, 0, 1);
            v45.Visible = true;
            v45.Position = UDim2.new(0, v48.X, 0, v48.Y);
            v45.Size = UDim2.new(0, p37.middleSize * v49, 0, p37.middleSize * v49);
        else
            v45.Visible = false;
        end;
    end;
end;
function u10.MoveStick(p50, p51) --[[ Line: 270 ]]
    local v52 = Vector2.new(p50.moveTouchStartPosition.X, p50.moveTouchStartPosition.Y) - p50.thumbstickFrame.AbsolutePosition;
    local v53 = Vector2.new(p51.X, p51.Y) - p50.thumbstickFrame.AbsolutePosition;
    p50.endImage.Position = UDim2.new(0, v53.X, 0, v53.Y);
    p50:LayoutMiddleImages(v52, v53);
end;
function u10.BindContextActions(u54) --[[ Line: 278 ]]
    -- upvalues: l__TweenService__7 (copy), u6 (ref), l__ContextActionService__5 (copy), l__Value__1 (copy), l__UserInputService__4 (copy)
    local function u57(p55) --[[ Line: 279 ]]
        -- upvalues: u54 (copy), l__TweenService__7 (ref)
        if u54.moveTouchObject then
            return Enum.ContextActionResult.Pass;
        end;
        if not u54:InputInFrame(p55) then
            return Enum.ContextActionResult.Pass;
        end;
        if u54.isFirstTouch then
            u54.isFirstTouch = false;
            local v56 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
            l__TweenService__7:Create(u54.startImage, v56, {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play();
            l__TweenService__7:Create(u54.endImage, v56, {
                Size = UDim2.new(0, u54.thumbstickSize, 0, u54.thumbstickSize),
                ImageColor3 = Color3.new(0, 0, 0)
            }):Play();
        end;
        u54.moveTouchLockedIn = false;
        u54.moveTouchObject = p55;
        u54.moveTouchStartPosition = p55.Position;
        u54.moveTouchFirstChanged = true;
        u54:DoFadeInBackground();
        return Enum.ContextActionResult.Pass;
    end;
    local function u61(p58) --[[ Line: 311 ]]
        -- upvalues: u54 (copy)
        if p58 ~= u54.moveTouchObject then
            return Enum.ContextActionResult.Pass;
        end;
        if u54.moveTouchFirstChanged then
            u54.moveTouchFirstChanged = false;
            local v59 = Vector2.new(p58.Position.X - u54.thumbstickFrame.AbsolutePosition.X, p58.Position.Y - u54.thumbstickFrame.AbsolutePosition.Y);
            u54.startImage.Visible = true;
            u54.startImage.Position = UDim2.new(0, v59.X, 0, v59.Y);
            u54.endImage.Visible = true;
            u54.endImage.Position = u54.startImage.Position;
            u54:FadeThumbstick(true);
            u54:MoveStick(p58.Position);
        end;
        u54.moveTouchLockedIn = true;
        local v60 = Vector2.new(p58.Position.X - u54.moveTouchStartPosition.X, p58.Position.Y - u54.moveTouchStartPosition.Y);
        if math.abs(v60.X) > 0 or math.abs(v60.Y) > 0 then
            u54:DoMove(v60);
            u54:MoveStick(p58.Position);
        end;
        return Enum.ContextActionResult.Sink;
    end;
    l__ContextActionService__5:BindActionAtPriority("DynamicThumbstickAction", function(_, p62, p63) --[[ Name: handleInput, Line 354 ]]
        -- upvalues: u57 (copy), u6 (ref), u54 (copy), u61 (copy)
        if p62 == Enum.UserInputState.Begin then
            return u57(p63);
        elseif p62 == Enum.UserInputState.Change then
            if u6 then
                if p63 == u54.moveTouchObject then
                    return Enum.ContextActionResult.Sink;
                else
                    return Enum.ContextActionResult.Pass;
                end;
            else
                return u61(p63);
            end;
        else
            if p62 == Enum.UserInputState.End then
                if p63 == u54.moveTouchObject then
                    u54:OnInputEnded();
                    if u54.moveTouchLockedIn then
                        return Enum.ContextActionResult.Sink;
                    end;
                end;
                return Enum.ContextActionResult.Pass;
            end;
            if p62 == Enum.UserInputState.Cancel then
                u54:OnInputEnded();
            end;
        end;
    end, false, l__Value__1, Enum.UserInputType.Touch);
    if u6 then
        u54.TouchMovedCon = l__UserInputService__4.TouchMoved:Connect(function(p64, _) --[[ Line: 382 ]]
            -- upvalues: u61 (copy)
            u61(p64);
        end);
    end;
end;
function u10.UnbindContextActions(p65) --[[ Line: 388 ]]
    -- upvalues: l__ContextActionService__5 (copy)
    l__ContextActionService__5:UnbindAction("DynamicThumbstickAction");
    if p65.TouchMovedCon then
        p65.TouchMovedCon:Disconnect();
    end;
end;
function u10.Create(u66, p67) --[[ Line: 396 ]]
    -- upvalues: u9 (ref), u2 (copy), u1 (copy), l__RunService__6 (copy), l__UserInputService__4 (copy), l__GuiService__3 (copy), l__LocalPlayer__8 (ref)
    if u66.thumbstickFrame then
        u66.thumbstickFrame:Destroy();
        u66.thumbstickFrame = nil;
        if u66.onRenderSteppedConn then
            u66.onRenderSteppedConn:Disconnect();
            u66.onRenderSteppedConn = nil;
        end;
    end;
    u66.thumbstickSize = 45;
    u66.thumbstickRingSize = 20;
    u66.middleSize = 10;
    u66.middleSpacing = u66.middleSize + 4;
    u66.radiusOfDeadZone = 2;
    u66.radiusOfMaxSpeed = 20;
    local l__AbsoluteSize__15 = p67.AbsoluteSize;
    if math.min(l__AbsoluteSize__15.X, l__AbsoluteSize__15.Y) > 500 then
        u66.thumbstickSize = u66.thumbstickSize * 2;
        u66.thumbstickRingSize = u66.thumbstickRingSize * 2;
        u66.middleSize = u66.middleSize * 2;
        u66.middleSpacing = u66.middleSpacing * 2;
        u66.radiusOfDeadZone = u66.radiusOfDeadZone * 2;
        u66.radiusOfMaxSpeed = u66.radiusOfMaxSpeed * 2;
    end;
    local u68 = u9 and 100 or 0;
    u66.thumbstickFrame = Instance.new("Frame");
    u66.thumbstickFrame.BorderSizePixel = 0;
    u66.thumbstickFrame.Name = "DynamicThumbstickFrame";
    u66.thumbstickFrame.Visible = false;
    u66.thumbstickFrame.BackgroundTransparency = 1;
    u66.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    u66.thumbstickFrame.Active = false;
    u66.thumbstickFrame.Size = UDim2.new(0.4, u68, 0.6666666666666666, u68);
    u66.thumbstickFrame.Position = UDim2.new(0, -u68, 0.3333333333333333, 0);
    u66.startImage = Instance.new("ImageLabel");
    u66.startImage.Name = "ThumbstickStart";
    u66.startImage.Visible = true;
    u66.startImage.BackgroundTransparency = 1;
    u66.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u66.startImage.ImageRectOffset = Vector2.new(1, 1);
    u66.startImage.ImageRectSize = Vector2.new(144, 144);
    u66.startImage.ImageColor3 = Color3.new(0, 0, 0);
    u66.startImage.AnchorPoint = Vector2.new(0.5, 0.5);
    u66.startImage.Position = UDim2.new(0, u66.thumbstickRingSize * 3.3 + u68, 1, -u66.thumbstickRingSize * 2.8 - u68);
    u66.startImage.Size = UDim2.new(0, u66.thumbstickRingSize * 3.7, 0, u66.thumbstickRingSize * 3.7);
    u66.startImage.ZIndex = 10;
    u66.startImage.Parent = u66.thumbstickFrame;
    u66.endImage = Instance.new("ImageLabel");
    u66.endImage.Name = "ThumbstickEnd";
    u66.endImage.Visible = true;
    u66.endImage.BackgroundTransparency = 1;
    u66.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
    u66.endImage.ImageRectOffset = Vector2.new(1, 1);
    u66.endImage.ImageRectSize = Vector2.new(144, 144);
    u66.endImage.AnchorPoint = Vector2.new(0.5, 0.5);
    u66.endImage.Position = u66.startImage.Position;
    u66.endImage.Size = UDim2.new(0, u66.thumbstickSize * 0.8, 0, u66.thumbstickSize * 0.8);
    u66.endImage.ZIndex = 10;
    u66.endImage.Parent = u66.thumbstickFrame;
    local function u70(p69) --[[ Line: 425 ]]
        -- upvalues: u66 (copy), u68 (copy)
        if p69 then
            u66.thumbstickFrame.Size = UDim2.new(1, u68, 0.4, u68);
            u66.thumbstickFrame.Position = UDim2.new(0, -u68, 0.6, 0);
        else
            u66.thumbstickFrame.Size = UDim2.new(0.4, u68, 0.6666666666666666, u68);
            u66.thumbstickFrame.Position = UDim2.new(0, -u68, 0.3333333333333333, 0);
        end;
    end;
    for v71 = 1, u2 do
        u66.middleImages[v71] = Instance.new("ImageLabel");
        u66.middleImages[v71].Name = "ThumbstickMiddle";
        u66.middleImages[v71].Visible = false;
        u66.middleImages[v71].BackgroundTransparency = 1;
        u66.middleImages[v71].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
        u66.middleImages[v71].ImageRectOffset = Vector2.new(1, 1);
        u66.middleImages[v71].ImageRectSize = Vector2.new(144, 144);
        u66.middleImages[v71].ImageTransparency = u1[v71];
        u66.middleImages[v71].AnchorPoint = Vector2.new(0.5, 0.5);
        u66.middleImages[v71].ZIndex = 9;
        u66.middleImages[v71].Parent = u66.thumbstickFrame;
    end;
    local u72 = nil;
    local function v74() --[[ Line: 486 ]]
        -- upvalues: u72 (ref), u70 (copy)
        if u72 then
            u72:Disconnect();
            u72 = nil;
        end;
        local l__CurrentCamera__16 = workspace.CurrentCamera;
        if l__CurrentCamera__16 then
            local function v73() --[[ Line: 493 ]]
                -- upvalues: l__CurrentCamera__16 (copy), u70 (ref)
                local l__ViewportSize__17 = l__CurrentCamera__16.ViewportSize;
                u70(l__ViewportSize__17.X < l__ViewportSize__17.Y);
            end;
            u72 = l__CurrentCamera__16:GetPropertyChangedSignal("ViewportSize"):Connect(v73);
            local l__ViewportSize__18 = l__CurrentCamera__16.ViewportSize;
            u70(l__ViewportSize__18.X < l__ViewportSize__18.Y);
        end;
    end;
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v74);
    if workspace.CurrentCamera then
        v74();
    end;
    u66.moveTouchStartPosition = nil;
    u66.startImageFadeTween = nil;
    u66.endImageFadeTween = nil;
    u66.middleImageFadeTweens = {};
    u66.onRenderSteppedConn = l__RunService__6.RenderStepped:Connect(function() --[[ Line: 513 ]]
        -- upvalues: u66 (copy)
        if u66.tweenInAlphaStart == nil then
            if u66.tweenOutAlphaStart ~= nil then
                local v75 = tick() - u66.tweenOutAlphaStart;
                local v76 = u66.fadeInAndOutHalfDuration * 2 - u66.fadeInAndOutHalfDuration * 2 * u66.fadeInAndOutBalance;
                u66.thumbstickFrame.BackgroundTransparency = math.min(v75 / v76, 1) * 0.35 + 0.65;
                if v76 < v75 then
                    u66.tweenOutAlphaStart = nil;
                end;
            end;
        else
            local v77 = tick() - u66.tweenInAlphaStart;
            local v78 = u66.fadeInAndOutHalfDuration * 2 * u66.fadeInAndOutBalance;
            u66.thumbstickFrame.BackgroundTransparency = 1 - math.min(v77 / v78, 1) * 0.35;
            if v78 < v77 then
                u66.tweenOutAlphaStart = tick();
                u66.tweenInAlphaStart = nil;
            end;
        end;
    end);
    u66.onTouchEndedConn = l__UserInputService__4.TouchEnded:connect(function(p79) --[[ Line: 532 ]]
        -- upvalues: u66 (copy)
        if p79 == u66.moveTouchObject then
            u66:OnInputEnded();
        end;
    end);
    l__GuiService__3.MenuOpened:connect(function() --[[ Line: 538 ]]
        -- upvalues: u66 (copy)
        if u66.moveTouchObject then
            u66:OnInputEnded();
        end;
    end);
    local u80 = l__LocalPlayer__8:FindFirstChildOfClass("PlayerGui");
    while not u80 do
        l__LocalPlayer__8.ChildAdded:wait();
        u80 = l__LocalPlayer__8:FindFirstChildOfClass("PlayerGui");
    end;
    local u81 = nil;
    local u82 = u80.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft and true or u80.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight;
    local _ = u80:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() --[[ Line: 560 ]]
        -- upvalues: u82 (copy), u80 (ref), u81 (ref), u66 (copy)
        if u82 and u80.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait or not u82 and u80.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait then
            u81:disconnect();
            u66.fadeInAndOutHalfDuration = 2.5;
            u66.fadeInAndOutBalance = 0.05;
            u66.tweenInAlphaStart = tick();
            if u82 then
                u66.hasFadedBackgroundInPortrait = true;
                return;
            end;
            u66.hasFadedBackgroundInLandscape = true;
        end;
    end);
    u66.thumbstickFrame.Parent = p67;
    if game:IsLoaded() then
        u66.fadeInAndOutHalfDuration = 2.5;
        u66.fadeInAndOutBalance = 0.05;
        u66.tweenInAlphaStart = tick();
    else
        coroutine.wrap(function() --[[ Line: 580 ]]
            -- upvalues: u66 (copy)
            game.Loaded:Wait();
            u66.fadeInAndOutHalfDuration = 2.5;
            u66.fadeInAndOutBalance = 0.05;
            u66.tweenInAlphaStart = tick();
        end)();
    end;
end;
return u10;