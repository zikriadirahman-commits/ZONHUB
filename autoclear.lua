-- [[ ZONHUB - AUTOCLEAR MODULE (ZIG-ZAG PATTERN) ]] --
local TargetPage = ... 

-- Mencegah error jika dijalankan tanpa Index
if not TargetPage then 
    warn("Running in standalone mode (TargetPage not found)")
    TargetPage = Instance.new("ScrollingFrame")
    TargetPage.Name = "StandaloneAutoClear"
    TargetPage.Size = UDim2.new(0, 300, 0, 400)
    TargetPage.Parent = game:GetService("CoreGui"):FindFirstChild("ZonHubIndex") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui")
end

getgenv().ScriptVersion = "AutoClear v1.5 - ZigZag" 

-- ========================================== --
-- VARIABEL GLOBAL (Bisa diatur via UI)
-- ========================================== --
getgenv().AutoClearEnabled = false
getgenv().AC_StartX = 0
getgenv().AC_EndX = 100
getgenv().AC_StartY = 37
getgenv().AC_EndY = 6
getgenv().AC_Speed = 80 -- Skala 1 - 100

-- ========================================== --
-- FUNGSI UI UTILITY (Mengikuti Manager.lua)
-- ========================================== --
local UIS = game:GetService("UserInputService")
local Theme = { Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local function CreateToggle(Parent, Text, Var, OnToggle) 
    local Btn = Instance.new("TextButton")
    Btn.Parent = Parent; Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, -10, 0, 35); Btn.Text = ""
    local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Btn
    local T = Instance.new("TextLabel"); T.Parent = Btn; T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left
    local IndBg = Instance.new("Frame"); IndBg.Parent = Btn; IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(1,0); IC.Parent = IndBg
    local Dot = Instance.new("Frame"); Dot.Parent = IndBg; Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(1,0); DC.Parent = Dot
    Btn.MouseButton1Click:Connect(function() 
        getgenv()[Var] = not getgenv()[Var]
        if getgenv()[Var] then 
            Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple 
        else 
            Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) 
        end 
        if OnToggle then OnToggle(getgenv()[Var]) end 
    end) 
end

local function CreateSlider(Parent, Text, Min, Max, Default, Var) 
    local Frame = Instance.new("Frame"); Frame.Parent = Parent; Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, -10, 0, 45)
    local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Frame
    local Label = Instance.new("TextLabel"); Label.Parent = Frame; Label.Text = Text .. ": " .. Default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
    local SliderBg = Instance.new("TextButton"); SliderBg.Parent = Frame; SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""
    local Fill = Instance.new("Frame"); Fill.Parent = SliderBg; Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0)
    local Dragging = false
    local function Update(input)
        local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local Val = math.floor(Min + ((Max - Min) * SizeX))
        Fill.Size = UDim2.new(SizeX, 0, 1, 0)
        Label.Text = Text .. ": " .. Val
        getgenv()[Var] = Val
    end
    SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end)
    UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end)
end

-- ========================================== --
-- MEMBANGUN MENU UI
-- ========================================== --
CreateToggle(TargetPage, "Start Auto Clear World", "AutoClearEnabled")
CreateSlider(TargetPage, "Speed Script", 1, 100, 80, "AC_Speed")
CreateSlider(TargetPage, "Start X", 0, 500, 0, "AC_StartX")
CreateSlider(TargetPage, "End X", 0, 500, 100, "AC_EndX")
CreateSlider(TargetPage, "Start Y", 0, 150, 37, "AC_StartY")
CreateSlider(TargetPage, "End Y", 0, 150, 6, "AC_EndY")

-- ========================================== --
-- FUNGSI API GAME
-- ========================================== --
local function GetDelay()
    local speed = math.clamp(getgenv().AC_Speed, 1, 100)
    if speed == 100 then return 0.01 end
    return 1 / speed
end

local function MoveTo(x, y)
    -- TODO: Masukkan script pemindah/teleport karakter game Anda di sini
    -- Contoh umum Roblox:
    -- local HRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    -- if HRP then HRP.CFrame = CFrame.new(x * 3, y * 3, 0) end 
    -- (Catatan: * 3 adalah skala block standar di banyak game voxel, sesuaikan jika perlu)
end

local function IsBlockSolid(x, y)
    -- TODO: Masukkan logika deteksi block Anda di sini
    -- Wajib return "true" jika block masih bisa dipukul, "false" jika sudah kosong/hancur total
    return false 
end

local function PunchBlock(x, y)
    -- TODO: Masukkan script untuk klik/pukul/hancurkan block di sini
end

-- ========================================== --
-- LOGIKA ZIG-ZAG UTAMA (THREAD)
-- ========================================== --
local isRunning = false

task.spawn(function()
    while task.wait(0.2) do
        -- Jika Toggle dinyalakan dan loop belum berjalan
        if getgenv().AutoClearEnabled and not isRunning then
            isRunning = true
            
            -- Set Awal arah gerak (Kanan)
            local arahKanan = true 
            
            -- 1. Loop menurun berdasarkan ketinggian (Y)
            for currentY = getgenv().AC_StartY, getgenv().AC_EndY, -1 do
                if not getgenv().AutoClearEnabled then break end -- Break instan jika tombol dimatikan
                
                local blockTargetY = currentY - 1 -- Menargetkan blok tepat di bawah posisi karakter
                
                if arahKanan then
                    -- 2A. Bergerak dari KIRI (StartX) ke KANAN (EndX)
                    for currentX = getgenv().AC_StartX, getgenv().AC_EndX do
                        if not getgenv().AutoClearEnabled then break end
                        
                        -- Pindah langsung ke atas block
                        MoveTo(currentX, currentY)
                        task.wait(GetDelay()) 
                        
                        -- Hajar block di bawah sampai benar-benar hancur
                        while IsBlockSolid(currentX, blockTargetY) do
                            if not getgenv().AutoClearEnabled then break end
                            PunchBlock(currentX, blockTargetY)
                            task.wait(GetDelay())
                        end
                    end
                else
                    -- 2B. Bergerak dari KANAN (EndX) ke KIRI (StartX) (Turun langsung di tempat, jalan mundur)
                    for currentX = getgenv().AC_EndX, getgenv().AC_StartX, -1 do
                        if not getgenv().AutoClearEnabled then break end
                        
                        -- Pindah langsung ke atas block
                        MoveTo(currentX, currentY)
                        task.wait(GetDelay()) 
                        
                        -- Hajar block di bawah sampai benar-benar hancur
                        while IsBlockSolid(currentX, blockTargetY) do
                            if not getgenv().AutoClearEnabled then break end
                            PunchBlock(currentX, blockTargetY)
                            task.wait(GetDelay())
                        end
                    end
                end
                
                -- Membalik arah (Kanan jadi Kiri, Kiri jadi Kanan) untuk layer selanjutnya
                arahKanan = not arahKanan 
            end
            
            -- Reset toggle saat sudah mencapai EndY (Y=6)
            isRunning = false
            if getgenv().AutoClearEnabled then
                getgenv().AutoClearEnabled = false
                -- (Opsional) Tambahkan notifikasi selesai di sini
            end
        end
    end
end)
