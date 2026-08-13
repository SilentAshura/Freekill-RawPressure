local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Pressure Test Script",
    Icon = 0,
    LoadingTitle = "Pressure 0.8",
    LoadingSubtitle = "Modified by Freekill#1619",
    Theme = {
        TextColor = Color3.fromRGB(200, 225, 255),
        Background = Color3.fromRGB(10, 18, 35),
        Topbar = Color3.fromRGB(15, 25, 50),
        Shadow = Color3.fromRGB(5, 10, 20),
        NotificationBackground = Color3.fromRGB(12, 22, 45),
        NotificationActionsBackground = Color3.fromRGB(30, 60, 120),
        TabBackground = Color3.fromRGB(20, 35, 70),
        TabStroke = Color3.fromRGB(30, 55, 110),
        TabBackgroundSelected = Color3.fromRGB(40, 90, 180),
        TabTextColor = Color3.fromRGB(150, 190, 255),
        SelectedTabTextColor = Color3.fromRGB(220, 235, 255),
        ElementBackground = Color3.fromRGB(15, 28, 58),
        ElementBackgroundHover = Color3.fromRGB(20, 38, 78),
        SecondaryElementBackground = Color3.fromRGB(10, 18, 40),
        ElementStroke = Color3.fromRGB(35, 65, 130),
        SecondaryElementStroke = Color3.fromRGB(25, 48, 100),
        SliderBackground = Color3.fromRGB(30, 80, 170),
        SliderProgress = Color3.fromRGB(50, 120, 220),
        SliderStroke = Color3.fromRGB(70, 150, 255),
        ToggleBackground = Color3.fromRGB(15, 28, 58),
        ToggleEnabled = Color3.fromRGB(40, 110, 220),
        ToggleDisabled = Color3.fromRGB(40, 55, 90),
        ToggleEnabledStroke = Color3.fromRGB(60, 140, 255),
        ToggleDisabledStroke = Color3.fromRGB(50, 70, 120),
        ToggleEnabledOuterStroke = Color3.fromRGB(35, 90, 180),
        ToggleDisabledOuterStroke = Color3.fromRGB(25, 40, 80),
        DropdownSelected = Color3.fromRGB(20, 40, 85),
        DropdownUnselected = Color3.fromRGB(15, 28, 58),
        InputBackground = Color3.fromRGB(15, 28, 58),
        InputStroke = Color3.fromRGB(40, 75, 150),
        PlaceholderColor = Color3.fromRGB(100, 140, 200),
    },
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = { Enabled = true, FolderName = "Pressure", FileName = "Pressure" },
    KeySystem = false
})

-- ================================================
-- MASTER TOGGLE LIST FOR CLEAN UNLOAD
-- ================================================
local AllToggles = {}

-- ================================================
-- Ensures the character is clean at the start.
-- ================================================
local function CleanupCharacter(char)
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if root then root.Anchored = false end
    if hum  then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end

local Players     = game:GetService("Players")
local Player      = Players.LocalPlayer
local RunService  = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Clears on load and on every respawn.
CleanupCharacter(Player.Character)
Player.CharacterAdded:Connect(CleanupCharacter)

local Esp  = Window:CreateTab("Visuals", "eye")
local Anti = Window:CreateTab("Antis", "shield")
local Move = Window:CreateTab("Move", "arrow-big-right")
local Settings = Window:CreateTab("Set")

local WHITE     = Color3.fromRGB(255, 255, 255)
local RED       = Color3.fromRGB(255, 0, 0)
local Rooms     = workspace.GameplayFolder.Rooms

-- ================================================
-- CONFIGS
-- ================================================

local KEYCARDS = {
    NormalKeyCard = { label = "Keycard",       fill = Color3.fromRGB(255, 50,  50),  outline = Color3.fromRGB(255, 150, 150) },
    InnerKeyCard  = { label = "Inner Keycard", fill = Color3.fromRGB(0,   120, 255), outline = Color3.fromRGB(100, 180, 255) },
    RidgeKeyCard  = { label = "Ridge Keycard", fill = Color3.fromRGB(255, 150, 0),   outline = Color3.fromRGB(255, 200, 100) },
    PasswordPaper = { label = "Password",      fill = Color3.fromRGB(0,   200, 80),  outline = Color3.fromRGB(100, 255, 150) },
}

local ITEM_PATTERNS = {
    { pattern = "Lantern",      label = "Lantern",       fill = Color3.fromRGB(255, 200, 0),   outline = Color3.fromRGB(255, 230, 100) },
    { pattern = "Flashlight",   label = "Flashlight",    fill = Color3.fromRGB(200, 200, 255), outline = Color3.fromRGB(255, 255, 255) },
    { pattern = "Blacklight",   label = "Blacklight",    fill = Color3.fromRGB(150, 0,   255), outline = Color3.fromRGB(200, 100, 255) },
    { pattern = "Medkit",       label = "Medkit",        fill = Color3.fromRGB(255, 50,  50),  outline = Color3.fromRGB(255, 150, 150) },
    { pattern = "HealthBoost",  label = "Health Boost",  fill = Color3.fromRGB(255, 100, 100), outline = Color3.fromRGB(255, 180, 180) },
    { pattern = "Defib",        label = "Defib",         fill = Color3.fromRGB(255, 0,   100), outline = Color3.fromRGB(255, 100, 180) },
    { pattern = "FlashBeacon",  label = "Flash Beacon",  fill = Color3.fromRGB(255, 255, 50),  outline = Color3.fromRGB(255, 255, 150) },
    { pattern = "Scanner",      label = "Scanner",       fill = Color3.fromRGB(0,   255, 200), outline = Color3.fromRGB(100, 255, 230) },
    { pattern = "^Book$",       label = "Book",          fill = Color3.fromRGB(180, 120, 40),  outline = Color3.fromRGB(220, 170, 100) },
    { pattern = "CodeBreacher", label = "Code Breacher", fill = Color3.fromRGB(0,   200, 255), outline = Color3.fromRGB(100, 230, 255) },
    { pattern = "Gummylight",   label = "Gummylight",    fill = Color3.fromRGB(255, 100, 200), outline = Color3.fromRGB(255, 180, 230) },
    { pattern = "WindupLight",  label = "Windup Light",  fill = Color3.fromRGB(255, 180, 50),  outline = Color3.fromRGB(255, 210, 120) },
    { pattern = "SPRINT",       label = "SPRINT",        fill = Color3.fromRGB(50,  255, 100), outline = Color3.fromRGB(150, 255, 180) },
    { pattern = "ToyRemote",    label = "Toy Remote",    fill = Color3.fromRGB(100, 100, 255), outline = Color3.fromRGB(180, 180, 255) },
    { pattern = "Battery",      label = "Battery",       fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 100) },
    { pattern = "[Nn]eostyk",   label = "NeoStyk",       fill = Color3.fromRGB(0,   255, 150), outline = Color3.fromRGB(100, 255, 200) },
}

-- Updated Monsters list including Room-spawning targets
local MONSTERS = {
    A200=true, A60=true, Angler=true, 
    Bleach=true, Bottomfeeder=true, Bouncers=true, CandleBearers=true, CandleBrutes=true,
    Eyefestation=true, Harbinger=true,
    ImaginaryFriend=true, Lopee=true, Pandemonium=true,
    Parasite=true, Pipsqueak=true, Rebarb=true, Redeemer=true,
    Skelepede=true, Stan=true, TheDiVine=true, TheEducator=true,
    TheMindscape=true, ThePainter=true, TheSaboteur=true,
    WallDwellers=true, WitchingHour=true,
    Blitz=true, Squiddles=true, NaviAI=true,
    RottenCoral=true, Searchlights=true, DefenseSystem=true,
    Froger=true, Chainsmoker=true, Pinkie=true,
    WallDweller=true, MeatWallDweller=true, RottenWallDweller=true,
    Bouncer=true, SkeletonHead=true, NoGood=true, 
    -- Room specific Wall Dweller Parts
    DiVineRoot=true, DwellerModel=true, StatueHead = true, StatueRoot = true, 
    -- Ridge variants
    RidgeAngler=true, RidgeChainsmoker=true, RidgePinkie=true,
    RidgeBlitz=true, RidgeFroger=true, RidgePandemonium=true,
    --Pandemoniums variants
    Anglemonium=true, Frogermonium=true,
    Blitzemonium=true, Pandesmoker=true, Pinkimonium=true,
    RidgePandemonium=true 
}

local PANDEMONIUM_NAMES = {
    Pandemonium=true, Anglemonium=true, Frogermonium=true,
    Blitzemonium=true, Pandesmoker=true, Pinkimonium=true,
    RidgePandemonium=true,
}

local CURRENCY_PATTERNS = {
    { pattern="^UCurrency5%-",   label="~5$",                fill=Color3.fromRGB(100,220,255), outline=Color3.fromRGB(180,240,255) },
    { pattern="^UCurrency10%-",  label="~10$",               fill=Color3.fromRGB(50,180,255),  outline=Color3.fromRGB(150,220,255) },
    { pattern="^UCurrency15%-",  label="~15$",               fill=Color3.fromRGB(0,150,255),   outline=Color3.fromRGB(100,200,255) },
    { pattern="^UCurrency25%-",  label="~25$",               fill=Color3.fromRGB(0,100,220),   outline=Color3.fromRGB(80,170,255)  },
    { pattern="^UCurrency50%-",  label="~50$",               fill=Color3.fromRGB(0,80,200),    outline=Color3.fromRGB(60,150,240)  },
    { pattern="^UCurrency100%-", label="~100$",              fill=Color3.fromRGB(0,50,180),    outline=Color3.fromRGB(50,120,220)  },
    { pattern="^UCurrency200%-", label="~200$",              fill=Color3.fromRGB(0,30,150),    outline=Color3.fromRGB(30,100,200)  },
    { pattern="^Currency5%-",    label="5$",                 fill=Color3.fromRGB(180,255,100), outline=Color3.fromRGB(220,255,170) },
    { pattern="^Currency10%-",   label="10$",                fill=Color3.fromRGB(100,220,50),  outline=Color3.fromRGB(170,240,120) },
    { pattern="^Currency15%-",   label="15$",                fill=Color3.fromRGB(50,200,50),   outline=Color3.fromRGB(130,230,130) },
    { pattern="^Currency25%-",   label="25$",                fill=Color3.fromRGB(0,180,80),    outline=Color3.fromRGB(80,220,150)  },
    { pattern="^Currency50%-",   label="50$",                fill=Color3.fromRGB(0,150,255),   outline=Color3.fromRGB(80,200,255)  },
    { pattern="^Currency100%-",  label="100$",               fill=Color3.fromRGB(255,200,0),   outline=Color3.fromRGB(255,230,100) },
    { pattern="^Currency200%-",  label="200$",               fill=Color3.fromRGB(255,100,0),   outline=Color3.fromRGB(255,180,80)  },
    { pattern="^Caps$",          label="Rare: Caps",         fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^DoorsGold",      label="Rare: Doors Gold",   fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^GOLDDD$",        label="Rare: GOLDDD",       fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^HypnoCoin$",     label="Rare: Hypno Coin",   fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^Regret$",        label="Rare: Regret",       fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^Studs$",         label="Rare: Studs",        fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^SuperCredits$",  label="Rare: Super Credits",fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^RareCurrency",   label="RARE$",              fill=Color3.fromRGB(200,0,255),   outline=Color3.fromRGB(255,100,255) },
    { pattern="^Blueprint$",     label="Blueprint",          fill=Color3.fromRGB(0,180,255),   outline=Color3.fromRGB(100,220,255) },
}

-- ================================================
-- HELPERS
-- ================================================

local function GetItemConfig(name)
    for _, e in ipairs(ITEM_PATTERNS) do
        if string.match(name, e.pattern) then
            return { label=e.label, fill=e.fill, outline=e.outline }
        end
    end
    return nil
end

local function GetCurrencyConfig(name)
    for _, e in ipairs(CURRENCY_PATTERNS) do
        if string.match(name, e.pattern) then
            return { label=e.label, fill=e.fill, outline=e.outline or WHITE }
        end
    end
    return nil
end

local function IsCurrencyOrBlueprint(name)
    return GetCurrencyConfig(name) ~= nil
end

local function GetRootPart()
    local char = Player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local char = Player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local lastNotify = {}
local function NotifyOnce(key, title, content, duration, image)
    if lastNotify[key] and (tick() - lastNotify[key]) < 8 then return end
    lastNotify[key] = tick()
    Rayfield:Notify({ Title=title, Content=content, Duration=duration, Image=image })
end

-- ================================================
-- ESP FUNCTIONS
-- ================================================

local NODE_MONSTERS = {
    Pandemonium = true, Anglemonium = true, Frogermonium = true, Blitzemonium = true, 
    Pandesmoker = true, Pinkimonium = true, RidgePandemonium = true, Harbinger = true,
    A200 = true, A60 = true, Bleach = true, Pipsqueak = true,
    Angler = true, Froger = true, Chainsmoker = true, Pinkie = true, Blitz = true,
    RidgeAngler = true, RidgeFroger = true, RidgeChainsmoker = true, RidgePinkie = true, RidgeBlitz = true
}

local function AddESP(part, config)
    if not part or not part.Parent then return end
    if part:FindFirstChildOfClass("Highlight") then return end

    local useCircle = NODE_MONSTERS[part.Name]

    local h = Instance.new("Highlight")
    h.Adornee = part
    h.FillColor = config.fill
    h.OutlineColor = config.outline or WHITE
    h.FillTransparency = config.fillTransparency or 0.4
    h.OutlineTransparency = 0
    h.Parent = part

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_Label"
    bb.Adornee = part
    bb.AlwaysOnTop = true
    bb.Parent = part

    local lbl = Instance.new("TextLabel")
    lbl.Name = "ESPText"
    lbl.Text = config.label
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = config.textColor or WHITE
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.3
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = bb

    if useCircle then
        bb.Size = UDim2.new(0, 100, 0, 100) 
        bb.StudsOffset = Vector3.new(0, 2, 0)

        local circle = Instance.new("Frame")
        circle.Name = "CenterCircle"
        circle.Size = UDim2.new(0, 24, 0, 24)
        circle.Position = UDim2.new(0.5, -12, 0.5, -12) 
        circle.BackgroundColor3 = config.fill
        circle.BorderSizePixel = 0
        circle.Parent = bb

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle

        local circleStroke = Instance.new("UIStroke")
        circleStroke.Color = config.outline or WHITE
        circleStroke.Thickness = 2
        circleStroke.Parent = circle

        lbl.Size = UDim2.new(0, 120, 0, 30)
        lbl.Position = UDim2.new(0.5, -60, 0, -25) 
    else
        bb.Size = UDim2.new(0, 140, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3, 0)

        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Position = UDim2.new(0, 0, 0, 0)

        local stroke = Instance.new("UIStroke")
        stroke.Color = config.outline or WHITE
        stroke.Thickness = 1.5
        stroke.Parent = lbl
    end
end

local function RemoveESP(part)
    if not part then return end
    local h = part:FindFirstChildOfClass("Highlight")
    if h then h:Destroy() end
    local b = part:FindFirstChild("ESP_Label")
    if b then b:Destroy() end
end

local function ScanRooms(enabled, matchFn, onFound)
    local connections = {}
    local scanned = {}

    local function processDesc(d)
        if scanned[d] then return end
        scanned[d] = true
        if not d.Parent then return end
        local config = matchFn(d.Name)
        if config then
            local target = d:FindFirstChild("ProxyPart") or d
            onFound(target, config)
        end
    end

    local function scanRoom(room)
        for _, d in ipairs(room:GetDescendants()) do
            if not enabled() then break end
            processDesc(d)
        end
    end

    for _, room in ipairs(Rooms:GetChildren()) do
        if not enabled() then break end
        task.defer(function() scanRoom(room) end)
        table.insert(connections, room.DescendantAdded:Connect(function(d)
            task.wait(0.1)
            if enabled() then processDesc(d) end
        end))
    end

    table.insert(connections, Rooms.ChildAdded:Connect(function(room)
        task.wait(0.3)
        if not enabled() then return end
        scanRoom(room)
        table.insert(connections, room.DescendantAdded:Connect(function(d)
            task.wait(0.1)
            if enabled() then processDesc(d) end
        end))
    end))

    return connections
end

local function CreateESPToggle(tab, name, flag, matchFn)
    local connections = {}
    local active = false
    local targets = {}

    local tgl = tab:CreateToggle({
        Name=name, CurrentValue=false, Flag=flag,
        Callback=function(Value)
            active = Value
            if Value then
                targets = {}
                connections = ScanRooms(
                    function() return active end,
                    matchFn,
                    function(target, config)
                        AddESP(target, config)
                        table.insert(targets, target)
                    end
                )
            else
                for _, c in ipairs(connections) do c:Disconnect() end
                connections = {}
                for _, target in ipairs(targets) do pcall(RemoveESP, target) end
                targets = {}
            end
        end
    })
    table.insert(AllToggles, tgl)
    return tgl
end

local function CreateAntiToggle(tab, name, flag, matchFn)
    local conns  = {}
    local active = false

    local tgl = tab:CreateToggle({
        Name=name, CurrentValue=false, Flag=flag,
        Callback=function(Value)
            active = Value
            if Value then
                local function destroyIfMatch(d)
                    if not active then return end
                    if matchFn(d.Name) then pcall(function() d:Destroy() end) end
                end
                local function setupRoom(room)
                    task.defer(function()
                        if not active then return end
                        for _, d in ipairs(room:GetDescendants()) do destroyIfMatch(d) end
                    end)
                    table.insert(conns, room.DescendantAdded:Connect(function(d)
                        task.wait(0.05)
                        if active then destroyIfMatch(d) end
                    end))
                end
                for _, room in ipairs(Rooms:GetChildren()) do setupRoom(room) end
                table.insert(conns, Rooms.ChildAdded:Connect(function(room)
                    task.wait(0.3)
                    if active then setupRoom(room) end
                end))
            else
                for _, c in ipairs(conns) do c:Disconnect() end
                conns = {}
            end
        end
    })
    table.insert(AllToggles, tgl)
    return tgl
end

-- ================================================
-- VISUALS TAB
-- ================================================

Esp:CreateSection("Items")
CreateESPToggle(Esp, "Keycard ESP",              "EspKeycard",  function(n) return KEYCARDS[n] end)
CreateESPToggle(Esp, "Currency & Blueprint ESP", "EspCurrency", function(n) return GetCurrencyConfig(n) end)
CreateESPToggle(Esp, "Item ESP",                 "EspItems",    function(n) return GetItemConfig(n) end)

Esp:CreateSection("Monsters")

local lockerConns, lockerActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Void Locker ESP", CurrentValue=false, Flag="EspMonsterLocker",
    Callback=function(Value)
        lockerActive = Value
        local cfg = { label="VOID LOCKER", fill=Color3.fromRGB(200,0,0), outline=Color3.fromRGB(255,80,80), textColor=Color3.fromRGB(255,80,80), fillTransparency=0.3 }
        if Value then
            lockerConns = ScanRooms(
                function() return lockerActive end,
                function(n) return n=="MonsterLocker" and cfg or nil end,
                function(target, config) AddESP(target, config) end
            )
        else
            for _, c in ipairs(lockerConns) do c:Disconnect() end
            lockerConns = {}
            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do
                    if d.Name == "MonsterLocker" then pcall(RemoveESP, d) end
                end
            end
        end
    end
}))

local fakeDoorConns, fakeDoorActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Good People Door ESP", CurrentValue=false, Flag="EspFakeDoor",
    Callback=function(Value)
        fakeDoorActive = Value
        local cfg = { label="GOOD PEOPLE DOOR", fill=Color3.fromRGB(180,0,0), outline=RED, textColor=RED, fillTransparency=0.3 }
        if Value then
            fakeDoorConns = ScanRooms(
                function() return fakeDoorActive end,
                function(n) return n=="Door" and cfg or nil end,
                function(target, config)
                    if target.Parent and target.Parent.Name == "TricksterDoor" then
                        AddESP(target, config)
                    end
                end
            )
        else
            for _, c in ipairs(fakeDoorConns) do c:Disconnect() end
            fakeDoorConns = {}
            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do
                    if d.Name=="Door" and d.Parent and d.Parent.Name=="TricksterDoor" then
                        pcall(RemoveESP, d)
                    end
                end
            end
        end
    end
}))

local generatorConns, generatorActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Generator ESP", CurrentValue=false, Flag="EspGenerator",
    Callback=function(Value)
        generatorActive = Value
        local trackedGenerators = {}

        local function getGeneratorCfg(fixedVal)
            local pct = tonumber(fixedVal) or 0
            if pct >= 100 then return nil end
            local r = math.floor(255 * (1 - pct/100))
            local g = math.floor(255 * (pct/100))
            return {
                label="Generator " .. math.floor(pct) .. "%",
                fill=Color3.fromRGB(r, g, 0),
                outline=Color3.fromRGB(255,200,0),
                textColor=WHITE, fillTransparency=0.3,
            }
        end

        local function setupGenerator(gen)
            if not generatorActive then return end
            if trackedGenerators[gen] then return end
            trackedGenerators[gen] = true
            local fixed = gen:FindFirstChild("Fixed")
            if not fixed then return end
            local proxy = gen:FindFirstChild("ProxyPart") or gen
            local cfg = getGeneratorCfg(fixed.Value)
            if cfg then pcall(AddESP, proxy, cfg) end
            table.insert(generatorConns, fixed:GetPropertyChangedSignal("Value"):Connect(function()
                if not generatorActive then return end
                pcall(RemoveESP, proxy)
                local newCfg = getGeneratorCfg(fixed.Value)
                if newCfg then pcall(AddESP, proxy, newCfg) end
            end))
        end

        local function scanRoom(room)
            for _, d in ipairs(room:GetDescendants()) do
                if not generatorActive then break end
                if d.Name=="PresetGenerator" or d.Name=="Generator" then
                    pcall(setupGenerator, d)
                end
                if d.Name=="Fixed" and d.Parent then
                    pcall(setupGenerator, d.Parent)
                end
            end
        end

        if Value then
            for _, room in ipairs(Rooms:GetChildren()) do
                task.defer(function() scanRoom(room) end)
                table.insert(generatorConns, room.DescendantAdded:Connect(function(d)
                    task.wait(0.2)
                    if not generatorActive then return end
                    if d.Name=="PresetGenerator" or d.Name=="Generator" or d.Name=="Fixed" then
                        pcall(setupGenerator, d.Name=="Fixed" and d.Parent or d)
                    end
                end))
            end
            table.insert(generatorConns, Rooms.ChildAdded:Connect(function(room)
                task.wait(0.3)
                if generatorActive then scanRoom(room) end
                table.insert(generatorConns, room.DescendantAdded:Connect(function(d)
                    task.wait(0.2)
                    if not generatorActive then return end
                    if d.Name=="PresetGenerator" or d.Name=="Generator" or d.Name=="Fixed" then
                        pcall(setupGenerator, d.Name=="Fixed" and d.Parent or d)
                    end
                end))
            end))
        else
            for _, c in ipairs(generatorConns) do c:Disconnect() end
            generatorConns = {}
            trackedGenerators = {}
            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do
                    if d.Name=="PresetGenerator" or d.Name=="Generator" then
                        pcall(RemoveESP, d:FindFirstChild("ProxyPart") or d)
                    end
                end
            end
        end
    end
}))

-- Updated Monster ESP
local monsterEspConns, monsterEspActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Monster ESP", CurrentValue=false, Flag="EspMonster",
    Callback=function(Value)
        monsterEspActive = Value
        local tracked = {}

        local function applyESP(child)
            if not monsterEspActive then return end
            if tracked[child] then return end
            tracked[child] = true
            pcall(AddESP, child, {
                fill=Color3.fromRGB(200,0,0),
                outline=Color3.fromRGB(255,200,0),
                textColor=RED,
                fillTransparency=0.3,
                label="" .. child.Name
            })
            table.insert(monsterEspConns, child.AncestryChanged:Connect(function()
                if not child:IsDescendantOf(game) then
                    pcall(RemoveESP, child)
                    tracked[child] = nil
                end
            end))
        end

        local function scanWorkspace()
            for _, child in ipairs(workspace:GetChildren()) do
                if MONSTERS[child.Name] then applyESP(child) end
            end
        end

        local function listenContainer(container)
            table.insert(monsterEspConns, container.ChildAdded:Connect(function(child)
                if monsterEspActive and MONSTERS[child.Name] then applyESP(child) end
            end))
        end

        if Value then
            scanWorkspace()
            for _, child in ipairs(workspace.GameplayFolder.Monsters:GetChildren()) do
                if MONSTERS[child.Name] then applyESP(child) end
            end
            listenContainer(workspace)
            listenContainer(workspace.GameplayFolder.Monsters)
            
            -- Room Specific Checks for Dwellers / Eyefestation spawning inside Interactables
            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do
                    if MONSTERS[d.Name] then pcall(applyESP, d) end
                end
            end
            table.insert(monsterEspConns, Rooms.DescendantAdded:Connect(function(d)
                if monsterEspActive and MONSTERS[d.Name] then pcall(applyESP, d) end
            end))
        else
            for _, c in ipairs(monsterEspConns) do c:Disconnect() end
            monsterEspConns = {}
            for child, _ in pairs(tracked) do
                pcall(RemoveESP, child)
            end
            tracked = {}
        end
    end
}))

-- Monster Alert 
local monsterAlertConns, monsterAlertActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Entity Alert", CurrentValue=false, Flag="MonsterAlert",
    Callback=function(Value)
        monsterAlertActive = Value
        if Value then
            local function listenContainer(container)
                table.insert(monsterAlertConns, container.ChildAdded:Connect(function(child)
                    if monsterAlertActive and MONSTERS[child.Name] then
                        NotifyOnce(child.Name, "Heads up!", child.Name .. " spawned!", 5, "alert-triangle")
                    end
                end))
            end
            listenContainer(workspace)
            listenContainer(workspace.GameplayFolder.Monsters)
        else
            for _, c in ipairs(monsterAlertConns) do c:Disconnect() end
            monsterAlertConns = {}
        end
    end
}))

Esp:CreateSection("World")

local originalLighting, fullbrightEffects = {}, {}
table.insert(AllToggles, Esp:CreateToggle({
    Name="Fullbright", CurrentValue=false, Flag="Fullbright",
    Callback=function(Value)
        local L = game:GetService("Lighting")
        if Value then
            originalLighting = {
                Brightness=L.Brightness, ClockTime=L.ClockTime,
                FogEnd=L.FogEnd, GlobalShadows=L.GlobalShadows,
                Ambient=L.Ambient, OutdoorAmbient=L.OutdoorAmbient,
            }
            fullbrightEffects = {}
            for _, e in ipairs(L:GetChildren()) do
                if e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then
                    fullbrightEffects[e] = e.Enabled
                    e.Enabled = false
                end
            end
            L.Brightness=10; L.ClockTime=14; L.FogEnd=100000
            L.GlobalShadows=false
            L.Ambient=Color3.fromRGB(255,255,255)
            L.OutdoorAmbient=Color3.fromRGB(255,255,255)
        else
            L.Brightness=originalLighting.Brightness
            L.ClockTime=originalLighting.ClockTime
            L.FogEnd=originalLighting.FogEnd
            L.GlobalShadows=originalLighting.GlobalShadows
            L.Ambient=originalLighting.Ambient
            L.OutdoorAmbient=originalLighting.OutdoorAmbient
            for effect, wasEnabled in pairs(fullbrightEffects) do
                if effect and effect.Parent then effect.Enabled = wasEnabled end
            end
            fullbrightEffects = {}
        end
    end
}))

Esp:CreateSection("Camera")

local originalFOV = nil
local fovSlider = Esp:CreateSlider({
    Name="FOV Changer",
    Range={70, 120},
    Increment=1,
    Suffix="",
    CurrentValue=70,
    Flag="FOVChanger",
    Callback=function(Value)
        if workspace.CurrentCamera then
            if not originalFOV then
                originalFOV = Value
            end
            workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

-- ================================================
-- LOOT AURA
-- ================================================

local lootAuraActive = false
local lootAuraRadius = 15
local lootAuraLoop = nil
local lootAuraCache = {}
local lootAuraLastScan = 0

local function BuildLootCache()
    lootAuraCache = {}
    for _, room in ipairs(Rooms:GetChildren()) do
        for _, desc in ipairs(room:GetDescendants()) do
            if desc:IsA("Model") or desc:IsA("BasePart") then
                local name = desc.Name
                if IsCurrencyOrBlueprint(name) or KEYCARDS[name] then
                    local prompt = desc:FindFirstChildWhichIsA("ProximityPrompt")
                    if not prompt then
                        prompt = desc:FindFirstChildWhichIsA("ClickDetector")
                    end
                    if not prompt then
                        for _, d in ipairs(desc:GetDescendants()) do
                            if d:IsA("ProximityPrompt") then
                                prompt = d
                                break
                            end
                        end
                    end
                    if prompt then
                        if prompt:IsA("ProximityPrompt") then
                            prompt.RequiresLineOfSight = false
                        end
                        
                        table.insert(lootAuraCache, { target = desc, prompt = prompt })
                    end
                end
            end
        end
    end
end

local function CollectNearbyItems()
    local root = GetRootPart()
    if not root then return end

    local now = tick()
    if now - lootAuraLastScan > 4 then
        BuildLootCache()
        lootAuraLastScan = now
    end

    local r = tonumber(lootAuraRadius) or 15

    for _, entry in ipairs(lootAuraCache) do
        if not lootAuraActive then break end
        local prompt = entry.prompt
        if prompt and prompt:IsDescendantOf(workspace) then
            local promptPart = prompt.Parent
            local checkPart = nil
            if promptPart and promptPart:IsA("BasePart") then
                checkPart = promptPart
            elseif prompt:IsA("BasePart") then
                checkPart = prompt
            end
            if checkPart then
                local dist = (root.Position - checkPart.Position).Magnitude
                if dist < r and dist > 0 then
                    pcall(function()
                        if prompt:IsA("ProximityPrompt") then
                            fireproximityprompt(prompt)
                        elseif prompt:IsA("ClickDetector") then
                            fireclickdetector(prompt)
                        end
                    end)
                end
            end
        end
    end
end

local lootAuraSection = Esp:CreateSection("Looting")

table.insert(AllToggles, Esp:CreateToggle({
    Name="Loot Aura",
    CurrentValue=false,
    Flag="LootAura",
    Callback=function(Value)
        lootAuraActive = Value
        if Value then
            NotifyOnce("loot_aura_on", "Loot Aura Enabled", "Collecting items within 15 studs.", 3, "sparkles")
            if not lootAuraLoop then
                lootAuraLoop = RunService.Heartbeat:Connect(function()
                    if lootAuraActive then
                        CollectNearbyItems()
                    end
                end)
            end
        else
            if lootAuraLoop then
                lootAuraLoop:Disconnect()
                lootAuraLoop = nil
            end
        end
    end
}))

-- ================================================
-- ANTI MONSTERS
-- ================================================

Anti:CreateSection("Monsters")

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Eyefestation", CurrentValue=false, Flag="AntiEyefestation",
    Callback=function(Value)
        local conns = {}
        local active = Value
        if Value then
            -- 1. Remove Camera Effect actively
            local function checkCameraEffect()
                if not active then return end
                local cam = workspace.CurrentCamera
                if cam then
                    local eff = cam:FindFirstChild("EyefestationCameraEffect")
                    if eff then pcall(function() eff:Destroy() end) end
                end
            end
            
            checkCameraEffect()
            table.insert(conns, workspace.CurrentCamera.ChildAdded:Connect(function(c)
                if active and c.Name == "EyefestationCameraEffect" then
                    task.wait()
                    pcall(function() c:Destroy() end)
                end
            end))
            table.insert(conns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                if active and workspace.CurrentCamera then
                    checkCameraEffect()
                    table.insert(conns, workspace.CurrentCamera.ChildAdded:Connect(function(c)
                        if active and c.Name == "EyefestationCameraEffect" then
                            task.wait()
                            pcall(function() c:Destroy() end)
                        end
                    end))
                end
            end))

            -- 2. Destroy EyefestHurt Sound in the room interactables
            local function destroyHurt(d)
                if not active then return end
                if d.Name == "EyefestHurt" then pcall(function() d:Destroy() end) end
            end

            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do destroyHurt(d) end
                table.insert(conns, room.DescendantAdded:Connect(function(d)
                    task.wait(0.05)
                    if active then destroyHurt(d) end
                end))
            end
            table.insert(conns, Rooms.ChildAdded:Connect(function(room)
                task.wait(0.3)
                for _, d in ipairs(room:GetDescendants()) do destroyHurt(d) end
                table.insert(conns, room.DescendantAdded:Connect(function(d)
                    task.wait(0.05)
                    if active then destroyHurt(d) end
                end))
            end))
        else
            active = false
            for _, c in ipairs(conns) do c:Disconnect() end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Pandemonium", CurrentValue=false, Flag="RemovePandemonium",
    Callback=function(Value)
        local conn=nil; local active=Value
        if Value then
            for _, child in ipairs(workspace:GetChildren()) do
                if PANDEMONIUM_NAMES[child.Name] then pcall(function() child:Destroy() end) end
            end
            conn = workspace.ChildAdded:Connect(function(child)
                if active and PANDEMONIUM_NAMES[child.Name] then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove WallDweller", CurrentValue=false, Flag="RemoveWallDweller",
    Callback=function(Value)
        local conn=nil; local active=Value
        local WD = { WallDweller=true, MeatWallDweller=true, RottenWallDweller=true, WallDwellers=true }
        if Value then
            for _, child in ipairs(workspace:GetChildren()) do
                if WD[child.Name] then pcall(function() child:Destroy() end) end
            end
            conn = workspace.ChildAdded:Connect(function(child)
                if active and WD[child.Name] then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Bouncer", CurrentValue=false, Flag="RemoveBouncer",
    Callback=function(Value)
        local conn=nil; local active=Value
        local mf = workspace.GameplayFolder.Monsters
        if Value then
            for _, c in ipairs(mf:GetChildren()) do
                if c.Name=="Bouncer" then pcall(function() c:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="Bouncer" then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Skeleton Head", CurrentValue=false, Flag="RemoveSkeletonHead",
    Callback=function(Value)
        local conn=nil; local active=Value
        local mf = workspace.GameplayFolder.Monsters
        if Value then
            for _, c in ipairs(mf:GetChildren()) do
                if c.Name=="SkeletonHead" then pcall(function() c:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="SkeletonHead" then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Statue", CurrentValue=false, Flag="RemoveStatue",
    Callback=function(Value)
        local conn=nil; local active=Value
        local mf = workspace.GameplayFolder.Monsters
        if Value then
            for _, d in ipairs(mf:GetChildren()) do
                if d.Name=="StatueRoot" then pcall(function() d:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="StatueRoot" then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

CreateAntiToggle(Anti,"Remove DiVine",        "RemoveDiVine",       function(n) return n=="DiVine" or n=="DiVineRoot" end)
CreateAntiToggle(Anti,"Remove Searchlights",  "RemoveSearchlights", function(n) return n=="Searchlights" end)
CreateAntiToggle(Anti,"Remove Monster Locker","RemoveMonsterLocker",function(n) return n=="MonsterLocker" end)

Anti:CreateSection("Spawns")
CreateAntiToggle(Anti,"Remove Turrets",  "RemoveTurrets",  function(n) return n=="Turret" or string.match(n,"^TurretSpawn")~=nil end)
CreateAntiToggle(Anti,"Remove Tripwires","RemoveTripwires",function(n) return n=="Tripwire" or n=="TripwireSpawn" end)
CreateAntiToggle(Anti,"Remove Landmines","RemoveLandmines",function(n) return n=="Landmine" or n=="LandmineSpawn" end)

Anti:CreateSection("Encounters")

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Firewall", CurrentValue=false, Flag="RemoveFirewall",
    Callback=function(Value)
        local conn=nil; local active=Value
        if Value then
            local fw = workspace:FindFirstChild("Firewall")
            if fw then fw:Destroy() end
            conn = workspace.ChildAdded:Connect(function(child)
                if active and child.Name=="Firewall" then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

-- ================================================
-- MOVEMENT TAB
-- ================================================
Move:CreateSection("Speed Modification")

local SpeedBoost = 0
local SpeedEnabled = false
local SpeedToggle

SpeedToggle = Move:CreateToggle({
    Name = "Enable Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoostToggle",
    Callback = function(Value)
        SpeedEnabled = Value
    end,
})
table.insert(AllToggles, SpeedToggle)

Move:CreateSlider({
    Name = "Speed Boost Amount",
    Range = {0, 20},
    Increment = 0.25,
    Suffix = " Boost",
    CurrentValue = 0,
    Flag = "SpeedBoostAmount",
    Callback = function(Value)
        SpeedBoost = Value
    end,
})

-- Core Speed Loop
RunService.Stepped:Connect(function()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if hum and hrp then
        if hum.Health <= 0 then
            if SpeedEnabled then
                SpeedEnabled = false
                pcall(function() SpeedToggle:Set(false) end) 
            end
            return
        end
        
        if SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (SpeedBoost / 10))
        end
    end
end)

-- ================================================
-- SETTINGS TAB
-- ================================================

local function UnloadScript()
    pcall(function()
        -- 1. TURN OFF ALL TOGGLES FIRST (Allows callbacks to safely remove ESPs and local connections)
        for _, toggle in ipairs(AllToggles) do
            if toggle and toggle.Set then
                pcall(function() toggle:Set(false) end)
            end
        end
        AllToggles = {}

        -- 2. Stop Loot Aura Loop
        if lootAuraLoop then
            lootAuraLoop:Disconnect()
            lootAuraLoop = nil
        end

        -- 3. Speed Boost variables cleanup
        SpeedEnabled = false
        SpeedBoost = 0

        -- 4. Revert Fullbright
        if originalLighting and originalLighting.Brightness then
            local L = game:GetService("Lighting")
            L.Brightness = originalLighting.Brightness
            L.ClockTime = originalLighting.ClockTime
            L.FogEnd = originalLighting.FogEnd
            L.GlobalShadows = originalLighting.GlobalShadows
            L.Ambient = originalLighting.Ambient
            L.OutdoorAmbient = originalLighting.OutdoorAmbient
            for effect, wasEnabled in pairs(fullbrightEffects) do
                if effect and effect.Parent then effect.Enabled = wasEnabled end
            end
        end

        -- 5. Revert Camera FOV
        if originalFOV and workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = originalFOV
        end

        -- 6. Clean up known global connection tables from the ESP/Antis (Failsafe)
        local allConnTables = {
            lockerConns, fakeDoorConns, generatorConns,
            monsterEspConns, monsterAlertConns
        }
        for _, tbl in ipairs(allConnTables) do
            if tbl then
                for _, c in ipairs(tbl) do
                    if typeof(c) == "RBXScriptConnection" then
                        c:Disconnect()
                    end
                end
            end
        end

         -- 7. Wipe all leftover ESPs globally (Highlights and ESP_Labels) (Failsafe)
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc:IsA("Highlight") or (desc:IsA("BillboardGui") and desc.Name == "ESP_Label") then
                desc:Destroy()
            end
        end

        -- 8. Destroy the Rayfield UI
        Rayfield:Destroy()
    end)
end

Settings:CreateSection("Script Cleanup")
Settings:CreateButton({
    Name = "Unload & Destroy Script",
    Callback = function()
        UnloadScript()
    end,
})

Rayfield:LoadConfiguration()
