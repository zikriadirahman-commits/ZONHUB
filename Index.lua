-- ScreenGui
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- clear old
pcall(function() if getgenv().ZonHubUI then getgenv().ZonHubUI:Destroy() end end)

-- new ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZonHubUI"
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = LP:WaitForChild("PlayerGui") end
screenGui.ResetOnSpawn = false
getgenv().ZonHubUI = screenGui

-- theme/colors
local Theme = {
    Bg = Color3.fromRGB(30,30,30),
    Header = Color3.fromRGB(20,20,20),
    Btn = Color3.fromRGB(40,40,40),
    TabActive = Color3.fromRGB(140,80,255),
    Text = Color3.fromRGB(255,255,255),
}

-- main frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", mainFrame).Color = Theme.TabActive

-- header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,40)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Theme.Header

local title = Instance.new("TextLabel", header)
title.Text = "ZonHub v0.60"
title.TextColor3 = Theme.TabActive
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Size = UDim2.new(0.5,0,1,0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0,10,0,0)

-- close button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,30,0,26)
closeBtn.Position = UDim2.new(1,-40,0,7)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Theme.Text
closeBtn.BackgroundColor3 = Theme.Btn
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- draggable
local function makeDraggable(frame, dragArea)
    local dragging, dragInput, startPos, startMouse
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startMouse = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startMouse
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset+delta.X,
                startPos.Y.Scale, startPos.Y.Offset+delta.Y
            )
        end
    end)
end
makeDraggable(mainFrame, header)

-- sidebar (tabs)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0,140,1,-40)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.BackgroundColor3 = Theme.Header

local tabList = Instance.new("UIListLayout", sidebar)
tabList.Padding = UDim.new(0,8)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- content pages container
local pageHolder = Instance.new("Frame", mainFrame)
pageHolder.Size = UDim2.new(1,-150,1,-50)
pageHolder.Position = UDim2.new(0,150,0,45)
pageHolder.BackgroundTransparency = 1

-- tab/page storage
local Tabs = {}
local Pages = {}

-- create tab function
local function createTab(name, description, scriptUrl)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.9,0,0,35)
    btn.BackgroundColor3 = Theme.Btn
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    local page = Instance.new("ScrollingFrame", pageHolder)
    page.Size = UDim2.new(1,0,1,0)
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0)
    page.ScrollBarThickness = 4
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0,6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- header area inside page
    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1,0,0,25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name.." Module"
    titleLabel.TextColor3 = Theme.TabActive
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel", page)
    descLabel.Size = UDim2.new(1,0,0,30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description or ""
    descLabel.TextColor3 = Color3.fromRGB(180,180,180)
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true

    local statusLabel = Instance.new("TextLabel", page)
    statusLabel.Size = UDim2.new(1,0,0,25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Click tab to load script..."
    statusLabel.TextColor3 = Theme.Text
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14

    -- load script when clicked
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        for _, tBtn in pairs(Tabs) do
            tBtn.BackgroundColor3 = Theme.Btn
            tBtn.TextColor3 = Theme.Text
        end

        page.Visible = true
        btn.BackgroundColor3 = Theme.TabActive
        btn.TextColor3 = Color3.fromRGB(255,255,255)

        if scriptUrl and scriptUrl ~= "" then
            statusLabel.Text = "Loading script..."
            task.spawn(function()
                local ok, data = pcall(function()
                    return game:HttpGet(scriptUrl, true)
                end)
                if ok and data then
                    local func, err = loadstring(data)
                    if func then
                        local _ok2, err2 = pcall(func, page)
                        if _ok2 then
                            statusLabel:Destroy()
                        else
                            statusLabel.Text = "Error execute: "..tostring(err2)
                        end
                    else
                        statusLabel.Text = "Compile error"
                    end
                else
                    statusLabel.Text = "Failed to get script"
                end
            end)
        end
    end)

    table.insert(Tabs, btn)
    table.insert(Pages, page)
end

-- add your tabs (example using old system)
createTab("Manager","Manage items etc","https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/Manager.lua")
createTab("Auto Farm","Sistem farming resource Kayu, Batu","https://raw.githubusercontent.com/Koziz/CAW-SCRIPT/refs/heads/main/Autofarm.lua")
createTab("Ability","Fly / other systems","https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/terbang.lua")
-- TODO: add more tabs like old hub but adapted

-- open first tab by default
if #Tabs > 0 then
    Tabs[1]:MouseButton1Click()
end
