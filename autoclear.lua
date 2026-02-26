-- [[ ZONHUB - AUTOCLEAR MODULE (CX GLIDE CLONE & PERFECT BODYPOSITION) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v25 - The CX Edition" 

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
getgenv().GlideSpeed = 15    -- Kecepatan meluncur 
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
CreateSlider(TargetPage, "Glide Speed", 5, 50, 15, "GlideSpeed")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- FUNGSI TERBANG MAGNET (BODYPOSITION)
-- ========================================== --
-- Ini yang dipakai cx script untuk menahan tubuh di udara agar 100% tidak jatuh/getar
local function ToggleFlightMode(state)
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

    for _, part in pairs({Hitbox, HRP}) do
        if part then
            if state then
                part.CanCollide = false -- Mencegah tabrakan fisik agar tidak nge-glitch
                
                local bp = part:FindFirstChild("ZON_BP") or Instance.new("BodyPosition")
                bp.Name = "ZON_BP"
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.P = 15000 -- Kekuatan menahan posisi (Magnet absolut)
                bp.D = 1000  -- Peredam getaran
                bp.Position = part.Position
                bp.Parent = part
                
                local bg = part:FindFirstChild("ZON_BG") or Instance.new("BodyGyro")
                bg.Name = "ZON_BG"
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.CFrame = part.CFrame
                bg.Parent = part
            else
                part.CanCollide = true
                if part:FindFirstChild("ZON_BP") then part.ZON_BP:Destroy() end
                if part:FindFirstChild("ZON_BG") then part.ZON_BG:Destroy() end
            end
        end
    end
end

-- ========================================== --
-- FUNGSI MELUNCUR (GLIDE) KE KOORDINAT
-- ========================================== --
local function GlideTo(tX, tY, targetZ)
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Hitbox then return end

    local targetPos = Vector3.new(tX * getgenv().GridSize, tY * getgenv().GridSize, targetZ)
    
    -- Memindahkan magnet BodyPosition ke target
    if Hitbox and Hitbox:FindFirstChild("ZON_BP") then Hitbox.ZON_BP.Position = targetPos end
    if HRP and HRP:FindFirstChild("ZON_BP") then HRP.ZON_BP.Position = targetPos end
    
    if PlayerMovement then pcall(function() PlayerMovement.Position = targetPos end) end

    -- Tunggu sampai karakter benar-benar sampai (Smooth Glide)
    local timeout = 0
    while (Hitbox.Position - targetPos).Magnitude > 0.5 and timeout < 20 do
        if not getgenv().AutoClearEnabled then break end
        task.wait(1 / getgenv().GlideSpeed)
        timeout = timeout + 1
    end
end

-- ========================================== --
-- FUNGSI SCAN PINTAR
-- ========================================== --
local function IsObstacle(gridX, gridY, startZ)
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    local filterObjects = {LP.Character, workspace:FindFirstChild("Hitbox"), workspace.CurrentCamera}
    if workspace:FindFirstChild("DroppedItems") then table.insert(filterObjects, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filterObjects, workspace.Items) end
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = filterObjects
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local pName = string.lower(part.Name)
            if string.find(pName, "door") or string.find(pName, "portal") or string.find(pName, "entrance") or string.find(pName, "spawn") or string.find(pName, "bedrock") or string.find(pName, "border") then
                return true
            end
        end
    end
    return false
end

local function NeedsBreaking(gridX, gridY, startZ)
    if getgenv().AC_Blacklist[gridX .. "," .. gridY] then return false end
    if IsObstacle(gridX, gridY, startZ) then return false end

    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    local filterObjects = {LP.Character, workspace:FindFirstChild("Hitbox"), workspace.CurrentCamera}
    if workspace:FindFirstChild("DroppedItems") then table.insert(filterObjects, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filterObjects, workspace.Items) end
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = filterObjects
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(3, 3, 50), params)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then return true end
    end
    return false
end

-- ========================================== --
-- FUNGSI JALAN AMAN (MELOMPATI PINTU)
-- ========================================== --
local function SafePathfind(currentX, currentY, tX, tY, startZ)
    -- Jika di jalur menyamping ada rintangan, bot akan terbang 1 blok ke atas (Y+1) 
    -- untuk melompati rintangan tersebut dari udara.
    local step = tX > currentX and 1 or -1
    local nextX = currentX + step
    
    if currentX ~= tX and IsObstacle(nextX, currentY, startZ) then
        GlideTo(currentX, currentY + 1, startZ) -- Terbang naik
        GlideTo(tX, currentY + 1, startZ)       -- Meluncur lewat atas pintu
        GlideTo(tX, tY, startZ)                 -- Turun ke target
    else
        GlideTo(tX, tY, startZ)
    end
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
            
            local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
            local startZ = Hitbox and Hitbox.Position.Z or 0

            -- AKTIFKAN MODE TERBANG MAGNET (Mencegah jatuh dan getar 100%)
            ToggleFlightMode(true)

            -- [[ PRE-SCAN (AUTO RESUME TERTINGGI) ]] --
            local highestTargetY = getgenv().AC_StartY
            for scanY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                local foundBlock = false
                for scanX = getgenv().AC_StartX, getgenv().AC_EndX do
                    if NeedsBreaking(scanX, scanY - 1, startZ) then
                        foundBlock = true
                        break
                    end
                end
                if foundBlock then
                    highestTargetY = scanY
                    break
                end
            end

            -- Update posisi awal pencarian
            local currentX = math.floor(Hitbox.Position.X / getgenv().GridSize + 0.5)

            for currentY = highestTargetY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end 
                local blockTargetY = currentY - 1 
                
                local startX, endX, stepX = getgenv().AC_StartX, getgenv().AC_EndX, 1
                if not arahKanan then startX, endX, stepX = getgenv().AC_EndX, getgenv().AC_StartX, -1 end

                for tX = startX, endX, stepX do
                    if not getgenv().AutoClearEnabled then break end
                    
                    -- JIKA KOSONG / PINTU, SKIP & JANGAN DIHANCURKAN
                    if not NeedsBreaking(tX, blockTargetY, startZ) then continue end
                    -- JIKA POSISI BERDIRI KITA TERNYATA PINTU, JANGAN BERDIRI DI SITU
                    if IsObstacle(tX, currentY, startZ) then continue end
                    
                    -- 1. MELUNCUR DENGAN AMAN KE TARGET (Bisa melompati pintu secara mulus)
                    SafePathfind(currentX, currentY, tX, currentY, startZ)
                    currentX = tX -- Update posisi karakter saat ini
                    task.wait(getgenv().MoveDelay) 
                    
                    -- 2. HANCURKAN BLOCK (Karakter sudah ditahan Magnet BodyPosition di atas)
                    local tries = 0
                    while tries < getgenv().MaxHitFailsafe do
                        if not getgenv().AutoClearEnabled then break end
                        if not NeedsBreaking(currentX, blockTargetY, startZ) then break end

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
            
            -- MATIKAN TERBANG saat selesai / tombol dimatikan
            ToggleFlightMode(false)
        end
    end
end)
