--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayAnimationObj = require(ReplicatedStorage.PlayAnimation.Self)

local AnimationValues = ReplicatedStorage.AnimationValues

local ValuesModuleInst = AnimationValues.Self
local ValuesModule = require(ValuesModuleInst)

local PlayAnimationClientSide = PlayAnimationObj()

local msg = tostring("play animation is %sclient side connected!")

if PlayAnimationClientSide() then
    warn(msg:format(''))
else
    error(msg:format('not '))
end

ValuesModule()