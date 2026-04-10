repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

getgenv().Farm = true
getgenv().Height = 40
getgenv().HitboxSize = 100 -- 🔥 MAX HITBOX

--------------------------------------------------
-- AUTO FARM PRO MAX
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

                -- 🧍‍♂️ TREO TRÊN KHÔNG
                hrp.Anchored = true

                -- AUTO EQUIP
                if not char:FindFirstChildOfClass("Tool") then
                    local tool = player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        humanoid:EquipTool(tool)
                    end
                end

                local centerMob = nil

                -- 🔍 tìm 1 con làm trung tâm
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        centerMob = mob
                        break
                    end
                end

                if centerMob then
                    local centerPos = centerMob.HumanoidRootPart.Position

                    -- 🚀 đứng trên đầu mob trung tâm
                    hrp.CFrame = CFrame.new(centerPos + Vector3.new(0, getgenv().Height, 0))

                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            
                            local mobHRP = mob.HumanoidRootPart
                            
                            -- 🧲 GOM MOB VỀ 1 CHỖ
                            mobHRP.CFrame = CFrame.new(centerPos)
                            
                            -- 💥 HITBOX TO 100
                            mobHRP.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                            mobHRP.CanCollide = false
                            mobHRP.Transparency = 0.7
                        end
                    end

                    -- 👊 AUTO ĐÁNH
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))
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
