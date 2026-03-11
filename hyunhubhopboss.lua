repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local place = game.PlaceId

local running = false
local history = {}

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HyunHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,420,0,260)
main.Position = UDim2.new(0.5,-210,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "HYUN HUB - Boss Hunter"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local start = Instance.new("TextButton", main)
start.Size = UDim2.new(0.8,0,0,40)
start.Position = UDim2.new(0.1,0,0.35,0)
start.Text = "Start Boss Finder"
start.BackgroundColor3 = Color3.fromRGB(50,50,50)
start.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",start)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.new(0,0,0.65,0)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.TextScaled = true
status.TextColor3 = Color3.new(1,1,1)

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,120,0,35)
toggle.Position = UDim2.new(0,10,0.5,0)
toggle.Text = "Toggle UI"

toggle.MouseButton1Click:Connect(function()
main.Visible = not main.Visible
end)

-- Boss detect
local function findBoss()

if workspace:FindFirstChild("Enemies") then

for _,v in pairs(workspace.Enemies:GetChildren()) do

if v.Name == "rip_indra True Form"
or v.Name == "Dough King"
or v.Name == "Diablo"
or v.Name == "Deandre"
or v.Name == "Urban"
then

return v.Name

end
end

end

return nil

end

-- Hop system
local function hop()

status.Text = "Status: hopping..."

TeleportService:Teleport(place,player)

end

-- main loop
start.MouseButton1Click:Connect(function()

running = not running

if running then
start.Text = "Stop Finder"
else
start.Text = "Start Boss Finder"
end

while running do

local boss = findBoss()

if boss then

status.Text = "Boss Found: "..boss
running = false
break

else

status.Text = "No boss - hopping server"

hop()

task.wait(2)

end

end

end)
