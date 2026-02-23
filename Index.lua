-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- CLEAN
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
-- THEME
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
Title.TextXAlignment = Enum.TextXAlignment.Left

--------------------------------------------------
-- TAB FRAME
--------------------------------------------------
local TabFrame = Instance.new("Frame", Main)
TabFrame.Position = UDim2.new(0,0,0,40)
TabFrame.Size = UDim2.new(0,140,1,-40)
TabFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local TabLayout = Instance.new("UIListLayout", TabFrame)
TabLayout.Padding = UDim.new(0,6)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--------------------------------------------------
-- CONTENT FRAME (INI PENTING)
--------------------------------------------------
local Content = Instance.new("Frame", Main)
Content.Name = "Content"
Content.Position = UDim2.new(0,140,0,40)
Content.Size = UDim2.new(1,-140,1,-40)
Content.BackgroundTransparency = 1

--------------------------------------------------
-- SISTEM TAB ASLI (MINIMAL & AMAN)
--------------------------------------------------
local Tabs = {
    {
        Name = "Manager",
        Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/Manager.lua"
    },
    {
        Name = "Ability",
        Url = "https://raw.githubusercontent.com/zikriadirahman-commits/ZONHUB/refs/heads/main/terbang.lua"
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
        -- bersihkan content
        for _, v in ipairs(Content:GetChildren()) do
            v:Destroy()
        end

        -- pastikan script tau parent content
        getgenv().ZONHUB_CONTENT = Content

        local ok, data = pcall(function()
            return game:HttpGet(tab.Url)
        end)

        if ok then
            local f = loadstring(data)
            if f then
                f()
            end
        end
    end)
end
