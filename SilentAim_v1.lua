--[[
    SilentAim v2 — ACS Engine (FastCastRedux)
    Исправления v1 → v2:
      - Защита pcall внутри хука чтобы не ломать стрельбу при ошибке
      - rawequal вместо == для сравнения RemoteEvent
      - Автоопределение индексов args (origin=Vector3, direction=Vector3)
      - Drawing: линия от центра экрана к цели + имя цели + FOV-круг
      - Цвет линии: зелёный = цель в прицеле, красный = цель есть но не в прицеле
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    Enabled       = true,
    FOV           = 250,           -- радиус поиска в пикселях от центра экрана
    AimPart       = "Head",        -- "Head" | "HumanoidRootPart" | "UpperTorso"
    TeamCheck     = true,
    WallCheck     = true,
    PredictLead   = true,
    LeadFactor    = 0.085,

    -- Drawing
    ShowFOV       = true,          -- круг FOV
    ShowLine      = true,          -- линия к цели
    ShowName      = true,          -- имя цели над линией
    LineColorLock = Color3.fromRGB(0, 255, 80),    -- цвет линии при захвате цели
    LineColorIdle = Color3.fromRGB(255, 60, 60),   -- цвет линии без захвата
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
--  DRAWING OBJECTS
-- ============================================================
local drawFOV, drawLine, drawLineDot, drawName

if CONFIG.ShowFOV then
    drawFOV           = Drawing.new("Circle")
    drawFOV.Visible   = false
    drawFOV.Radius    = CONFIG.FOV
    drawFOV.Color     = CONFIG.FOVColor
    drawFOV.Thickness = 1
    drawFOV.Filled    = false
    drawFOV.Transparency = 0.6
end

if CONFIG.ShowLine then
    drawLine              = Drawing.new("Line")
    drawLine.Visible      = false
    drawLine.Thickness    = 1.5
    drawLine.Transparency = 0.9

    -- точка на цели (маленький круг)
    drawLineDot           = Drawing.new("Circle")
    drawLineDot.Visible   = false
    drawLineDot.Radius    = 4
    drawLineDot.Filled    = true
    drawLineDot.Transparency = 0.9
end

if CONFIG.ShowName then
    drawName              = Drawing.new("Text")
    drawName.Visible      = false
    drawName.Size         = 14
    drawName.Color        = Color3.fromRGB(255, 255, 255)
    drawName.Outline      = true
    drawName.OutlineColor = Color3.fromRGB(0, 0, 0)
    drawName.Center       = true
end

-- ============================================================
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================================
local function getHitPart(character)
    return character:FindFirstChild(CONFIG.AimPart)
        or character:FindFirstChild("HumanoidRootPart")
end

local function isSameTeam(player)
    if not CONFIG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == player.Team
end

local function hasWallBetween(origin, targetPos, character)
    if not CONFIG.WallCheck then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {Camera}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    table.insert(filter, character)
    rayParams.FilterDescendantsInstances = filter
    local result = workspace:Raycast(origin, targetPos - origin, rayParams)
    return result ~= nil
end

local function worldToScreen(pos)
    local sp, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen, sp.Z
end

local function screenCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function predictedPosition(hitPart, shellSpeed)
    local root = hitPart.Parent:FindFirstChild("HumanoidRootPart") or hitPart
    local vel  = root.AssemblyLinearVelocity
    if not CONFIG.PredictLead then return hitPart.Position end
    local dist   = (hitPart.Position - Camera.CFrame.Position).Magnitude
    local travel = dist / math.max(shellSpeed, 1)
    return hitPart.Position + vel * travel * CONFIG.LeadFactor
end

-- ============================================================
--  ПОИСК ЦЕЛИ
-- ============================================================
local currentTarget     = nil   -- Player
local currentTargetPos  = nil   -- Vector3

local function findTarget(shellSpeed)
    local bestPlayer  = nil
    local bestDist    = math.huge
    local bestPos     = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if isSameTeam(player) then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local hitPart = getHitPart(char)
        if not hitPart then continue end
        local predPos = predictedPosition(hitPart, shellSpeed or 1000)
        local sp, onScreen = worldToScreen(predPos)
        if not onScreen then continue end
        local dist = (sp - screenCenter()).Magnitude
        if dist > CONFIG.FOV then continue end
        local origin = Camera.CFrame.Position
        if hasWallBetween(origin, predPos, char) then continue end
        if dist < bestDist then
            bestDist   = dist
            bestPlayer = player
            bestPos    = predPos
        end
    end

    return bestPlayer, bestPos
end

-- ============================================================
--  DRAWING UPDATE LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    local center = screenCenter()

    -- FOV круг
    if drawFOV then
        drawFOV.Position = center
        drawFOV.Visible  = CONFIG.Enabled and CONFIG.ShowFOV
        drawFOV.Radius   = CONFIG.FOV
        drawFOV.Color    = CONFIG.FOVColor
    end

    -- Ищем ближайшую цель (для Drawing — не для выстрела, это отдельно)
    local target, targetPos = findTarget(1000)
    currentTarget    = target
    currentTargetPos = targetPos

    if target and targetPos then
        local sp, onScreen = worldToScreen(targetPos)

        -- Линия центр → цель
        if drawLine then
            drawLine.Visible  = CONFIG.Enabled and CONFIG.ShowLine and onScreen
            drawLine.From     = center
            drawLine.To       = sp
            drawLine.Color    = CONFIG.LineColorLock
            drawLine.Thickness = 1.5
        end

        -- Точка на цели
        if drawLineDot then
            drawLineDot.Visible   = CONFIG.Enabled and CONFIG.ShowLine and onScreen
            drawLineDot.Position  = sp
            drawLineDot.Color     = CONFIG.LineColorLock
        end

        -- Имя цели
        if drawName then
            drawName.Visible   = CONFIG.Enabled and CONFIG.ShowName and onScreen
            drawName.Position  = Vector2.new(sp.X, sp.Y - 18)
            drawName.Text      = target.Name
        end
    else
        -- Нет цели — скрываем
        if drawLine    then drawLine.Visible    = false end
        if drawLineDot then drawLineDot.Visible = false end
        if drawName    then drawName.Visible    = false end
    end
end)

-- ============================================================
--  REMOTE HOOK
-- ============================================================
local function getServerBulletRemote()
    local rs = game:GetService("ReplicatedStorage")
    local engine = rs:FindFirstChild("ACS_Engine") or rs:WaitForChild("ACS_Engine", 15)
    if not engine then return nil end
    local events = engine:FindFirstChild("Events") or engine:WaitForChild("Events", 10)
    if not events then return nil end
    return events:FindFirstChild("ServerBullet")
end

local ServerBulletRemote = getServerBulletRemote()

if not ServerBulletRemote then
    task.spawn(function()
        task.wait(5)
        ServerBulletRemote = getServerBulletRemote()
        if ServerBulletRemote then
            print("[SilentAim v2] Remote найден (отложенно):", ServerBulletRemote:GetFullName())
        else
            warn("[SilentAim v2] ServerBullet не найден! Путь: ReplicatedStorage.ACS_Engine.Events.ServerBullet")
        end
    end)
else
    print("[SilentAim v2] Remote:", ServerBulletRemote:GetFullName())
end

-- Хук: перехватываем FireServer на ServerBullet
-- Исправление v1: используем rawequal, pcall-защиту, автодетект индексов Vector3
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if CONFIG.Enabled
        and method == "FireServer"
        and ServerBulletRemote
        and rawequal(self, ServerBulletRemote)
    then
        -- Безопасно копируем аргументы
        local args = table.pack(...)  -- args.n = количество аргументов

        -- Автоопределение: ищем два Vector3 подряд (origin, direction)
        -- Порядок: origin(Vector3), direction(Vector3), shellData(table)
        local originIdx, dirIdx = nil, nil
        for i = 1, args.n do
            if typeof(args[i]) == "Vector3" then
                if not originIdx then
                    originIdx = i
                elseif not dirIdx then
                    dirIdx = i
                    break
                end
            end
        end

        if originIdx and dirIdx then
            local origin    = args[originIdx]
            local shellData = nil
            -- shellData — первая таблица после dirIdx
            for i = dirIdx + 1, args.n do
                if type(args[i]) == "table" then
                    shellData = args[i]
                    break
                end
            end

            local shellSpeed = shellData and shellData.shellSpeed or 1000
            local _, targetPos = findTarget(shellSpeed)

            if targetPos then
                local newDir = (targetPos - origin).Unit
                args[dirIdx] = newDir
            end
        end

        -- Передаём обратно распакованные args
        -- table.unpack с n чтобы не терять nil-аргументы
        local ok, err = pcall(originalNamecall, self, table.unpack(args, 1, args.n))
        if not ok then
            warn("[SilentAim v2] hook pcall error:", err)
            -- Фоллбэк — оригинальный вызов без изменений
            return originalNamecall(self, ...)
        end
        return
    end

    return originalNamecall(self, ...)
end))

-- ============================================================
--  KEYBIND: Insert = toggle
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        if drawFOV    then drawFOV.Visible    = CONFIG.Enabled end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = "SilentAim v2",
            Text     = CONFIG.Enabled and "✓ Включён" or "✗ Выключен",
            Duration = 2,
        })
        print("[SilentAim v2] Enabled =", CONFIG.Enabled)
    end
end)

print("[SilentAim v2] Загружен. Insert = toggle")
print("[SilentAim v2] FOV:", CONFIG.FOV, "| AimPart:", CONFIG.AimPart, "| TeamCheck:", CONFIG.TeamCheck)
