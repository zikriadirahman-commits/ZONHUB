-- [[ ZONHUB | Movement & Auto Collect Module ]] --
local TargetPage = ...
if not TargetPage then
    warn("ZONHUB: Module harus di-load dari Index")
    return
end

-- =====================
-- UI SAFETY (WAJIB)
-- =====================
if TargetPage:IsA("ScrollingFrame") then
    TargetPage.CanvasSize = UDim2.new(0,0,0,0)
end

local layout = TargetPage:FindFirstChildOfClass("UIListLayout")
if not layout then
    layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,6)
    layout.Parent = TargetPage

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if TargetPage:IsA("ScrollingFrame") then
            TargetPage.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
        end
    end)
end

-- =====================
-- GLOBAL STATE
-- =====================
getgenv().FlyEnabled = false
getgenv().FlySpeed = 40

getgenv().SpeedEnabled = false
getgenv().WalkSpeedValue = 30

getgenv().AutoCollect = false
getgenv().CollectRadius = 20

-- =====================
-- SERVICES
-- =====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local function GetChar()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c, c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

local Char, Humanoid, HRP = GetChar()
LP.CharacterAdded:Connect(function()
    Char, Humanoid, HRP = GetChar()
end)

-- =====================
-- THEME (HIJAU HITAM)
-- =====================
local Theme = {
    Item = Color3.fromRGB(30,40,35),
    Text = Color3.fromRGB(220,255,230),
    Accent = Color3.fromRGB(60,200,120),
    Off = Color3.fromRGB(120,120,120)
}

-- =====================
-- UI ELEMENTS
-- =====================
local function CreateToggle(Parent, Text, Var)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Parent
    Btn.Size = UDim2.new(1,-10,0,36)
    Btn.BackgroundColor3 = Theme.Item
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)

    local Label = Instance.new("TextLabel", Btn)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1,-70,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Theme.Text

    local Status = Instance.new("TextLabel", Btn)
    Status.Size = UDim2.new(0,50,1,0)
    Status.Position = UDim2.new(1,-55,0,0)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Right

    local function Refresh()
        local on = getgenv()[Var]
        Label.Text = Text
        Status.Text = on and "ON" or "OFF"
        Status.TextColor3 = on and Theme.Accent or Theme.Off
    end

    Btn.MouseButton1Click:Connect(function()
        getgenv()[Var] = not getgenv()[Var]
        Refresh()
    end)

    Refresh()
end

local function CreateSlider(Parent, Text, Min, Max, Default, Var)
    getgenv()[Var] = Default

    local Frame = Instance.new("Frame", Parent)
    Frame.Size = UDim2.new(1,-10,0,45)
    Frame.BackgroundColor3 = Theme.Item
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)

    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0,10,0,2)
    Label.Size = UDim2.new(1,-20,0,18)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Theme.Text

    local Bar = Instance.new("TextButton", Frame)
    Bar.Text = ""
    Bar.AutoButtonColor = false
    Bar.Position = UDim2.new(0,10,0,28)
    Bar.Size = UDim2.new(1,-20,0,6)
    Bar.BackgroundColor3 = Color3.fromRGB(20,25,23)
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame", Bar)
    Fill.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

    local function SetValue(x)
        local alpha = math.clamp(x,0,1)
        local value = math.floor(Min + (Max-Min)*alpha)
        Fill.Size = UDim2.new(alpha,0,1,0)
        Label.Text = Text.." : "..value
        getgenv()[Var] = value
    end

    SetValue((Default-Min)/(Max-Min))

    Bar.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.Touch
        and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        SetValue((i.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X)
    end)
end

-- =====================
-- UI BUILD
-- =====================
CreateToggle(TargetPage,"Fly","FlyEnabled")
CreateSlider(TargetPage,"Fly Speed",10,100,40,"FlySpeed")

CreateToggle(TargetPage,"Speed Run","SpeedEnabled")
CreateSlider(TargetPage,"Walk Speed",16,100,30,"WalkSpeedValue")

CreateToggle(TargetPage,"Auto Collect","AutoCollect")
CreateSlider(TargetPage,"Collect Radius",1,100,20,"CollectRadius")

-- =====================
-- LOGIC
-- =====================
local BV, BG

RunService.RenderStepped:Connect(function()
    if not HRP or not Humanoid then return end

    Humanoid.WalkSpeed =
        getgenv().SpeedEnabled and getgenv().WalkSpeedValue or 16

    if getgenv().FlyEnabled then
        if not BV then
            BV = Instance.new("BodyVelocity",HRP)
            BG = Instance.new("BodyGyro",HRP)
            BV.MaxForce = Vector3.new(1e8,1e8,1e8)
            BG.MaxTorque = Vector3.new(1e8,1e8,1e8)
        end
        BG.CFrame = workspace.CurrentCamera.CFrame
        BV.Velocity = Humanoid.MoveDirection * getgenv().FlySpeed
    else
        if BV then BV:Destroy() BV=nil end
        if BG then BG:Destroy() BG=nil end
    end
end)

task.spawn(function()
    while task.wait(0.4) do
        if not getgenv().AutoCollect or not HRP then continue end

        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                local p = v.Parent
                if p:IsA("BasePart")
                and (p.Position-HRP.Position).Magnitude <= getgenv().CollectRadius then
                    pcall(function()
                        fireproximityprompt(v,0)
                    end)
                end
            end
        end
    end
end)
