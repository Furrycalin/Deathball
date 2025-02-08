local Gui = Instance.new("ScreenGui") 
Gui.Parent = game.Players.LocalPlayer.PlayerGui
local CoreGui = game:GetService("StarterGui")

local RunService = game:GetService("RunService")

local Text1 = Instance.new("TextLabel")
Text1.Parent = Gui
Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
Text1.Position = UDim2.new(0.529, -40, 0.1, 0) 
Text1.Text = "游戏尚未开始"
Text1.TextSize = 25.000

local Text2 = Instance.new("TextLabel")
Text2.Parent = Gui
Text2.TextColor3 = Color3.fromRGB(166, 166, 166)
Text2.Position = UDim2.new(0.529, -40, 0.14, 0) 
Text2.Text = ""
Text2.TextSize = 15.000

local Text3 = Instance.new("TextLabel")
Text3.Parent = Gui
Text3.TextColor3 = Color3.fromRGB(230, 230, 250)
Text3.Position = UDim2.new(0.949, -40, -0.04, 0) 
Text3.Text = "Auto Parry (OFF)"
Text3.TextSize = 20.000

local RB = Color3.new(1, 0, 0) 
local AutoValue = false

CoreGui:SetCore("SendNotification", { 
    Title = "死亡球辅助已启动", 
    Text = "by Chronix", 
    Duration = 10,   
})

CoreGui:SetCore("SendNotification", { 
    Title = "提示", 
    Text = "按下K启动自动格挡", 
    Duration = 10,   
})

while true do
    wait(0.05)
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.K) then
        if AutoValue then
            AutoValue = false
        else
            AutoValue = true
        end
    end
        local userInputService = game:GetService("UserInputService")
        Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
        Text1.Text = "游戏尚未开始"
        Text2.Text = ""
        local ball = game.Workspace:WaitForChild("Part") 
        local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        if playerPos.Z < -777.55 and playerPos.Y > 279.17 then
            Text1.TextColor3 = Color3.fromRGB(230, 230, 250)
            Text1.Text = "观战中"
            Text2.Text = ""
        else
            if ball.Highlight.FillColor == RB then
                Text1.Text = "已被球锁定"
                Text1.TextColor3 = Color3.fromRGB(238, 17, 17)
            else
                Text1.Text = "未被球锁定"
                Text1.TextColor3 = Color3.fromRGB(17, 238, 17)
            end
            local dx = ball.CFrame.X - playerPos.X
            local dy = ball.CFrame.Y - playerPos.Y
            local dz = ball.CFrame.Z - playerPos.Z
            local distance = math.sqrt(dx^2 + dy^2 + dz^2)
            Text2.Text = string.format("%.0f", distance)
        end
        if AutoValue then
            Text3.Text = "Auto Parry (ON)"
            if ball.Highlight.FillColor == RB then
                if distance < 15 then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                end
            end
        else
            Text3.Text = "Auto Parry (OFF)"
        end
end
