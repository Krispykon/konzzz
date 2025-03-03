-- Modern Browser-Style UI for Roblox with Animations and Stand
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- State variables
local menuEnabled = false
local states = {
    esp = false,
    invisible = false,
    speed = false,
    godMode = false,
    noClip = false,
    stand = false
}

-- Animation configurations
local MENU_ANIMATION_TIME = 0.4
local BUTTON_ANIMATION_TIME = 0.15
local STAND_ATTACK_COOLDOWN = 1.5
local STAND_DAMAGE = 25

-- Opera GX Theme Colors
local THEME = {
    background = Color3.fromRGB(36, 36, 36),
    titleBar = Color3.fromRGB(25, 25, 25),
    accent = Color3.fromRGB(255, 55, 55),
    buttonIdle = Color3.fromRGB(45, 45, 45),
    buttonHover = Color3.fromRGB(55, 55, 55),
    textPrimary = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(180, 180, 180),
    statusOff = Color3.fromRGB(239, 68, 68),
    statusOn = Color3.fromRGB(34, 197, 94)
}

-- Tween configurations
local tweenInfo = TweenInfo.new(
    MENU_ANIMATION_TIME,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

local buttonTweenInfo = TweenInfo.new(
    BUTTON_ANIMATION_TIME,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OperaGXMenu"
screenGui.Parent = game.CoreGui

-- Main browser window
local browserFrame = Instance.new("Frame")
browserFrame.Size = UDim2.new(0, 600, 0, 400)
browserFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
browserFrame.BackgroundColor3 = THEME.background
browserFrame.BorderSizePixel = 0
browserFrame.Visible = false
browserFrame.Active = true
browserFrame.Draggable = true
browserFrame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = browserFrame

-- Top bar (like Opera GX's title bar)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = THEME.titleBar
topBar.BorderSizePixel = 0
topBar.Parent = browserFrame

local topBarCorner = corner:Clone()
topBarCorner.Parent = topBar

-- Title text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "konnzzz menu"
title.TextColor3 = THEME.accent
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -40)
contentArea.Position = UDim2.new(0, 10, 0, 35)
contentArea.BackgroundColor3 = THEME.background
contentArea.BorderSizePixel = 0
contentArea.Parent = browserFrame

-- Create modern button with Opera GX style
local function createModernButton(name, yOffset, callback)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 0, 40)
    buttonContainer.Position = UDim2.new(0, 0, 0, yOffset)
    buttonContainer.BackgroundColor3 = THEME.buttonIdle
    buttonContainer.BorderSizePixel = 0
    buttonContainer.Parent = contentArea

    -- Add shadow effect
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = buttonContainer.ZIndex - 1
    shadow.Parent = buttonContainer

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 6)
    shadowCorner.Parent = shadow

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = buttonContainer

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -50, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundTransparency = 1
    button.Text = name
    button.TextColor3 = THEME.textPrimary
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = buttonContainer

    -- Add padding to text
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = button

    local status = Instance.new("Frame")
    status.Size = UDim2.new(0, 40, 0, 40)
    status.Position = UDim2.new(1, -45, 0, 0)
    status.BackgroundColor3 = THEME.statusOff
    status.BorderSizePixel = 0
    status.Parent = buttonContainer

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = status

    -- Add glow effect
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundColor3 = THEME.accent
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = buttonContainer.ZIndex - 1
    glow.Parent = buttonContainer

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 10)
    glowCorner.Parent = glow

    -- Hover and click effects
    buttonContainer.MouseEnter:Connect(function()
        TweenService:Create(buttonContainer, buttonTweenInfo, {
            BackgroundColor3 = THEME.buttonHover,
            Size = UDim2.new(1, 4, 0, 42)
        }):Play()
        
        TweenService:Create(glow, buttonTweenInfo, {
            BackgroundTransparency = 0.9
        }):Play()
    end)

    buttonContainer.MouseLeave:Connect(function()
        TweenService:Create(buttonContainer, buttonTweenInfo, {
            BackgroundColor3 = THEME.buttonIdle,
            Size = UDim2.new(1, 0, 0, 40)
        }):Play()
        
        TweenService:Create(glow, buttonTweenInfo, {
            BackgroundTransparency = 1
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        -- Click effect with ripple
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, mouse.X - buttonContainer.AbsolutePosition.X, 0, mouse.Y - buttonContainer.AbsolutePosition.Y)
        ripple.BackgroundColor3 = THEME.accent
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.ZIndex = buttonContainer.ZIndex + 1
        ripple.Parent = buttonContainer

        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple

        TweenService:Create(ripple, TweenInfo.new(0.5), {
            Size = UDim2.new(2, 0, 2, 0),
            Position = UDim2.new(-0.5, mouse.X - buttonContainer.AbsolutePosition.X, -0.5, mouse.Y - buttonContainer.AbsolutePosition.Y),
            BackgroundTransparency = 1
        }):Play()

        game:GetService("Debris"):AddItem(ripple, 0.5)
        
        callback()

        -- Status color transition with smooth animation
        local newColor = status.BackgroundColor3 == THEME.statusOff
            and THEME.statusOn
            or THEME.statusOff

        TweenService:Create(status, buttonTweenInfo, {
            BackgroundColor3 = newColor,
            Size = UDim2.new(0, 38, 0, 38)
        }):Play()
        
        wait(buttonTweenInfo.Time)
        
        TweenService:Create(status, buttonTweenInfo, {
            Size = UDim2.new(0, 40, 0, 40)
        }):Play()
    end)

    return buttonContainer
end

-- Feature functions
local function toggleESP()
    states.esp = not states.esp
    if states.esp then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end

local function toggleInvisible()
    states.invisible = not states.invisible
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = states.invisible and 1 or 0
            end
        end
    end
end

local function toggleSpeed()
    states.speed = not states.speed
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = states.speed and 50 or 16
        end
    end
end

local function toggleGodMode()
    states.godMode = not states.godMode
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if states.godMode then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end

local function toggleNoClip()
    states.noClip = not states.noClip
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not states.noClip
            end
        end
    end
end

local function toggleStand()
    states.stand = not states.stand
    local character = LocalPlayer.Character
    if not character then return end
    
    if states.stand then
        local stand = createStand()
        stand.Parent = character
        
        -- Weld stand to character
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local weld = Instance.new("Weld")
            weld.Part0 = hrp
            weld.Part1 = stand.PrimaryPart
            weld.C0 = CFrame.new(0, 0, -3)
            weld.Parent = stand
        end
    else
        local stand = character:FindFirstChild("Stand")
        if stand then stand:Destroy() end
    end
end

-- Stand Creation and Management
local function createStand()
    local stand = Instance.new("Model")
    stand.Name = "Stand"
    
    -- Create main body parts
    local torso = Instance.new("Part")
    torso.Size = Vector3.new(2, 2, 1)
    torso.BrickColor = BrickColor.new("Really black")
    torso.Name = "Torso"
    torso.Transparency = 0.2
    torso.CanCollide = false
    torso.Anchored = false
    torso.Parent = stand
    
    -- Set torso as PrimaryPart
    stand.PrimaryPart = torso
    
    local head = Instance.new("Part")
    head.Size = Vector3.new(1, 1, 1)
    head.BrickColor = BrickColor.new("Really black")
    head.Name = "Head"
    head.Transparency = 0.2
    head.CanCollide = false
    head.Parent = stand
    
    -- Create arms for attacking
    local rightArm = Instance.new("Part")
    rightArm.Size = Vector3.new(1, 2, 1)
    rightArm.BrickColor = BrickColor.new("Really black")
    rightArm.Name = "RightArm"
    rightArm.Transparency = 0.2
    rightArm.CanCollide = false
    rightArm.Parent = stand
    
    local leftArm = rightArm:Clone()
    leftArm.Name = "LeftArm"
    leftArm.Parent = stand
    
    -- Create welds
    local headWeld = Instance.new("Weld")
    headWeld.Part0 = torso
    headWeld.Part1 = head
    headWeld.C0 = CFrame.new(0, 1.5, 0)
    headWeld.Parent = torso
    
    local rightArmWeld = Instance.new("Weld")
    rightArmWeld.Part0 = torso
    rightArmWeld.Part1 = rightArm
    rightArmWeld.C0 = CFrame.new(1.5, 0, 0)
    rightArmWeld.Parent = torso
    
    local leftArmWeld = Instance.new("Weld")
    leftArmWeld.Part0 = torso
    leftArmWeld.Part1 = leftArm
    leftArmWeld.C0 = CFrame.new(-1.5, 0, 0)
    leftArmWeld.Parent = torso

    return stand
end

-- Stand attack function
local function standAttack()
    if states.stand then
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("Stand") then return end
        
        local stand = character.Stand
        local rightArm = stand:FindFirstChild("RightArm")
        local leftArm = stand:FindFirstChild("LeftArm")
        
        -- Rapid punch animation with improved effects
        for i = 1, 10 do
            local arm = i % 2 == 0 and rightArm or leftArm
            if arm then
                -- Create punch trail effect
                local trail = Instance.new("Trail")
                trail.Lifetime = 0.2
                trail.MinLength = 0.1
                trail.MaxLength = 0.2
                trail.Color = ColorSequence.new(THEME.accent)
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                trail.Parent = arm
                
                local a0 = Instance.new("Attachment")
                local a1 = Instance.new("Attachment")
                a0.Position = Vector3.new(0, 1, 0)
                a1.Position = Vector3.new(0, -1, 0)
                a0.Parent = arm
                a1.Parent = arm
                trail.Attachment0 = a0
                trail.Attachment1 = a1
                
                -- Create punch animation
                local punchTween = TweenService:Create(arm, TweenInfo.new(0.1), {
                    CFrame = arm.CFrame * CFrame.new(0, 0, -2)
                })
                punchTween:Play()
                wait(0.05)
                
                -- Reset arm position
                local resetTween = TweenService:Create(arm, TweenInfo.new(0.1), {
                    CFrame = arm.CFrame
                })
                resetTween:Play()
                
                -- Check for hits with improved visual feedback
                local rayOrigin = arm.Position
                local rayDirection = arm.CFrame.LookVector * 4
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {character}
                
                local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                if raycastResult and raycastResult.Instance then
                    local hitPlayer = Players:GetPlayerFromCharacter(raycastResult.Instance.Parent)
                    if hitPlayer then
                        local humanoid = hitPlayer.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            -- Apply damage with visual effect
                            humanoid.Health = humanoid.Health - STAND_DAMAGE
                            
                            -- Create hit effect
                            local hitEffect = Instance.new("Part")
                            hitEffect.Size = Vector3.new(0.5, 0.5, 0.5)
                            hitEffect.CFrame = CFrame.new(raycastResult.Position)
                            hitEffect.Anchored = true
                            hitEffect.CanCollide = false
                            hitEffect.BrickColor = BrickColor.new("Really red")
                            hitEffect.Material = Enum.Material.Neon
                            hitEffect.Shape = Enum.PartType.Ball
                            hitEffect.Parent = workspace
                            
                            TweenService:Create(hitEffect, TweenInfo.new(0.2), {
                                Size = Vector3.new(2, 2, 2),
                                Transparency = 1
                            }):Play()
                            
                            game:GetService("Debris"):AddItem(hitEffect, 0.2)
                        end
                    end
                end
                
                -- Remove trail after punch
                game:GetService("Debris"):AddItem(trail, 0.2)
                game:GetService("Debris"):AddItem(a0, 0.2)
                game:GetService("Debris"):AddItem(a1, 0.2)
            end
            wait(0.1)
        end
    end
end

-- Create buttons with callbacks
local buttonY = 10
local buttons = {
    {name = "ESP", callback = toggleESP},
    {name = "Invisible", callback = toggleInvisible},
    {name = "Speed", callback = toggleSpeed},
    {name = "God Mode", callback = toggleGodMode},
    {name = "No Clip", callback = toggleNoClip},
    {name = "Stand", callback = toggleStand},
    {name = "Teleport Random", callback = teleportToRandomPlayer},
    {name = "Teleport Random to Me", callback = teleportPlayersToMe}
}

for _, buttonInfo in ipairs(buttons) do
    createModernButton(buttonInfo.name, buttonY, buttonInfo.callback)
    buttonY = buttonY + 50
end

-- Add RunService connection for NoClip
RunService.Stepped:Connect(function()
    if states.noClip then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Add Players.PlayerAdded connection for ESP
Players.PlayerAdded:Connect(function(player)
    if states.esp and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            if states.esp then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character
            end
        end)
    end
end)

-- Enhanced key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        menuEnabled = not menuEnabled
        
        if menuEnabled then
            browserFrame.Position = UDim2.new(0.5, -300, 0, -400)
            browserFrame.Visible = true
            
            -- Add fade in effect
            browserFrame.BackgroundTransparency = 1
            for _, child in pairs(browserFrame:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
                    child.BackgroundTransparency = 1
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        child.TextTransparency = 1
                    end
                end
            end
            
            -- Animate position and fade
            TweenService:Create(browserFrame, tweenInfo, {
                Position = UDim2.new(0.5, -300, 0.5, -200),
                BackgroundTransparency = 0
            }):Play()
            
            -- Fade in all elements
            for _, child in pairs(browserFrame:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(child, tweenInfo, {
                        BackgroundTransparency = child.Name == "shadow" and 0.7 or 0
                    }):Play()
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        TweenService:Create(child, tweenInfo, {
                            TextTransparency = 0
                        }):Play()
                    end
                end
            end
        else
            -- Fade out animation
            local disappearTween = TweenService:Create(browserFrame, tweenInfo, {
                Position = UDim2.new(0.5, -300, 1, 100),
                BackgroundTransparency = 1
            })
            disappearTween:Play()
            
            -- Fade out all elements
            for _, child in pairs(browserFrame:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(child, tweenInfo, {
                        BackgroundTransparency = 1
                    }):Play()
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        TweenService:Create(child, tweenInfo, {
                            TextTransparency = 1
                        }):Play()
                    end
                end
            end
            
            disappearTween.Completed:Connect(function()
                browserFrame.Visible = false
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.U then
        teleportToMouse()
    elseif input.KeyCode == Enum.KeyCode.G and states.stand then
        standAttack()
    end
end)

print("Opera GX Style Menu Loaded - Press P to toggle")
