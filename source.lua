-- QStyleUI Library (Versi Fix)
-- Sudah ada: Auto Resize Section, Tab Switching, Drag Window

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local QStyleUI = {}

-- Helper warna
local function hex(hexStr)
    return Color3.fromHex(hexStr)
end

function QStyleUI:CreateWindow(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QStyleGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 760, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -380, 0.45, -190)
    mainFrame.BackgroundColor3 = hex("#0F1720")
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

    -- Drag support
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Left Panel (tabs)
    local leftPanel = Instance.new("Frame")
    leftPanel.Size = UDim2.new(0, 200, 1, -20)
    leftPanel.Position = UDim2.new(0, 12, 0, 10)
    leftPanel.BackgroundTransparency = 1
    leftPanel.Parent = mainFrame

    local leftList = Instance.new("UIListLayout", leftPanel)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Padding = UDim.new(0, 8)

    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -8, 0, 36)
    searchBox.Position = UDim2.new(0, 4, 0, 0)
    searchBox.BackgroundTransparency = 0.85
    searchBox.Text = "Search"
    searchBox.PlaceholderText = "Search"
    searchBox.TextColor3 = hex("#B7C3CC")
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = leftPanel
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

    -- Right Panel
    local rightPanel = Instance.new("Frame")
    rightPanel.Size = UDim2.new(1, -236, 1, -20)
    rightPanel.Position = UDim2.new(0, 220, 0, 10)
    rightPanel.BackgroundTransparency = 1
    rightPanel.Parent = mainFrame

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -8, 0, 56)
    header.Position = UDim2.new(0, 4, 0, 0)
    header.BackgroundTransparency = 1
    header.Parent = rightPanel

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "QStyleUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = hex("#E6EEF5")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 8)
    title.Size = UDim2.new(0.7, 0, 0, 24)
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.Text = config.SubTitle or ""
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = hex("#98A7B4")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 0, 0, 30)
    subtitle.Size = UDim2.new(0.7, 0, 0, 20)
    subtitle.Parent = header

    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -8, 1, -68)
    contentFrame.Position = UDim2.new(0, 4, 0, 64)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = rightPanel

    -- Canvas (tempat tab contents)
    local canvas = Instance.new("Frame")
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundTransparency = 1
    canvas.Parent = contentFrame

    -- Tab System
    local window = { Tabs = {}, ActiveTab = nil }

    function window:CreateTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -8, 0, 42)
        tabBtn.BackgroundTransparency = 0.8
        tabBtn.Text = " " .. tabName
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.TextColor3 = hex("#DDE6EE")
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 16
        tabBtn.Parent = leftPanel
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 6
        tabContent.Visible = false
        tabContent.Parent = canvas

        local tabList = Instance.new("UIListLayout", tabContent)
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 12)
        tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local tab = { Frame = tabContent, Sections = {} }
        window.Tabs[tabName] = tab

        -- Switch tab
        tabBtn.MouseButton1Click:Connect(function()
            if window.ActiveTab then
                window.ActiveTab.Frame.Visible = false
            end
            tabContent.Visible = true
            window.ActiveTab = tab
        end)

        -- Section
        function tab:CreateSection(titleText)
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(0.95, 0, 0, 0)
            sec.BackgroundColor3 = hex("#0B1220")
            sec.BackgroundTransparency = 0.15
            sec.Parent = tabContent
            Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 10)

            local secList = Instance.new("UIListLayout", sec)
            secList.SortOrder = Enum.SortOrder.LayoutOrder
            secList.Padding = UDim.new(0, 6)

            local lbl = Instance.new("TextLabel", sec)
            lbl.Text = titleText
            lbl.Size = UDim2.new(1, -12, 0, 24)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = hex("#E6EEF5")
            lbl.Font = Enum.Font.GothamSemibold
            lbl.TextSize = 14

            local section = { Frame = sec }

            function section:AddToggle(name, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0.9, 0, 0, 32)
                btn.BackgroundColor3 = hex("#0E1620")
                btn.Text = name
                btn.TextColor3 = hex("#DDE6EE")
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Parent = sec
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

                local state = false
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    pcall(callback, state)
                end)
            end

            function section:AddSlider(name, min, max, default, callback)
                local slider = Instance.new("TextButton")
                slider.Size = UDim2.new(0.9, 0, 0, 32)
                slider.BackgroundColor3 = hex("#0E1620")
                slider.Text = name .. " [" .. default .. "]"
                slider.TextColor3 = hex("#DDE6EE")
                slider.Font = Enum.Font.Gotham
                slider.TextSize = 14
                slider.Parent = sec
                Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

                slider.MouseButton1Click:Connect(function()
                    local val = math.random(min, max)
                    slider.Text = name .. " [" .. val .. "]"
                    pcall(callback, val)
                end)
            end

            return section
        end

        return tab
    end

    return window
end

return QStyleUI
