local function GetHumanoidFromCharacter(character: Model): Humanoid
	local humBfr = character:FindFirstChildOfClass("Humanoid")

	assert(humBfr ~= nil, `the character {character.Name} doesn't have a humanoid`)

	return (character:WaitForChild(humBfr.Name) :: Humanoid)
end

local humanoid: Humanoid
local animator: Animator

local ID_PREFIX = "rbxassetid://"

local animationID: number

local function animationIdGet(id_num: number, char: Model): Animation
	for _, child in ipairs(char:FindFirstChild(game.StarterPlayer.StarterCharacterScripts.MovementAnimations.Name):GetChildren()) do
		pcall(function()
			print(tostring(id_num), child.Name, (child.Value::Instance).ClassName, "çChild")
		end)
		
		local ifo = ((child.Name :: string):find(tostring(id_num)) ~= nil)
		
		--warn(`@If: {ifo}`)
		
		ifo = ifo and child:IsA("ObjectValue")
		
		--warn(`@If: {ifo}`)
		
		if ifo then
			warn("@If: yay")
			return (child.Value) :: Animation
		end
	end
	local result: Animation = Instance.new("Animation")

	result.AnimationId = ID_PREFIX..id_num
	animationID = id_num

	return result
end

local function meta(character: Model, animation: number|Animation|AnimationTrack)
	local list = {}
	
	local exists = pcall(function()
		list = {humanoid, animator}
	end)
	
	local last = nil
	
	pcall(function()
		last = list[#(list)]
	end)

	if (not exists) or last == nil then
		humanoid = GetHumanoidFromCharacter(character)
		local mator = humanoid:WaitForChild("Animator")

		assert(mator:IsA("Animator"), `somehow {character}'s Animator is not an Animator`)

		animator = mator
	end

	if typeof(animation) == "number" then
		animation = animationIdGet(animation, character)
	else
		local to_gsub = `^{ID_PREFIX}`
		local id = tonumber(string.gsub(animation.AnimationId, to_gsub, ''))
		assert(id~=nil, `unexistent id for {animation.AnimationId}`)

		animationID = id
	end
	
	local tp = typeof(animation)
	if tp == "Instance" then
		tp = animation.ClassName
	end
	
	warn(debug.traceback())

	assert(
		typeof(animation) == "Instance" and (animation:IsA("AnimationTrack") or animation:IsA("Animation")),
		`animation param is one {tp}`
	)
	
	if animation:IsA("AnimationTrack") then
		animator:LoadAnimation(animation.Animation)
		return animation
	end

	return animator:LoadAnimation(animation)
end

local players = game:GetService("Players")

local ID_PREFIX = "rbxassetid://"

local function movesParent(track_val: AnimationTrack, parent_obj: Instance?,  idleAndEmoteBins: {[string]: number})
	assert(typeof(parent_obj) == "Instance", `2nd paramater is not an Instance but one {typeof(parent_obj)}`)
	assert(idleAndEmoteBins ~= nil, `idleAndEmoteBinsStr may not be empty`)
	
	local res: Instance? = nil
	
	local nameChild = "_NoEnum_C"
	pcall(function()
		nameChild = `_{track_val.Priority.Name}__`
	end)
	
	local p = ''
	if nameChild == `_{p}__` then
		nameChild = "_"
	else
		nameChild = nameChild:sub(2, (nameChild:len() - 2))
	end
	
	local idleAndEmoteBinsStr: string = ''
	local t: {string|number} = {}
	
	for _=1,2 do
		table.insert(t, "")
	end
	
	
	for k, v in pairs(idleAndEmoteBins) do
		t[1] = k:sub(1):lower()
		t[2] = tostring(tonumber(v))
		
		idleAndEmoteBinsStr = `{idleAndEmoteBinsStr}{table.concat(t)}`
		
		t = {}
	end
	
	if idleAndEmoteBinsStr ~= "" then
		idleAndEmoteBinsStr = `_{idleAndEmoteBinsStr}`
	end
	
	warn(`nameChild: {nameChild}`)
	
	local success = pcall(function()
		for _, c in ipairs(parent_obj:GetChildren()) do
			local _id = (track_val::AnimationTrack).Animation.AnimationId
			
			
			warn(`cases: {c.Name:find(`{animationID}`)} & {animationID}||{_id}||{c.Name} & {c.Name:sub(1, nameChild:len()):lower() == nameChild:lower()}`)
			
			if 
				(c.Name:find(`{animationID}`) ~= nil)
					and
				c.Name:sub(1, nameChild:len()):lower() == nameChild:lower()
			then
				res = c
				break
			end
		end
	end)
	
	if (not success) or res == nil then
		(function ()
			for _, c in ipairs(parent_obj:GetChildren()) do
				if c.Name:sub(1, 1) == '_' then
					res = c
				end
			end
			
			if nameChild ~= nil and parent_obj:FindFirstChild(nameChild) == nil then
				res = Instance.new("ObjectValue")
				res.Name = nameChild
				res.Parent = (parent_obj :: Instance)
			end
		end)()
	end
	assert(res ~= nil, `first child for {parent_obj.Name} doesn't exist`)
	
	assert(res:IsA("ObjectValue"), `the child {nameChild} for {parent_obj.Name} is not an ObjectValue`)
	
	local instance_val: ObjectValue = (res :: ObjectValue)
	
	instance_val.Value = track_val
	
	task.spawn(function()
		local tmp: string
		
		if --[[instance_val.Name:find("NoEnum") or]] instance_val == '_' then
			return
		end
		
		while true do
			if instance_val.Name:find('__') then
				pcall(function()
					tmp = `_{(instance_val.Value::AnimationTrack).Priority.Name}__`
				end)
			else
				pcall(function()
					tmp = (instance_val.Value::AnimationTrack).Priority.Name
				end)
			end
			
			if not tmp:find('__') then
				tmp = `{tmp}_`
			end
			
			local to_gsub = `^{ID_PREFIX}`
			
			local id: string? = (instance_val.Value::AnimationTrack).Animation.AnimationId
			id = string.gsub(id, to_gsub, '')

			-- print(`names>\n\t{instance_val.Name}\n\t{`{tmp}{id}{idleAndEmoteBinsStr}`}\n`)

			instance_val.Name = `{tmp}{id}{idleAndEmoteBinsStr}`
			
			task.wait(0.02)
		end
	end)
end

local table_meet = {}
local res__
local fo
local fo2

local function _isBin(nameInst: string, other: number|nil, f: string)
	other = other or 0
	
	nameInst = nameInst:lower()

	fo = nameInst:find(f)
	fo2 = nameInst:find(f:sub(1, 1)..`{other}`)
	res__ = fo ~= nil
	assert(fo2~=nil, `´{f:sub(1, 1)}{other}´ is not inside ´{nameInst}´`)
	
	return res__
end
local function isEmote(nameInst: string): boolean
	return _isBin(nameInst, 0, 'e1')
end

local function isDance(nameInst: string): boolean
	return _isBin(nameInst, 0, 'd1')
end

local function forplAnim(mv_inst: Instance?)
	if mv_inst == nil then
		return false
	end
	
	for _, ch in ipairs((mv_inst):GetChildren()) do
		warn(`ANIMATION IS: {ch.Name}`)
		
		if ch.Name == "_NoEnum" then
			continue
		end
		
		if

			((not isDance(ch.Name)) and isEmote(ch.Name)) 
			--or
			--((ch.Name :: string):find())

		then
			continue
		end


	end
	
	return true
end

local function PlayAnimation()
	local res = function()
		local bool = false

		bool = pcall(function()
			script.Parent.OnClientInvoke = function(character: Model, animation: number|Animation, idleAndEmoteBins: {[string]: number}|{['char']: 'bin_bool'}): AnimationTrack
				local track: AnimationTrack? = meta(character, animation)
				
				task.spawn(function()
					if not forplAnim(character:FindFirstChild("MovementAnimations")) then
						warn(`character {character.Name} has no movement in client side for {players.LocalPlayer}`)
					end
				end)
				
				assert(track ~= nil, `unexistent track for {animationID} // {animation}`)

				assert(players.LocalPlayer ~= nil, `script is not a LocalScript`)
				--local me_player = (players.LocalPlayer :: Player)
				
				local nonNilTrack = track :: AnimationTrack
				local isTrack = false
				pcall(function(...)
					isTrack = track:IsA("AnimationTrack")
				end)
				
				print("çTrack:", track, "is a track:", isTrack)

				task.spawn(function()
					local curTrack = nonNilTrack

					local priority: Enum.AnimationPriority|nil = nil
					while true do
						if priority ~= curTrack.Priority then
							print(`anim priority {character} {curTrack.Animation.AnimationId} {curTrack.Priority.Name}`)
							priority = curTrack.priority
						end

						task.wait()
					end
				end)

				nonNilTrack:Play()
				
				movesParent(nonNilTrack, character.MovementAnimations, idleAndEmoteBins)
				
				return nonNilTrack
			end
		end)

		return bool
	end

	return res
end

return PlayAnimation