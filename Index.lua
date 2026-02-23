-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- CLEAN OLD
pcall(function()
    if getgenv().ZonHubUI then
        getgenv().ZonHubUI:Destroy()
    end
end)

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZonHubUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end
getgenv().ZonHubUI = ScreenGui

-- THEME
local Theme = {
    Main = Color3.fromRGB(30,30,30),
    Header = Color3.fromRGB(20,20,20),
    Button = Color3.fromRGB(40,40,40),
    Accent = Color3.fromRGB(145, 90, 255), -- ungu awal
    Text = Color3.fromRGB(240,240,240)
}

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 540, 0, 380)
Main.Position = UDim2.new(0.5, -270, 0.5, -190)
Main.BackgroundColor3 = Theme.Main
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", Main).Color = Theme.Accent

------------------------------------------------
-- HEADER
------------------------------------------------
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,42)
Header.BackgroundColor3 = Theme.Header
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel", Header)
Title.Text = "ZONHUB v0.60"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Theme.Accent
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-120,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.TextXAlignment = Left

-- MINIMIZE
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.Size = UDim2.new(0,30,0,26)
MinBtn.Position = UDim2.new(1,-74,0,8)
MinBtn.BackgroundColor3 = Theme.Button
MinBtn.TextColor3 = Theme.Text
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

-- CLOSE
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Size = UDim2.new(0,30,0,26)
CloseBtn.Position = UDim2.new(1,-38,0,8)
CloseBtn.BackgroundColor3 = Theme.Button
CloseBtn.TextColor3 = Theme.Text
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

------------------------------------------------
-- SIDEBAR
------------------------------------------------
local Sidebar = Instance.new("Frame", Main)
Sidebar.Position = UDim2.new(0,0,0,42)
Sidebar.Size = UDim2.new(0,150,1,-42)
Sidebar.BackgroundColor3 = Theme.Header

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0,8)
SideLayout.HorizontalAlignment = Center

------------------------------------------------
-- CONTENT (SCROLLABLE)
------------------------------------------------
local Pages = Instance.new("Frame", Main)
Pages.Position = UDim2.new(0,150,0,42)
Pages.Size = UDim2.new(1,-150,1,-42)
Pages.BackgroundTransparency = 1

------------------------------------------------
-- MINIMIZED LOGO
------------------------------------------------
local MiniLogo = Instance.new("TextButton", ScreenGui)
MiniLogo.Size = UDim2.new(0,60,0,60)
MiniLogo.Position = UDim2.new(0,20,0.5,-30)
MiniLogo.BackgroundColor3 = Theme.Main
MiniLogo.Text = "ZON"
MiniLogo.Font = Enum.Font.GothamBlack
MiniLogo.TextSize = 18
MiniLogo.TextColor3 = Theme.Accent
MiniLogo.Visible = false
Instance.new("UICorner", MiniLogo).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", MiniLogo).Color = Theme.Accent

------------------------------------------------
-- TAB SYSTEM
------------------------------------------------
local Tabs = {}
local PagesList = {}

local function CreateTab(name, url)
    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(0.9,0,0,34)
    Tab.Text = name
    Tab.Font = Enum.Font.Gotham
    Tab.TextSize = 14
    Tab.BackgroundColor3 = Theme.Button
    Tab.TextColor3 = Theme.Text
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0,6)

    local Page = Instance.new("ScrollingFrame", Pages)
    Page.Size = UDim2.new(1,0,1,0)
    Page.ScrollBarThickness = 4
    Page.CanvasSize = UDim2.new(0,0)
    Page.Visible = false
    Page.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0,8)

    Tab.MouseButton1Click:Connect(function()
        for _,p in pairs(PagesList) do p.Visible = false end
        for _,t in pairs(Tabs) do t.BackgroundColor3 = Theme.Button end

        Page.Visible = true
        Tab.BackgroundColor3 = Theme.Accent

        if url then
            task.spawn(function()
                pcall(function()
                    loadstring(game:HttpGet(url,true))()
                end)
            end)
        end
    end)

    table.insert(Tabs, Tab)
    table.insert(PagesList, Page)
end

------------------------------------------------
-- BUTTON LOGIC
------------------------------------------------
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniLogo.Visible = true
end)

MiniLogo.MouseButton1Click:Connect(function()
    Main.Visible = true
    MiniLogo.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

------------------------------------------------
-- EXAMPLE TABS (sesuai sistem lama)
------------------------------------------------
CreateTab("Manager", "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/Manager.lua")
CreateTab("Autofarm", "https://raw.githubusercontent.com/Koziz/CAW-SCRIPT/refs/heads/main/Autofarm.lua")
CreateTab("Pabrik", "hhttps://raw.githubusercontent.com/Koziz/CAW-SCRIPT/refs/heads/main/Pabrik.lua")
CreateTab("Ability", "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/terbang.lua")


if Tabs[1] then Tabs[1]:MouseButton1Click() end
