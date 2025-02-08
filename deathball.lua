-- 死亡球脚本 by Chronix
-- Update in 2025.2.8
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 辅助函数：创建并配置 TextLabel
local function CreateTextLabel(parent, text, textColor3, position, textSize)
    local textLabel = Instance.new("TextLabel", parent)
    textLabel.Text = text
    textLabel.TextColor3 = textColor3 or Color3.new(1, 1, 1) -- 默认白色
    textLabel.Position = position or UDim2.new(0.5, 0, 0.5, 0) -- 默认居中
    textLabel.TextSize = textSize or 14 -- 默认字体大小
    textLabel.BackgroundTransparency = 1 -- 默认背景透明
    return textLabel
end

-- 创建 ScreenGui 并作为 LocalPlayer.PlayerGui 的子对象
local Gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)

-- 使用辅助函数创建 TextLabel 实例
local Text1 = CreateTextLabel(Gui, "游戏未开始", Color3.fromRGB(230, 230, 250), UDim2.new(0.529, -40, 0.1, 0), 25)
local Text2 = CreateTextLabel(Gui, "", Color3.fromRGB(166, 166, 166), UDim2.new(0.529, -40, 0.14, 0), 15)
local Text3 = CreateTextLabel(Gui, "Auto Parry (OFF)", Color3.fromRGB(230, 230, 250), UDim2.new(0.949, -40, -0.04, 0), 20)

local RB = Color3.new(1, 0, 0)
local AutoValue = false

-- 查找球的函数
function FindBall()
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "Part" and child:IsA("BasePart") then -- 假设球是一个BasePart
            return child
        end
    end
    return nil
end

-- 更新 UI 的函数
local function UpdateUI()
    local playerPos = (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame) or CFrame.new()
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

-- 主循环
while true do
    wait(0.05)
    if UserInputService:IsKeyDown(Enum.KeyCode.K) then
        AutoValue = not AutoValue
    end

    UpdateUI()
end
