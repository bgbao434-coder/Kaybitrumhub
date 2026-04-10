-- KAYBITRUM FARM SEA 2 STABLE

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

getgenv().Farm = true

-- AUTO FARM + QUEST
spawn(function()
    while task.wait(0.2) do
        if getgenv().Farm then
            pcall(function()

                local char = player.Character
                if not char then return end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end

                local level = player.Data.Level.Value

                -- AUTO EQUIP
                if not char:FindFirstChildOfClass("Tool") then
                    for _,v in pairs(player.Backpack:GetChildren()) do
                        if v:IsA("Tool") then
                            hum:EquipTool(v)
                            break
                        end
                    end
                end

                -- CHỌN QUEST
                local quest, questLv, mobName

                if level < 10 then
                    quest, questLv, mobName = "BanditQuest1", 1, "Bandit"
                elseif level < 30 then
                    quest, questLv, mobName = "JungleQuest", 1, "Monkey"
                elseif level < 60 then
                    quest, questLv, mobName = "BuggyQuest1", 1, "Pirate"
                elseif level < 100 then
                    quest, questLv, mobName = "DesertQuest", 1, "Desert Bandit"
                elseif level < 200 then
                    quest, questLv, mobName = "SnowQuest", 1, "Snow Bandit"
                elseif level < 300 then
                    quest, questLv, mobName = "MarineQuest2", 1, "Chief Petty Officer"
                elseif level < 700 then
                    quest, questLv, mobName = "MarineQuest3", 1, "Marine"
                end

                -- AUTO NHẬN QUEST (FIX)
                pcall(function()
                    rs.Remotes.CommF_:InvokeServer("StartQuest", quest, questLv)
                end)

                -- TÌM MOB GẦN NHẤT ĐÚNG LOẠI
                local target = nil
                local dist = math.huge

                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == mobName
                    and v:FindFirstChild("Humanoid")
                    and v:FindFirstChild("HumanoidRootPart")
                    and v.Humanoid.Health > 0 then

                        local mag = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                        if mag < dist then
                            dist = mag
                            target = v
                        end
                    end
                end

                -- BAY + ĐÁNH
                if target then
                    local mobhrp = target.HumanoidRootPart

                    hrp.CFrame = mobhrp.CFrame * CFrame.new(0,4,2)
                    hrp.Velocity = Vector3.new(0,0,0)

                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end

            end)
        end
    end
end)

-- AUTO HAKI (KHÔNG BỊ BẬT TẮT)
spawn(function()
    while task.wait(3) do
        if getgenv().Farm then
            pcall(function()
                if not player.Character:FindFirstChild("HasBuso") then
                    rs.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- AUTO QUA SEA 2
spawn(function()
    while task.wait(5) do
        pcall(function()
            if player.Data.Level.Value >= 700 then
                rs.Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Dressrosa")
                rs.Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
        end)
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
