repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

getgenv().Farm = true
getgenv().Height = 40
getgenv().HitboxSize = 100

spawn(function()
    while task.wait(0.1) do
        if getgenv().Farm then
            pcall(function()
                local char = player.Character
                if not char then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                if not hrp or not humanoid then return end

                -- TREO TRÊN KHÔNG
                hrp.Anchored = true

                -- AUTO HAKI
                if not char:FindFirstChild("HasBuso") then
                    VIM:SendKeyEvent(true, "J", false, game)
                    task.wait(0.1)
                    VIM:SendKeyEvent(false, "J", false, game)
                end

                -- AUTO EQUIP
                if not char:FindFirstChildOfClass("Tool") then
                    local tool = player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        humanoid:EquipTool(tool)
                    end
                end

                local centerMob = nil

                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        centerMob = mob
                        break
                    end
                end

                if centerMob then
                    local centerPos = centerMob.HumanoidRootPart.Position

                    -- ĐỨNG TRÊN ĐẦU
                    hrp.CFrame = CFrame.new(centerPos + Vector3.new(0, getgenv().Height, 0))

                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            
                            local mobHRP = mob.HumanoidRootPart
                            
                            -- GOM MOB
                            mobHRP.CFrame = CFrame.new(centerPos)

                            -- HITBOX 100
                            mobHRP.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                            mobHRP.CanCollide = false
                        end
                    end

                    -- AUTO HIT
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end)
        else
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Anchored = false
            end
        end
    end
end)
