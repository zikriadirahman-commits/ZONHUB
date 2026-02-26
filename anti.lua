-- [[ ZONHUB - ANTI LAVA MODULE (UI FIX) ]] --
local TargetPage = ... 
if not TargetPage then return end

local G = getgenv()
G.AutoLavaEnabled = false

-- ========================================== --
-- FUNGSI UI UTILITY (DIJAMIN MUNCUL)
-- ========================================== --
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local function CreateToggle(Parent, Text, Var) 
    local Btn = Instance.new("TextButton", Parent)
    Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false
    local C = Instance.new("UICorner", Btn); C.CornerRadius = UDim.new(0, 6)
    local T = Instance.new("TextLabel", Btn)
    T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
    local IndBg = Instance.new("Frame", Btn)
    IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    local IC = Instance.new("UICorner", IndBg); IC.CornerRadius = UDim.new(1,0)
    local Dot = Instance.new("Frame", IndBg)
    Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local DC = Instance.new("UICorner", Dot); DC.CornerRadius = UDim.new(1,0)
    
    Btn.MouseButton1Click:Connect(function() 
        G[Var] = not G[Var]
        if G[Var] then 
            Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true)
            Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple 
        else 
            Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true)
            Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) 
        end 
    end) 
end

-- ========================================== --
-- MOUNTING UI (LOOP SAMPAI MUNCUL)
-- ========================================== --
task.spawn(function()
    local container = nil
    -- Cari ScrollingFrame atau Frame utama di TargetPage
    for i = 1, 20 do
        container = TargetPage:FindFirstChildWhichIsA("ScrollingFrame", true) or TargetPage:FindFirstChild("Content", true) or TargetPage
        if container then break end
        task.wait(0.5)
    end
    
    if container then
        -- Bersihkan UI lama jika ada
        for _, v in pairs(container:GetChildren()) do
            if v.Name == "LavaControl" then v:Destroy() end
        end
        
        local Holder = Instance.new("Frame", container)
        Holder.Name = "LavaControl"
        Holder.Size = UDim2.new(1, 0, 0, 50)
        Holder.BackgroundTransparency = 1
        
        CreateToggle(Holder, "Enable Anti Lava (God)", "AutoLavaEnabled")
    end
end)

-- ========================================== --
-- LOGIKA ANTI LAVA (TOTAL IMMUNITY)
-- ========================================== --
game:GetService("RunService").Heartbeat:Connect(function()
    if G.AutoLavaEnabled then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                -- 1. Hapus sensor damage sentuhan (TouchInterest)
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("TouchTransmitter") then
                        v:Destroy()
                    end
                end
                
                -- 2. Paksa State agar tidak loncat-loncat
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
                
                -- 3. Bypass deteksi lava di sekitar kaki
                for _, part in pairs(workspace:GetPartBoundsInBox(char.PrimaryPart.CFrame, Vector3.new(4, 6, 4))) do
                    if part.Name:lower():find("lava") or part.Name:lower():find("magma") then
                        part.CanTouch = false
                        part.CanCollide = true -- Tetap bisa diinjak tapi tidak panas
                    end
                end
            end
        end)
    end
end)
