local replicatedStorage = game:GetService("ReplicatedStorage")
local teleportevent = replicatedStorage.RemoteEvents:WaitForChild("TeleportEvent")

local player = game:GetService("Players").LocalPlayer
local teleports = workspace:waitForChild("MapSpawns")

teleportevent.OnServerEvent:Connect(function(player)
	local teleport = teleports:GetChildren()[math.random(1, #teleports:GetChildren())]
	player.Character:MoveTo(teleport.Position)
end)