---@diagnostic disable: undefined-type
local replicated_storage = game:GetService("ReplicatedStorage")
local callStack = require(replicated_storage.PlayAnimation.Call)

local playAnimation: callStack.__CallResult<AnimationTrack> = callStack()

return playAnimation
