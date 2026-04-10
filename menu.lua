-- KAYBITRUM FULL FARM (TWEEN + BRING + ATTACK)

repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

getgenv().Farm = true

-- CHECK QUEST
function HasQuest()
    return player.PlayerGui:FindFirstChild("Main")
    and player.PlayerGui.Main:FindFirstChild("Quest")
    and player.PlayerGui.Main.Quest.Visible
end

-- TWEEN
function TweenTo(pos)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - pos).Magnitude
    local speed = 250

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )
    tween:Play()
end

-- CHỌN MOB
function GetMob()
    local level = player.Data.Level.Value

    if level < 10 then
        return "BanditQuest1", 1, "Bandit"
    elseif level < 30 then
        return "JungleQuest", 1, "Monkey"
    elseif level < 60 then
        return "BuggyQuest1", 1, "Pirate"
    elseif level < 100 then
        return "DesertQuest", 1, "Desert Bandit"
    elseif level < 200 then
        return "SnowQuest", 1, "Snow Bandit"
    elseif level < 300 then
        return "MarineQuest2", 1, "Chief Petty Officer"
    elseif level < 700 then
        return "MarineQuest3", 1, "Marine"
    end
end

-- AUTO FARM
spawn(function()
    while task.wait(0.15) do
        if getgenv().Farm then
            pcall(function()

                local char = player.Character
                if not char then return end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end

                local quest, questLv, mobName = GetMob()
                if not mobName then return end

                -- AUTO EQUIP
                local tool = char:FindFirstChildOfClass("Tool")
                if not tool then
                    for _,v in pairs(player.Backpack:GetChildren()) do
                        if v:IsA("Tool") then
                            hum:EquipTool(v)
                            break
                        end
                    end
                    return
                end

                -- NHẬN QUEST
                if not HasQuest() then
                    rs.Remotes.CommF_:InvokeServer("StartQuest", quest, questLv)
                    task.wait(1)
                end

                -- TÌM MOB GẦN
                local target, dist = nil, math.huge
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

                if target then
                    local mobhrp = target.HumanoidRootPart

                    -- BRING MOB
                    for _,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == mobName
                        and v:FindFirstChild("HumanoidRootPart")
                        and v.Humanoid.Health > 0 then

                            v.HumanoidRootPart.CFrame = mobhrp.CFrame
                            v.HumanoidRootPart.CanCollide = false
                            v.Humanoid:ChangeState(11)
                        end
                    end

                    -- DI CHUYỂN + BÁM ĐẦU
                    if (hrp.Position - mobhrp.Position).Magnitude > 10 then
                        TweenTo((mobhrp.CFrame * CFrame.new(0,6,0)).Position)
                    else
                        hrp.CFrame = mobhrp.CFrame * CFrame.new(0,6,0)
                        hrp.Velocity = Vector3.new(0,0,0)

                        -- ĐÁNH
                        tool:Activate()
                    end
                end

            end)
        end
    end
end)

-- AUTO HAKI
spawn(function()
    while task.wait(5) do
        if getgenv().Farm then
            pcall(function()
                if player.Character and not player.Character:FindFirstChild("HasBuso") then
                    rs.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- AUTO SEA 2
spawn(function()
    while task.wait(10) do
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
