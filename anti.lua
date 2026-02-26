-- [[ ZONHUB - ANTI LAVA MODULE ]] --
local TargetPage = ... 
if not TargetPage then return end

getgenv().ScriptVersion = "AntiLava v1.0 - Heat Resistance" 

-- ========================================== --
-- VARIABEL GLOBAL 
-- ========================================== --
getgenv().AntiLavaEnabled = false
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
CreateToggle(TargetPage, "Enable Anti Lava", "AntiLavaEnabled")

-- ========================================== --
-- LOGIKA TAHAN LAVA (GOD MODE BYPASS)
-- ========================================== --
RunService.Stepped:Connect(function()
    if getgenv().AntiLavaEnabled then
        pcall(function()
            local Char = LP.Character
            if Char then
                -- Metode 1: Mencari part bernama Lava di sekitar kaki dan mematikan tabrakannya
                for _, part in pairs(workspace:GetPartBoundsInBox(Char.PrimaryPart.CFrame, Vector3.new(4, 6, 4))) do
                    if part.Name:lower():find("lava") or part.Name:lower():find("magma") then
                        part.CanTouch = false -- Mematikan sensor panas lava agar tidak kena damage
                    end
                end
                
                -- Metode 2: Menghapus TouchInterest (sensor sentuhan damage) dari karakter
                for _, v in pairs(Char:GetDescendants()) do
                    if v:IsA("TouchTransmitter") then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end)
