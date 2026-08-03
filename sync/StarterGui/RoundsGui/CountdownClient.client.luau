local ReplicatedStorage = game:GetService("ReplicatedStorage")

local roundValues = ReplicatedStorage:WaitForChild("RoundValues")
local timeValue = roundValues:WaitForChild("TimeRemaining")
local phaseValue = roundValues:WaitForChild("Phase")
local roundValue = roundValues:WaitForChild("RoundNumber")
local countdownLabel = script.Parent:WaitForChild("CountdownLabel")

local function formatTime(seconds)
	local mins = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%d:%02d", mins, secs)
end

local function updateDisplay()
	local phase = phaseValue.Value
	local time = timeValue.Value
	local round = roundValue.Value
	
	if time > 0 then
		if phase == "Day" then
			countdownLabel.Text = "Intermission: " .. formatTime(time)
		else
			countdownLabel.Text = "Round ends in: " .. formatTime(time)
		end
	else
		countdownLabel.Text = "..."
	end
	
	countdownLabel.BackgroundColor3 = Color3.new(0, 0, 0)
	
	if time <= 30 then
		countdownLabel.TextColor3 = Color3.new(1, 0.3, 0.3)
	elseif time <= 60 then
		countdownLabel.TextColor3 = Color3.new(1, 1, 0.3)
	else
		countdownLabel.TextColor3 = Color3.new(1, 1, 1)
	end
end

timeValue.Changed:Connect(updateDisplay)
phaseValue.Changed:Connect(updateDisplay)
roundValue.Changed:Connect(updateDisplay)

updateDisplay()