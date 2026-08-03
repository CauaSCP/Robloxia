-- --
--[[   --!strict	]]
--!strict

type _self_type = BaseScript|Script

export type ID = number|string

export type main = (_self: _self_type) -> (boolean)

export type ChangeTextureBloxyCola = {
	[string]: main|ID|'list'

	,

	main: main,
	bloxy_cola_id: ID,
	fallback_id: ID

	,

	['all: [bloxy_cola_id, fallback_id, main]']																																																																																																											: [[What am I?I am the list with all the ChangeTextureBloxyCola module usable children]]|''

}


local request = game:GetService("HttpService")

local module: (ChangeTextureBloxyCola|{[any]: any}) = {
	bloxy_cola_id = "",
	main = function() end,
	['all: [bloxy_cola_id, fallback_id, main]'] = ''
}

module.bloxy_cola_id = ""..84119663076633
module.fallback_id = ""..10470600

local _start_of_url = "https://assetdelivery.rotunnel.com/v1/asset/?id="
local _main: main = function(_self: _self_type)
	local bloxy_cola_id = module.bloxy_cola_id
	local fallback_id = module.fallback_id

	local self: _self_type = _self

	local url = _start_of_url..bloxy_cola_id
	local options = {
		Url = url,
		Method = "GET"
	}

	local status_parent: {
		[string]: any,
		StatusCode: number?
	} = {
		StatusCode = -1
	}

	pcall(function()
		status_parent = request:RequestAsync(options)
	end)

	local status_code: number? = status_parent["StatusCode"]

	local par: SpecialMesh|Instance|nil

	par = self.Parent

	local id_to_set: ID = bloxy_cola_id
	if not(type(status_code) == "number" and status_code >= 200 and status_code < 300) then
		id_to_set = fallback_id
	end

	if par ~= nil and par:IsA("SpecialMesh") then
		par.TextureId = "rbxassetid://"..id_to_set
	end

	local type_of_id: string

	if id_to_set == bloxy_cola_id then
		type_of_id = "our texture!"
	else
		type_of_id = "fallback one!"
	end

	print(">DEBUG: Bloxy Cola texture set to "..type_of_id)

	return true
end
local main: main = function(_self: _self_type)
	local res = nil

	_main(_self)

	game:GetService("RunService").Heartbeat:Connect(function()
		local now = DateTime.now()
		local mins = tonumber(now:FormatUniversalTime("mm", "en-us"))

		if mins ~= nil and mins >= 59 then
			res = _main(_self)
		end 
	end)

	while true do
		if res ~= nil then
			return res
		end

		task.wait()
	end
end

module.main = main
module = table.freeze(module)

local ChangeTextureBloxyCola: ChangeTextureBloxyCola = module

return ChangeTextureBloxyCola
