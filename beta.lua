local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI gagal dimuat!")
    return
else
    print("✓ UI berhasil dimuat!")
end

local Window = WindUI:CreateWindow({
    Title = "Bot Toko RootSec", -- Diterjemahkan
    Icon = "rbxassetid://73847768972928",
    Author = "CHEATER MEMANCING", -- Diterjemahkan
    Folder = "Bot Toko RootSec", -- Diterjemahkan
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

local Tab1 = Window:Tab({
    Title = "Informasi", -- Diterjemahkan dari Info
    Icon = "info",
})

Tab1:Section({
    Title = "Admin Telegram", -- Diterjemahkan dari Telegram Admin
    Icon = "chevrons-left-right-ellipsis",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Divider()

Tab1:Button({
    Title = "Telegram",
    Desc = "klik untuk menyalin tautan", -- Diterjemahkan dari click to copy link
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/apptokoroots")
        end
    end
})

Tab1:Paragraph({
    Title = "Dukungan", -- Diterjemahkan dari Support
    Desc = "Setiap kali ada pembaruan game atau ada yang melaporkan, saya akan memperbaikinya sesegera mungkin." -- Diterjemahkan
})

Tab1:Keybind({
    Title = "Tutup/Buka UI", -- Diterjemahkan dari Close/Open ui
    Desc = "Tombol pintas untuk Tutup/Buka UI", -- Diterjemahkan dari Keybind to Close/Open ui
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

_G.AutoFishing = false
_G.AutoEquipRod = false
_G.AutoSell = false
_G.Radar = false
_G.Instant = false
_G.SellDelay = _G.SellDelay or 30
_G.CallMinDelay = _G.CallMinDelay or 0.12
_G.CallBackoff = _G.CallBackoff or 1.5

local lastCall = {}
local function safeCall(key, fn)
    local now = os.clock()
    local minDelay = _G.CallMinDelay or 0.12
    local backoff = _G.CallBackoff or 1.5
    if lastCall[key] and now - lastCall[key] < minDelay then
        task.wait(minDelay - (now - lastCall[key]))
    end
    local ok, res = pcall(fn)
    lastCall[key] = os.clock()
    if not ok then
        local msg = tostring(res):lower()
        if msg:find("429") or msg:find("too many requests") then
            task.wait(backoff)
        else
            task.wait(0.2)
        end
    end
    return ok, res
end

local function rod()
    safeCall("EquipToolFromHotbar", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RE/EquipToolFromHotbar"):FireServer(1)
    end)
end

local function sell()
    safeCall("SellAllItems", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/SellAllItems"):InvokeServer()
    end)
end

local function radar()
    safeCall("UpdateFishingRadar_true", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/UpdateFishingRadar"):InvokeServer(true)
    end)
end

local function autoon()
    safeCall("UpdateAutoFishingState_true", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/UpdateAutoFishingState"):InvokeServer(true)
    end)
end

local function autooff()
    safeCall("UpdateAutoFishingState_false", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/UpdateAutoFishingState"):InvokeServer(false)
    end)
end

local function catch()
    safeCall("FishingCompleted", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RE/FishingCompleted"):FireServer()
    end)
end

local function charge()
    safeCall("ChargeFishingRod", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"):InvokeServer()
    end)
end

local function lempar()
    safeCall("RequestFishingMinigameStarted", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(-1.233, 0.996, 1761532005.497)
    end)
    safeCall("ChargeFishingRod_after_lempar", function()
        game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"):InvokeServer()
    end)
end

local function autosell()
    while _G.AutoSell do
        sell()
        local delay = tonumber(_G.SellDelay) or 30
        local waited = 0
        while waited < delay and _G.AutoSell do
            task.wait(0.25)
            waited = waited + 0.25
        end
    end
end

local function perform_instant_cycle()
    charge()
    task.wait(0)
    lempar()
    task.wait(1)
    if _G.Instant then
        local loops = 5
        local fast = 0
        for i = 1, loops do
            if not _G.Instant then break end
            catch()
            task.wait(fast)
        end
    else
        catch()
    end
end

local Tab2 = Window:Tab({
    Title = "Utama", -- Diterjemahkan dari Main
    Icon = "house"
})

Tab2:Section({
    Title = "Memancing", -- Diterjemahkan dari Fishing
    Icon = "anchor",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab2:Divider()

Tab2:Toggle({ Title = "Auto Pasang Joran", Value = false, Callback = function(v) _G.AutoEquipRod = v if v then rod() end end }) -- Diterjemahkan dari Auto Equip Rod

local CurrentOption = "Instan" -- Menggunakan terjemahan sebagai default
local autoFishingThread = nil
local autosellThread = nil

Tab2:Dropdown({
    Title = "Mode", -- Diterjemahkan
    Values = { "Instan", "Legal" }, -- Diterjemahkan dari Instant, Legit
    Value = "Instan",
    Callback = function(opt)
        CurrentOption = opt
        WindUI:Notify({ Title = "Mode Dipilih", Content = "Mode: " .. opt, Duration = 3, Icon = "check" }) -- Diterjemahkan
    end
})

Tab2:Toggle({
    Title = "Auto Memancing", -- Diterjemahkan dari Auto Fishing
    Value = false,
    Callback = function(v)
        _G.AutoFishing = v
        if v then
            if CurrentOption == "Instan" then
                _G.Instant = true
                WindUI:Notify({ Title = "Auto Memancing", Content = "Mode Instan AKTIF", Duration = 3 }) -- Diterjemahkan
                if autoFishingThread then autoFishingThread = nil end
                autoFishingThread = task.spawn(function()
                    while _G.AutoFishing and CurrentOption == "Instan" do
                        perform_instant_cycle()
                        task.wait(1)
                    end
                end)
            else
                WindUI:Notify({ Title = "Auto Memancing", Content = "Mode Legal AKTIF", Duration = 3 }) -- Diterjemahkan
                if autoFishingThread then autoFishingThread = nil end
                autoFishingThread = task.spawn(function()
                    while _G.AutoFishing and CurrentOption == "Legal" do
                        autoon()
                        task.wait(1)
                    end
                end)
            end
        else
            WindUI:Notify({ Title = "Auto Memancing", Content = "NONAKTIF", Duration = 3 }) -- Diterjemahkan
            autooff()
            _G.Instant = false
            if autoFishingThread then task.cancel(autoFishingThread) end
            autoFishingThread = nil
        end
    end
})

Tab2:Section({
    Title = "Auto Jual", -- Diterjemahkan dari Auto Sell
    Icon = "coins",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab2:Divider()

Tab2:Toggle({
    Title = "Auto Jual", -- Diterjemahkan dari Auto Sell
    Value = false,
    Callback = function(v)
        _G.AutoSell = v
        if v then
            if autosellThread then task.cancel(autosellThread) end
            autosellThread = task.spawn(autosell)
        else
            _G.AutoSell = false
            if autosellThread then task.cancel(autosellThread) end
            autosellThread = nil
        end
    end
})

Tab2:Slider({
        Title = "Jeda Jual", -- Diterjemahkan dari Sell Delay
        Step = 1,
        Value = { Min = 1, Max = 120, Default = 30 },
        Callback = function(v) _G.SellDelay = v
    end
})

Tab2:Section({
    Title = "Item", -- Diterjemahkan dari Item
    Icon = "grid-2x2-check",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

Tab2:Toggle{
    Title = "Radar", -- Diterjemahkan dari Radar
    Value = false,
    Callback = function(state)
        local RS = game:GetService("ReplicatedStorage")
        local Lighting = game:GetService("Lighting")
        local Replion = require(RS.Packages.Replion).Client:GetReplion("Data")
        local NetFunction = require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar")

        if Replion and NetFunction:InvokeServer(state) then
            local sound = require(RS.Shared.Soundbook).Sounds.RadarToggle:Play()
            sound.PlaybackSpeed = 1 + math.random() * 0.3

            local colorEffect = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
            if colorEffect then
                require(RS.Packages.spr).stop(colorEffect)
                local timeController = require(RS.Controllers.ClientTimeController)
                local lightingProfile = (timeController._getLightingProfile and timeController:_getLightingProfile() or timeController._getLighting_profile and timeController:_getLighting_profile() or {})
                local colorCorrection = lightingProfile.ColorCorrection or {}

                colorCorrection.Brightness = colorCorrection.Brightness or 0.04
                colorCorrection.TintColor = colorCorrection.TintColor or Color3.fromRGB(255, 255, 255)

                if state then
                    colorEffect.TintColor = Color3.fromRGB(42, 226, 118)
                    colorEffect.Brightness = 0.4
                    require(RS.Controllers.TextNotificationController):DeliverNotification{
                        Type = "Text",
                        Text = "Radar: Diaktifkan", -- Diterjemahkan
                        TextColor = {R = 9, G = 255, B = 0}
                    }
                else
                    colorEffect.TintColor = Color3.fromRGB(255, 0, 0)
                    colorEffect.Brightness = 0.2
                    require(RS.Controllers.TextNotificationController):DeliverNotification{
                        Type = "Text",
                        Text = "Radar: Dinonaktifkan", -- Diterjemahkan
                        TextColor = {R = 255, G = 0, B = 0}
                    }
                end

                require(RS.Packages.spr).target(colorEffect, 1, 1, colorCorrection)
            end

            require(RS.Packages.spr).stop(Lighting)
            Lighting.ExposureCompensation = 1
            require(RS.Packages.spr).target(Lighting, 1, 2, {ExposureCompensation = 0})
        end
    end
}

Tab2:Toggle({
    Title = "Peralatan Selam", -- Diterjemahkan dari Diving Gear
    Desc = "Tabung Oksigen", -- Diterjemahkan dari Oxygen Tank
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.DivingGear = state
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RemoteFolder = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
        if _G.DivingGear then
            local args = {
                [1] = 105
            }
            RemoteFolder:FindFirstChild("RF/EquipOxygenTank"):InvokeServer(unpack(args))
        else
            RemoteFolder:FindFirstChild("RF/UnequipOxygenTank"):InvokeServer()
        end
    end
})

_G.AutoNotifyEJ = false
_G.AutoNotifyQuest = false

local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local player = players.LocalPlayer

local QuestList = require(rs.Shared.Quests.QuestList)
local QuestUtility = require(rs.Shared.Quests.QuestUtility)
local Replion = require(rs.Packages.Replion)

local repl = nil
task.spawn(function()
    repl = Replion.Client:WaitReplion("Data")
end)

local function GetEJ()
    if not repl then return nil end
    return repl:Get(QuestList.ElementJungle.ReplionPath)
end

local function GetDeepSea()
    if not repl then return nil end
    return repl:Get(QuestList.DeepSea.ReplionPath)
end

_G.CheckEJ = function()
    local data = GetEJ()
    if not data or not data.Available or not data.Available.Forever then
        WindUI:Notify({Title="Hutan Elemen",Content="Misi tidak ditemukan",Duration=4,Icon="alert-circle"}) -- Diterjemahkan
        return
    end

    local quests = data.Available.Forever.Quests
    local total = #quests
    local done = 0
    local list = ""

    for _,q in ipairs(quests) do
        local info = QuestUtility:GetQuestData("ElementJungle","Forever",q.QuestId)
        if info then
            local maxVal = QuestUtility.GetQuestValue(repl,info)
            local percent = math.floor(math.clamp(q.Progress/maxVal,0,1)*100)
            if percent>=100 then done+=1 end
            list = list..info.DisplayName.." - "..percent.."%\n"
        end
    end

    local totalPercent = math.floor((done/total)*100)
    WindUI:Notify({
        Title="Progres Hutan Elemen", -- Diterjemahkan
        Content="Total: "..totalPercent.."%\n\n"..list,
        Duration=7,
        Icon="leaf"
    })
end

_G.CheckQuestProgress = function()
    local data = GetDeepSea()
    if not data or not data.Available or not data.Available.Forever then
        WindUI:Notify({Title="Misi Laut Dalam",Content="Misi tidak ditemukan",Duration=4,Icon="alert-circle"}) -- Diterjemahkan
        return
    end

    local quests = data.Available.Forever.Quests
    local total = #quests
    local done = 0
    local list = ""

    for _,q in ipairs(quests) do
        local info = QuestUtility:GetQuestData("DeepSea","Forever",q.QuestId)
        if info then
            local maxVal = QuestUtility.GetQuestValue(repl,info)
            local percent = math.floor(math.clamp(q.Progress/maxVal,0,1)*100)
            if percent>=100 then done+=1 end
            list = list..info.DisplayName.." - "..percent.."%\n"
        end
    end

    local totalPercent = math.floor((done/total)*100)
    WindUI:Notify({
        Title="Progres Laut Dalam", -- Diterjemahkan
        Content="Total: "..totalPercent.."%\n\n"..list,
        Duration=7,
        Icon="check-circle"
    })
end

task.spawn(function()
    while task.wait(5) do
        if _G.AutoNotifyEJ then _G.CheckEJ() end
        if _G.AutoNotifyQuest then _G.CheckQuestProgress() end
    end
end)

Tab2:Section({
    Title="Misi", -- Diterjemahkan dari Quest
    Icon="scroll-text",
    TextXAlignment="Left",
    TextSize=17
})

Tab2:Divider()

Tab2:Toggle({
    Title="Notifikasi Otomatis Hutan Elemen", -- Diterjemahkan
    Desc="Cek Progres Otomatis Hutan Elemen", -- Diterjemahkan
    Default=false,
    Callback=function(v)
        _G.AutoNotifyEJ = v
    end
})

Tab2:Toggle({
    Title="Notifikasi Otomatis Misi", -- Diterjemahkan
    Desc="Cek Progres Otomatis Laut Dalam", -- Diterjemahkan
    Default=false,
    Callback=function(v)
        _G.AutoNotifyQuest = v
    end
})

Tab2:Button({
    Title="Misi Hutan Elemen", -- Diterjemahkan
    Desc="Cek Progres Misi Hutan Elemen", -- Diterjemahkan
    Callback=function()
        _G.CheckEJ()
    end
})

Tab2:Button({
    Title="Misi Laut Dalam", -- Diterjemahkan
    Desc="Cek Progres Laut Dalam", -- Diterjemahkan
    Callback=function()
        _G.CheckQuestProgress()
    end
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Tab3 = Window:Tab({
    Title = "Pemain", -- Diterjemahkan dari Players
    Icon = "user"
})

Tab3:Slider({
    Title = "Kecepatan", -- Diterjemahkan dari Speed
    Desc = false,
    Step = 1,
    Value = {
        Min = 18,
        Max = 100,
        Default = 18,
    },
    Callback = function(Value)
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = Value
    end
})

Tab3:Slider({
    Title = "Kekuatan Lompatan", -- Diterjemahkan dari Jump Power
    Desc = false,
    Step = 1,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50,
    },
    Callback = function(Value)
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").JumpPower = Value
    end
})

Tab3:Divider()

Tab3:Button({
    Title = "Atur Ulang Kekuatan Lompatan", -- Diterjemahkan dari Reset Jump Power
    Desc = "Kembalikan Kekuatan Lompatan ke normal (50)", -- Diterjemahkan dari Return Jump Power to normal (50)
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
        print("🔄 Kekuatan Lompatan diatur ulang ke 50") -- Diterjemahkan
    end
})

Player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.UseJumpPower = true
    humanoid.JumpPower = _G.CustomJumpPower or 50
end)

Tab3:Button({
    Title = "Atur Ulang Kecepatan", -- Diterjemahkan dari Reset Speed
    Desc = "Kembalikan kecepatan ke normal (16)", -- Diterjemahkan dari Return speed to normal (16)
    Callback = function()
        Humanoid.WalkSpeed = 16
        print("WalkSpeed diatur ulang ke default (16)") -- Diterjemahkan
    end
})

Tab3:Divider()

local UserInputService = game:GetService("UserInputService")

Tab3:Toggle({
    Title = "Lompatan Tak Terbatas", -- Diterjemahkan dari Infinite Jump
    Desc = "aktifkan untuk menggunakan lompatan tak terbatas", -- Diterjemahkan dari activate to use infinite jump
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
        if state then
            print("✅ Lompatan Tak Terbatas Aktif") -- Diterjemahkan
        else
            print("❌ Lompatan Tak Terbatas Nonaktif") -- Diterjemahkan
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab3:Toggle({
    Title = "Tembus Dinding", -- Diterjemahkan dari Noclip
    Desc = "Berjalan menembus dinding", -- Diterjemahkan dari Walk through walls
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        task.spawn(function()
            local Player = game:GetService("Players").LocalPlayer
            while _G.Noclip do
                task.wait(0.1)
                if Player.Character then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
})

local player = game:GetService("Players").LocalPlayer
local freezeConnection
local originalCFrame

Tab3:Toggle({
    Title = "Bekukan Karakter", -- Diterjemahkan dari Freeze Character
    Default = false,
    Callback = function(state)
        _G.FreezeCharacter = state
        if state then
            local character = game.Players.LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    originalCFrame = root.CFrame
                    freezeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                        if _G.FreezeCharacter and root then
                            root.CFrame = originalCFrame
                        end
                    end)
                end
            end
        else
            if freezeConnection then
                freezeConnection:Disconnect()
                freezeConnection = nil
            end
        end
    end
})

player.CharacterAdded:Connect(function(char)
    if isFrozen then
        task.wait(0.5)
        freezeCharacter(char)
    end
end)

local Tab4 = Window:Tab({
    Title = "Toko", -- Diterjemahkan dari Shop
    Icon = "badge-dollar-sign",
})

Tab4:Section({
    Title = "Beli Joran", -- Diterjemahkan dari Purchase Rod
    Icon = "shrimp",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab4:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

local rods = {
    ["Luck Rod"] = 79,
    ["Carbon Rod"] = 76,
    ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77,
    ["Ice Rod"] = 78,
    ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80,
    ["Steampunk Rod"] = 6,
    ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5,
    ["Ares Rod"] = 126,
    ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}

local rodNames_id = { -- Diterjemahkan
    "Joran Keberuntungan (350 Koin)", "Joran Karbon (900 Koin)", "Joran Rumput (1.5k Koin)", "Joran Demaskus (3k Koin)",
    "Joran Es (5k Koin)", "Joran Beruntung (15k Koin)", "Joran Tengah Malam (50k Koin)", "Joran Steampunk (215k Koin)",
    "Joran Krom (437k Koin)", "Joran Astral (1M Koin)", "Joran Ares (3M Koin)", "Joran Angler (8M Koin)",
    "Joran Bambu (12M Koin)"
}

local rodKeyMap_id = { -- Diterjemahkan, memetakan kembali ke key bahasa Inggris asli
    ["Joran Keberuntungan (350 Koin)"]="Luck Rod",
    ["Joran Karbon (900 Koin)"]="Carbon Rod",
    ["Joran Rumput (1.5k Koin)"]="Grass Rod",
    ["Joran Demaskus (3k Koin)"]="Demascus Rod",
    ["Joran Es (5k Koin)"]="Ice Rod",
    ["Joran Beruntung (15k Koin)"]="Lucky Rod",
    ["Joran Tengah Malam (50k Koin)"]="Midnight Rod",
    ["Joran Steampunk (215k Koin)"]="Steampunk Rod",
    ["Joran Krom (437k Koin)"]="Chrome Rod",
    ["Joran Astral (1M Koin)"]="Astral Rod",
    ["Joran Ares (3M Koin)"]="Ares Rod",
    ["Joran Angler (8M Koin)"]="Angler Rod",
    ["Joran Bambu (12M Koin)"]="Bamboo Rod"
}

local selectedRod = rodNames_id[1]

Tab4:Dropdown({
    Title = "Pilih Joran", -- Diterjemahkan dari Select Rod
    Values = rodNames_id,
    Value = selectedRod,
    Callback = function(value)
        selectedRod = value
    end
})

Tab4:Button({
    Title="Beli Joran", -- Diterjemahkan dari Buy Rod
    Callback=function()
        local key = rodKeyMap_id[selectedRod]
        if key and rods[key] then
            local success, err = pcall(function()
                RFPurchaseFishingRod:InvokeServer(rods[key])
            end)
            if success then
                WindUI:Notify({Title="Pembelian Joran", Content="Berhasil membeli "..selectedRod, Duration=3}) -- Diterjemahkan
            else
                WindUI:Notify({Title="Kesalahan Pembelian Joran", Content=tostring(err), Duration=5}) -- Diterjemahkan
            end
        end
    end
})

Tab4:Section({
    Title = "Beli Umpan", -- Diterjemahkan dari Purchase Baits
    Icon = "compass",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab4:Divider()

local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]

local baits = {
    ["TopWater Bait"] = 10,
    ["Lucky Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Chroma Bait"] = 6,
    ["Dark Mater Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16,
    ["Floral Bait"] = 20,
}

local baitNames_id = { -- Diterjemahkan
    "Umpan Keberuntungan (1k Koin)", -- Luck Bait
    "Umpan Tengah Malam (3k Koin)", -- Midnight Bait
    "Umpan Alam (83.5k Koin)", -- Nature Bait
    "Umpan Chroma (290k Koin)",
    "Umpan Dark Matter (630k Koin)",
    "Umpan Korup (1.15M Koin)", -- Corrupt Bait
    "Umpan Aether (3.7M Koin)",
    "Umpan Floral (4M Koin)"
}

local baitKeyMap_id = { -- Diterjemahkan, memetakan kembali ke key bahasa Inggris asli
    ["Umpan Keberuntungan (1k Koin)"] = "Luck Bait",
    ["Umpan Tengah Malam (3k Koin)"] = "Midnight Bait",
    ["Umpan Alam (83.5k Koin)"] = "Nature Bait",
    ["Umpan Chroma (290k Koin)"] = "Chroma Bait",
    ["Umpan Dark Matter (630k Koin)"] = "Dark Mater Bait", -- Menggunakan ejaan asli
    ["Umpan Korup (1.15M Koin)"] = "Corrupt Bait",
    ["Umpan Aether (3.7M Koin)"] = "Aether Bait",
    ["Umpan Floral (4M Koin)"] = "Floral Bait"
}

local selectedBait = baitNames_id[1]

Tab4:Dropdown({
    Title = "Pilih Umpan", -- Diterjemahkan dari Select Bait
    Values = baitNames_id,
    Value = selectedBait,
    Callback = function(value)
        selectedBait = value
    end
})

Tab4:Button({
    Title = "Beli Umpan", -- Diterjemahkan dari Buy Bait
    Callback = function()
        local key = baitKeyMap_id[selectedBait]
        if key and baits[key] then
            local success, err = pcall(function()
                RFPurchaseBait:InvokeServer(baits[key])
            end)
            if success then
                WindUI:Notify({Title = "Pembelian Umpan", Content = "Berhasil membeli " .. selectedBait, Duration = 3}) -- Diterjemahkan
            else
                WindUI:Notify({Title = "Kesalahan Pembelian Umpan", Content = tostring(err), Duration = 5}) -- Diterjemahkan
            end
        end
    end
})

Tab4:Section({
    Title = "Beli Acara Cuaca", -- Diterjemahkan dari Purchase Weathers
    Icon = "shrimp",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab4:Divider()

-- Pemetaan Cuaca
local weatherKeyMap_id = { -- Diterjemahkan
    ["Angin (10k Koin)"] = "Wind",
    ["Salju (15k Koin)"] = "Snow",
    ["Berawan (20k Koin)"] = "Cloudy",
    ["Badai (35k Koin)"] = "Storm",
    ["Cerah (50k Koin)"] = "Radiant",
    ["Buru Hiu (300k Koin)"] = "Shark Hunt"
}

local weatherNames_id = { -- Diterjemahkan
    "Angin (10k Koin)", "Salju (15k Koin)", "Berawan (20k Koin)",
    "Badai (35k Koin)", "Cerah (50k Koin)", "Buru Hiu (300k Koin)"
}

local selectedWeathers = {}

Tab4:Dropdown({
    Title = "Pilih Acara Cuaca", -- Diterjemahkan dari Select Weather Event
    Values = weatherNames_id,
    Multi = true,
    Callback = function(values)
        selectedWeathers = values
    end
})

local autoBuyEnabled = false
local buyDelay = 0.5

local function startAutoBuy()
    task.spawn(function()
        while autoBuyEnabled do
            for _, displayName in ipairs(selectedWeathers) do
                local key = weatherKeyMap_id[displayName]
                if key then
                    local success, err = pcall(function()
                        RFPurchaseWeatherEvent:InvokeServer(key)
                    end)
                    if success then
                        WindUI:Notify({
                            Title = "Beli",
                            Content = "Berhasil membeli " .. displayName, -- Diterjemahkan
                            Duration = 1
                        })
                    else
                        warn("Error buying weather:", err)
                    end
                    task.wait(buyDelay)
                end
            end
            task.wait(0.1)
        end
    end)
end

Tab4:Toggle({
    Title = "Auto Beli Acara Cuaca", -- Diterjemahkan dari Buy Weather Event
    Desc = "Otomatis beli acara cuaca yang dipilih", -- Diterjemahkan dari Automatically purchase selected weather event
    Value = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Beli", -- Diterjemahkan
                Content = "Diaktifkan", -- Diterjemahkan
                Duration = 2
            })
            startAutoBuy()
        else
            WindUI:Notify({
                Title = "Auto Beli", -- Diterjemahkan
                Content = "Dinonaktifkan", -- Diterjemahkan
                Duration = 2
            })
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Teleportasi", -- Diterjemahkan dari Teleport
    Icon = "map-pin",
})

Tab5:Section({
    Title = "Pulau", -- Diterjemahkan dari Island
    Icon = "tree-palm",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local IslandLocations = {
    ["Ancient Jungle"] = Vector3.new(1518, 1, -186),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Crater Island"] = Vector3.new(997, 1, 5012),
    ["Crystal Cavern"] = Vector3.new(-1841, -456, 7186),
    ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
    ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
    ["Fisherman Island"] = Vector3.new(-175, 3, 2772),
    ["Konoha"] = Vector3.new(-603, 3, 719),
    ["Lost Isle"] = Vector3.new(-3643, 1, -1061),
    ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
    ["Underground Cellar"] = Vector3.new(2135, -93, -701),
    ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
}

local SelectedIsland = nil

local IslandDropdown = Tab5:Dropdown({
    Title = "Pilih Pulau", -- Diterjemahkan dari Select Island
    Values = (function()
        local keys = {}
        for name in pairs(IslandLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedIsland = Value
    end
})

Tab5:Button({
    Title = "Teleportasi ke Pulau", -- Diterjemahkan dari Teleport to Island
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(IslandLocations[SelectedIsland])
        end
    end
})

Tab5:Section({
    Title = "Tempat Memancing", -- Diterjemahkan dari Fishing Spot
    Icon = "spotlight",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local FishingLocations = {
    ["Ancient Ruin"] = Vector3.new(6033.74267578125, -585.9241943359375, 4620.7236328125),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Enchant Room 2"] = Vector3.new(1480, 126, -585),
    ["Konoha"] = Vector3.new(-603, 3, 719),
    ["Levers 1"] = Vector3.new(1475,4,-847),
    ["Levers 2"] = Vector3.new(882,5,-321),
    ["levers 3"] = Vector3.new(1425,6,126),
    ["levers 4"] = Vector3.new(1837,4,-309),
    ["Sacred Temple"] = Vector3.new(1475,-22,-632),
    ["Spawn"] = Vector3.new(33, 9, 2810),
    ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
    ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
    ["Underground Cellar"] = Vector3.new(2135,-92,-695),
    ["Volcano"] = Vector3.new(-632, 55, 197),
}

local SelectedFishing = nil

Tab5:Dropdown({
    Title = "Pilih Tempat", -- Diterjemahkan dari Select Spot
    Values = (function()
        local keys = {}
        for name in pairs(FishingLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedFishing = Value
    end
})

Tab5:Button({
    Title = "Teleportasi ke Tempat Memancing", -- Diterjemahkan dari Teleport to Fishing Spot
    Callback = function()
        if SelectedFishing and FishingLocations[SelectedFishing] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(FishingLocations[SelectedFishing])
        end
    end
})

Tab5:Section({
    Title = "Teleportasi Pemain", -- Diterjemahkan dari Teleport Player
    Icon = "person-standing",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

local SelectedPlayer = nil
local Dropdown

Dropdown = Tab5:Dropdown({
    Title = "Daftar Pemain", -- Diterjemahkan dari List Player
    Values = GetPlayerList(),
    Value = GetPlayerList()[1],
    Callback = function(option)
        SelectedPlayer = option
    end
})

Tab5:Button({
    Title = "Teleportasi ke Pemain (Target)", -- Diterjemahkan dari Teleport to Player (Target)
    Locked = false,
    Callback = function()
        if not SelectedPlayer then
            return
        end
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame =
                target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

Tab5:Button({
    Title = "Segarkan Daftar Pemain", -- Diterjemahkan dari Refresh Player List
    Locked = false,
    Callback = function()
        local newList = GetPlayerList()

        if Dropdown.SetValues then
            Dropdown:SetValues(newList)
        elseif Dropdown.Refresh then
            Dropdown:Refresh(newList)
        elseif Dropdown.Update then
            Dropdown:Update(newList)
        end

        if newList[1] then
            SelectedPlayer = newList[1]
            if Dropdown.Set then
                Dropdown:Set(newList[1])
            end
        end
    end
})

Tab5:Section({
    Title = "Teleporter Acara", -- Diterjemahkan dari Event Teleporter
    Icon = "calendar",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
	character = c
	hrp = c:WaitForChild("HumanoidRootPart")
end)

local megCheckRadius = 150

local autoEventTPEnabled = false
local selectedEvents = {}
local createdEventPlatform = nil

local eventData = {
	["Worm Hunt"] = {
		TargetName = "Model",
		Locations = {
			Vector3.new(2190.85, -1.4, 97.575),
			Vector3.new(-2450.679, -1.4, 139.731),
			Vector3.new(-267.479, -1.4, 5188.531),
			Vector3.new(-327, -1.4, 2422)
		},
		PlatformY = 107,
		Priority = 1,
		Icon = "fish"
	},
	["Megalodon Hunt"] = {
		TargetName = "Megalodon Hunt",
		Locations = {
			Vector3.new(-1076.3, -1.4, 1676.2),
			Vector3.new(-1191.8, -1.4, 3597.3),
			Vector3.new(412.7, -1.4, 4134.4),
		},
		PlatformY = 107,
		Priority = 2,
		Icon = "anchor"
	},
	["Ghost Shark Hunt"] = {
		TargetName = "Ghost Shark Hunt",
		Locations = {
			Vector3.new(489.559, -1.35, 25.406),
			Vector3.new(-1358.216, -1.35, 4100.556),
			Vector3.new(627.859, -1.35, 3798.081)
		},
		PlatformY = 107,
		Priority = 3,
		Icon = "fish"
	},
	["Shark Hunt"] = {
		TargetName = "Shark Hunt",
		Locations = {
			Vector3.new(1.65, -1.35, 2095.725),
			Vector3.new(1369.95, -1.35, 930.125),
			Vector3.new(-1585.5, -1.35, 1242.875),
			Vector3.new(-1896.8, -1.35, 2634.375)
		},
		PlatformY = 107,
		Priority = 4,
		Icon = "fish"
	},
}

local eventNames = {}
for name in pairs(eventData) do
	table.insert(eventNames, name)
end

local function destroyEventPlatform()
	if createdEventPlatform and createdEventPlatform.Parent then
		createdEventPlatform:Destroy()
		createdEventPlatform = nil
	end
end

local function createAndTeleportToPlatform(targetPos, y)
	destroyEventPlatform()

	local platform = Instance.new("Part")
	platform.Size = Vector3.new(5, 1, 5)
	platform.Position = Vector3.new(targetPos.X, y, targetPos.Z)
	platform.Anchored = true
	platform.Transparency = 1
	platform.CanCollide = true
	platform.Name = "EventPlatform"
	platform.Parent = Workspace
	createdEventPlatform = platform

	hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 3, 0))
end

local function runMultiEventTP()
	while autoEventTPEnabled do
		local sorted = {}
		for _, e in ipairs(selectedEvents) do
			if eventData[e] then
				table.insert(sorted, eventData[e])
			end
		end
		table.sort(sorted, function(a, b) return a.Priority < b.Priority end)

		for _, config in ipairs(sorted) do
			local foundTarget, foundPos = nil, nil

			if config.TargetName == "Model" then
				local menuRings = Workspace:FindFirstChild("!!! MENU RINGS")
				if menuRings then
					for _, props in ipairs(menuRings:GetChildren()) do
						if props.Name == "Props" then
							local model = props:FindFirstChild("Model")
							if model and model.PrimaryPart then
								for _, loc in ipairs(config.Locations) do
									if (model.PrimaryPart.Position - loc).Magnitude <= megCheckRadius then
										foundTarget = model
										foundPos = model.PrimaryPart.Position
										break
									end
								end
							end
						end
						if foundTarget then break end
					end
				end
			else
				for _, loc in ipairs(config.Locations) do
					for _, d in ipairs(Workspace:GetDescendants()) do
						if d.Name == config.TargetName then
							local pos = d:IsA("BasePart") and d.Position or (d.PrimaryPart and d.PrimaryPart.Position)
							if pos and (pos - loc).Magnitude <= megCheckRadius then
								foundTarget = d
								foundPos = pos
								break
							end
						end
					end
					if foundTarget then break end
				end
			end

			if foundTarget and foundPos then
				createAndTeleportToPlatform(foundPos, config.PlatformY)
			end
		end
		task.wait(0.05)
	end
	destroyEventPlatform()
end

Tab5:Dropdown({
	Title = "Pilih Acara", -- Diterjemahkan dari Select Events
	Values = eventNames,
	Multi = true,
	AllowNone = true,
	Callback = function(values)
		selectedEvents = values
	end
})

Tab5:Toggle({
	Title = "Auto Acara", -- Diterjemahkan dari Auto Event
	Icon = false,
	Type = false,
	Value = false,
	Callback = function(state)
		autoEventTPEnabled = state
		if state then
			task.spawn(runMultiEventTP)
		end
	end
})

local Tab6 = Window:Tab({
    Title = "Pengaturan", -- Diterjemahkan dari Settings
    Icon = "settings",
})

Tab6:Toggle({
    Title = "Anti AFK", -- Diterjemahkan dari AntiAFK
    Desc = "Mencegah Roblox mengeluarkan Anda saat diam", -- Diterjemahkan dari Prevent Roblox from kicking you when idle
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")

        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(60)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK dimuat!", -- Diterjemahkan
                Text = "Dibuat Oleh Kirsiasc", -- Diterjemahkan dari Coded By Kirsiasc
                Button1 = "Oke", -- Diterjemahkan dari Okey
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK Dinonaktifkan", -- Diterjemahkan
                Text = "AntiAFK Dihentikan", -- Diterjemahkan dari Stopped AntiAFK
                Duration = 3
            })
        end
    end
})

Tab6:Toggle({
    Title = "Auto Sambungkan Kembali", -- Diterjemahkan dari Auto Reconnect
    Desc = "Sambungkan kembali secara otomatis jika terputus", -- Diterjemahkan dari Automatic reconnect if disconnected
    Icon = false,
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)

                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tab6:Section({
    Title = "Server", -- Diterjemahkan dari Server
    Icon = "server",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab6:Divider()

Tab6:Button({
    Title = "Gabung Ulang Server", -- Diterjemahkan dari Rejoin Server
    Desc = "Sambungkan kembali ke server saat ini", -- Diterjemahkan dari Reconnect to current server
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Tab6:Button({
    Title = "Pindah Server", -- Diterjemahkan dari Server Hop
    Desc = "Beralih ke server lain", -- Diterjemahkan dari Switch to another server
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")

        local function GetServers()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
            local response = HttpService:JSONDecode(game:HttpGet(url))
            return response.data
        end

        local function FindBestServer(servers)
            for _, server in ipairs(servers) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    return server.id
                end
            end
            return nil
        end

        local servers = GetServers()
        local serverId = FindBestServer(servers)

        if serverId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
        else
            warn("⚠️ Tidak ada server yang cocok ditemukan!") -- Diterjemahkan
        end
    end
})
