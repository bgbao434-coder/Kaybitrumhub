-- KAYBITRUM FULL FARM GUI (FIX ALL)

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

getgenv().Farm = false

-- GUI XANH ĐEN
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,120)
Frame.Position = UDim2.new(0,20,0.5,-60)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "KAYBITRUM FARM"
Title.TextColor3 = Color3.fromRGB(0,255,150)
Title.BackgroundTransparency = 1

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1,-20,0,40)
Button.Position = UDim2.new(0,10,0,50)
Button.Text = "OFF"
Button.BackgroundColor3 = Color3.fromRGB(0,100,80)
Button.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", Button)

Button.MouseButton1Click:Connect(function()
    getgenv().Farm = not getgenv().Farm
    Button.Text = getgenv().Farm and "ON" or "OFF"
end)

-- TWEEN
function TweenTo(pos)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - pos).Magnitude
    local tween = TweenService:Create(hrp,
        TweenInfo.new(dist/250, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )
    tween:Play()
end

-- AUTO FARM
spawn(function()
    while task.wait(0.15) do
        if getgenv().Farm then
            pcall(function()

                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end

                -- equip
                local tool = char:FindFirstChildOfClass("Tool")
                if not tool then
                    for _,v in pairs(player.Backpack:GetChildren()) do
                        if v:IsA("Tool") then
                            hum:EquipTool(v)
                            return
                        end
                    end
                end

                -- tìm mob gần
                local target,dist=nil,math.huge
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") 
                    and v:FindFirstChild("HumanoidRootPart")
                    and v.Humanoid.Health > 0 then

                        local m=(hrp.Position-v.HumanoidRootPart.Position).Magnitude
                        if m<dist then
                            dist=m
                            target=v
                        end
                    end
                end

                if target then
                    local mobhrp = target.HumanoidRootPart

                    -- 🔥 BAY CAO HƠN (FIX CHÍNH)
                    local offset = CFrame.new(0,10,0)

                    -- tween nếu xa
                    if dist > 12 then
                        TweenTo((mobhrp.CFrame * offset).Position)
                    else
                        -- bám đầu
                        hrp.CFrame = mobhrp.CFrame * offset
                        hrp.Velocity = Vector3.new(0,0,0)

                        -- fix mob
                        mobhrp.CanCollide = false

                        -- spam đánh mạnh hơn
                        if tool then
                            tool:Activate()
                            tool:Activate()
                        end
                    end
                end

            end)
        end
    end
end)

-- AUTO HAKI
spawn(function()
    while task.wait(5) do
        if getgenv().Farm then
            pcall(function()
                if player.Character and not player.Character:FindFirstChild("HasBuso") then
                    rs.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- ANTI AFK
spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)
