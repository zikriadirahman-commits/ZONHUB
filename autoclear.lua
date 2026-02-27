local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")

local isFarming = false
local glideHeight = 4 -- Jarak karakter melayang di atas block (sesuaikan jangkauan tool)
local moveStep = 3    -- Jarak geser ke samping setelah block hancur/ketemu Bedrock

-- Fungsi untuk mendapatkan Tool yang sedang dipegang
local function getEquippedTool()
    return character:FindFirstChildOfClass("Tool")
end

-- Fungsi menembakkan sensor (Raycast) ke bawah untuk mendeteksi block
local function scanBelow()
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -10, 0) -- Jarak sensor ke bawah 10 stud
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    return workspace:Raycast(rayOrigin, rayDirection, raycastParams)
end

local function startFarming()
    -- Aktifkan mode Glide (Karakter melayang, tidak akan jatuh/lompat)
    rootPart.Anchored = true 
    
    while isFarming do
        task.wait(0.1)
        
        local tool = getEquippedTool()
        if not tool then
            warn("Pegang Tool/Pickaxe kamu dulu!")
            task.wait(1)
            continue
        end

        local hit = scanBelow()
        
        if hit and hit.Instance then
            local target = hit.Instance
            
            -- 1. DETEKSI BEDROCK: Langsung geser ke samping tanpa memukul
            if target.Name:lower() == "bedrock" then
                rootPart.CFrame = rootPart.CFrame * CFrame.new(moveStep, 0, 0)
                task.wait(0.3) -- Jeda sebentar biar tidak nge-glitch
                continue
            end

            -- 2. DETEKSI DIRT/BACKGROUND: Kunci posisi tepat di atas block
            rootPart.CFrame = CFrame.new(target.Position.X, target.Position.Y + glideHeight, rootPart.Position.Z)
            
            -- 3. STRICT BREAK: Pukul terus sampai block/background BENAR-BENAR hilang dari game
            repeat
                if not isFarming then break end
                
                tool:Activate() -- Mengayunkan tool/klik
                
                -- [OPSIONAL] Jika game butuh RemoteEvent khusus, letakkan di sini.
                -- Contoh: game.ReplicatedStorage.MineEvent:FireServer(target)
                
                task.wait(0.2) -- Kecepatan pukulan (sesuaikan dengan game)
            until target == nil or target.Parent == nil
            
            -- 4. PINDAH KE SAMPING: Hanya dieksekusi setelah target benar-benar hancur
            rootPart.CFrame = rootPart.CFrame * CFrame.new(moveStep, 0, 0)
            
        else
            -- Kalau di bawah kosong (sudah digali semua), otomatis geser ke samping cari block baru
            rootPart.CFrame = rootPart.CFrame * CFrame.new(moveStep, 0, 0)
            task.wait(0.2)
        end
    end
end

-- Sistem Tombol On/Off (Toggle) menggunakan tombol "F" di keyboard
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        isFarming = not isFarming
        
        if isFarming then
            print("Auto Mine: ON - Mode Glide Aktif")
            startFarming()
        else
            print("Auto Mine: OFF")
            rootPart.Anchored = false -- Lepaskan karakter kembali normal
        end
    end
end)

print("Script siap! Pegang pickaxe dan tekan 'F' untuk mulai/berhenti.")
