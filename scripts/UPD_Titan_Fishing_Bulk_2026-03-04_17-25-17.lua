-- ================================================
--   Titan Fishing Hub | Auto Fishing Script
--   Game: Titan Fishing / Sdeer Fishing Games
--   Features: Auto Fish, Auto Sell, Teleports, Shop
--   Compatible with Delta Executor & other executors
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Titan Fishing Hub | Auto Fish",
    LoadingTitle = "Titan Fishing Hub",
    LoadingSubtitle = "Auto Fishing Script",
    Theme = "Dark",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TitanFishingHub",
        FileName = "TitanFishing_AutoFish"
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ================================================
--   Remotes & Game Data
-- ================================================

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)

local function GetRemote(name)
    if Remotes then
        return Remotes:FindFirstChild(name)
    end
    return nil
end

-- ================================================
--   Fish Data (Common Titan Fishing Games)
-- ================================================

local FishData = {
    Common = {"Ikan Lele", "Ikan Mas", "Ikan Nila", "Ikan Gurame", "Ikan Mujaer", "Ikan Tengiri", "Ikan Kembung"},
    Uncommon = {"Ikan Salmon", "Ikan Tuna", "Ikan Kakap", "Ikan Cue", "Ikan Baronang"},
    Rare = {"Ikan Hiu", "Ikan Pari", "Ikan Lumba-lumba", "Ikan Paus", "Ikan Arwana"},
    Legendary = {"Ikan Duyung", "Ikan Naga", "Ikan Leviathan", "Ikan Kraken", "Ikan Poseidon"},
    Epic = {"Ikan Golden", "Ikan Diamond", "Ikan Rainbow", "Ikan Galaxy", "Ikan Cosmic"}
}

local BaitData = {
    "Ulat Sutra", "Cacing Tanah", "Kroto", "Jangkrik", "Belalang", 
    "Kepiting Kecil", "Ikan Kecil", "Udang", "Cumi-cumi", "Kepiting"
}

local RodData = {
    "Pancing Bambu", "Pancing Kayu", "Pancing Metal", "Pancing Fiberglass",
    "Pancing Carbon", "Pancing Titanium", "Pancing Diamond", "Pancing Legendary"
}

-- ================================================
--   State Variables
-- ================================================

local AutoFishing = false
local AutoFishConn = nil
local AutoReeling = false
local AutoReelConn = nil
local AutoSelling = false
local AutoSellConn = nil
local AutoBait = false
local AutoBaitConn = nil
local SpeedHacking = false
local OriginalSpeed = 16
local HackSpeed = 50
local AntiAFKActive = false
local AntiAFKConn = nil
local NoclipActive = false
local NoclipConn = nil
local InfJumpActive = false
local InfJumpConn = nil

local SelectedBait = "Cacing Tanah"
local SelectedRod = "Pancing Metal"
local SellDelay = 2.0
local FishDelay = 0.5
local ReelDelay = 0.3
local BuyBaitQuantity = 10

local FishCaughtCount = 0
local TotalValue = 0

-- ================================================
--   Helper Functions
-- ================================================

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHRP()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function TeleportTo(pos)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

local function GetFishingRod()
    local char = GetCharacter()
    if not char then return nil end
    return char:FindFirstChildWhichIsA("Tool")
end

local function EquipRod(rodName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return false end
    local rod = backpack:FindFirstChild(rodName)
    if rod then
        LocalPlayer.Character.Humanoid:EquipTool(rod)
        return true
    end
    return false
end

local function GetBait(baitName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end
    return backpack:FindFirstChild(baitName)
end

local function EquipBait(baitName)
    local bait = GetBait(baitName)
    if bait then
        LocalPlayer.Character.Humanoid:EquipTool(bait)
        return true
    end
    return false
end

local function SetSpeed(speed)
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = speed
    end
end

local function StartAntiAFK()
    if AntiAFKConn then return end
    AntiAFKActive = true
    AntiAFKConn = game:GetService("RunService").Heartbeat:Connect(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.Unknown, false, nil)
    end)
end

local function StopAntiAFK()
    if AntiAFKConn then
        AntiAFKConn:Disconnect()
        AntiAFKConn = nil
    end
    AntiAFKActive = false
end

local function StartNoclip()
    if NoclipConn then return end
    NoclipActive = true
    NoclipConn = RunService.Heartbeat:Connect(function()
        if not NoclipActive then
            NoclipConn:Disconnect()
            NoclipConn = nil
            return
        end
        local char = GetCharacter()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopNoclip()
    NoclipActive = false
end

local function StartInfJump()
    if InfJumpConn then return end
    InfJumpActive = true
    InfJumpConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Space then
            local hum = GetHumanoid()
            if hum then
                hum.Jump = true
            end
        end
    end)
end

local function StopInfJump()
    if InfJumpConn then
        InfJumpConn:Disconnect()
        InfJumpConn = nil
    end
    InfJumpActive = false
end

-- ================================================
--   Core Fishing Functions
-- ================================================

-- Cast fishing rod
local function CastRod()
    local rod = GetFishingRod()
    if rod then
        pcall(function()
            rod:Activate()
        end)
    end
end

-- Reel in the fish
local function ReelFish()
    pcall(function()
        local fishingEvent = GetRemote("ReelFish") or GetRemote("PullFish")
        if fishingEvent then
            fishingEvent:FireServer()
        end
    end)
end

-- Catch the fish
local function CatchFish()
    pcall(function()
        local catchEvent = GetRemote("CatchFish") or GetRemote("ClaimFish")
        if catchEvent then
            catchEvent:FireServer()
        end
    end)
end

-- Sell fish
local function SellFish()
    pcall(function()
        local sellRemote = GetRemote("SellFish") or GetRemote("RequestSell")
        if sellRemote then
            sellRemote:InvokeServer("SELL_ALL")
        end
    end)
end

-- Buy bait
local function BuyBait(baitName, quantity)
    pcall(function()
        local buyRemote = GetRemote("BuyBait") or GetRemote("RequestBuyBait")
        if buyRemote then
            buyRemote:InvokeServer(baitName, quantity)
        end
    end)
end

-- Buy rod
local function BuyRod(rodName)
    pcall(function()
        local buyRemote = GetRemote("BuyRod") or GetRemote("RequestBuyRod")
        if buyRemote then
            buyRemote:InvokeServer(rodName)
        end
    end)
end

-- Get fishing spots
local function GetFishingSpots()
    local spots = {}
    local fishingAreas = workspace:FindFirstChild("FishingAreas") or workspace:FindFirstChild("FishingSpots")
    if fishingAreas then
        for _, spot in ipairs(fishingAreas:GetChildren()) do
            if spot:IsA("BasePart") or spot:IsA("Model") then
                table.insert(spots, {
                    Name = spot.Name,
                    Position = spot.PrimaryPart and spot.PrimaryPart.Position or spot.Position
                })
            end
        end
    end
    return spots
end

-- Get NPCs
local function GetNPC(npcType)
    local npcFolder = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Characters")
    if not npcFolder then return nil end
    for _, npc in ipairs(npcFolder:GetChildren()) do
        if string.find(string.lower(npc.Name), string.lower(npcType)) then
            return npc
        end
    end
    return nil
end

-- ================================================
--   Auto Fish Loop
-- ================================================

local function StartAutoFish()
    if AutoFishConn then AutoFishConn:Disconnect() end
    AutoFishing = true

    AutoFishConn = RunService.Heartbeat:Connect(function()
        if not AutoFishing then
            AutoFishConn:Disconnect()
            AutoFishConn = nil
            return
        end

        -- Equip selected rod
        EquipRod(SelectedRod)
        task.wait(0.1)

        -- Equip selected bait
        if AutoBait then
            EquipBait(SelectedBait)
            task.wait(0.1)
        end

        -- Cast the rod
        CastRod()
        task.wait(FishDelay)

        -- Auto reel when fish bites (simplified detection)
        task.wait(1.5)
        for i = 1, 5 do
            ReelFish()
            task.wait(ReelDelay)
        end

        -- Catch the fish
        CatchFish()
        task.wait(0.5)

        FishCaughtCount = FishCaughtCount + 1

        Rayfield:Notify({
            Title = "Ikan Tertangkap!",
            Content = "Total: " .. FishCaughtCount .. " ikan",
            Duration = 1,
        })
    end)
end

local function StopAutoFish()
    AutoFishing = false
end

-- ================================================
--   Auto Sell Loop
-- ================================================

local function StartAutoSell()
    if AutoSellConn then AutoSellConn:Disconnect() end
    AutoSelling = true

    AutoSellConn = RunService.Heartbeat:Connect(function()
        if not AutoSelling then
            AutoSellConn:Disconnect()
            AutoSellConn = nil
            return
        end

        SellFish()
        task.wait(SellDelay)
    end)
end

local function StopAutoSell()
    AutoSelling = false
end

-- ================================================
--   Auto Bait Loop
-- ================================================

local function StartAutoBait()
    AutoBait = true
end

local function StopAutoBait()
    AutoBait = false
end

-- ================================================
--   Teleport Functions
-- ================================================

local FishingSpots = {
    {Name = "Pantai Utara", Position = Vector3.new(100, 10, 200)},
    {Name = "Pantai Selatan", Position = Vector3.new(-150, 10, -100)},
    {Name = "Danau Utama", Position = Vector3.new(50, 15, 50)},
    {Name = "Sungai Besar", Position = Vector3.new(-200, 10, 150)},
    {Name = "Pelabuhan", Position = Vector3.new(300, 10, -50)},
    {Name = "Pulau Terpencil", Position = Vector3.new(-400, 10, -300)},
    {Name = "Goa Laut", Position = Vector3.new(200, -20, 250)},
    {Name = "Arena比赛", Position = Vector3.new(0, 50, 0)}
}

local NPClocations = {
    {Name = "Toko Pancing", Position = Vector3.new(80, 5, 80)},
    {Name = "Toko Umpan", Position = Vector3.new(85, 5, 85)},
    {Name = "Penjual Ikan", Position = Vector3.new(90, 5, 90)},
    {Name = "Upgrade Gear", Position = Vector3.new(95, 5, 95)}
}

-- ================================================
--   UI Tabs
-- ================================================

-- ---- Tab 1: Auto Fish ----
local FishTab = Window:CreateTab("🎣 Auto Fish", "anchor")

FishTab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(val)
        if val then
            StartAutoFish()
            Rayfield:Notify({Title = "Auto Fish", Content = "Auto fishing diaktifkan!", Duration = 2})
        else
            StopAutoFish()
            Rayfield:Notify({Title = "Auto Fish", Content = "Auto fishing dimatikan!", Duration = 2})
        end
    end
})

FishTab:CreateSlider({
    Name = "Fish Delay",
    Range = {0.1, 5.0},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Flag = "FishDelay",
    Callback = function(val)
        FishDelay = val
    end
})

FishTab:CreateSlider({
    Name = "Reel Delay",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.3,
    Flag = "ReelDelay",
    Callback = function(val)
        ReelDelay = val
    end
})

FishTab:CreateToggle({
    Name = "Auto Bait",
    CurrentValue = false,
    Flag = "AutoBait",
    Callback = function(val)
        if val then
            StartAutoBait()
        else
            StopAutoBait()
        end
    end
})

FishTab:CreateDivider()

FishTab:CreateLabel("Total ikan tertangkap: " .. FishCaughtCount)

FishTab:CreateButton({
    Name = "Reset Counter",
    Callback = function()
        FishCaughtCount = 0
        TotalValue = 0
        Rayfield:Notify({Title = "Reset", Content = "Counter berhasil direset!", Duration = 2})
    end
})

-- ---- Tab 2: Auto Sell ----
local SellTab = Window:CreateTab("💰 Auto Sell", "dollar-sign")

SellTab:CreateToggle({
    Name = "Auto Sell Fish",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(val)
        if val then
            StartAutoSell()
            Rayfield:Notify({Title = "Auto Sell", Content = "Auto sell diaktifkan!", Duration = 2})
        else
            StopAutoSell()
            Rayfield:Notify({Title = "Auto Sell", Content = "Auto sell dimatikan!", Duration = 2})
        end
    end
})

SellTab:CreateSlider({
    Name = "Sell Delay",
    Range = {1.0, 10.0},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 2.0,
    Flag = "SellDelay",
    Callback = function(val)
        SellDelay = val
    end
})

SellTab:CreateButton({
    Name = "Sell Semua Ikan",
    Callback = function()
        SellFish()
        Rayfield:Notify({Title = "Sell", Content = "Menjual semua ikan...", Duration = 2})
    end
})

-- ---- Tab 3: Shop ----
local ShopTab = Window:CreateTab("🛒 Shop", "shopping-cart")

ShopTab:CreateDropdown({
    Name = "Pilih Umpan",
    Options = BaitData,
    CurrentValue = BaitData[2],
    Flag = "BaitSelection",
    Callback = function(val)
        SelectedBait = val
    end
})

ShopTab:CreateSlider({
    Name = "Jumlah Beli",
    Range = {1, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 10,
    Flag = "BaitQuantity",
    Callback = function(val)
        BuyBaitQuantity = val
    end
})

ShopTab:CreateButton({
    Name = "Beli Umpan",
    Callback = function()
        BuyBait(SelectedBait, BuyBaitQuantity)
        Rayfield:Notify({Title = "Beli Umpan", Content = "Membeli " .. BuyBaitQuantity .. " " .. SelectedBait, Duration = 2})
    end
})

ShopTab:CreateDivider()

ShopTab:CreateDropdown({
    Name = "Pilih Pancing",
    Options = RodData,
    CurrentValue = RodData[3],
    Flag = "RodSelection",
    Callback = function(val)
        SelectedRod = val
    end
})

ShopTab:CreateButton({
    Name = "Beli Pancing",
    Callback = function()
        BuyRod(SelectedRod)
        Rayfield:Notify({Title = "Beli Pancing", Content = "Membeli " .. SelectedRod, Duration = 2})
    end
})

-- ---- Tab 4: Teleport ----
local TpTab = Window:CreateTab("🚀 Teleport", "map-pin")

TpTab:CreateSection("Fishing Spots")

for _, spot in ipairs(FishingSpots) do
    TpTab:CreateButton({
        Name = spot.Name,
        Callback = function()
            TeleportTo(spot.Position)
            Rayfield:Notify({Title = "Teleport", Content = "Teleport ke " .. spot.Name, Duration = 2})
        end
    })
end

TpTab:CreateSection("NPC Locations")

for _, npc in ipairs(NPClocations) do
    TpTab:CreateButton({
        Name = npc.Name,
        Callback = function()
            TeleportTo(npc.Position)
            Rayfield:Notify({Title = "Teleport", Content = "Teleport ke " .. npc.Name, Duration = 2})
        end
    })
end

-- ---- Tab 5: Utilities ----
local UtilTab = Window:CreateTab("⚙️ Utilities", "settings")

UtilTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(val)
        SpeedHacking = val
        if val then
            SetSpeed(HackSpeed)
        else
            SetSpeed(OriginalSpeed)
        end
    end
})

UtilTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "WalkSpeed",
    Callback = function(val)
        HackSpeed = val
        if SpeedHacking then
            SetSpeed(val)
        end
    end
})

UtilTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(val)
        if val then
            StartNoclip()
        else
            StopNoclip()
        end
    end
})

UtilTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(val)
        if val then
            StartInfJump()
        else
            StopInfJump()
        end
    end
})

UtilTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(val)
        if val then
            StartAntiAFK()
        else
            StopAntiAFK()
        end
    end
})

-- ---- Tab 6: Settings ----
local SettingsTab = Window:CreateTab("⚡ Settings", "sliders")

SettingsTab:CreateSection("Fishing Settings")

SettingsTab:CreateDropdown({
    Name = "Pancing Default",
    Options = RodData,
    CurrentValue = RodData[3],
    Flag = "DefaultRod",
    Callback = function(val)
        SelectedRod = val
    end
})

SettingsTab:CreateDropdown({
    Name = "Umpan Default",
    Options = BaitData,
    CurrentValue = BaitData[2],
    Flag = "DefaultBait",
    Callback = function(val)
        SelectedBait = val
    end
})

SettingsTab:CreateDivider()

SettingsTab:CreateSection("Auto Features")

SettingsTab:CreateToggle({
    Name = "Auto Equip Rod",
    CurrentValue = true,
    Flag = "AutoEquipRod",
    Callback = function(val)
        -- Toggle auto equip rod
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Equip Bait",
    CurrentValue = true,
    Flag = "AutoEquipBait",
    Callback = function(val)
        -- Toggle auto equip bait
    end
})

SettingsTab:CreateToggle({
    Name = "Show Notifications",
    CurrentValue = true,
    Flag = "ShowNotif",
    Callback = function(val)
        -- Toggle notifications
    end
})

SettingsTab:CreateDivider()

SettingsTab:CreateSection("About")

SettingsTab:CreateLabel("Titan Fishing Hub v1.0")
SettingsTab:CreatedLabel("Created for Sdeer Games")
SettingsTab:CreateLabel("Compatible with Delta Executor")

-- ================================================
--   Initialize
-- ================================================

Rayfield:Notify({
    Title = "Titan Fishing Hub",
    Content = "Script loaded successfully!",
    Duration = 3,
})

print("Titan Fishing Hub loaded!")
