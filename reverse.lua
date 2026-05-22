-- apisXit - Sailor Piece Reverse (Void Hub Style)
local player = game.Players.LocalPlayer
local chr = player.Character or player.CharacterAdded:wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "apisXitReverse"
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 500)
main.Position = UDim2.new(0.5, -200, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
main.BackgroundTransparency = 0.2
main.Parent = gui
Instance.new("UICorner").CornerRadius = UDim.new(0, 12)
Instance.new("UICorner").Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
title.BackgroundTransparency = 0.3
title.Text = "⚡ apisXit | Sailor Piece ⚡"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 28)
close.Position = UDim2.new(1, -35, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(255,80,180)
close.BackgroundTransparency = 0.2
close.Text = "X"
close.Parent = title
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = scroll

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    btn.BackgroundTransparency = 0.7
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
end

local function addToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BackgroundTransparency = 0.4
    frame.Parent = scroll
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0, 60, 0, 28)
    tog.Position = UDim2.new(1, -70, 0, 6)
    tog.BackgroundColor3 = Color3.fromRGB(255,80,180)
    tog.BackgroundTransparency = 0.3
    tog.Text = "OFF"
    tog.Parent = frame
    local state = false
    tog.MouseButton1Click:Connect(function()
        state = not state
        tog.BackgroundColor3 = state and Color3.fromRGB(0,255,150) or Color3.fromRGB(255,80,180)
        tog.Text = state and "ON" or "OFF"
        pcall(callback, state)
    end)
end

-- Fitur Void Hub Style
addButton("💀 Kill Aura (1 Hit)", function()
    local ka = true
    task.spawn(function()
        while ka do
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                    v.Character.Humanoid.Health = 0
                end
            end
            task.wait()
        end
    end)
end)

addButton("⚔️ Auto Farm Boss", function()
    -- boss farm logic
end)

addButton("🌀 Auto Raid", function()
    -- raid logic
end)

addButton("🌊 Auto New World", function()
    -- new world logic
end)

addButton("🏃 Speed + Fly", function()
    hum.WalkSpeed = 150
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNM1/SimpleFlyGui/main/SimpleFlyGui.lua"))()
end)

addButton("🗺️ Teleport Last Island", function()
    hrp.CFrame = CFrame.new(99999, 100, 99999)
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 20)
end)

-- Draggable
local dragStart, dragPos
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = i.Position
        dragPos = main.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(i)
    if dragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + delta.X, dragPos.Y.Scale, dragPos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = nil end
end)

print("✅ apisXit Reverse Loaded")
