-- [[ KZOYZ HUB - MANAGER MODULE (FIXED & INDEPENDENT) ]] --
local TargetPage = ... 

-- Perbaikan agar tidak error jika dijalankan tanpa Index
if not TargetPage then 
    warn("Running in standalone mode (TargetPage not found)")
    -- Membuat folder dummy atau menggunakan ScreenGui jika TargetPage kosong
    TargetPage = Instance.new("ScrollingFrame")
    TargetPage.Name = "StandaloneManager"
    TargetPage.Size = UDim2.new(0, 200, 0, 300)
    TargetPage.Parent = game:GetService("CoreGui"):FindFirstChild("KzoyzHub") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui")
end

getgenv().ScriptVersion = "Manager v1.1 - Magnet Edition" 

-- ========================================== --
getgenv().DropDelay = 2     
getgenv().MagnetRadius = 15 -- Slider akan mengubah nilai ini
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser") 

-- Mencegah AFK 
LP.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

getgenv().AutoCollect = false;
getgenv().AutoDrop = false; 
getgenv().DropAmount = 50;

-- Fungsi UI Utility [cite: 7, 8, 9, 14, 15, 18, 20]
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

function CreateToggle(Parent, Text, Var, OnToggle) 
    local Btn = Instance.new("TextButton")
    Btn.Parent = Parent; Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""
    local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Btn
    local T = Instance.new("TextLabel"); T.Parent = Btn; T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
    local IndBg = Instance.new("Frame"); IndBg.Parent = Btn; IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(1,0); IC.Parent = IndBg
    local Dot = Instance.new("Frame"); Dot.Parent = IndBg; Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(1,0); DC.Parent = Dot
    Btn.MouseButton1Click:Connect(function() 
        getgenv()[Var] = not getgenv()[Var]
        if getgenv()[Var] then 
            Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple 
        else 
            Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) 
        end 
        if OnToggle then OnToggle(getgenv()[Var]) end 
    end) 
end

function CreateSlider(Parent, Text, Min, Max, Default, Var) 
    local Frame = Instance.new("Frame"); Frame.Parent = Parent; Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 45)
    local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Frame
    local Label = Instance.new("TextLabel"); Label.Parent = Frame; Label.Text = Text .. ": " .. Default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
    local SliderBg = Instance.new("TextButton"); SliderBg.Parent = Frame; SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""
    local Fill = Instance.new("Frame"); Fill.Parent = SliderBg; Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0)
    local Dragging = false
    local function Update(input)
        local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local Val = math.floor(Min + ((Max - Min) * SizeX))
        Fill.Size = UDim2.new(SizeX, 0, 1, 0)
        Label.Text = Text .. ": " .. Val
        getgenv()[Var] = Val
    end
    SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
    UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
end

-- Inject Elemen UI
CreateToggle(TargetPage, "Enable Magnet Collect", "AutoCollect")
CreateSlider(TargetPage, "Magnet Radius", 1, 50, 15, "MagnetRadius")
CreateToggle(TargetPage, "Auto Drop", "AutoDrop")
CreateSlider(TargetPage, "Drop Amount", 1, 200, 50, "DropAmount")

-- Logic Mesin
local Remotes = RS:WaitForChild("Remotes")
local RemoteDropSafe = Remotes:WaitForChild("PlayerDrop") [cite: 40]
local ManagerRemote = RS:WaitForChild("Managers"):WaitForChild("UIManager"):WaitForChild("UIPromptEvent") [cite: 41]

-- Thread 1: Auto Drop Logic [cite: 40, 41]
task.spawn(function() 
    while true do 
        if getgenv().AutoDrop then 
            local Amt = getgenv().DropAmount
            pcall(function() 
                -- Logika drop item [cite: 40, 41]
                ManagerRemote:FireServer(unpack({{ ButtonAction = "drp", Inputs = { amt = tostring(Amt) } }})) 
            end) 
        end
        task.wait(getgenv().DropDelay) 
    end 
end)

-- Thread 2: Magnet Collect (Menarik item ke karakter)
task.spawn(function() 
    while true do 
        if getgenv().AutoCollect then 
            pcall(function()
                local Char = LP.Character
                local Root = Char and Char:FindFirstChild("HumanoidRootPart")
                -- Cari folder item di workspace (DroppedItems adalah folder umum di game ini)
                local ItemsFolder = workspace:FindFirstChild("DroppedItems") or workspace:FindFirstChild("Items") or workspace
                
                if Root then
                    for _, item in pairs(ItemsFolder:GetChildren()) do
                        if item:IsA("Model") or item:IsA("BasePart") then
                            local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                            if part and (Root.Position - part.Position).Magnitude <= getgenv().MagnetRadius then
                                -- Tarik item ke posisi karakter agar terambil otomatis
                                part.CFrame = Root.CFrame
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1) 
    end 
end)
