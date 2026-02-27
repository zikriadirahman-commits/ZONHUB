-- [[ ZONHUB - AUTOCLEAR MODULE (V44 PERFECT GLIDE & STRICT BREAK) ]] --

getgenv().ScriptVersion = "AutoClear v44 - Pure Glide & Instant Bedrock Skip" 

-- ========================================== --
-- MEMBUAT MENU UI SENDIRI (STANDALONE)
-- ========================================== --
local CoreGui = game:GetService("CoreGui")
local oldGui = CoreGui:FindFirstChild("ZonHub_AutoClear_UI")
if oldGui then oldGui:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "ZonHub_AutoClear_UI"
sg.Parent = CoreGui

local TargetPage = Instance.new("Frame")
TargetPage.Name = "MainFrame"
TargetPage.Parent = sg
TargetPage.Size = UDim2.new(0, 250, 0, 310)
TargetPage.Position = UDim2.new(0, 20, 0.4, 0)
TargetPage.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TargetPage.Active = true
TargetPage.Draggable = true 

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = TargetPage

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TargetPage
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = TargetPage
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = TargetPage
Title.Size = UDim2.new(1, 0, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "ZonHub AutoClear v44 Glide"
Title.TextColor3 = Color3.fromRGB(140, 80, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- ========================================== --
-- VARIABEL GLOBAL
-- ========================================== --
getgenv().AutoClearEnabled = false
getgenv().AC_StartX = 0
getgenv().AC_EndX = 100
getgenv().AC_StartY = 37
getgenv().AC_EndY = 6

getgenv().GridSize = 4.5     
getgenv().BreakDelay = 0.03  
getgenv().StepDelay = 0.05 -- Dipercepat karena Glide instan     

getgenv().AC_Blacklist = getgenv().AC_Blacklist or {}

-- ========================================== --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 

LP.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

local PlayerMovement
pcall(function() PlayerMovement = require(LP.PlayerScripts:WaitForChild("PlayerMovement")) end)

local Remotes = RS:WaitForChild("Remotes")
local RemoteBreak = Remotes:WaitForChild("PlayerFist")

-- ========================================== --
-- FUNGSI UI UTILITY
-- ========================================== --
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local function CreateToggle(Parent, Text, Var) local Btn = Instance.new("TextButton", Parent); Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, 0, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false; local C = Instance.new("UICorner", Btn); C.CornerRadius = UDim.new(0, 6); local T = Instance.new("TextLabel", Btn); T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; local IndBg = Instance.new("Frame", Btn); IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30); local IC = Instance.new("UICorner", IndBg); IC.CornerRadius = UDim.new(1,0); local Dot = Instance.new("Frame", IndBg); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); local DC = Instance.new("UICorner", Dot); DC.CornerRadius = UDim.new(1,0); Btn.MouseButton1Click:Connect(function() getgenv()[Var] = not getgenv()[Var]; if getgenv()[Var] then Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple else Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) end end) end
local function CreateSlider(Parent, Text, Min, Max, Default, Var) local Frame = Instance.new("Frame", Parent); Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, 0, 0, 45); local C = Instance.new("UICorner", Frame); C.CornerRadius = UDim.new(0, 6); local Label = Instance.new("TextLabel", Frame); Label.Text = Text .. ": " .. Default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; local SliderBg = Instance.new("TextButton", Frame); SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""; SliderBg.AutoButtonColor = false; local SC = Instance.new("UICorner", SliderBg); SC.CornerRadius = UDim.new(1,0); local Fill = Instance.new("Frame", SliderBg); Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0); local FC = Instance.new("UICorner", Fill); FC.CornerRadius = UDim.new(1,0); local Dragging = false; local function Update(input) local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1); local Val = math.floor(Min + ((Max - Min) * SizeX)); Fill.Size = UDim2.new(SizeX, 0, 1, 0); Label.Text = Text .. ": " .. Val; getgenv()[Var] = Val end; SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end); UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end) end

CreateToggle(TargetPage, "Start Auto Clear World", "AutoClearEnabled")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- SENSOR BLOK & BEDROCK
-- ========================================== --
local function GetFilterObjects()
    local filter = {LP.Character, workspace.CurrentCamera}
    if workspace:FindFirstChild("Hitbox") then table.insert(filter, workspace.Hitbox) end
    if workspace:FindFirstChild("DroppedItems") then table.insert(filter, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filter, workspace.Items) end
    return filter
end

local function IsBedrock(gridX, gridY)
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local startZ = Hitbox and Hitbox.Position.Z or 0
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = GetFilterObjects()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and string.match(string.lower(part.Name), "bedrock") then
            return true
        end
    end
    return false
end

local function NeedsBreaking(gridX, gridY)
    if getgenv().AC_Blacklist[gridX .. "," .. gridY] then return false end
    
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local startZ = Hitbox and Hitbox.Position.Z or 0
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = GetFilterObjects()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then 
            local pName = string.lower(part.Name)
            if string.find(pName, "door") or string.find(pName, "portal") or string.find(pName, "border") or string.find(pName, "spawn") then
                continue
            end
            -- Selama sensor menyentuh Dirt atau Background, akan return true
            return true 
        end
    end
    return false
end

-- ========================================== --
-- FUNGSI KUNCI POSISI (GLIDE MURNI)
-- ========================================== --
local function SetGlideMode(active)
    local Char = LP.Character
    local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
    if HRP then HRP.Anchored = active end
    
    for _, part in pairs(Char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not active
        end
    end
end

local function GlideTo(gX, gY)
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Hitbox or not HRP then return end

    local startZ = Hitbox.Position.Z
    local newCFrame = CFrame.new(gX * getgenv().GridSize, gY * getgenv().GridSize, startZ)
    
    Hitbox.CFrame = newCFrame
    Hitbox.Velocity = Vector3.zero 
    
    HRP.CFrame = newCFrame
    HRP.Velocity = Vector3.zero 
    
    if PlayerMovement then pcall(function() PlayerMovement.Position = newCFrame.Position end) end
end

-- ========================================== --
-- LOGIKA UTAMA (ZIG-ZAG)
-- ========================================== --
local isRunning = false

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            local arahKanan = true 

            -- Aktifkan mode Glide (Karakter melayang, tidak nyangkut)
            SetGlideMode(true)

            for currentY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end 
                local blockTargetY = currentY - 1 
                
                local startX, endX, stepX = getgenv().AC_StartX, getgenv().AC_EndX, 1
                if not arahKanan then startX, endX, stepX = getgenv().AC_EndX, getgenv().AC_StartX, -1 end

                for currentX = startX, endX, stepX do
                    if not getgenv().AutoClearEnabled then break end
                    
                    -- Kalau kosong, otomatis skip
                    if not NeedsBreaking(currentX, blockTargetY) then continue end
                    
                    -- DETEKSI BEDROCK AWAL: Langsung skip tanpa disentuh
                    if IsBedrock(currentX, blockTargetY) then
                        getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                        continue 
                    end

                    -- Posisi Hover: Melayang 1 grid di atas blok target
                    local hoverY = blockTargetY + 1
                    GlideTo(currentX, hoverY)
                    task.wait(getgenv().StepDelay) 
                    
                    -- ========================================== --
                    -- STRICT BREAK LOOP (TIDAK AKAN GESER SEBELUM HANCUR TOTAL)
                    -- ========================================== --
                    repeat
                        if not getgenv().AutoClearEnabled then break end
                        
                        -- Pastikan CFrame tetap terkunci di atas target
                        GlideTo(currentX, hoverY)
                        
                        -- Pukul
                        RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                        task.wait(getgenv().BreakDelay)
                        
                        -- Cek darurat kalau di balik dirt ternyata bedrock
                        if IsBedrock(currentX, blockTargetY) then
                            getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                            break
                        end

                    until not NeedsBreaking(currentX, blockTargetY) 
                    -- LOOP BERHENTI KETIKA DIRT & BACKGROUND SUDAH BENAR-BENAR HILANG
                end
                
                arahKanan = not arahKanan 
            end
            
            isRunning = false
            if getgenv().AutoClearEnabled then getgenv().AutoClearEnabled = false end
            
            -- Kembalikan karakter ke mode normal
            SetGlideMode(false)
        end
    end
end)
