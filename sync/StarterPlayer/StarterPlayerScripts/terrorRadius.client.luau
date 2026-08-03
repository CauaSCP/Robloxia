--Local k00lHumanoidroot = game.Workspace:WaitForChild("K00lkid"):WaitForChild('HumanoidRootPart')

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local _consts = table.freeze({
	["HUMANOID_ROOT_NAME"] = "HumanoidRootPart",
	["FADE_TIME"] = 0.8
})


local HUMANOID_ROOT_NAME = function(): string
	return _consts["HUMANOID_ROOT_NAME"]
end

local newValue: Instance?

repeat
	newValue = script.GetDistanceFrom.Value:FindFirstChild(HUMANOID_ROOT_NAME())
	
	if newValue ~= nil then	
		break
	end
	
	wait()
until false

if newValue:IsA("BasePart") then
	script.GetDistanceFrom.Value = newValue
end

local function playerHumanoidRootPart(): BasePart
	local res: Instance? = character:FindFirstChild(HUMANOID_ROOT_NAME())
	
	if not res:IsA("BasePart") then
		error(HUMANOID_ROOT_NAME() + "is not a part")
	end
	
	return res
end

local replicated_storage = game:GetService("ReplicatedStorage")
local sounds = replicated_storage.Assets.Music.K00lkid

--replicated_storage.Assets.Music.K00lkidEvent.OnClientEvent:Connect(function(val: SoundGroup)
--	print(">VAL: ", val)
--	sounds.SoundGroup.Value = val
--end)

while sounds.SoundGroup.Value == nil do
	wait()
end

local do_error: boolean = true



local k00lkid_sounds: SoundGroup?
k00lkid_sounds = sounds.SoundGroup.Value
if k00lkid_sounds ~= nil then if k00lkid_sounds:IsA("SoundGroup") then
	do_error = false
end
end

local snd_grp_fnd: string = "K00lkid Sound Group %sfound!"
if do_error then
	error(snd_grp_fnd:format("not "))
end

game:GetService("TestService"):Message(snd_grp_fnd:format(""), script)

for _, c in ipairs(sounds:GetChildren()) do
	--k00lkid_sounds.Volume = 0.5
	
	if c:IsA("Sound") then
		c:Stop()
		c.SoundGroup = k00lkid_sounds
	end
end

local max_distance = 100
local RS = game:GetService("RunService")

local layers: { [number]: {max_distance: number, sound: Sound, Volume: (number|nil)} } = {
	{ sound = sounds.Layer1, max_distance = 100 },
	{ sound = sounds.Layer2, max_distance = 70 },
	{ sound = sounds.Layer3, max_distance = 50 },
	{ sound = sounds.Chase, max_distance = 30 }
}

local function getDistanceFrom(): Vector3
	return ((playerHumanoidRootPart().Position * Vector3.new(-1, -1, -1)) + (script.GetDistanceFrom.Value.Position
		-- * Vector3.new(1, 0, 1)
	))
end

--function NewDistance(): number
--	return getDistanceFrom()
--end

local to_play: Sound?
local _vol: number?

local function FADE_TIME(): number
	return _consts["FADE_TIME"]
end

local function playOnDistance(distance: Vector3)
	local distance: number = distance.Magnitude
	
	if distance > max_distance then
		for _, layer: {max_distance: number, sound: Sound} in ipairs(layers) do
			if layer.sound.Playing then
				layer.sound:Stop()
			end
		end
		
		return
	end
	
	--local layers_sounds: {[number]: Sound} = {}
	local layers_dists: {[number]: number} = {}
	
	for _, layer: {max_distance: number, sound: Sound} in ipairs(layers) do	
		--table.insert(layers_sounds, layer.sound)
		
		table.insert(layers_dists, layer.max_distance)
	end
	
	local function processIndex(i: number): number
		return math.max(0, i-1)
	end

	
	for ind: number, d: number in ipairs(layers_dists) do
		if not( (
			function(_max_dintance: number): boolean
				local max_distance: number = _max_dintance
				
				local greater_than: boolean = distance > max_distance
				
				--print("> DISTANCES:", distance, max_distance)
				
				--if greater_than then
				--	--if ind == 0 then
				--	--	return
				--	--end
					
				--end
				
				--print("Sound:", layers[ind].sound.Name, "| playing:", layers[ind].sound.Playing)
				--print(">DISTANCES:", distance, "|", max_distance)
				
				return (not(greater_than))
				
			end)(d) ) then
			
			break
		end
		
		(function(changing: Sound)
			if changing == to_play then
				return
			end
			
			_vol = layers[ind].Volume
			to_play = changing
		end)(layers[ind].sound)
	end
	
	local fade_plus_time: number = 0
	
	if to_play ~= nil then
		for volume_index, layer: {sound: Sound} in ipairs(layers) do
			if layer.sound ~= to_play then
				if layer.sound.Volume > 0 and layers[volume_index]["Volume"] == nil then
					
					layers[volume_index]["Volume"] = layer.sound.Volume
				end
				
				if not layer.sound.Playing then
					layer.sound.Volume = 0
				else
					fade_plus_time = FADE_TIME()
					local t = tween_service:Create(layer.sound, TweenInfo.new(fade_plus_time), {Volume = 0})
					
					task.delay(fade_plus_time, function()
						task.wait()
						
						layer.sound:Stop()
					end)
					
					t:Play()
				end
				
			end
		end
	end
	
	if not to_play.Playing then
		to_play.Volume = 0
	end
	
	if to_play.Volume == 0 then
		_vol = _vol or 0.75
		--print("Song Name:", to_play.Name)
		
		--print("Volume:", _vol)
		
		local fd = (FADE_TIME() + fade_plus_time + (fade_plus_time/1.8333))
		
		local t = tween_service:Create(to_play, TweenInfo.new(fd), {Volume = _vol})
		t:Play()
		
		print("DELAY:", fd)
		
		to_play:Play()
		
	end
end

tween_service = game:GetService("TweenService")

RS.PreSimulation:Connect(function(_)
	playOnDistance(getDistanceFrom())
end)
