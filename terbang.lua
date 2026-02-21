--[[ 
    ZONHUB MOBILE CLIENT
    Fly + Speed + Auto Collect
    Touch Friendly | Optimized
]]--

-- ======================
-- GLOBAL CONFIG
-- ======================
getgenv().ZONHUB = {
    Fly = false,
    Speed = false,
    AutoCollect = false,

    FlySpeed = 50,
    WalkSpeed = 32
}

-- ======================
-- SERVICES
-- ======================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local function GetChar()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c, c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

local Char, Humanoid, HRP = GetChar()

LP.CharacterAdded:Connect(function()
    Char, Humanoid, HRP = GetChar()
end)

-- ======================
-- FLY SYSTEM (MOBILE SAFE)
-- ======================
local FlyConn
local BV, BG

local function EnableFly()
    if BV then return end

    BV = Instance.new("BodyVelocity")
    BG = Instance.new("BodyGyro")

    BV.MaxForce = Vector3.new(9e8, 9e8, 9e8)
    BG.MaxTorque = Vector3.new(9e8, 9e8, 9e8)

    BV.Parent = HRP
    BG.Parent = HRP

    FlyConn = RunService.RenderStepped:Connect(function()
        if not getgenv().ZONHUB.Fly then return end

        local cam = workspace.CurrentCamera
        BG.CFrame = cam.CFrame

        local moveDir = Humanoid.MoveDirection
        BV.Velocity = (moveDir.Magnitude > 0 and moveDir.Unit or Vector3.zero) * getgenv().ZONHUB.FlySpeed
    end)
end

local function DisableFly()
    if FlyConn then FlyConn:Disconnect() FlyConn = nil end
    if BV then BV:Destroy() BV = nil end
    if BG then BG:Destroy() BG = nil end
end

-- ======================
-- SPEED SYSTEM (SMOOTH)
-- ======================
RunService.Heartbeat:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = getgenv().ZONHUB.Speed and getgenv().ZONHUB.WalkSpeed or 16
    end
end)

-- ======================
-- AUTO COLLECT (SAFE)
-- ======================
task.spawn(function()
    while task.wait(0.4) do
        if not getgenv().ZONHUB.AutoCollect then continue end

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                pcall(function()
                    fireproximityprompt(v, 0)
                end)
            end
        end
    end
end)

-- ======================
-- MOBILE TOUCH UI
-- ======================
local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "ZONHUB_MOBILE"
Gui.ResetOnSpawn = false

local function MakeButton(text, pos, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(140, 42)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(20, 30, 25)
    b.TextColor3 = Color3.fromRGB(200, 255, 220)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = Gui
    b.AutoButtonColor = true

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)

    b.Activated:Connect(callback)
    return b
end

-- BUTTONS
MakeButton("FLY", UDim2.new(0, 15, 0.55, 0), function()
    getgenv().ZONHUB.Fly = not getgenv().ZONHUB.Fly
    if getgenv().ZONHUB.Fly then
        EnableFly()
    else
        DisableFly()
    end
end)

MakeButton("SPEED", UDim2.new(0, 15, 0.63, 0), function()
    getgenv().ZONHUB.Speed = not getgenv().ZONHUB.Speed
end)

MakeButton("AUTO", UDim2.new(0, 15, 0.71, 0), function()
    getgenv().ZONHUB.AutoCollect = not getgenv().ZONHUB.AutoCollect
end)

print("ZONHUB MOBILE LOADED")
