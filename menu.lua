-- KayBiTrum Hub VIP

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
top.Text = "   KayBiTrum Hub"
top.TextColor3 = Color3.new(1,1,1)
top.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- 🖼️ ICON
local icon = Instance.new("ImageLabel", top)
icon.Size = UDim2.new(0,25,0,25)
icon.Position = UDim2.new(0,2,0,2)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://7733960981" -- bạn có thể đổi ID khác

-- ❌ Close button
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,1,0)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150,0,0)
close.TextColor3 = Color3.new(1,1,1)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 🔥 Drag (mobile + PC)
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Tabs
local tabs = {"Farm","Combat","Misc"}
local pages = {}

for i,v in pairs(tabs) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.33,0,0,30)
    btn.Position = UDim2.new((i-1)*0.33,0,0,30)
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

-- Toggles
Toggle(pages["Farm"],"Auto Farm",0,"Farm")
Toggle(pages["Farm"],"Auto Quest",40,"Quest")
Toggle(pages["Combat"],"Auto Skill",0,"Skill")
Toggle(pages["Combat"],"Fast Attack",40,"Fast")
Toggle(pages["Combat"],"Auto Click",80,"Click")

-- Anti AFK
spawn(function()
    local vu = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

-- Random delay
function rd(a,b)
    return math.random(a,b)/10
end

-- Get Mob
function GetMob()
    for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
end

-- Auto Farm
spawn(function()
    while wait() do
        if getgenv().KBT.Farm then
            pcall(function()
                local mob = GetMob()
                if mob then
                    repeat wait(rd(1,3))
                        player.Character.HumanoidRootPart.CFrame =
                            mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                    until not mob or mob.Humanoid.Health <= 0
                end
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
                    wait(rd(2,5))
                end
            end)
        end
    end
end)

-- Fast Attack
spawn(function()
    while wait() do
        if getgenv().KBT.Fast then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Combat:FireServer()
                wait(0.25)
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

-- Auto Quest
spawn(function()
    while wait(2) do
        if getgenv().KBT.Quest then
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if remote and remote:FindFirstChild("Quest") then
                    remote.Quest:FireServer("Start")
                end
            end)
        end
    end
end)

-- Notify
game.StarterGui:SetCore("SendNotification",{
    Title = "KayBiTrum Hub",
    Text = "VIP Loaded 🚀",
    Duration = 5

})
