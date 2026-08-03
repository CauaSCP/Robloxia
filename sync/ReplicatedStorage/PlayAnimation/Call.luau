--!strict

type char = 'char'
type bin_bool = 'bin_bool'

export type __CallResult<T> = (character: Model, animation: number|Animation, idleAndEmoteBins: {[string]: number}|{[char]: bin_bool}) -> T|any

local players = game:GetService("Players")

local function PlayAnimationCall<T>(): __CallResult<T>
	local loc_pl = nil
	local is_a_local = not(pcall(function()
		loc_pl = players.LocalPlayer
	end))
	
	if loc_pl == nil then
		is_a_local = false
	end


	assert(is_a_local ~= true, `is not being called in a Server script`)
	

	local function result<T>(character: Model, animation: number|Animation, idleAndEmoteBins: {[string]: number}|{[char]: bin_bool}): T|any
		warn(`\n{debug.traceback()} -- traceback`)
		
		local players_list = players:GetPlayers()

        local func = script.Parent
        if #(players_list) == 0 then
            warn(`there are no players... [{func:GetFullName()}]`)
		end
		
		print("çAnimation:", animation)

		local res = func:InvokeClient(players_list[1], character, animation, idleAndEmoteBins)

        if #(players_list) < 2 then
            return res
        end

        for i = 2, #(players_list) do
			func:InvokeClient(players_list[i], character, animation, idleAndEmoteBins)
        end

        return res
	end
	
	assert(typeof(result) == "function", "")

    return result
end

return PlayAnimationCall
