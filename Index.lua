-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- CLEANING PREVIOUS UI
pcall(function()
    if getgenv().ZONHUB then getgenv().ZONHUB:Destroy() end
end)

-- MAIN SETTINGS
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255) -- Warna Biru Modern
local BG_COLOR = Color3.fromRGB(20, 20, 20)
local SIDEBAR_COLOR = Color3.fromRGB(25, 25, 25)

-- CREATE SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZONHUB_REBORN"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end
getgenv().ZONHUB = ScreenGui

-- MAIN FRAME
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BackgroundColor3 = BG_COLOR
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 1.5
MainStroke.Color = ACCENT_COLOR
MainStroke.Transparency = 0.5

-- SIDEBAR (TAB FRAME)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = SIDEBAR_COLOR
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Sidebar)
Title.Text = "ZONHUB"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = ACCENT_COLOR

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT FRAME
local Content = Instance.new("ScrollingFrame", Main)
Content.Name = "Content"
Content.Position = UDim2.new(0, 170, 0, 10)
Content.Size = UDim2.new(1, -180, 1, -20)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = ACCENT_COLOR

getgenv().ZONHUB_CONTENT = Content -- Penting untuk script eksternal

-- TAB SYSTEM LOGIC
local Tabs = {
    { Name = "Manager", Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/Manager.lua", Icon = "rbxassetid://10734945610" },
    { Name = "Ability", Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/terbang.lua", Icon = "rbxassetid://10734944510" }
}

local function CreateTab(info)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.Text = "  " .. info.Name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.AutoButtonColor = false

    local BtnCorner = Instance.new("UICorner", TabBtn)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    
    -- Hover Animation
    TabBtn.MouseEnter:Connect(function()
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    TabBtn.MouseLeave:Connect(function()
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)

    -- Click Logic
    TabBtn.MouseButton1Click:Connect(function()
        -- Clear Content
        for _, v in ipairs(Content:GetChildren()) do
            if not v:IsA("UIListLayout") then v:Destroy() end
        end

        -- Visual Feedback
        for _, other in ipairs(TabContainer:GetChildren()) do
            if other:IsA("TextButton") then
                other.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        TabBtn.TextColor3 = ACCENT_COLOR

        -- Load Script
        local success, scriptData = pcall(function()
            return game:HttpGet(info.Url)
        end)

        if success then
            local func = loadstring(scriptData)
            if func then
                task.spawn(func)
            end
        end
    end)
end

-- Load all tabs
for _, tabData in ipairs(Tabs) do
    CreateTab(tabData)
end

-- Dragging System
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
