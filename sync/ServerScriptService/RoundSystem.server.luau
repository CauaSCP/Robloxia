local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local roundValues = ReplicatedStorage:WaitForChild("RoundValues")
local timeValue = roundValues:WaitForChild("TimeRemaining")
local phaseValue = roundValues:WaitForChild("Phase")
local roundValue = roundValues:WaitForChild("RoundNumber")

local roundStartForKiller = require(ServerStorage.RoundStartForKiller)

local function setDayLighting()
	Lighting.ClockTime = 14
	Lighting.Brightness = 2
	Lighting.Ambient = Color3.fromRGB(200, 200, 200)
	Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
	Lighting.FogEnd = 100000
end

local function setNightLighting()
	Lighting.ClockTime = 0
	Lighting.Brightness = 0.5
	Lighting.Ambient = Color3.fromRGB(50, 50, 70)
	Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 50)
	Lighting.FogEnd = 5000
end

local DAY_MIN = ((3 * 60) * 3.6) -- 60 -- 29
local DAY_MAX = DAY_MIN -- 90 -- 30
local NIGHT_BASE = 300
local NIGHT_PER_SURVIVOR = 40

local currentRound = 0

local function getDayDuration()
	return math.random(DAY_MIN, DAY_MAX)
end

local function getNightDuration()
	local playerCount = #Players:GetPlayers()
	local extraSurvivors = math.max(0, playerCount - 1)
	return NIGHT_BASE + (extraSurvivors * NIGHT_PER_SURVIVOR)
end

local function runCountdown(duration, phaseName)
	phaseValue.Value = phaseName

	if phaseName == "Day" then
		setDayLighting()
	elseif phaseName == "Night" then
		setNightLighting()
	end

	if Lighting.ClockTime == 0 then --// if it is night
		local players: {Player} = Players:GetPlayers()
		local killers: {[number]: roundStartForKiller.Killer}
			=
		{roundStartForKiller:Classes().Killer.new("K00lkid")}

		roundStartForKiller:Main(players, killers)
	end

	for i = duration, 0, -1 do
		timeValue.Value = i
		task.wait(1)
	end
end

while true do
	currentRound = currentRound + 1
	roundValue.Value = currentRound
	local dayDuration = getDayDuration()
	runCountdown(dayDuration, "Day")

	local nightDuration = getNightDuration()
	runCountdown(nightDuration, "Night")

	phaseValue.Value = "Transition"
	timeValue.Value = 0
	task.wait(3)
end