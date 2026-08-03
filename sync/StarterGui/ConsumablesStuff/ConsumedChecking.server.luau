--!strict

local server_storage = game:GetService("ServerStorage")
local consumables_module = require(server_storage.Consumables)

local messaging: TestService = game:GetService("TestService")

local player = script:FindFirstAncestorOfClass("Player");

(function()
	print(">Before Backpack")

	if player == nil then
		return
	end

	local backpack = player:FindFirstChildWhichIsA("Backpack")

	print(">backpack:", backpack)


	if backpack == nil then
		return
	end

	local connecteds: {[Tool]: any} = {}


	backpack.ChildAdded:Connect(function(child: Instance|Tool)
		if not(child:IsA("Tool")) then
			return
		end

		if connecteds[child] ~= nil then
			return
		end

		print(child.Name.." ADDED!")

		local consumed_event: RemoteEvent|Instance?

		pcall(function()
			consumed_event = child:WaitForChild("ConsumedEvent")

			if consumed_event == nil then
				return
			end

			if not(consumed_event:IsA("RemoteEvent")) then
				return
			end

			local nam = child.Name

			local conn = nil

			conn = consumed_event.OnServerEvent:Connect(function(player: Player)
				consumables_module[nam](player)
				connecteds[child] = nil
			end)

			if conn ~= nil then
				connecteds[child] = conn

				print("Connected:", conn)
			end
		end)
	end)
end)()