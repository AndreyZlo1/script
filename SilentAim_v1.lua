--[[
    SilentAim v1 — ACS Engine (FastCastRedux)
    ============================================
    Игра использует ACS (Advanced Combat System) на основе FastCastRedux.
    
    Механика стрельбы:
      1. ACS_Framework вычисляет origin (позиция Muzzle/Camera) и direction (LookVector + spread)
      2. Вызывает ShootModule.fire(localPlayer, origin, direction, shellData)
         → FastCastRedux запускает raycast-снаряд на клиенте
      3. Параллельно: Events.ServerBullet:FireServer(origin, direction, shellData)
         → Сервер запускает свой FastCast по тем же параметрам и валидирует hit
      4. При попадании: BulletHitDetector.onHit → Events.Damage:InvokeServer(shellData, humanoid, dist, partType, part)
    
    Вектор атаки SilentAim:
      Перехватываем hookmetamethod __namecall на RemoteEvent/RemoteFunction.
      Когда вызывается ServerBullet:FireServer(origin, direction, shellData),
      подменяем `direction` на вектор (origin → target.HitPart.Position).
      ShootModule.fire() на клиенте НЕ трогаем — визуально выстрел летит в прицел,
      но серверный снаряд идёт в цель.
      
      Дополнительно: hookfunction на ShootModule.fire для синхронизации
      клиентского трейсера с серверным направлением (опционально, включается флагом).
    
    ВАЖНО: Damage:InvokeServer вызывается из FastCastRedux RayHit на клиенте
    при попадании снаряда в хитбокс. Поскольку мы подменяем direction в ServerBullet,
    серверный снаряд попадёт в цель и сервер сам отправит Damage — дублировать не нужно.
]]

-- ============================================================
--  КОНФИГУРАЦИЯ
-- ============================================================
local CONFIG = {
    Enabled       = true,          -- глобальный включатель
    FOV           = 250,           -- радиус поиска цели в пикселях от центра экрана
    AimPart       = "Head",        -- часть тела для наведения: "Head" | "HumanoidRootPart" | "UpperTorso"
    TeamCheck     = true,          -- не аимить на тиммейтов
    WallCheck     = true,          -- не аимить сквозь стены
    SyncClient    = false,         -- синхронизировать клиентский трейсер с серверным направлением
    PredictLead   = true,          -- упреждение по velocity цели
    LeadFactor    = 0.085,         -- коэффициент упреждения (настраивай под пинг)
    DebugFOV      = false,         -- рисовать круг FOV на экране
}

-- ============================================================
--  СЕРВИСЫ
-- ============================================================
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer    = Players.LocalPlayer
local Camera         = workspace.CurrentCamera
local Mouse          = LocalPlayer:GetMouse()

-- ============================================================
--  FOV DRAWING (Drawing API)
-- ============================================================
local fovCircle
if CONFIG.DebugFOV then
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible    = true
    fovCircle.Radius     = CONFIG.FOV
    fovCircle.Color      = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness  = 1
    fovCircle.Filled     = false
    fovCircle.Transparency = 0.5
    RunService.RenderStepped:Connect(function()
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end

-- ============================================================
--  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================================

-- Получить команду приоритетного хитбокса (с учётом смещения в зависимости от части)
local function getHitPart(character)
    return character:FindFirstChild(CONFIG.AimPart)
        or character:FindFirstChild("HumanoidRootPart")
end

-- Проверка команды (team check)
local function isSameTeam(player)
    if not CONFIG.TeamCheck then return false end
    return LocalPlayer.Team ~= nil and LocalPlayer.Team == player.Team
end

-- Проверка стены между origin и целью
local function hasWallBetween(origin, targetPos, character)
    if not CONFIG.WallCheck then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {workspace.CurrentCamera}
    -- исключаем персонажа стрелка
    if LocalPlayer.Character then
        table.insert(filterList, LocalPlayer.Character)
    end
    -- исключаем персонажа цели чтобы луч мог до него дойти
    table.insert(filterList, character)
    rayParams.FilterDescendantsInstances = filterList
    local dir = (targetPos - origin)
    local result = workspace:Raycast(origin, dir, rayParams)
    -- если raycast ничего не нашёл — путь чист
    return result ~= nil
end

-- Мировые координаты → экран (возвращает Vector2 и флаг видимости)
local function worldToScreen(pos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

-- Расстояние от центра экрана до screenPos
local function screenDistFromCenter(screenPos)
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    return (screenPos - center).Magnitude
end

-- ============================================================
--  ПОИСК БЛИЖАЙШЕЙ ЦЕЛИ
-- ============================================================

-- Предсказание позиции цели с учётом скорости (lead)
local function predictedPosition(hitPart, shellSpeed)
    local rootPart = hitPart.Parent:FindFirstChild("HumanoidRootPart") or hitPart
    local velocity = rootPart.AssemblyLinearVelocity
    if not CONFIG.PredictLead then
        return hitPart.Position
    end
    local dist = (hitPart.Position - Camera.CFrame.Position).Magnitude
    local travelTime = dist / math.max(shellSpeed, 1)
    return hitPart.Position + velocity * travelTime * CONFIG.LeadFactor
end

-- Найти ближайшую к центру экрана цель в пределах FOV
local function findTarget(shellSpeed)
    local bestPlayer  = nil
    local bestDist    = math.huge
    local bestPredPos = nil

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
        local screenPos, onScreen = worldToScreen(predPos)
        if not onScreen then continue end

        local dist = screenDistFromCenter(screenPos)
        if dist > CONFIG.FOV then continue end

        -- Проверка стены
        local origin = Camera.CFrame.Position
        if hasWallBetween(origin, predPos, char) then continue end

        if dist < bestDist then
            bestDist    = dist
            bestPlayer  = player
            bestPredPos = predPos
        end
    end

    return bestPlayer, bestPredPos
end

-- ============================================================
--  CORE: ПЕРЕХВАТ ServerBullet:FireServer
--  Подменяем direction (p2) на вектор к цели
-- ============================================================

-- Кешируем RemoteEvent по fullName из _remotes_index
-- ReplicatedStorage.ACS_Engine.Events.ServerBullet
local function getServerBulletRemote()
    local rs = game:GetService("ReplicatedStorage")
    local engine = rs:WaitForChild("ACS_Engine", 10)
    if not engine then return nil end
    local events = engine:WaitForChild("Events", 10)
    if not events then return nil end
    return events:FindFirstChild("ServerBullet")
end

local ServerBulletRemote = getServerBulletRemote()

-- hookmetamethod перехватывает ВСЕ __namecall на game, включая :FireServer
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()

    -- Перехватываем только FireServer на ServerBullet
    if CONFIG.Enabled and method == "FireServer" and self == ServerBulletRemote then
        local args = { ... }
        -- args[1] = origin (Vector3)
        -- args[2] = direction (Vector3)
        -- args[3] = shellData (table)

        local origin    = args[1]
        local direction = args[2]
        local shellData = args[3]

        if origin and direction and typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
            local shellSpeed = (shellData and shellData.shellSpeed) or 1000
            local _, targetPos = findTarget(shellSpeed)

            if targetPos then
                -- Вычисляем новый direction: нормализованный вектор origin → targetPos
                local newDirection = (targetPos - origin).Unit
                args[2] = newDirection

                -- Опциональная синхронизация клиентского трейсера
                -- (меняем args для ShootModule тоже — не нужно, т.к. fire() уже вызван ДО FireServer)
            end
        end

        return originalNamecall(self, table.unpack(args))
    end

    return originalNamecall(self, ...)
end))

-- ============================================================
--  ОПЦИОНАЛЬНО: ПЕРЕХВАТ ShootModule.fire
--  Синхронизирует клиентский трейсер с серверным направлением
--  Включается только при CONFIG.SyncClient = true
-- ============================================================

if CONFIG.SyncClient then
    -- ShootModule живёт в ReplicatedStorage.Modules.Projectile.ShootModule
    -- Находим его через getgc или геттинг require
    local function findShootModule()
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "fire") and type(rawget(v, "fire")) == "function" then
                -- Проверяем что это ShootModule (у него только fire)
                local keys = 0
                for _ in pairs(v) do keys = keys + 1 end
                if keys == 1 then
                    return v
                end
            end
        end
        return nil
    end

    task.spawn(function()
        task.wait(3) -- ждём загрузки модуля
        local ShootModule = findShootModule()
        if not ShootModule then
            warn("[SilentAim] SyncClient: ShootModule не найден")
            return
        end

        local originalFire = ShootModule.fire
        ShootModule.fire = newcclosure(function(player, origin, direction, shellData, extra)
            if CONFIG.Enabled and player == LocalPlayer then
                local shellSpeed = (shellData and shellData.shellSpeed) or 1000
                local _, targetPos = findTarget(shellSpeed)
                if targetPos and origin then
                    direction = (targetPos - origin).Unit
                end
            end
            return originalFire(player, origin, direction, shellData, extra)
        end)
    end)
end

-- ============================================================
--  KEYBIND: Toggle SilentAim (клавиша Insert)
-- ============================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        CONFIG.Enabled = not CONFIG.Enabled
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title   = "SilentAim",
            Text    = CONFIG.Enabled and "✓ Включён" or "✗ Выключен",
            Duration = 2
        })
    end
end)

-- ============================================================
--  ИНИЦИАЛИЗАЦИЯ
-- ============================================================

if ServerBulletRemote then
    print("[SilentAim] Remote найден:", ServerBulletRemote:GetFullName())
else
    warn("[SilentAim] ServerBullet remote НЕ найден — ожидаем загрузку...")
    -- Повторная попытка после загрузки
    task.spawn(function()
        task.wait(5)
        ServerBulletRemote = getServerBulletRemote()
        if ServerBulletRemote then
            print("[SilentAim] Remote найден (отложенно):", ServerBulletRemote:GetFullName())
        else
            warn("[SilentAim] Remote так и не найден. Проверь путь: ReplicatedStorage.ACS_Engine.Events.ServerBullet")
        end
    end)
end

print("[SilentAim v1] Загружен. Insert = toggle")
