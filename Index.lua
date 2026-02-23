-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- CLEAN OLD
pcall(function()
    if getgenv().ZONHUB then
        getgenv().ZONHUB:Destroy()
    end
end)

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZONHUB"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end
getgenv().ZONHUB = ScreenGui

--------------------------------------------------
-- THEME (ASLI)
--------------------------------------------------
local ACCENT = Color3.fromRGB(145, 90, 255)

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", Main).Color = ACCENT

--------------------------------------------------
-- HEADER
--------------------------------------------------
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,40)
Header.BackgroundColor3 = Color3.fromRGB(20,20,20)

local Title = Instance.new("TextLabel", Header)
Title.Text = "ZONHUB v0.60"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = ACCENT
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-90,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.TextXAlignment = Left

-- MINIMIZE
local Min = Instance.new("TextButton", Header)
Min.Text = "-"
Min.Font = Enum.Font.GothamBold
Min.TextSize = 22
Min.Size = UDim2.new(0,30,0,26)
Min.Position = UDim2.new(1,-70,0,7)
Min.BackgroundColor3 = Color3.fromRGB(45,45,45)
Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Min).CornerRadius = UDim.new(0,6)

-- CLOSE
local Close = Instance.new("TextButton", Header)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.Size = UDim2.new(0,30,0,26)
Close.Position = UDim2.new(1,-36,0,7)
Close.BackgroundColor3 = Color3.fromRGB(45,45,45)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,6)

--------------------------------------------------
-- TAB FRAME (SISTEM ASLI)
--------------------------------------------------
local TabFrame = Instance.new("Frame", Main)
TabFrame.Position = UDim2.new(0,0,0,40)
TabFrame.Size = UDim2.new(0,140,1,-40)
TabFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local TabLayout = Instance.new("UIListLayout", TabFrame)
TabLayout.Padding = UDim.new(0,6)
TabLayout.HorizontalAlignment = Center

--------------------------------------------------
-- CONTENT FRAME (SCROLLABLE)
--------------------------------------------------
local Content = Instance.new("ScrollingFrame", Main)
Content.Position = UDim2.new(0,140,0,40)
Content.Size = UDim2.new(1,-140,1,-40)
Content.CanvasSize = UDim2.new(0,0)
Content.ScrollBarThickness = 4
Content.BackgroundTransparency = 1

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.Padding = UDim.new(0,6)

--------------------------------------------------
-- MINIMIZED LOGO
--------------------------------------------------
local Mini = Instance.new("TextButton", ScreenGui)
Mini.Size = UDim2.new(0,58,0,58)
Mini.Position = UDim2.new(0,20,0.5,-29)
Mini.Text = "ZON"
Mini.Font = Enum.Font.GothamBlack
Mini.TextSize = 18
Mini.TextColor3 = ACCENT
Mini.BackgroundColor3 = Color3.fromRGB(30,30,30)
Mini.Visible = false
Instance.new("UICorner", Mini).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Mini).Color = ACCENT

--------------------------------------------------
-- MINIMIZE / CLOSE LOGIC
--------------------------------------------------
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--------------------------------------------------
-- 🔴 SISTEM TAB ASLI (DARI INDEX.LUA)
--------------------------------------------------
local Tabs = {
    {
        Name = "Manager",
        Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/Manager.lua"
    },
    {
        Name = "Autofarm",
        Url = "https://raw.githubusercontent.com/Koziz/CAW-SCRIPT/refs/heads/main/Autofarm.lua"
    }
}

for _, tab in ipairs(Tabs) do
    local Button = Instance.new("TextButton", TabFrame)
    Button.Size = UDim2.new(1,-12,0,30)
    Button.Text = tab.Name
    Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)

    Button.MouseButton1Click:Connect(function()
        for _, v in ipairs(Content:GetChildren()) do
            if v:IsA("Frame") or v:IsA("TextButton") then
                v:Destroy()
            end
        end

        local ok, result = pcall(function()
            return game:HttpGet(tab.Url)
        end)

        if ok then
            loadstring(result)()
        end
    end)
end
