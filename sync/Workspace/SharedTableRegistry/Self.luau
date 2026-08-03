local _SharedTableRegistry_Real = game:GetService("SharedTableRegistry")
local _SharedTableRegistry = {}

local api_data_module = require(game.Workspace.SharedTableRegistry._Other)
local api_data: {[string]: {[number]: {[string]: {[number]: any}|string}}}|nil = api_data_module()

local data_store_service: DataStoreService = game:GetService("DataStoreService")
local caching: DataStore

local _sucess, _msg = pcall(function()
	caching = data_store_service:GetDataStore("caching")
	caching:SetAsync("_", -1)
end)
local service_try: {
	success: boolean?,
	message: string
} = {}
service_try.success = _sucess
service_try.message = ""
if typeof(_msg) == "string" then  service_try.message =_msg  end

if service_try.success == false and service_try.message ~= "" then
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		player:Kick(service_try.message)
	end
	
	error()
end

task.spawn(function()
	caching:RemoveAsync("_")
end)

local function checkClasses(key_name: string)
	local name = "SharedTableRegIndex"

	local success: boolean|nil = nil
	local cached_index: number|nil = nil

	task.spawn(function()
		success = pcall(function()
			cached_index = caching:GetAsync(name)
		end)
	end)

	while true do
		if success ~= nil then
			break
		end

		wait()
	end

	local classes_from_api = api_data[key_name]

	local member_name: string

	local function contentParser(content, use_pcall: boolean)
		if use_pcall ~= true then
			use_pcall = false
		end

		local function member_setter()
			_SharedTableRegistry[member_name] = _SharedTableRegistry_Real[member_name]
		end

		local pcall_foo

		if use_pcall then
			pcall_foo = function()
				local s, e = pcall(function()
					member_setter()
				end)

				return table.unpack({s, e})
			end
		else
			pcall_foo = function()
				member_setter()

				return table.unpack({true, "nil"})
			end
		end

		for _, member in ipairs(content["Members"]) do
			member_name = member["Name"]

			local success, err = pcall_foo()

			if not success then
				print("name:", member_name, "|", "reason:", err)
			end
		end
	end

	local instance_members_parent = classes_from_api[1]
	contentParser(instance_members_parent, true)

	local function redo_cache()
		for i, content in ipairs(classes_from_api) do
			if type(content) ~= "table" then
				continue
			end

			if content["Name"] == "SharedTableRegistry" then
				caching:SetAsync(name, i)

				contentParser(content)
			end
		end
	end

	if cached_index == nil then
		redo_cache()
	else
		local content_to_parse = classes_from_api[cached_index]

		if type(content_to_parse) == "table" and content_to_parse["Name"] == "SharedTableRegistry" then
			contentParser(content_to_parse)
		else
			redo_cache()
		end
	end
end

for key_name, _ in pairs(api_data) do
	if key_name == "Classes" then
		checkClasses(key_name)
		break
	end
end

-- print(_SharedTableRegistry)

export type __func_any = (arg1: any|nil|"inexistent", other_args: {any|nil|"inexistent"}) -> any|nil

local SharedTableRegistryClass = {}
SharedTableRegistryClass.__real__ = _SharedTableRegistry

local function getReal(): SharedTableRegistry
	return SharedTableRegistryClass.__real__
end

local foos: {[string]: __func_any} = {}
for name, val in pairs(_SharedTableRegistry) do
	if type(val) == "function" then
		local foo: __func_any = val

		foos[name] = function(...)
			local args = table.pack(...)
			local test_self = args[1]

			if test_self == SharedTableRegistryClass then
				test_self = _SharedTableRegistry_Real

				print("[SharedTableCustom]:", name)
				print("[SharedTableCustom]:", args)

				local func = _SharedTableRegistry_Real[name]

				print("[SharedTableCustom]:", func)

				local res = func(_SharedTableRegistry_Real, table.unpack(args, 2))

				print(string.format("[SharedTableCustom] result for [%s]:", name), res)

				if res ~= nil then
					return res
				end

				return
			end

			return foo(...)
		end

		local final_foo: any = foos[name]

		SharedTableRegistryClass[name] = final_foo

		continue
	end

	SharedTableRegistryClass[name] = val
end


local table_types: {[string]: boolean?} = {}

table_types["SharedTable"] = true
table_types["table"] = true
table_types["nil"] = true

local name_registered_ones = "__RegisteredOnes__"
local _registered_ones = SharedTable.new()
SharedTableRegistryClass:SetSharedTable(name_registered_ones, _registered_ones)

local registered_ones: {[string]: number} = {}
registered_ones = _SharedTableRegistry_Real:GetSharedTable(name_registered_ones)

function SharedTableRegistryClass.SetSharedTable(self, name: string, theSharedTable: {[any]: any}|nil|SharedTable)
	if not(type(name) == "string" and (table_types[typeof(theSharedTable)] == true)) then

		error([[ERROR: argument(s) type(s) wrong;
^name should be {string};
^theSharedTable shound be @in {table|SharedTable|nil};

]])

	end

	if type(theSharedTable) == "table" then
		local frozen = table.isfrozen(theSharedTable)

		theSharedTable = SharedTable.new(theSharedTable)
		if frozen then
			theSharedTable = SharedTable.cloneAndFreeze(theSharedTable, true)
		end
	end

	_SharedTableRegistry_Real:SetSharedTable(name, theSharedTable)

	registered_ones[name] = 1

	-- print("gotten shared table that was set:", _SharedTableRegistry_Real:GetSharedTable(name))
end

SharedTableRegistryClass.__index = SharedTableRegistryClass

local SharedTableRegistry_Service = _SharedTableRegistry_Real

local setAux: (() -> nil)|nil = nil
local function setAuxPlus()
	if setAux ~= nil and typeof(setAux) == "function" then
		setAux()
	end
end

local cases: {[boolean|number]: (() -> nil)|nil} = {}

cases[true] = setAuxPlus
cases[1] = setAuxPlus

local GetRegisteredSharedTables: (self: any|string, name: string, _unuseds: {nil|"useless"}) -> (() -> boolean) = function(self: string|any, ...): (() -> boolean)
	local registered_one_name: string = nil

	if typeof(self) == "string" then
		registered_one_name = self
	else
		local args = table.pack(...)

		registered_one_name = args[1]
	end

	if registered_one_name == nil then
		error("no name argument put in SharedTableRegistry_Service.GetRegisteredSharedTables(...)")
	end

	if typeof(registered_one_name) ~= "string" then

		error([[the argument parsed is wrong in:
\t-- SharedTableRegistry_Service.GetRegisteredSharedTables( ]]..tostring(registered_one_name).." )")

	end

	local aux: any = nil

	setAux = function()
		aux = registered_one_name
	end

	local test: number|boolean|nil = SharedTableRegistry_Service:GetSharedTable(name_registered_ones)[registered_one_name]

	if test ~= nil then
		local foo = cases[test]

		if foo ~= nil then
			foo()
		end
	end

	local res = function(): boolean
		return aux == registered_one_name
	end

	return res
end

export type SharedTableRegistryCustom = {
	[string]: {[string]: __func_any}|__func_any
}

local SharedTableRegistryCustom = {}

SharedTableRegistryCustom["Serv"] = SharedTableRegistryClass
SharedTableRegistryCustom.Serv.GetRegisteredSharedTables = GetRegisteredSharedTables
SharedTableRegistryCustom["Service"] = SharedTableRegistryCustom.Serv

SharedTableRegistryCustom.GetRegisteredSharedTables = GetRegisteredSharedTables
--function SharedTableRegistryCustom:GetRegisteredSharedTables(...)
--	local SELF: string|any = self

--	return GetRegisteredSharedTables(SELF, ...)
--end

function SharedTableRegistryCustom.GetSharedTable(self: SharedTableRegistryCustom|any, name: string)
	local res = SharedTableRegistryCustom.Serv:GetSharedTable(name)

	print("result:", res)

	return res
end

function SharedTableRegistryCustom.SetSharedTable(self: SharedTableRegistryCustom|any, name: string, theSharedTable: {[any]: any}|nil|SharedTable)
	SharedTableRegistryCustom.Serv:SetSharedTable(name, theSharedTable)
end

--SharedTableRegistryCustom.SetSharedTable = SharedTableRegistry_Service.SetSharedTable

return SharedTableRegistryCustom