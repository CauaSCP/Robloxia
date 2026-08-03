--!strict

local storage = game:GetService("ServerStorage")
local module: {[string]: (player: Player) -> ()} = {}


module["WaterBottle"] = function(player: Player)
	require(storage.ChangePlayerStatus.InvokeModule)(
		{
			["stam"] = function(current_val: number): number
				print("curando 6 stamina")
				return current_val + 6
			end,
			["food"] = function(current_val: number): number
				print("curando 10 food")
				return current_val + 10
			end,
		},
		player
	)
end

module["BloxyCola"] = function(player: Player)
	require(storage.ChangePlayerStatus.InvokeModule)(
		{
			["stam"] = function(current_val: number): number
				print("curando 8 stamina")
				return current_val + 8
			end,
			["food"] = function(current_val: number): number
				print("curando 20 food")
				return current_val + 20
			end,
			["speed"] = function(_: number): number
				print("ganhou velo 1")
				return 1
			end
		},
		player
	)
end

return module
