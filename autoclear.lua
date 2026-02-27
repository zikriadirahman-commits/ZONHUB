-- [[ ZONHUB - AUTOCLEAR MODULE V35 (INSTA-NEXT OPTIMIZED) ]] --
local TargetPage = ... 
if not TargetPage then warn("Module harus di-load dari ZonIndex!") return end

getgenv().ScriptVersion = "AutoClear v35 - Fast Transition" 

-- ========================================== --
-- VARIABEL GLOBAL (Dioptimalkan untuk Kecepatan)
-- ========================================== --
getgenv().AutoClearEnabled = false
getgenv().AC_StartX = 0
getgenv().AC_EndX = 100
getgenv().AC_StartY = 37
getgenv().AC_EndY = 6

getgenv().GridSize = 4.5     
getgenv().BreakDelay = 0.01   -- Kecepatan Pukul (Frame based)
getgenv().StepDelay = 0       -- Di-set ke 0 untuk Insta-Teleport per block
getgenv().MaxHitFailsafe = 30 -- Dikurangi agar tidak stuck di blok keras

getgenv().AC_Blacklist = getgenv().AC_Blacklist or {}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")
local RemoteBreak = Remotes:WaitForChild("PlayerFist")

-- ========================================== --
-- FUNGSI DETEKSI & MOVEMENT (INSTANT)
-- ========================================== --

local function GetHitbox()
    return workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
end

local function NeedsBreaking(gridX, gridY)
    if getgenv().AC_Blacklist[gridX .. "," .. gridY] then return false end
    
    local checkPos = Vector3.new(gridX * getgenv().GridSize, gridY * getgenv().GridSize, 0)
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = {LP.Character, workspace.CurrentCamera, workspace:FindFirstChild("DroppedItems")}
    params.FilterType = Enum.RaycastFilterType.Exclude

    local parts = workspace:GetPartBoundsInBox(CFrame.new(checkPos.X, checkPos.Y, 0), Vector3.new(3, 3, 10), params)
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and part.CanCollide then
            -- Abaikan Bedrock atau Border
            local pName = part.Name:lower()
            if not (pName:find("bedrock") or pName:find("border") or pName:find("spawn")) then
                return true
            end
        end
    end
    return false
end

-- Teleport Instant ke posisi grid
local function FastMove(tX, tY)
    local Hitbox = GetHitbox()
    if not Hitbox then return end
    local newPos = Vector3.new(tX * getgenv().GridSize, tY * getgenv().GridSize, Hitbox.Position.Z)
    Hitbox.CFrame = CFrame.new(newPos)
    
    -- Sync posisi ke PlayerMovement script jika ada
    local PM = LP.PlayerScripts:FindFirstChild("PlayerMovement")
    if PM then
        pcall(function() require(PM).Position = newPos end)
    end
end

-- ========================================== --
-- LOGIKA UTAMA (Samping-ke-Samping)
-- ========================================== --
local isRunning = false

task.spawn(function()
    while task.wait(0.3) do
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            
            -- Scan dari Atas ke Bawah (Y)
            for currentY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end
                
                -- Tentukan arah jalan (Zig-Zag)
                local isRight = (getgenv().AC_StartY - currentY) % 2 == 0
                local startX = isRight and getgenv().AC_StartX or getgenv().AC_EndX
                local endX = isRight and getgenv().AC_EndX or getgenv().AC_StartX
                local step = isRight and 1 or -1

                for currentX = startX, endX, step do
                    if not getgenv().AutoClearEnabled then break end

                    -- Cek apakah ada blok atau background di depannya
                    if NeedsBreaking(currentX, currentY) then
                        -- Posisikan diri di SAMPING blok (Insta-Move)
                        FastMove(currentX - step, currentY)
                        
                        local tries = 0
                        -- Loop pukul sampai blok HILANG TOTAL
                        while NeedsBreaking(currentX, currentY) and tries < getgenv().MaxHitFailsafe do
                            RemoteBreak:FireServer(Vector2.new(currentX, currentY))
                            task.wait(getgenv().BreakDelay)
                            tries = tries + 1
                        end
                        
                        -- Penanganan jika blok tidak hancur-hancur
                        if tries >= getgenv().MaxHitFailsafe then
                            getgenv().AC_Blacklist[currentX .. "," .. currentY] = true
                        end
                    end
                end
            end
            
            isRunning = false
            getgenv().AutoClearEnabled = false
        end
    end
end)

-- ========================================== --
-- UI (Sesuai Permintaan)
-- ========================================== --
-- ... (Gunakan fungsi CreateToggle/CreateSlider yang sudah kamu miliki di script lama)
