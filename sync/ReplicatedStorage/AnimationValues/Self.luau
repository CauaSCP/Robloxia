--!nonstrict

export type aTrack = AnimationTrack|number|nil

export type Tracks = {
	[string]: aTrack,

	Idle: aTrack,
	Walk: aTrack,
	Run: aTrack,
}

local players = game:GetService("Players")

export type Main = (t: Tracks, names: {string}) -> {aTrack}

local LOCAL_PLAYER = players.LocalPlayer

local function scriptFolderScriptFromLocal()
	return LOCAL_PLAYER.PlayerGui.StaminaNhealth.ScriptFolder:WaitForChild("StaminaAndHealthServer")
end

local _main = function<T>(t: T|Tracks|{[any|string]: aTrack}, names: {string})
	assert(type(t) == "table", `simple type of parameter is not a table but a {type(t)}`)

	local result = {}
	for i, nam in ipairs((names) :: {string}) do

		local inst = nil
		inst = (t[nam] :: any) :: aTrack|nil

		if inst ~= nil then
			table.insert(result, inst::aTrack)
			continue
		end

		inst = scriptFolderScriptFromLocal():FindFirstChild(nam) :: aTrack
		table.insert(result, inst::aTrack)
	end

	return result
end

local main: Main = function(t: Tracks, names: {string})
	return _main(t, names)
end

local AnimationValues = function()
	script.Parent.OnInvoke = main
end

return AnimationValues
