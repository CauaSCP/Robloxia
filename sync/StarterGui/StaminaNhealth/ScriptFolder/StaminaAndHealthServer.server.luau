---@diagnostic disable: undefined-global

--// SERVICES
-- local Players = game:GetService("Players")
-- local TweenService = game:GetService("TweenService")

local SharedTableRegistry = require(game.Workspace.SharedTableRegistry.Self)
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Types = require(ServerStorage.Consumables.TypesModule)

--// PLAYER
local pGui = nil

repeat
	pGui = script:FindFirstAncestorWhichIsA("PlayerGui")

	task.wait()
until pGui ~= nil

local _player = pGui:FindFirstAncestorOfClass("Player")

assert(typeof(_player) == "Instance" and _player:IsA("Player"), "playerGui "..tostring(pGui).." doesn't have a player!")

local player = _player :: Player

local character = (function() local c = (player.Character or player.CharacterAdded:Wait()) :: Model|nil;  
	assert(
		c ~= nil, "not find character for "..tostring(player)
	)
	
	return c :: Model
end)()

local fireChangeCharacter = function(c: Model)
	script.AnimSel.ChangeCharacter:Fire(c)
end

fireChangeCharacter(character)

local humanoid: Humanoid = character:WaitForChild("Humanoid") :: Humanoid


-- local animator = humanoid:WaitForChild("Animator")

--// GUI
local ScreenGui = script.Parent.Parent
local MainFrame = ScreenGui:WaitForChild("MainFrame")

local HealthFrame = MainFrame:WaitForChild("HealthFrame")
local HealthText = HealthFrame:WaitForChild("HealthText")
local HealthBar = HealthFrame:WaitForChild("HealthBar")

local StaminaFrame = MainFrame:WaitForChild("StaminaFrame")
local StaminaText = StaminaFrame:WaitForChild("StaminaText")
local StaminaBar = StaminaFrame:WaitForChild("StaminaBar")

--local WALKING_SPEEDS = table.freeze({
--	["walking"] = 13,
--	["running"] = 45
--})

local player_id = -1

repeat
	player_id = script.Parent.PlayerId.Value
	task.wait()
until player_id > 0

local GetStatusTable: Types.GetStatus = function()
	return SharedTableRegistry:GetSharedTable("status_"..player_id)
end


-- -------------
local Status = GetStatusTable()
print(">Values {"..player.Name.."} >", Status)

local MAX_STAMINA: number = Status.MAX["stam"]

print(">Maximum Stamina", MAX_STAMINA)

local DRAIN_RATE = 7
local REGEN_RATE = 13

local staminaLocked = false
local regenDelay = 0

--// BAR SIZES
local HP_SIZE = HealthBar.Size
local ST_SIZE = StaminaBar.Size

--// ANIMATIONS
local AnimationsStuffModule = require(ServerStorage.AnimationsStuffModule)

local tracks: AnimationsStuffModule.Tracks? = nil
local animationIds = {
	Idle = -1	--[[96901824097912]],
	Walk = -1	--[[115078091577032]],
	Run  = -1	--[[71193544003604]]
}

--for name, id in pairs(animationIds) do
--	local anim = Instance.new("Animation")
--	anim.AnimationId = "rbxassetid://" .. id

--	local track = animator:LoadAnimation(anim)
--	tracks[name] = track

--	if name == "Run" then
--		track.Priority = Enum.AnimationPriority.Action
--	elseif name == "Walk" then
--		track.Priority = Enum.AnimationPriority.Movement
--	end
--end


-- local requiredFunc = require(ReplicatedStorage.PlayAnimation.Call)

-- ---@diagnostic disable-next-line: 1014
-- local playAnimation = requiredFunc<<AnimationTrack>>()

-- playAnimation(character, 96901824097912, {e = 0, i = 1})

local boolToNum = {
	[false] = 0,
	[true] = 1
}

for name, id in pairs(animationIds) do
	local cur_int = script:FindFirstChild(name)
	local animId = cur_int and cur_int or id
	
	assert(cur_int:IsA("IntValue"), name.." doesn't exist for "..tostring(script.Name))
	
	local prop_name = "Value"
	
	cur_int.Value = -1

	local conn: any|nil = cur_int:GetPropertyChangedSignal(prop_name):Connect(function(...)
		local self: IntValue = cur_int
		--local emote_and_idle = {e=0, i=0}
		
		print("self.Value:", self.Value)
		
		if animationIds[self.Name] == self.Value then
			return
		end
		
		animationIds[self.Name] = self.Value
		
		--[[
		'''
		emote_and_idle["i"] = boolToNum[self.Name:lower() == "idle"]
		
		print("emote_and_idle:", emote_and_idle)
		
		if emote_and_idle.i == 1 then
			playAnimation(character, self.Value, emote_and_idle)
		end
		'''
		]]
		
		
		--print(cur_int.Name, "UPDATED_Ç")


		
--		--local cur_track, retrieved_tracks = AnimationsStuffModule:updateAnimId(self.Name, self.Value, player, script)
		
--		local animat = (cur_track :: AnimationTrack).Animation
		
		
--		----
--		local animID = nil
--		if animat ~= nil then
--			animID = animat.AnimationId :: (string|nil)
--		end
		
--		if animID == nil then
--			animID = "@NULL"
--		end
--		----
		
		
--		print(animID, retrieved_tracks, "cur_int")
		
--		if typeof(retrieved_tracks) == "table" then
--			if tracks == nil then
--				tracks = retrieved_tracks
--			else
--				for key, value in pairs(retrieved_tracks :: AnimationsStuffModule.Tracks) do
--					tracks[key] = value
--				end
--			end
			
----			print("--tracks:", {
--			--	AnimationsStuffModule.getAnimationId(tracks.Idle),
--			--	AnimationsStuffModule.getAnimationId(tracks.Walk),
--			--	AnimationsStuffModule.getAnimationId(tracks.Run)
--			--})
--		end
		
--		print()
	end)
	
	--cur_int[prop_name] = id
	
	--cur_int.Value = id
	--assert(conn and cur_int.Value == id, "GetPropertyChangedSignal for "..tostring(cur_int.Name).."'s "..prop_name.." connection could not be made")
	
--	print(cur_int[prop_name], "cur_int", "LL")
end

print("cur_int")

--local function playAnimation(name)
--	if tracks == nil then
--		if script:FindFirstAncestorOfClass("StarterGui") == nil then

--			return
--		else
--			warn('tracks is a nil value!')
--		end
--	end
	
--	local track = tracks[name]
--	if not track or track.IsPlaying then return end

--	for _, t in pairs(tracks) do
--		if t ~= track then
--			t:Stop(0.15)
--		end
--	end

--	track:Play(name == "Run" and 0.1 or 0.25)
--end

--// GUI UPDATE
local function updateGUI()
	local hpPercent = humanoid.Health / humanoid.MaxHealth
	local stPercent = Status.stam.Value / MAX_STAMINA

	HealthBar:TweenSize(
		UDim2.new(HP_SIZE.X.Scale * hpPercent, 0, HP_SIZE.Y.Scale, 0),
		"Out", "Quad", 0.15, true
	)

	StaminaBar:TweenSize(
		UDim2.new(ST_SIZE.X.Scale * stPercent, 0, ST_SIZE.Y.Scale, 0),
		"Out", "Quad", 0.15, true
	)

	StaminaText.Text = math.floor(Status.stam.Value).."/"..MAX_STAMINA

	if not humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead) then
		HealthText.Text = "∞/∞"
		HealthText.TextScaled = false
		return
	else
		HealthText.TextScaled = true
	end

	HealthText.Text = math.floor(humanoid.Health).."/"..humanoid.MaxHealth
end

local anim_instance_sel: ObjectValue = script.AnimSel

local moving: boolean
local running: boolean

local MOVE_CASES = {
	[true] = script.Walk;
	[false] = script.Idle
}

local function _animUPD(val: Instance)
	if val.Parent ~= script or typeof(val) ~= "Instance" then
		error(`invalid val argument /{val}\\!`)
	end

	anim_instance_sel.Value = val
end
local _dt: number

local function updateAnim()
	if running and moving and not staminaLocked and Status.stam.Value > 0 then
		_animUPD(script.Run)

		humanoid.WalkSpeed = 45

		local old_stamina_val = Status.stam.Value
		Status.stam.Value = math.max(0, old_stamina_val - DRAIN_RATE * _dt)

		regenDelay = 0.35

		return
	end

	_animUPD(MOVE_CASES[moving])

	humanoid.WalkSpeed = 13

	if regenDelay > 0 then
		regenDelay = math.max(0, regenDelay - _dt)
	else
		local old_stamina_val = Status.stam.Value
		Status.stam.Value = math.min(MAX_STAMINA, old_stamina_val + REGEN_RATE * _dt)
	end
end

local staminaChecking: boolean = false

local runButtonPressedEvent = ReplicatedStorage.RunButtonPressed

local conn = runButtonPressedEvent.OnServerEvent:Connect(function(pl: Player, keyCode: Enum.KeyCode, keyIsDown: boolean)
	if pl.UserId ~= player.UserId then
		return
	end

	if keyCode == Enum.KeyCode.LeftShift and not keyIsDown then
		staminaChecking = false
		return
	end

	if keyCode == Enum.KeyCode.LeftShift and keyIsDown then
		staminaChecking = true
	end
end)

if conn == nil then
	return
end

if Status.stam.Value == -1 then
	return
end

---//playAnimation(character, 96901824097912, {e = 0, i = 1})

local RoundStartForKiller = require(ServerStorage.RoundStartForKiller)

print("StaminaAndHealth TESTED |", RoundStartForKiller:Animations(RoundStartForKiller:Classes()["Survivor"], player))

RunService.PreSimulation:Connect(function(dt)
    moving = humanoid.MoveDirection.Magnitude > 0
	running = staminaChecking and not(
		(function(h: Humanoid?): boolean
			local humanoid = h
			
			if humanoid == nil then
				warn("humanoid is nil")
				
				return false
			end

			if humanoid.MoveDirection.Magnitude == 0 then
				return false
			end

			local rootPart = character:WaitForChild("HumanoidRootPart")

			if not rootPart:IsA("BasePart") then
				error("why is Humanoid root part not a PART")
			end

			local move_dir: number = humanoid.MoveDirection:Dot(rootPart.CFrame.LookVector)

			return (move_dir * -1) > 0.5
		end)(character:FindFirstChildWhichIsA("Humanoid"))
	)

	-- LOCK SYSTEM
	if Status.stam.Value <= 0 and not staminaLocked then
		staminaLocked = true
		regenDelay = 3
	elseif Status.stam.Value >= 10 then
		staminaLocked = false
	end

	-- RUN
	_dt = dt
	updateAnim()

	updateGUI()
end)



