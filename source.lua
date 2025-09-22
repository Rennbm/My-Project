-- QStyleUI Library (Lengkap: Toggle, Slider, Button, TextBox)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local QStyleUI = {}

-- Helper warna
local function hex(h)
    return Color3.fromHex(h)
end

function QStyleUI:CreateWindow(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QStyleGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 760, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -380, 0.45, -190)
    mainFrame.BackgroundColor3 = hex("#0F1720")
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

    -- Drag window
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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

    -- Left Panel (Tabs)
    local leftPanel = Instance.new("Frame", mainFrame)
    leftPanel.Size = UDim2.new(0, 200, 1, -20)
    leftPanel.Position = UDim2.new(0, 12, 0, 10)
    leftPanel.BackgroundTransparency = 1
    local leftList = Instance.new("UIListLayout", leftPanel)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Padding = UDim.new(0, 8)

    local searchBox = Instance.new("TextBox", leftPanel)
    searchBox.Size = UDim2.new(1, -8, 0, 36)
    searchBox.Position = UDim2.new(0, 4, 0, 0)
    searchBox.BackgroundTransparency = 0.85
    searchBox.Text = "Search"
    searchBox.PlaceholderText = "Search"
    searchBox.TextColor3 = hex("#B7C3CC")
    searchBox.ClearTextOnFocus = false
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

    -- Right Panel
    local rightPanel = Instance.new("Frame", mainFrame)
    rightPanel.Size = UDim2.new(1, -236, 1, -20)
    rightPanel.Position = UDim2.new(0, 220, 0, 10)
    rightPanel.BackgroundTransparency = 1

    -- Header
    local header = Instance.new("Frame", rightPanel)
    header.Size = UDim2.new(1, -8, 0, 56)
    header.Position = UDim2.new(0, 4, 0, 0)
    header.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Text = config.Title or "QStyleUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = hex("#E6EEF5")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 8)
    title.Size = UDim2.new(0.7, 0, 0, 24)

    local subtitle = Instance.new("TextLabel", header)
    subtitle.Text = config.SubTitle or ""
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextColor3 = hex("#98A7B4")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 0, 0, 30)
    subtitle.Size = UDim2.new(0.7, 0, 0, 20)

    -- Content (Tabs area)
    local contentFrame = Instance.new("Frame", rightPanel)
    contentFrame.Size = UDim2.new(1, -8, 1, -68)
    contentFrame.Position = UDim2.new(0, 4, 0, 64)
    contentFrame.BackgroundTransparency = 1

    local canvas = Instance.new("Frame", contentFrame)
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundTransparency = 1

    -- Window Object
    local window = { Tabs = {}, ActiveTab = nil }

    -- CreateTab
    function window:CreateTab(tabName)
        local tabBtn = Instance.new("TextButton", leftPanel)
        tabBtn.Size = UDim2.new(1, -8, 0, 42)
        tabBtn.BackgroundTransparency = 0.8
        tabBtn.Text = " " .. tabName
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.TextColor3 = hex("#DDE6EE")
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 16
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("ScrollingFrame", canvas)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 6
        tabContent.Visible = false

        local tabList = Instance.new("UIListLayout", tabContent)
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 12)
        tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local tab = { Frame = tabContent, Sections = {} }
        window.Tabs[tabName] = tab

        -- Tab switching
        tabBtn.MouseButton1Click:Connect(function()
            if window.ActiveTab then
                window.ActiveTab.Frame.Visible = false
            end
            tabContent.Visible = true
            window.ActiveTab = tab
        end)

        -- Section
        function tab:CreateSection(titleText)
            local sec = Instance.new("Frame", tabContent)
            sec.Size = UDim2.new(0.95, 0, 0, 0)
            sec.BackgroundColor3 = hex("#0B1220")
            sec.BackgroundTransparency = 0.15
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

            -- ✅ Toggle
            function section:AddToggle(name, callback)
                local btn = Instance.new("TextButton", sec)
                btn.Size = UDim2.new(0.9, 0, 0, 32)
                btn.BackgroundColor3 = hex("#0E1620")
                btn.Text = name .. " [OFF]"
                btn.TextColor3 = hex("#DDE6EE")
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

                local state = false
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    btn.Text = name .. (state and " [ON]" or " [OFF]")
                    pcall(callback, state)
                end)
            end

            -- ✅ Slider (simulasi klik, bisa diganti drag versi advance)
            function section:AddSlider(name, min, max, default, callback)
                local slider = Instance.new("TextButton", sec)
                slider.Size = UDim2.new(0.9, 0, 0, 32)
                slider.BackgroundColor3 = hex("#0E1620")
                slider.Text = name .. " [" .. default .. "]"
                slider.TextColor3 = hex("#DDE6EE")
                slider.Font = Enum.Font.Gotham
                slider.TextSize = 14
                Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

                slider.MouseButton1Click:Connect(function()
                    local val = math.random(min, max)
                    slider.Text = name .. " [" .. val .. "]"
                    pcall(callback, val)
                end)
            end

            -- ✅ Button
            function section:AddButton(name, callback)
                local btn = Instance.new("TextButton", sec)
                btn.Size = UDim2.new(0.9, 0, 0, 32)
                btn.BackgroundColor3 = hex("#0E1620")
                btn.Text = name
                btn.TextColor3 = hex("#DDE6EE")
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

                btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
            end

            -- ✅ Input Box
            function section:AddInput(name, callback)
                local box = Instance.new("TextBox", sec)
                box.Size = UDim2.new(0.9, 0, 0, 32)
                box.BackgroundColor3 = hex("#0E1620")
                box.PlaceholderText = name
                box.Text = ""
                box.TextColor3 = hex("#DDE6EE")
                box.Font = Enum.Font.Gotham
                box.TextSize = 14
                Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

                box.FocusLost:Connect(function()
                    pcall(callback, box.Text)
                end)
            end

            return section
        end

        return tab
    end

    return window
end

return QStyleUI
