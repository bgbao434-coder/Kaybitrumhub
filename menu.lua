-- KayBiTrum Hub Mini (Blox Fruits)

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

getgenv().KBT = {
    Farm = false,
    Fast = false,
    Skill = false,
    Click = false
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,250,0,200)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "KayBiTrum Hub"
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.new(1,1,1)

-- Toggle function
function Toggle(name, y, key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,0,0,30)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = name.." : OFF"
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)

    b.MouseButton1Click:Connect(function()
        getgenv().KBT[key] = not getgenv().KBT[key]
        b.Text = name.." : "..(getgenv().KBT[key] and "ON" or "OFF")
    end)
end

Toggle("Auto Farm",40,"Farm")
Toggle("Fast Attack",70,"Fast")
Toggle("Auto Skill",100,"Skill")
Toggle("Auto Click",130,"Click")

-- QUEST LIST (MAP 1)
local QuestList = {
    {Level = 1, Name = "Bandit", QuestName = "BanditQuest1", QuestLv = 1},
    {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestLv = 1},
    {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestLv = 2},
    {Level = 30, Name = "Pirate", QuestName = "BuggyQuest1", QuestLv = 1},
    {Level = 40, Name = "Brute", QuestName = "BuggyQuest1", QuestLv = 2},
}

function GetQuest()
    local level = player.Data.Level.Value
    for i = #QuestList,1,-1 do
        if level >= QuestList[i].Level then
            return QuestList[i]
        end
    end
end

-- MAIN AUTO FARM (gộp quest + farm)
spawn(function()
    while task.wait() do
        if getgenv().KBT.Farm then
            pcall(function()

                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

                local quest = GetQuest()
                if not quest then return end

                -- Nhận quest
                if not player.PlayerGui:FindFirstChild("Quest") then
                    rs.Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestLv)
                    task.wait(1)
                end

                -- Tìm mob
                local mob
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _,v in pairs(enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid")
                        and v.Humanoid.Health > 0
                        and string.find(v.Name, quest.Name) then
                            mob = v
                            break
                        end
                    end
                end

                -- Bay trên đầu + đánh
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame =
                        CFrame.new(
                            mob.HumanoidRootPart.Position + Vector3.new(0,10,0),
                            mob.HumanoidRootPart.Position
                        )
                end

            end)
        end
    end
end)

-- Fast Attack
spawn(function()
    while task.wait(0.1) do
        if getgenv().KBT.Fast then
            pcall(function()
                rs.Remotes.Combat:FireServer("Attack")
            end)
        end
    end
end)

-- No Animation
spawn(function()
    while task.wait() do
        if getgenv().KBT.Fast then
            pcall(function()
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _,v in pairs(hum:GetPlayingAnimationTracks()) do
                        v:Stop()
                    end
                end
            end)
        end
    end
end)

-- Hitbox
spawn(function()
    while task.wait() do
        if getgenv().KBT.Fast then
            pcall(function()
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.Size = Vector3.new(12,12,12)
                        v.HumanoidRootPart.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- Auto Skill
spawn(function()
    while task.wait() do
        if getgenv().KBT.Skill then
            local vim = game:GetService("VirtualInputManager")
            for _,k in pairs({"Z","X","C","V"}) do
                vim:SendKeyEvent(true,k,false,game)
                task.wait(0.5)
            end
        end
    end
end)

-- Auto Click
spawn(function()
    while task.wait() do
        if getgenv().KBT.Click then
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(0.1)
            vim:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
end)

-- Auto Haki
spawn(function()
    while task.wait(1) do
        if getgenv().KBT.Farm then
            pcall(function()
                rs.Remotes.CommF_:InvokeServer("Buso")
            end)
        end
    end
end)

-- Speed
spawn(function()
    while task.wait() do
        pcall(function()
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 80
            end
        end)
    end
end)

-- Anti AFK
spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)
