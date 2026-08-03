--local replicated_storage = game:GetService("ReplicatedStorage")

--local function err()
--	error("parsed arg isnt a Part")
--end

--local function forBindable(part_to_change_pos: nil|BasePart|Instance)
--	part_to_change_pos = part_to_change_pos or nil

--	if part_to_change_pos == nil then
--		err()
--		return
--	end

--	if not(part_to_change_pos:IsA("BasePart")) then
--		err()
--		return
--	end

--	local player = game:GetService("Players").LocalPlayer
--	local char = player.Character or player.CharacterAdded:Wait()

--	local function torso(): BasePart
--		return char:WaitForChild("Torso")
--	end
--	local arms: {BasePart} = {
--		char:WaitForChild("Left Arm"),
--		char:WaitForChild("Right Arm")
--	}
--	local legs: {BasePart} = {
--		char:WaitForChild("Left Leg"),
--		char:WaitForChild("Right Leg")
--	}
--	local head: BasePart = char:WaitForChild("Head")

--	part_to_change_pos.Size = (part_to_change_pos.Size * Vector3.new(0, 0, 1)) + Vector3.new(math.max(torso().Size.X, torso().Size.Z), torso().Size.Y + head.Size.Y, 0)

--	--local limits_parent = game.Workspace.BarriersLimit:WaitForChild("Barry"..(part_to_change_pos.Name:sub(-1)))
--	--local l2 = limits_parent:WaitForChild("Limit2")
--	--local l1 = limits_parent:WaitForChild("Limit1")
	
--	--local limits: {Attachment} = {l1, l2}
	
--	--for i, limit: Attachment in ipairs(limits) do
--	--	local addition = ((-2 * i) + 3) * -1
		
--	--	local p = limit.Position
--	--	limit.Position = Vector3.new(part_to_change_pos.Size.X, p.Y, p.Z)
--	--end

--	for _, arm: BasePart in ipairs(arms) do
--		part_to_change_pos.Size += Vector3.new(math.max(arm.Size.X, arm.Size.Z))
--	end

--	for _, leg: BasePart in ipairs(legs) do
--		part_to_change_pos.Size += Vector3.new(0, leg.Size.Y / 2, 0)
--	end

--	local default_player_height: {number} = {part_to_change_pos.Size.Y}
--	table.insert(default_player_height, default_player_height[1] / torso().Size.Y)

--	local function getPlayerCenter(): Vector3
--		local foot_attachment: Instance = legs[1]:WaitForChild("LeftFootAttachment")

--		local player_height_calc_from_torso: number = default_player_height[2] * torso().Size.Y

--		local x_cases: {[boolean]: number} = {
--			[true] = part_to_change_pos.Position.X,
--			[false] = torso().Position.X
--		}

--		local z_cases: {[boolean]: number} = {
--			[true] = torso().Position.Z,
--			[false] = part_to_change_pos.Position.Z
--		}

--		if foot_attachment:IsA("Attachment") then
--			local num = math.abs(part_to_change_pos.Orientation.Y)
--			local case = num == 90

--			return CFrame.new(
--				x_cases[case],
--				foot_attachment.WorldCFrame.Y + (player_height_calc_from_torso / 2), 
--				z_cases[case]
--			).Position
--		end
--	end

--	local bigger_part: Part = Instance.new("Part")
--	bigger_part.Anchored = true
	
--	bigger_part.Size = part_to_change_pos.Size

--	part_to_change_pos.Size *= Vector3.new(5, 5, 1)
--	bigger_part.Size *= Vector3.new(35, 35, 1)

--	bigger_part.Orientation = part_to_change_pos.Orientation
--	bigger_part.Transparency = 1
	
--	bigger_part.Parent = part_to_change_pos



--	local gui = part_to_change_pos.SurfaceGui

--	local max_size: UDim2 = gui.SizeFrame.Size
--	local old_size_for_scale: UDim2 = gui.ScrollingFrame:FindFirstChildWhichIsA("ImageLabel", true).Size

--	--local scrolling_frame_1st_child = gui.ScrollingFrame:FindFirstChildWhichIsA("Instance", false)

--	--local size_of_1st_child: UDim2? = scrolling_frame_1st_child.Size

--	--print(">> TAM:", size_of_1st_child)

--	local img_resized: boolean = false

--	local function resizeImage()
--		local absolute_size = gui.ScrollingFrame.AbsoluteSize

--		if absolute_size ~= Vector2.new(0, 0) then
--			print("[SetParentSize] IMG Sizes:", absolute_size, "|", old_size_for_scale)

--			gui.ScrollingFrame:FindFirstChildWhichIsA("ImageLabel", true).Size = UDim2.fromOffset(
--				absolute_size.X * old_size_for_scale.X.Scale,
--				absolute_size.Y * old_size_for_scale.Y.Scale
--			)

--			--scrolling_frame_1st_child:SetAttribute("Size", 
--			--	UDim2.fromOffset(
--			--		absolute_size.X * size_of_1st_child.X.Scale,
--			--		absolute_size.Y * size_of_1st_child.Y.Scale
--			--	)
--			--)
--		end

--		img_resized = true
--	end

--	local camera = workspace.CurrentCamera

--	while camera == nil do
--		script.Disabled = true
--		wait()
--	end

--	camera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeImage)

--	resizeImage()

--	game:GetService("TestService"):Message("[ParentSize] Current size is: "..tostring(part_to_change_pos.Size))

--	print("Size For Alpha:", part_to_change_pos.SurfaceGui.ScrollingFrame.AbsoluteSize)

--	local tween: TweenService = game:GetService("TweenService")


--	----------------------------------------------------------------------------------------------------------------------------------

--	local oriY = part_to_change_pos.Orientation.Y
	
--	game:GetService("RunService").PreSimulation:Connect(function()
--		if not img_resized then
--			return
--		end

--		local tween_time = 0.26
--		local waited = 0

--		local p = getPlayerCenter()
--		--p = {
--		--	X = p.X,
--		--	Y = p.Y,
--		--	Z = p.Z
--		--}
		
--		--if math.abs(oriY) then
--		--	p.X = math.clamp(p.X, limits[2].WorldCFrame.X, limits[1].WorldCFrame.X)
--		--else
--		--	p.Z = math.clamp(p.Z, limits[1].WorldCFrame.Z, limits[2].WorldCFrame.Z)
--		--end
		
--		--p = Vector3.new(
--		--	p.X,
--		--	p.Y,
--		--	p.Z
--		--)
		
--		--print("PlayerPos:", p)
		
--		tween:Create(part_to_change_pos, TweenInfo.new(tween_time), {Position = p}):Play()

--		task.spawn(function()
--			while true do
--				bigger_part.Position = part_to_change_pos.Position
				

--				if waited >= tween_time then
--					return
--				end

--				wait(0.001)
--				waited += 0.001
--			end
--		end)

--		local dist = math.max((part_to_change_pos.DistAttachment.WorldPosition - torso().CFrame.Position).Magnitude - 1.01, 0.00001)
--		local scale = math.max(math.min(1, 1 / dist) - 0.071, 0)

--		local si_predict = UDim2.fromScale(max_size.X.Scale * scale, max_size.Y.Scale * scale)
--		gui.SizeFrame.Size = si_predict;

--		gui.SiPredictFrame.Size = si_predict;


--		(function(size_to_check: Vector2): ()
--			local axes_enum = Enum.Axis:GetEnumItems()
--			for i = 1, math.min(2, #(axes_enum)) do
--				local _get_nam = axes_enum[i]

--				local axis_name = _get_nam.Name
--				local axis = size_to_check[axis_name]

--				local stop: boolean? = (function(axis: number|any|nil)
--					if type(axis) ~= "number" then
--						return
--					end

--					if axis <= 0.175 then
--						si_predict = UDim2.new()

--						return true
--					end
--				end)(axis)

--				if stop == true then
--					return
--				end
--			end
--		end)(gui.SiPredictFrame.AbsoluteSize / gui.AbsoluteSize)

--		tween:Create(gui.ScrollingFrame, TweenInfo.new(0.46), {Size = si_predict}):Play()
--	end)
--end

--game:GetService("ReplicatedStorage").ToSetPosAndSizeFoo.OnInvoke = forBindable