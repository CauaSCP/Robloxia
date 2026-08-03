local RoundStartForKiller = {}

type IDsPool = {
	__type: "Killer.IDsPool",
	mask: number,
	new: () -> IDsPool,
	Allocate: (self: IDsPool) -> (number),
	Free: (self: IDsPool, bitIndex: number) -> ()
}

local IDsPool = {}
IDsPool.__index = IDsPool
IDsPool.__type = "Killer.IDsPool"

function IDsPool.new(): IDsPool
	local self = setmetatable({
		mask = 0
	}, IDsPool)

	return (self :: any) :: IDsPool
end

local bitlimit = (script.Bitlimit.Value - 1)

function IDsPool:Allocate()
	local i: number| nil = nil

	for j = 0, bitlimit do
		local bit_val = 2 ^ j

		if (self.mask % (bit_val * 2)) < bit_val then
			self.mask = self.mask + bit_val

			i = j; break
		end
	end

	if i == nil then
		error(`Killers limit of {bitlimit + 1} has been reached!`)
	end

	return i
end

function IDsPool:Free(bitIndex: number)
	local val = 2 ^ bitIndex

	if (self.mask % (val * 2)) >= val then
		self.mask = self.mask - val
	end
end

export type GetName = (self: nil|{[any|nil]: any|nil}) -> string

export type Killer = {
	__type: "Killer",
	new: (name: string) -> Killer,

	GetKillerHumanoid: (self: Killer) -> Humanoid,

	isKiller: (other: any|Killer|nil) -> boolean,

	GetName: (self: Killer) -> string,
	Enum: (self: Killer) -> number,
	IDsPool: () -> IDsPool
}

type _Killer = {
	_name: nil|string,
	_enum_index: nil|number,
	[string]: any
}
local _Killer = {
	_hum = nil,
	_name = nil,
	_enum_index = nil,

	__type = "Killer",

	__tostring = function(tab)
		return tab._name
	end
}

_Killer.__index = function(tab, ind: number)
	local key: any = ind

	local res: string

	if typeof(key) ~= "number" then
		if key == "__type" then
			return _Killer.__type
		end

		return _Killer[key]
	end

	res = string.sub(tab._name, ind)

	return res
end

local IDsPoolInstance: IDsPool = IDsPool.new()
function _Killer.IDsPool(...: any|nil)
	return IDsPoolInstance
end

function _Killer.new(name: string): Killer
	local ids_pool: IDsPool = _Killer.IDsPool()

	local typ = typeof(name)

	assert(typ == "string", `the type for killer name is not a string but one {typ}...`)

	local self = setmetatable({}, _Killer)
	self._name = name

	local res = (self :: any) :: Killer
	self._enum_index = ids_pool:Allocate()

	return res
end

function _Killer.GetName(self: Killer): string
	return tostring(self)
end

function _Killer.Enum(self: Killer): number
	local cur = (self :: any) :: _Killer

	local res = cur._enum_index

	assert(res ~= nil, `Enum for {self:GetName()} is Null value!`)

	return (res :: number)
end

local Killer: Killer = (_Killer :: any) :: Killer

function Killer.isKiller(other: any|Killer|nil): boolean
	return other.__type == Killer.__type
end

function RoundStartForKiller:Classes()
	local res = {}

	local other = "Survivor"

	local getName: GetName = function(self: any|nil): string
		return `@{other}`
	end
	res.Killer = Killer

	res[other] = {
		GetName = getName,
		__type = other
	}

	return res
end


RoundStartForKiller._random = Random.new()

function RoundStartForKiller:ChooseRandomOne<T>(table_value: {any}): any
	local res: any

	if typeof(table_value) == "table" then
		local ind: number = self._random:NextInteger(1, #table_value)

		res = table_value[ind]
	else
		error(`RoundStartForKiller.ChooseRandomOne(table_value) can not return a {typeof(table_value)}!`)
	end

	return res
end

local debris = game:GetService("Debris")
local server_scripts = game:GetService("ServerScriptService")
local chosen_system_sc = server_scripts:WaitForChild("ChosenTextSystem")
local folder_val: ObjectValue = chosen_system_sc:WaitForChild("FolderVal")

type ChosenImage = {
	self: ImageLabel,
	parent: Folder|Instance
}

local chosen_image: ChosenImage = {} :: ChosenImage
chosen_image.parent = (function(): Folder|Instance
	local v = folder_val.Value

	assert(v ~= nil and v:IsA("Folder"), "ChosenImage parent is wrong "..typeof(v))

	return v
end)()

chosen_image.self = chosen_image.parent:WaitForChild("ChosenImg") :: ImageLabel

function RoundStartForKiller.godMode(player: Player): Humanoid
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:FindFirstChildOfClass("Humanoid")

	assert(hum ~= nil, `humanoid does not exist for {player.Name}`)

	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum.BreakJointsOnDeath = false

	hum.HealthChanged:Connect(function()
		hum.Health = hum.MaxHealth
	end)

	return hum
end

local function _killerMorph(killer: Killer, player: Player)
	local hum = RoundStartForKiller.godMode(player)

	local killer_morph: Model|Instance|nil = game.Workspace:FindFirstChild(killer:GetName())

	assert(
		(killer_morph ~= nil and killer_morph:FindFirstChildOfClass("Humanoid")),
		`killer with the name {killer:GetName()} does not exist in workspace`
	)

	local humClone: Humanoid|nil = killer_morph:FindFirstChildOfClass("Humanoid")
	local kiler_morph_clone: Model = (humClone::any).Parent:Clone() :: Model

	print(kiler_morph_clone)

	humClone = kiler_morph_clone:WaitForChild("Humanoid") :: Humanoid

	hum.JumpPower = 0
	hum.WalkSpeed = 0

	local humPar = hum.Parent
	local current_position: CFrame|nil = nil
	if humPar:IsA("Model") then
		current_position = humPar:GetPivot()
	end

	assert(humPar:IsA("Model"), `Humanoid parent for {player} is not a Model`);

	(humClone::Humanoid).DisplayName = killer:GetName()
	kiler_morph_clone.Name = player.Name
	player.Character = kiler_morph_clone

	kiler_morph_clone:PivotTo(current_position :: CFrame)
	kiler_morph_clone.Parent = game.Workspace

	local root_part: BasePart = kiler_morph_clone:WaitForChild("HumanoidRootPart") :: BasePart
	root_part.Anchored = false

	task.wait()

	killer._hum = RoundStartForKiller.godMode(player)

	local _GetKillerHumanoid = function(self: Killer|{_hum: Humanoid|any|nil}): Humanoid
		local val_hum: Humanoid|any|nil = self._hum

		local err = `{(self::Killer):GetName()} has no character's humanoid`

		if typeof(val_hum) ~= "Instance" then
			error(err)
		end

		if not val_hum:IsA("Humanoid") then
			error(err)
		end

		return (val_hum :: Humanoid)
	end

	killer.GetKillerHumanoid = _GetKillerHumanoid

	humPar:Destroy()
end

local storage = game:GetService("ServerStorage")
local function GetCurrentKillerInstance(	sv_st: ServerStorage, on_invoke: (  (...any) -> ...any  )|nil	)
	local foo_inst: Instance? = sv_st.GetCurrentKiller
	local is_changeable: Instance? = foo_inst.IsChangeable

	if is_changeable ~= nil then
		assert(is_changeable:IsA("BoolValue"), `IsChangeable is not a BoolValue`)
		assert(foo_inst:IsA("BindableFunction"), `ServerStorage.GetCurrentKiller is not a BindableFunction`)

		if not is_changeable.Value then
			local success = pcall(function()
				foo_inst.OnInvoke = on_invoke
			end)

			if success then
				return
			end
		end

		if on_invoke == nil then
			pcall(function()
				foo_inst.OnInvoke = nil
			end)

			is_changeable.Value = false
		end
	else
		error(`{foo_inst} doesn't have a child called IsChangeable`)
	end
end

function RoundStartForKiller:Main(players_list: {Player}, killers_list: {Killer})
	local player_will_be: Player|nil = (self:ChooseRandomOne(players_list))

	assert(

		typeof(player_will_be) == "Instance" and (player_will_be :: Instance):IsA("Player")
		,
		`parsed players list isn't of players but a list of '{typeof(player_will_be)}'...`

	)

	local player_final: Player = player_will_be :: Player

	local enums: {[number]: boolean|nil} = {}

	local enumInsert = function(b: boolean, n: number)
		n = n or 1

		enums[n] = b
	end

	for _, k in ipairs(killers_list) do
		local i = k:Enum()

		assert((enums[i]) ~= true, `the enum index {i} already exists ({k:GetName()})`)

		if enums[1] == nil then
			enumInsert(true)
		end

		if enums[i] == nil then
			enumInsert(true, i)
		end
	end

	local killer_will_be = self:ChooseRandomOne(killers_list)

	local typ = killer_will_be.__type
	if typ == nil then
		typ = typeof(killer_will_be)
	end

	assert(

		self:Classes().Killer.isKiller(killer_will_be)
		,
		`parsed killers list isn't of killers but a list of '{typ}'...`

	)

	local img = chosen_image.self:Clone()

	img.Parent = player_final.PlayerGui:WaitForChild("ChosenKillerGui")

	task.spawn(function()
		debris:AddItem(img, 0.015)
		task.wait(0.03)

		_killerMorph(killer_will_be, player_final)

		RoundStartForKiller:Animations(killer_will_be, player_final)
	end)
end

function RoundStartForKiller:Animations(classe: {GetName: GetName|nil, [any|nil]: any|nil}|Killer, player: Player)
	local animationIds = {
		Idle = -1,
		Walk = -1,
		Run  = -1
	}

	local _other = nil

	local classeGottenName: string|nil|any = nil
	if classe.GetName ~= nil then
		classeGottenName = ((classe.GetName :: any))()

		if classeGottenName ~= nil and typeof(classeGottenName) == "string" then
			_other = classeGottenName
		end
	end

	if _other ~= nil then
		animationIds.Idle = 96901824097912
		animationIds.Walk = 115078091577032
		animationIds.Run  = 71193544003604
	end
	
	local is_killer = self:Classes().Killer.isKiller(classe)
	
	print("is killer:", is_killer)

	if is_killer then
		local killer = classe :: Killer

		GetCurrentKillerInstance(storage, function(): Killer
			return Killer
		end)

		local char = player.Character or player.CharacterAdded:Wait()
		local player_of_char: ObjectValue? = char:FindFirstChild("PlayerOfChar", true)
		if player_of_char ~= nil then
			player_of_char.Value = player
		end

		animationIds.Idle = 83117640333496
		animationIds.Walk = 79945063702141
		animationIds.Run = 88659174463260

		-- print(
		-- 	"display name:",
		-- 	(player.Character:WaitForChild("Humanoid") :: Humanoid).DisplayName
		-- )

	--print("run", animationIds.Run, killer.IDsPool())
	end
	
	
	local guis = player:FindFirstChildOfClass("PlayerGui")

	assert(guis, `PlayerGui not found for {player.Name}`)

	local ids_parent: Instance? = guis.StaminaNhealth.ScriptFolder:WaitForChild("StaminaAndHealthServer")

	local id_val: IntValue|nil

	local num: number?

	for name, id in pairs(animationIds) do
		id_val = ids_parent:FindFirstChild(name)

		num = id_val.Value

		if num ~= id then
			id_val.Value = id
		end
	end
end

return RoundStartForKiller