repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local place = game.PlaceId

local visited = {}

-- UI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "HyunHub"

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,420)
main.Position = UDim2.new(0.5,-260,0.5,-210)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "HYUN HUB - Server Hop"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local refresh = Instance.new("TextButton",main)
refresh.Size = UDim2.new(0,140,0,28)
refresh.Position = UDim2.new(0,10,0,45)
refresh.Text = "Refresh"
refresh.BackgroundColor3 = Color3.fromRGB(45,45,45)
refresh.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",refresh)

local list = Instance.new("ScrollingFrame",main)
list.Size = UDim2.new(1,-20,1,-90)
list.Position = UDim2.new(0,10,0,80)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 6
list.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout",list)
layout.Padding = UDim.new(0,6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle
local toggle = Instance.new("TextButton",gui)
toggle.Size = UDim2.new(0,120,0,35)
toggle.Position = UDim2.new(0,10,0.5,0)
toggle.Text = "Toggle UI"

toggle.MouseButton1Click:Connect(function()
main.Visible = not main.Visible
end)

-- Create server button
function CreateServer(server)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1,0,0,38)
btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
btn.TextColor3 = Color3.new(1,1,1)

btn.Text =
"Players: "..server.playing..
" | "..string.sub(server.id,1,8)

Instance.new("UICorner",btn)

btn.Parent = list

btn.MouseButton1Click:Connect(function()

title.Text = "Teleporting..."

TeleportService:TeleportToPlaceInstance(
place,
server.id,
player
)

end)

end

-- Scan servers
function ScanServers()

title.Text = "Scanning..."

for _,v in pairs(list:GetChildren()) do
if v:IsA("TextButton") then
v:Destroy()
end
end

local cursor = nil
local pages = 0

repeat

local url =
"https://games.roblox.com/v1/games/"..
place..
"/servers/Public?limit=100"

if cursor then
url = url.."&cursor="..cursor
end

local response = game:HttpGet(url)
local data = HttpService:JSONDecode(response)

for _,server in pairs(data.data) do

if server.playing < server.maxPlayers
and not visited[server.id]
then

visited[server.id] = true
CreateServer(server)

end

end

cursor = data.nextPageCursor
pages += 1

task.wait(0.1)

until not cursor or pages >= 10

title.Text = "Scan Complete"

end

refresh.MouseButton1Click:Connect(ScanServers)
