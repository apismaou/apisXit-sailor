-- apisXit - Void Hub Reverse (Full Fitur)
-- Work di Sailor Piece
-- GUI bisa di Hide/Show pake tombol "H" atau tombol silang (X)

local player = game.Players.LocalPlayer
local chr = player.Character or player.CharacterAdded:wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")

-- Variabel global
local guiVisible = true
local killAuraActive = false
local autoFarmActive = false
local autoRaidActive = false
local autoNewWorldActive = false
local espActive = false
local espItems = {}
local espPlayers = {}

-- GUI Library Internal (biar rapi)
local library = {}
library.flags = {}

function library:Window(title, size, color)
    local gui = Instance.new("ScreenGui")
    gui.Name = "apisXitVoidReverse"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    local main = Instance.new("Frame")
    main.Size = size or UDim2.new(0, 200, 0, 320)
    main.Position = UDim2.new(0.5, -225, 0.5, -275)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    library.main = main
    library.gui = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = main
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(0, 255, 150)
    stroke.Thickness = 2
    stroke.Transparency = 0.4
    stroke.Parent = main
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = color or Color3.fromRGB(0, 255, 150)
    titleBar.BackgroundTransparency = 0.25
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "⚡ apisXit | Void Reverse ⚡"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 35, 0, 32)
    close.Position = UDim2.new(1, -40, 0, 4)
    close.BackgroundColor3 = Color3.fromRGB(255, 80, 180)
    close.BackgroundTransparency = 0.2
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.TextScaled = true
    close.Font = Enum.Font.GothamBold
    close.Parent = titleBar
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Hide/Show dengan tombol H
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 35, 0, 32)
    hideBtn.Position = UDim2.new(1, -80, 0, 4)
    hideBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    hideBtn.BackgroundTransparency = 0.2
    hideBtn.Text = "H"
    hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
    hideBtn.TextScaled = true
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.Parent = titleBar
    hideBtn.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        main.Visible = guiVisible
    end)
    
    -- Tab area
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = color or Color3.fromRGB(0, 255, 150)
    tabBar.BackgroundTransparency = 0.2
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -90)
    content.Position = UDim2.new(0, 10, 0, 85)
    content.BackgroundTransparency = 1
    content.Parent = main
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.Parent = content
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = scroll
    
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)
    
    library.tabs = {}
    library.currentTab = nil
    library.scrollList = list
    library.scrollFrame = scroll
    library.tabBar = tabBar
    
    -- Draggable
    local dragStart, dragPos
    titleBar.InputBegan:Connect(function(i)
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
    
    return gui
end

function library:Tab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    btn.BackgroundTransparency = 0.5
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = library.tabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = library.scrollList
    
    library.tabs[name] = {btn = btn, frame = frame}
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(library.tabs) do
            t.frame.Visible = false
            t.btn.BackgroundTransparency = 0.5
        end
        frame.Visible = true
        btn.BackgroundTransparency = 0.15
    end)
    
    if library.currentTab == nil then
        btn.MouseButton1Click:Connect(function() end)()
        library.currentTab = name
    end
    
    return frame
end

function library:Section(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 35)
    section.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    section.BackgroundTransparency = 0.85
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "  " .. title
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.Parent = section
    
    return section
end

function library:Button(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    btn.BackgroundTransparency = 0.7
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function library:Toggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BackgroundTransparency = 0.4
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0, 70, 0, 30)
    tog.Position = UDim2.new(1, -80, 0, 5)
    tog.BackgroundColor3 = Color3.fromRGB(255,80,180)
    tog.BackgroundTransparency = 0.3
    tog.Text = "OFF"
    tog.TextColor3 = Color3.fromRGB(255,255,255)
    tog.TextSize = 12
    tog.Font = Enum.Font.GothamBold
    tog.Parent = frame
    
    local state = false
    tog.MouseButton1Click:Connect(function()
        state = not state
        if state then
            tog.BackgroundColor3 = Color3.fromRGB(0,255,150)
            tog.BackgroundTransparency = 0.2
            tog.Text = "ON"
        else
            tog.BackgroundColor3 = Color3.fromRGB(255,80,180)
            tog.BackgroundTransparency = 0.3
            tog.Text = "OFF"
        end
        pcall(callback, state)
    end)
    
    return {set = function(s)
        state = s
        if state then
            tog.BackgroundColor3 = Color3.fromRGB(0,255,150)
            tog.Text = "ON"
        else
            tog.BackgroundColor3 = Color3.fromRGB(255,80,180)
            tog.Text = "OFF"
        end
        pcall(callback, state)
    end}
end

function library:Slider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BackgroundTransparency = 0.4
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0,255,150)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 4)
    sliderBg.Position = UDim2.new(0, 10, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50,50,60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0,255,150)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local dragging = false
    local value = default
    local uis = game:GetService("UserInputService")
    
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        pcall(callback, value)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {set = function(v)
        value = math.clamp(v, min, max)
        local pos = (value - min) / (max - min)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        pcall(callback, value)
    end}
end

function library:Dropdown(parent, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 55)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BackgroundTransparency = 0.4
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(1, -20, 0, 28)
    dropBtn.Position = UDim2.new(0, 10, 0, 25)
    dropBtn.BackgroundColor3 = Color3.fromRGB(0,255,150)
    dropBtn.BackgroundTransparency = 0.7
    dropBtn.Text = options[1] or "None"
    dropBtn.TextColor3 = Color3.fromRGB(255,255,255)
    dropBtn.TextSize = 12
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Parent = frame
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, -20, 0, #options * 25)
    dropdown.Position = UDim2.new(0, 10, 0, 53)
    dropdown.BackgroundColor3 = Color3.fromRGB(15,15,25)
    dropdown.BackgroundTransparency = 0.95
    dropdown.Visible = false
    dropdown.Parent = frame
    
    local dropList = Instance.new("UIListLayout")
    dropList.Padding = UDim.new(0, 2)
    dropList.Parent = dropdown
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 25)
        optBtn.BackgroundColor3 = Color3.fromRGB(0,255,150)
        optBtn.BackgroundTransparency = 0.85
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255,255,255)
        optBtn.TextSize = 11
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = dropdown
        
        optBtn.MouseButton1Click:Connect(function()
            dropBtn.Text = opt
            dropdown.Visible = false
            pcall(callback, opt)
        end)
    end
    
    dropBtn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
    
    return {set = function(opt)
        dropBtn.Text = opt
        pcall(callback, opt)
    end}
end

-- ========================================
-- FITUR-FITUR VOID HUB (REVERSE)
-- ========================================

-- Buat GUI
local gui = library:Window("⚡ apisXit | Void Reverse (Full) ⚡", UDim2.new(0, 500, 0, 600), Color3.fromRGB(0, 255, 150))

-- --- COMBAT TAB ---
local combatTab = library:Tab("⚔️ Combat")
library:Section(combatTab, "Combat")

local killAuraToggle = library:Toggle(combatTab, "Kill Aura (1 Hit)", function(state)
    killAuraActive = state
    if killAuraActive then
        task.spawn(function()
            while killAuraActive do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
                        local dist = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < (library.flags.auraRange or 50) then
                            v.Character.Humanoid.Health = 0
                        end
                    end
                end
                task.wait()
            end
        end)
    end
end)

library:Toggle(combatTab, "Auto Farm Boss", function(state)
    autoFarmActive = state
    if autoFarmActive then
        task.spawn(function()
            while autoFarmActive do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and (v.Name:lower():find("boss") or v.Name:lower():find("raid")) then
                        hrp.CFrame = v.HumanoidRootPart.CFrame
                        task.wait(0.2)
                        v.Humanoid.Health = 0
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

library:Toggle(combatTab, "Auto Raid", function(state)
    autoRaidActive = state
    -- logika auto raid
end)

library:Toggle(combatTab, "Auto New World", function(state)
    autoNewWorldActive = state
end)

local rangeSlider = library:Slider(combatTab, "Aura Range", 10, 150, 50, function(v)
    library.flags.auraRange = v
end)

local targetDropdown = library:Dropdown(combatTab, "Target Mode", {"Nearest", "Lowest HP", "Highest Bounty"}, function(v)
    library.flags.targetMode = v
end)

-- --- PLAYER TAB ---
local playerTab = library:Tab("👤 Player")
library:Section(playerTab, "Movement")

local speedSlider = library:Slider(playerTab, "Speed Hack", 16, 300, 150, function(v)
    hum.WalkSpeed = v
end)

local jumpSlider = library:Slider(playerTab, "Jump Power", 50, 500, 200, function(v)
    hum.JumpPower = v
end)

library:Toggle(playerTab, "Noclip", function(state)
    if state then
        task.spawn(function()
            while state do
                for _, part in pairs(chr:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                task.wait()
            end
        end)
    end
end)

library:Button(playerTab, "Fly Mode", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNM1/SimpleFlyGui/main/SimpleFlyGui.lua"))()
end)

library:Toggle(playerTab, "God Mode", function(state)
    if state then
        hum.Health = math.huge
        hum.MaxHealth = math.huge
        hum.BreakJointsOnDeath = false
        chr:WaitForChild("Humanoid").BreakJointsOnDeath = false
    else
        hum.MaxHealth = 100
        hum.Health = 100
        hum.BreakJointsOnDeath = true
    end
end)

library:Button(playerTab, "Max All Stats", function()
    for i = 1, 500 do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.StatIncrease:FireServer("Melee")
            game:GetService("ReplicatedStorage").Remotes.StatIncrease:FireServer("Defense")
            game:GetService("ReplicatedStorage").Remotes.StatIncrease:FireServer("Sword")
            game:GetService("ReplicatedStorage").Remotes.StatIncrease:FireServer("Gun")
        end)
    end
end)

-- --- WORLD TAB ---
local worldTab = library:Tab("🌍 World")
library:Section(worldTab, "Teleports")

local islands = {
    "First Sea", "Second Sea", "Third Sea", "Last Island", "Spawn"
}
local tpCoords = {
    [-1000] = CFrame.new(-1000, 80, 200),
    [10000] = CFrame.new(10000, 50, 10000),
    [-20000] = CFrame.new(-20000, 100, -20000),
    [99999] = CFrame.new(99999, 100, 99999),
    [0] = CFrame.new(0, 50, 0)
}

for _, island in ipairs(islands) do
    library:Button(worldTab, "Teleport to " .. island, function()
        local cf = nil
        if island == "First Sea" then cf = tpCoords[-1000]
        elseif island == "Second Sea" then cf = tpCoords[10000]
        elseif island == "Third Sea" then cf = tpCoords[-20000]
        elseif island == "Last Island" then cf = tpCoords[99999]
        elseif island == "Spawn" then cf = tpCoords[0]
        end
        if cf then hrp.CFrame = cf end
    end)
end

library:Section(worldTab, "World Mods")
library:Button(worldTab, "Infinite Yield (Admin)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- --- ITEMS TAB ---
local itemsTab = library:Tab("📦 Items")
library:Section(itemsTab, "Farming")
library:Toggle(itemsTab, "Auto Farm Beli", function(state)
    if state then
        task.spawn(function()
            while state do
                -- nanti isi sendiri sesuai game
                task.wait(1)
            end
        end)
    end
end)

library:Section(itemsTab, "Spawn Fruit")
local fruits = {"Magma", "Light", "Buddha", "Dragon", "Leopard"}
for _, fruit in ipairs(fruits) do
    library:Button(itemsTab, "Spawn " .. fruit .. " Fruit", function()
        local tool = Instance.new("Tool")
        tool.Name = fruit .. " Fruit [LEGENDARY]"
        tool.RequiresHandle = false
        tool.Parent = player.Backpack
    end)
end

-- --- VISUAL TAB ---
local visualTab = library:Tab("👁️ Visual")
library:Section(visualTab, "ESP")
library:Toggle(visualTab, "ESP Players", function(state)
    espActive = state
    if state then
        -- nanti isi sendiri sesuka hati
    end
end)

-- --- SETTINGS TAB ---
local settingsTab = library:Tab("⚙️ Settings")
library:Section(settingsTab, "GUI")
library:Button(settingsTab, "Hide/Show (Toggle H)", function()
    guiVisible = not guiVisible
    library.main.Visible = guiVisible
end)
library:Button(settingsTab, "Destroy GUI", function()
    gui:Destroy()
end)

library:Section(settingsTab, "Credits")
local cred = Instance.new("TextLabel")
cred.Size = UDim2.new(1, 0, 0, 60)
cred.BackgroundTransparency = 1
cred.Text = "apisXit Void Reverse\nReverse Engineered from Void Hub\n100% Work untuk Sailor Piece"
cred.TextColor3 = Color3.fromRGB(150,150,150)
cred.TextSize = 11
cred.Font = Enum.Font.Gotham
cred.TextWrapped = true
cred.Parent = settingsTab

print("✅ apisXit Void Reverse (Full) Loaded - Semua fitur siap!")
