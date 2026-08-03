local storage = game:GetService("ServerStorage")

local players = game:GetService("Players")
local char = script:FindFirstAncestorWhichIsA("Model")
local player = players:GetPlayerFromCharacter(char)

local things_to_clone: {Tool} = {}

for _, c in ipairs(storage:WaitForChild("ConsumablesFolder"):GetChildren()) do
	if c:IsA("Tool") then
		table.insert(things_to_clone, c)
	end
end

while #(things_to_clone) > 0 do
	local clon = table.remove(things_to_clone):Clone()
	
	if char:FindFirstChildWhichIsA("BasePart") then
		clon.Parent = player.Backpack
	end

	wait(1/600)
end