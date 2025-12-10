--[[
    XIAN SCRIPT v6.0 - PURE FISHING EDITION
    
    Status: PRIVATE (Locked to Lifan_xian)
    
    Update v6.0:
    - CLEANUP: Menghapus fitur Money, Free Shop, Custom Name (Sesuai Request).
    - UI FIX: Memperbaiki tampilan Fly Speed agar tidak menumpuk.
    - NEW FEATURES: Menambahkan fitur utilitas khusus map mancing.
    
    Fitur:
    1. Auto Fish / Smart Clicker (P)
    2. Walk on Water / Jesus Mode (J) - Jalan di air
    3. Full Bright (B) - Terang di malam/gua
    4. Infinite Oxygen - Anti tenggelam
    5. Fly Mode (F) - Dengan UI Speed yang rapi
    6. Teleport Manager (N)
    7. Coord Tracker (M)
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- [KEAMANAN] Lock User
if player.Name ~= "tokorootsec_bot" then
    warn("Script ini khusus untuk tokorootsec_bot!")
    script:Destroy()
    return
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager") 
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService") 

print("Xian Fishing Script v6.0 Loaded")

-- Global Variables
local currentFlySpeed = 50 

-- ============================================================================
-- 1. SYSTEM SAVE & LOAD
-- ============================================================================
local TELEPORT_FILE = "XianTeleports.json"
local savedLocations = {}

local function LoadLocations()
    if isfile and isfile(TELEPORT_FILE) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(TELEPORT_FILE))
        end)
        if success then savedLocations = result end
    else
        savedLocations = {{name = "Safe Zone", x = 0, y = 50, z = 0}}
    end
end

local function SaveLocations()
    if writefile then
        pcall(function()
            writefile(TELEPORT_FILE, HttpService:JSONEncode(savedLocations))
        end)
    end
end

LoadLocations()

-- ============================================================================
-- 2. KONFIGURASI TEMA UI
-- ============================================================================
local THEME = {
    Background = Color3.fromRGB(10, 15, 25), -- Deep Ocean Blue
    Sidebar = Color3.fromRGB(20, 25, 35),
    Header = Color3.fromRGB(0, 150, 255), -- Cyan Blue
    Accent = Color3.fromRGB(0, 255, 255), -- Neon Cyan
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 160),
    BtnOff = Color3.fromRGB(30, 40, 50),
    BtnOn = Color3.fromRGB(0, 200, 150), 
    Danger = Color3.fromRGB(255, 80, 80),
    Input = Color3.fromRGB(40, 50, 70)
}

-- ============================================================================
-- 3. DATA FITUR
-- ============================================================================
local features = {
    {
        id = "auto_fish",
        name = "Auto Fish (Smart Clicker)",
        icon = "🎣",
        desc = "Otomatis Cast & Reel (Perfect). Mendeteksi bar/klik.",
        keybind = Enum.KeyCode.P,
        enabled = false
    },
    {
        id = "walk_water",
        name = "Walk on Water",
        icon = "🌊",
        desc = "Berjalan di atas permukaan air (Jesus Mode).",
        keybind = Enum.KeyCode.J,
        enabled = false
    },
    {
        id = "full_bright",
        name = "Full Bright & No Fog",
        icon = "💡",
        desc = "Membuat map terang benderang & menghapus kabut.",
        keybind = Enum.KeyCode.B,
        enabled = false
    },
    {
        id = "fly_mode",
        name = "Fly Mode", 
        icon = "🕊️",
        desc = "Terbang menembus dinding. Atur kecepatan di panel.",
        keybind = Enum.KeyCode.F,
        enabled = false
    },
    {
        id = "teleport_hub",
        name = "Teleport Manager",
        icon = "🚀",
        desc = "Simpan lokasi mancing favoritmu.",
        keybind = Enum.KeyCode.N,
        enabled = false
    },
    {
        id = "coord_tracker",
        name = "Coordinate Tracker",
        icon = "📍",
        desc = "Melihat koordinat X, Y, Z.",
        keybind = Enum.KeyCode.M,
        enabled = false
    }
}

local currentSelectedId = features[1].id
local isBinding = false

-- ============================================================================
-- 4. MEMBUAT UI
-- ============================================================================

for _, v in pairs(player:WaitForChild("PlayerGui"):GetChildren()) do
    if v.Name == "XianFishingGUI" then v:Destroy() end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XianFishingGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
toggleBtn.BackgroundColor3 = THEME.Background
toggleBtn.Text = "🐟" 
toggleBtn.TextSize = 25
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", toggleBtn).Color = THEME.Accent; 

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 350)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
mainFrame.BackgroundColor3 = THEME.Background
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Visible = true 
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Color = THEME.Accent; 

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.BackgroundColor3 = THEME.Sidebar
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", sidebar)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XIAN FISHING"
titleLabel.TextColor3 = THEME.Accent
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18

local listContainer = Instance.new("ScrollingFrame", sidebar)
listContainer.Size = UDim2.new(1, 0, 1, -50)
listContainer.Position = UDim2.new(0, 0, 0, 50)
listContainer.BackgroundTransparency = 1
listContainer.ScrollBarThickness = 2
local listLayout = Instance.new("UIListLayout", listContainer)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

local detailFrame = Instance.new("Frame", mainFrame)
detailFrame.Size = UDim2.new(1, -180, 1, 0)
detailFrame.Position = UDim2.new(0, 180, 0, 0)
detailFrame.BackgroundTransparency = 1

local dTitle = Instance.new("TextLabel", detailFrame)
dTitle.Size = UDim2.new(1, -40, 0, 40)
dTitle.Position = UDim2.new(0, 20, 0, 20)
dTitle.BackgroundTransparency = 1
dTitle.TextColor3 = THEME.Text
dTitle.Font = Enum.Font.GothamBold
dTitle.TextSize = 22
dTitle.TextXAlignment = Enum.TextXAlignment.Left

local dDesc = Instance.new("TextLabel", detailFrame)
dDesc.Size = UDim2.new(1, -40, 0, 60)
dDesc.Position = UDim2.new(0, 20, 0, 60)
dDesc.BackgroundTransparency = 1
dDesc.TextColor3 = THEME.TextDim
dDesc.Font = Enum.Font.Gotham
dDesc.TextSize = 14
dDesc.TextXAlignment = Enum.TextXAlignment.Left
dDesc.TextYAlignment = Enum.TextYAlignment.Top
dDesc.TextWrapped = true

-- [BAGIAN STANDAR]
local keyLabel = Instance.new("TextLabel", detailFrame)
keyLabel.Text = "Trigger Key:"
keyLabel.Size = UDim2.new(0, 100, 0, 30)
keyLabel.Position = UDim2.new(0, 20, 0, 130)
keyLabel.BackgroundTransparency = 1
keyLabel.TextColor3 = THEME.Text
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextXAlignment = Enum.TextXAlignment.Left

local keyBtn = Instance.new("TextButton", detailFrame)
keyBtn.Size = UDim2.new(0, 120, 0, 35)
keyBtn.Position = UDim2.new(0, 20, 0, 160)
keyBtn.BackgroundColor3 = THEME.BtnOff
keyBtn.TextColor3 = THEME.Accent
keyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

local toggleBigBtn = Instance.new("TextButton", detailFrame)
toggleBigBtn.Size = UDim2.new(1, -40, 0, 50)
toggleBigBtn.Position = UDim2.new(0, 20, 1, -70) -- Posisi Default (Bawah)
toggleBigBtn.BackgroundColor3 = THEME.BtnOff
toggleBigBtn.Font = Enum.Font.GothamBold
toggleBigBtn.TextSize = 18
Instance.new("UICorner", toggleBigBtn).CornerRadius = UDim.new(0, 8)

-- [BAGIAN TELEPORT MANAGER]
local tpFrame = Instance.new("Frame", detailFrame)
tpFrame.Size = UDim2.new(1, -40, 0, 200)
tpFrame.Position = UDim2.new(0, 20, 0, 130)
tpFrame.BackgroundTransparency = 1
tpFrame.Visible = false

local inputName = Instance.new("TextBox", tpFrame)
inputName.Size = UDim2.new(0.6, 0, 0, 30)
inputName.PlaceholderText = "Nama Lokasi..."
inputName.Text = ""
inputName.BackgroundColor3 = THEME.Input
inputName.TextColor3 = Color3.new(1,1,1)
inputName.Font = Enum.Font.Gotham
Instance.new("UICorner", inputName).CornerRadius = UDim.new(0, 6)

local inputX = Instance.new("TextBox", tpFrame)
inputX.Size = UDim2.new(0.2, -5, 0, 30)
inputX.Position = UDim2.new(0, 0, 0, 35)
inputX.PlaceholderText = "X"
inputX.BackgroundColor3 = THEME.Input
inputX.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", inputX).CornerRadius = UDim.new(0, 6)

local inputY = Instance.new("TextBox", tpFrame)
inputY.Size = UDim2.new(0.2, -5, 0, 30)
inputY.Position = UDim2.new(0.2, 0, 0, 35)
inputY.PlaceholderText = "Y"
inputY.BackgroundColor3 = THEME.Input
inputY.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", inputY).CornerRadius = UDim.new(0, 6)

local inputZ = Instance.new("TextBox", tpFrame)
inputZ.Size = UDim2.new(0.2, -5, 0, 30)
inputZ.Position = UDim2.new(0.4, 0, 0, 35)
inputZ.PlaceholderText = "Z"
inputZ.BackgroundColor3 = THEME.Input
inputZ.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", inputZ).CornerRadius = UDim.new(0, 6)

local getPosBtn = Instance.new("TextButton", tpFrame)
getPosBtn.Size = UDim2.new(0.35, 0, 0, 30)
getPosBtn.Position = UDim2.new(0.65, 0, 0, 35)
getPosBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
getPosBtn.Text = "Get Pos"
getPosBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", getPosBtn).CornerRadius = UDim.new(0, 6)

local addTpBtn = Instance.new("TextButton", tpFrame)
addTpBtn.Size = UDim2.new(0.35, 0, 0, 30)
addTpBtn.Position = UDim2.new(0.65, 0, 0, 0)
addTpBtn.BackgroundColor3 = THEME.BtnOn
addTpBtn.Text = "ADD"
addTpBtn.TextColor3 = Color3.new(0,0,0)
addTpBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", addTpBtn).CornerRadius = UDim.new(0, 6)

local tpListScroll = Instance.new("ScrollingFrame", tpFrame)
tpListScroll.Size = UDim2.new(1, 0, 0, 120)
tpListScroll.Position = UDim2.new(0, 0, 0, 75)
tpListScroll.BackgroundTransparency = 1
tpListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tpListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y 
tpListScroll.ScrollBarThickness = 6
local tpGridLayout = Instance.new("UIGridLayout", tpListScroll)
tpGridLayout.CellSize = UDim2.new(1, -10, 0, 30) 
tpGridLayout.CellPadding = UDim2.new(0, 0, 0, 5)

-- [BAGIAN FLY SETTINGS - PERBAIKAN UI]
local flyFrame = Instance.new("Frame", detailFrame)
flyFrame.Size = UDim2.new(1, -40, 0, 80)
flyFrame.Position = UDim2.new(0, 20, 0, 200) -- Geser ke bawah agar tidak tumpang tindih
flyFrame.BackgroundTransparency = 1
flyFrame.Visible = false

local speedLabel = Instance.new("TextLabel", flyFrame)
speedLabel.Text = "Flight Speed:"
speedLabel.Size = UDim2.new(0.4, 0, 0, 30)
speedLabel.TextColor3 = THEME.Text
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", flyFrame)
speedInput.Size = UDim2.new(0.5, 0, 0, 30)
speedInput.Position = UDim2.new(0.45, 0, 0, 0)
speedInput.Text = "50" 
speedInput.BackgroundColor3 = THEME.Input
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.Gotham
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)

speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then currentFlySpeed = num else speedInput.Text = tostring(currentFlySpeed) end
end)

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = THEME.TextDim
closeBtn.Font = Enum.Font.GothamBold

-- ============================================================================
-- 5. UI LOGIC
-- ============================================================================

local function refreshTeleportList()
    for _, v in pairs(tpListScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for i, loc in ipairs(savedLocations) do
        local row = Instance.new("Frame", tpListScroll)
        row.BackgroundColor3 = THEME.BtnOff
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
        
        local tpBtn = Instance.new("TextButton", row)
        tpBtn.Size = UDim2.new(0.8, 0, 1, 0)
        tpBtn.BackgroundTransparency = 1
        tpBtn.Text = "  " .. loc.name
        tpBtn.TextColor3 = Color3.new(1,1,1)
        tpBtn.TextXAlignment = Enum.TextXAlignment.Left
        tpBtn.Font = Enum.Font.GothamSemibold
        tpBtn.TextSize = 12
        
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0.2, 0, 1, 0)
        delBtn.Position = UDim2.new(0.8, 0, 0, 0)
        delBtn.BackgroundTransparency = 1
        delBtn.Text = "X"
        delBtn.TextColor3 = THEME.Danger
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        
        tpBtn.MouseButton1Click:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y, loc.z)
            end
        end)
        
        delBtn.MouseButton1Click:Connect(function()
            table.remove(savedLocations, i)
            SaveLocations()
            refreshTeleportList() 
        end)
    end
end

getPosBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos = char.HumanoidRootPart.Position
        inputX.Text = tostring(math.floor(pos.X))
        inputY.Text = tostring(math.floor(pos.Y))
        inputZ.Text = tostring(math.floor(pos.Z))
    end
end)

addTpBtn.MouseButton1Click:Connect(function()
    local name = inputName.Text
    local x = tonumber(inputX.Text)
    local y = tonumber(inputY.Text)
    local z = tonumber(inputZ.Text)
    if name ~= "" and x and y and z then
        table.insert(savedLocations, {name = name, x = x, y = y, z = z})
        SaveLocations()
        refreshTeleportList()
        inputName.Text = "" 
    end
end)

-- ============================================================================
-- 6. UI CONTROLLER UTAMA
-- ============================================================================
local featureButtons = {}

local function getFeatureData(id)
    for _, f in ipairs(features) do if f.id == id then return f end end
    return nil
end

local function getKeyName(keyCode)
    local name = keyCode.Name
    name = name:gsub("Button", "")
    return name
end

local function updateDetailPanel()
    local data = getFeatureData(currentSelectedId)
    if not data then return end
    
    dTitle.Text = data.icon .. "  " .. data.name
    dDesc.Text = data.desc
    
    -- Reset UI
    tpFrame.Visible = false
    flyFrame.Visible = false
    keyLabel.Visible = true
    keyBtn.Visible = true
    toggleBigBtn.Visible = true
    toggleBigBtn.Position = UDim2.new(0, 20, 1, -70) -- Posisi normal

    if data.id == "teleport_hub" then
        keyLabel.Visible = false
        keyBtn.Visible = false
        toggleBigBtn.Visible = false
        tpFrame.Visible = true
        refreshTeleportList()
    elseif data.id == "fly_mode" then
        -- Fly UI Adjustment: Geser tombol toggle ke atas agar tidak numpuk
        toggleBigBtn.Position = UDim2.new(0, 20, 0, 160) 
        flyFrame.Visible = true
    else
        keyBtn.Text = "[ " .. getKeyName(data.keybind) .. " ]"
    end
    
    if data.enabled then
        toggleBigBtn.Text = "ENABLED"
        toggleBigBtn.BackgroundColor3 = THEME.BtnOn
        toggleBigBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        toggleBigBtn.Text = "DISABLED"
        toggleBigBtn.BackgroundColor3 = THEME.BtnOff
        toggleBigBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    
    for id, btn in pairs(featureButtons) do
        if id == currentSelectedId then
            btn.BackgroundTransparency = 0.8; btn.BackgroundColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundTransparency = 1
        end
    end
end

local function toggleFeature(id)
    local data = getFeatureData(id)
    if not data then return end
    
    if id ~= "teleport_hub" then
        data.enabled = not data.enabled
    end
    
    if currentSelectedId == id then updateDetailPanel() end
    
    if featureButtons[id] then
        featureButtons[id].TextColor3 = data.enabled and THEME.Accent or THEME.TextDim
    end
    
    if id == "coord_tracker" then logic_CoordTracker(data.enabled)
    elseif id == "auto_fish" then logic_AutoFish(data.enabled)
    elseif id == "walk_water" then logic_WalkWater(data.enabled)
    elseif id == "full_bright" then logic_FullBright(data.enabled)
    elseif id == "fly_mode" then logic_Fly(data.enabled)
    end
end

for i, feat in ipairs(features) do
    local btn = Instance.new("TextButton")
    btn.Name = feat.id
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = THEME.Sidebar
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. feat.name
    btn.TextColor3 = THEME.TextDim
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = i
    btn.Parent = listContainer
    
    featureButtons[feat.id] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentSelectedId = feat.id
        updateDetailPanel()
    end)
end

updateDetailPanel()

keyBtn.MouseButton1Click:Connect(function()
    if isBinding then return end
    isBinding = true; keyBtn.Text = "..."; keyBtn.TextColor3 = THEME.Danger
end)

UserInputService.InputBegan:Connect(function(input, gp)
    local isKeyboard = input.UserInputType == Enum.UserInputType.Keyboard
    
    if isBinding then
        if isKeyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            local d = getFeatureData(currentSelectedId)
            if d then 
                d.keybind = input.KeyCode
                isBinding = false
                keyBtn.TextColor3 = THEME.Accent
                updateDetailPanel() 
            end
        end
    elseif not gp then
        if isKeyboard then
            for _, f in ipairs(features) do 
                if input.KeyCode == f.keybind then toggleFeature(f.id) end 
            end
            if input.KeyCode == Enum.KeyCode.RightControl then
                mainFrame.Visible = not mainFrame.Visible
            end
        end
    end
end)

toggleBigBtn.MouseButton1Click:Connect(function() toggleFeature(currentSelectedId) end)
toggleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- ============================================================================
-- 7. LOGIKA FITUR (BACKEND)
-- ============================================================================

-- [0] COORDINATE TRACKER
local coordLabel = nil
function logic_CoordTracker(state)
    if coordLabel then coordLabel:Destroy() coordLabel = nil end
    if state then
        local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        gui.Name = "XianCoordTracker"
        coordLabel = Instance.new("TextLabel", gui)
        coordLabel.Size = UDim2.new(0, 300, 0, 40)
        coordLabel.Position = UDim2.new(0.5, -150, 0, 10)
        coordLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        coordLabel.BackgroundTransparency = 0.5
        coordLabel.TextColor3 = THEME.Accent
        coordLabel.Font = Enum.Font.Code
        coordLabel.TextSize = 18
        Instance.new("UICorner", coordLabel).CornerRadius = UDim.new(0, 8)
        
        task.spawn(function()
            while features[6].enabled and coordLabel do -- Index 6
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local pos = char.HumanoidRootPart.Position
                    local txt = string.format("X: %d, Y: %d, Z: %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
                    coordLabel.Text = txt
                end
                task.wait(0.1)
            end
            if coordLabel then coordLabel:Destroy() end
            if gui then gui:Destroy() end
        end)
    end
end

-- [1] AUTO FISH (SMART CLICKER)
function logic_AutoFish(state)
    if state then
        task.spawn(function()
            while features[1].enabled do 
                RunService.Heartbeat:Wait() 
                local pGui = player:WaitForChild("PlayerGui")
                local minigameFound = false
                
                for _, gui in pairs(pGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui.Enabled then
                        if gui.Name:lower():find("reel") or gui.Name:lower():find("click") or gui.Name:lower():find("shake") then
                            minigameFound = true
                            break
                        end
                        for _, obj in pairs(gui:GetDescendants()) do
                            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and (obj.Text:lower():find("click") or obj.Text:lower():find("fast")) then
                                minigameFound = true
                                break
                            end
                        end
                        if minigameFound then break end
                    end
                end
                
                if minigameFound then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    RunService.Heartbeat:Wait()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                else
                    local char = player.Character
                    if char then
                        local rod = char:FindFirstChildOfClass("Tool")
                        if rod then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.1)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            task.wait(1.5) 
                        end
                    end
                end
            end
        end)
    end
end

-- [2] WALK ON WATER
local waterPlatform = nil
function logic_WalkWater(state)
    if waterPlatform then waterPlatform:Destroy() waterPlatform = nil end
    if state then
        -- Buat platform transparan di level air (Y=0 biasanya)
        waterPlatform = Instance.new("Part", workspace)
        waterPlatform.Name = "JesusPlate"
        waterPlatform.Anchored = true
        waterPlatform.CanCollide = true
        waterPlatform.Transparency = 1
        waterPlatform.Size = Vector3.new(10000, 1, 10000)
        waterPlatform.Position = Vector3.new(0, -0.5, 0) -- Tepat di bawah permukaan air
    end
end

-- [3] FULL BRIGHT
local oldAmbient, oldOutdoor, oldClock
function logic_FullBright(state)
    if state then
        oldAmbient = Lighting.Ambient
        oldOutdoor = Lighting.OutdoorAmbient
        oldClock = Lighting.ClockTime
        
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.ClockTime = 14 -- Siang hari
        Lighting.FogEnd = 100000 -- Hapus kabut
    else
        -- Restore (Agak tricky kalau game nge-loop lighting, tapi ini basic restore)
        if oldAmbient then
            Lighting.Ambient = oldAmbient
            Lighting.OutdoorAmbient = oldOutdoor
            Lighting.ClockTime = oldClock
            Lighting.FogEnd = 500 -- Default fog
        end
    end
end

-- [4] FLY MODE
function logic_Fly(state)
    if state then
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "XianFly"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0,0,0)
        
        task.spawn(function()
            while features[4].enabled and char:FindFirstChild("HumanoidRootPart") do
                RunService.Heartbeat:Wait()
                hum.PlatformStand = true
                local cam = workspace.CurrentCamera.CFrame
                local move = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
                
                bv.Velocity = move * currentFlySpeed
            end
            bv:Destroy()
            hum.PlatformStand = false
        end)
    else
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("XianFly") then
            char.HumanoidRootPart.XianFly:Destroy()
            char.Humanoid.PlatformStand = false
        end
    end
end
