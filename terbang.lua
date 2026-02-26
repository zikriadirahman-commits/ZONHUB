-- [[ ZONHUB - FLY MODULE (REAL-TIME BUILD) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "FlyModule v1.0 - Smooth Build" 

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
    local Btn = Instance.new("TextButton", Parent); Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false; 
    local C = Instance.new("UICorner", Btn); C.CornerRadius = UDim.new(0, 6); 
    local T = Instance.new("TextLabel", Btn); T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; 
    local IndBg = Instance.new("Frame", Btn); IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30); 
    local IC = Instance.new("UICorner", IndBg); IC.CornerRadius = UDim.new(1,0); 
    local Dot = Instance.new("Frame", IndBg); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); 
    local DC = Instance.new("UICorner", Dot); DC.CornerRadius = UDim.new(1,0); 

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

local function CreateSlider(Parent, Text, Min, Max, Default, Var)
    local Frame = Instance.new("Frame", Parent); Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 45); 
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame); Label.Text = Text .. ": " .. Default; Label.Size = UDim2.new(1, -20, 0, 20); Label.Position = UDim2.new(0, 10, 0, 5); Label.BackgroundTransparency = 1; Label.TextColor3 = Theme.Text; Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 11; Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBG = Instance.new("Frame", Frame); SliderBG.Size = UDim2.new(1, -20, 0, 4); SliderBG.Position = UDim2.new(0, 10, 0, 32); SliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    local Fill = Instance.new("Frame", SliderBG); Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0); Fill.BackgroundColor3 = Theme.Purple
    
    -- Slider Logic bisa ditambahkan sesuai kebutuhan UI Framework kamu
    getgenv()[Var] = Default
end

-- ========================================== --
-- MEMBANGUN MENU UI 
-- ========================================== --
CreateToggle(TargetPage, "Enable Fly", "FlyEnabled")
CreateSlider(TargetPage, "Fly Speed", 10, 200, 50, "FlySpeed")

-- ========================================== --
-- LOGIKA FLY (SMOOTH & STABLE)
-- ========================================== --
local BodyVel = Instance.new("BodyVelocity")
BodyVel.MaxForce = Vector3.new(0, 0, 0)
BodyVel.Velocity = Vector3.new(0, 0, 0)

RunService.RenderSteps:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChild("Humanoid")
    
    if getgenv().FlyEnabled and Root and Hum then
        BodyVel.Parent = Root
        BodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        local Dir = Hum.MoveDirection
        -- Logika terbang ke arah kamera atau arah jalan
        BodyVel.Velocity = Dir * getgenv().FlySpeed
        
        -- Mencegah karakter jatuh
        if Dir.Magnitude == 0 then
            BodyVel.Velocity = Vector3.new(0, 0.1, 0)
        end
    else
        BodyVel.Parent = nil
        BodyVel.MaxForce = Vector3.new(0, 0, 0)
    end
end)
