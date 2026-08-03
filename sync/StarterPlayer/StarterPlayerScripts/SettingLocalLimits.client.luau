local dyns_parent = nil
local a_dynamic = nil

local function barriers_limiting(_b: Instance, new_part_size: Vector3)
	if not _b:IsA("BasePart") then
		return
	end

	local barrier: BasePart = _b

	local name_ending = barrier.Name:sub(-1)
	local dyn: BasePart? = dyns_parent:FindFirstChild("DynamicBarrier"..name_ending)
	if dyn == nil then
		error("dynamic barrier inexistent")
	end

	for c = 1, 2 do
		local to_add = (-2 * c) + 3	--// -1 or 1
		local position_limit = Instance.new("Part")
		position_limit.Anchored = true
		position_limit.Name = "Limit"..c
		position_limit.Orientation = Vector3.new(0, dyn.Orientation.Y, 0)
		position_limit.Size = new_part_size

		local p = barrier.Position
		local pos = {
			X = p.X,
			Y = p.Y,
			Z = p.Z
		}

		pos.X += (barrier.Size.X/2) * to_add

		position_limit.Position = Vector3.new(pos.X, pos.Y, pos.Z)
	end
end

local messaging = game:GetService("TestService")

local function main(barriers_parent: Folder)
	messaging:Message("Running main Func")

	if not a_dynamic:IsA("BasePart") then
		return
	end

	local sizing = a_dynamic.Size

	for _, barrier in ipairs(barriers_parent:GetChildren()) do
		barriers_limiting(barrier, sizing)
	end
end

local barriers_limit: Folder

messaging:Message("wating for barriers limiting")

while true do
	local folder = game.Workspace:FindFirstChild("BarriersLimit")

	if folder ~= nil then
		if folder:IsA("Folder") then
			barriers_limit = folder

			break
		end
	end

	wait()
end

dyns_parent = game.Workspace.MainMap.Secondary.BarrierSystem.DynamicSystem

while true do
	a_dynamic = dyns_parent:FindFirstChild("DynamicBarrier4")
	if a_dynamic ~= nil then
		break
	end

	wait()
end

main(barriers_limit)