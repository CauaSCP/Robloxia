local button = script.Parent
local buttonPosition = button.Position
local buttonSize = button.Size

button.touched:Connect(function()
	local tween = game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {Position = buttonPosition - UDim2.new(0, 0, 0.01, 0)})
end)