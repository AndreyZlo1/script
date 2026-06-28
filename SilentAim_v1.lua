--[[
    SilentAim v3 — ACS Engine (FastCastRedux)
    
    Исправления v2 → v3:
      КРИТИЧЕСКИЙ ФИЧ: workspace:Raycast() НЕЛЬЗЯ вызывать внутри hookmetamethod-хука.
      На большинстве экзплойтов (Fluxus, Delta, Arceus X, Electron) game и workspace
      делят одну метатаблицу — рекурсивный __namecall вызов Raycast падает с ошибкой
      "Raycast is not a valid member of RemoteEvent".
      
      Решение: findTarget() вызывается ТОЛЬКО из RenderStepped (вне хука).
      Результат кешируется в currentTargetPos.
      Хук только читает кеш — никаких сервисных вызовов внутри.
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    Enabled       = true,
    FOV           = 250,
    AimPart       = "Head",        -- "Head" | "HumanoidRootPart" | "UpperTorso"
    TeamCheck     = true,
    WallCheck     = true,
    PredictLead   = true,
    LeadFactor    = 0.085,
    ShowFOV       = true,
    ShowLine      = true,
    ShowName      = true,
    LineColorLock = Color3.fromRGB(0, 255, 80),
    FOVColor      = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
--  СЕРВИСЫ
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

-- ============================================================
--  DRAWING
-- ============================================================
local drawFOV, drawLine, drawLineDot, drawName

drawFOV           = Drawing.new("Circle")
drawFOV.Visible   = false
drawFOV.Radius    = CONFIG.FOV
drawFOV.Color     = CONFIG.FOVColor
drawFOV.Thickness = 1
drawFOV.Filled    = false
drawFOV.Transparency = 0.55

drawLine           = Drawing.new("Line")
drawLine.Visible   = false
drawLine.Thickness = 1.5
drawLine.Color     = CONFIG.LineColorLock
drawLine.Transparency = 0.85

drawLineDot           = Drawing.new("Circle")
drawLineDot.Visible   = false
drawLineDot.Radius    = 5
drawLineDot.Filled    = true
drawLineDot.Color     = CONFIG.LineColorLock
drawLineDot.Transparency = 0.85

drawName              = Drawing.new("Text")
drawName.Visible      = false
drawName.Size         = 14
drawName.Color        = Color3.fromRGB(255, 255, 255)
drawName.Outline      = true
drawName.OutlineColor = Color3.fromRGB(0, 0, 0)
drawName.Center       = true

-- ============================================================
--  ВСПОМОГАТЕЛЬНЫЕ (только чистая математика — без сервисных вызовов)
-- ============================================================
local function getHitPart(char)
    return char:FindFirstChild(CONFIG.AimPart) or char:FindFirstChild("HumanoidRootPart")
end

local function isSameTeam(player)
    if not CONFIG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == player.Team
end

-- Raycast-проверка стены — вызывается ТОЛЬКО из RenderStepped, НИКОГДА из хука
local _rayParams = RaycastParams.new()
_rayParams.FilterType = Enum.RaycastFilterType.Exclude
local function hasWall(origin, targetPos, char)
    if not CONFIG.WallCheck then return false end
    local filter = {Camera}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    table.insert(filter, char)
    _rayParams.FilterDescendantsInstances = filter
    local result = workspace:Raycast(origin, targetPos - origin, _rayParams)
    return result ~= nil
end

local function worldToScreen(pos)
    local sp, vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), vis
end

local function screenCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function predictPos(hitPart, spd)
    local root = hitPart.Parent:FindFirstChild("HumanoidRootPart") or hitPart
    local vel  = root.AssemblyLinearVelocity
    if not CONFIG.PredictLead then return hitPart.Position end
    local dist   = (hitPart.Position - Camera.CFrame.Position).Magnitude
    local travel = dist / math.max(spd, 1)
    return hitPart.Position + vel * travel * CONFIG.LeadFactor
end

-- ============================================================
--  КЕШ ЦЕЛИ — обновляется из RenderStepped
--  Хук ТОЛЬКО читает эти переменные, сам ничего не вычисляет
-- ============================================================
local cachedTarget    = nil   -- Player | nil
local cachedTargetPos = nil   -- Vector3 | nil
local cachedOriginPos = nil   -- Vector3 | nil (позиция камеры в момент кеша)

local function updateTargetCache()
    local center = screenCenter()
    local origin = Camera.CFrame.Position
    local bestPlayer, bestPos, bestDist = nil, nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if isSameTeam(player) then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = getHitPart(char)
        if not part then continue end
        local predPos = predictPos(part, 1000)
        local sp, vis = worldToScreen(predPos)
        if not vis then continue end
        local dist = (sp - center).Magnitude
        if dist > CONFIG.FOV then continue end
        if hasWall(origin, predPos, char) then continue end  -- Raycast вне хука — безопасно
        if dist < bestDist then
            bestDist   = dist
            bestPlayer = player
            bestPos    = predPos
        end
    end

    cachedTarget    = bestPlayer
    cachedTargetPos = bestPos
    cachedOriginPos = origin
end

-- ============================================================
--  RENDER LOOP — обновление кеша + Drawing
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not CONFIG.Enabled then
        drawFOV.Visible    = false
        drawLine.Visible   = false
        drawLineDot.Visible = false
        drawName.Visible   = false
        return
    end

    -- 1. Обновляем кеш (здесь можно делать Raycast)
    updateTargetCache()

    local center = screenCenter()

    -- 2. FOV круг
    drawFOV.Position = center
    drawFOV.Visible  = CONFIG.ShowFOV
    drawFOV.Radius   = CONFIG.FOV

    -- 3. Drawing линия / имя
    if cachedTarget and cachedTargetPos then
        local sp, vis = worldToScreen(cachedTargetPos)

        drawLine.Visible   = CONFIG.ShowLine and vis
        drawLine.From      = center
        drawLine.To        = sp
        drawLine.Color     = CONFIG.LineColorLock

        drawLineDot.Visible   = CONFIG.ShowLine and vis
        drawLineDot.Position  = sp
        drawLineDot.Color     = CONFIG.LineColorLock

        drawName.Visible   = CONFIG.ShowName and vis
        drawName.Position  = Vector2.new(sp.X, sp.Y - 20)
        drawName.Text      = cachedTarget.Name
    else
        drawLine.Visible    = false
        drawLineDot.Visible = false
        drawName.Visible    = false
    end
end)

-- ============================================================
--  REMOTE — находим ServerBullet
-- ============================================================
local ServerBulletRemote = nil

local function findRemote()
    local rs = game:GetService("ReplicatedStorage")
    local engine = rs:FindFirstChild("ACS_Engine")
    if not engine then engine = rs:WaitForChild("ACS_Engine", 15) end
    if not engine then return nil end
    local events = engine:FindFirstChild("Events")
    if not events then events = engine:WaitForChild("Events", 10) end
    if not events then return nil end
    return events:FindFirstChild("ServerBullet")
end

ServerBulletRemote = findRemote()
if ServerBulletRemote then
    print("[SilentAim v3] Remote OK:", ServerBulletRemote:GetFullName())
else
    warn("[SilentAim v3] Remote не найден, жду...")
    task.spawn(function()
        task.wait(6)
        ServerBulletRemote = findRemote()
        if ServerBulletRemote then
            print("[SilentAim v3] Remote найден:", ServerBulletRemote:GetFullName())
        else
            warn("[SilentAim v3] ServerBullet не найден! Путь: ReplicatedStorage.ACS_Engine.Events.ServerBullet")
        end
    end)
end

-- ============================================================
--  HOOK — только читает кеш, никаких сервисных вызовов внутри
-- ============================================================
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if CONFIG.Enabled
        and method == "FireServer"
        and ServerBulletRemote
        and rawequal(self, ServerBulletRemote)
        and cachedTargetPos  -- есть захваченная цель
    then
        local args = table.pack(...)

        -- Ищем два Vector3: origin (args[1]) и direction (args[2])
        local originIdx, dirIdx
        for i = 1, args.n do
            if typeof(args[i]) == "Vector3" then
                if not originIdx then originIdx = i
                elseif not dirIdx then dirIdx = i; break end
            end
        end

        if originIdx and dirIdx then
            -- ТОЛЬКО арифметика — никаких :Raycast(), :WaitForChild() и т.д.
            local origin = args[originIdx]
            local newDir = (cachedTargetPos - origin)
            if newDir.Magnitude > 0 then
                args[dirIdx] = newDir.Unit
            end
        end

        -- Передаём изменённые аргументы
        return originalNamecall(self, table.unpack(args, 1, args.n))
    end

    return originalNamecall(self, ...)
end))

-- ============================================================
--  KEYBIND: Insert
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = "SilentAim v3",
            Text     = CONFIG.Enabled and "✓ Включён" or "✗ Выключен",
            Duration = 2,
        })
        print("[SilentAim v3] Enabled =", CONFIG.Enabled)
    end
end)

print("[SilentAim v3] Загружен | Insert = toggle")
print("  FOV:", CONFIG.FOV, "| AimPart:", CONFIG.AimPart, "| TeamCheck:", CONFIG.TeamCheck, "| WallCheck:", CONFIG.WallCheck)
