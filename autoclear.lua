-- [[ ZONHUB - AUTOCLEAR MODULE (GIANT FLOOR & SMART PATHFINDING) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v11.0 - The Masterpiece" 

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
getgenv().StepDelay = 0.1    -- Jeda jalan murni per block
getgenv().MoveDelay = 0.15    
getgenv().MaxHitFailsafe = 20 

getgenv().AC_Blacklist = getgenv().AC_Blacklist or {}
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 

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
-- FUNGSI JALAN ANTI-GLITCH (LOGIKA PABRIK + SMART PATH)
-- ========================================== --
local function WalkToGrid(tX, tY)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    if not MyHitbox then return end

    local startZ = MyHitbox.Position.Z
    local currentX = math.floor(MyHitbox.Position.X / getgenv().GridSize + 0.5)
    local currentY = math.floor(MyHitbox.Position.Y / getgenv().GridSize + 0.5)

    -- Looping jalan murni 1 per 1 (Seperti Pabrik)
    while (currentX ~= tX or currentY ~= tY) do
        if not getgenv().AutoClearEnabled then break end
        
        -- LOGIKA PINTAR: Naik dulu -> Geser X -> Baru Turun. 
        -- Mencegah karakter nembus tanah dan anti balik-balik!
        if currentY < tY then 
            currentY = currentY + 1
        elseif currentX ~= tX then 
            currentX = currentX + (tX > currentX and 1 or -1)
        elseif currentY > tY then 
            currentY = currentY - 1 
        end
        
        local newWorldPos = Vector3.new(currentX * getgenv().GridSize, currentY * getgenv().GridSize, startZ)
        MyHitbox.CFrame = CFrame.new(newWorldPos)
        
        if PlayerMovement then pcall(function() PlayerMovement.Position = newWorldPos end) end
        
        task.wait(getgenv().StepDelay)
    end
end

-- ========================================== --
-- FUNGSI SCAN PINTAR (SKIP KOSONG & PINTU)
-- ========================================== --
local function NeedsBreaking(gridX, gridY)
    if getgenv().AC_Blacklist[gridX .. "," .. gridY] then return false end

    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    local startZ = MyHitbox and MyHitbox.Position.Z or 0
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    
    local filterObjects = {}
    if LP.Character then table.insert(filterObjects, LP.Character) end
    if HitboxFolder then table.insert(filterObjects, HitboxFolder) end
    if workspace.CurrentCamera then table.insert(filterObjects, workspace.CurrentCamera) end
    if workspace:FindFirstChild("DroppedItems") then table.insert(filterObjects, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filterObjects, workspace.Items) end
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = filterObjects
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(2, 2, 50), params)
    
    local isProtectedDoor = false
    local hasBreakableBlock = false
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local partName = string.lower(part.Name)
            -- JANGAN HANCURKAN: Pintu, Entrance, Spawn, Portal, Bedrock, Border
            if string.find(partName, "door") or string.find(partName, "portal") or string.find(partName, "entrance") or string.find(partName, "spawn") or string.find(partName, "bedrock") or string.find(partName, "border") then
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
    while task.wait(0.2) do
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            local arahKanan = true 
            
            local HitboxFolder = workspace:FindFirstChild("Hitbox")
            local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
            local startZ = MyHitbox and MyHitbox.Position.Z or 0

            -- [[ TRIK LANTAI RAKSASA (ANTI-GETAR & ANTI JATUH ABSOLUT) ]] --
            -- Membuat lantai palsu yang transparan agar karakter bisa memijak di udara
            local GiantFloor = Instance.new("Part")
            GiantFloor.Name = "ZONHUB_GiantFloor"
            GiantFloor.Size = Vector3.new(2000, getgenv().GridSize, getgenv().GridSize)
            GiantFloor.Anchored = true
            GiantFloor.CanCollide = true
            GiantFloor.Transparency = 1 -- 100% Tak Terlihat
            -- Memasukkan ke CurrentCamera agar tidak ter-scan oleh radar bot
            GiantFloor.Parent = workspace.CurrentCamera 

            -- [[ PRE-SCAN (SMART RESUME) ]] --
            local highestTargetY = getgenv().AC_StartY
            for scanY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                local foundBlockInRow = false
                for scanX = getgenv().AC_StartX, getgenv().AC_EndX do
                    if NeedsBreaking(scanX, scanY - 1) then
                        foundBlockInRow = true
                        break
                    end
                end
                if foundBlockInRow then
                    highestTargetY = scanY
                    break
                end
            end

            for currentY = highestTargetY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end 
                local blockTargetY = currentY - 1 
                
                -- Memindahkan Lantai Raksasa tepat 1 block di bawah karakter
                -- Karakter akan berpijak pada lantai ini, menipu engine game!
                GiantFloor.Position = Vector3.new(50 * getgenv().GridSize, blockTargetY * getgenv().GridSize, startZ)

                local startX, endX, stepX
                if arahKanan then
                    startX, endX, stepX = getgenv().AC_StartX, getgenv().AC_EndX, 1
                else
                    startX, endX, stepX = getgenv().AC_EndX, getgenv().AC_StartX, -1
                end

                for currentX = startX, endX, stepX do
                    if not getgenv().AutoClearEnabled then break end
                    
                    if not NeedsBreaking(currentX, blockTargetY) then
                        continue 
                    end
                    
                    -- 1. Berjalan aman per block
                    WalkToGrid(currentX, currentY)
                    task.wait(getgenv().MoveDelay) 
                    
                    -- 2. Hancurkan Block 
                    -- Karena ada Lantai Raksasa (GiantFloor) di bawah pijakannya, 
                    -- Karakter tidak akan jatuh atau bergetar sama sekali meskipun block aslinya hancur!
                    local tries = 0
                    while tries < getgenv().MaxHitFailsafe do
                        if not getgenv().AutoClearEnabled then break end
                        if not NeedsBreaking(currentX, blockTargetY) then break end

                        RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                        task.wait(getgenv().BreakDelay)
                        tries = tries + 1
                    end
                    
                    -- 3. Blacklist jika pintu tersembunyi nge-bug
                    if tries >= getgenv().MaxHitFailsafe then
                        getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                    end
                end
                
                arahKanan = not arahKanan 
            end
            
            isRunning = false
            if getgenv().AutoClearEnabled then getgenv().AutoClearEnabled = false end
            
            -- Menghapus lantai raksasa saat selesai atau stop
            if GiantFloor then GiantFloor:Destroy() end
        end
    end
end)
