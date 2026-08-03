local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationValues = ReplicatedStorage.AnimationValues

local ValuesModuleInst = AnimationValues.Self
local ValuesModule = require(ValuesModuleInst)

return ValuesModule()