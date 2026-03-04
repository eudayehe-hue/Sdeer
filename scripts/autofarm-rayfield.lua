-- ================================================
--   Haja Hub | Auto Farm Script
--   Game: SAWAH Indo Voice Chat (Roblox)
--   Compatible with Delta Executor & other executors
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Haja Hub | Auto Farm - SAWAH",
    LoadingTitle = "Haja Hub",
    LoadingSubtitle = "Auto Farm by Haja Hub",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HajaHub",
        FileName = "AutoFarm_SAWAH"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- ================================================
--   Services
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================================
--   State Variables
-- ================================================

-- Auto Farm
local AutoFarming = false
local AutoFarmConnection = nil
local FarmDelay = 0.5

-- Auto Collect
local AutoCollecting = false
local AutoCollectConnection = nil
local CollectRadius = 50

-- Auto Plant
local AutoPlanting = false
local AutoPlantConnection = nil
local PlantDelay = 1.0

-- Auto Harvest
local AutoHarvesting = false
local AutoHarvestConnection = nil
local HarvestDelay = 0.5

-- Speed Hack
local SpeedHacking = false
local OriginalSpeed = 16
local HackSpeed = 50

-- Anti AFK
local AntiAFKActive = false
local AntiAFKConnection = nil

-- Auto Sell
local AutoSelling = false
local AutoSellConnection = nil
local SellDelay = 5.0

-- Teleport
local TeleportEnabled = false

-- ================================================
--   Helper Functions
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

local function TeleportTo(position)
    local hrp = GetHumanoidRootPart()
    if hrp then
        hrp.CFrame = CFrame.new(position)
    end
end

local function GetNearestPart(partName, maxDistance)
    local hrp = GetHumanoidRootPart()
    if not hrp then return nil end

    local nearest = nil
    local nearestDist = maxDistance or math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find(partName:lower()) and obj:IsA("BasePart") then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < nearestDist then
                nearest = obj
                nearestDist = dist
            end
        end
    end

    return nearest, nearestDist
end

local function GetAllParts(partName, maxDistance)
    local hrp = GetHumanoidRootPart()
    if not hrp then return {} end

    local parts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find(partName:lower()) and obj:IsA("BasePart") then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist <= (maxDistance or math.huge) then
                table.insert(parts, {part = obj, dist = dist})
            end
        end
    end

    -- Sort by distance
    table.sort(parts, function(a, b) return a.dist < b.dist end)
    return parts
end

local function FireRemote(remoteName, ...)
    local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(...)
        return true
    end
    local remoteFunc = ReplicatedStorage:FindFirstChild(remoteName, true)
    if remoteFunc and remoteFunc:IsA("RemoteFunction") then
        return remoteFunc:InvokeServer(...)
    end
    return false
end

-- ================================================
--   Auto Farm Functions
-- ================================================

local function StartAutoFarm()
    AutoFarming = true
    AutoFarmConnection = RunService.Heartbeat:Connect(function()
        if not AutoFarming then return end

        local hrp = GetHumanoidRootPart()
        if not hrp then return end

        -- Cari tanaman yang bisa dipanen (harvest)
        local harvestTargets = {"Crop", "Plant", "Harvest", "Tanaman", "Padi", "Sawah", "Wheat", "Corn", "Vegetable"}
        for _, targetName in ipairs(harvestTargets) do
            local parts = GetAllParts(targetName, 100)
            for _, data in ipairs(parts) do
                local part = data.part
                -- Teleport ke tanaman dan coba harvest
                if data.dist > 5 then
                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                end
                -- Coba fire remote harvest
                FireRemote("Harvest", part)
                FireRemote("HarvestCrop", part)
                FireRemote("PickUp", part)
                task.wait(FarmDelay)
                if not AutoFarming then return end
            end
        end

        task.wait(FarmDelay)
    end)
end

local function StopAutoFarm()
    AutoFarming = false
    if AutoFarmConnection then
        AutoFarmConnection:Disconnect()
        AutoFarmConnection = nil
    end
end

-- ================================================
--   Auto Collect Functions
-- ================================================

local function StartAutoCollect()
    AutoCollecting = true
    AutoCollectConnection = RunService.Heartbeat:Connect(function()
        if not AutoCollecting then return end

        local hrp = GetHumanoidRootPart()
        if not hrp then return end

        -- Cari item yang bisa dikumpulkan
        local collectTargets = {"Drop", "Item", "Coin", "Money", "Gold", "Gem", "Reward", "Loot", "Pickup", "Collect"}
        for _, targetName in ipairs(collectTargets) do
            local parts = GetAllParts(targetName, CollectRadius)
            for _, data in ipairs(parts) do
                local part = data.part
                if data.dist > 3 then
                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                end
                -- Coba touch/collect
                FireRemote("Collect", part)
                FireRemote("PickupItem", part)
                task.wait(0.1)
                if not AutoCollecting then return end
            end
        end

        task.wait(0.3)
    end)
end

local function StopAutoCollect()
    AutoCollecting = false
    if AutoCollectConnection then
        AutoCollectConnection:Disconnect()
        AutoCollectConnection = nil
    end
end

-- ================================================
--   Auto Plant Functions
-- ================================================

local function StartAutoPlant()
    AutoPlanting = true
    AutoPlantConnection = RunService.Heartbeat:Connect(function()
        if not AutoPlanting then return end

        local hrp = GetHumanoidRootPart()
        if not hrp then return end

        -- Cari plot/lahan kosong untuk ditanam
        local plotTargets = {"Plot", "FarmPlot", "Lahan", "Soil", "Ground", "Bed", "Field"}
        for _, targetName in ipairs(plotTargets) do
            local parts = GetAllParts(targetName, 100)
            for _, data in ipairs(parts) do
                local part = data.part
                if data.dist > 5 then
                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                end
                -- Coba fire remote plant
                FireRemote("Plant", part)
                FireRemote("PlantSeed", part)
                FireRemote("PlantCrop", part)
                task.wait(PlantDelay)
                if not AutoPlanting then return end
            end
        end

        task.wait(PlantDelay)
    end)
end

local function StopAutoPlant()
    AutoPlanting = false
    if AutoPlantConnection then
        AutoPlantConnection:Disconnect()
        AutoPlantConnection = nil
    end
end

-- ================================================
--   Auto Harvest Functions
-- ================================================

local function StartAutoHarvest()
    AutoHarvesting = true
    AutoHarvestConnection = RunService.Heartbeat:Connect(function()
        if not AutoHarvesting then return end

        local hrp = GetHumanoidRootPart()
        if not hrp then return end

        -- Cari tanaman matang
        local harvestTargets = {"Ripe", "Ready", "Mature", "Grown", "Panen", "Harvest"}
        for _, targetName in ipairs(harvestTargets) do
            local parts = GetAllParts(targetName, 100)
            for _, data in ipairs(parts) do
                local part = data.part
                if data.dist > 5 then
                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                end
                FireRemote("Harvest", part)
                FireRemote("HarvestCrop", part)
                task.wait(HarvestDelay)
                if not AutoHarvesting then return end
            end
        end

        task.wait(HarvestDelay)
    end)
end

local function StopAutoHarvest()
    AutoHarvesting = false
    if AutoHarvestConnection then
        AutoHarvestConnection:Disconnect()
        AutoHarvestConnection = nil
    end
end

-- ================================================
--   Auto Sell Functions
-- ================================================

local function StartAutoSell()
    AutoSelling = true
    AutoSellConnection = RunService.Heartbeat:Connect(function()
        if not AutoSelling then return end

        local hrp = GetHumanoidRootPart()
        if not hrp then return end

        -- Cari NPC/toko untuk jual
        local sellTargets = {"Shop", "Sell", "Merchant", "Toko", "Penjual", "Market", "Store", "Trader"}
        for _, targetName in ipairs(sellTargets) do
            local nearest, dist = GetNearestPart(targetName, 500)
            if nearest then
                if dist > 5 then
                    hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
                end
                -- Coba fire remote sell
                FireRemote("Sell", nearest)
                FireRemote("SellAll")
                FireRemote("SellItems")
                task.wait(SellDelay)
                if not AutoSelling then return end
            end
        end

        task.wait(SellDelay)
    end)
end

local function StopAutoSell()
    AutoSelling = false
    if AutoSellConnection then
        AutoSellConnection:Disconnect()
        AutoSellConnection = nil
    end
end

-- ================================================
--   Speed Hack Functions
-- ================================================

local function SetSpeed(speed)
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function StartSpeedHack()
    SpeedHacking = true
    local humanoid = GetHumanoid()
    if humanoid then
        OriginalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = HackSpeed
    end
end

local function StopSpeedHack()
    SpeedHacking = false
    SetSpeed(OriginalSpeed)
end

-- ================================================
--   Anti AFK Functions
-- ================================================

local function StartAntiAFK()
    AntiAFKActive = true
    local VirtualUser = game:GetService("VirtualUser")
    AntiAFKConnection = LocalPlayer.Idled:Connect(function()
        if AntiAFKActive then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

local function StopAntiAFK()
    AntiAFKActive = false
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

-- ================================================
--   Rayfield UI Tabs
-- ================================================

local FarmTab = Window:CreateTab("🌾 Auto Farm", 4483362458)
local CollectTab = Window:CreateTab("💰 Auto Collect", 4483362458)
local PlantTab = Window:CreateTab("🌱 Auto Plant", 4483362458)
local SellTab = Window:CreateTab("🏪 Auto Sell", 4483362458)
local UtilTab = Window:CreateTab("⚡ Utilities", 4483362458)
local TeleportTab = Window:CreateTab("🗺️ Teleport", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

-- ================================================
--   Farm Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Auto Farm Control"
}, FarmTab)

Window:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        if Value then
            StartAutoFarm()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Farm aktif! Karakter akan otomatis panen.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopAutoFarm()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Farm dimatikan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, FarmTab)

Window:CreateToggle({
    Name = "Enable Auto Harvest",
    CurrentValue = false,
    Flag = "AutoHarvestToggle",
    Callback = function(Value)
        if Value then
            StartAutoHarvest()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Harvest aktif!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopAutoHarvest()
        end
    end,
}, FarmTab)

Rayfield:CreateSection({
    Name = "Farm Info"
}, FarmTab)

Window:CreateLabel("Auto Farm akan otomatis panen tanaman.", FarmTab)
Window:CreateLabel("Pastikan karakter dekat area sawah.", FarmTab)

-- ================================================
--   Collect Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Auto Collect Control"
}, CollectTab)

Window:CreateToggle({
    Name = "Enable Auto Collect",
    CurrentValue = false,
    Flag = "AutoCollectToggle",
    Callback = function(Value)
        if Value then
            StartAutoCollect()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Collect aktif! Mengumpulkan item otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopAutoCollect()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Collect dimatikan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, CollectTab)

Window:CreateSlider({
    Name = "Collect Radius",
    Range = {10, 200},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "CollectRadius",
    Callback = function(Value)
        CollectRadius = Value
    end,
}, CollectTab)

Rayfield:CreateSection({
    Name = "Info"
}, CollectTab)

Window:CreateLabel("Mengumpulkan semua item dalam radius.", CollectTab)

-- ================================================
--   Plant Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Auto Plant Control"
}, PlantTab)

Window:CreateToggle({
    Name = "Enable Auto Plant",
    CurrentValue = false,
    Flag = "AutoPlantToggle",
    Callback = function(Value)
        if Value then
            StartAutoPlant()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Plant aktif! Menanam otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopAutoPlant()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Plant dimatikan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, PlantTab)

Rayfield:CreateSection({
    Name = "Info"
}, PlantTab)

Window:CreateLabel("Auto Plant akan menanam benih di lahan kosong.", PlantTab)
Window:CreateLabel("Pastikan kamu punya benih di inventory.", PlantTab)

-- ================================================
--   Sell Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Auto Sell Control"
}, SellTab)

Window:CreateToggle({
    Name = "Enable Auto Sell",
    CurrentValue = false,
    Flag = "AutoSellToggle",
    Callback = function(Value)
        if Value then
            StartAutoSell()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Sell aktif! Menjual item otomatis.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopAutoSell()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Auto Sell dimatikan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, SellTab)

Window:CreateButton({
    Name = "Sell All Now",
    Callback = function()
        FireRemote("SellAll")
        FireRemote("Sell")
        FireRemote("SellItems")
        Rayfield:Notify({
            Title = "Haja Hub",
            Content = "Mencoba menjual semua item...",
            Duration = 2,
            Image = 4483362458,
        })
    end,
}, SellTab)

Rayfield:CreateSection({
    Name = "Info"
}, SellTab)

Window:CreateLabel("Auto Sell akan otomatis pergi ke toko dan jual.", SellTab)

-- ================================================
--   Utilities Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Speed Hack"
}, UtilTab)

Window:CreateToggle({
    Name = "Enable Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Callback = function(Value)
        if Value then
            StartSpeedHack()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Speed Hack aktif! WalkSpeed = " .. HackSpeed,
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopSpeedHack()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Speed Hack dimatikan. Speed normal.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, UtilTab)

Window:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 300},
    Increment = 5,
    Suffix = " speed",
    CurrentValue = 50,
    Flag = "WalkSpeed",
    Callback = function(Value)
        HackSpeed = Value
        if SpeedHacking then
            SetSpeed(Value)
        end
    end,
}, UtilTab)

Rayfield:CreateSection({
    Name = "Anti AFK"
}, UtilTab)

Window:CreateToggle({
    Name = "Enable Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        if Value then
            StartAntiAFK()
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Anti AFK aktif! Kamu tidak akan di-kick.",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopAntiAFK()
        end
    end,
}, UtilTab)

Rayfield:CreateSection({
    Name = "Noclip"
}, UtilTab)

local NoclipActive = false
local NoclipConn = nil

Window:CreateToggle({
    Name = "Enable Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipActive = Value
        if Value then
            NoclipConn = RunService.Stepped:Connect(function()
                if not NoclipActive then return end
                local char = LocalPlayer.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Noclip aktif!",
                Duration = 2,
                Image = 4483362458,
            })
        else
            if NoclipConn then
                NoclipConn:Disconnect()
                NoclipConn = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
}, UtilTab)

Rayfield:CreateSection({
    Name = "Infinite Jump"
}, UtilTab)

Window:CreateToggle({
    Name = "Enable Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        if Value then
            UserInputService.JumpRequest:Connect(function()
                local humanoid = GetHumanoid()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Infinite Jump aktif!",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, UtilTab)

-- ================================================
--   Teleport Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Teleport ke Area"
}, TeleportTab)

Window:CreateButton({
    Name = "Teleport ke Sawah",
    Callback = function()
        -- Cari area sawah
        local sawah = GetNearestPart("Sawah", 10000) or GetNearestPart("Farm", 10000) or GetNearestPart("Field", 10000)
        if sawah then
            TeleportTo(sawah.Position + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Teleport ke Sawah berhasil!",
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Area Sawah tidak ditemukan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, TeleportTab)

Window:CreateButton({
    Name = "Teleport ke Toko/Market",
    Callback = function()
        local shop = GetNearestPart("Shop", 10000) or GetNearestPart("Market", 10000) or GetNearestPart("Store", 10000) or GetNearestPart("Toko", 10000)
        if shop then
            TeleportTo(shop.Position + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Teleport ke Toko berhasil!",
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Toko tidak ditemukan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, TeleportTab)

Window:CreateButton({
    Name = "Teleport ke Spawn",
    Callback = function()
        local spawn = Workspace:FindFirstChild("SpawnLocation") or GetNearestPart("Spawn", 10000)
        if spawn then
            TeleportTo(spawn.Position + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Teleport ke Spawn berhasil!",
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Haja Hub",
                Content = "Spawn tidak ditemukan.",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
}, TeleportTab)

Window:CreateButton({
    Name = "Teleport ke Player Lain",
    Callback = function()
        -- Teleport ke player pertama yang bukan diri sendiri
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    TeleportTo(targetHRP.Position + Vector3.new(0, 3, 0))
                    Rayfield:Notify({
                        Title = "Haja Hub",
                        Content = "Teleport ke " .. player.Name .. " berhasil!",
                        Duration = 2,
                        Image = 4483362458,
                    })
                    return
                end
            end
        end
        Rayfield:Notify({
            Title = "Haja Hub",
            Content = "Tidak ada player lain ditemukan.",
            Duration = 2,
            Image = 4483362458,
        })
    end,
}, TeleportTab)

Rayfield:CreateSection({
    Name = "Info"
}, TeleportTab)

Window:CreateLabel("Teleport mencari objek terdekat di workspace.", TeleportTab)

-- ================================================
--   Settings Tab
-- ================================================

Rayfield:CreateSection({
    Name = "Farm Settings"
}, SettingsTab)

Window:CreateSlider({
    Name = "Farm Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "FarmDelay",
    Callback = function(Value)
        FarmDelay = Value
    end,
}, SettingsTab)

Window:CreateSlider({
    Name = "Plant Delay",
    Range = {0.5, 10},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 1.0,
    Flag = "PlantDelay",
    Callback = function(Value)
        PlantDelay = Value
    end,
}, SettingsTab)

Window:CreateSlider({
    Name = "Harvest Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "HarvestDelay",
    Callback = function(Value)
        HarvestDelay = Value
    end,
}, SettingsTab)

Window:CreateSlider({
    Name = "Sell Delay",
    Range = {1, 30},
    Increment = 1,
    Suffix = "s",
    CurrentValue = 5,
    Flag = "SellDelay",
    Callback = function(Value)
        SellDelay = Value
    end,
}, SettingsTab)

Rayfield:CreateSection({
    Name = "Reset"
}, SettingsTab)

Window:CreateButton({
    Name = "Stop All Features",
    Callback = function()
        StopAutoFarm()
        StopAutoCollect()
        StopAutoPlant()
        StopAutoHarvest()
        StopAutoSell()
        StopSpeedHack()
        StopAntiAFK()
        Rayfield:Notify({
            Title = "Haja Hub",
            Content = "Semua fitur dimatikan.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
}, SettingsTab)

-- ================================================
--   Character Respawn Handler
-- ================================================

LocalPlayer.CharacterAdded:Connect(function()
    -- Reset speed on respawn
    task.wait(1)
    if SpeedHacking then
        SetSpeed(HackSpeed)
    end
end)

-- ================================================
--   Init Notification
-- ================================================

Rayfield:Notify({
    Title = "Haja Hub - SAWAH Auto Farm",
    Content = "Script loaded! Fitur: Auto Farm, Collect, Plant, Sell, Speed, Anti AFK, Teleport.",
    Duration = 6,
    Image = 4483362458,
})

Rayfield:LoadConfiguration()
