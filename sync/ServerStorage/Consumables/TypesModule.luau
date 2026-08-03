--!strict

local module = {}

export type CurrentVal = number

export type ResultValue = number

local startings =	
	{0100,0100,000,000,000,00000}


local _max_values =
	{0100,0100,050,080,050,00004}


module._Status =
	"stam|food|res|inv|strength|speed"

export type Status = "StatusString"

local max_values: {[Status|string]: number} = {}

module.start_values = table.clone(max_values)
module.max_values = max_values


for ind, st in string.split(module._Status, "|") do
	module.max_values[st] = _max_values[ind]
	module.start_values[st] = startings[ind]
end

export type GetStatus = () -> {
	MAX: {[string]: number},
	[string]: {
		Value: number
	}
}

export type Method = (currentVal: CurrentVal) -> (ResultValue|"ResultValue"|number)

export type CalcMethods = {[Status|string]: Method}

return module
