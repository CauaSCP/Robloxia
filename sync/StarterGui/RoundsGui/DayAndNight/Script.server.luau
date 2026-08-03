local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local roundValues = ReplicatedStorage:WaitForChild("RoundValues")
local phaseValue = roundValues:WaitForChild("Phase")

local label = script.Parent
local phaseColorsParent = ServerStorage:WaitForChild("PhasesColors")

local function updateColor()
	local colorValue: Instance? = phaseColorsParent:FindFirstChild(label.Text)
	
	if colorValue ~= nil and colorValue:IsA("Color3Value") then
		label.TextColor3 = colorValue.Value
	end
end

local function update()
	if phaseValue.Value == "Day" then
		label.Text = "Day"
	else
		label.Text = "Night"
	end
	
	updateColor()
end

phaseValue.Changed:Connect(update)
update()