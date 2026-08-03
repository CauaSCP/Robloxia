--!strict

local server_storage = game:GetService("ServerStorage")
local tables_registry = require(game.Workspace.SharedTableRegistry.Self)

local Types = require(server_storage.Consumables.TypesModule)

local StaminaVal = script.StaminaValue
local FoodVal = script.FoodValue
local SpeedVal = script.SpeedValue

local player_id = -1

repeat
	player_id = script.Parent.PlayerId.Value
	wait()
until player_id > 0

local GetStatusTable: Types.GetStatus = function()
	return tables_registry:GetSharedTable("status_"..tostring(player_id))
end

local Status = GetStatusTable()

server_storage.ChangePlayerStatus.OnInvoke = function(calculation_methods: Types.CalcMethods, player: Player)
	for status_name, method: Types.Method in pairs(calculation_methods) do
		if status_name == "stam" then
			local stamina_b4 = Status.stam.Value

			print(">oldStamina:", stamina_b4)

			Status.stam.Value = (math.min(100, tonumber(method(stamina_b4))))
			
			print(">newStamina:", Status.stam.Value)
			
		elseif status_name == "health" then
			local char = player.Character or player.CharacterAdded:Wait()
			local hum = char:FindFirstChildWhichIsA("Humanoid")

			if hum == nil then
				continue
			end

			local health_b4 = hum.Health

			hum.Health = math.min(hum.MaxHealth, tonumber(method(health_b4)))
		elseif status_name == "food" then
			local food_b4 = Status.food.Value

			Status.food.Value = (math.min(100, tonumber(method(food_b4))))
		elseif status_name == "speed" then
			local speed_b4 = Status.speed.Value

			Status.speed.Value = (math.min(4, tonumber(method(speed_b4))))

			print(">newSpeed:", Status.speed.Value)
		end
	end
end