-- GUI ICON
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.16, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Draggable = true
ImageButton.Image = "rbxassetid://83190276951914"

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ImageButton

ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)

-- LOAD UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
repeat task.wait() until game:IsLoaded()

local Window = Fluent:CreateWindow({
    Title = "Kaybitrum Hub",
    SubTitle = "Blox Fruits | Full OP",
    TabWidth = 160,
    Size = UDim2.fromOffset(470, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

-- TABS
local Tabs = {
    Main0 = Window:AddTab({ Title = "Thông Tin" }),
    Main1 = Window:AddTab({ Title = "Auto Farm" }),
}

-- INFO
Tabs.Main0:AddButton({
    Title = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/tboyroblox-community-1253927333920899153")
    end
})

-- SETTINGS
getgenv().Farm = false
getgenv().BringMob = false

Tabs.Main1:AddToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(v)
        getgenv().Farm = v
    end
})

Tabs.Main1:AddToggle({
    Title = "Gom Quái (Bring Mob)",
    Default = false,
    Callback = function(v)
        getgenv().BringMob = v
    end
})

-- MAIN LOOP
spawn(function()
    while task.wait(0.15) do
        pcall(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    
                    -- GOM QUÁI
                    if getgenv().BringMob then
                        v.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
                        v.HumanoidRootPart.CanCollide = false
                    end

                    -- AUTO FARM
                    if getgenv().Farm then
                        hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,15,0)

                        -- HITBOX TO (100)
                        v.HumanoidRootPart.Size = Vector3.new(100,100,100)
                        v.HumanoidRootPart.Transparency = 0.8
                        v.HumanoidRootPart.CanCollide = false

                        -- AUTO CLICK
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,0)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,0)
                    end
                end
            end
        end)
    end
end)
