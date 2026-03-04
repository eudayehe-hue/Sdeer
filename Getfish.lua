
-- =============================================================================
-- DUALITY HUB PREMIUM - PANDA KEY SYSTEM + FISHING CORE + AUTO MODE
-- FULL SCRIPT FINAL - SIAP PASTE
-- =============================================================================

--[[
    Duality Hub Premium - FULL COMPLETE VERSION
    Access: Panda Key System
    Features: Auto Farm, Smart Blatant, Teleport, Auto Sell, etc.
    Role: Haja Hub Ai (VEXTH)
]]

-- =============================================================================
-- [1] PANDA KEY SYSTEM LOGIC
-- =============================================================================

local BaseURL = "https://new.pandadevelopment.net/api/v1"
local Client_ServiceID = "u1678"

local function getHardwareId()
    local success, hwid = pcall(gethwid)
    if success and hwid then
        return hwid
    end
    local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
    local clientId = tostring(RbxAnalyticsService:GetClientId())
    return clientId:gsub("-", "")
end

local function makeRequest(endpoint, body)
    local HttpService = game:GetService("HttpService")
    local url = BaseURL .. endpoint
    local jsonBody = HttpService:JSONEncode(body)
    
    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
    if not httpRequest then
        warn("Executor does not support HTTP requests.")
        return nil
    end

    local response = httpRequest({
        Url = url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonBody
    })

    if response and response.Body then
        return HttpService:JSONDecode(response.Body)
    end
    return nil
end

function GetKeyURL()
    local hwid = getHardwareId()
    return "https://new.pandadevelopment.net/getkey/" .. Client_ServiceID .. "?hwid=" .. hwid
end

function ValidateKey(key)
    local hwid = getHardwareId()
    local result = makeRequest("/keys/validate", {
        ServiceID = Client_ServiceID,
        HWID = hwid,
        Key = key
    })
    if not result then return {success = false} end
    return {
        success = (result.Authenticated_Status == "Success"),
        message = result.Note or "Verification Result",
        isPremium = result.Key_Premium or false
    }
end

-- =============================================================================
-- [2] INITIAL KEY UI
-- =============================================================================

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "PandaAuth_DualityHub"
KeyGui.Parent = game:GetService("CoreGui")
KeyGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 340, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -170, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = KeyGui

local UICorner_1 = Instance.new("UICorner", KeyFrame)
UICorner_1.CornerRadius = UDim.new(0, 10)

local UIStroke_1 = Instance.new("UIStroke", KeyFrame)
UIStroke_1.Color = Color3.fromRGB(0, 170, 255)
UIStroke_1.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "DUALITY HUB - KEY SYSTEM"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.Parent = KeyFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0.38, 0, 0, 40)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyBtn.Text = "VERIFY"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Parent = KeyFrame
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.38, 0, 0, 40)
GetKeyBtn.Position = UDim2.new(0.52, 0, 0.65, 0)
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Parent = KeyFrame
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

-- START LANGSUNG (KEY SYSTEM DILEWATI)
StartDualityHub()
    
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local TweenService = game:GetService("TweenService")
    local Stats = game:GetService("Stats")

    local player = Players.LocalPlayer
    local pgui = player:WaitForChild("PlayerGui")
    local backpack = player:WaitForChild("Backpack")

    local scriptStartTime = tick()
    local lifetimeRunning = true
   
    -- Fungsi mendapatkan ping
    local function getPing()
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
        return ping
    end
    
    -- =========================================================================
-- VARIABEL ANTI AFK
-- =========================================================================
local antiAfkEnabled = false
local antiAfkTask = nil
local virtualUser = game:GetService("VirtualUser")
    
    -- Fungsi toggle anti AFK
local function toggleAntiAfk(state)
    antiAfkEnabled = state
    
    if state then
        if antiAfkTask then
            task.cancel(antiAfkTask)
            antiAfkTask = nil
        end
        
        antiAfkTask = task.spawn(function()
            print("[Anti AFK] Dimulai")
            while antiAfkEnabled do
                pcall(function()
                    -- Simulasi aktivitas mouse
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                    
                    -- Alternatif: gerakkan kamera sedikit
                    local camera = workspace.CurrentCamera
                    if camera then
                        camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(0.1), 0)
                    end
                end)
                task.wait(60) -- Jalankan setiap 60 detik
            end
            print("[Anti AFK] Dimatikan")
            antiAfkTask = nil
        end)
    else
        if antiAfkTask then
            task.cancel(antiAfkTask)
            antiAfkTask = nil
        end
    end
end

-- =============================================================================
-- MODUL FISHING CORE (RATW ENGINE) - UNTUK BLATANT MODE
-- =============================================================================
local BlatantModule = {}

local StartAutoFishing = ReplicatedStorage:FindFirstChild("LevelSystem") and 
                         ReplicatedStorage.LevelSystem:FindFirstChild("ToServer") and 
                         ReplicatedStorage.LevelSystem.ToServer:FindFirstChild("StartAutoFishing")

local StopAutoFishing = ReplicatedStorage:FindFirstChild("LevelSystem") and 
                        ReplicatedStorage.LevelSystem:FindFirstChild("ToServer") and 
                        ReplicatedStorage.LevelSystem.ToServer:FindFirstChild("StopAutoFishing")

local Fishing_RemoteThrow = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
local Fishing_RemoteParked = ReplicatedStorage:FindFirstChild("Fishing_RemoteParked")
local Fishing_RemoteRetract = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract") -- tambahan

local DEFAULT_UUID = "324ca136-b1d1-45eb-b6f8-4c219a163529"

local fishingON = false
local parkedTask = nil
local reelTask = nil
local reelCount = 0
local cyclePhase = "NORMAL"
local firstReelDone = false
local firstThrowDone = false

-- Variabel untuk Blatant Mode
local blatant2Task = nil
local bobberFireTask = nil

local function getUUID()
    local c = player.Character
    local rod = nil
    
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") and v.Name:match("ROD$") then
                rod = v
                break
            end
        end
    end
    
    if not rod then
        for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name:match("ROD$") then
                rod = v
                break
            end
        end
    end
    
    if rod and rod.Parent == backpack and c then
        rod.Parent = c
        task.wait(0.2)
    end
    
    if not rod then
        return DEFAULT_UUID
    end
    
    local uuid = rod:GetAttribute("ToolUniqueId") or 
                 rod:GetAttribute("UniqueId") or 
                 rod:GetAttribute("UUID") or 
                 rod.Name
                 
    return tostring(uuid)
end

local function autoEquipRod()
    local c = player.Character
    if not c then return false end
    
    for _, v in ipairs(c:GetChildren()) do
        if v:IsA("Tool") and v.Name:match("ROD$") then
            return true
        end
    end
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:match("ROD$") then
            tool.Parent = c
            task.wait(0.3)
            return true
        end
    end
    
    return false
end

local function fireFirstThrow()
    pcall(function()
        if Fishing_RemoteThrow then
            Fishing_RemoteThrow:FireServer(0.77109680999911, DEFAULT_UUID)
            firstThrowDone = true
        end
    end)
end

local function fireStartAutoFishing()
    pcall(function()
        if StartAutoFishing then
            StartAutoFishing:FireServer()
        end
    end)
end

local function fireStopAutoFishing()
    pcall(function()
        if StopAutoFishing then
            StopAutoFishing:FireServer()
        end
    end)
end

local function startParked()
    if parkedTask then return end
    
    parkedTask = task.spawn(function()
        task.wait(1.5)
        
        while fishingON do
            pcall(function()
                if Fishing_RemoteParked then
                    local uuid = getUUID()
                    local pos = player.Character and 
                               player.Character:FindFirstChild("HumanoidRootPart") and 
                               player.Character.HumanoidRootPart.Position or Vector3.new(-453.766, 992, 165.67)
                    
                    firesignal(Fishing_RemoteParked.OnClientEvent, true, uuid, {}, pos)
                    
                    -- 🔥 TAMBAHAN: Fire RemoteRetract bersamaan dengan parked
                    if Fishing_RemoteRetract then
                        Fishing_RemoteRetract:FireServer(uuid)
                    end
                end
            end)
            task.wait(0.01)
        end
        
        parkedTask = nil
    end)
end

local function stopParked()
    if parkedTask then
        task.cancel(parkedTask)
        parkedTask = nil
    end
end

local function startReel()
    if reelTask then return end
    
    reelCount = 0
    cyclePhase = "NORMAL"
    firstReelDone = false
    
    reelTask = task.spawn(function()
        task.wait(2.5)
        
        while fishingON do
            pcall(function()
                autoEquipRod()
                local uuid = getUUID()
                local ev = ReplicatedStorage.Fishing and 
                          ReplicatedStorage.Fishing.ToServer and 
                          ReplicatedStorage.Fishing.ToServer:FindFirstChild("ReelFinished")
                
                if ev then
                    ev:FireServer({duration=12, result="SUCCESS", insideRatio=1}, uuid)
                    reelCount = reelCount + 1
                    
                    if firstReelDone then
                        if cyclePhase == "NORMAL" and reelCount >= 19 then
                            cyclePhase = "SLOW"
                            reelCount = 0
                        elseif cyclePhase == "SLOW" and reelCount >= 10 then
                            cyclePhase = "NORMAL"
                            reelCount = 0
                        end
                    end
                end
            end)
            
            if not firstReelDone then
                task.wait(3.5)
                firstReelDone = true
            elseif cyclePhase == "NORMAL" then
                task.wait(1.5)
            else
                task.wait(2.3)
            end
        end
        
        reelTask = nil
    end)
end

local function stopReel()
    if reelTask then
        task.cancel(reelTask)
        reelTask = nil
    end
    reelCount = 0
    cyclePhase = "NORMAL"
    firstReelDone = false
end

local function startFishing() -- Mode 1
    if fishingON then return end
    fishingON = true
    firstThrowDone = false
    firstReelDone = false
    reelCount = 0
    cyclePhase = "NORMAL"
    
    fireFirstThrow()
    fireStartAutoFishing()
    startParked()
    startReel()
end

local function stopFishing()
    if not fishingON then return end
    fishingON = false
    
    stopParked()
    stopReel()
    fireStopAutoFishing()
end

-- =============================================================================
-- BLATANT MODE (RemoteAutofishing → throw → ReelFinished → Reel → stop → repeat)
-- Parallel: BobberFire setiap 0.01s
-- =============================================================================

local function findRemoteDeep(name)
    -- Cari di lokasi umum dulu
    local locations = {
        ReplicatedStorage,
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("Events"),
        ReplicatedStorage:FindFirstChild("RemoteEvents"),
        ReplicatedStorage:FindFirstChild("RF"),
        ReplicatedStorage:FindFirstChild("RE"),
        ReplicatedStorage:FindFirstChild("Fishing"),
        ReplicatedStorage:FindFirstChild("Fishing") and ReplicatedStorage.Fishing:FindFirstChild("ToServer"),
        ReplicatedStorage:FindFirstChild("LevelSystem") and ReplicatedStorage.LevelSystem:FindFirstChild("ToServer"),
    }
    for _, loc in ipairs(locations) do
        if loc then
            local r = loc:FindFirstChild(name)
            if r then return r end
        end
    end
    -- Deep search
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == name then return v end
    end
    return nil
end

local function fireRemote(remote, ...)
    if not remote then return end
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(...)
        end
    end)
end

local function startBlatant2()
    if fishingON then return end
    fishingON = true

    -- Loop utama: RemoteAutofishing → throw → ReelFinished → Reel → stop → repeat
    blatant2Task = task.spawn(function()
        while fishingON do
            pcall(function()
                -- Step 1: RemoteAutofishing (start auto fishing)
                local remoteAutoFishing = findRemoteDeep("RemoteAutofishing")
                    or findRemoteDeep("StartAutoFishing")
                    or findRemoteDeep("AutoFishing")
                fireRemote(remoteAutoFishing)
                task.wait(0.1)

                -- Step 2: throw (lempar kail)
                local throwRemote = findRemoteDeep("throw")
                    or findRemoteDeep("Throw")
                    or findRemoteDeep("Fishing_RemoteThrow")
                    or findRemoteDeep("CastRod")
                if throwRemote then
                    -- Fishing_RemoteThrow butuh parameter power + uuid
                    if throwRemote.Name == "Fishing_RemoteThrow" then
                        local uuid = getUUID()
                        fireRemote(throwRemote, 0.77109680999911, uuid)
                    else
                        fireRemote(throwRemote)
                    end
                end
                task.wait(0.2)

                -- Step 3: ReelFinished (sinyal reel selesai)
                local reelFinishedRemote = findRemoteDeep("ReelFinished")
                    or findRemoteDeep("reelfinished")
                    or findRemoteDeep("FinishReel")
                if reelFinishedRemote then
                    local uuid = getUUID()
                    -- Coba dengan parameter dulu, fallback tanpa parameter
                    pcall(function()
                        if reelFinishedRemote:IsA("RemoteEvent") then
                            reelFinishedRemote:FireServer({duration=12, result="SUCCESS", insideRatio=1}, uuid)
                        elseif reelFinishedRemote:IsA("RemoteFunction") then
                            reelFinishedRemote:InvokeServer({duration=12, result="SUCCESS", insideRatio=1}, uuid)
                        end
                    end)
                end
                task.wait(0.1)

                -- Step 4: Reel (tarik ikan)
                local reelRemote = findRemoteDeep("Reel")
                    or findRemoteDeep("reel")
                    or findRemoteDeep("ReelFish")
                    or findRemoteDeep("Fishing_RemoteRetract")
                if reelRemote then
                    if reelRemote.Name == "Fishing_RemoteRetract" then
                        local uuid = getUUID()
                        fireRemote(reelRemote, uuid)
                    else
                        fireRemote(reelRemote)
                    end
                end
                task.wait(0.1)

                -- Step 5: Stop auto fishing (reset state)
                local stopRemote = findRemoteDeep("StopAutoFishing")
                    or findRemoteDeep("StopFishing")
                    or findRemoteDeep("CancelFishing")
                fireRemote(stopRemote)
                task.wait(0.05)
            end)
            task.wait(0.05)
        end
        blatant2Task = nil
    end)

    -- Loop paralel: BobberFire setiap 0.01s
    bobberFireTask = task.spawn(function()
        while fishingON do
            pcall(function()
                local bobberRemote = findRemoteDeep("BobberFire")
                    or findRemoteDeep("bobberfire")
                    or findRemoteDeep("Bobber")
                    or findRemoteDeep("BobberEvent")
                fireRemote(bobberRemote)
            end)
            task.wait(0.01)
        end
        bobberFireTask = nil
    end)
end

local function stopBlatant2()
    fishingON = false
    if blatant2Task then
        task.cancel(blatant2Task)
        blatant2Task = nil
    end
    if bobberFireTask then
        task.cancel(bobberFireTask)
        bobberFireTask = nil
    end
    -- Panggil StopAutoFishing
    pcall(function()
        if StopAutoFishing then
            StopAutoFishing:FireServer()
        end
    end)
end

function BlatantModule.Toggle(state)
    if state then
        startBlatant2()
    else
        stopBlatant2()
    end
end

function BlatantModule.GetStatus()
    return {
        active = fishingON,
        phase = cyclePhase,
        reelCount = reelCount,
        firstDone = firstReelDone
    }
end
-- =============================================================================
-- AKHIR MODUL FISHING CORE
-- =============================================================================

    -- =========================================================================
    -- EQUIP BOBBER STARTER 5X SAAT LOAD
    -- =========================================================================
    task.spawn(function()
        task.wait(3)
        local bobberEvent = ReplicatedStorage:FindFirstChild("BobberShop") and 
                            ReplicatedStorage.BobberShop:FindFirstChild("ToServer") and 
                            ReplicatedStorage.BobberShop.ToServer:FindFirstChild("EquipBobber")
        
        if bobberEvent then
            for i = 1, 5 do
                pcall(function()
                    bobberEvent:FireServer("BOBBER_STARTER")
                end)
                task.wait(2)
            end
        end
    end)

    -- =========================================================================
    -- VARIABEL GLOBAL & FUNGSI UTAMA
    -- =========================================================================
    local ROD_CHECK_COUNTER = 0
    local MAX_ROD_CHECK_ATTEMPTS = 5
    local NO_ROD_WAIT_TIME = 10
    local lastRodCheckTime = 0
    local rodNotFoundWarningShown = false
    local isFirstCycle = true
    local cycleCounter = 0
    local isFirstStandaloneCycle = true

    local reelFinishedCounter = 0
    local MAX_REEL_NORMAL = 100
    local boostFrame = nil

    local standaloneReelCounter = 0
    local originalPosBeforeAdjust = nil

    local Settings = {
        autoFarm = false,
        autoFishing = false,
        fishingMode = "Fast",
        fishingDelayFast = 2.62,
        fishingDelayLegit = 3.5,
        
        autosell = false,
        sellValue = 600,
        autosellDelay = 70,
        autoworm = false,
        
        freeze = false,
        freezePos = nil,
        noClip = true,
        infOxygen = true,
        
        potionSelect = "EXTREME_POTION",
        potionDelay = 2.0,
        skinSelect = "SKINCF_FAIRY_SPARK",
        rodSelect = "PINKYS",
        bobberSelect = "BOBBER_ROYAL",
        autoBuyPotion = false,
        autoBuySkin = false,
        autoBuyRod = false,
        autoBuyBobber = false,
        
        boostPing = false,
        selectedZone = "Mira nusa",
        teleportTarget = "Mira nusa",
        
        wormSpot = Vector3.new(-1894, 1007, -1607),
        
        activeMegalodon = false,
        adjustPosition = false,
        blatantMode = false,
    }

    local autoFishingTask = nil
    local standaloneFishingTask = nil
    local expiryTimestamp = nil
    local Window = nil
    local autoFishingPaused = false
    local autoSellTask = nil

    local ZoneData = {
        ["Mira nusa"] = { 
            fishingPos = Vector3.new(-344, 991, 480), 
            parkedPos = Vector3.new(-273, 1131, 312),
            teleportPos = Vector3.new(-285, 1135, 300)
        },
        ["Deep Sea 1"] = { 
            fishingPos = Vector3.new(1015, 990, 1633), 
            parkedPos = Vector3.new(1015, 1021, 1618),
            teleportPos = Vector3.new(1132, 1054, 1584) 
        },
        ["Deep Sea 2"] = { 
            fishingPos = Vector3.new(924, 882, 1660), 
            parkedPos = Vector3.new(923.02996826172, 832, 1808.1125488281),
            teleportPos = Vector3.new(880, 846, 1788) 
        },
        ["Tropical Isle"] = { 
            fishingPos = Vector3.new(-1852, 991, -1577), 
            parkedPos = Vector3.new(-1877, 1043, -1552),
            teleportPos = Vector3.new(-1890, 1045, -1560) 
        },
        ["Mega Zone"] = { 
            fishingPos = Vector3.new(-623, 990, -1728), 
            parkedPos = Vector3.new(-613, 1012, -1797),
            teleportPos = Vector3.new(-608, 1008, -1795) 
        },
        ["MAJITOS Zone"] = { 
            fishingPos = Vector3.new(2443, 990, 140), 
            parkedPos = Vector3.new(2210, 1027, 23),
            teleportPos = Vector3.new(2220, 1030, 30) 
        },
        ["Kinyis Isle"] = { 
            fishingPos = Vector3.new(-54, 990, -1092), 
            parkedPos = Vector3.new(102, 1051, -805),
            teleportPos = Vector3.new(100, 1012, -771) 
        },
        ["Skyler Zone"] = { 
            fishingPos = Vector3.new(-1617, 990, 1552), 
            parkedPos = Vector3.new(-1468, 1052, 1521),
            teleportPos = Vector3.new(-1480, 1055, 1530) 
        },
        ["Ocean Zone"] = { 
            fishingPos = Vector3.new(73, 990, -338),
            parkedPos = Vector3.new(73, 1000, -338),
            teleportPos = Vector3.new(-1089, 995, -516)
        }
    }

    -- =========================================================================
    -- FUNGSI UTILITAS
    -- =========================================================================
    function hasRodInInventory()
        if tick() - lastRodCheckTime > 60 then ROD_CHECK_COUNTER = 0 end
        local character = player.Character
        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:match("ROD$") then
                    ROD_CHECK_COUNTER = 0; rodNotFoundWarningShown = false; return true, tool
                end
            end
        end
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:match("ROD$") then
                ROD_CHECK_COUNTER = 0; rodNotFoundWarningShown = false; return true, tool
            end
        end
        ROD_CHECK_COUNTER = ROD_CHECK_COUNTER + 1
        lastRodCheckTime = tick()
        return false, nil
    end

    function getRodUUID()
        if ROD_CHECK_COUNTER >= MAX_ROD_CHECK_ATTEMPTS then return nil end
        local hasRod, rod = hasRodInInventory()
        if not hasRod then return nil end
        if rod.Parent == backpack then 
            local char = player.Character
            if char then 
                rod.Parent = char 
                task.wait(0.3) 
            end 
        end
        return tostring(rod:GetAttribute("ToolUniqueId") or rod:GetAttribute("UniqueId") or rod:GetAttribute("UUID") or tostring(rod.Name))
    end

    local function autoEquipRod()
        local hasRod, rod = hasRodInInventory()
        if hasRod and rod.Parent == backpack then
            rod.Parent = player.Character
            task.wait(0.5)
        end
    end

    -- =========================================================================
    -- FUNGSI NO CLIP & INF OXYGEN
    -- =========================================================================
    local function enableNoClipAndInfOxygenOnStart()
        Settings.noClip = true
        Settings.infOxygen = true
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        local oxyScript = player.PlayerScripts:FindFirstChild("OxygenSystem.client")
        if oxyScript then oxyScript.Disabled = true end
        if Lighting:FindFirstChild("UnderwaterBlur") then Lighting.UnderwaterBlur:Destroy() end
    end

    local function applyNoClip(character, enable)
        if not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not enable end
        end
    end

    -- =========================================================================
    -- FUNGSI TELEPORT ZONE
    -- =========================================================================
    local function instantTeleport(root, targetPos)
        if root then root.CFrame = CFrame.new(targetPos) end
    end

    local function teleportToZone(zone, isManual)
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local root = character.HumanoidRootPart
        local zoneData = ZoneData[zone]
        if not zoneData then return end
        
        local targetPos = isManual and zoneData.teleportPos or zoneData.fishingPos
        
        local wasAutoFarm = Settings.autoFarm
        if not isManual and wasAutoFarm then
            autoFishingPaused = true
            Settings.freeze = false
        end
        
        applyNoClip(character, false)
        task.wait(0.8)
        
        instantTeleport(root, targetPos)
        
        applyNoClip(character, true)
        
        if not isManual then
            Settings.freeze = true
            Settings.freezePos = root.CFrame
            task.wait(2.9)
            if wasAutoFarm then
                isFirstCycle = true
                cycleCounter = 0
                autoFishingPaused = false
                autoEquipRod()
            end
        else
            Settings.freeze = false 
        end
    end

    -- =========================================================================
    -- FUNGSI AUTO FARM UTAMA (dengan mode Fast/Legit/Auto)
    -- =========================================================================
    local function getReelDelay()
        if Settings.fishingMode == "Fast" then
            return Settings.fishingDelayFast
        elseif Settings.fishingMode == "Legit" then
            return Settings.fishingDelayLegit
        else -- Auto
            local ping = getPing()
            if ping > 200 then
                return 4.0
            elseif ping > 150 then
                return 3.5
            elseif ping > 100 then
                return 3.0
            elseif ping > 50 then
                return 2.8
            else
                return 2.62
            end
        end
    end

    local function optimizedAutoFishing()
        while Settings.autoFarm do
            if autoFishingPaused then 
                task.wait(0.5) 
                continue 
            end
            
            local char = player.Character
            if not char then 
                task.wait(2) 
                continue 
            end
            
            local hasRod, rod = hasRodInInventory()
            if not hasRod then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:match("ROD$") then
                        tool.Parent = char
                        task.wait(0.5)
                        break
                    end
                end
                task.wait(1)
                continue
            end
            
            local uuid = getRodUUID()
            if not uuid then 
                task.wait(1) 
                continue 
            end
            
            local success = pcall(function()
                local ParkedEvent = ReplicatedStorage:FindFirstChild("Fishing_RemoteParked")
                if ParkedEvent and not isFirstCycle then
                    firesignal(ParkedEvent.OnClientEvent, true, uuid, {}, ZoneData[Settings.selectedZone].parkedPos)
                end
                
                local throwEvent = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
                if throwEvent then
                    throwEvent:FireServer(math.random(812, 850) / 1000, uuid)
                end
                
                local currentDelay = getReelDelay()
                if isFirstCycle then currentDelay = 3.5 end
                task.wait(currentDelay)
                
                local ReelFinished = ReplicatedStorage:FindFirstChild("Fishing") and 
                                     ReplicatedStorage.Fishing:FindFirstChild("ToServer") and 
                                     ReplicatedStorage.Fishing.ToServer:FindFirstChild("ReelFinished")
                
                if ReelFinished then
                    ReelFinished:FireServer({
                        duration = math.random(6,8) + math.random(),
                        result = "SUCCESS",
                        insideRatio = ({0.2, 0.4, 0.6, 0.8})[math.random(1,4)]
                    }, uuid)
                    
                    reelFinishedCounter = reelFinishedCounter + 1
                    
                    if reelFinishedCounter >= MAX_REEL_NORMAL then
                        autoFishingPaused = true
                        
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local root = char.HumanoidRootPart
                            local randomOffset = Vector3.new(math.random(-20,20), 0, math.random(-20,20))
                            root.CFrame = CFrame.new(root.Position + randomOffset)
                            task.wait(0.5)
                        end
                        
                        local secretGacha = ReplicatedStorage:FindFirstChild("SecretGacha")
                        if secretGacha and secretGacha:FindFirstChild("ToClient") and 
                           secretGacha.ToClient:FindFirstChild("OpenUI") then
                            firesignal(secretGacha.ToClient.OpenUI.OnClientEvent)
                        end
                        
                        reelFinishedCounter = 0
                        autoFishingPaused = false
                    end
                end
                
                if ParkedEvent and not isFirstCycle then
                    firesignal(ParkedEvent.OnClientEvent, false, uuid)
                end
                
                isFirstCycle = false
            end)
            
            if not success then
                warn("[AutoFarm] Error dalam siklus fishing")
            end
            
            task.wait(0.1)
        end
        
        reelFinishedCounter = 0
    end

-- =============================================================================
-- FUNGSI STANDALONE AUTO FISHING (DENGAN REMOTE PARKED, TANPA RETRACT)
-- =============================================================================
local function standaloneAutoFishing()
    print("[Standalone] Auto Fishing dimulai")
    local firstCycle = true
    
    while Settings.autoFishing do
        if autoFishingPaused then 
            task.wait(0.5) 
            continue 
        end
        
        local char = player.Character
        if not char then 
            task.wait(2) 
            continue 
        end
        
        local hasRod, rod = hasRodInInventory()
        if not hasRod then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:match("ROD$") then
                    tool.Parent = char
                    task.wait(0.5)
                    break
                end
            end
            task.wait(1)
            continue
        end
        
        local uuid = getRodUUID()
        if not uuid then 
            task.wait(1) 
            continue 
        end
        
        local success = pcall(function()
            local ParkedEvent = ReplicatedStorage:FindFirstChild("Fishing_RemoteParked")
            local currentPos = char.HumanoidRootPart.Position
            
            -- Parked ON sebelum throw (kecuali cycle pertama)
            if ParkedEvent and not firstCycle then
                firesignal(ParkedEvent.OnClientEvent, true, uuid, {}, currentPos)
            end
            
            -- Throw
            local throwEvent = ReplicatedStorage:FindFirstChild("Fishing_RemoteThrow")
            if throwEvent then
                throwEvent:FireServer(math.random(812, 850) / 1000, uuid)
            end
            
            -- Delay sesuai mode
            local currentDelay = getReelDelay()
            if firstCycle then currentDelay = 3.5 end
            task.wait(currentDelay)
            
            -- Reel
            local ReelFinished = ReplicatedStorage:FindFirstChild("Fishing") and 
                                 ReplicatedStorage.Fishing:FindFirstChild("ToServer") and 
                                 ReplicatedStorage.Fishing.ToServer:FindFirstChild("ReelFinished")
            
            if ReelFinished then
                ReelFinished:FireServer({
                    duration = math.random(6,8) + math.random(),
                    result = "SUCCESS",
                    insideRatio = ({0.2, 0.4, 0.6, 0.8})[math.random(1,4)]
                }, uuid)
                
                standaloneReelCounter = standaloneReelCounter + 1
                
                -- Reset counter setelah 100 reel (seperti auto farm)
                if standaloneReelCounter >= MAX_REEL_NORMAL then
                    print("[Standalone] Mencapai 100 reel, reset counter...")
                    standaloneReelCounter = 0
                end
            end
            
            -- Parked OFF setelah reel (kecuali cycle pertama)
            if ParkedEvent and not firstCycle then
                firesignal(ParkedEvent.OnClientEvent, false, uuid)
            end
            
            firstCycle = false
        end)
        
        if not success then
            warn("[Standalone] Error dalam siklus fishing")
        end
        
        task.wait(0.1)
    end
    
    standaloneReelCounter = 0
    print("[Standalone] Auto Fishing dimatikan")
end

    -- =========================================================================
    -- FUNGSI AUTO SELL
    -- =========================================================================
    local function startAutoSell()
        while Settings.autosell do
            pcall(function()
                local sellRemote = ReplicatedStorage.Economy.ToServer.SellUnder
                if sellRemote then
                    sellRemote:FireServer(Settings.sellValue)
                end
            end)
            task.wait(Settings.autosellDelay)
        end
    end

    -- =========================================================================
    -- FUNGSI SETUP AUTO FARM
    -- =========================================================================
    local function setupAutoFarm()
        local character = player.Character
        if not character then 
            local timeout = 0
            repeat
                task.wait(0.5)
                character = player.Character
                timeout = timeout + 1
                if timeout > 10 then 
                    return 
                end
            until character
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        Settings.freeze = true
        
        if ZoneData[Settings.selectedZone] then
            local tempFreeze = Settings.freeze
            Settings.freeze = false
            
            teleportToZone(Settings.selectedZone, false)
            
            Settings.freeze = tempFreeze
            Settings.freezePos = root.CFrame
        end
        
        isFirstCycle = true
        cycleCounter = 0
        reelFinishedCounter = 0
        
        task.wait(1)
        autoEquipRod()
    end

    local function disableAutoFarm()
        Settings.freeze = false
        isFirstCycle = true
        cycleCounter = 0
        reelFinishedCounter = 0
    end

    -- =========================================================================
    -- FUNGSI UI LIFETIME
    -- =========================================================================
    local function createLifetimeTimer()
        local lifetimeFrame = Instance.new("Frame", pgui)
        lifetimeFrame.Name = "LifetimeFrame"
        lifetimeFrame.Size = UDim2.new(0, 220, 0, 90)
        lifetimeFrame.Position = UDim2.new(0.5, -110, 0, 20)
        lifetimeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        lifetimeFrame.BackgroundTransparency = 0.1
        lifetimeFrame.BorderSizePixel = 0
        
        local UICorner = Instance.new("UICorner", lifetimeFrame)
        UICorner.CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke", lifetimeFrame)
        stroke.Color = Color3.fromRGB(0, 170, 255)
        stroke.Thickness = 2
        stroke.Transparency = 0.2
        
        local gradient = Instance.new("UIGradient", lifetimeFrame)
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
        })
        
        local userIdLabel = Instance.new("TextLabel", lifetimeFrame)
        userIdLabel.Size = UDim2.new(1, 0, 0, 18)
        userIdLabel.Position = UDim2.new(0, 0, 0, 5)
        userIdLabel.Text = "USER ID: " .. player.UserId
        userIdLabel.Font = Enum.Font.GothamBold
        userIdLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        userIdLabel.TextSize = 11
        userIdLabel.BackgroundTransparency = 1
        
        local timeLabel = Instance.new("TextLabel", lifetimeFrame)
        timeLabel.Size = UDim2.new(1, 0, 0, 22)
        timeLabel.Position = UDim2.new(0, 0, 0, 42)
        timeLabel.Text = "00:00:00"
        timeLabel.Font = Enum.Font.GothamSemibold
        timeLabel.TextColor3 = Color3.new(1, 1, 1)
        timeLabel.TextSize = 16
        timeLabel.BackgroundTransparency = 1
        
        local statusLabel = Instance.new("TextLabel", lifetimeFrame)
        statusLabel.Size = UDim2.new(1, 0, 0, 15)
        statusLabel.Position = UDim2.new(0, 0, 0, 68)
        statusLabel.Text = "🎯 FISHING CORE: OFF"
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        statusLabel.TextSize = 10
        statusLabel.BackgroundTransparency = 1
        
        local function MakeDraggable(frame)
            local dragging, dragInput, dragStart, startPos
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; dragStart = input.Position; startPos = frame.Position
                end
            end)
            frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
        end
        MakeDraggable(lifetimeFrame)
        
        task.spawn(function()
            while lifetimeRunning do
                local elapsed = tick() - scriptStartTime
                timeLabel.Text = string.format("%02d:%02d:%02d", math.floor(elapsed/3600), math.floor((elapsed%3600)/60), math.floor(elapsed%60))
                
                local status = BlatantModule.GetStatus()
                if status.active then
                    statusLabel.Text = string.format("⚡ BLATANT: %s (%d/%d)", status.phase, status.reelCount, (status.phase == "NORMAL" and 19 or 10))
                    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif Settings.autoFarm then
                    statusLabel.Text = string.format("🎯 AUTO FARM: %d/100", reelFinishedCounter)
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif Settings.autoFishing then
                    statusLabel.Text = string.format("🎣 STANDALONE: %d", standaloneReelCounter)
                    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
                else
                    statusLabel.Text = "🎯 STATUS: READY"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                end
                
                task.wait(1)
            end
        end)
        
        return lifetimeFrame
    end

    -- =========================================================================
    -- MEMBUAT PART MARKER OCEAN ZONE
    -- =========================================================================
    task.spawn(function()
        task.wait(5)
        local markerPart = Instance.new("Part")
        markerPart.Name = "OceanZoneMarker"
        markerPart.Size = Vector3.new(30, 1, 30)
        markerPart.Position = Vector3.new(-1089, 995, -516)
        markerPart.Anchored = true
        markerPart.CanCollide = true
        markerPart.BrickColor = BrickColor.new("Bright blue")
        markerPart.Material = Enum.Material.Neon
        markerPart.Transparency = 0.3
        markerPart.Parent = workspace
        
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = markerPart
        local text = Instance.new("TextLabel", billboard)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Text = "🌊 OCEAN ZONE MARKER"
        text.TextColor3 = Color3.new(1,1,1)
        text.BackgroundTransparency = 1
        text.TextStrokeTransparency = 0
        text.TextStrokeColor3 = Color3.new(0,0,0)
        text.Font = Enum.Font.GothamBold
        text.TextSize = 14
    end)

    -- =========================================================================
    -- FUNGSI CREATE UI (LENGKAP)
    -- =========================================================================
    local function createUI()
        Window = Rayfield:CreateWindow({
            Name = "Duality Hub Premium | GETFISH",
            LoadingTitle = "Script Initializing...",
            LoadingSubtitle = "By Bimsq",
            ConfigurationSaving = {Enabled = false},
            KeySystem = false
        })

        -- Tab Misc
        local MiscTab = Window:CreateTab("Misc", nil)

        MiscTab:CreateToggle({
            Name = "⚡ Boost Ping",
            CurrentValue = Settings.boostPing,
            Callback = function(v)
                Settings.boostPing = v
                if v then
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                    game.Lighting.GlobalShadows = false
                    game.Lighting.Brightness = 0
                    game.Lighting.FogEnd = 0
                    workspace.StreamingEnabled = true
                    task.spawn(function()
                        while Settings.boostPing do
                            for _, obj in ipairs(workspace:GetDescendants()) do
                                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Sparkles") or obj:IsA("Smoke") or obj:IsA("Fire") then
                                    obj.Enabled = false
                                elseif obj:IsA("Decal") and obj.Parent:IsA("Part") then
                                    obj:Destroy()
                                end
                            end
                            task.wait(2)
                        end
                        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
                        game.Lighting.GlobalShadows = true
                        game.Lighting.Brightness = 1
                        game.Lighting.FogEnd = math.huge
                    end)
                end
            end,
        })
        
        MiscTab:CreateToggle({
    Name = "⏱️ Anti AFK (Anti Idle)",
    CurrentValue = false,
    Callback = function(v)
        toggleAntiAfk(v)
        Rayfield:Notify({
            Title = "Anti AFK",
            Content = v and "Diaktifkan - Mencegah kick karena idle" or "Dimatikan",
            Duration = 3
        })
    end,
})

        MiscTab:CreateButton({
            Name = "Load Fly GUI V3",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
            end,
        })

        -- Tab Fishing
        local FishTab = Window:CreateTab("🎣 Fishing", nil)

        FishTab:CreateLabel("⚠️ UNTUK KEAMANAN MANCING, PAKAI MINIMAL STARTER BOBBER ⚠️")

        FishTab:CreateToggle({
            Name = "🎯 Auto Farm",
            CurrentValue = Settings.autoFarm,
            Callback = function(v)
                if v and (Settings.autoFishing or Settings.blatantMode) then
                    Settings.autoFishing = false
                    Settings.blatantMode = false
                    BlatantModule.Toggle(false)
                    if standaloneFishingTask then task.cancel(standaloneFishingTask) standaloneFishingTask = nil end
                end
                Settings.autoFarm = v
                if v then 
                    ROD_CHECK_COUNTER = 0
                    rodNotFoundWarningShown = false
                    isFirstCycle = true
                    cycleCounter = 0
                    reelFinishedCounter = 0
                    setupAutoFarm()
                    autoFishingTask = task.spawn(optimizedAutoFishing)
                    Rayfield:Notify({
                        Title = "Duality Hub",
                        Content = "Auto Farm aktif!",
                        Duration = 3,
                    })
                else
                    if autoFishingTask then 
                        task.cancel(autoFishingTask) 
                        autoFishingTask = nil 
                    end
                    disableAutoFarm()
                end
            end,
        })

        FishTab:CreateToggle({
            Name = "🎣 Auto Fishing standalone",
            CurrentValue = Settings.autoFishing,
            Callback = function(v)
                if v and (Settings.autoFarm or Settings.blatantMode) then
                    Settings.autoFarm = false
                    Settings.blatantMode = false
                    BlatantModule.Toggle(false)
                    if autoFishingTask then task.cancel(autoFishingTask) autoFishingTask = nil end
                end
                Settings.autoFishing = v
                if v then 
                    isFirstStandaloneCycle = true
                    standaloneFishingTask = task.spawn(standaloneAutoFishing)
                    Rayfield:Notify({
                        Title = "Duality Hub",
                        Content = "Auto Fishing Standalone aktif!",
                        Duration = 3,
                    })
                else
                    if standaloneFishingTask then 
                        task.cancel(standaloneFishingTask) 
                        standaloneFishingTask = nil 
                    end
                end
            end,
        })

        FishTab:CreateToggle({
            Name = "⚡ Blatant Mode",
            CurrentValue = Settings.blatantMode,
            Callback = function(v)
                if v and (Settings.autoFarm or Settings.autoFishing) then
                    Settings.autoFarm = false
                    Settings.autoFishing = false
                    if autoFishingTask then task.cancel(autoFishingTask) autoFishingTask = nil end
                    if standaloneFishingTask then task.cancel(standaloneFishingTask) standaloneFishingTask = nil end
                end
                Settings.blatantMode = v
                BlatantModule.Toggle(v)
                Rayfield:Notify({
                    Title = "Blatant Mode",
                    Content = v and "Aktif - AutoFishing + BobberFire" or "Dimatikan",
                    Duration = 3
                })
            end,
        })

        FishTab:CreateDropdown({
            Name = "🎯 Fishing Mode",
            Options = {"Fast", "Legit", "Auto"},
            CurrentOption = {Settings.fishingMode},
            MultipleOptions = false,
            Callback = function(v)
                Settings.fishingMode = v[1]
                Rayfield:Notify({
                    Title = "Mode Fishing",
                    Content = "Diubah ke " .. v[1],
                    Duration = 2
                })
            end,
        })

        FishTab:CreateDropdown({
            Name = "📍 Select Fishing Zone (untuk Auto Farm & Teleport)",
            Options = {"Mira nusa", "Deep Sea 1", "Deep Sea 2", "Tropical Isle", "Mega Zone", "MAJITOS Zone", "Kinyis Isle", "Skyler Zone", "Ocean Zone"},
            CurrentOption = {Settings.selectedZone},
            MultipleOptions = false,
            Callback = function(v)
                Settings.selectedZone = v[1]
                if Settings.autoFarm then
                    local uuid = getRodUUID()
                    if uuid then
                        local RetractEvent = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
                        if RetractEvent then
                            RetractEvent:FireServer(uuid)
                        end
                    end
                    teleportToZone(v[1], false)
                    autoEquipRod()
                end
            end,
        })

        FishTab:CreateToggle({
            Name = "Active Megalodon Zone",
            CurrentValue = Settings.activeMegalodon,
            Callback = function(v)
                Settings.activeMegalodon = v
                if v then
                    pcall(function()
                        local megaZone = ReplicatedStorage:FindFirstChild("MegalodonZone")
                        if megaZone then
                            local activateEvent = megaZone:FindFirstChild("ActivateWithCF")
                            if activateEvent and activateEvent:IsA("RemoteFunction") then
                                activateEvent:InvokeServer()
                            end
                        end
                    end)
                end
            end,
        })

        local MovementSection = FishTab:CreateSection("Movement Options")

        FishTab:CreateToggle({
            Name = "👻 NoClip",
            CurrentValue = Settings.noClip,
            Callback = function(v) Settings.noClip = v end,
        })

        FishTab:CreateToggle({
            Name = "❄️ Freeze Player",
            CurrentValue = Settings.freeze,
            Callback = function(v)
                if Settings.autoFarm then return end
                Settings.freeze = v
                if v and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then 
                    Settings.freezePos = player.Character.HumanoidRootPart.CFrame 
                end
            end,
        })

        FishTab:CreateToggle({
            Name = "📍 Adjust Height (Y=995)",
            CurrentValue = Settings.adjustPosition,
            Callback = function(v)
                Settings.adjustPosition = v
            end,
        })

        FishTab:CreateToggle({
            Name = "🌊 Infinite Oxygen",
            CurrentValue = Settings.infOxygen,
            Callback = function(v) Settings.infOxygen = v end,
        })

        -- Tab Farm
        local FarmTab = Window:CreateTab("💰 Farm", nil)

        FarmTab:CreateToggle({
            Name = "💰 Auto Sell Fish",
            CurrentValue = Settings.autosell,
            Callback = function(v)
                Settings.autosell = v 
                if v then 
                    autoSellTask = task.spawn(startAutoSell) 
                else
                    if autoSellTask then task.cancel(autoSellTask) autoSellTask = nil end
                end
            end,
        })

        FarmTab:CreateSlider({
            Name = "⏱️ Auto Sell Delay",
            Range = {1.1, 300},
            Increment = 1,
            Suffix = "Seconds",
            CurrentValue = Settings.autosellDelay,
            Callback = function(v) Settings.autosellDelay = v end,
        })

        FarmTab:CreateSlider({
            Name = "💵 Sell Value",
            Range = {100, 1000},
            Increment = 50,
            Suffix = "Value",
            CurrentValue = Settings.sellValue,
            Callback = function(v) Settings.sellValue = v end,
        })

        FarmTab:CreateToggle({
            Name = "🐌 Auto Farm Worm",
            CurrentValue = Settings.autoworm,
            Callback = function(v)
                Settings.autoworm = v
                if v and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then 
                    instantTeleport(player.Character.HumanoidRootPart, Settings.wormSpot)
                end
                task.spawn(function()
                    while Settings.autoworm do
                        local character = player.Character
                        if not character or not character:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end
                        local root = character.HumanoidRootPart
                        
                        local worms = {}
                        for _, o in ipairs(workspace:GetChildren()) do
                            if o.Name:upper():find("CACING") and o:IsA("BasePart") then
                                local dist = (root.Position - o.Position).Magnitude
                                table.insert(worms, {obj = o, dist = dist})
                            end
                        end
                        
                        table.sort(worms, function(a,b) return a.dist < b.dist end)
                        
                        for _, wormData in ipairs(worms) do
                            local o = wormData.obj
                            if (root.Position - o.Position).Magnitude <= 10 then
                                local prompt = o:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then fireproximityprompt(prompt) end
                                task.wait(0.3)
                            else
                                instantTeleport(root, o.Position + Vector3.new(0,3,0))
                                task.wait(0.3)
                                local prompt = o:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then fireproximityprompt(prompt) end
                                task.wait(2)
                            end
                        end
                        task.wait(1)
                    end
                end)
            end,
        })

        -- Tab Shop
        local ShopTab = Window:CreateTab("🛒 Shop", nil)

        ShopTab:CreateDropdown({
            Name = "🧪 Select Potion",
            Options = {"SMALL_POTION", "MEDIUM_POTION", "BIG_POTION", "LARGE_POTION", "EXTREME_POTION"},
            CurrentOption = {Settings.potionSelect},
            MultipleOptions = false,
            Callback = function(v) Settings.potionSelect = v[1] end,
        })

        ShopTab:CreateSlider({
            Name = "⏱️ Potion Buy Delay",
            Range = {1, 10},
            Increment = 0.5,
            Suffix = "Seconds",
            CurrentValue = Settings.potionDelay,
            Callback = function(v) Settings.potionDelay = v end,
        })

        ShopTab:CreateToggle({
            Name = "🔁 Auto Buy Potion",
            CurrentValue = Settings.autoBuyPotion,
            Callback = function(v)
                Settings.autoBuyPotion = v 
                task.spawn(function() 
                    while Settings.autoBuyPotion do 
                        ReplicatedStorage.Potion.ToServer.PurchasePotion:FireServer(Settings.potionSelect) 
                        task.wait(Settings.potionDelay) 
                    end 
                end) 
            end,
        })

        ShopTab:CreateDropdown({
            Name = "🎨 Select Skin",
            Options = {"SKINCF_FAIRY_SPARK", "SKINCF_SAMURAI_LIGHTNING", "SKINCF_VERINOS", "SKINCF_BLUE_DRAGON", "SKINCF_COSMIC_EYE", "SKINCF_AQUA_HALO", "SKINCF_SKY_RELIC"},
            CurrentOption = {Settings.skinSelect},
            MultipleOptions = false,
            Callback = function(v) Settings.skinSelect = v[1] end,
        })

        ShopTab:CreateToggle({
            Name = "🔁 Auto Buy Skin",
            CurrentValue = Settings.autoBuySkin,
            Callback = function(v)
                Settings.autoBuySkin = v 
                task.spawn(function() 
                    while Settings.autoBuySkin do 
                        ReplicatedStorage.RodSkin.ToServer.PurchaseSkinCF:FireServer(Settings.skinSelect) 
                        task.wait(3) 
                    end 
                end) 
            end,
        })

        ShopTab:CreateDropdown({
            Name = "🎣 Select Rod",
            Options = {"PINKYS", "SAMURAI", "VERINOS", "DESTROYER", "GALAXY", "ENTROPY", "LEGEND"},
            CurrentOption = {Settings.rodSelect},
            MultipleOptions = false,
            Callback = function(v) Settings.rodSelect = v[1] end,
        })

        ShopTab:CreateToggle({
            Name = "🔁 Auto Buy Rod",
            CurrentValue = Settings.autoBuyRod,
            Callback = function(v)
                Settings.autoBuyRod = v 
                task.spawn(function() 
                    while Settings.autoBuyRod do 
                        ReplicatedStorage.RodShop.ToServer.PurchaseRod:FireServer(Settings.rodSelect) 
                        task.wait(3) 
                    end 
                end) 
            end,
        })

        ShopTab:CreateDropdown({
            Name = "🌐 Select Bobber",
            Options = {"BOBBER_ROYAL", "BOBBER_STARTER", "BOBBER_LIGHT", "BOBBER_PLASMA", "BOBBER_LUNAR", "BOBBER_VORTEX"},
            CurrentOption = {Settings.bobberSelect},
            MultipleOptions = false,
            Callback = function(v) Settings.bobberSelect = v[1] end,
        })

        ShopTab:CreateToggle({
            Name = "🔁 Auto Buy Bobber",
            CurrentValue = Settings.autoBuyBobber,
            Callback = function(v)
                Settings.autoBuyBobber = v 
                task.spawn(function() 
                    while Settings.autoBuyBobber do 
                        ReplicatedStorage.BobberShop.ToServer.BuyBobber:FireServer(Settings.bobberSelect) 
                        task.wait(3) 
                    end 
                end) 
            end,
        })

        -- Tab Teleport
        local TeleTab = Window:CreateTab("📍 Teleport", nil)

        TeleTab:CreateSection("🌊 Zona Fishing")

        local teleportZones = {"Mira nusa", "Deep Sea 1", "Deep Sea 2", "Tropical Isle", "Mega Zone", "MAJITOS Zone", "Kinyis Isle", "Skyler Zone", "Ocean Zone"}

        for _, zoneName in ipairs(teleportZones) do
            TeleTab:CreateButton({
                Name = "📍 Teleport to " .. zoneName,
                Callback = function()
                    local wasAutoFarm = Settings.autoFarm
                    if wasAutoFarm then
                        Settings.autoFarm = false
                        if autoFishingTask then 
                            task.cancel(autoFishingTask) 
                            autoFishingTask = nil 
                        end
                    end
                    
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local uuid = getRodUUID()
                        if uuid then
                            local RetractEvent = ReplicatedStorage:FindFirstChild("Fishing_RemoteRetract")
                            if RetractEvent then
                                pcall(function() RetractEvent:FireServer(uuid) end)
                            end
                        end
                        
                        teleportToZone(zoneName, true)
                        
                        task.wait(2.9)
                        autoEquipRod()
                        
                        Rayfield:Notify({
                            Title = "Teleport",
                            Content = "Berhasil teleport ke " .. zoneName,
                            Duration = 3
                        })
                    else
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "Karakter tidak ditemukan",
                            Duration = 3
                        })
                    end
                    
                    if wasAutoFarm then
                        task.wait(1)
                        Settings.autoFarm = true
                        setupAutoFarm()
                        autoFishingTask = task.spawn(optimizedAutoFishing)
                    end
                end,
            })
        end

        TeleTab:CreateSection("📍 Lokasi Khusus")

        TeleTab:CreateButton({
            Name = "🪱 Teleport to Worm Spot",
            Callback = function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    root.CFrame = CFrame.new(Settings.wormSpot)
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Berhasil teleport ke Worm Spot",
                        Duration = 3
                    })
                end
            end,
        })

        -- Tab Stones
        local StoneTab = Window:CreateTab("💎 Stones", nil)

        local stones = {
            {"Stone 1", Vector3.new(-195.7, 977.6, 1335.2)}, 
            {"Stone 2", Vector3.new(1370.1, 977.6, -794.4)}, 
            {"Stone 3", Vector3.new(-2547.4, 977.6, 363.6)}, 
            {"Stone 4", Vector3.new(-1699.2, 977.6, 876.3)}, 
            {"Stone 5", Vector3.new(-1032.4, 986.2, 280.5)}, 
            {"Stone 6", Vector3.new(-1636.3, 977.6, -716.7)}, 
            {"Stone 7", Vector3.new(-540.5, 977.6, -809.8)}, 
            {"Stone 8", Vector3.new(928.4, 985.7, 372.2)}
        }

        for _, s in ipairs(stones) do
            StoneTab:CreateButton({
                Name = "💎 Teleport to " .. s[1],
                Callback = function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then 
                        local character = player.Character
                        applyNoClip(character, false)
                        task.wait(0.8)
                        
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(s[2])
                        
                        task.wait(0.1)
                        
                        applyNoClip(character, true)
                        
                        autoEquipRod()
                    end 
                end,
            })
        end
    end

    -- =========================================================================
    -- LOOP UTAMA
    -- =========================================================================
    RunService.Stepped:Connect(function()
        if player.Character then
            applyNoClip(player.Character, Settings.noClip)
        end
    end)

    RunService.Heartbeat:Connect(function()
        if Settings.autoFarm and Settings.freeze and Settings.freezePos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            root.CFrame = Settings.freezePos
            root.Velocity = Vector3.new(0,0,0)
            root.AssemblyLinearVelocity = Vector3.new(0,0,0)
            root.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
        
        if not Settings.autoFarm and Settings.freeze and Settings.freezePos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            root.CFrame = Settings.freezePos
            root.Velocity = Vector3.new(0,0,0)
            root.AssemblyLinearVelocity = Vector3.new(0,0,0)
            root.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
        
        if Settings.infOxygen then
            local oxyScript = player.PlayerScripts:FindFirstChild("OxygenSystem.client")
            if oxyScript then oxyScript.Disabled = true end
            if Lighting:FindFirstChild("UnderwaterBlur") then Lighting.UnderwaterBlur:Destroy() end
        end
    end)

    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        applyNoClip(character, Settings.noClip)
        if Settings.autoFarm then 
            task.wait(1)
            setupAutoFarm() 
        end
    end)

    enableNoClipAndInfOxygenOnStart()

    if Workspace:FindFirstChild("TempleIsle") and Workspace.TempleIsle:FindFirstChild("TempleRoom") then
        Workspace.TempleIsle.TempleRoom:Destroy()
    end

    createUI()
    createLifetimeTimer()
end

-- =============================================================================
-- [4] UI BUTTON HANDLERS (KEY SYSTEM)
-- =============================================================================

GetKeyBtn.MouseButton1Click:Connect(function()
    local url = GetKeyURL()
    if setclipboard then
        setclipboard(url)
        Title.Text = "URL COPIED!"
        task.wait(2)
        Title.Text = "DUALITY HUB - KEY SYSTEM"
    else
        Title.Text = "LINK: " .. url
    end
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key == "" then return end
    
    VerifyBtn.Text = "VERIFYING..."
    local res = ValidateKey(key)
    
    if res.success then
        VerifyBtn.Text = "SUCCESS!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.wait(1)
        StartDualityHub()
    else
        VerifyBtn.Text = "INVALID KEY"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        task.wait(2)
        VerifyBtn.Text = "VERIFY"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)
