-- [[ ZONHUB - AUTOCLEAR MODULE (100% PURE PABRIK LOGIC) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v19 - The Pabrik Engine" 

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
getgenv().StepDelay = 0.1    -- Jeda jalan murni per block (Persis Pabrik)
getgenv().MoveDelay = 0.15    
getgenv().MaxHitFailsafe = 25 

-- Blacklist untuk pintu, bedrock, dan error block
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
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- LANTAI KACA PENYELAMAT (AGAR TIDAK JATUH SAAT JALAN DI UDARA)
-- ========================================== --
local WalkFloor = workspace:FindFirstChild("ZONHUB_WalkFloor")
if not WalkFloor then
    WalkFloor = Instance.new("Part")
    WalkFloor.Name = "ZONHUB_WalkFloor"
    WalkFloor.Size = Vector3.new(getgenv().GridSize, 1, getgenv().GridSize)
    WalkFloor.Anchored = true
    WalkFloor.CanCollide = true
    WalkFloor.Transparency = 1 
    WalkFloor.Parent = workspace
end
WalkFloor.Position = Vector3.new(0, 9999, 0)

-- ========================================== --
-- FUNGSI JALAN (100% COPY PASTE DARI PABRIK)
-- ========================================== --
local function WalkToGrid(tX, tY)
    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    if not MyHitbox then return end

    local startZ = MyHitbox.Position.Z
    local currentX = math.floor(MyHitbox.Position.X / getgenv().GridSize + 0.5)
    local currentY = math.floor(MyHitbox.Position.Y / getgenv().GridSize + 0.5)

    -- Looping jalan murni 1 per 1 tanpa skip (Anti Glitch Balik-balik)
    while (currentX ~= tX or currentY ~= tY) do
        if not getgenv().AutoClearEnabled then break end
        
        if currentX ~= tX then 
            currentX = currentX + (tX > currentX and 1 or -1)
        elseif currentY ~= tY then 
            currentY = currentY + (tY > currentY and 1 or -1) 
        end
        
        -- Memindahkan lantai kaca tepat 1 block di bawah karakter agar ia bisa menapak di udara
        WalkFloor.Position = Vector3.new(currentX * getgenv().GridSize, (currentY - 1) * getgenv().GridSize, startZ)
        
        local newWorldPos = Vector3.new(currentX * getgenv().GridSize, currentY * getgenv().GridSize, startZ)
        MyHitbox.CFrame = CFrame.new(newWorldPos)
        
        if PlayerMovement then pcall(function() PlayerMovement.Position = newWorldPos end) end
        
        task.wait(getgenv().StepDelay)
    end
end

-- ========================================== --
-- FUNGSI SCAN PINTAR (LEWATI PINTU & BEDROCK)
-- ========================================== --
local function NeedsBreaking(gridX, gridY)
    -- Lewati jika sudah di-blacklist
    if getgenv().AC_Blacklist[gridX .. "," .. gridY] then return false end

    local HitboxFolder = workspace:FindFirstChild("Hitbox")
    local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
    local startZ = MyHitbox and MyHitbox.Position.Z or 0
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, startZ)
    
    local filterObjects = {LP.Character, HitboxFolder, workspace.CurrentCamera, WalkFloor}
    if workspace:FindFirstChild("DroppedItems") then table.insert(filterObjects, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filterObjects, workspace.Items) end
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = filterObjects
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos), Vector3.new(2, 2, 50), params)
    
    local isProtected = false
    local hasTarget = false
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") then
            local pName = string.lower(part.Name)
            -- Benda yang DILARANG dihancurkan
            if string.find(pName, "door") or string.find(pName, "portal") or string.find(pName, "entrance") or string.find(pName, "spawn") or string.find(pName, "bedrock") or string.find(pName, "border") then
                isProtected = true
            else
                hasTarget = true
            end
        end
    end
    
    if isProtected then return false end
    return hasTarget
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

            -- [[ PRE-SCAN (SMART RESUME TERBAIK) ]] --
            local highestTargetY = getgenv().AC_StartY
            for scanY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                local foundBlock = false
                for scanX = getgenv().AC_StartX, getgenv().AC_EndX do
                    if NeedsBreaking(scanX, scanY - 1) then
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
                    
                    -- JALAN FISIK KE SETIAP BLOCK (Wajib agar tidak nge-glitch ditarik game)
                    WalkToGrid(currentX, currentY)
                    
                    -- Jika block di bawahnya adalah Pintu / Bedrock / Kosong, abaikan memukul
                    if not NeedsBreaking(currentX, blockTargetY) then
                        continue 
                    end
                    
                    task.wait(getgenv().MoveDelay) 
                    
                    -- ==================================================== --
                    -- LOGIKA MELAYANG MURNI DARI PABRIK (ANTI GETAR 100%)
                    -- ==================================================== --
                    local tries = 0
                    local startZ = MyHitbox and MyHitbox.Position.Z or 0
                    
                    -- Sembunyikan lantai kaca saat memukul agar tidak menghalangi pukulan
                    WalkFloor.Position = Vector3.new(0, 9999, 0)
                    
                    -- Matikan fisik tubuh agar tidak memantul-mantul (Trik Pabrik)
                    if MyHitbox then MyHitbox.CanCollide = false end
                    
                    while tries < getgenv().MaxHitFailsafe do
                        if not getgenv().AutoClearEnabled then break end
                        if not NeedsBreaking(currentX, blockTargetY) then break end
                        
                        -- Tahan Posisi CFrame berulang kali di dalam loop (Trik Pabrik)
                        if MyHitbox then 
                            local lockPos = Vector3.new(currentX * getgenv().GridSize, currentY * getgenv().GridSize, startZ)
                            MyHitbox.CFrame = CFrame.new(lockPos)
                            if PlayerMovement then pcall(function() PlayerMovement.Position = lockPos end) end
                        end 

                        RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                        task.wait(getgenv().BreakDelay)
                        tries = tries + 1
                    end
                    
                    -- Kembalikan fisik tubuh normal setelah block hancur
                    if MyHitbox then MyHitbox.CanCollide = true end
                    
                    -- Blacklist jika nyangkut
                    if tries >= getgenv().MaxHitFailsafe then
                        getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                    end
                end
                
                arahKanan = not arahKanan 
            end
            
            isRunning = false
            if getgenv().AutoClearEnabled then getgenv().AutoClearEnabled = false end
            if WalkFloor then WalkFloor.Position = Vector3.new(0, 9999, 0) end
            if MyHitbox then MyHitbox.CanCollide = true end
        end
    end
end)
