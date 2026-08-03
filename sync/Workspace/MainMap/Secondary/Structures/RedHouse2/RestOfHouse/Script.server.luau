local house = script.Parent
local TweenService = game:GetService("TweenService")

local info = TweenInfo.new(
	2,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

local goal = {
	Position = house.Position + Vector3.new(0, 88, 0)
}

local tween = TweenService:Create(house, info, goal)
tween:Play()
