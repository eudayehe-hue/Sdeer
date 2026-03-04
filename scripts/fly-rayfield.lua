-- ================================================
--   Haja Hub | Fly Script with Rayfield UI
--   Compatible with Delta Executor & other executors
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Haja Hub | Fly Script",
    LoadingTitle = "Haja Hub",
    LoadingSubtitle = "by Haja Hub",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HajaHub",
        FileName = "FlyScript"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- ================================================
--   Variables
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Flying = false
local FlySpeed = 50
local FlyConnection = nil

local BodyVelocity = nil
local BodyGyro = nil

-- ================================================
--   Fly Functions
-- ================================================

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoidRootPart()
    local char = GetCharacter()
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local char = GetCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

local function StartFly()
    local char = GetCharacter()
    local hrp = GetHumanoidRootPart()
    local humanoid = GetHumanoid()

    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true

    -- Remove existing body movers if any
    if hrp:FindFirstChild("HajaBodyVelocity") then
        hrp:FindFirstChild("HajaBodyVelocity"):Destroy()
    end
    if hrp:FindFirstChild("HajaBodyGyro") then
        hrp:FindFirstChild("HajaBodyGyro"):Destroy()
    end

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "HajaBodyVelocity"
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    BodyVelocity.Parent = hrp

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "HajaBodyGyro"
    BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    BodyGyro.P = 1e4
    BodyGyro.CFrame = hrp.CFrame
    BodyGyro.Parent = hrp

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not Flying then return end

        local hrp2 = GetHumanoidRootPart()
        if not hrp2 then return end

        local moveDir = Vector3.new(0, 0, 0)
        local camCF = Camera.CFrame

        -- WASD / Arrow Key Movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end

        -- Up / Down
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        BodyVelocity.Velocity = moveDir * FlySpeed
        BodyGyro.CFrame = camCF
    end)

    Flying = true
end

local function StopFly()
    Flying = false

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    local hrp = GetHumanoidRootPart()
    local humanoid = GetHumanoid()

    if hrp then
        if hrp:FindFirstChild("HajaBodyVelocity") then
            hrp:FindFirstChild("HajaBodyVelocity"):Destroy()
        end
        if hrp:FindFirstChild("HajaBodyGyro") then
            hrp:FindFirstChild("HajaBodyGyro"):Destroy()
        end
    end

    if humanoid then
        humanoid.PlatformStand = false
    end

    BodyVelocity = nil
    BodyGyro = nil
end

-- ================================================
--   Rayfield UI Tabs
-- ================================================

local MainTab = Window:CreateTab("✈️ Fly", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

-- ================================================
--   Main Tab - Fly Toggle
-- ================================================

Rayfield:CreateSection({
    Name = "Fly Control"
}, MainTab)

Window:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if Value then
            StartFly()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Fly Enabled! Gunakan WASD untuk terbang.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopFly()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Fly Disabled.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
}, MainTab)

Rayfield:CreateSection({
    Name = "Controls Info"
}, MainTab)

Window:CreateLabel("W/A/S/D — Gerak Terbang", MainTab)
Window:CreateLabel("Space — Naik", MainTab)
Window:CreateLabel("Left Shift — Turun", MainTab)

-- ================================================
--   Settings Tab - Speed Slider
-- ================================================

Rayfield:CreateSection({
    Name = "Fly Settings"
}, SettingsTab)

Window:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 300},
    Increment = 5,
    Suffix = " Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end,
}, SettingsTab)

Window:CreateButton({
    Name = "Reset Speed (Default: 50)",
    Callback = function()
        FlySpeed = 50
        Rayfield:Notify({
            Title = "Haja Hub",
            Content = "Speed direset ke 50.",
            Duration = 2,
            Image = 4483362458,
        })
    end,
}, SettingsTab)

-- ================================================
--   Character Respawn Handler
-- ================================================

LocalPlayer.CharacterAdded:Connect(function()
    Flying = false
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    BodyVelocity = nil
    BodyGyro = nil
end)

-- ================================================
--   Init Notification
-- ================================================

Rayfield:Notify({
    Title = "Haja Hub Loaded!",
    Content = "Fly Script siap digunakan. Buka tab Fly untuk mulai.",
    Duration = 5,
    Image = 4483362458,
})

Rayfield:LoadConfiguration()
