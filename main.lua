-- FRAMEWORK SETUP
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local GuiParent = (gethui and gethui()) or game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
local ExistingGui = GuiParent:FindFirstChild("PressureCustomGUI")
if ExistingGui then ExistingGui:Destroy() end
local CustomGui = Instance.new("ScreenGui")
CustomGui.Name = "PressureCustomGUI"
CustomGui.ResetOnSpawn = false
CustomGui.Parent = GuiParent

-- NOTIFICATION CONTAINER
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 350, 1, -20)
NotifContainer.Position = UDim2.new(1, -360, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ClipsDescendants = false
NotifContainer.Parent = CustomGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.Parent = NotifContainer

local function ShowNotification(title, content, duration)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 80)
    wrapper.BackgroundTransparency = 1
    wrapper.ClipsDescendants = false
    wrapper.Parent = NotifContainer

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 1, 0)
    card.Position = UDim2.new(1, 60, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(12, 22, 45)
    card.BorderSizePixel = 0
    card.Parent = wrapper

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 60, 120)
    stroke.Thickness = 1.5
    stroke.Parent = card

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -24, 0, 24)
    tLbl.Position = UDim2.new(0, 12, 0, 8)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = Enum.Font.GothamBold
    tLbl.Text = title
    tLbl.TextColor3 = Color3.fromRGB(200, 225, 255)
    tLbl.TextSize = 16
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local cLbl = Instance.new("TextLabel")
    cLbl.Size = UDim2.new(1, -24, 0, 40)
    cLbl.Position = UDim2.new(0, 12, 0, 32)
    cLbl.BackgroundTransparency = 1
    cLbl.Font = Enum.Font.Gotham
    cLbl.Text = content
    cLbl.TextColor3 = Color3.fromRGB(150, 190, 255)
    cLbl.TextSize = 13
    cLbl.TextWrapped = true
    cLbl.TextXAlignment = Enum.TextXAlignment.Left
    cLbl.Parent = card

    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(duration or 3, function()
        if wrapper and wrapper.Parent then
            local tw = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 60, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function()
                if wrapper and wrapper.Parent then wrapper:Destroy() end
            end)
        end
    end)
end

-- MAIN CANVAS FRAME
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 330)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -165)
MainFrame.GroupTransparency = 1
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 18, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = CustomGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 65, 130)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- ANIMATION CONTROLLER
local isAnimating = false
local function OpenUI()
    if isAnimating or MainFrame.Visible then return end
    isAnimating = true
    MainFrame.Size = UDim2.new(0, 480, 0, 330)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -165)
    MainFrame.GroupTransparency = 1
    MainFrame.Visible = true
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 520, 0, 360),
        Position = UDim2.new(0.5, -260, 0.5, -180),
        GroupTransparency = 0
    })
    tw:Play()
    tw.Completed:Connect(function() isAnimating = false end)
end

local function CloseUI(onComplete)
    if isAnimating or not MainFrame.Visible then return end
    isAnimating = true
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 480, 0, 330),
        Position = UDim2.new(0.5, -240, 0.5, -165),
        GroupTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        MainFrame.Visible = false
        isAnimating = false
        if onComplete then onComplete() end
    end)
end

-- TOPBAR & DRAG LOGIC
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 35)
Topbar.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
Topbar.BorderSizePixel = 0
Topbar.Active = true
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 8)
TopbarCorner.Parent = Topbar

local TopbarTitle = Instance.new("TextLabel")
TopbarTitle.Size = UDim2.new(1, -50, 1, 0)
TopbarTitle.Position = UDim2.new(0, 12, 0, 0)
TopbarTitle.BackgroundTransparency = 1
TopbarTitle.Font = Enum.Font.GothamBold
TopbarTitle.Text = "Pressure Test Script - Pressure 0.8"
TopbarTitle.TextColor3 = Color3.fromRGB(200, 225, 255)
TopbarTitle.TextSize = 13
TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
TopbarTitle.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    CloseUI()
end)

local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- TAB BAR & CONTENT CONTAINER
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 110, 1, -45)
TabBar.Position = UDim2.new(0, 8, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 28, 58)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 6)
TabBarCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabBar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -134, 1, -45)
ContentContainer.Position = UDim2.new(0, 124, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local FirstTab = true

-- TAB GENERATOR
local function CreateTab(tabName)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(40, 90, 180)
    page.Visible = FirstTab
    page.Parent = ContentContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
    end)

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = FirstTab and Color3.fromRGB(40, 90, 180) or Color3.fromRGB(20, 35, 70)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextColor3 = FirstTab and Color3.fromRGB(220, 235, 255) or Color3.fromRGB(150, 190, 255)
    tabBtn.TextSize = 12
    tabBtn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 35, 70), TextColor3 = Color3.fromRGB(150, 190, 255)}):Play()
        end
        page.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 90, 180), TextColor3 = Color3.fromRGB(220, 235, 255)}):Play()
    end)

    FirstTab = false

    local tabObj = { Page = page, Button = tabBtn }
    function tabObj:CreateSection(secName)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -8, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = "  " .. secName
        lbl.TextColor3 = Color3.fromRGB(70, 150, 255)
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = page
    end

    function tabObj:CreateToggle(options)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -8, 0, 32)
        frame.BackgroundColor3 = Color3.fromRGB(15, 28, 58)
        frame.BorderSizePixel = 0
        frame.Parent = page

        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(0, 4)
        fCorner.Parent = frame

        local fStroke = Instance.new("UIStroke")
        fStroke.Color = Color3.fromRGB(35, 65, 130)
        fStroke.Thickness = 1
        fStroke.Parent = frame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -50, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.Text = options.Name
        lbl.TextColor3 = Color3.fromRGB(200, 225, 255)
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 34, 0, 18)
        box.Position = UDim2.new(1, -42, 0.5, -9)
        box.BackgroundColor3 = options.CurrentValue and Color3.fromRGB(40, 110, 220) or Color3.fromRGB(40, 55, 90)
        box.Parent = frame

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(1, 0)
        boxCorner.Parent = box

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = options.CurrentValue and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.Parent = box

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        local toggleObj = { Value = options.CurrentValue or false }
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame

        function toggleObj:Set(v)
            toggleObj.Value = v
            local twInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(box, twInfo, {BackgroundColor3 = v and Color3.fromRGB(40, 110, 220) or Color3.fromRGB(40, 55, 90)}):Play()
            TweenService:Create(dot, twInfo, {Position = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
            if options.Callback then options.Callback(v) end
        end

        btn.MouseButton1Click:Connect(function()
            toggleObj:Set(not toggleObj.Value)
        end)
        return toggleObj
    end

    function tabObj:CreateSlider(options)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -8, 0, 42)
        frame.BackgroundColor3 = Color3.fromRGB(15, 28, 58)
        frame.BorderSizePixel = 0
        frame.Parent = page

        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(0, 4)
        fCorner.Parent = frame

        local fStroke = Instance.new("UIStroke")
        fStroke.Color = Color3.fromRGB(35, 65, 130)
        fStroke.Thickness = 1
        fStroke.Parent = frame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 0, 18)
        lbl.Position = UDim2.new(0, 10, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.Text = options.Name
        lbl.TextColor3 = Color3.fromRGB(200, 225, 255)
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.35, 0, 0, 18)
        valLbl.Position = UDim2.new(0.65, -10, 0, 4)
        valLbl.BackgroundTransparency = 1
        valLbl.Font = Enum.Font.GothamBold
        valLbl.Text = tostring(options.CurrentValue) .. (options.Suffix or "")
        valLbl.TextColor3 = Color3.fromRGB(150, 190, 255)
        valLbl.TextSize = 11
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = frame

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(1, -20, 0, 8)
        barBg.Position = UDim2.new(0, 10, 0, 26)
        barBg.BackgroundColor3 = Color3.fromRGB(30, 55, 90)
        barBg.Parent = frame

        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(1, 0)
        barCorner.Parent = barBg

        local minV, maxV = options.Range[1], options.Range[2]
        local currentVal = options.CurrentValue or minV
        local pct = math.clamp((currentVal - minV) / (maxV - minV), 0, 1)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(pct, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
        fill.Parent = barBg

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        local dragging = false
        local function UpdateSlider(input)
            local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            local rawVal = minV + pos * (maxV - minV)
            local inc = options.Increment or 1
            local val = math.floor(rawVal / inc + 0.5) * inc
            val = math.clamp(val, minV, maxV)
            TweenService:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new((val - minV) / (maxV - minV), 0, 1, 0)}):Play()
            valLbl.Text = tostring(val) .. (options.Suffix or "")
            if options.Callback then options.Callback(val) end
        end

        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                UpdateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider(input)
            end
        end)

        return { Set = function(_, v)
            v = math.clamp(v, minV, maxV)
            TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new((v - minV) / (maxV - minV), 0, 1, 0)}):Play()
            valLbl.Text = tostring(v) .. (options.Suffix or "")
            if options.Callback then options.Callback(v) end
        end }
    end

    function tabObj:CreateButton(options)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(25, 48, 100)
        btn.Font = Enum.Font.GothamBold
        btn.Text = options.Name
        btn.TextColor3 = Color3.fromRGB(200, 225, 255)
        btn.TextSize = 11
        btn.Parent = page

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(40, 75, 150)
        stroke.Thickness = 1
        stroke.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if options.Callback then options.Callback() end
        end)
    end

    table.insert(Tabs, tabObj)
    return tabObj
end

-- KEYBIND & CHARACTER CLEANUP
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        if MainFrame.Visible then
            CloseUI()
        else
            OpenUI()
        end
    end
end)

local AllToggles = {}
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
CleanupCharacter(Player.Character)
Player.CharacterAdded:Connect(CleanupCharacter)

-- TAB INSTANTIATION
local Esp  = CreateTab("Visuals")
local Anti = CreateTab("Antis")
local Move = CreateTab("Move")
local Settings = CreateTab("Set")

local WHITE     = Color3.fromRGB(255, 255, 255)
local RED       = Color3.fromRGB(255, 0, 0)
local Rooms     = workspace.GameplayFolder.Rooms

-- CONFIGS
local KEYCARDS = {
    NormalKeyCard = { label = "Keycard",       fill = Color3.fromRGB(255, 50,  50),  outline = Color3.fromRGB(255, 150, 150) },
    InnerKeyCard  = { label = "Inner Keycard", fill = Color3.fromRGB(0,   120, 255), outline = Color3.fromRGB(100, 180, 255) },
    RidgeKeyCard  = { label = "Ridge Keycard", fill = Color3.fromRGB(255, 150, 0),   outline = Color3.fromRGB(255, 200, 100) },
    PasswordPaper = { label = "Password",      fill = Color3.fromRGB(0,   200, 80),  outline = Color3.fromRGB(100, 255, 150) },
}

local ITEM_PATTERNS = {
    { pattern = "Lantern",      label = "Lantern",       fill = Color3.fromRGB(255, 200, 0),  outline = Color3.fromRGB(255, 230, 100) },
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

local MONSTERS = {
    A200=true, A60=true, Angler=true, Bleach=true, Bottomfeeder=true, Bouncers=true, CandleBearers=true, CandleBrutes=true,
    Eyefestation=true, Harbinger=true, DeathAngel=true, FriendPart=true, LopeePart=true, Pandemonium=true, Parasite=true,
    Pipsqueak=true, Rebarb=true, Redeemer=true, Skelepede=true, Stan=true, Divineroot=true, TheEducator=true, TheMindscape=true,
    Painter=true, Saboteur=true, WitchingHour=true, Blitz=true, Squiddles=true, NaviAI=true, RottenCoral=true, Searchlights=true,
    DefenseSystem=true, Froger=true, Chainsmoker=true, Pinkie=true, WallDweller=true, MeatWallDweller=true, RottenWallDweller=true,
    Bouncer=true, SkeletonHead=true, NoGood=true, Coagulate=true, EdenTree=true, Weeper=true, DiVineRoot=true, DwellerModel=true,
    StatueHead=true, StatueRoot=true, RidgeAngler=true, RidgeChainsmoker=true, RidgePinkie=true, RidgeBlitz=true, RidgeFroger=true,
    RidgePandemonium=true, Anglemonium=true, Frogermonium=true, Blitzemonium=true, Pandesmoker=true, Pinkimonium=true
}

local PANDEMONIUM_NAMES = {
    Pandemonium=true, Anglemonium=true, Frogermonium=true, Blitzemonium=true, Pandesmoker=true, Pinkimonium=true, RidgePandemonium=true
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

-- HELPERS
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
    ShowNotification(title, content, duration)
end

-- ESP FUNCTIONS AND RANGE MANAGEMENT
local ESP_RANGES = { Stuff = 1000, Room = 1000, Monster = 1000 }
local ActiveESPs = {}

local espDistanceLoop = RunService.Heartbeat:Connect(function()
    local root = GetRootPart()
    if not root then return end
    for i = #ActiveESPs, 1, -1 do
        local esp = ActiveESPs[i]
        if not esp.Part or not esp.Part.Parent then
            table.remove(ActiveESPs, i)
        else
            local pivot = esp.Part:GetPivot()
            if pivot then
                local dist = (pivot.Position - root.Position).Magnitude
                local maxDist = ESP_RANGES[esp.Category] or 1000
                local inRange = dist <= maxDist
                if esp.Highlight then esp.Highlight.Enabled = inRange end
                if esp.Billboard then esp.Billboard.Enabled = inRange end
            end
        end
    end
end)

local NODE_MONSTERS = {
    Pandemonium = true, Anglemonium = true, Frogermonium = true, Blitzemonium = true, 
    Pandesmoker = true, Pinkimonium = true, RidgePandemonium = true, Harbinger = true,
    A200 = true, A60 = true, Bleach = true, Pipsqueak = true,
    Angler = true, Froger = true, Chainsmoker = true, Pinkie = true, Blitz = true,
    RidgeAngler = true, RidgeFroger = true, RidgeChainsmoker = true, RidgePinkie = true, RidgeBlitz = true
}

local function AddESP(part, config, category)
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

    local espEntry = {Part = part, Highlight = h, Billboard = bb, Category = category or "Stuff"}
    table.insert(ActiveESPs, espEntry)
end

local function RemoveESP(part)
    if not part then return end
    local h = part:FindFirstChildOfClass("Highlight")
    if h then h:Destroy() end
    local b = part:FindFirstChild("ESP_Label")
    if b then b:Destroy() end
    
    for i = #ActiveESPs, 1, -1 do
        if ActiveESPs[i].Part == part then
            table.remove(ActiveESPs, i)
            break
        end
    end
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

local function CreateESPToggle(tab, name, flag, matchFn, category)
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
                        AddESP(target, config, category)
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

-- VISUALS TAB
Esp:CreateSection("Stuff ESP")
CreateESPToggle(Esp, "Keycard ESP",              "EspKeycard",  function(n) return KEYCARDS[n] end, "Stuff")
CreateESPToggle(Esp, "Currency & Blueprint ESP", "EspCurrency", function(n) return GetCurrencyConfig(n) end, "Stuff")
CreateESPToggle(Esp, "Item ESP",                 "EspItems",    function(n) return GetItemConfig(n) end, "Stuff")

Esp:CreateSlider({
    Name = "Stuff ESP Range",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "s",
    CurrentValue = 1000,
    Flag = "StuffRangeSlider",
    Callback = function(val)
        ESP_RANGES.Stuff = val
    end
})

Esp:CreateSection("Room ESP")
local DoorConns, DoorActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Door ESP", CurrentValue=false, Flag="EspDoor",
    Callback=function(Value)
        DoorActive = Value
        local cfg = { label="EXIT DOOR", fill=Color3.fromRGB(0, 200, 100), outline=Color3.fromRGB(80, 255, 160), textColor=Color3.fromRGB(80, 255, 160), fillTransparency=0.3 }
        if Value then
            DoorConns = ScanRooms(
                function() return DoorActive end,
                function(n) return n=="NormalDoor" and cfg or nil end,
                function(target, config)
                    if target:IsA("BasePart") then
                        AddESP(target, config, "Room")
                    end
                end
            )
        else
            for _, c in ipairs(DoorConns) do c:Disconnect() end
            DoorConns = {}
            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do
                    if d.Name=="NormalDoor" and d:IsA("BasePart") then
                        pcall(RemoveESP, d)
                    end
                end
            end
        end
    end
}))

local lockerConns, lockerActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Void Locker ESP", CurrentValue=false, Flag="EspMonsterLocker",
    Callback=function(Value)
        lockerActive = Value
        local cfg = { label="VOID LOCKER", fill=Color3.fromRGB(200,0,0), outline=GREEN, textColor=GREEN, fillTransparency=0.3 }
        if Value then
            lockerConns = ScanRooms(
                function() return lockerActive end,
                function(n) return n=="MonsterLocker" and cfg or nil end,
                function(target, config) AddESP(target, config, "Room") end
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
                        AddESP(target, config, "Room")
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
            if cfg then pcall(AddESP, proxy, cfg, "Room") end
            table.insert(generatorConns, fixed:GetPropertyChangedSignal("Value"):Connect(function()
                if not generatorActive then return end
                pcall(RemoveESP, proxy)
                local newCfg = getGeneratorCfg(fixed.Value)
                if newCfg then pcall(AddESP, proxy, newCfg, "Room") end
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

Esp:CreateSlider({
    Name = "Room ESP Range",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "s",
    CurrentValue = 1000,
    Flag = "RoomRangeSlider",
    Callback = function(val)
        ESP_RANGES.Room = val
    end
})

Esp:CreateSection("Monster ESP")
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
            }, "Monster")
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

Esp:CreateSlider({
    Name = "Monster ESP Range",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "s",
    CurrentValue = 1000,
    Flag = "MonsterRangeSlider",
    Callback = function(val)
        ESP_RANGES.Monster = val
    end
})

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
Esp:CreateSlider({
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

-- LOOT AURA
local lootAuraActive = false
local lootAuraRadius = 4
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
    if now - lootAuraLastScan > 2 then
        BuildLootCache()
        lootAuraLastScan = now
    end
    for _, entry in ipairs(lootAuraCache) do
        if not lootAuraActive then break end
        local prompt = entry.prompt
        if prompt and prompt:IsDescendantOf(workspace) then
            if prompt:IsA("ProximityPrompt") and not prompt.Enabled then
                continue 
            end
            local promptPart = prompt.Parent
            local checkPart = nil
            if promptPart and promptPart:IsA("BasePart") then
                checkPart = promptPart
            elseif prompt:IsA("BasePart") then
                checkPart = prompt
            end
            if checkPart then
                local dist = (root.Position - checkPart.Position).Magnitude
                if dist <= lootAuraRadius and dist > 0 then
                    pcall(function()
                        if prompt:IsA("ProximityPrompt") then
                            local oldSight = prompt.RequiresLineOfSight
                            local oldHold = prompt.HoldDuration
                            if dist <= 10 then
                                prompt.RequiresLineOfSight = false
                            end
                            prompt.HoldDuration = 0
                            fireproximityprompt(prompt)
                            task.wait()
                            prompt.HoldDuration = oldHold
                            prompt.RequiresLineOfSight = oldSight
                        elseif prompt:IsA("ClickDetector") then
                            fireclickdetector(prompt)
                        end
                    end)
                end
            end
        end
    end
end

Esp:CreateSection("Looting")
table.insert(AllToggles, Esp:CreateToggle({
    Name="Loot Aura (3 Studs)",
    CurrentValue=false,
    Flag="LootAura",
    Callback=function(Value)
        lootAuraActive = Value
        if Value then
            NotifyOnce("loot_aura_on", "Loot Aura Enabled", "Collecting items strictly within 3 studs.", 3, "sparkles")
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

-- ANTI MONSTERS
Anti:CreateSection("Monsters")
table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Eyefestation", CurrentValue=false, Flag="AntiEyefestation",
    Callback=function(Value)
        local conns = {}
        local active = Value
        if Value then
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
        local mf = workspace.GameplayFolder.Monsters
        if Value then
            for _, c in ipairs(mf:GetChildren()) do
                if c.Name=="DiVineRoot" then pcall(function() c:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="DiVineRoot" then pcall(function() child:Destroy() end) end
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

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove CementShoesBeta", CurrentValue=false, Flag="RemoveCementShoesBeta",
    Callback=function(Value)
        local conn=nil; local active=Value
        local mf = workspace.MoonAnimator2Saves
        if Value then
            for _, d in ipairs(mf:GetChildren()) do
                if d.Name=="cement_shoes_killanimation" then pcall(function() d:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="cement_shoes_killanimation" then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove CouagolateBeta", CurrentValue=false, Flag="RemoveCouagolateBeta",
    Callback=function(Value)
        local conn=nil; local active=Value
        local mf = workspace.GameplayFolder.Characters
        if Value then
            for _, d in ipairs(mf:GetChildren()) do
                if d.Name=="Couagulant" then pcall(function() d:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="Couagulant" then pcall(function() child:Destroy() end) end
            end)
        else
            active=false
            if conn then conn:Disconnect(); conn=nil end
        end
    end
}))

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove EdenTreesBeta", CurrentValue=false, Flag="RemoveEdenTreesBeta",
    Callback=function(Value)
        local conn=nil; local active=Value
        local mf = workspace.GameplayFolder.Characters
        if Value then
            for _, d in ipairs(mf:GetChildren()) do
                if d.Name=="EdenTrees" then pcall(function() d:Destroy() end) end
            end
            conn = mf.ChildAdded:Connect(function(child)
                if active and child.Name=="EdenTrees" then pcall(function() child:Destroy() end) end
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

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Squiddles", CurrentValue=false, Flag="RemoveSquiddles",
    Callback=function(Value)
        local active = Value
        if Value then
            task.spawn(function()
                while active do
                    for _,object in pairs(workspace:GetDescendants()) do
                        if object.Name == "SquiddleBuildup" and object.Parent and object.Parent.Name == "Face" then
                            local face = object.Parent
                            local Squiddle = face.Parent
                            if Squiddle then
                                pcall(function() Squiddle:Destroy() end)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            active = false
        end
    end}))

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

-- MOVEMENT TAB
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

-- SETTINGS TAB
local function UnloadScript()
    CloseUI(function()
        pcall(function()
            for _, toggle in ipairs(AllToggles) do
                if toggle and toggle.Set then
                    pcall(function() toggle:Set(false) end)
                end
            end
            AllToggles = {}
            if lootAuraLoop then
                lootAuraLoop:Disconnect()
                lootAuraLoop = nil
            end
            if espDistanceLoop then 
                espDistanceLoop:Disconnect() 
                espDistanceLoop = nil 
            end
            ActiveESPs = {}
            SpeedEnabled = false
            SpeedBoost = 0
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
            if originalFOV and workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = originalFOV
            end
            local allConnTables = {
                lockerConns, fakeDoorConns, generatorConns, DoorConns,
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
            for _, desc in ipairs(workspace:GetDescendants()) do
                if desc:IsA("Highlight") or (desc:IsA("BillboardGui") and desc.Name == "ESP_Label") then
                    desc:Destroy()
                end
            end
            CustomGui:Destroy()
        end)
    end)
end

Settings:CreateSection("Script Cleanup")
Settings:CreateButton({
    Name = "Unload & Destroy Script",
    Callback = function()
        UnloadScript()
    end,
})

-- INITIAL LAUNCH
OpenUI()
