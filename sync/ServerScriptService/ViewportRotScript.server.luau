task.wait(0.5)

local tables_registry = require(game.Workspace.SharedTableRegistry.Self)
local storage = game:GetService("ReplicatedStorage")

local for_rot_cfram: CFrame = script.ForRot.Value
local rot_table: {number} = {for_rot_cfram:ToEulerAnglesYXZ()}

-- for index, coord in ipairs(rot_table) do
-- 	if index > 3 then
-- 		break
-- 	end

-- 	print("old:", coord)
-- 	rot_table[index] = math.deg(coord)
-- 	print("new:", rot_table[index])
-- end

local table_name = "RotationForViewport"

tables_registry:SetSharedTable(table_name, rot_table)

local test: () -> boolean

table.clear(rot_table)

while true do
	test = tables_registry:GetRegisteredSharedTables(table_name)

	if test() then
		break
	end

	wait()
end

local rot_table_shared = tables_registry:GetSharedTable(table_name)
for ind = 1, SharedTable.size(rot_table_shared) do
	table.insert(rot_table, rot_table_shared[ind])
end

table.freeze(rot_table)

wait()

print("TEST Viewport")

storage.ViewportRotCall.OnServerInvoke = function()
	local clon: {number} = {}
	for _, coord in ipairs(rot_table) do
		table.insert(clon, coord)
	end

	return clon
end