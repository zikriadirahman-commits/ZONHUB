-- [[ ZONHUB - AUTOCLEAR MODULE (V60 BASED ON YOUR SCRIPT + TUNNEL + STONE FIX) ]] --

local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v60 - Tunnel & Stone Fix" 

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
getgenv().GlideSpeed = 1.5   

-- [!] DIUBAH JADI 80 AGAR STONE (BATU) BISA HANCUR (Sekitar 2.4 detik)
getgenv().MaxHits = 80       

-- [!] VARIABEL MEMORI (AGAR BISA MELANJUTKAN DARI TITIK TERAKHIR)
getgenv().AC_ResumeX = nil
getgenv().AC_ResumeY = nil
getgenv().AC_ArahKanan = nil

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
-- FUNGSI UI UTILITY (DENGAN RESET MEMORI PADA SLIDER)
-- ========================================== --
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local function CreateToggle(Parent, Text, Var) local Btn = Instance.new("TextButton", Parent); Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false; local C = Instance.new("UICorner", Btn); C.CornerRadius = UDim.new(0, 6); local T = Instance.new("TextLabel", Btn); T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; local IndBg = Instance.new("Frame", Btn); IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30); local IC = Instance.new("UICorner", IndBg); IC.CornerRadius = UDim.new(1,0); local Dot = Instance.new("Frame", IndBg); Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); local DC = Instance.new("UICorner", Dot); DC.CornerRadius = UDim.new(1,0); Btn.MouseButton1Click:Connect(function() getgenv()[Var] = not getgenv()[Var]; if getgenv()[Var] then Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple else Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) end end) end
local function CreateSlider(Parent, Text, Min, Max, Default, Var) local Frame = Instance.new("Frame", Parent); Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 45); local C = Instance.new("UICorner", Frame); C.CornerRadius = UDim.new(0, 6); local Label = Instance.new("TextLabel", Frame); Label.Text = Text .. ": " .. Default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; local SliderBg = Instance.new("TextButton", Frame); SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""; SliderBg.AutoButtonColor = false; local SC = Instance.new("UICorner", SliderBg); SC.CornerRadius = UDim.new(1,0); local Fill = Instance.new("Frame", SliderBg); Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0); local FC = Instance.new("UICorner", Fill); FC.CornerRadius = UDim.new(1,0); local Dragging = false; local function Update(input) local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1); local Val = math.floor(Min + ((Max - Min) * SizeX)); Fill.Size = UDim2.new(SizeX, 0, 1, 0); Label.Text = Text .. ": " .. Val; getgenv()[Var] = Val; 
    
    -- [!] JIKA SLIDER DIUBAH, RESET MEMORI AGAR MULAI DARI ANGKA BARU
    getgenv().AC_ResumeX = nil; getgenv().AC_ResumeY = nil; getgenv().AC_ArahKanan = nil; 
end; SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end); UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end) end

CreateToggle(TargetPage, "Start Auto Clear World", "AutoClearEnabled")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- FUNGSI TERBANG FISIK (MURNI BAWAAN KAMU)
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
            part.Anchored = false 
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
-- SENSOR PINTAR BLOK & BEDROCK/DOOR
-- ========================================== --
local function GetFilterObjects()
    local filter = {LP.Character, workspace.CurrentCamera}
    if workspace:FindFirstChild("Hitbox") then table.insert(filter, workspace.Hitbox) end
    if workspace:FindFirstChild("DroppedItems") then table.insert(filter, workspace.DroppedItems) end
    if workspace:FindFirstChild("Items") then table.insert(filter, workspace.Items) end
    return filter
end

-- [!] DIPERBARUI: Mendeteksi Bedrock DAN Main Door
local function IsUnbreakable(gridX, gridY)
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
            local parentName = part.Parent and string.lower(part.Parent.Name) or ""
            
            if string.find(pName, "bedrock") or string.find(parentName, "bedrock") or 
               string.find(pName, "door") or string.find(parentName, "door") or 
               string.find(pName, "main") or string.find(parentName, "main") then
                return true
            end
        end
    end
    return false
end

-- Persis sama seperti yang kamu kasih
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
            return true 
        end
    end
    return false
end

-- ========================================== --
-- SISTEM GLIDE SERVER-SYNC (MURNI BAWAAN KAMU)
-- ========================================== --
local function ServerSyncedGlide(gX, gY)
    local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not Hitbox or not HRP then return end

    local startZ = Hitbox.Position.Z
    local targetPos = Vector3.new(gX * getgenv().GridSize, gY * getgenv().GridSize, startZ)
    local speed = getgenv().GlideSpeed 
    
    while getgenv().AutoClearEnabled do
        local currentPos = Hitbox.Position
        local distance = (targetPos - currentPos).Magnitude
        
        if distance <= speed then
            Hitbox.CFrame = CFrame.new(targetPos)
            Hitbox.Velocity = Vector3.zero
            HRP.CFrame = CFrame.new(targetPos)
            HRP.Velocity = Vector3.zero
            if PlayerMovement then pcall(function() PlayerMovement.Position = targetPos end) end
            break
        else
            local direction = (targetPos - currentPos).Unit
            local nextPos = currentPos + (direction * speed)
            
            Hitbox.CFrame = CFrame.new(nextPos)
            Hitbox.Velocity = Vector3.zero
            HRP.CFrame = CFrame.new(nextPos)
            HRP.Velocity = Vector3.zero
            if PlayerMovement then pcall(function() PlayerMovement.Position = nextPos end) end
        end
        task.wait() 
    end
end

-- ========================================== --
-- LOGIKA UTAMA (ZIG-ZAG)
-- ========================================== --
local isRunning = false

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            
            -- [!] MEMUAT MEMORI (RESUME STATE)
            if getgenv().AC_ResumeY == nil then getgenv().AC_ResumeY = getgenv().AC_StartY end
            if getgenv().AC_ArahKanan == nil then getgenv().AC_ArahKanan = true end
            if getgenv().AC_ResumeX == nil then 
                getgenv().AC_ResumeX = getgenv().AC_ArahKanan and getgenv().AC_StartX or getgenv().AC_EndX
            end

            ToggleCXFly(true)

            local function isRowFinished(x)
                if getgenv().AC_ArahKanan then return x > getgenv().AC_EndX else return x < getgenv().AC_StartX end
            end

            while getgenv().AutoClearEnabled and getgenv().AC_ResumeY >= getgenv().AC_EndY do
                local blockTargetY = getgenv().AC_ResumeY - 1 
                local stepX = getgenv().AC_ArahKanan and 1 or -1

                while getgenv().AutoClearEnabled and not isRowFinished(getgenv().AC_ResumeX) do
                    local currentX = getgenv().AC_ResumeX
                    
                    if IsUnbreakable(currentX, blockTargetY) then
                        getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                    elseif NeedsBreaking(currentX, blockTargetY) then
                        
                        local hoverY = blockTargetY + 1
                        
                        -- ========================================== --
                        -- [!] LOGIKA TEROWONGAN (TURUN 1 BLOK)
                        -- Jika di udara (hoverY) ada Bedrock/Pintu
                        -- ========================================== --
                        if IsUnbreakable(currentX, hoverY) then
                            -- Mundur 1 blok dan sejajar dengan tanah
                            local standX = currentX - stepX
                            
                            -- Meluncur ke posisi mundur
                            ServerSyncedGlide(standX, blockTargetY)
                            
                            local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
                            local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                            local lockZ = Hitbox and Hitbox.Position.Z or 0
                            local tunnelPos = Vector3.new(standX * getgenv().GridSize, blockTargetY * getgenv().GridSize, lockZ)

                            local tunnelFailsafe = 0
                            -- Hancurkan dari depan
                            while NeedsBreaking(currentX, blockTargetY) and getgenv().AutoClearEnabled do
                                if Hitbox then Hitbox.CFrame = CFrame.new(tunnelPos); Hitbox.Velocity = Vector3.zero end
                                if HRP then HRP.CFrame = CFrame.new(tunnelPos); HRP.Velocity = Vector3.zero end
                                if PlayerMovement then pcall(function() PlayerMovement.Position = tunnelPos end) end
                                
                                if IsUnbreakable(currentX, blockTargetY) then
                                    getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                                    break
                                end
                                
                                RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                                
                                tunnelFailsafe = tunnelFailsafe + 1
                                if tunnelFailsafe > getgenv().MaxHits then 
                                    getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                                    break
                                end
                                task.wait(getgenv().BreakDelay)
                            end
                            
                        else
                            -- ========================================== --
                            -- [!] GLIDE NORMAL DI ATAS (Bawaan Script Kamu)
                            -- ========================================== --
                            ServerSyncedGlide(currentX, hoverY)
                            
                            local Hitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
                            local HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                            local lockZ = Hitbox and Hitbox.Position.Z or 0
                            local lockPos = Vector3.new(currentX * getgenv().GridSize, hoverY * getgenv().GridSize, lockZ)

                            local extremeFailsafe = 0
                            while NeedsBreaking(currentX, blockTargetY) and getgenv().AutoClearEnabled do
                                
                                if Hitbox then Hitbox.CFrame = CFrame.new(lockPos); Hitbox.Velocity = Vector3.zero end
                                if HRP then HRP.CFrame = CFrame.new(lockPos); HRP.Velocity = Vector3.zero end
                                if PlayerMovement then pcall(function() PlayerMovement.Position = lockPos end) end
                                
                                if IsUnbreakable(currentX, blockTargetY) then
                                    getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                                    break
                                end
                                
                                RemoteBreak:FireServer(Vector2.new(currentX, blockTargetY))
                                
                                extremeFailsafe = extremeFailsafe + 1
                                if extremeFailsafe > getgenv().MaxHits then 
                                    getgenv().AC_Blacklist[currentX .. "," .. blockTargetY] = true
                                    break
                                end
                                task.wait(getgenv().BreakDelay)
                            end
                        end
                    end

                    -- Hanya berpindah X jika tombol masih menyala
                    if getgenv().AutoClearEnabled then
                        getgenv().AC_ResumeX = getgenv().AC_ResumeX + stepX
                    end
                end

                -- Pindah ke baris (Y) bawahnya jika baris saat ini selesai
                if getgenv().AutoClearEnabled and isRowFinished(getgenv().AC_ResumeX) then
                    getgenv().AC_ResumeY = getgenv().AC_ResumeY - 1
                    getgenv().AC_ArahKanan = not getgenv().AC_ArahKanan
                    getgenv().AC_ResumeX = getgenv().AC_ArahKanan and getgenv().AC_StartX or getgenv().AC_EndX
                end
            end
            
            -- Jika tombol dimatikan, loop terputus, tapi AC_ResumeX & Y tetap tersimpan di memori.
            isRunning = false
            if getgenv().AutoClearEnabled then getgenv().AutoClearEnabled = false end
            ToggleCXFly(false)
        end
    end
end)
