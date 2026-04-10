-- KayBiTrum Hub FINAL (No Skill)

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

getgenv().KBT = {
    Farm = false,
    Fast = false
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,250,0,150)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "KayBiTrum Hub FINAL"
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.new(1,1,1)

-- Toggle
function Toggle(name,y,key)
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
Toggle("Fast Attack",80,"Fast")

-- Quest list
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

-- Auto Farm
spawn(function()
    while task.wait() do
        if getgenv().KBT.Farm then
            pcall(function()

                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local quest = GetQuest()
                if not quest then return end

                -- nhận quest
                if not player.PlayerGui:FindFirstChild("Quest") then
                    rs.Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestLv)
                    task.wait(1)
                end

                -- tìm mob
                local mob
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name:find(quest.Name)
                    and v:FindFirstChild("Humanoid")
                    and v.Humanoid.Health > 0 then
                        mob = v
                        break
                    end
                end

                -- đứng gần mob
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame =
                        mob.HumanoidRootPart.CFrame * CFrame.new(0,3,2)
                end

            end)
        end
    end
end)

-- FAST ATTACK (KHÔNG CLICK THẬT)
spawn(function()
    while task.wait(0.05) do
        if getgenv().KBT.Fast then
            pcall(function()
                local CF = require(player.PlayerScripts.CombatFramework)
                local AC = CF.activeController

                if AC and AC.equipped then
                    AC.hitboxMagnitude = 60
                    AC.timeToNextAttack = 0
                    AC:attack()
                end
            end)
        end
    end
end)

-- Auto Haki (fix)
spawn(function()
    while task.wait(2) do
        if getgenv().KBT.Farm then
            pcall(function()
                local char = player.Character
                if char and not char:FindFirstChild("HasBuso") then
                    rs.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- Hitbox
spawn(function()
    while task.wait() do
        if getgenv().KBT.Fast then
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") then
                    v.HumanoidRootPart.Size = Vector3.new(10,10,10)
                    v.HumanoidRootPart.CanCollide = false
                end
            end
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
