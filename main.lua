-- FRAMEWORK SETUP
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local function RoomWarning()
    local playerGui = Player:FindFirstChildOfClass("PlayerGui")
    if not playerGui then
        warn("This game isn't supported brah.")
        return
    end

    local warningGui = Instance.new("ScreenGui")
    warningGui.Name = "RoomWarning"
    warningGui.ResetOnSpawn = false
    warningGui.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 350, 0, 60)
    label.Position = UDim2.new(0.5, -175, 0, 20)
    label.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
    label.TextColor3 = Color3.fromRGB(255, 100, 100)
    label.Text = "Hey Skid, This game isn't supported brah."
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = warningGui
    task.delay(5, function()
        if warningGui then
            warningGui:Destroy()
        end
    end)
end

local GameplayFolder = workspace:WaitForChild("GameplayFolder", 10)
local Rooms = GameplayFolder and GameplayFolder:WaitForChild("Rooms", 10)
if not Rooms then
    RoomWarning()
    return
end

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
TopbarTitle.Text = "Pressure Custom Script GUI"
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

local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
        valLbl.Text = tostring(options.CurrentValue or options.Range[1]) .. (options.Suffix or "")
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

        local isDragging = false
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
                isDragging = true
                UpdateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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

    function tabObj:CreateKeybind(options)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(15, 28, 58)
    frame.BorderSizePixel = 0
    frame.Parent = page

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 4)
    fCorner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.Text = options.Name
    lbl.TextColor3 = Color3.fromRGB(200, 225, 255)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 60, 0, 20)
    bindBtn.Position = UDim2.new(1, -68, 0.5, -10)
    bindBtn.BackgroundColor3 = Color3.fromRGB(25, 48, 100)
    bindBtn.Font = Enum.Font.GothamBold
    bindBtn.Text = options.CurrentKeybind or "None"
    bindBtn.TextColor3 = Color3.fromRGB(200, 225, 255)
    bindBtn.TextSize = 11
    bindBtn.Parent = frame

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = bindBtn

    local listening = false
    bindBtn.MouseButton1Click:Connect(function()
        listening = true
        bindBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            bindBtn.Text = input.KeyCode.Name
            if options.Callback then options.Callback(input.KeyCode) end
        end
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
        hum.JumpPower = 0
    end
end
CleanupCharacter(Player.Character)
Player.CharacterAdded:Connect(CleanupCharacter)

-- TAB INSTANTIATION
local Esp  = CreateTab("Visuals")
local Anti = CreateTab("Antis")
local Auto = CreateTab("Auto")
local Move = CreateTab("Move")
local Settings = CreateTab("Set")

local WHITE     = Color3.fromRGB(255, 255, 255)
local RED       = Color3.fromRGB(255, 0, 0)

-- CONFIGS
local KEYCARDS = {
    NormalKeyCard = { label = "Keycard",       fill = Color3.fromRGB(0, 0,  255),  outline = Color3.fromRGB(255, 150, 150) },
    InnerKeyCard  = { label = "Inner Keycard", fill = Color3.fromRGB(0,   120, 255), outline = Color3.fromRGB(100, 180, 255) },
    PurpleKeyCard = { label = "Purple Keycard",fill = Color3.fromRGB(170, 0,   255), outline = Color3.fromRGB(210, 100, 255) },
    RidgeKeyCard  = { label = "Ridge Keycard", fill = Color3.fromRGB(255, 160, 0),   outline = Color3.fromRGB(255, 200, 100) },
    PasswordPaper = { label = "Password",      fill = Color3.fromRGB(255, 255, 255), outline = Color3.fromRGB(220, 220, 220) },
}

local ITEM_PATTERNS = {
    { pattern = "Lantern",      label = "Lantern",       fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "Flashlight",   label = "Flashlight",    fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "Blacklight",   label = "Blacklight",    fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "FlashBeacon",  label = "Flash Beacon",  fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "Gummylight",   label = "Gummylight",    fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "WindupLight",  label = "Windup Light",  fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "Battery",      label = "Battery",       fill = Color3.fromRGB(255, 230, 0),   outline = Color3.fromRGB(255, 245, 120) },
    { pattern = "Medkit",       label = "Medkit",        fill = Color3.fromRGB(0,   255, 100), outline = Color3.fromRGB(120, 255, 170) },
    { pattern = "HealthBoost",  label = "Health Boost",  fill = Color3.fromRGB(0,   255, 100), outline = Color3.fromRGB(120, 255, 170) },
    { pattern = "Defib",        label = "Defib",         fill = Color3.fromRGB(0,   255, 100), outline = Color3.fromRGB(120, 255, 170) },
    { pattern = "SPRINT",       label = "SPRINT",        fill = Color3.fromRGB(100, 220, 255), outline = Color3.fromRGB(180, 240, 255) },
    { pattern = "[Nn]eostyk",   label = "NeoStyk",       fill = Color3.fromRGB(100, 220, 255), outline = Color3.fromRGB(180, 240, 255) },
    { pattern = "Scanner",      label = "Scanner",       fill = Color3.fromRGB(255, 50,  50),  outline = Color3.fromRGB(255, 150, 150) },
    { pattern = "CodeBreacher", label = "Code Breacher", fill = Color3.fromRGB(255, 0,  0),  outline = Color3.fromRGB(255, 150, 150) },
    { pattern = "^Book$",       label = "Book",          fill = Color3.fromRGB(180, 120, 40),  outline = Color3.fromRGB(220, 170, 100) },
    { pattern = "ToyRemote",    label = "Toy Remote",    fill = Color3.fromRGB(100, 100, 255), outline = Color3.fromRGB(180, 180, 255) },
}

local MONSTERS = {
    A200=true, A60=true, Angler=true, Bleach=true, Bottomfeeder=true, Bouncers=true, CandleBearers=true, CandleBrutes=true,
    Eyefestation=true, Eyefest=true, Harbinger=true, DeathAngel=true, LopeePart=true, Pandemonium=true, Parasite=true, Mirage=true,
    Pipsqueak=true, Rebarb=true, Redeemer=true, Skelepede=true, Stan=true, Divineroot=true, TheEducator=true, TheMindscape=true,
    Painter=true, Saboteur=true, WitchingHour=true, Blitz=true, Squiddles=true, NaviAI=true, RottenCoral=true, Searchlights=true,
    DefenseSystem=true, Froger=true, Chainsmoker=true, Pinkie=true, WallDweller=true, MeatWallDweller=true, RottenWallDweller=true,
    Bouncer=true, SkeletonHead=true, NoGood=true, Coagulant=true, TreeBody=true, Coagulate=true, DiVineRoot=true, DwellerModel=true,
    StatueHead=true, StatueRoot=true, RidgeAngler=true, RidgeChainsmoker=true, RidgePinkie=true, RidgeBlitz=true, RidgeFroger=true,
    RidgePandemonium=true, Anglemonium=true, Frogermonium=true, Blitzemonium=true, Pandesmoker=true, Pinkimonium=true, DamageParts=true
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

local lastNotify = {}
local function NotifyOnce(key, title, content, duration, cooldown)
    cooldown = cooldown or 8
    if lastNotify[key] and (tick() - lastNotify[key]) < cooldown then return end
    lastNotify[key] = tick()
    ShowNotification(title, content, duration)
end

-- ESP FUNCTIONS AND RANGE MANAGEMENT
local ESP_RANGES = { Stuff = 1000, Room = 1000, Monster = 1000, Player = math.huge }
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
                if esp.Highlight and esp.Highlight.Parent then esp.Highlight.Enabled = inRange end
                if esp.Billboard and esp.Billboard.Parent then esp.Billboard.Enabled = inRange end
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
    lbl.Text = config.label or part.Name
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = config.textColor or WHITE
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.3
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = bb

    if useCircle then
        bb.Size = UDim2.new(0, 100, 0, 100) 
        bb.StudsOffset = Vector3.new(0, 4, 0)
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


-- VISUALS TAB
Esp:CreateSection("Stuff ESP")
-- ITEM ESP HANDLER
local itemESPConns, itemESPActive = {}, false
local itemESPTargets = {}

table.insert(AllToggles, Esp:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Flag = "EspItems",

    Callback = function(Value)
        itemESPActive = Value

        for _, c in ipairs(itemESPConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        table.clear(itemESPConns)

        for proxy in pairs(itemESPTargets) do
            pcall(RemoveESP, proxy)
        end
        table.clear(itemESPTargets)

        if not Value then return end

        local seen = {}

        local function addItem(item, proxy)
            if not item or not item.Parent or not proxy or not proxy.Parent then return end
            if seen[proxy] then return end

            local cfg = GetItemConfig(item.Name)
            if not cfg then return end

            seen[proxy] = true

            AddESP(proxy, {
                label = cfg.label or item.Name,
                fill = cfg.fill,
                outline = cfg.outline or WHITE,
                textColor = cfg.textColor or WHITE,
                fillTransparency = 0.3
            }, "Stuff")

            itemESPTargets[proxy] = true
        end

        local function scanNormalContainer(container)
            if not container then return end
            for _, d in ipairs(container:GetDescendants()) do
                if not itemESPActive then return end
                local proxy = d:IsA("BasePart") and d.Name == "ProxyPart" and d or nil
                if proxy and proxy.Parent then
                    addItem(proxy.Parent, proxy)
                end
            end
        end

        local function scanDroppedContainer(container)
            if not container then return end
            for _, d in ipairs(container:GetDescendants()) do
                if not itemESPActive then return end
                if d:IsA("BasePart") and d.Name == "ProxyPart" then
                    local item = d.Parent
                    if item then addItem(item, d) end
                end
            end
        end

        scanNormalContainer(Rooms)

        for _, room in ipairs(Rooms:GetChildren()) do
            table.insert(itemESPConns, room.DescendantAdded:Connect(function(d)
                if not itemESPActive then return end
                if d:IsA("BasePart") and d.Name == "ProxyPart" then
                    task.defer(function()
                        if itemESPActive then addItem(d.Parent, d) end
                    end)
                end
            end))
        end

        table.insert(itemESPConns, Rooms.ChildAdded:Connect(function(room)
            task.defer(function()
                if itemESPActive then
                    scanNormalContainer(room)
                    table.insert(itemESPConns, room.DescendantAdded:Connect(function(d)
                        if not itemESPActive then return end
                        if d:IsA("BasePart") and d.Name == "ProxyPart" then
                            task.defer(function()
                                if itemESPActive then addItem(d.Parent, d) end
                            end)
                        end
                    end))
                end
            end)
        end))

        local droppedContainers = {
            GameplayFolder and GameplayFolder:FindFirstChild("DroppedItems"),
            workspace:FindFirstChild("DroppedItems")
        }

        for _, dropped in ipairs(droppedContainers) do
            scanDroppedContainer(dropped)

            table.insert(itemESPConns, dropped.DescendantAdded:Connect(function(d)
                if not itemESPActive then return end
                if d:IsA("BasePart") and d.Name == "ProxyPart" then
                    task.defer(function()
                        if itemESPActive then addItem(d.Parent, d) end
                    end)
                end
            end))
        end

        -- Listen for workspace.DroppedItems if it is created dynamically after activation
        table.insert(itemESPConns, workspace.ChildAdded:Connect(function(child)
            if child.Name == "DroppedItems" and itemESPActive then
                scanDroppedContainer(child)
                table.insert(itemESPConns, child.DescendantAdded:Connect(function(d)
                    if not itemESPActive then return end
                    if d:IsA("BasePart") and d.Name == "ProxyPart" then
                        task.defer(function()
                            if itemESPActive then addItem(d.Parent, d) end
                        end)
                    end
                end))
            end
        end))
    end
}))

-- ESP TOGGLE FACTORY
local function CreateESPToggle(tab, name, flag, matchFn, category)
    local connections = {}
    local active = false
    local targets = {}
    local tgl = tab:CreateToggle({
        Name = name, CurrentValue = false, Flag = flag,
        Callback = function(Value)
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

-- ANTI TOGGLE FACTORY
local function CreateAntiToggle(tab, name, flag, matchFn)
    local conns  = {}
    local active = false
    local tgl = tab:CreateToggle({
        Name = name, CurrentValue = false, Flag = flag,
        Callback = function(Value)
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

CreateESPToggle(Esp, "Keycard ESP",              "EspKeycard",  function(n) return KEYCARDS[n] end, "Stuff")
CreateESPToggle(Esp, "Currency & Blueprint ESP", "EspCurrency", function(n) return GetCurrencyConfig(n) end, "Stuff")

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
        local cfg = { label="EXIT DOOR", fill=Color3.fromRGB(0, 200, 100), outline=Color3.fromRGB(0, 0, 0), textColor=Color3.fromRGB(80, 255, 160), fillTransparency=0.3 }
        if Value then
            DoorConns = ScanRooms(
                function() return DoorActive end,
                function(n) return (n=="NormalDoor" or n=="BigDoor" or n=="DoubleDoorSewer" or n=="DoubleDoor" or n=="Airlock") and cfg or nil end,
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
                    if (d.Name=="NormalDoor" or d.Name=="BigDoor" or d.Name=="DoubleDoorSewer" or d.Name=="DoubleDoor" or d.Name=="Airlock") and d:IsA("BasePart") then
                        pcall(RemoveESP, d)
                    end
                end
            end
        end
    end
}))

local PlayerEspConns, PlayerEspActive = {}, false
table.insert(AllToggles, Esp:CreateToggle({
    Name="Player Chams", CurrentValue=false, Flag="EspPlayerChams",
    Callback=function(Value)
        PlayerEspActive = Value
        
        local function ApplyPlayerESP(targetPlayer)
            if targetPlayer == Player then return end 
            
            local function onChar(char)
                if not PlayerEspActive then return end
                
                local torso = char:WaitForChild("Torso", 3) or char:WaitForChild("UpperTorso", 3) or char:WaitForChild("HumanoidRootPart", 3)
                if not torso then return end

                local espGui = Instance.new("BillboardGui")
                espGui.Name = "CustomPlayerESP_GUI"
                espGui.Adornee = torso
                espGui.Size = UDim2.new(4, 0, 6, 0)
                espGui.AlwaysOnTop = true
                espGui.MaxDistance = math.huge

                local dot = Instance.new("Frame")
                dot.Size = UDim2.new(0, 8, 0, 8)
                dot.Position = UDim2.new(0.5, 0, 0.5, 0)
                dot.AnchorPoint = Vector2.new(0.5, 0.5)
                dot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                dot.BorderSizePixel = 0
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = dot
                dot.Parent = espGui

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0, 15)
                nameLabel.Position = UDim2.new(0.5, 0, 0, 0) 
                nameLabel.AnchorPoint = Vector2.new(0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = targetPlayer.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextStrokeTransparency = 0.2
                nameLabel.TextSize = 13
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.Parent = espGui

                espGui.Parent = torso

                local cfg = { 
                    label = " ", 
                    fill = Color3.fromRGB(255, 255, 255), 
                    outline = Color3.fromRGB(255, 255, 255), 
                    fillTransparency = 0.3 
                }
                AddESP(torso, cfg, "Player") 
            end
            
            if targetPlayer.Character then task.spawn(onChar, targetPlayer.Character) end
            table.insert(PlayerEspConns, targetPlayer.CharacterAdded:Connect(onChar))
        end

        if Value then
            for _, p in ipairs(Players:GetPlayers()) do ApplyPlayerESP(p) end
            table.insert(PlayerEspConns, Players.PlayerAdded:Connect(ApplyPlayerESP))
        else
            for _, c in ipairs(PlayerEspConns) do c:Disconnect() end
            PlayerEspConns = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    local torso = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
                    if torso then 
                        pcall(RemoveESP, torso) 
                        local gui = torso:FindFirstChild("CustomPlayerESP_GUI")
                        if gui then gui:Destroy() end
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
        local cfg = { label=" ", fill=Color3.fromRGB(200,0,0), outline=Color3.fromRGB(0, 255, 0), textColor=Color3.fromRGB(0, 255, 0), fillTransparency=0.3 }
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
            local pct = typeof(fixedVal) == "boolean" and (fixedVal and 100 or 0) or (tonumber(fixedVal) or 0)
            if pct >= 100 then return nil end
            local r = math.floor(255 * (1 - pct/100))
            local g = math.floor(255 * (pct/100))
            return {
                label = "Generator " .. math.floor(pct) .. "%",
                fill = Color3.fromRGB(r, g, 0),
                outline = Color3.fromRGB(255, 200, 0),
                textColor = WHITE, fillTransparency = 0.3,
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
            local monstersFolder = GameplayFolder and GameplayFolder:FindFirstChild("Monsters")
            if monstersFolder then
                for _, child in ipairs(monstersFolder:GetChildren()) do
                    if MONSTERS[child.Name] then applyESP(child) end
                end
                listenContainer(monstersFolder)
            end
            listenContainer(workspace)
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
                        NotifyOnce(child.Name, "Heads up!", child.Name .. " spawned!", 5)
                    end
                end))
            end
            listenContainer(workspace)
            local monstersFolder = GameplayFolder and GameplayFolder:FindFirstChild("Monsters")
            if monstersFolder then listenContainer(monstersFolder) end
        else
            for _, c in ipairs(monsterAlertConns) do c:Disconnect() end
            monsterAlertConns = {}
        end
    end}))

Esp:CreateSlider({
    Name = "Monster ESP Range",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "s",
    CurrentValue = 1000,
    Flag = "MonsterRangeSlider",
    Callback = function(val)
        ESP_RANGES.Monster = val
    end})

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
            L.Brightness=originalLighting.Brightness or L.Brightness
            L.ClockTime=originalLighting.ClockTime or L.ClockTime
            L.FogEnd=originalLighting.FogEnd or L.FogEnd
            L.GlobalShadows=originalLighting.GlobalShadows or false
            L.Ambient=originalLighting.Ambient or Color3.new(0,0,0)
            L.OutdoorAmbient=originalLighting.OutdoorAmbient or Color3.new(0,0,0)
            for effect, wasEnabled in pairs(fullbrightEffects) do
                if effect and effect.Parent then effect.Enabled = wasEnabled end
            end
            fullbrightEffects = {}
        end
    end}))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

Esp:CreateSection("Camera")

local fovEnabled = false
local targetFOV = 70
local originalFOV = nil

local thirdPersonEnabled = false
local thirdPersonDistance = 10

local function getCamera()
    return workspace.CurrentCamera
end

Esp:CreateToggle({
    Name = "Enable FOV",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value)
        fovEnabled = Value

        local camera = getCamera()
        if not camera then return end

        if Value then
            originalFOV = camera.FieldOfView
            camera.FieldOfView = targetFOV
        elseif originalFOV then
            camera.FieldOfView = originalFOV
            originalFOV = nil
        end
    end
})

Esp:CreateSlider({
    Name = "FOV Changer",
    Range = {60, 120},
    CurrentValue = 70,
    Increment = 1,
    Suffix = " FOV",
    Flag = "FOVChanger",
    Callback = function(Value)
        targetFOV = Value

        if fovEnabled then
            local camera = getCamera()
            if camera then
                camera.FieldOfView = targetFOV
            end
        end
    end
})

local thirdPersonEnabled = false
local thirdPersonDistance = 10

local THIRD_PERSON_BIND = "PressureThirdPerson"

local function updateThirdPerson()
    if not thirdPersonEnabled then return end

    local camera = workspace.CurrentCamera
    local character = Player.Character
    if not camera or not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    -- Force control away from Pressure's camera
    camera.CameraType = Enum.CameraType.Scriptable

    local focus = root.Position + Vector3.new(0, 1.5, 0)

    -- Keep the player's current viewing direction
    local look = camera.CFrame.LookVector

    -- Move camera backwards
    local position = focus - look * thirdPersonDistance

    camera.CFrame = CFrame.lookAt(position, focus)
end

Esp:CreateToggle({
    Name = "Third Person",
    CurrentValue = false,
    Flag = "ThirdPersonToggle",
    Callback = function(Value)
        thirdPersonEnabled = Value

        if Value then
            -- Use an extremely high priority so Pressure runs first,
            -- then our camera takes control afterward.
            pcall(function()
                RunService:UnbindFromRenderStep(THIRD_PERSON_BIND)
            end)

            RunService:BindToRenderStep(
                THIRD_PERSON_BIND,
                Enum.RenderPriority.Last.Value,
                updateThirdPerson
            )
        else
            pcall(function()
                RunService:UnbindFromRenderStep(THIRD_PERSON_BIND)
            end)

            local camera = workspace.CurrentCamera
            if camera then
                camera.CameraType = Enum.CameraType.Custom

                local character = Player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    camera.CameraSubject = humanoid
                end
            end
        end
    end
})

Esp:CreateSlider({
    Name = "Third Person Distance",
    Range = {5, 50},
    CurrentValue = 10,
    Increment = 1,
    Suffix = " Studs",
    Flag = "ThirdPersonDistance",
    Callback = function(Value)
        thirdPersonDistance = Value
    end
})

Esp:CreateButton({
    Name = "Camera Fixer Beta",
    Callback = function()
        local camera = getCamera()
        if not camera then return end

        camera.CameraType = Enum.CameraType.Custom

        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            camera.CameraSubject = humanoid
        end

        if fovEnabled then
            camera.FieldOfView = targetFOV
        end
    end
})


Auto:CreateSection("Automatic Stuff")

-- LOOT AURA
local lootAuraActive = false
local lootAuraRadius = 6
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

table.insert(AllToggles, Auto:CreateToggle({
    Name="Loot Aura (5 Studs)",
    CurrentValue=false,
    Flag="LootAura",
    Callback=function(Value)
        lootAuraActive = Value
        if Value then
            NotifyOnce("Loot Goblin", "Loot Aura Enabled", "Collecting items strictly within 5 studs.", 5)
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
    end}))

local doorPhaseActive = false
local doorPhaseConns = {}
local originalCanCollide = {}

table.insert(AllToggles, Auto:CreateToggle({
    Name = "Open Sesame",
    Flag = "OpenSesame",
    Callback = function()
        doorPhaseActive = not doorPhaseActive
                for _, conn in ipairs(doorPhaseConns) do 
            conn:Disconnect() 
        end
        table.clear(doorPhaseConns)
        local function processDoorPart(part)
            if part:IsA("BasePart") and (table.find({"NormalGatedDoor", "NormalDoor", "BigDoor", "DoubleDoorSewer", "DoubleDoor", "LockedDoor"}, part.Name) or part.Parent.Name:lower():find("bigdoor")) then
                if originalCanCollide[part] == nil then
                    originalCanCollide[part] = part.CanCollide
                end
                
                if doorPhaseActive then
                    part.CanCollide = false
                else
                    part.CanCollide = originalCanCollide[part]
                end
            end
        end
        for _, object in ipairs(Rooms:GetDescendants()) do
            processDoorPart(object)
        end
        if doorPhaseActive then
            NotifyOnce("OPEN SESAME!", "Magic dubi dubi dum dum", "You can now walk directly through doors.", 5)
            table.insert(doorPhaseConns, Rooms.DescendantAdded:Connect(function(object)
                if doorPhaseActive then
                    task.defer(processDoorPart, object)
                end
            end))
        end
    end
}))

local doorOpenConns = {}
local doorOpenActive = false

local function DisconnectDoorOpenConns()
    for _, connection in ipairs(doorOpenConns) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    table.clear(doorOpenConns)
end

local function IsExcludedDoor(door)
    local current = door
    while current and current ~= workspace do
        local name = string.lower(current.Name)
        if string.find(name, "drawer", 1, true)
            or string.find(name, "cabinet", 1, true)
            or string.find(name, "locker", 1, true) then
            return true
        end
        current = current.Parent
    end
    return false
end

local function GetDoorFromPrompt(prompt)
    local current = prompt.Parent
    while current and current ~= workspace do
        local name = string.lower(current.Name)

        -- Ignore room models so they aren't targeted as a door
        if string.find(name, "room") then
            current = current.Parent
            continue
        end

        if string.find(name, "innerlock") or string.find(name, "gatedoff") then
            return current
        end
        
        if name == "normaldoor" or name == "bigdoor" or name == "lockeddoor" or name == "doubledoorsewer" then
            return current
        end
        
        local openValue = current:FindFirstChild("OpenValue")
        local enter = current:FindFirstChild("Enter")
        local exit = current:FindFirstChild("Exit")

        if openValue and openValue:IsA("BoolValue") and enter and exit then
            return current
        end
        current = current.Parent
    end
    return nil
end

local function SetupDoorPrompt(prompt)
    if not doorOpenActive or not prompt:IsA("ProximityPrompt") then return end
    local door = GetDoorFromPrompt(prompt)
    if not door or IsExcludedDoor(door) then return end

    local connection = prompt.Triggered:Connect(function()
        if not doorOpenActive then return end
        
        local doorName = string.lower(door.Name)
        local openValue = door:FindFirstChild("OpenValue")
        
        if openValue then
            pcall(function() openValue.Value = true end)
        end
    end)
    table.insert(doorOpenConns, connection)
end

Auto:CreateButton({
    Name = "Door YEET",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local yeeted = {}
        for _, prompt in ipairs(Rooms:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local door = GetDoorFromPrompt(prompt)

                if door and not yeeted[door] and not IsExcludedDoor(door) then
                    local foundNearby = false
                    local elements = door:GetDescendants()
                    table.insert(elements, door)

                    for _, d in ipairs(elements) do
                        if d:IsA("BasePart") and (root.Position - d.Position).Magnitude <= 10 then
                            foundNearby = true
                            break
                        end
                    end

                    if foundNearby then
                        yeeted[door] = true
                        for _, d in ipairs(elements) do
                            if d:IsA("BasePart") then
                                d.LocalTransparencyModifier = 1
                                d.CanCollide = false
                            elseif d:IsA("Decal") or d:IsA("Texture") then
                                d.Transparency = 1
                            elseif d:IsA("SurfaceGui") or d:IsA("BillboardGui") then
                                d.Enabled = false
                            end
                        end
                    end
                end
            end
        end
    end})


-- ANTI MONSTERS SECTION
Anti:CreateSection("Monsters")

local eyefestConns = {}
table.insert(AllToggles, Anti:CreateToggle({
    Name = "Anti Eyefestation",
    CurrentValue = false,
    Flag = "AntiEyefestation",
    Callback = function(Value)
        for _, c in ipairs(eyefestConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        table.clear(eyefestConns)
        if Value then
            local function checkCameraEffect()
                local cam = workspace.CurrentCamera
                if cam then
                    local eff = cam:FindFirstChild("EyefestationCameraEffect")
                    if eff then pcall(function() eff:Destroy() end) end
                end
            end
            checkCameraEffect()
            if workspace.CurrentCamera then
                table.insert(eyefestConns, workspace.CurrentCamera.ChildAdded:Connect(function(c)
                    if c.Name == "EyefestationCameraEffect" then
                        task.wait()
                        pcall(function() c:Destroy() end)
                    end
                end))
            end
            table.insert(eyefestConns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                if workspace.CurrentCamera then
                    checkCameraEffect()
                    table.insert(eyefestConns, workspace.CurrentCamera.ChildAdded:Connect(function(c)
                        if c.Name == "EyefestationCameraEffect" then
                            task.wait()
                            pcall(function() c:Destroy() end)
                        end
                    end))
                end
            end))

            local function destroyHurt(d)
                if d.Name == "EyefestHurt" or d.Name == "EyefestationCameraEffect" then
                    pcall(function() d:Destroy() end)
                end
            end

            for _, room in ipairs(Rooms:GetChildren()) do
                for _, d in ipairs(room:GetDescendants()) do destroyHurt(d) end
                table.insert(eyefestConns, room.DescendantAdded:Connect(function(d)
                    task.wait(0.05)
                    destroyHurt(d)
                end))
            end
            table.insert(eyefestConns, Rooms.ChildAdded:Connect(function(room)
                task.wait(0.3)
                for _, d in ipairs(room:GetDescendants()) do destroyHurt(d) end
                table.insert(eyefestConns, room.DescendantAdded:Connect(function(d)
                    task.wait(0.05)
                    destroyHurt(d)
                end))
            end))
        end
    end}))

local pandemoniumConn = nil
table.insert(AllToggles, Anti:CreateToggle({
    Name="Spoof Pandemonium", CurrentValue=false, Flag="RemovePandemonium",
    Callback=function(Value)
        if pandemoniumConn then 
            pandemoniumConn:Disconnect()
            pandemoniumConn = nil 
        end
        
        if Value then
            for _, child in ipairs(workspace:GetChildren()) do
                if PANDEMONIUM_NAMES[child.Name] then pcall(function() child:Destroy() end) end
            end
            pandemoniumConn = workspace.ChildAdded:Connect(function(child)
                if PANDEMONIUM_NAMES[child.Name] then pcall(function() child:Destroy() end) end
            end)
        end
    end
}))

local pipsqueakConn1, pipsqueakConn2 = nil, nil
table.insert(AllToggles, Anti:CreateToggle({
    Name="Spoof PipsqueakBeta", CurrentValue=false, Flag="RemovePipsqueakBeta",
    Callback=function(Value)
        if pipsqueakConn1 then pipsqueakConn1:Disconnect(); pipsqueakConn1 = nil end
        if pipsqueakConn2 then pipsqueakConn2:Disconnect(); pipsqueakConn2 = nil end

        if Value then
            local function check(child)
                if (child.Name == "Pipsqueak" or string.match(child.Name, "Pipsqueak")) or (child.Name == "Pipsqeuak" or string.match(child.Name, "Pipsqeuak")) then
                    pcall(function() child:Destroy() end)
                end
            end
            
            for _, c in ipairs(workspace:GetChildren()) do check(c) end
            
            local mf = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
            if mf then
                for _, c in ipairs(mf:GetChildren()) do check(c) end
                pipsqueakConn2 = mf.ChildAdded:Connect(check)
            end
            pipsqueakConn1 = workspace.ChildAdded:Connect(check)
        end
    end
}))

local a200Conn1, a200Conn2 = nil, nil
table.insert(AllToggles, Anti:CreateToggle({
    Name="Spoof A200Beta", CurrentValue=false, Flag="RemoveA200Beta",
    Callback=function(Value)
        if a200Conn1 then a200Conn1:Disconnect(); a200Conn1 = nil end
        if a200Conn2 then a200Conn2:Disconnect(); a200Conn2 = nil end

        if Value then
            local function check(child)
                if child.Name == "A200" or child.Name == "A-200" or string.match(child.Name, "A200") or string.match(child.Name, "A%-200") then
                    pcall(function() child:Destroy() end)
                end
            end
            
            for _, c in ipairs(workspace:GetChildren()) do check(c) end
            
            local mf = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
            if mf then
                for _, c in ipairs(mf:GetChildren()) do check(c) end
                a200Conn2 = mf.ChildAdded:Connect(check)
            end
            a200Conn1 = workspace.ChildAdded:Connect(check)
        end
    end
}))

local wallDwellerConn = nil
table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove WallDweller", CurrentValue=false, Flag="RemoveWallDweller",
    Callback=function(Value)
        if wallDwellerConn then wallDwellerConn:Disconnect(); wallDwellerConn = nil end
        
        if Value then
            local mf = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
            if mf then
                local function check(c)
                    if c.Name == "WallDweller" or c.Name == "MeatWallDweller" or c.Name == "RottenWallDweller" or c.Name == "DwellerModel" or c.Name == "DiVineRoot" then
                        pcall(function() c:Destroy() end)
                    end
                end
                for _, c in ipairs(mf:GetChildren()) do check(c) end
                wallDwellerConn = mf.ChildAdded:Connect(check)
            end
        end
    end
}))

local bouncerConn = nil
table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Bouncer", CurrentValue=false, Flag="RemoveBouncer",
    Callback=function(Value)
        if bouncerConn then bouncerConn:Disconnect(); bouncerConn = nil end
        
        if Value then
            local mf = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
            if mf then
                local function check(c)
                    if c.Name == "Bouncer" or c.Name == "Bouncers" then
                        pcall(function() c:Destroy() end)
                    end
                end
                for _, c in ipairs(mf:GetChildren()) do check(c) end
                bouncerConn = mf.ChildAdded:Connect(check)
            end
        end
    end
}))

local skeletonHeadConn = nil
table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Skeleton Head", CurrentValue=false, Flag="RemoveSkeletonHead",
    Callback=function(Value)
        if skeletonHeadConn then skeletonHeadConn:Disconnect(); skeletonHeadConn = nil end
        
        if Value then
            local mf = workspace:FindFirstChild("GameplayFolder") and workspace.GameplayFolder:FindFirstChild("Monsters")
            if mf then
                local function check(c)
                    if c.Name == "SkeletonHead" then
                        pcall(function() c:Destroy() end)
                    end
                end
                for _, c in ipairs(mf:GetChildren()) do check(c) end
                skeletonHeadConn = mf.ChildAdded:Connect(check)
            end
        end
    end}))

local statueConns = {}

table.insert(AllToggles, Anti:CreateToggle({
    Name = "Remove Statue",
    CurrentValue = false,
    Flag = "RemoveStatue",
    Callback = function(Value)
        for _, c in ipairs(statueConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        table.clear(statueConns)

        if Value then
            local function checkAndDestroy(obj)
                if obj.Name == "StatueRoot" or obj.Name == "StatueHead" then
                    pcall(function() obj:Destroy() end)
                end
            end

            for _, object in ipairs(workspace:GetDescendants()) do
                checkAndDestroy(object)
            end

            table.insert(statueConns, workspace.DescendantAdded:Connect(function(object)
                task.wait(0.05)
                checkAndDestroy(object)
            end))
        end
    end
}))

CreateAntiToggle(Anti, "Anti DiVine", "RemoveDiVine", function(n) return n == "DiVine" or n == "DiVineRoot" or n == "Divineroot" end)
CreateAntiToggle(Anti, "Remove Searchlights", "RemoveSearchlights", function(n) return n == "Searchlights" end)
CreateAntiToggle(Anti, "Remove Monster Locker", "RemoveMonsterLocker", function(n) return n == "MonsterLocker" end)

local noGoodActive = false
local noGoodConn = nil

table.insert(AllToggles, Anti:CreateToggle({
    Name = "Anti NoGood", CurrentValue = false, Flag = "RemoveNoGood",
    Callback = function(Value)
        noGoodActive = Value
        if noGoodConn then
            noGoodConn:Disconnect()
            noGoodConn = nil
        end
        if not Value then
            return
        end
        local function removeNoGood(object)
            if not noGoodActive or not object.Parent then
                return
            end
            if object.Name == "NoGood" then
                pcall(function()
                    object:Destroy()
                end)
            end
        end
        for _, object in ipairs(workspace:GetDescendants()) do
            removeNoGood(object)
        end
        noGoodConn = workspace.DescendantAdded:Connect(function(object)
            if noGoodActive then
                task.defer(removeNoGood, object)
            end
        end)
    end}))

local skinlessActive = false
local skinlessConn = nil

table.insert(AllToggles, Anti:CreateToggle({
    Name = "Remove SkinlessCorpseBeta", CurrentValue = false, Flag = "RemoveSkinlessCorpseBeta",
    Callback = function(Value)
        skinlessActive = Value
        if skinlessConn then
            skinlessConn:Disconnect()
            skinlessConn = nil
        end
        if not Value then
            return
        end
        local function removeSkinlessCorpse(object)
            if not skinlessActive or not object.Parent then
                return
            end
            if object.Name == "SkinlessCorpse" then
                pcall(function()
                    object:Destroy()
                end)
            end
        end
        for _, object in ipairs(workspace:GetDescendants()) do
            removeskinlesscorpse(object)
        end
        skinlessConn = workspace.DescendantAdded:Connect(function(object)
            if skinlessActive then
                task.defer(removeskinlesscorpse, object)
            end
        end)
    end}))   

local cementAnti, cementConns = false, {}

local function DestroyCement(o)
    if o and o.Parent and string.find(o.Name:lower(),"cement",1,true) then pcall(function() o:Destroy() end) end
end

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Cement Shoes", CurrentValue=false, Flag="RemoveCementShoes",
    Callback=function(v)
        cementAnti=v
        for _,c in ipairs(cementConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
        table.clear(cementConns)
        if not v then return end
        for _,o in ipairs(workspace:GetDescendants()) do DestroyCement(o) end
        table.insert(cementConns, workspace.DescendantAdded:Connect(function(o)
            if cementAnti then DestroyCement(o) end
        end))
    end
}))

local witchingAnti, witchingConns=false, {}
local function DestroyWitchingHour(o)
    if o and o.Parent and o.Name:lower()=="witchinghour" then pcall(function() o:Destroy() end) end
end
table.insert(AllToggles,Anti:CreateToggle({
    Name="Remove WitchingHour",CurrentValue=false,Flag="RemoveWitchingHour",
    Callback=function(v)
        witchingAnti=v
        for _,c in ipairs(witchingConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
        table.clear(witchingConns)
        if not v then return end
        for _,o in ipairs(workspace:GetDescendants()) do DestroyWitchingHour(o) end
        table.insert(witchingConns,workspace.DescendantAdded:Connect(function(o)
            if witchingAnti then DestroyWitchingHour(o) end
        end))
    end
}))

Anti:CreateSection("Spawns")
CreateAntiToggle(Anti,"Remove Turrets",  "RemoveTurrets",  function(n) return n=="Turret" or string.match(n,"^TurretSpawn")~=nil end)
CreateAntiToggle(Anti,"Remove Tripwires","RemoveTripwires",function(n) return n=="Tripwire" or n=="TripwireSpawn" end)
CreateAntiToggle(Anti,"Remove Landmines","RemoveLandmines",function(n) return n=="Landmine" or n=="LandmineSpawn" or n=="DrawerLandmine" end)

local squiddleConns = {}
table.insert(AllToggles, Anti:CreateToggle({
    Name = "Anti Squiddles",
    CurrentValue = false,
    Flag = "AntiSquiddles",
    Callback = function(Value)
        for _, c in ipairs(squiddleConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        table.clear(squiddleConns)
        if Value then
            local function checkAndDestroy(obj)
                if obj.Name == "SquiddleBuildup" and obj.Parent and obj.Parent.Name == "Face" then
                    local squiddle = obj.Parent.Parent
                    if squiddle then
                        pcall(function() squiddle:Destroy() end)
                    end
                elseif obj.Name == "Squiddle" or obj.Name == "SquiddleBase" then
                    pcall(function() obj:Destroy() end)
                end
            end
            for _, object in ipairs(workspace:GetDescendants()) do
                checkAndDestroy(object)
            end
            table.insert(squiddleConns, workspace.DescendantAdded:Connect(function(object)
                task.wait(0.05)
                checkAndDestroy(object)
            end))
        end
    end
}))

local CoagulateConnection = nil
local CameraConnection = nil
local CoagulateRemovalEnabled = false

local function RemoveCoagulate(object)
    if not object or not object.Parent then return end
    local nameLower = object.Name:lower()
    if nameLower:find("coagulate") or nameLower:find("coagulant") then
        pcall(function() object:Destroy() end)
        return
    end
    local parent = object.Parent
    while parent and parent ~= workspace and parent ~= game do
        if parent.Name:lower():find("coagulate") or parent.Name:lower():find("coagulant") then
            pcall(function() parent:Destroy() end)
            return
        end
        parent = parent.Parent
    end
end

table.insert(AllToggles, Anti:CreateToggle({
    Name = "Anti CoagulateBeta", CurrentValue = false, Flag = "AntiCoagulateBeta",
    Callback = function(Value)
        CoagulateRemovalEnabled = Value
        if CoagulateConnection then CoagulateConnection:Disconnect() CoagulateConnection = nil end
        if CameraConnection then CameraConnection:Disconnect() CameraConnection = nil end
        if not Value then return end

        for _, object in ipairs(workspace:GetDescendants()) do RemoveCoagulate(object) end
        CoagulateConnection = workspace.DescendantAdded:Connect(function(object)
            if CoagulateRemovalEnabled then RemoveCoagulate(object) end
        end)
        local camera = workspace.CurrentCamera
        if camera then
            CameraConnection = camera.DescendantAdded:Connect(function(object)
                if CoagulateRemovalEnabled then RemoveCoagulate(object) end
            end)
        end
    end
}))

local edenConns = {}

table.insert(AllToggles, Anti:CreateToggle({
    Name = "Remove EdentreesBeta",
    CurrentValue = false,
    Flag = "RemoveEdentreesBeta",
    Callback = function(Value)
        for _, c in ipairs(edenConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        table.clear(edenConns)

        if Value then
            local function checkAndDestroyEden(object)
                if not object or not object.Parent then return end

                if object:IsA("Model") and object.Name:match("^%l%l%l%l$") and object:FindFirstChild("RootPart") then
                    pcall(function() object:Destroy() end)
                    return
                end

                local parent = object.Parent
                if parent and parent:IsA("Model") and parent.Name:match("^%l%l%l%l$") and parent:FindFirstChild("RootPart") then
                    pcall(function() parent:Destroy() end)
                end
            end

            for _, object in ipairs(workspace:GetDescendants()) do
                checkAndDestroyEden(object)
            end

            table.insert(edenConns, workspace.DescendantAdded:Connect(function(object)
                task.wait(0.05)
                checkAndDestroyEden(object)
            end))
        end
    end
}))

Anti:CreateSection("Encounters")
CreateAntiToggle(Anti, "Remove Damage Parts", "RemoveDamageParts", function(n)
    local name = string.lower(n)
    return name == "damagepart" or name == "electricity" or name == "damageparts"
end)

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Firewall",CurrentValue=false,Flag="RemoveFirewall",
    Callback=function(Value)
        local conns,active={},Value

        local function launch(o)
            if not o:IsA("BasePart") then return end
            local p=Instance.new("Part")
            p.Name="FirewallPitLauncher";p.Size=o.Size;p.CFrame=o.CFrame
            p.Anchored=true;p.CanCollide=false;p.CanTouch=true;p.Transparency=1;p.Parent=o.Parent

            table.insert(conns,p.Touched:Connect(function(hit)
                if not active then return end
                local c=hit:FindFirstAncestorOfClass("Model")
                local h=c and c:FindFirstChildOfClass("Humanoid")
                local r=c and c:FindFirstChild("HumanoidRootPart")
                if h and r and c==Player.Character then
                    r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,200,r.AssemblyLinearVelocity.Z)
                end
            end))

            pcall(function() o:Destroy() end)
        end

        if Value then
            for _,o in ipairs(workspace:GetDescendants()) do
                if o.Name=="Firewall" then
                    pcall(function() o:Destroy() end)
                elseif o.Name=="FirewallPit" then
                    launch(o)
                elseif o.Name=="FirewallPitLauncher" then
                    pcall(function() o:Destroy() end)
                end
            end

            table.insert(conns,workspace.DescendantAdded:Connect(function(o)
                if active then
                    task.defer(function()
                        if o.Name=="Firewall" or o.Name=="FirewallPitLauncher" then
                            pcall(function() o:Destroy() end)
                        elseif o.Name=="FirewallPit" then
                            launch(o)
                        end
                    end)
                end
            end))
        else
            active=false

            for _,c in ipairs(conns) do
                if typeof(c)=="RBXScriptConnection" then
                    c:Disconnect()
                end
            end
            table.clear(conns)

            for _,o in ipairs(workspace:GetDescendants()) do
                if o.Name=="FirewallPitLauncher" then
                    pcall(function() o:Destroy() end)
                end
            end
        end
    end
}))

local antiPitConn
local antiPitActive = false
local spaceCount, lastSpace = 0, 0

table.insert(AllToggles, Anti:CreateToggle({
    Name="Anti Pit Falls", CurrentValue=false, Flag="AntiPitFalls",
    Callback=function(Value)
        antiPitActive=Value
        spaceCount,lastSpace=0,0

        if antiPitConn then
            antiPitConn:Disconnect()
            antiPitConn=nil
        end

        if Value then
            antiPitConn=UserInputService.InputBegan:Connect(function(input,gpe)
                if not antiPitActive or gpe or input.KeyCode~=Enum.KeyCode.Space then return end
                local t=tick()
                spaceCount=t-lastSpace<0.4 and spaceCount+1 or 1
                lastSpace=t

                if spaceCount>=4 then
                    local r=GetRootPart()
                    if r then
                        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,200,r.AssemblyLinearVelocity.Z)
                    end
                    spaceCount=0
                end
            end)
        end
    end
}))

local abomAnti, abomConns = false, {}
local function DestroyAbom(o)
    if o and o.Parent and string.find(o.Name:lower(),"abom",1,true) then pcall(function() o:Destroy() end) end
end

table.insert(AllToggles, Anti:CreateToggle({
    Name="Remove Abomination", CurrentValue=false, Flag="RemoveAbomination",
    Callback=function(v)
        abomAnti=v
        for _,c in ipairs(abomConns) do if typeof(c)=="RBXScriptConnection" then c:Disconnect() end end
        table.clear(abomConns)
        if not v then return end
        for _,o in ipairs(workspace:GetDescendants()) do DestroyAbom(o) end
        table.insert(abomConns, workspace.DescendantAdded:Connect(function(o)
            if abomAnti then DestroyAbom(o) end
        end))
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
        if Value then 
            NotifyOnce("Speed On", "I AM SPEED", "Sprint Knockoff turned on.", 5)
        end
    end,
})
table.insert(AllToggles, SpeedToggle)

Move:CreateSlider({
    Name = "Speed Boost Amount", Range = {0, 20}, Increment = 0.25, Suffix = " Boost", CurrentValue = 0, Flag = "SpeedBoostAmount",
    Callback = function(Value) SpeedBoost = Value end,
})

local SpeedLoopConnection = RunService.Stepped:Connect(function(_, dt)
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hrp and hum.Health > 0 and SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (SpeedBoost * 60 * dt / 10))
    end
end)

local JumpKeybindConnection = nil
local CurrentJumpKey = Enum.KeyCode.Space

Move:CreateToggle({
    Name = "Jump Power (Retoggle if it doesn't work)",
    CurrentValue = false,
    Flag = "JumpPower",
    Callback = function(Value)
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if Value then
            NotifyOnce("Jump power = 50", "Jumping Enabled", "Setting Jump to true, you junkie.", 5)
            if not JumpKeybindConnection then
                JumpKeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.KeyCode == CurrentJumpKey then
                        local char = Player.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.JumpPower > 0 then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end)
            end
        else
            if JumpKeybindConnection then
                JumpKeybindConnection:Disconnect()
                JumpKeybindConnection = nil
            end
        end
        if not humanoid then return end
        humanoid.UseJumpPower = true
        humanoid.JumpPower = Value and 50 or 0
    end})
Move:CreateKeybind({
    Name = "Jump Keybind",
    CurrentKeybind = "Space",
    HoldToInteract = false,
    Flag = "JumpKeybind",
    Callback = function(Keybind)
        if typeof(Keybind) == "EnumItem" then
            CurrentJumpKey = Keybind
        elseif typeof(Keybind) == "string" and Enum.KeyCode[Keybind] then
            CurrentJumpKey = Enum.KeyCode[Keybind]
        end
    end,
})
--noclip
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

Move:CreateSection("Collision Modification")

local TorsoParts = {
    ["Torso"] = true,
    ["UpperTorso"] = true,
    ["LowerTorso"] = true,
    ["HumanoidRootPart"] = true
}

-- Destroy any pre-existing connection running in the executor environment
if getgenv().NoclipLoopConnection then
    getgenv().NoclipLoopConnection:Disconnect()
    getgenv().NoclipLoopConnection = nil
end

local NoclipEnabled = false

-- Helper function to force-reset character collisions
local function RestoreCollisions()
    local char = Player.Character
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Restores standard collision: Torso/Root collides, limbs pass through
            if TorsoParts[part.Name] then
                part.CanCollide = true
            else
                part.CanCollide = false
            end
        end
    end
end

-- Export restore function so UnloadScript can call it globally
getgenv().RestoreCollisions = RestoreCollisions

local NoclipToggle = Move:CreateToggle({
    Name = "Enable Noclip", 
    CurrentValue = false, 
    Flag = "NoclipToggle",
    Callback = function(Value) 
        NoclipEnabled = Value 
        if Value then 
            if NotifyOnce then NotifyOnce("Noclip On", "GHOST MODE", "Full noclip turned on.", 5) end
        else
            -- Force reset parts back to solid state immediately on toggle off
            RestoreCollisions()
        end
    end,
})
if AllToggles then table.insert(AllToggles, NoclipToggle) end

-- Store connection globally so subsequent script executions automatically kill old ones
getgenv().NoclipLoopConnection = RunService.Stepped:Connect(function()
    local char = Player.Character
    
    -- Local player logic
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if NoclipEnabled then
                    part.CanCollide = false
                else
                    if TorsoParts[part.Name] then
                        part.CanCollide = true
                    else
                        part.CanCollide = false
                    end
                end
            end
        end
    end

    -- Player-to-player collision disable (always active)
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            for _, part in ipairs(otherPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)
--flight
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

Move:CreateSection("Flight Modification")
local FlySpeed = 1
local FlyEnabled = false
local FlyToggle
local pos, gyro

-- Helper function to safely destroy old physics parts
local function CleanUpFly()
    if pos then pos:Destroy() pos = nil end
    if gyro then gyro:Destroy() gyro = nil end
    
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- Helper function to apply physics parts to the active character
local function SetupFly(hrp)
    CleanUpFly() -- Clear existing parts first to prevent duplicates
    
    pos = Instance.new("BodyPosition", hrp)
    pos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    pos.P = 100000
    pos.D = 1750
    pos.Position = hrp.Position
    
    gyro = Instance.new("BodyGyro", hrp)
    gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    gyro.P = 100000
    gyro.D = 2200
end

FlyToggle = Move:CreateToggle({
    Name = "Enable Flight", 
    CurrentValue = false, 
    Flag = "FlyToggle",
    Callback = function(Value) 
        FlyEnabled = Value 
        if Value then 
            if NotifyOnce then NotifyOnce("Flight On", "I BELIEVE I CAN FLY", "Flight mode turned on.", 5) end
            
            local char = Player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum then
                SetupFly(hrp)
                hum.PlatformStand = true
            end
        else
            CleanUpFly()
        end
    end,
})
if AllToggles then table.insert(AllToggles, FlyToggle) end

Move:CreateSlider({
    Name = "Flight Speed Amount", Range = {1, 20}, Increment = 0.5, Suffix = " Speed", CurrentValue = 1, Flag = "FlySpeedAmount",
    Callback = function(Value) FlySpeed = Value end,
})

local FlyLoopConnection = RunService.Heartbeat:Connect(function()
    -- Only run the math if the toggle is actively on
    if not FlyEnabled then return end
    
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = workspace.CurrentCamera -- Dynamically fetch the current camera every frame!
    
    if hrp and hum and hum.Health > 0 then
        -- 1. Auto-Recreate BodyMovers if they went missing (e.g., you respawned)
        if not pos or not pos.Parent or not gyro or not gyro.Parent then
            SetupFly(hrp)
        end
        
        hum.PlatformStand = true -- Ensure PlatformStand stays true
        
        -- 2. Calculate Vertical Movement (Space/Shift)
        local verticalMove = 0
        if UIS:IsKeyDown(Enum.KeyCode.Space) then 
            verticalMove = FlySpeed
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then 
            verticalMove = -FlySpeed 
        end
        
        -- 3. Apply Movement using simplified math
        local moveDir = hum.MoveDirection
        pos.Position = pos.Position + (moveDir * FlySpeed) + Vector3.new(0, verticalMove, 0)
        gyro.CFrame = cam.CFrame
    end
end)

-- PLAYER TELEPORT
local function GetDetectablePlayerTarget(farthest)
    local localChar = Player.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end

    local targetPlayer = nil
    local bestDistance = farthest and -math.huge or math.huge

    for _, targetPlayerCandidate in ipairs(Players:GetPlayers()) do
        if targetPlayerCandidate ~= Player then
            local char = targetPlayerCandidate.Character
            if char then
                local torso = char:FindFirstChild("Torso")
                    or char:FindFirstChild("UpperTorso")
                    or char:FindFirstChild("HumanoidRootPart")

                local targetHRP = char:FindFirstChild("HumanoidRootPart")

                if torso and targetHRP then
                    local distance = (localHRP.Position - targetHRP.Position).Magnitude

                    if farthest then
                        if distance > bestDistance then
                            bestDistance = distance
                            targetPlayer = targetPlayerCandidate
                        end
                    else
                        if distance < bestDistance then
                            bestDistance = distance
                            targetPlayer = targetPlayerCandidate
                        end
                    end
                end
            end
        end
    end

    return targetPlayer
end

local function TeleportToPlayer(farthest)
    local character = Player.Character
    local localHRP = character and character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end

    local targetPlayer = GetDetectablePlayerTarget(farthest)
    if not targetPlayer then
        NotifyOnce("LET ME IN!", "Teleport", "No detectable player found.", 3)
        return
    end

    local targetChar = targetPlayer.Character
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    pcall(function()
        localHRP.CFrame = targetHRP.CFrame
    end)
end

Move:CreateButton({
    Name = "Teleport To Nearest Player",
    Callback = function() TeleportToPlayer(false) end
})

Move:CreateButton({
    Name = "Teleport To Farthest Player",
    Callback = function() TeleportToPlayer(true) end
})

-- SAVED LOCATION
local savedLocation = nil

Move:CreateButton({
    Name = "Dropping Anchor",
    Callback = function()
        local root = GetRootPart()
        if root then
            savedLocation = root.CFrame
            NotifyOnce("Anchor Dropped", "Location Saved", "Your current position has been saved.", 3)
        end
    end
})

Move:CreateButton({
    Name = "Beam Me Up",
    Callback = function()
        local root = GetRootPart()
        if not root then return end
        if not savedLocation then
            NotifyOnce("Yeah, Where?", "Teleport", "No saved location.", 3)
            return
        end
        pcall(function() root.CFrame = savedLocation end)
    end
})

-- SETTINGS TAB
local function UnloadScript()
    CloseUI(function()
        pcall(function()
            for _, toggle in ipairs(AllToggles) do
                if toggle and toggle.Set then pcall(function() toggle:Set(false) end) end
            end
            AllToggles = {}

            -- Disconnect global Noclip connection and reset collision states
            if getgenv().NoclipLoopConnection then 
                getgenv().NoclipLoopConnection:Disconnect() 
                getgenv().NoclipLoopConnection = nil 
            end

            if getgenv().RestoreCollisions then
                getgenv().RestoreCollisions()
                getgenv().RestoreCollisions = nil
            end
            
            if PlayerClipConnection then 
                PlayerClipConnection:Disconnect() 
                PlayerClipConnection = nil 
            end
            
            if originalFOV and workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = originalFOV
                fovEnabled = false
                originalFOV = nil
            end

            NoClipEnabled = false
            PlayerClipEnabled = false

            -- Existing Disconnects
            if lootAuraLoop then lootAuraLoop:Disconnect() lootAuraLoop = nil end
            if SpeedLoopConnection then SpeedLoopConnection:Disconnect() SpeedLoopConnection = nil end
            if espDistanceLoop then espDistanceLoop:Disconnect() espDistanceLoop = nil end
            if noGoodConn then noGoodConn:Disconnect() noGoodConn = nil end
            if CoagulateConnection then CoagulateConnection:Disconnect() CoagulateConnection = nil end
            if CameraConnection then CameraConnection:Disconnect() CameraConnection = nil end
            if skinlessConn then skinlessConn:Disconnect() skinlessConn = nil end
            if pandemoniumConn then pandemoniumConn:Disconnect() pandemoniumConn = nil end
            if pipsqueakConn1 then pipsqueakConn1:Disconnect() end
            if pipsqueakConn2 then pipsqueakConn2:Disconnect() end
            if a200Conn1 then a200Conn1:Disconnect() end
            if a200Conn2 then a200Conn2:Disconnect() end
            if wallDwellerConn then wallDwellerConn:Disconnect() end
            if bouncerConn then bouncerConn:Disconnect() end
            if skeletonHeadConn then skeletonHeadConn:Disconnect() end
            if statueConn then statueConn:Disconnect() end

            ActiveESPs = {}
            SpeedEnabled = false
            SpeedBoost = 0
            savedLocation = nil

            if antiPitConn then
                antiPitConn:Disconnect()
                antiPitConn = nil
            end
            antiPitActive = false
            spaceCount = 0
            lastSpace = 0

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

            local JumpKeybindConnection

            -- Example of how the keybind listener should be bound:
            -- JumpKeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed) ... end)
            local character = game.Players.LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = 0
            end

            -- Disconnect and unload the keybind listener
            if JumpKeybindConnection then
                JumpKeybindConnection:Disconnect()
                JumpKeybindConnection = nil
            end

            -- Safely restores original collision states without deleting parts
            if originalCanCollide then
                for part, originalState in pairs(originalCanCollide) do
                    if part and part.Parent then
                        pcall(function()
                            part.CanCollide = originalState
                        end)
                    end
                end
                table.clear(originalCanCollide)
            end

            doorOpenActive = false
            doorPhaseActive = false

            local allConnTables = {
                lockerConns, fakeDoorConns, generatorConns, DoorConns,
                monsterEspConns, monsterAlertConns, PlayerEspConns,
                eyefestConns, statueConns, squiddleConns, edenConns, doorOpenConns,
                doorPhaseConns, itemESPConns, cementConns, abomConns, witchingConns
            }

            for _, tbl in ipairs(allConnTables) do
                for _, c in ipairs(tbl) do
                    if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
                end
                table.clear(tbl)
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
    Callback = function() UnloadScript() end,
})

-- INITIAL LAUNCH
OpenUI()
