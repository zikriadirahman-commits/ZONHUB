-- [[ ZONHUB - ANTI LAVA ULTIMATE FIX ]] --
local TargetPage = ... 
if not TargetPage then return end

getgenv().ScriptVersion = "AntiLava v2.0 - God Mode" 

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
CreateToggle(TargetPage, "Enable God Anti Lava", "AntiLavaEnabled")

-- ========================================== --
-- LOGIKA ANTI DAMAGE & ANTI LONCAT
-- ========================================== --
RunService.Heartbeat:Connect(function()
    if getgenv().AntiLavaEnabled then
        pcall(function()
            local Char = LP.Character
            local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
            
            if Hum then
                -- 1. Matikan Force Loncat Otomatis (Mencegah loncat-loncat)
                if Hum:GetState() == Enum.HumanoidStateType.Jumping or Hum:GetState() == Enum.HumanoidStateType.FallingDown then
                    -- Jika sedang di atas lava, paksa state ke Running agar tidak mental
                    Hum:ChangeState(Enum.HumanoidStateType.Running)
                end

                -- 2. Anti Damage (Menghapus LocalScript Damage jika ada)
                -- Banyak game pakai script 'LavaDamage' di dalam karakter
                local dScript = Char:FindFirstChild("LavaDamage") or Char:FindFirstChild("HitHandler")
                if dScript then dScript.Disabled = true end

                -- 3. Mencari objek lava dan mematikan sensor sentuhnya secara paksa
                for _, part in pairs(workspace:GetPartBoundsInBox(Char.PrimaryPart.CFrame, Vector3.new(5, 8, 5))) do
                    if part:IsA("BasePart") and (part.Name:lower():find("lava") or part.Name:lower():find("magma")) then
                        part.CanTouch = false
                        -- Tambahan: Supaya tidak licin/mental
                        part.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
                    end
                end
            end
        end)
    end
end)
