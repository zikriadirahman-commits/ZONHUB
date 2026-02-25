-- [[ MODUL AUTO CLEAR WORLD ]] --
return function(Page)
    -- ========================================== --
    -- PENGATURAN SCRIPT (BISA DIATUR DI SINI)
    -- ========================================== --
    local Config = {
        StartX = 0,
        EndX = 100,
        StartY = 37,
        EndY = 6,
        Kecepatan = 80 -- Skala 1 sampai 100 (1 = Sangat Lambat, 100 = Sangat Cepat / Instan)
    }
    
    -- Variabel Kontrol
    local isRunning = false

    -- Mengkalkulasi delay (task.wait) berdasarkan Kecepatan (1-100)
    -- Jika kecepatan 100, delay hampir 0. Jika 1, delay 1 detik.
    local function GetDelay()
        local speed = math.clamp(Config.Kecepatan, 1, 100)
        if speed == 100 then return 0.01 end
        return 1 / speed
    end

    -- ========================================== --
    -- FUNGSI API GAME (Ganti sesuai game Anda)
    -- ========================================== --
    local function MoveTo(x, y)
        -- Contoh: Teleportasi karakter ke X, Y
        -- print("Jalan ke: X="..x..", Y="..y)
    end

    local function IsBlockSolid(x, y)
        -- Return true jika block masih ada, false jika sudah hancur
        -- Contoh untuk testing (langsung anggap false agar loop tidak infinity):
        return false 
    end

    local function PunchBlock(x, y)
        -- Logika memukul block
        -- print("Hit block di: X="..x..", Y="..y)
    end

    -- ========================================== --
    -- LOGIKA UTAMA AUTO CLEAR
    -- ========================================== --
    local function StartAutoClear(StatusText)
        local arahKanan = true 
        
        -- Loop dari Y=37 turun sampai Y=6
        for currentY = Config.StartY, Config.EndY, -1 do
            if not isRunning then break end -- Cek jika di-stop
            
            local blockTargetY = currentY - 1 
            StatusText.Text = "Status: Membersihkan Baris Y = " .. currentY

            if arahKanan then
                -- Kiri ke Kanan
                for currentX = Config.StartX, Config.EndX do
                    if not isRunning then break end
                    
                    MoveTo(currentX, currentY)
                    task.wait(GetDelay()) -- Delay jalan
                    
                    while IsBlockSolid(currentX, blockTargetY) do
                        if not isRunning then break end
                        PunchBlock(currentX, blockTargetY)
                        task.wait(GetDelay()) -- Delay hit
                    end
                end
            else
                -- Kanan ke Kiri
                for currentX = Config.EndX, Config.StartX, -1 do
                    if not isRunning then break end
                    
                    MoveTo(currentX, currentY)
                    task.wait(GetDelay()) 
                    
                    while IsBlockSolid(currentX, blockTargetY) do
                        if not isRunning then break end
                        PunchBlock(currentX, blockTargetY)
                        task.wait(GetDelay())
                    end
                end
            end
            
            arahKanan = not arahKanan
        end
        
        -- Jika selesai natural
        if isRunning then
            isRunning = false
            StatusText.Text = "Status: Selesai!"
            StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end

    -- ========================================== --
    -- MEMBANGUN UI DI DALAM TAB
    -- ========================================== --
    
    -- Label Info
    local InfoLabel = Instance.new("TextLabel", Page)
    InfoLabel.Size = UDim2.new(1, 0, 0, 25)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Target X: " .. Config.StartX .. " to " .. Config.EndX .. " | Y: " .. Config.StartY .. " to " .. Config.EndY
    InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InfoLabel.Font = Enum.Font.GothamMedium
    InfoLabel.TextSize = 12
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Label Kecepatan
    local SpeedLabel = Instance.new("TextLabel", Page)
    SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "Kecepatan Script: " .. Config.Kecepatan .. " / 100"
    SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SpeedLabel.Font = Enum.Font.GothamMedium
    SpeedLabel.TextSize = 12
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Label Status Aktual
    local StatusText = Instance.new("TextLabel", Page)
    StatusText.Size = UDim2.new(1, 0, 0, 25)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Status: Menunggu (Idle)"
    StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
    StatusText.Font = Enum.Font.GothamBold
    StatusText.TextSize = 13
    StatusText.TextXAlignment = Enum.TextXAlignment.Left

    -- Tombol Start / Stop
    local ToggleBtn = Instance.new("TextButton", Page)
    ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 100) -- Warna Hijau Start
    ToggleBtn.Text = "START AUTO CLEAR"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

    -- Logika Klik Tombol
    ToggleBtn.MouseButton1Click:Connect(function()
        if not isRunning then
            -- MULAISCRIPT
            isRunning = true
            ToggleBtn.Text = "STOP AUTO CLEAR"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- Warna Merah Stop
            StatusText.Text = "Status: Berjalan..."
            StatusText.TextColor3 = Color3.fromRGB(100, 200, 255)
            
            -- Jalankan loop di thread terpisah agar game tidak freeze
            task.spawn(function()
                StartAutoClear(StatusText)
                -- Reset tombol jika script selesai sendiri
                isRunning = false
                ToggleBtn.Text = "START AUTO CLEAR"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 100)
            end)
        else
            -- STOP SCRIPT
            isRunning = false
            ToggleBtn.Text = "START AUTO CLEAR"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 100)
            StatusText.Text = "Status: Dihentikan (Paused)"
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end
