local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer.PlayerGui

local Text1 = Instance.new("TextLabel", Gui)
Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
Text1.Position = UDim2.new(0.529, -40, 0.1, 0)
Text1.TextSize = 25

local Text2 = Instance.new("TextLabel", Gui)
Text2.TextColor3 = Color3.fromRGB(166, 166, 166)
Text2.Position = UDim2.new(0.529, -40, 0.14, 0)
Text2.TextSize = 15

local Text3 = Instance.new("TextLabel", Gui)
Text3.TextColor3 = Color3.fromRGB(230, 230, 250)
Text3.Position = UDim2.new(0.949, -40, -0.04, 0)
Text3.TextSize = 20
Text3.Text = "Auto Parry (OFF)"

local RB = Color3.new(1, 0, 0)
local AutoValue = false

function FindBall()
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "Part" and child:IsA("BasePart") then -- 假设球是一个BasePart
            return child
        end
    end
    return nil
end

local function UpdateUI()
    local playerPos = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame or CFrame.new()
    local ball = FindBall()

    if not ball then
        Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
        Text1.Text = "游戏未开始"
        Text2.Text = ""
        return
    end

    local isSpectating = playerPos.Z < -777.55 and playerPos.Y > 279.17
    if isSpectating then
        Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
        Text1.Text = "观战中"
        Text2.Text = ""
    else
        local isLocked = ball.Highlight and ball.Highlight.FillColor == RB
        Text1.Text = isLocked and "已被球锁定" or "未被球锁定"
        Text1.TextColor3 = isLocked and Color3.fromRGB(238, 17, 17) or Color3.fromRGB(17, 238, 17)

        local dx, dy, dz = ball.CFrame.X - playerPos.X, ball.CFrame.Y - playerPos.Y, ball.CFrame.Z - playerPos.Z
        local distance = math.sqrt(dx^2 + dy^2 + dz^2)
        Text2.Text = string.format("%.0f", distance)

        if AutoValue then
            Text3.Text = "Auto Parry (ON)"
            if isLocked and distance < 15 then
                VirtualInputManager:SendKeyEvent(true, "F", false, game)
            end
        else
            Text3.Text = "Auto Parry (OFF)"
        end
    end
end

while true do
    wait(0.05)
    if UserInputService:IsKeyDown(Enum.KeyCode.K) then
        AutoValue = not AutoValue
    end

    UpdateUI()
end
