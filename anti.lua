-- ServerScriptService/LavaDamage.server.lua
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local DAMAGE_PER_TICK = 8
local TICK = 0.5

local touching = {} -- [Humanoid] = true/false

local function getHumanoid(hit)
    local model = hit and hit.Parent
    if not model then return end
    return model:FindFirstChildOfClass("Humanoid")
end

local function startDot(hum)
    if touching[hum] then return end
    touching[hum] = true

    task.spawn(function()
        while touching[hum] and hum.Parent do
            -- immunity check (SERVER-SIDE)
            if not hum:GetAttribute("LavaImmune") then
                hum:TakeDamage(DAMAGE_PER_TICK)
            end
            task.wait(TICK)
        end
    end)
end

local function stopDot(hum)
    touching[hum] = nil
end

local function hookLavaPart(part)
    if not part:IsA("BasePart") then return end

    part.Touched:Connect(function(hit)
        local hum = getHumanoid(hit)
        if hum then startDot(hum) end
    end)

    part.TouchEnded:Connect(function(hit)
        local hum = getHumanoid(hit)
        if hum then stopDot(hum) end
    end)
end

-- Hook semua part yang di-tag Lava
for _, p in ipairs(CollectionService:GetTagged("Lava")) do
    hookLavaPart(p)
end
CollectionService:GetInstanceAddedSignal("Lava"):Connect(hookLavaPart)

-- (opsional) fallback kalau kamu nggak pakai tag:
-- for _, p in ipairs(workspace:GetDescendants()) do
--     if p:IsA("BasePart") and p.Name == "Lava" then hookLavaPart(p) end
-- end

-- contoh cara bikin pemain kebal:
-- set attribute saat spawn (misal semua kebal)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            -- set true kalau mau kebal
            -- hum:SetAttribute("LavaImmune", true)

            -- atau kebal sementara 10 detik:
            -- hum:SetAttribute("LavaImmune", true)
            -- task.delay(10, function()
            --     if hum.Parent then hum:SetAttribute("LavaImmune", false) end
            -- end)
        end
    end)
end)
