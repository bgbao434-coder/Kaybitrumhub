-- KayBiTrum Hub VIP (Blox Fruits Full Auto)

repeat wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

getgenv().KBT = {
    Farm = false,
    Skill = false,
    Fast = false,
    Click = false,
    Quest = false
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
local top = Instance.new("TextLabel", main)

main.Size = UDim2.new(0,260,0,200)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)

top.Size = UDim2.new(1,0,0,30)
top.Text = "KayBiTrum Hub"
top.TextColor3 = Color3.new(1,1,1)
top.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- Drag
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

top.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
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

-- Tabs
local tabs = {"Farm","Combat"}
local pages = {}

for i,v in pairs(tabs) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.5,0,0,30)
    btn.Position = UDim2.new((i-1)*0.5,0,0,30)
    btn.Text = v
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)

    local page = Instance.new("Frame", main)
    page.Size = UDim2.new(1,0,1,-60)
    page.Position = UDim2.new(0,0,0,60)
    page.Visible = false
    page.BackgroundTransparency = 1
    pages[v] = page

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

pages["Farm"].Visible = true

-- Toggle
function Toggle(parent, text, posY, key)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,35)
    btn.Position = UDim2.new(0,0,0,posY)
    btn.Text = text.." : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        getgenv().KBT[key] = not getgenv().KBT[key]
        btn.Text = text.." : "..(getgenv().KBT[key] and "ON" or "OFF")
    end)
end

Toggle(pages["Farm"],"Auto Farm",0,"Farm")
Toggle(pages["Farm"],"Auto Quest",40,"Quest")
Toggle(pages["Combat"],"Fast Attack",0,"Fast")
Toggle(pages["Combat"],"Auto Skill",40,"Skill")
Toggle(pages["Combat"],"Auto Click",80,"Click")

-- QUEST DATA
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

function GetMob()
    local quest = GetQuest()
    if not quest then return end

    for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") 
        and v.Humanoid.Health > 0 
        and string.find(v.Name, quest.Name) then
            return v
        end
    end
end

-- Auto Quest
spawn(function()
    while wait(1) do
        if getgenv().KBT.Quest then
            pcall(function()
                local quest = GetQuest()
                if quest then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                        "StartQuest",
                        quest.QuestName,
                        quest.QuestLv
                    )
                end
            end)
        end
    end
end)

-- Auto Farm (bay trên đầu)
spawn(function()
    while wait() do
        if getgenv().KBT.Farm then
            pcall(function()
                local mob = GetMob()
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    repeat task.wait()
                        player.Character.HumanoidRootPart.CFrame =
                            CFrame.new(
                                mob.HumanoidRootPart.Position + Vector3.new(0,10,0),
                                mob.HumanoidRootPart.Position
                            )
                    until not mob or mob.Humanoid.Health <= 0
                end
            end)
        end
    end
end)

-- Anti Fall
spawn(function()
    while wait() do
        if getgenv().KBT.Farm then
            pcall(function()
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(0,0,0)
                end
            end)
        end
    end
end)

-- Fast Attack
spawn(function()
    while wait(0.1) do
        if getgenv().KBT.Fast then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer("Attack")
            end)
        end
    end
end)

-- No Animation
spawn(function()
    while wait() do
        if getgenv().KBT.Fast then
            pcall(function()
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _,track in pairs(hum:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end
            end)
        end
    end
end)

-- Auto Click
spawn(function()
    while wait() do
        if getgenv().KBT.Click then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(0,0,0,true,game,0)
                wait(0.1)
                vim:SendMouseButtonEvent(0,0,0,false,game,0)
            end)
        end
    end
end)

-- Auto Skill
spawn(function()
    while wait() do
        if getgenv().KBT.Skill then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                for _,k in pairs({"Z","X","C","V"}) do
                    vim:SendKeyEvent(true,k,false,game)
                    wait(0.5)
                end
            end)
        end
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
