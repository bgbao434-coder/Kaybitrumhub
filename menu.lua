-- KayBiTrum Hub VIP

repeat wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

getgenv().KBT = {
    Farm = false,
    Skill = false,
    Fast = false
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

-- Drag GUI
local dragging, dragInput, startPos, startInput

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startInput = input.Position
        startPos = main.Position
    end
end)

top.InputChanged:Connect(function(input)
    dragInput = input
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - startInput
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
local tabs = {"Farm","Combat","Misc"}
local buttons = {}
local pages = {}

for i,v in pairs(tabs) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.33,0,0,30)
    btn.Position = UDim2.new((i-1)*0.33,0,0,30)
    btn.Text = v
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    buttons[v] = btn

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

-- Create Toggle
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
Toggle(pages["Combat"],"Auto Skill",0,"Skill")
Toggle(pages["Combat"],"Fast Attack",40,"Fast")

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

-- Notify
game.StarterGui:SetCore("SendNotification",{
    Title = "KayBiTrum Hub",
    Text = "VIP Loaded 🚀",
    Duration = 5
})
