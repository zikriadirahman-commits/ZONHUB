-- [[ ZONHUB - AUTOCLEAR MODULE (CX.FARM GLIDE CLONE & EXACT FREEZE) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v20 - Glide Edition" 

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
getgenv().GlideSpeed = 25    -- Kecepatan meluncur (mirip cx.farm)
getgenv().MaxHitFailsafe = 20 

getgenv().AC_Blacklist = getgenv().AC_Blacklist or {}
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 
local TweenService = game:GetService("TweenService")

-- Anti AFK
LP.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

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
CreateSlider(TargetPage, "Glide Speed", 10, 100, 25, "GlideSpeed")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- FUNGSI MEMATUNG TOTAL (ANCHOR)
-- ========================================== --
local function FreezeCharacter(state)
    local Char = LP.Character
    local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)

    if Hitbox then 
        Hitbox.Anchored = state 
        Hitbox.CanCollide = not state -- Matikan tabrakan fisik agar tidak nabrak saat meluncur
    end
    if HRP then 
        HRP.Anchored = state 
        HRP.CanCollide = not state
    end
end

-- ========================================== --
-- FUNGSI MELUNCUR (GLIDE) DENGAN TWEENSERVICE
-- ========================================== --
local function GlideTo(tX, tY, targetZ)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not MyHitbox then return end

    local targetPos = Vector3.new(tX * getgenv().GridSize, tY * getgenv().GridSize, targetZ)
    local distance = (MyHitbox.Position - targetPos).Magnitude
    
    if distance < 0.1 then return end -- Sudah di posisi

    -- Menghitung waktu luncur (Jarak dibagi Kecepatan)
    local timeToTake = distance / getgenv().GlideSpeed
    if timeToTake < 0.05 then timeToTake = 0.05 end 

    local tweenInfo = TweenInfo.new(timeToTake, Enum.EasingStyle.Linear)
    
    -- Meluncurkan Hitbox & Tubuh secara bersamaan
    local tweenHitbox = TweenService:Create(MyHitbox, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tweenHitbox:Play()
    
    if HRP then 
        TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(targetPos)}):Play() 
    end
    if PlayerMovement then pcall(function() PlayerMovement.Position = targetPos end) end
    
    tweenHitbox.Completed:Wait()
end

-- ========================================== --
-- FUNGSI SCAN PINTAR
-- ========================================== --
local function CheckGridState(gridX, gridY)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    local startZ = MyHitbox and MyHitbox.Position.Z or 0
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    
    local filterObjects = {LP.Character, HitboxFolder, workspace.CurrentCamera}
    if workspace:FindFirstChild("DroppedItems") then table.insert(filterObjects, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filterObjects, workspace.Items) end
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = filterObjects
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(2, 2, 50), params)
    
    local state = { hasTarget = false, isObstacle = false }
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local pName = string.lower(part.Name)
            if string.find(pName, "door") or string.find(pName, "portal") or string.find(pName, "entrance") or string.find(pName, "spawn") or string.find(pName, "bedrock") or string.find(pName, "border") then
                state.isObstacle = true
            else
                state.hasTarget = true
            end
        end
    end
    
    return state
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

            -- MENGUNCI KARAKTER SEJAK AWAL AGAR MELAYANG
            FreezeCharacter(true)

            -- [[ PRE-SCAN (SMART RESUME) ]] --
            local highestTargetY = getgenv().AC_StartY
            for scanY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                local foundBlock = false
                for scanX = getgenv().AC_StartX, getgenv().AC_EndX do
                    local st = CheckGridState(scanX, scanY - 1)
                    if st.hasTarget and not st.isObstacle and not getgenv().AC_Blacklist[scanX .. "," .. (scanY-1)] then
                        foundBlock = true
                        break
                    end
                end
                if foundBlock then
                    highestTargetY = scanY
                    break
                end
            end

            for currentY = highestTargetY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end 
                local blockTargetY = currentY - 1 
                
                local startX, endX, stepX = getgenv().AC_StartX, getgenv().AC_EndX, 1
                if not arahKanan then startX, endX, stepX = getgenv().AC_EndX, getgenv().AC_StartX, -1 end

                for currentX = startX, endX, stepX do
                    if not getgenv().AutoClearEnabled then break end
                    
                    if getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] then continue end
                    
                    local gridState = CheckGridState(currentX, blockTargetY)
                    
                    -- JIKA ADA PINTU/BEDROCK DI DEPAN: Meluncur ke atas (Y+1) untuk menghindari tabrakan
                    if gridState.isObstacle then
                        -- Terbang meluncur melewati atas pintu
                        GlideTo(currentX, currentY + 1, startZ)
                        continue
                    end
                    
                    -- SKIP KOSONG
                    if not gridState.hasTarget then continue end
                    
                    -- 1. MELUNCUR HALUS KE ATAS TARGET
                    GlideTo(currentX, currentY, startZ)
                    
                    -- 2. HANCURKAN BLOCK (Posisi sudah di-anchor/kunci mati, tidak akan turun!)
                    local tries = 0
                    while tries < getgenv().MaxHitFailsafe do
                        if not getgenv().AutoClearEnabled then break end
                        
                        -- Cek Real-time
                        local check = CheckGridState(currentX, blockTargetY)
                        if not check.hasTarget or check.isObstacle then break end

                        RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                        task.wait(getgenv().BreakDelay)
                        tries = tries + 1
                    end
                    
                    if tries >= getgenv().MaxHitFailsafe then
                        getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                    end
                end
                
                arahKanan = not arahKanan 
            end
            
            isRunning = false
            if getgenv().AutoClearEnabled then getgenv().AutoClearEnabled = false end
            
            -- KEMBALIKAN FISIK NORMAL SAAT SELESAI
            FreezeCharacter(false)
        end
    end
end)
