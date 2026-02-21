-- [[ ZONHUB - MOVEMENT & COLLECT MODULE ]] --
local TargetPage = ...
if not TargetPage then
    warn("Module harus di-load dari ZONHUB Index!")
    return
end

getgenv().ScriptVersion = "ZONHUB Movement v1.0"

-- =========================
-- CONFIG DEFAULT
-- =========================
getgenv().FlyEnabled = false
getgenv().FlySpeed = 40

getgenv().SpeedEnabled = false
getgenv().WalkSpeedValue = 30

getgenv().AutoCollect = false
getgenv().CollectRadius = 20

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local function GetChar()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char, char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
end

local Character, Humanoid, HRP = GetChar()
LP.CharacterAdded:Connect(function()
    Character, Humanoid, HRP = GetChar()
end)

-- =========================
-- UI THEME (PAKAI YANG SUDAH ADA)
-- =========================
local Theme = {
    Item = Color3.fromRGB(30, 40, 35),
    Text = Color3.fromRGB(220, 255, 230),
    Accent = Color3.fromRGB(60, 200, 120)
}

-- =========================
-- UI ELEMENTS (SAMA STYLE)
-- =========================
function CreateToggle(Parent, Text, Var)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Parent
    Btn.BackgroundColor3 = Theme.Item
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Text = ""
    Btn.AutoButtonColor = false

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Btn)
    Label.Text = Text
    Label.TextColor3 = Theme.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Left

    local Dot = Instance.new("Frame", Btn)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(1, -30, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    Btn.MouseButton1Click:Connect(function()
        getgenv()[Var] = not getgenv()[Var]
        Dot.BackgroundColor3 = getgenv()[Var] and Theme.Accent or Color3.fromRGB(90, 90, 90)
    end)
end

function CreateSlider(Parent, Text, Min, Max, Default, Var)
    getgenv()[Var] = Default

    local Frame = Instance.new("Frame", Parent)
    Frame.BackgroundColor3 = Theme.Item
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = Text .. ": " .. Default
    Label.TextColor3 = Theme.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -20, 0, 18)
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Left

    local Bar = Instance.new("TextButton", Frame)
    Bar.Position = UDim2.new(0, 10, 0, 28)
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Text = ""
    Bar.AutoButtonColor = false
    Bar.BackgroundColor3 = Color3.fromRGB(20, 25, 23)
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        local x = math.clamp(
            (input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0, 1
        )
        local value = math.floor(Min + (Max - Min) * x)
        Fill.Size = UDim2.new(x, 0, 1, 0)
        Label.Text = Text .. ": " .. value
        getgenv()[Var] = value
    end)
end

-- =========================
-- INJECT KE GUI
-- =========================
CreateToggle(TargetPage, "Fly", "FlyEnabled")
CreateSlider(TargetPage, "Fly Speed", 10, 100, 40, "FlySpeed")

CreateToggle(TargetPage, "Speed", "SpeedEnabled")
CreateSlider(TargetPage, "Walk Speed", 16, 100, 30, "WalkSpeedValue")

CreateToggle(TargetPage, "Auto Collect", "AutoCollect")
CreateSlider(TargetPage, "Collect Radius", 1, 100, 20, "CollectRadius")

-- =========================
-- FLY LOGIC (HALUS)
-- =========================
local BV, BG

RunService.RenderStepped:Connect(function()
    if not HRP or not Humanoid then return end

    -- SPEED
    Humanoid.WalkSpeed = getgenv().SpeedEnabled and getgenv().WalkSpeedValue or 16

    -- FLY
    if getgenv().FlyEnabled then
        if not BV then
            BV = Instance.new("BodyVelocity", HRP)
            BG = Instance.new("BodyGyro", HRP)
            BV.MaxForce = Vector3.new(1e8,1e8,1e8)
            BG.MaxTorque = Vector3.new(1e8,1e8,1e8)
        end
        BG.CFrame = workspace.CurrentCamera.CFrame
        BV.Velocity = Humanoid.MoveDirection * getgenv().FlySpeed
    else
        if BV then BV:Destroy() BV = nil end
        if BG then BG:Destroy() BG = nil end
    end
end)

-- =========================
-- AUTO COLLECT (RADIUS)
-- =========================
task.spawn(function()
    while task.wait(0.4) do
        if not getgenv().AutoCollect or not HRP then continue end

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                local part = v.Parent:IsA("BasePart") and v.Parent
                if part and (part.Position - HRP.Position).Magnitude <= getgenv().CollectRadius then
                    pcall(function()
                        fireproximityprompt(v, 0)
                    end)
                end
            end
        end
    end
end)
