-- [[ ZONHUB - FLY MODULE (INVISIBLE PLATFORM) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "FlyModule v3.0 - Platform Mode" 

-- ========================================== --
-- VARIABEL GLOBAL 
-- ========================================== --
getgenv().FlyEnabled = false
getgenv().FlySpeed = 50
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ========================================== --
-- FUNGSI UI UTILITY
-- ========================================== --
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local function CreateToggle(Parent, Text, Var) 
    local Btn = Instance.new("TextButton", Parent); Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false
    local C = Instance.new("UICorner", Btn); C.CornerRadius = UDim.new(0, 6)
    local T = Instance.new("TextLabel", Btn); T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
    local IndBg = Instance.new("Frame", Btn); IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    local IC = Instance.new("UICorner", IndBg); IC.CornerRadius = UDim.new(1,0)
    local Dot = Instance.new("Frame", IndBg); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local DC = Instance.new("UICorner", Dot); DC.CornerRadius = UDim.new(1,0)
    
    Btn.MouseButton1Click:Connect(function() 
        getgenv()[Var] = not getgenv()[Var]
        if getgenv()[Var] then 
            Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true)
            Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple 
        else 
            Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true)
            Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) 
        end 
    end) 
end

-- ========================================== --
-- MEMBANGUN MENU UI 
-- ========================================== --
CreateToggle(TargetPage, "Enable Fly (Platform)", "FlyEnabled")

-- ========================================== --
-- LOGIKA PLATFORM TERBANG
-- ========================================== --
local Platform = Instance.new("Part")
Platform.Name = "ZonFly_Platform"
Platform.Size = Vector3.new(4, 1, 4)
Platform.Transparency = 1 -- Ubah ke 0.5 jika ingin melihat pijakannya
Platform.Anchored = true
Platform.CanCollide = true

RunService.RenderStepped:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    
    if getgenv().FlyEnabled and Root then
        Platform.Parent = workspace
        -- Platform selalu berada tepat di bawah kaki (HumanoidRootPart - 3.5 unit)
        Platform.CFrame = Root.CFrame * CFrame.new(0, -3.5, 0)
    else
        Platform.Parent = nil
    end
end)

-- Kontrol Naik/Turun menggunakan Space dan LeftControl
local UIS = game:GetService("UserInputService")
RunService.Heartbeat:Connect(function()
    if getgenv().FlyEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LP.Character.HumanoidRootPart
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            Root.CFrame = Root.CFrame * CFrame.new(0, 0.5, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            Root.CFrame = Root.CFrame * CFrame.new(0, -0.5, 0)
        end
    end
end)
