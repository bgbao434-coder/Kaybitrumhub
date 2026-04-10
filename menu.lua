repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- SETTINGS
getgenv().Farm = false
getgenv().Height = 35 -- chỉnh độ cao (30-40 là đẹp)

--------------------------------------------------
-- AUTO FARM (ỔN ĐỊNH)
--------------------------------------------------
spawn(function()
    while task.wait(0.1) do
        if getgenv().Farm then
            pcall(function()
                local char = player.Character
                if not char then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                if not hrp or not humanoid then return end

                -- AUTO EQUIP TOOL
                if not char:FindFirstChildOfClass("Tool") then
                    local tool = player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        humanoid:EquipTool(tool)
                    end
                end

                -- TÌM MOB GẦN NHẤT
                local target = nil
                local dist = math.huge
                
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then
                            dist = d
                            target = v
                        end
                    end
                end

                if target then
                    local mobHRP = target.HumanoidRootPart

                    -- ĐỨNG IM TRÊN ĐẦU
                    hrp.CFrame = mobHRP.CFrame * CFrame.new(0, getgenv().Height, 0)
                    
                    -- KHÔNG RƠI
                    hrp.Velocity = Vector3.new(0,0,0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)

                    -- GIỮ MOB
                    mobHRP.CanCollide = false
                    mobHRP.Size = Vector3.new(60,60,60)

                    -- AUTO ĐÁNH
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))
                end
            end)
        end
    end
end)

--------------------------------------------------
-- MENU XỊN (XANH ĐEN)
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,220,0,160)
Frame.Position = UDim2.new(0,20,0.4,0)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,25)

Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "KAY PRO FARM"
Title.TextColor3 = Color3.fromRGB(0,255,180)
Title.BackgroundTransparency = 1

-- BUTTON FARM
local FarmBtn = Instance.new("TextButton", Frame)
FarmBtn.Size = UDim2.new(0.8,0,0,40)
FarmBtn.Position = UDim2.new(0.1,0,0.3,0)
FarmBtn.Text = "Farm: OFF"
FarmBtn.BackgroundColor3 = Color3.fromRGB(0,120,120)
FarmBtn.TextColor3 = Color3.new(1,1,1)

FarmBtn.MouseButton1Click:Connect(function()
    getgenv().Farm = not getgenv().Farm
    FarmBtn.Text = getgenv().Farm and "Farm: ON" or "Farm: OFF"
end)

-- HEIGHT BUTTON
local HeightBtn = Instance.new("TextButton", Frame)
HeightBtn.Size = UDim2.new(0.8,0,0,40)
HeightBtn.Position = UDim2.new(0.1,0,0.65,0)
HeightBtn.Text = "Height: "..getgenv().Height
HeightBtn.BackgroundColor3 = Color3.fromRGB(0,80,120)
HeightBtn.TextColor3 = Color3.new(1,1,1)

HeightBtn.MouseButton1Click:Connect(function()
    if getgenv().Height == 35 then
        getgenv().Height = 40
    elseif getgenv().Height == 40 then
        getgenv().Height = 30
    else
        getgenv().Height = 35
    end
    HeightBtn.Text = "Height: "..getgenv().Height
end)

--------------------------------------------------
-- DRAG MENU
--------------------------------------------------
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
