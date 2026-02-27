-- [[ ZONHUB - AUTOCLEAR MODULE (SMART DUAL-SPEED FIX) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v40 - Dual Speed Perfect" 

-- ========================================== --
-- VARIABEL GLOBAL 
-- ========================================== --
getgenv().AutoClearEnabled = false
getgenv().AC_StartX = 0
getgenv().AC_EndX = 100
getgenv().AC_StartY = 37
getgenv().AC_EndY = 6

getgenv().GridSize = 4.5     
getgenv().BreakDelay = 0.03       -- Kecepatan pukul
getgenv().NormalStepDelay = 0.15  -- [LOGIKA 1] Kecepatan jalan santai (Pas awal start & pindah baris)
getgenv().FastStepDelay = 0.04    -- [LOGIKA 2] Kecepatan NGEBUT (Pas geser ke sebelahnya)
getgenv().MaxHitFailsafe = 100 

getgenv().AC_Blacklist = getgenv().AC_Blacklist or {}
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 

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

CreateToggle(TargetPage, "Start Auto Clear World", "AutoClearEnabled")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- FUNGSI TERBANG CX
-- ========================================== --
local function ToggleCXFly(state)
    local Char = LP.Character
    local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)

    if Hum then Hum.PlatformStand = state end

    local parts = {HRP, Hitbox}
    for _, part in ipairs(parts) do
        if part then
            if state then
                part.CanCollide = false
                local bv = part:FindFirstChild("ZON_FlyBV") or Instance.new("BodyVelocity")
                bv.Name = "ZON_FlyBV"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero 
                bv.Parent = part
            else
                part.CanCollide = true
                if part:FindFirstChild("ZON_FlyBV") then part.ZON_FlyBV:Destroy() end
            end
        end
    end
end

-- ========================================== --
-- SENSOR SMART 
-- ========================================== --
local function GetFilterObjects()
    local filter = {LP.Character, workspace.CurrentCamera}
    if workspace:FindFirstChild("Hitbox") then table.insert(filter, workspace.Hitbox) end
    if workspace:FindFirstChild("DroppedItems") then table.insert(filter, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filter, workspace.Items) end
    return filter
end

local function IsSolidObstacle(gridX, gridY)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    local startZ = MyHitbox and MyHitbox.Position.Z or 0
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = GetFilterObjects()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local pName = string.lower(part.Name)
            if string.find(pName, "bedrock") or string.find(pName, "border") or string.find(pName, "portal") or string.find(pName, "spawn") or string.find(pName, "door") then
                return true 
            end
        end
    end
    return false
end

local function NeedsBreaking(gridX, gridY)
    if getgenv().AC_Blacklist[gridX .. "," .. gridY] then return false end
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    local startZ = MyHitbox and MyHitbox.Position.Z or 0
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = GetFilterObjects()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then 
            local pName = string.lower(part.Name)
            if string.find(pName, "bedrock") or string.find(pName, "border") or string.find(pName, "spawn") or string.find(pName, "portal") or string.find(pName, "door") then continue end
            return true 
        end
    end
    return false
end

-- ========================================== --
-- PERGERAKAN PER-GRID PABRIK (DENGAN 2 KECEPATAN)
-- ========================================== --
local function WalkToGrid(tX, tY, isFast)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    if not MyHitbox then return end

    local startZ = MyHitbox.Position.Z
    local currentX = math.floor(MyHitbox.Position.X / getgenv().GridSize + 0.5)
    local currentY = math.floor(MyHitbox.Position.Y / getgenv().GridSize + 0.5)

    local failsafe = 0
    while (currentX ~= tX or currentY ~= tY) do
        if not getgenv().AutoClearEnabled then break end
        
        -- Bergerak 1 grid demi 1 grid persis seperti Pabrik
        if currentX ~= tX then 
            currentX = currentX + (tX > currentX and 1 or -1)
        elseif currentY ~= tY then 
            currentY = currentY + (tY > currentY and 1 or -1) 
        end
        
        local targetWorldPos = Vector3.new(currentX * getgenv().GridSize, currentY * getgenv().GridSize, startZ)
        local startPos = MyHitbox.Position
        
        -- [ PENENTUAN KECEPATAN ]
        local timeToWait = isFast and getgenv().FastStepDelay or getgenv().NormalStepDelay
        local steps = isFast and 5 or 15 -- Cepat pakai 5 frame, Santai pakai 15 frame
        
        for i = 1, steps do
            if not getgenv().AutoClearEnabled then break end
            
            local lerpPos = startPos:Lerp(targetWorldPos, i / steps)
            MyHitbox.CFrame = CFrame.new(lerpPos)
            if PlayerMovement then pcall(function() PlayerMovement.Position = lerpPos end) end
            
            task.wait(timeToWait / steps) 
        end
        
        failsafe = failsafe + 1
        if failsafe > 30 then break end 
    end
end

-- ========================================== --
-- LOGIKA ZIG-ZAG UTAMA
-- ========================================== --
local isRunning = false

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            local arahKanan = true 

            ToggleCXFly(true)

            local highestTargetY = getgenv().AC_StartY
            for scanY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                local foundBlock = false
                for scanX = getgenv().AC_StartX, getgenv().AC_EndX do
                    if NeedsBreaking(scanX, scanY - 1) then
                        foundBlock = true
                        break
                    end
                end
                if foundBlock then highestTargetY = scanY; break end
            end

            for currentY = highestTargetY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end 
                local blockTargetY = currentY - 1 
                
                local startX, endX, stepX = getgenv().AC_StartX, getgenv().AC_EndX, 1
                if not arahKanan then startX, endX, stepX = getgenv().AC_EndX, getgenv().AC_StartX, -1 end

                -- Variabel Penanda Awal Baris
                local isFirstBlock = true 

                for currentX = startX, endX, stepX do
                    if not getgenv().AutoClearEnabled then break end
                    
                    if not NeedsBreaking(currentX, blockTargetY) then continue end
                    
                    local standX = currentX - stepX
                    local standY = blockTargetY

                    -- LOGIKA X=0 & BEDROCK/DOOR
                    if standX < getgenv().AC_StartX or standX > getgenv().AC_EndX then
                        standX = currentX
                        standY = blockTargetY + 1
                    else
                        local maxUp = 0
                        while IsSolidObstacle(standX, standY) and maxUp < 5 do
                            standY = standY + 1
                            maxUp = maxUp + 1
                        end
                    end
                    
                    -- JALANKAN LOGIKA JALAN PINTAR
                    -- Jika ini blok pertama yang dihampiri, jalan SANTAI.
                    -- Setelah memecahkan blok pertama, sisanya akan jalan NGEBUT.
                    WalkToGrid(standX, standY, not isFirstBlock)
                    isFirstBlock = false -- Tandai bahwa blok pertama sudah dilewati
                    
                    local HitboxFolder = workspace:FindFirstChild("Hitbox")
                    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
                    local lockCFrame = MyHitbox and MyHitbox.CFrame or nil

                    local tries = 0
                    while tries < getgenv().MaxHitFailsafe do
                        if not getgenv().AutoClearEnabled then break end
                        
                        if not NeedsBreaking(currentX, blockTargetY) then break end

                        -- Kunci CFrame agar karakter mantap seperti patung saat memukul
                        if MyHitbox and lockCFrame then
                            MyHitbox.CFrame = lockCFrame
                            MyHitbox.Velocity = Vector3.zero
                        end

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
            ToggleCXFly(false)
        end
    end
end)
