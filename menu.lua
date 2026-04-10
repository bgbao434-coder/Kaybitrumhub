repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

getgenv().Farm = true

-- TWEEN
function TweenTo(pos)
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new((hrp.Position - pos).Magnitude / 200, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )
    tween:Play()
end

-- AUTO FARM
spawn(function()
    while task.wait(0.2) do
        if getgenv().Farm then
            pcall(function()
                local char = player.Character
                if not char then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local mob = workspace.Enemies:FindFirstChild("Bandit")
                if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                    
                    -- BAY CAO 40
                    local pos = mob.HumanoidRootPart.Position + Vector3.new(0, 40, 0)
                    TweenTo(pos)

                    -- BRING MOB
                    mob.HumanoidRootPart.CanCollide = false
                    mob.HumanoidRootPart.Size = Vector3.new(50,50,50)

                    -- AUTO ĐÁNH
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))

                    -- AUTO SKILL
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                end
            end)
        end
    end
end)

-- AUTO QUEST (Bandit)
spawn(function()
    while task.wait(1) do
        if getgenv().Farm then
            pcall(function()
                local quest = workspace:FindFirstChild("Quest")
                if quest then
                    -- tuỳ map nên bạn chỉnh lại nếu cần
                end
            end)
        end
    end
end)

--------------------------------------------------
-- MENU XANH ĐEN
--------------------------------------------------

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,120)
Frame.Position = UDim2.new(0,20,0.4,0)
Frame.BackgroundColor3 = Color3.fromRGB(10,10,20)

local UICorner = Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "KAY FARM"
Title.TextColor3 = Color3.fromRGB(0,255,150)
Title.BackgroundTransparency = 1

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.8,0,0,40)
Button.Position = UDim2.new(0.1,0,0.4,0)
Button.Text = "Farm: ON"
Button.BackgroundColor3 = Color3.fromRGB(0,100,100)
Button.TextColor3 = Color3.new(1,1,1)

Button.MouseButton1Click:Connect(function()
    getgenv().Farm = not getgenv().Farm
    
    if getgenv().Farm then
        Button.Text = "Farm: ON"
    else
        Button.Text = "Farm: OFF"
    end
end)

-- DRAG MENU
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
