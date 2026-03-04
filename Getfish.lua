-- ================================================
--   Getfish | Sdeer Fishing Auto Script
--   Game: Sdeer Fishing Games
--   Features: Blatant Auto Fish, Bobber Fire, Utilities
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Getfish | Sdeer Auto Fish",
    LoadingTitle = "Getfish",
    LoadingSubtitle = "Sdeer Fishing Script",
    Theme = "Dark",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Getfish",
        FileName = "Getfish_Config"
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
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ================================================
--   Remote Helpers
-- ================================================

local function FindRemote(name)
    -- Search common locations
    local locations = {
        ReplicatedStorage,
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("Events"),
        ReplicatedStorage:FindFirstChild("RemoteEvents"),
        ReplicatedStorage:FindFirstChild("RF"),
        ReplicatedStorage:FindFirstChild("RE"),
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

-- ================================================
--   State Variables
-- ================================================

local BlatantActive = false
local BlatantThread = nil
local BobberFireActive = false
local BobberFireThread = nil

local SpeedHacking = false
local OriginalSpeed = 16
local HackSpeed = 50
local NoclipActive = false
local NoclipConn = nil
local InfJumpActive = false
local InfJumpConn = nil
local AntiAFKActive = false
local AntiAFKConn = nil

local FishCaughtCount = 0

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

local function SetSpeed(speed)
    local hum = GetHumanoid()
    if hum then hum.WalkSpeed = speed end
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
    InfJumpConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Space then
            local hum = GetHumanoid()
            if hum then hum.Jump = true end
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

local function StartAntiAFK()
    if AntiAFKConn then return end
    AntiAFKActive = true
    AntiAFKConn = RunService.Heartbeat:Connect(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Unknown, false, nil)
    end)
end

local function StopAntiAFK()
    if AntiAFKConn then
        AntiAFKConn:Disconnect()
        AntiAFKConn = nil
    end
    AntiAFKActive = false
end

-- ================================================
--   Blatant Auto Fish Logic
--   Sequence: RemoteAutofishing -> throw -> ReelFinished -> Reel -> stop -> repeat
--   Parallel: BobberFire every 0.01s
-- ================================================

local function RunBlatantLoop()
    while BlatantActive do
        pcall(function()
            -- Step 1: Fire RemoteAutofishing (start auto fishing)
            local remoteAutoFishing = FindRemote("RemoteAutofishing")
                or FindRemote("AutoFishing")
                or FindRemote("StartFishing")
            if remoteAutoFishing then
                if remoteAutoFishing:IsA("RemoteEvent") then
                    remoteAutoFishing:FireServer()
                elseif remoteAutoFishing:IsA("RemoteFunction") then
                    remoteAutoFishing:InvokeServer()
                end
            end
            task.wait(0.1)

            -- Step 2: Fire throw (cast the rod)
            local throwRemote = FindRemote("throw")
                or FindRemote("Throw")
                or FindRemote("CastRod")
                or FindRemote("Cast")
            if throwRemote then
                if throwRemote:IsA("RemoteEvent") then
                    throwRemote:FireServer()
                elseif throwRemote:IsA("RemoteFunction") then
                    throwRemote:InvokeServer()
                end
            end
            task.wait(0.2)

            -- Step 3: Fire ReelFinished (signal reel is done)
            local reelFinishedRemote = FindRemote("ReelFinished")
                or FindRemote("reelfinished")
                or FindRemote("FinishReel")
            if reelFinishedRemote then
                if reelFinishedRemote:IsA("RemoteEvent") then
                    reelFinishedRemote:FireServer()
                elseif reelFinishedRemote:IsA("RemoteFunction") then
                    reelFinishedRemote:InvokeServer()
                end
            end
            task.wait(0.1)

            -- Step 4: Fire Reel (reel in the fish)
            local reelRemote = FindRemote("Reel")
                or FindRemote("reel")
                or FindRemote("ReelFish")
                or FindRemote("PullFish")
            if reelRemote then
                if reelRemote:IsA("RemoteEvent") then
                    reelRemote:FireServer()
                elseif reelRemote:IsA("RemoteFunction") then
                    reelRemote:InvokeServer()
                end
            end
            task.wait(0.1)

            -- Step 5: Stop auto fishing (reset state)
            local stopRemote = FindRemote("StopFishing")
                or FindRemote("StopAutoFishing")
                or FindRemote("CancelFishing")
            if stopRemote then
                if stopRemote:IsA("RemoteEvent") then
                    stopRemote:FireServer()
                elseif stopRemote:IsA("RemoteFunction") then
                    stopRemote:InvokeServer()
                end
            end
            task.wait(0.05)

            FishCaughtCount = FishCaughtCount + 1
        end)

        task.wait(0.05) -- small gap before repeating
    end
end

local function RunBobberFireLoop()
    while BobberFireActive do
        pcall(function()
            local bobberRemote = FindRemote("BobberFire")
                or FindRemote("bobberfire")
                or FindRemote("Bobber")
                or FindRemote("BobberEvent")
            if bobberRemote then
                if bobberRemote:IsA("RemoteEvent") then
                    bobberRemote:FireServer()
                elseif bobberRemote:IsA("RemoteFunction") then
                    bobberRemote:InvokeServer()
                end
            end
        end)
        task.wait(0.01)
    end
end

local function StartBlatant()
    if BlatantActive then return end
    BlatantActive = true
    BobberFireActive = true

    -- Run blatant fishing loop in background
    BlatantThread = task.spawn(RunBlatantLoop)

    -- Run bobber fire loop in parallel background
    BobberFireThread = task.spawn(RunBobberFireLoop)
end

local function StopBlatant()
    BlatantActive = false
    BobberFireActive = false
    BlatantThread = nil
    BobberFireThread = nil
end

-- ================================================
--   UI Tabs
-- ================================================

-- ---- Tab 1: Auto Fish (Blatant) ----
local FishTab = Window:CreateTab("🎣 Auto Fish", "anchor")

FishTab:CreateSection("Blatant Mode")

FishTab:CreateToggle({
    Name = "Blatant Auto Fish",
    CurrentValue = false,
    Flag = "BlatantFish",
    Callback = function(val)
        if val then
            StartBlatant()
            Rayfield:Notify({
                Title = "Blatant Fish",
                Content = "Auto fishing + BobberFire aktif!",
                Duration = 2,
            })
        else
            StopBlatant()
            Rayfield:Notify({
                Title = "Blatant Fish",
                Content = "Auto fishing dimatikan.",
                Duration = 2,
            })
        end
    end
})

FishTab:CreateLabel("Sequence: AutoFishing → Throw → ReelFinished → Reel → Stop → Repeat")
FishTab:CreateLabel("Parallel: BobberFire setiap 0.01s")

FishTab:CreateDivider()

FishTab:CreateLabel("Ikan tertangkap: 0")

FishTab:CreateButton({
    Name = "Reset Counter",
    Callback = function()
        FishCaughtCount = 0
        Rayfield:Notify({Title = "Reset", Content = "Counter direset!", Duration = 2})
    end
})

-- ---- Tab 2: Teleport ----
local TpTab = Window:CreateTab("🚀 Teleport", "map-pin")

local FishingSpots = {
    {Name = "Pantai Utara", Position = Vector3.new(100, 10, 200)},
    {Name = "Pantai Selatan", Position = Vector3.new(-150, 10, -100)},
    {Name = "Danau Utama", Position = Vector3.new(50, 15, 50)},
    {Name = "Sungai Besar", Position = Vector3.new(-200, 10, 150)},
    {Name = "Pelabuhan", Position = Vector3.new(300, 10, -50)},
    {Name = "Pulau Terpencil", Position = Vector3.new(-400, 10, -300)},
}

TpTab:CreateSection("Fishing Spots")

for _, spot in ipairs(FishingSpots) do
    TpTab:CreateButton({
        Name = spot.Name,
        Callback = function()
            local hrp = GetHRP()
            if hrp then
                hrp.CFrame = CFrame.new(spot.Position)
                Rayfield:Notify({Title = "Teleport", Content = "Teleport ke " .. spot.Name, Duration = 2})
            end
        end
    })
end

-- ---- Tab 3: Utilities ----
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
        if SpeedHacking then SetSpeed(val) end
    end
})

UtilTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(val)
        if val then StartNoclip() else StopNoclip() end
    end
})

UtilTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(val)
        if val then StartInfJump() else StopInfJump() end
    end
})

UtilTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(val)
        if val then StartAntiAFK() else StopAntiAFK() end
    end
})

-- ================================================
--   Initialize
-- ================================================

Rayfield:Notify({
    Title = "Getfish",
    Content = "Script loaded! Sdeer Fishing Hub siap.",
    Duration = 3,
})

print("Getfish | Sdeer Auto Fish loaded!")
