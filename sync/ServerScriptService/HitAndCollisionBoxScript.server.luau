local replicated_storage = game:GetService("ReplicatedStorage")
local server_storage = game:GetService("ServerStorage")

local parts_essentials = require(server_storage.PartsEssentials)

for i = 1, 3 do
	parts_essentials.physics_service:RegisterCollisionGroup(parts_essentials.collision_groups[i])
end

local collidable = true

local collidable_cases = {
	{1, 4, false},
	{1, 3, false},
	{1, 2, false},
	{3, 3, true},
	{2, 4, true}
}

for i = 2, 3 do
	table.insert(collidable_cases, {2, i, true})
end

replicated_storage.HitBoxEvent.OnServerEvent:Connect(function(player: Player)
	if collidable then
		for _, case in ipairs(collidable_cases) do
			parts_essentials.physics_service:CollisionGroupSetCollidable(
				parts_essentials.collision_groups[case[1]],
				parts_essentials.collision_groups[case[2]],
				
				case[3]
			)
			
			collidable = ( 
				parts_essentials.physics_service:CollisionGroupsAreCollidable(parts_essentials.collision_groups[case[1]], parts_essentials.collision_groups[case[2]])
					==
				case[3]
			)
		end
	end
	
	print("player", player.Name, "fired hit box stuff event", parts_essentials.physics_service:CollisionGroupsAreCollidable(parts_essentials.collision_groups[1], parts_essentials.collision_groups[4]))
	
	local run_service = game:GetService("RunService")

	local __char: Model?

	player.CharacterAdded:Connect(function(character: Model)
		__char = character
	end)

	player.CharacterRemoving:Connect(function()
		__char = nil
	end)

	local function char(): Model
		local result = player.Character or __char

		if not result then
			local ch = player.CharacterAdded:Wait()

			if not ch then
				error("totally could not find character for "..player.Name)
			end

			result = ch
		end

		return result
	end

	local stuff_box: BasePart = server_storage.HitAndCollisionBox:Clone()
	local welding = stuff_box:FindFirstChildOfClass("Weld")

	stuff_box.CanCollide = false

	local function timeOfLoopEnd(Time: number?)
		task.wait(Time)
	end

	local parts: {[BasePart|Part|string]: any} = {}

	local function parts_using(foo: (the_part: BasePart|Part) -> any|nil)
		local results = {}

		local nils = 0
		local count = 0

		for part, _ in pairs(parts) do
			if type(part) ~= "userdata" then
				error("found something that is not an Instance")
			end

			local cur = foo(part)

			if cur == nil then
				cur = 'nil'
				nils += 1
			end

			results[part] = cur

			count += 1
		end

		if count == nil then
			return {}
		end

		return results
	end

	local function a_task()
		local torso: BasePart? = nil
		
		while true do
			if char() and not(welding.Enabled) and welding.Part0 == nil then
				pcall(function()
					torso = char():WaitForChild("Torso")
				end)

				if torso == nil then
					timeOfLoopEnd()

					return
				end

				--local nam = "HitAndCollisionBoxPositioning"
				

				torso.Anchored = true

				parts_using(function(the_part: BasePart | Part): nil
					the_part.CollisionGroup = parts_essentials.collision_groups[1]
				end)
				
				local other_leg: Instance? = char():FindFirstChild("Right Leg")
				
				if other_leg ~= nil then if other_leg:IsA("BasePart") then
						other_leg.CollisionGroup = parts_essentials.collision_groups[1]
					end
				end

				stuff_box.CollisionGroup = parts_essentials.collision_groups[4]
				stuff_box.CanCollide = true
				
				stuff_box.Transparency = 1
				stuff_box.Parent = char()
				
				stuff_box.Orientation = torso.Orientation
			
				stuff_box.Position = torso.Position
				
				welding.Part0 = torso

				wait()
				
				torso.Anchored = false
				welding.Enabled = true
				
			end

			if welding.Enabled and welding.Part0 ~= nil then
				local vec_zero = Vector3.new(0, 0, 0)
				local hum = char():FindFirstChildOfClass("Humanoid")
				
				local num = 0
				local one = -1
				
				local higher_and_lower: {[boolean]: () -> number} = {
					[true] = function()
						return math.min(welding.C1.Z - 0.01)
					end,
					[false] = function()
						return math.max(welding.C1.Z + 0.01)
					end
				}

				run_service.PostSimulation:Connect(function()
					if num <= -0.6 then
						one = 1
					elseif num >= 0.3 then
						one = -1
					end
					
					if hum.MoveDirection ~= vec_zero then
						num = num + (one * 0.01)
						welding.C1 = CFrame.new(0, 0, num)
					elseif welding.C1.Z ~= 0 then
						local adding = higher_and_lower[welding.C1.Z > 0]
						
						welding.C1 = CFrame.new(0, 0, adding())
					end
				end)
				
				break
			end

			timeOfLoopEnd()
		end
	end

	local function first_task(char: Model)
		local function part_by_name(name: string): string|Part
			local result: Instance|nil|string = nil

			pcall(function()
				result = char:WaitForChild(name)
			end)

			if result ~= nil then
				local r: Instance = result

				if not r:IsA("BasePart") then
					result = nil
				end
			end

			if result == nil then
				result = 'nil'
			end

			return result
		end

		local torso: Part|string = part_by_name("Torso")

		parts[torso] = 1
		parts[part_by_name("Left Leg")] = 1
		parts[part_by_name("Head")] = 1

		if parts['nil'] == 1 then
			error("parts not found completally")
		end

		local my_sum = 0

		parts_using(function(the_part: BasePart | Part): nil
			my_sum += the_part.Size.Y
		end)

		if type(torso) ~= "string" and torso:IsA("BasePart") then
			stuff_box.Size = Vector3.new(torso.Size.X, my_sum, torso.Size.Z)
		end
	end

	first_task(char())


	task.spawn(a_task)
end)