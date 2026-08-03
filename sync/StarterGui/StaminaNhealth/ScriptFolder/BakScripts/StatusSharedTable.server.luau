script.Parent.PlayerId.Value = -1

local server_storage = game:GetService("ServerStorage")
local tables_registry = require(game.Workspace.SharedTableRegistry.Self)

local Types = require(server_storage.Consumables.TypesModule)

local player = script:FindFirstAncestorOfClass("Player")

print(">player id:", player.UserId)

local _value: {Value: number} = SharedTable.new(
{
	Value = nil
}
)

local MAXIMUMS = SharedTable.new()

local vals: {[string]: {Value: number}} = SharedTable.new()

for name, starting in pairs(Types.start_values) do
	local v = SharedTable.clone(_value)
	v.Value = starting

	vals[name] = v
	MAXIMUMS[name] = Types.max_values[name]
end

MAXIMUMS = SharedTable.cloneAndFreeze(MAXIMUMS)

vals.MAX = MAXIMUMS

tables_registry:SetSharedTable("status_"..player.UserId, vals)

wait(0.5)

script.Parent.PlayerId.Value = player.UserId