-- [[ ZONHUB - AUTOCLEAR MODULE (PURE PABRIK MOVEMENT) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v5.0 - Pabrik Walk" 

-- ========================================== --
-- VARIABEL GLOBAL 
-- ========================================== --
getgenv().AutoClearEnabled = false
getgenv().AC_StartX = 0
getgenv().AC_EndX = 100
getgenv().AC_StartY = 37
getgenv().AC_EndY = 6

getgenv().GridSize = 4.5     
getgenv().BreakDelay = 0.05  
getgenv().StepDelay = 0.1    -- Kecepatan jalan (Sama persis dengan settingan Pabrik)
getgenv().MoveDelay = 0.15    
getgenv().MaxHitFailsafe = 25 
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 
local RunService = game:GetService("RunService")

-- Anti AFK
LP.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

-- Memuat Modul Pergerakan Khusus Game
local PlayerMovement
pcall(function() PlayerMovement = require(LP.PlayerScripts:WaitForChild("PlayerMovement")) end)

local Remotes = RS:WaitForChild("Remotes")
local RemoteBreak = Remotes:WaitForChild("PlayerFist")

-- ========================================== --
-- FUNGSI UI UTILITY
-- ========================================== --
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local function CreateToggle(Parent, Text, Var) local Btn = Instance.new("TextButton", Parent); Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false; local C = Instance.new("UICorner", Btn); C.CornerRadius = UDim.new(0, 6); local T = Instance.new("TextLabel", Btn); T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; local IndBg = Instance.new("Frame", Btn); IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30); local IC = Instance.new("UICorner", IndBg); IC.CornerRadius = UDim.new(1,0); local Dot = Instance.new("Frame", IndBg); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); local DC = Instance.new("UICorner", Dot); DC.CornerRadius = UDim.new(1,0); Btn.MouseButton1Click:Connect(function() getgenv()[Var] = not getgenv()[Var]; if getgenv()[Var] then Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple else Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) end end) end
local function CreateSlider(Parent, Text, Min, Max, Default, Var) local Frame = Instance.new("Frame", Parent); Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 45); local C = Instance.new("UICorner", Frame); C.CornerRadius = UDim.new(0, 6); local Label = Instance.new("TextLabel", Frame); Label.Text = Text .. ": " .. Default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; local SliderBg = Instance.new("TextButton", Frame); SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""; SliderBg.AutoButtonColor = false; local SC = Instance.new("UICorner", SliderBg); SC.CornerRadius = UDim.new(1,0); local Fill = Instance.new("Frame", SliderBg); Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0); local FC = Instance.new("UICorner", Fill); FC.CornerRadius = UDim.new(1,0); local Dragging = false; local function Update(input) local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1); local Val = math.floor(Min + ((Max - Min) * SizeX)); Fill.Size = UDim2.new(SizeX, 0, 1, 0); Label.Text = Text .. ": " .. Val; getgenv()[Var] = Val end; SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end); UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end) end

-- ========================================== --
-- MEMBANGUN MENU UI 
-- ========================================== --
CreateToggle(TargetPage, "Start Auto Clear World", "AutoClearEnabled")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- FUNGSI PERGERAKAN (MURNI LOGIKA PABRIK)
-- ========================================== --
local function WalkToGrid(tX, tY)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    if not MyHitbox then return end

    local startZ = MyHitbox.Position.Z
    local currentX = math.floor(MyHitbox.Position.X / getgenv().GridSize + 0.5)
    local currentY = math.floor(MyHitbox.Position.Y / getgenv().GridSize + 0.5)

    -- Looping jalan murni, 100% copas dari script Pabrik
    while (currentX ~= tX or currentY ~= tY) do
        if not getgenv().AutoClearEnabled then break end
        
        if currentX ~= tX then 
            currentX = currentX + (tX > currentX and 1 or -1)
        elseif currentY ~= tY then 
            currentY = currentY + (tY > currentY and 1 or -1) 
        end
        
        local newWorldPos = Vector3.new(currentX * getgenv().GridSize, currentY * getgenv().GridSize, startZ)
        MyHitbox.CFrame = CFrame.new(newWorldPos)
        
        if PlayerMovement then pcall(function() PlayerMovement.Position = newWorldPos end) end
        
        task.wait(getgenv().StepDelay)
    end
end

-- ========================================== --
-- FUNGSI SCAN SMART DETECT (DENGAN SKIP PINTU)
-- ========================================== --
local function IsBlockOrBackgroundThere(gridX, gridY)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    if not MyHitbox then return false end
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, MyHitbox.Position.Z)
    
    local params = OverlapParams.new()
    local filterObjects = {LP.Character, HitboxFolder, workspace.CurrentCamera}
    if workspace:FindFirstChild("DroppedItems") then table.insert(filterObjects, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filterObjects, workspace.Items) end
    
    params.FilterDescendantsInstances = filterObjects
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    
    local isProtectedDoor = false
    local hasBreakableBlock = false
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local partName = string.lower(part.Name)
            -- Melindungi pintu, portal, entrance, dan spawn agar tidak dihancurkan
            if string.find(partName, "door") or string.find(partName, "portal") or string.find(partName, "entrance") or string.find(partName, "spawn") then
                isProtectedDoor = true
            else
                hasBreakableBlock = true
            end
        end
    end
    
    if isProtectedDoor then return false end
    
    return hasBreakableBlock
end

-- ========================================== --
-- LOGIKA ZIG-ZAG UTAMA (THREAD)
-- ========================================== --
local isRunning = false

task.spawn(function()
    local hoverConnection = nil

    while task.wait(0.2) do
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            local arahKanan = true 
            
            local HitboxFolder = workspace:FindFirstChild("Hitbox")
            local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)

            for currentY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end 
                local blockTargetY = currentY - 1 
                
                -- Menentukan arah pergerakan baris X
                local startX, endX, stepX
                if arahKanan then
                    startX, endX, stepX = getgenv().AC_StartX, getgenv().AC_EndX, 1
                else
                    startX, endX, stepX = getgenv().AC_EndX, getgenv().AC_StartX, -1
                end

                for currentX = startX, endX, stepX do
                    if not getgenv().AutoClearEnabled then break end
                    
                    -- Sistem Auto-Resume Instan (Abaikan ruang kosong)
                    if not IsBlockOrBackgroundThere(currentX, blockTargetY) then
                        continue 
                    end
                    
                    -- 1. Berjalan ke atas block target (Gunakan jalan murni)
                    WalkToGrid(currentX, currentY)
                    task.wait(getgenv().MoveDelay) 
                    
                    -- 2. Sistem Anti-Getar & Anti-Jatuh (Heartbeat)
                    if MyHitbox then
                        local hoverPos = Vector3.new(currentX * getgenv().GridSize, currentY * getgenv().GridSize, MyHitbox.Position.Z)
                        
                        -- Pastikan tiada connection lama yang masih berjalan
                        if hoverConnection then hoverConnection:Disconnect() end
                        
                        hoverConnection = RunService.Heartbeat:Connect(function()
                            if MyHitbox then
                                MyHitbox.CFrame = CFrame.new(hoverPos)
                                MyHitbox.Velocity = Vector3.zero
                                MyHitbox.RotVelocity = Vector3.zero
                                if PlayerMovement then pcall(function() PlayerMovement.Position = hoverPos end) end
                            end
                        end)
                    end
                    
                    -- 3. Hajar Block / Background sampai habis (Sambil melayang)
                    local tries = 0
                    while tries < getgenv().MaxHitFailsafe do
                        if not getgenv().AutoClearEnabled then break end
                        
                        if not IsBlockOrBackgroundThere(currentX, blockTargetY) then break end

                        RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                        task.wait(getgenv().BreakDelay)
                        tries = tries + 1
                    end
                    
                    -- 4. Putus status melayang (hover) agar karakter boleh menyambung jalan grid seterusnya
                    if hoverConnection then
                        hoverConnection:Disconnect()
                        hoverConnection = nil
                    end
                end
                
                arahKanan = not arahKanan 
            end
            
            -- Matikan script jika sudah selesai
            isRunning = false
            if getgenv().AutoClearEnabled then getgenv().AutoClearEnabled = false end
            
            if hoverConnection then
                hoverConnection:Disconnect()
                hoverConnection = nil
            end
        end
    end
end)
