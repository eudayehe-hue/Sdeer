-- ================================================
--   Haja Hub | Auto Farm Script
--   Game: Unknown Farming Game (Decompiled)
--   Crops: Padi, Jagung, Tomat, Terong, Strawberry, Sawit, Durian
--   Compatible with Delta Executor & other executors
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Haja Hub | Auto Farm",
    LoadingTitle = "Haja Hub",
    LoadingSubtitle = "Auto Farm by Haja Hub",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HajaHub",
        FileName = "AutoFarm_UnknownFarm"
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

local LocalPlayer = Players.LocalPlayer

-- ================================================
--   Remotes (from decompiled source)
-- ================================================

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local TutorialRemotes = Remotes and Remotes:FindFirstChild("TutorialRemotes")

local function GetRemote(name)
    if Remotes then
        return Remotes:FindFirstChild(name)
    end
    return nil
end

local function GetTutorialRemote(name)
    if TutorialRemotes then
        return TutorialRemotes:FindFirstChild(name)
    end
    return nil
end

-- ================================================
--   Shop Functions (from decompile)
-- ================================================

local ShopData = {
    Seeds = {},
    Tools = {}
}

-- Get shop seed list
local function GetSeedList()
    local RequestShop = GetRemote("RequestShop")
    if RequestShop then
        local result = pcall(function()
            return RequestShop:InvokeServer("GET_LIST")
        end)
        if result and result.Success and result.Seeds then
            ShopData.Seeds = result.Seeds
            return result.Seeds
        end
    end
    return {}
end

-- Get tool shop list
local function GetToolList()
    local RequestToolShop = GetRemote("RequestToolShop")
    if RequestToolShop then
        local result = pcall(function()
            return RequestToolShop:InvokeServer("GET_LIST")
        end)
        if result and result.Success and result.Tools then
            ShopData.Tools = result.Tools
            return result.Tools
        end
    end
    return {}
end

-- Buy seeds
local function BuySeed(seedName, quantity)
    local RequestShop = GetRemote("RequestShop")
    if RequestShop then
        local result = pcall(function()
            return RequestShop:InvokeServer("BUY", seedName, quantity or 1)
        end)
        return result
    end
    return nil
end

-- Buy tool
local function BuyTool(toolName)
    local RequestToolShop = GetRemote("RequestToolShop")
    if RequestToolShop then
        local result = pcall(function()
            return RequestToolShop:InvokeServer("BUY", toolName)
        end)
        return result
    end
    return nil
end

-- Auto buy seeds state
local AutoBuyingSeeds = false
local AutoBuySeedConn = nil
local SelectedSeedToBuy = "Bibit Padi"
local BuyQuantity = 10
local BuySeedDelay = 2.0

-- Auto buy tools state
local AutoBuyingTools = false
local AutoBuyToolConn = nil
local SelectedToolToBuy = ""

-- ================================================
--   Crop Config (from decompiled CropConfig)
-- ================================================

local CropConfig = {
    ["Bibit Padi"]       = { ToolName = "BibitTool",      HarvestItem = "Padi",       GrowthTime = 60,  AutoHarvestDelay = 60  },
    ["Bibit Jagung"]     = { ToolName = "JagungTool",     HarvestItem = "Jagung",     GrowthTime = 90,  AutoHarvestDelay = 90  },
    ["Bibit Tomat"]      = { ToolName = "TomatTool",      HarvestItem = "Tomat",      GrowthTime = 135, AutoHarvestDelay = 120 },
    ["Bibit Terong"]     = { ToolName = "TerongTool",     HarvestItem = "Terong",     GrowthTime = 175, AutoHarvestDelay = 150 },
    ["Bibit Strawberry"] = { ToolName = "StrawberryTool", HarvestItem = "Strawberry", GrowthTime = 215, AutoHarvestDelay = 200 },
    ["Bibit Sawit"]      = { ToolName = "SawitTool",      HarvestItem = "Sawit",      GrowthTime = 800, AutoHarvestDelay = 600, CustomHarvest = true },
    ["Bibit Durian"]     = { ToolName = "DurianTool",     HarvestItem = "Durian",     GrowthTime = 1000,AutoHarvestDelay = 700, CustomHarvest = true },
}

local SellableItems = {
    "Padi", "Jagung", "Tomat", "Terong", "Strawberry", "Sawit", "Durian"
}

-- ================================================
--   State Variables
-- ================================================

local AutoFarming       = false
local AutoFarmConn      = nil
local AutoHarvesting    = false
local AutoHarvestConn   = nil
local AutoSelling       = false
local AutoSellConn      = nil
local AutoPlanting      = false
local AutoPlantConn     = nil
local SpeedHacking      = false
local OriginalSpeed     = 16
local HackSpeed         = 50
local AntiAFKActive     = false
local AntiAFKConn       = nil
local NoclipActive      = false
local NoclipConn        = nil
local InfJumpActive     = false
local InfJumpConn       = nil
local SelectedCrop      = "Bibit Padi"
local FarmDelay         = 0.35
local SellDelay         = 3.0
local PlantDelay        = 0.35

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

local function GetNPC(npcType)
    -- NPCFolder = "NPCs", NPCBibit = "NPC_Bibit", NPCPenjual = "NPC_Penjual"
    local folder = workspace:FindFirstChild("NPCs")
    if not folder then return nil end
    return folder:FindFirstChild(npcType)
end

local function GetAreaTanam()
    local area = workspace:FindFirstChild("AreaTanam")
    if area then return area end
    for _, v in ipairs(workspace:GetChildren()) do
        if string.sub(v.Name, 1, 9) == "AreaTanam" then
            return v
        end
    end
    return nil
end

local function GetPlantSlots()
    local area = GetAreaTanam()
    if not area then return {} end
    local slots = {}
    for _, v in ipairs(area:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name == "Slot" or v.Name == "TanamSlot" or string.find(v.Name, "Slot")) then
            table.insert(slots, v)
        end
    end
    return slots
end

local function GetCurrentTool()
    local char = GetCharacter()
    if not char then return nil end
    return char:FindFirstChildWhichIsA("Tool")
end

local function EquipTool(toolName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return false end
    local tool = backpack:FindFirstChild(toolName)
    if tool then
        LocalPlayer.Character.Humanoid:EquipTool(tool)
        return true
    end
    return false
end

-- ================================================
--   Core Farm Functions
-- ================================================

-- Plant at player's current position (Y - 3) using the PlantCrop remote
local function PlantAtPosition()
    local PlantCrop = GetRemote("PlantCrop")
    if not PlantCrop then return end

    local cropData = CropConfig[SelectedCrop]
    if not cropData then return end

    local hrp = GetHRP()
    if not hrp then return end

    local plantPos = hrp.Position - Vector3.new(0, 3, 0)

    -- Equip the seed tool
    EquipTool(cropData.ToolName)
    task.wait(0.1)

    pcall(function()
        PlantCrop:FireServer(plantPos)
    end)
end

-- Harvest all ready crops
local function HarvestAll()
    local HarvestCrop = GetRemote("HarvestCrop")
    if not HarvestCrop then return end
    -- The server handles which crops are ready; just fire
    pcall(function()
        HarvestCrop:FireServer()
    end)
end

-- Sell all crops via RequestSell remote
local function SellAll()
    local RequestSell = GetRemote("RequestSell")
    if not RequestSell then return end

    -- Sell all crops
    pcall(function()
        local list = RequestSell:InvokeServer("GET_LIST")
        if list and type(list) == "table" then
            for itemName, amount in pairs(list) do
                if amount and amount > 0 then
                    pcall(function()
                        RequestSell:InvokeServer("SELL", itemName, amount)
                    end)
                    task.wait(0.1)
                end
            end
        end
    end)

    -- Also try sell all fruit (Sawit/Durian)
    for _, fruitType in ipairs({"Sawit", "Durian"}) do
        pcall(function()
            RequestSell:InvokeServer("SELL_ALL_FRUIT", fruitType)
        end)
        task.wait(0.1)
    end
end

-- Toggle Auto Harvest (server-side feature)
local function SetAutoHarvest(enabled)
    local ToggleAutoHarvest = GetTutorialRemote("ToggleAutoHarvest")
    if ToggleAutoHarvest then
        pcall(function()
            ToggleAutoHarvest:FireServer(enabled)
        end)
    end
end

-- ================================================
--   Auto Farm Loop (Plant + Harvest + Sell cycle)
-- ================================================

local function StartAutoFarm()
    if AutoFarmConn then AutoFarmConn:Disconnect() end
    AutoFarming = true

    -- Enable server-side auto harvest
    SetAutoHarvest(true)

    AutoFarmConn = RunService.Heartbeat:Connect(function()
        if not AutoFarming then
            AutoFarmConn:Disconnect()
            AutoFarmConn = nil
            return
        end

        local hrp = GetHRP()
        if not hrp then return end

        -- Plant at current position (Y - 3)
        local PlantCrop = GetRemote("PlantCrop")
        if PlantCrop then
            local cropData = CropConfig[SelectedCrop]
            if cropData then
                EquipTool(cropData.ToolName)
                task.wait(0.05)
                pcall(function()
                    PlantCrop:FireServer(hrp.Position - Vector3.new(0, 3, 0))
                end)
            end
        end

        task.wait(FarmDelay)
    end)
end

local function StopAutoFarm()
    AutoFarming = false
    SetAutoHarvest(false)
    if AutoFarmConn then
        AutoFarmConn:Disconnect()
        AutoFarmConn = nil
    end
end

-- ================================================
--   Auto Harvest Loop
-- ================================================

local function StartAutoHarvest()
    if AutoHarvestConn then AutoHarvestConn:Disconnect() end
    AutoHarvesting = true
    SetAutoHarvest(true)

    AutoHarvestConn = task.spawn(function()
        while AutoHarvesting do
            HarvestAll()
            task.wait(2)
        end
    end)
end

local function StopAutoHarvest()
    AutoHarvesting = false
    SetAutoHarvest(false)
end

-- ================================================
--   Auto Sell Loop
-- ================================================

local function StartAutoSell()
    AutoSelling = true
    task.spawn(function()
        while AutoSelling do
            SellAll()
            task.wait(SellDelay)
        end
    end)
end

local function StopAutoSell()
    AutoSelling = false
end

-- ================================================
--   Auto Plant Loop
-- ================================================

local function StartAutoPlant()
    AutoPlanting = true
    task.spawn(function()
        while AutoPlanting do
            local hrp = GetHRP()
            if hrp then
                local PlantCrop = GetRemote("PlantCrop")
                local cropData = CropConfig[SelectedCrop]
                if PlantCrop and cropData then
                    EquipTool(cropData.ToolName)
                    task.wait(0.1)
                    pcall(function()
                        PlantCrop:FireServer(hrp.Position - Vector3.new(0, 3, 0))
                    end)
                end
            end
            task.wait(PlantDelay)
        end
    end)
end

local function StopAutoPlant()
    AutoPlanting = false
end

-- ================================================
--   Utilities
-- ================================================

local function SetSpeed(speed)
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = speed
    end
end

local function StartNoclip()
    NoclipActive = true
    NoclipConn = RunService.Stepped:Connect(function()
        if not NoclipActive then
            NoclipConn:Disconnect()
            NoclipConn = nil
            return
        end
        local char = LocalPlayer.Character
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
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function StartInfJump()
    InfJumpActive = true
    InfJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
        if InfJumpActive then
            local hum = GetHumanoid()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function StopInfJump()
    InfJumpActive = false
    if InfJumpConn then
        InfJumpConn:Disconnect()
        InfJumpConn = nil
    end
end

local function StartAntiAFK()
    AntiAFKActive = true
    AntiAFKConn = task.spawn(function()
        while AntiAFKActive do
            local VirtualUser = game:GetService("VirtualUser")
            if VirtualUser then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
            task.wait(60)
        end
    end)
end

local function StopAntiAFK()
    AntiAFKActive = false
end

-- ================================================
--   Teleport Locations (based on NPC names from decompile)
-- ================================================

local function TeleportToNPC(npcType)
    local npc = GetNPC(npcType)
    if npc then
        local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
        if root then
            TeleportTo(root.Position + Vector3.new(0, 3, 5))
            return true
        end
    end
    return false
end

local function TeleportToFarm()
    local area = GetAreaTanam()
    if area then
        local center = area:GetBoundingBox()
        TeleportTo(center.Position + Vector3.new(0, 5, 0))
        return true
    end
    return false
end

-- ================================================
--   Rayfield UI Tabs
-- ================================================

-- ---- Tab 1: Auto Farm ----
local AutoFarmTab = Window:CreateTab("🌾 Auto Farm", "leaf")

AutoFarmTab:CreateToggle({
    Name = "Auto Farm (Plant + Harvest)",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(val)
        if val then
            StartAutoFarm()
        else
            StopAutoFarm()
        end
    end
})

AutoFarmTab:CreateDropdown({
    Name = "Pilih Tanaman",
    Options = {
        "Bibit Padi",
        "Bibit Jagung",
        "Bibit Tomat",
        "Bibit Terong",
        "Bibit Strawberry",
        "Bibit Sawit",
        "Bibit Durian",
    },
    CurrentOption = {"Bibit Padi"},
    MultipleOptions = false,
    Flag = "SelectedCrop",
    Callback = function(val)
        SelectedCrop = val[1] or val
    end
})

AutoFarmTab:CreateSlider({
    Name = "Farm Delay (detik)",
    Range = {0.1, 2.0},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.35,
    Flag = "FarmDelay",
    Callback = function(val)
        FarmDelay = val
    end
})

AutoFarmTab:CreateButton({
    Name = "Enable Server Auto Harvest",
    Callback = function()
        SetAutoHarvest(true)
        Rayfield:Notify({
            Title = "Auto Harvest",
            Content = "Server-side auto harvest diaktifkan!",
            Duration = 3,
        })
    end
})

AutoFarmTab:CreateButton({
    Name = "Disable Server Auto Harvest",
    Callback = function()
        SetAutoHarvest(false)
        Rayfield:Notify({
            Title = "Auto Harvest",
            Content = "Server-side auto harvest dinonaktifkan.",
            Duration = 3,
        })
    end
})

-- ---- Tab 2: Auto Harvest ----
local HarvestTab = Window:CreateTab("🌿 Auto Harvest", "scissors")

HarvestTab:CreateToggle({
    Name = "Auto Harvest",
    CurrentValue = false,
    Flag = "AutoHarvest",
    Callback = function(val)
        if val then
            StartAutoHarvest()
        else
            StopAutoHarvest()
        end
    end
})

HarvestTab:CreateButton({
    Name = "Harvest Sekarang",
    Callback = function()
        HarvestAll()
        Rayfield:Notify({
            Title = "Harvest",
            Content = "Memanen semua tanaman...",
            Duration = 2,
        })
    end
})

-- ---- Tab 3: Auto Plant ----
local PlantTab = Window:CreateTab("🌱 Auto Plant", "sprout")

PlantTab:CreateToggle({
    Name = "Auto Plant",
    CurrentValue = false,
    Flag = "AutoPlant",
    Callback = function(val)
        if val then
            StartAutoPlant()
        else
            StopAutoPlant()
        end
    end
})

PlantTab:CreateDropdown({
    Name = "Tanaman untuk Ditanam",
    Options = {
        "Bibit Padi",
        "Bibit Jagung",
        "Bibit Tomat",
        "Bibit Terong",
        "Bibit Strawberry",
        "Bibit Sawit",
        "Bibit Durian",
    },
    CurrentOption = {"Bibit Padi"},
    MultipleOptions = false,
    Flag = "PlantCrop",
    Callback = function(val)
        SelectedCrop = val[1] or val
    end
})

PlantTab:CreateSlider({
    Name = "Plant Delay (detik)",
    Range = {0.1, 2.0},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.35,
    Flag = "PlantDelay",
    Callback = function(val)
        PlantDelay = val
    end
})

-- ---- Tab 4: Auto Sell ----
local SellTab = Window:CreateTab("💰 Auto Sell", "dollar-sign")

SellTab:CreateToggle({
    Name = "Auto Sell Semua",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(val)
        if val then
            StartAutoSell()
        else
            StopAutoSell()
        end
    end
})

SellTab:CreateSlider({
    Name = "Sell Delay (detik)",
    Range = {1.0, 30.0},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 3.0,
    Flag = "SellDelay",
    Callback = function(val)
        SellDelay = val
    end
})

SellTab:CreateButton({
    Name = "Jual Semua Sekarang",
    Callback = function()
        SellAll()
        Rayfield:Notify({
            Title = "Jual",
            Content = "Menjual semua hasil panen...",
            Duration = 2,
        })
    end
})

SellTab:CreateButton({
    Name = "Jual Sawit Semua",
    Callback = function()
        local RequestSell = GetRemote("RequestSell")
        if RequestSell then
            pcall(function()
                RequestSell:InvokeServer("SELL_ALL_FRUIT", "Sawit")
            end)
            Rayfield:Notify({
                Title = "Jual Sawit",
                Content = "Menjual semua buah sawit...",
                Duration = 2,
            })
        end
    end
})

SellTab:CreateButton({
    Name = "Jual Durian Semua",
    Callback = function()
        local RequestSell = GetRemote("RequestSell")
        if RequestSell then
            pcall(function()
                RequestSell:InvokeServer("SELL_ALL_FRUIT", "Durian")
            end)
            Rayfield:Notify({
                Title = "Jual Durian",
                Content = "Menjual semua buah durian...",
                Duration = 2,
            })
        end
    end
})

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

-- ---- Tab 6: Teleport ----
local TpTab = Window:CreateTab("🚀 Teleport", "map-pin")

TpTab:CreateButton({
    Name = "Teleport ke Area Tanam",
    Callback = function()
        if TeleportToFarm() then
            Rayfield:Notify({ Title = "Teleport", Content = "Teleport ke Area Tanam!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Area Tanam tidak ditemukan.", Duration = 3 })
        end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke NPC Penjual (Jual Hasil)",
    Callback = function()
        if TeleportToNPC("NPC_Penjual") then
            Rayfield:Notify({ Title = "Teleport", Content = "Teleport ke NPC Penjual!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "NPC Penjual tidak ditemukan.", Duration = 3 })
        end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke NPC Bibit (Beli Bibit)",
    Callback = function()
        if TeleportToNPC("NPC_Bibit") then
            Rayfield:Notify({ Title = "Teleport", Content = "Teleport ke NPC Bibit!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "NPC Bibit tidak ditemukan.", Duration = 3 })
        end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke NPC Alat (Beli Alat)",
    Callback = function()
        if TeleportToNPC("NPC_Alat") then
            Rayfield:Notify({ Title = "Teleport", Content = "Teleport ke NPC Alat!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "NPC Alat tidak ditemukan.", Duration = 3 })
        end
    end
})

TpTab:CreateButton({
    Name = "Teleport ke NPC Pedagang Sawit",
    Callback = function()
        if TeleportToNPC("NPC_PedagangSawit") then
            Rayfield:Notify({ Title = "Teleport", Content = "Teleport ke NPC Pedagang Sawit!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Error", Content = "NPC Pedagang Sawit tidak ditemukan.", Duration = 3 })
        end
    end
})

-- ---- Tab 7: Shop ----
local ShopTab = Window:CreateTab("🛒 Shop", "shopping-cart")

-- Seed selection dropdown
local seedNames = {"Bibit Padi", "Bibit Jagung", "Bibit Tomat", "Bibit Terong", "Bibit Strawberry", "Bibit Sawit", "Bibit Durian"}

ShopTab:CreateDropdown({
    Name = "Pilih Bibit",
    Options = seedNames,
    CurrentValue = seedNames[1],
    Flag = "SeedSelection",
    Callback = function(val)
        SelectedSeedToBuy = val
    end
})

ShopTab:CreateSlider({
    Name = "Jumlah Beli",
    Range = {1, 99},
    Increment = 1,
    Suffix = "",
    CurrentValue = 10,
    Flag = "BuyQuantity",
    Callback = function(val)
        BuyQuantity = val
    end
})

ShopTab:CreateButton({
    Name = "Beli Bibit Sekarang",
    Callback = function()
        local result = BuySeed(SelectedSeedToBuy, BuyQuantity)
        if result and result.Success then
            Rayfield:Notify({ Title = "Berhasil", Content = result.Message or "Bibit berhasil dibeli!", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Gagal", Content = result and result.Message or "Gagal membeli bibit.", Duration = 3 })
        end
    end
})

ShopTab:CreateDivider()

ShopTab:CreateButton({
    Name = "Ambil Daftar Bibit dari Server",
    Callback = function()
        local seeds = GetSeedList()
        if #seeds > 0 then
            Rayfield:Notify({ Title = "Sukses", Content = "Daftar bibit berhasil diambil! (" .. #seeds .. " items)", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Gagal mengambil daftarbibit.", Duration = 3 })
        end
    end
})

ShopTab:CreateButton({
    Name = "Ambil Daftar Alat dari Server",
    Callback = function()
        local tools = GetToolList()
        if #tools > 0 then
            Rayfield:Notify({ Title = "Sukses", Content = "Daftar alat berhasil diambil! (" .. #tools .. " items)", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Gagal mengambil daftar alat.", Duration = 3 })
        end
    end
})

ShopTab:CreateDivider()

-- Auto Buy Seeds Toggle
ShopTab:CreateToggle({
    Name = "Auto Beli Bibit",
    CurrentValue = false,
    Flag = "AutoBuySeeds",
    Callback = function(val)
        AutoBuyingSeeds = val
        if val then
            if not AutoBuySeedConn then
                AutoBuySeedConn = RunService.Heartbeat:Connect(function()
                    if AutoBuyingSeeds then
                        local result = BuySeed(SelectedSeedToBuy, BuyQuantity)
                        if result and result.Success then
                            -- Success notification optional
                        end
                        task.wait(BuySeedDelay)
                    end
                end)
            end
            Rayfield:Notify({ Title = "Auto Beli Bibit", Content = "Aktif!", Duration = 2 })
        else
            if AutoBuySeedConn then
                AutoBuySeedConn:Disconnect()
                AutoBuySeedConn = nil
            end
            Rayfield:Notify({ Title = "Auto Beli Bibit", Content = "Nonaktif!", Duration = 2 })
        end
    end
})

ShopTab:CreateSlider({
    Name = "Auto Beli Delay",
    Range = {0.5, 10},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 2.0,
    Flag = "BuySeedDelay",
    Callback = function(val)
        BuySeedDelay = val
    end
})

-- ---- Tab 8: Info ----
local InfoTab = Window:CreateTab("ℹ️ Info", "info")

InfoTab:CreateSection("Crop Info")

InfoTab:CreateLabel("🌾 Padi - Grow: 50-60s | AutoHarvest: 60s | Sell: 10/ea")
InfoTab:CreateLabel("🌽 Jagung - Grow: 80-100s | AutoHarvest: 90s | Sell: 20/ea")
InfoTab:CreateLabel("🍅 Tomat - Grow: 120-150s | AutoHarvest: 120s | Sell: 30/ea")
InfoTab:CreateLabel("🍆 Terong - Grow: 150-200s | AutoHarvest: 150s | Sell: 50/ea")
InfoTab:CreateLabel("🍓 Strawberry - Grow: 180-250s | AutoHarvest: 200s | Sell: 75/ea")
InfoTab:CreateLabel("🌴 Sawit - Grow: 600-1000s | AutoHarvest: 600s | Sell: 1500/ea")
InfoTab:CreateLabel("🍈 Durian - Grow: 800-1200s | AutoHarvest: 700s")

InfoTab:CreateSection("Remotes Used")
InfoTab:CreateLabel("PlantCrop / PlantLahanCrop - Tanam tanaman")
InfoTab:CreateLabel("HarvestCrop - Panen tanaman")
InfoTab:CreateLabel("RequestSell - Jual hasil panen")
InfoTab:CreateLabel("ToggleAutoHarvest - Auto harvest server-side")
InfoTab:CreateLabel("RequestShop - Beli bibit (GET_LIST, BUY)")
InfoTab:CreateLabel("RequestToolShop - Beli alat (GET_LIST, BUY)")

-- ================================================
--   Notify on Load
-- ================================================

Rayfield:Notify({
    Title = "Haja Hub Loaded",
    Content = "Auto Farm script berhasil dimuat! Pilih tanaman dan aktifkan fitur.",
    Duration = 5,
})
