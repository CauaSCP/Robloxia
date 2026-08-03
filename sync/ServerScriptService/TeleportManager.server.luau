local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local teleportEvent = replicatedStorage.RemoteEvents:WaitForChild("TeleportPlayer")
local mapSpawnsFolder = replicatedStorage:WaitForChild("MapSpawns")

--[[local menuGui = game.StarterGui:WaitForChild("MenuGUI")
local menuAmbience = menuGui:WaitForChild("MenuAmbience")]]

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Forçamos o estado de menu ANTES de qualquer outra coisa
		player:SetAttribute("IsInMenu", true)
	end)
end)

teleportEvent.OnServerEvent:Connect(function(player)
	if player:GetAttribute("IsInMenu") == true then
		local character = player.Character
		local spawns = mapSpawnsFolder:GetChildren()

		if character and #spawns > 0 then
			local randomSpawn = spawns[math.random(1, #spawns)]
			-- Usando PivotTo que é mais moderno que MoveTo
			character:PivotTo(randomSpawn.CFrame + Vector3.new(0, 3, 0))

			-- O jogador saiu do menu
			player:SetAttribute("IsInMenu", false)
			
		end
	end
end)