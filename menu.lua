-- KAYBITRUM HUB VIP FULL

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

getgenv().KBT = {
    Farm = false,
    ESP_Fruit = false,
    ESP_Island = false
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,270,0,230)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "KayBiTrum Hub VIP"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title)

-- MINIMIZE
local mini = Instance.new("TextButton", title)
mini.Size = UDim2.new(0,30,1,0)
mini.Position = UDim2.new(1,-30,0,0)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(80,80,80)

local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(main:GetChildren()) do
        if v:IsA("TextButton") then
            v.Visible = not minimized
        end
    end
end)

-- DRAG
local dragging, dragInput, startPos, startFramePos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startPos = input.Position
        startFramePos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - startPos
        main.Position = UDim2.new(
            startFramePos.X.Scale,
            startFramePos.X.Offset + delta.X,
            startFramePos.Y.Scale,
            startFramePos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- TOGGLE
function Toggle(name,y,key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,0,0,30)
    b.Position = UDim2.new(0,0,0,y)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)

    local function update()
        if getgenv().KBT[key] then
            b.Text = name.." : ON"
            b.BackgroundColor3 = Color3.fromRGB(0,170,0)
        else
            b.Text = name.." : OFF"
            b.BackgroundColor3 = Color3.fromRGB(170,0,0)
        end
    end

    update()

    b.MouseButton1Click:Connect(function()
        getgenv().KBT[key] = not getgenv().KBT[key]
        update()
    end)
end

Toggle("Auto Farm",40,"Farm")
Toggle("ESP Fruit",80,"ESP_Fruit")
Toggle("ESP Island",120,"ESP_Island")

-- AUTO FARM + QUEST + ĐÁNH
spawn(function()
    while task.wait(0.1) do
        if getgenv().KBT.Farm then
            pcall(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                -- auto quest
                rs.Remotes.CommF_:InvokeServer("StartQuest","BanditQuest1",1)

                -- mob
                local mob
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        mob = v break
                    end
                end

                if mob then
                    hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,5,2)

                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end)
        end
    end
end)

-- AUTO HAKI
spawn(function()
    while task.wait(2) do
        if getgenv().KBT.Farm then
            pcall(function()
                if not player.Character:FindFirstChild("HasBuso") then
                    rs.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- ESP FRUIT + NOTIFY
spawn(function()
    while task.wait(2) do
        if getgenv().KBT.ESP_Fruit then
            for _,v in pairs(workspace:GetChildren()) do
                if string.find(v.Name:lower(),"fruit") and v:IsA("Tool") then

                    if not v:FindFirstChild("ESP") then
                        game.StarterGui:SetCore("SendNotification",{
                            Title="Fruit Spawn!",
                            Text=v.Name,
                            Duration=5
                        })

                        local bill = Instance.new("BillboardGui", v)
                        bill.Name = "ESP"
                        bill.Size = UDim2.new(0,120,0,40)
                        bill.AlwaysOnTop = true

                        local txt = Instance.new("TextLabel", bill)
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.Text = "🍎 "..v.Name
                        txt.TextColor3 = Color3.new(1,1,0)
                        txt.TextScaled = true
                    end
                end
            end
        end
    end
end)

-- TELEPORT FRUIT
spawn(function()
    while task.wait(5) do
        if getgenv().KBT.ESP_Fruit then
            for _,v in pairs(workspace:GetChildren()) do
                if string.find(v.Name:lower(),"fruit") then
                    player.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                end
            end
        end
    end
end)

-- ESP ISLAND
local Islands = {
    ["Jungle"] = Vector3.new(-1600,15,150),
    ["Desert"] = Vector3.new(900,15,4300)
}

spawn(function()
    while task.wait(5) do
        if getgenv().KBT.ESP_Island then
            for name,pos in pairs(Islands) do
                if not workspace:FindFirstChild("ESP_"..name) then
                    local part = Instance.new("Part", workspace)
                    part.Name = "ESP_"..name
                    part.Anchored = true
                    part.Transparency = 1
                    part.Position = pos

                    local bill = Instance.new("BillboardGui", part)
                    bill.Size = UDim2.new(0,150,0,40)
                    bill.AlwaysOnTop = true

                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "🏝️ "..name
                    txt.TextColor3 = Color3.new(0,0.7,1)
                    txt.TextScaled = true
                end
            end
        end
    end
end)
