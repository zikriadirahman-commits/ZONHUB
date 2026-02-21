-- [[ ZONHUB - MANAGER MODULE (INJECTED) ]] --
local TargetPage = ...
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "Manager v1.1 - Magnet Edition" 

-- ========================================== --
getgenv().DropDelay = 2     
getgenv().StepDelay = 0.1   
getgenv().GridSize = 4.5 
getgenv().MagnetRadius = 15 -- Default radius sedotan
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser") 

local PlayerMovement
pcall(function() PlayerMovement = require(LP.PlayerScripts:WaitForChild("PlayerMovement")) end) [cite: 1]

LP.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) [cite: 1]

getgenv().AutoCollect = false; [cite: 1]
getgenv().AutoDrop = false; getgenv().DropAmount = 50; getgenv().TargetPosX = 0; getgenv().TargetPosY = 0 [cite: 2]

local function ManageUIState(Mode) [cite: 2]
    local PG = LP:FindFirstChild("PlayerGui")
    if not PG then return end
    if Mode == "Normal" then
        local prompts = {PG:FindFirstChild("UIPromptUI"), PG:FindFirstChild("UIPrompt")}
        for _, prompt in pairs(prompts) do if prompt then for _, v in pairs(prompt:GetChildren()) do if v:IsA("Frame") then v.Visible = true end end end end
        local RestoredUI = {"GemsUI", "TopbarCentered", "TopbarCenteredClipped", "TopbarStandard", "TopbarStandardClipped", "ExperienceChat"} [cite: 2]
   
        for _, name in pairs(RestoredUI) do local ui = PG:FindFirstChild(name); [cite: 3]
        if ui and ui:IsA("ScreenGui") then ui.Enabled = true end end [cite: 4]
    elseif Mode == "Dropping" then
        if PlayerMovement then PlayerMovement.InputActive = true end
        if PG:FindFirstChild("TouchGui") then PG.TouchGui.Enabled = true end
        if PG:FindFirstChild("InventoryUI") then PG.InventoryUI.Enabled = true end
        if PG:FindFirstChild("ExperienceChat") then PG.ExperienceChat.Enabled = true end
        local prompts = {PG:FindFirstChild("UIPromptUI"), PG:FindFirstChild("UIPrompt")}
        for _, prompt in pairs(prompts) do if [cite: 4]
        prompt then for _, v in pairs(prompt:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end end end [cite: 5]
    end
end

local function FindInventoryModule() [cite: 5]
    local Candidates = {}
    for _, v in pairs(RS:GetDescendants()) do if v:IsA("ModuleScript") and (v.Name:match("Inventory") or v.Name:match("Hotbar") or v.Name:match("Client")) then table.insert(Candidates, v) end end
    if LP:FindFirstChild("PlayerScripts") then for _, v in pairs(LP.PlayerScripts:GetDescendants()) do if v:IsA("ModuleScript") and (v.Name:match("Inventory") or v.Name:match("Hotbar")) then table.insert(Candidates, v) end end end
    for _, module in pairs(Candidates) do local success, result = pcall(require, module); [cite: 5]
    if success and type(result) == "table" then if result.GetSelectedHotbarItem or result.GetSelectedItem or result.GetEquippedItem then return result end end end [cite: 6]
    return nil
end
getgenv().GameInventoryModule = FindInventoryModule() [cite: 6]

local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) } [cite: 6]

function CreateToggle(Parent, Text, Var, OnToggle) local Btn = Instance.new("TextButton"); [cite: 6]
    Btn.Parent = Parent; Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false; [cite: 7]
    local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Btn; local T = Instance.new("TextLabel"); T.Parent = Btn; [cite: 8]
    T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); [cite: 9]
    T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; local IndBg = Instance.new("Frame"); IndBg.Parent = Btn; [cite: 10]
    IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30); local IC = Instance.new("UICorner"); [cite: 11]
    IC.CornerRadius = UDim.new(1,0); IC.Parent = IndBg; local Dot = Instance.new("Frame"); Dot.Parent = IndBg; Dot.Size = UDim2.new(0, 14, 0, 14); [cite: 12]
    Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(1,0); DC.Parent = Dot; [cite: 13]
    Btn.MouseButton1Click:Connect(function() getgenv()[Var] = not getgenv()[Var]; if getgenv()[Var] then Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple else Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) end if OnToggle then OnToggle(getgenv()[Var]) end end) end [cite: 14]

function CreateSlider(Parent, Text, Min, Max, Default, Var) local Frame = Instance.new("Frame"); [cite: 14]
    Frame.Parent = Parent; Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 45); local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); [cite: 15]
    C.Parent = Frame; local Label = Instance.new("TextLabel"); Label.Parent = Frame; Label.Text = Text .. ": " .. Default; [cite: 16]
    Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); [cite: 17]
    Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; local SliderBg = Instance.new("TextButton"); SliderBg.Parent = Frame; [cite: 18]
    SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""; [cite: 19]
    SliderBg.AutoButtonColor = false; local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(1,0); SC.Parent = SliderBg; local Fill = Instance.new("Frame"); Fill.Parent = SliderBg; [cite: 20]
    Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new(0.5, 0, 1, 0); local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1,0); FC.Parent = Fill; [cite: 21]
    local Dragging = false; local function Update(input) local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1); [cite: 22]
    local Val = math.floor(Min + ((Max - Min) * SizeX)); Fill.Size = UDim2.new(SizeX, 0, 1, 0); [cite: 23]
    Label.Text = Text .. ": " .. Val; getgenv()[Var] = Val end; [cite: 24]
    SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end); [cite: 25]
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end); [cite: 26]
    UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end) end [cite: 27]

function CreateTextBox(Parent, Text, Default, Var) local Frame = Instance.new("Frame"); [cite: 27]
    Frame.Parent = Parent; Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 35); local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); [cite: 28]
    C.Parent = Frame; local Label = Instance.new("TextLabel"); Label.Parent = Frame; Label.Text = Text; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; [cite: 29]
    Label.Size = UDim2.new(0.5, 0, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; [cite: 30]
    Label.TextXAlignment = Enum.TextXAlignment.Left; local InputBox = Instance.new("TextBox"); InputBox.Parent = Frame; InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30); [cite: 31]
    InputBox.Position = UDim2.new(0.6, 0, 0.15, 0); InputBox.Size = UDim2.new(0.35, 0, 0.7, 0); InputBox.Font = Enum.Font.GothamSemibold; InputBox.TextSize = 12; [cite: 32]
    InputBox.TextColor3 = Theme.Text; InputBox.Text = tostring(Default); local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(0, 4); IC.Parent = InputBox; [cite: 33]
    InputBox.FocusLost:Connect(function() local val = tonumber(InputBox.Text); if val then getgenv()[Var] = val else InputBox.Text = tostring(getgenv()[Var]) end end); [cite: 34]
    return InputBox end

-- Inject Elemen ke UI [cite: 38]
CreateToggle(TargetPage, "Enable Magnet Collect", "AutoCollect")
CreateSlider(TargetPage, "Magnet Radius", 1, 50, 15, "MagnetRadius") -- Slider baru untuk jarak sedotan 

--- Horizontal Rule ---

CreateToggle(TargetPage, "Auto Drop", "AutoDrop", function(state) if not state then ManageUIState("Normal") end end) [cite: 39]
CreateSlider(TargetPage, "Drop Amount", 1, 200, 50, "DropAmount") [cite: 39]

-- Logic Mesin
local Remotes = RS:WaitForChild("Remotes") [cite: 39]
local RemoteDropSafe = Remotes:WaitForChild("PlayerDrop") 
local ManagerRemote = RS:WaitForChild("Managers"):WaitForChild("UIManager"):WaitForChild("UIPromptEvent") 

RunService.RenderStepped:Connect(function() if getgenv().AutoDrop then ManageUIState("Dropping") end end) [cite: 39]

-- Thread 1: Auto Drop Logic [cite: 40]
task.spawn(function() while true do if getgenv().AutoDrop then local Amt = getgenv().DropAmount;
    pcall(function() if getgenv().GameInventoryModule then local _, slot; if getgenv().GameInventoryModule.GetSelectedHotbarItem then _, slot = getgenv().GameInventoryModule.GetSelectedHotbarItem() elseif getgenv().GameInventoryModule.GetSelectedItem then _, slot = getgenv().GameInventoryModule.GetSelectedItem() end; if slot then RemoteDropSafe:FireServer(slot, Amt) end end end); [cite: 40]
    pcall(function() ManagerRemote:FireServer(unpack({{ ButtonAction = "drp", Inputs = { amt = tostring(Amt) } }})) end) end; [cite: 41]
    task.wait(getgenv().DropDelay) end end) [cite: 42]

-- Thread 2: NEW Magnet Collect Logic (Tanpa Gerak) 
task.spawn(function() 
    while true do 
        if getgenv().AutoCollect then 
            pcall(function()
                -- Mencoba mencari folder item yang umum di game Roblox
                local ItemsFolder = workspace:FindFirstChild("DroppedItems") or workspace:FindFirstChild("Items") or workspace
                local Char = LP.Character
                local Root = Char and Char:FindFirstChild("HumanoidRootPart")
                
                if Root then
                    for _, item in pairs(ItemsFolder:GetChildren()) do
                        -- Mengecek apakah objek bisa diambil (Model atau Part)
                        if item:IsA("Model") or item:IsA("BasePart") then
                            local targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                            
                            if targetPart and targetPart:IsA("BasePart") then
                                local distance = (Root.Position - targetPart.Position).Magnitude
                                
                                -- Jika masuk dalam radius yang diatur di Slider
                                if distance <= getgenv().MagnetRadius then
                                    -- Memindahkan item tepat ke posisi karakter Anda secara instan
                                    targetPart.CFrame = Root.CFrame
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1) -- Cepat agar item langsung terhisap saat muncul [cite: 45]
    end 
end)
