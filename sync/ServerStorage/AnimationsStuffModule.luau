--[[
	--!strict
]]


local AnimationsStuffModule = {}

export type Tracks = {
	[string]: (number|AnimationTrack)?,

	Idle: (number|AnimationTrack)?,
	Walk: (number|AnimationTrack)?,
	Run: (number|AnimationTrack)?
}

local enum = {
	Run = Enum.AnimationPriority.Action,
	Walk = Enum.AnimationPriority.Movement,
	Idle = 0
}

local function animatorFromPlayer(player: Player): Animator
	local char = player.Character or player.CharacterAdded:Wait()
	
	local hum: Humanoid = char:WaitForChild("Humanoid") :: Humanoid
	
	local res = hum:WaitForChild("Animator")
	
	assert(res:IsA("Animator"), `couldn't find an Animator for player {player.Name}`)
	
	return res
end

local test_service = game:GetService("TestService")

type _LoadAnimation = (name: string, id: number, player: Player) -> AnimationTrack

local TRACKS: Tracks = {

} :: Tracks

function AnimationsStuffModule.getAnimationId<T>(track: T|AnimationTrack)
	local res = nil
	
	local instance_track: T|Instance = track
	
	local success, txt = pcall(function(...)
		assert(typeof(instance_track) == "Instance", "track is not an Instance")
		
		local class = "AnimationTrack"
		assert(instance_track:IsA(class), `{instance_track.Name} {typeof((instance_track))} is not an {class}`)
		
		local property: string = "Animation"
		local anim: Animation = (instance_track :: AnimationTrack).Animation
		
		assert(anim ~= nil, `{instance_track.Name} does not have an {property} property`)
		
		res = anim.AnimationId
		
		assert(res ~= nil, `{property} is nil for {instance_track.Name}`)
		
		return ""
	end)
	
	if not success then
		warn(txt)
		
		return "@NULL"
	end
	
	return res
end

function AnimationsStuffModule._loadAnimation(name: string, id: number, player: Player)
	local tracks = TRACKS
	
	local anim = Instance.new("Animation")
	
	anim.AnimationId = `rbxassetid://{id}`
	
	print(anim.AnimationId)
	
	local animator = animatorFromPlayer(player)
	
	local track = animator:LoadAnimation(anim)
	local named_track: Instance|AnimationTrack
	
	if typeof(tracks[name]) == "Instance" then
		named_track = (tracks[name] :: Instance)
		
		local method_name: string = "Stop"
		
		assert(named_track:IsA("AnimationTrack"),
--
--[[]]    `{method_name} is not a valid member of {named_track.ClassName}`
--
		)
		
		type Method = (me: AnimationTrack, arg: number|nil) -> ()
		
		local stop_method: Method = function(me: AnimationTrack, arg: number|nil)
			
		end
		
		pcall(function()
			stop_method = ((named_track :: any)[method_name] :: Method)
		end)
		
		stop_method(named_track)
		
		named_track:Destroy()
	end
	
	local curLin: number? = -1
	assert((enum[name])~=nil, `unexistent enum for {name}`)
	
	local success: boolean
	local warn_text: string = ""
	
	success, warn_text = pcall(function()
		local a = 1 + 1; (function()
			return a
		end)()
		
		local n = tonumber(enum[name])

		curLin = debug.info(1, "l")		assert(typeof(n) == "number", `{name} is not a real enum for 'Enum.{Enum.AnimationPriority}'!`)
		
		local priority: Enum.AnimationPriority = (enum[name] :: any) :: Enum.AnimationPriority
		
		track.Priority = priority
	end)
	
	test_service:Warn(not success, `{warn_text}`, script, curLin)
	
	local tab = {track, tracks}

	tracks[name] = track

	return unpack(tab)
end

local others = {}
others[96901824097912] = 'Idle'
others[115078091577032] = 'Walk'
others[71193544003604] = 'Run'

function AnimationsStuffModule:updateAnimId(name: string, newId: number, player: Player, sc: Script)
	assert(not sc:IsA("ModuleScript"), "sc may not be a ModuleScript!")
	
	local _tracks: Tracks|nil = nil
	
	local res: AnimationTrack = (nil :: any) :: AnimationTrack
	
	local me: {[string]: any, _loadAnimation: _LoadAnimation} = self
	
	self = me
	
	local cur_int: IntValue? = sc:FindFirstChild(name) :: IntValue|nil
	
	local cur_line: number|nil = 102
	
	if cur_int ~= nil then    cur_line = debug.info(1, "l")
		cur_int.Value = newId
		
		print(`play_anim | {name} {newId} {player.Name}`)
		
		res, _tracks = self._loadAnimation(name, newId, player)

		-- others
	else
		test_service:Error(`{sc.Name} doesn't have {name} child!`, script, cur_line)
	end
	
	local tab = {res, _tracks}
	return unpack(tab)
end

return AnimationsStuffModule
