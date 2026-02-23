-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- CLEAN OLD GUI
if getgenv().ZONHUB then
    getgenv().ZONHUB:Destroy()
end

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZONHUB_V2"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end
getgenv().ZONHUB = ScreenGui

-- THEME COLORS
local BG_COLOR = Color3.fromRGB(25, 25, 25)
local ACCENT = Color3.fromRGB(145, 90, 255)
local TEXT_COLOR = Color3.fromRGB(240, 240, 240)

--------------------------------------------------
-- DRAG SYSTEM FUNCTION
--------------------------------------------------
local function MakeDraggable(topbarobject, object)
    local dragging, dragInput, dragStart, startPos
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)
    topbarobject.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = BG_COLOR
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = ACCENT

-- MINIMIZE LOGO (ZON BUTTON)
local MinBtn = Instance.new("TextButton", ScreenGui)
MinBtn.Name = "ZON_LOGO"
MinBtn.Size = UDim2.new(0, 50, 0, 50)
MinBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
MinBtn.BackgroundColor3 = ACCENT
MinBtn.Text = "ZON"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.TextSize = 16
MinBtn.Visible = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MinBtn).Thickness = 2

--------------------------------------------------
-- HEADER & CONTROLS
--------------------------------------------------
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)
MakeDraggable(Header, Main)

local Title = Instance.new("TextLabel", Header)
Title.Text = "ZONHUB V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = ACCENT
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 5)

-- MINIMIZE BUTTON
local Mini = Instance.new("TextButton", Header)
Mini.Size = UDim2.new(0, 30, 0, 30)
Mini.Position = UDim2.new(1, -70, 0, 2)
Mini.Text = "-"
Mini.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 5)

-- LOGIC MIN/CLOSE
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
Mini.MouseButton1Click:Connect(function() 
    Main.Visible = false 
    MinBtn.Visible = true 
end)
MinBtn.MouseButton1Click:Connect(function() 
    Main.Visible = true 
    MinBtn.Visible = false 
end)

--------------------------------------------------
-- SIDEBAR (TABS)
--------------------------------------------------
local Sidebar = Instance.new("Frame", Main)
Sidebar.Position = UDim2.new(0, 5, 0, 40)
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", Sidebar)

local TabList = Instance.new("UIListLayout", Sidebar)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

--------------------------------------------------
-- CONTENT AREA (CONTAINER)
--------------------------------------------------
local Content = Instance.new("ScrollingFrame", Main)
Content.Name = "Content"
Content.Position = UDim2.new(0, 130, 0, 40)
Content.Size = UDim2.new(1, -135, 1, -45)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 2

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

--------------------------------------------------
-- TAB LOADER SYSTEM
--------------------------------------------------
local Tabs = {
    { Name = "Manager", Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/Manager.lua" },
    { Name = "Ability", Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/terbang.lua" }
}

for _, tab in ipairs(Tabs) do
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0, 110, 0, 35)
    TabBtn.Text = tab.Name
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        -- Clear Content
        for _, v in ipairs(Content:GetChildren()) do
            if not v:IsA("UIListLayout") then v:Destroy() end
        end

        -- Fix Content Visibility: Global Parent
        getgenv().ZONHUB_CONTENT = Content

        local success, data = pcall(function() return game:HttpGet(tab.Url) end)
        if success then
            local func, err = loadstring(data)
            if func then
                -- Menjalankan content script
                func()
                -- Update canvas size agar bisa di scroll jika konten banyak
                Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            else
                warn("Error loading tab: " .. tostring(err))
            end
        end
    end)
end

-- Default Load First Tab
spawn(function()
    if Tabs[1] then
        -- Trigger click manually or call load logic
    end
end)
