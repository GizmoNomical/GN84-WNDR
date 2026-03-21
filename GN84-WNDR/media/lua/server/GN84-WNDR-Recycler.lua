-- #########################################################################################################
-- #########################################################################################################
-- ##                                                                                                     ##
-- ##                                                                                                     ##
-- ##       _____   _                              _   _                       _                  _       ##
-- ##      / ____| (_)                            | \ | |                     (_)                | |      ##
-- ##      | |  __   _   ____  _ __ ___     ___   |  \| |   ___    _ __ ___    _    ___    __ _  | |      ##
-- ##      | | |_ | | | |_  / | '_ ` _ \   / _ \  | . ` |  / _ \  | '_ ` _ \  | |  / __|  / _` | | |      ##
-- ##      | |__| | | |  / /  | | | | | | | (_) | | |\  | | (_) | | | | | | | | | | (__  | (_| | | |      ##
-- ##      \_____ | |_| /___| |_| |_| |_|  \___/  |_| \_|  \___/  |_| |_| |_| |_|  \___|  \__,_| |_|      ##
-- ##                                                                                                     ##
-- ##                               Copyright © GizmoNomical - 2025                                       ##
-- ##                                           GN84-WNDR                                                 ##
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################


local Utils = require "Gizmo/GN84LIB_Utils"

------------------------------------------------------------------------
--                     SHREDDING AND RECYCLING
------------------------------------------------------------------------

local recyclerValueMultiplier = SandboxVars.GN84WNDR.RecyclerValueMultiplier	or 1.0
local recyclerTimeout = SandboxVars.GN84WNDR.RecyclerTimeout					or 5
local watchesMinValue = SandboxVars.GN84WNDR.WatchesMinValue					or 3
local watchesMaxValue = SandboxVars.GN84WNDR.WatchesMaxValue					or 10
local jewelrySimpleMinValue = SandboxVars.GN84WNDR.JewelrySimpleMinValue 		or 1
local jewelrySimpleMaxValue = SandboxVars.GN84WNDR.JewelrySimpleMaxValue 		or 5
local jewelryPreciousMinValue = SandboxVars.GN84WNDR.JewelryPreciousMinValue 	or 10
local jewelryPreciousMaxValue = SandboxVars.GN84WNDR.JewelryPreciousMaxValue 	or 50
local jewelryGemsMinValue = SandboxVars.GN84WNDR.JewelryGemsMinValue 			or 25
local jewelryGemsMaxValue = SandboxVars.GN84WNDR.JewelryGemsMaxValue 			or 100
local jewelryDiamondMinValue = SandboxVars.GN84WNDR.JewelryDiamondMinValue 		or 100
local jewelryDiamondMaxValue = SandboxVars.GN84WNDR.JewelryDiamondMaxValue 		or 200

local simpleToolMinValue = SandboxVars.GN84WNDR.SimpleToolMinValue 				or 1
local simpleToolMaxValue = SandboxVars.GN84WNDR.SimpleToolMaxValue 				or 10
local largeToolMinValue = SandboxVars.GN84WNDR.LargeToolMinValue 				or 10
local largeToolMaxValue = SandboxVars.GN84WNDR.LargeToolMaxValue 				or 40
local complexToolMinValue = SandboxVars.GN84WNDR.ComplexToolMinValue 			or 40
local complexToolMaxValue = SandboxVars.GN84WNDR.ComplexToolMaxValue 			or 100

local leatherMinValue = SandboxVars.GN84WNDR.LeatherMinValue 					or 20
local leatherMaxValue = SandboxVars.GN84WNDR.LeatherMaxValue 					or 50

local clothingMinValue = SandboxVars.GN84WNDR.ClothingMinValue 					or 5
local clothingMaxValue = SandboxVars.GN84WNDR.ClothingMaxValue 					or 25

local bulletVestMinValue = SandboxVars.GN84WNDR.BulletVestMinValue 				or 100
local bulletVestMaxValue = SandboxVars.GN84WNDR.BulletVestMaxValue 				or 250

local glassesMinValue = SandboxVars.GN84WNDR.GlassesMinValue 					or 5
local glassesMaxValue = SandboxVars.GN84WNDR.GlassesMaxValue 					or 20

local paperProductMinValue = SandboxVars.GN84WNDR.PaperProductMinValue 			or 5
local paperProductMaxValue = SandboxVars.GN84WNDR.PaperProductMaxValue 			or 10

local lowElectronicsMinValue = SandboxVars.GN84WNDR.LowElectronicsMinValue 		or 15
local lowElectronicsMaxValue = SandboxVars.GN84WNDR.LowElectronicsMaxValue 		or 35

local highElectronicsMinValue = SandboxVars.GN84WNDR.HighElectronicsMinValue 	or 50
local highElectronicsMaxValue = SandboxVars.GN84WNDR.HighElectronicsMaxValue 	or 100

local MS_TO_MINUTES = 60000

local CreateCash
local AttractZombiesToRecycler









------------------------------------------------------------------------
--                          
--                          
--                          TIMED ACTIONS  
--                          
--                          
------------------------------------------------------------------------

require "TimedActions/ISBaseTimedAction"


------------------------------------------------------------------------
--                         POWER ON RECYCLER
------------------------------------------------------------------------

PowerOnTimedAction = ISBaseTimedAction:derive("PowerOnTimedAction")

function PowerOnTimedAction:isValid() -- Check if the action can be done
	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  115  |  FUNCTION:  PowerOnTimedAction:start  |  ERROR:  modData is Invalid or Missing")
		return false
	end

	local username = self.character:getUsername()

	if modData.CurrentUser == nil then
		return true
	elseif modData.CurrentUser ~= nil and modData.CurrentUser == username then
		return true
	elseif modData.CurrentUser ~= nil and modData.CurrentUser ~= username then
		return false
	end

    return true
end

function PowerOnTimedAction:update() -- Trigger every game update when the action is perform
    -- print("Action is update")
	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  115  |  FUNCTION:  PowerOnTimedAction:update  |  ERROR:  modData is Invalid or Missing")
		return
	end

	if modData.CurrentUser ~= nil and modData.CurrentUser ~= self.character:getUsername() then
		print("Lost Recycler Lock Mid-Action, Cancelling")
		self:forceStop()
	end
end

function PowerOnTimedAction:waitToStart() -- Wait until return false
    return false
end

function PowerOnTimedAction:start() -- Trigger when the action start
    -- print("Action start")
	
	self.character:faceThisObject(self.recycler)

	sendClientCommand("GN84-WNDR", "RequestRecyclerLock",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		username = self.character:getUsername()
	})
end

function PowerOnTimedAction:stop() -- Trigger if the action is cancel
    -- print("Action stop")
	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  115  |  FUNCTION:  PowerOnTimedAction:stop  |  ERROR:  modData is Invalid or Missing")
		return
	end

	if modData.CurrentUser == self.character:getUsername() then
		modData.CurrentUser = nil
		sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = self.recycler:getItem():getID(), X = self.recycler:getX(), Y = self.recycler:getY(), Z = self.recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = modData.CurrentUser, RecyclerLastUsed = modData.RecyclerLastUsed })
	end


    ISBaseTimedAction.stop(self)
end

function PowerOnTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	print("Recycler Powered On")
	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  115  |  FUNCTION:  PowerOnTimedAction:perform  |  ERROR:  modData is Invalid or Missing")
		return
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		print("Recycler Lock Lost, Aborting Action")
		return
	end

	AttractZombiesToRecycler(self.character)	
	modData.RecyclerEnabled = true
	modData.RecyclerLastUsed = getTimeInMillis()
	modData.CurrentUser = self.character:getUsername()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = self.recycler:getItem():getID(), X = self.recycler:getX(), Y = self.recycler:getY(), Z = self.recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = modData.CurrentUser, RecyclerLastUsed = modData.RecyclerLastUsed })

    ISBaseTimedAction.perform(self)
end

function PowerOnTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 120 -- Time take by the action
    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o;
end

------------------------------------------------------------------------
--                         POWER OFF RECYCLER
------------------------------------------------------------------------

PowerOffTimedAction = ISBaseTimedAction:derive("PowerOffTimedAction")

function PowerOffTimedAction:isValid() -- Check if the action can be done
    return true
end

function PowerOffTimedAction:update() -- Trigger every game update when the action is perform
    -- print("Action is update")
end

function PowerOffTimedAction:waitToStart() -- Wait until return false
	local modData = self.recycler:getItem():getModData()
	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  180  |  FUNCTION:  PowerOffTimedAction:waitToStart  |  WARN:  modData is Invalid or Missing")
		return true
	end

	if (modData.CashBalance or 0) > 0 then
		self.character:Say("..Please Cash Out before Powering Down Recycler..")
		return true
	end

    return false
end

function PowerOffTimedAction:start() -- Trigger when the action start
    -- print("Action start")
	self.character:faceThisObject(self.recycler)
end

function PowerOffTimedAction:stop() -- Trigger if the action is cancel
    -- print("Action stop")
    ISBaseTimedAction.stop(self)
end

function PowerOffTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	print("Recycler Powered Off")

	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  251  |  FUNCTION:  PowerOffTimedAction:perform  |  WARN:  modData is Invalid or Missing")
		return
	end
	
	AttractZombiesToRecycler(self.character)
	modData.RecyclerEnabled = false
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = self.recycler:getItem():getID(), X = self.recycler:getX(), Y = self.recycler:getY(), Z = self.recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = modData.CurrentUser, RecyclerLastUsed = modData.RecyclerLastUsed })

    ISBaseTimedAction.perform(self)
end

function PowerOffTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 120 -- Time take by the action
    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o;
end


------------------------------------------------------------------------
--                         RESET RECYCLER
------------------------------------------------------------------------

ResetRecyclerTimedAction = ISBaseTimedAction:derive("ResetRecyclerTimedAction")

function ResetRecyclerTimedAction:isValid() -- Check if the action can be done
    return true
end

function ResetRecyclerTimedAction:update() -- Trigger every game update when the action is perform
    -- print("Action is update")
end

function ResetRecyclerTimedAction:waitToStart() -- Wait until return false
    return false
end

function ResetRecyclerTimedAction:start() -- Trigger when the action start
    -- print("Action start")
	self.character:faceThisObject(self.recycler)
end

function ResetRecyclerTimedAction:stop() -- Trigger if the action is cancel
    -- print("Action stop")
    ISBaseTimedAction.stop(self)
end

function ResetRecyclerTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	print("Recycler Reset")

	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  272  |  FUNCTION:  ResetRecyclerTimedAction:perform  |  WARN:  modData is Invalid or Missing")
		return
	end

	if modData.CurrentUser ~= nil and (modData.CashBalance or 0) > 0 then
		print("Depositing Previous Balance of " .. modData.CashBalance .. " into " .. modData.CurrentUser .. "'s Smokey Bank")
		sendClientCommand("GN84-WNDR", "depositCash", {modData.CurrentUser, modData.CashBalance})
	end

	AttractZombiesToRecycler(self.character)
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = self.recycler:getItem():getID(), X = self.recycler:getX(), Y = self.recycler:getY(), Z = self.recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = modData.CurrentUser, RecyclerLastUsed = modData.RecyclerLastUsed })
    
	ISBaseTimedAction.perform(self)
end

function ResetRecyclerTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 120 -- Time take by the action
    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o;
end

------------------------------------------------------------------------
--                            CASH OUT
------------------------------------------------------------------------

CashoutTimedAction = ISBaseTimedAction:derive("CashoutTimedAction")

function CashoutTimedAction:isValid() -- Check if the action can be done
    return true
end

function CashoutTimedAction:update() -- Trigger every game update when the action is perform
    -- print("Action is update")
end

function CashoutTimedAction:waitToStart() -- Wait until return false
    return false
end

function CashoutTimedAction:start() -- Trigger when the action start
    -- print("Action start")
	self.character:faceThisObject(self.recycler)
end

function CashoutTimedAction:stop() -- Trigger if the action is cancel
    -- print("Action stop")
    ISBaseTimedAction.stop(self)
end

function CashoutTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	print("Recycler Cashed Out")

	local modData = self.recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  313  |  FUNCTION:  CashoutTimedAction:perform  |  WARN:  modData is Invalid or Missing")
		return
	end

	if modData.CashBalance and modData.CashBalance > 0 then
		self.character:Say("Cashing Out:  $" .. Utils.CurrencyFormatter(modData.CashBalance))
		CreateCash(modData.CashBalance, self.recycler:getItem())
		modData.CashBalance = 0
	end

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = self.recycler:getItem():getID(), X = self.recycler:getX(), Y = self.recycler:getY(), Z = self.recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = modData.CurrentUser, RecyclerLastUsed = modData.RecyclerLastUsed })

    ISBaseTimedAction.perform(self)
end

function CashoutTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 120 -- Time take by the action
    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o;
end


------------------------------------------------------------------------
--                     RECYCLER AUDIO SYSTEM (CLIENT)     
------------------------------------------------------------------------

local RecyclerAudio = {}
RecyclerAudio.activeEmitters = {}

local SOUND_NAME = "RecyclerMotorRunning"


local function getKey(x, y, z)
	return x .. "," .. y .. "," .. z
end


function RecyclerAudio.StartEmitter(x, y, z)
	local key = getKey(x, y, z)

	if RecyclerAudio.activeEmitters[key] then return end

	local square = getCell():getGridSquare(x, y, z)
	if not square then return end

	local emitter = square:getEmitter()
	if not emitter then return end
	
	emitter:playSoundLooped(SOUND_NAME)
	RecyclerAudio.activeEmitters[key] = 
	{
		emitter = emitter,
		x = x,
		y = y,
		z = z
	}
end


function RecyclerAudio.StopEmitter(x, y, z)
	local key = getKey(x, y, z)
	local data = RecyclerAudio.activeEmitters[key]

	if not data then return end

	if data.emitter then
		data.emitter:stopSoundByName(SOUND_NAME)
	end

	RecyclerAudio.activeEmitters[key] = nil
end

function RecyclerAudio.IsEmitterActive(x, y, z)
	local key = getKey(x, y, z)
	return RecyclerAudio.activeEmitters[key] ~= nil
end

function RecyclerAudio.SyncEmitterToModData(object)
	if not isClient() then return end
	if not object then return end

	local item = object:getItem()
	if not item then return end

	local modData = item:getModData()
	if not modData then return end

	local x = object:getX()
	local y = object:getY()
	local z = object:getZ()

	local emitterActive = RecyclerAudio.IsEmitterActive(x, y, z)

	if modData.RecyclerEnabled then
		if not emitterActive then
			print("Recycler Audio Manager: Recovered missing emitter at " .. x .. "," .. y .. "," .. z)
			RecyclerAudio.StartEmitter(x, y, z)			
		end
	else
		if emitterActive then
			print("Recycler Audio Manager: Removed ghost emitter at " .. x .. "," .. y .. "," .. z)
			RecyclerAudio.StopEmitter(x, y, z)
		end
	end
end



local function PlayCashoutSound(player)
	print("Playing Cashout Sound")
end

------------------------------------------------------------------------
--                      GLOBAL MOD DATA - RECYCLERS    
------------------------------------------------------------------------

local function InitRecyclerGlobalData()
	local modData = ModData.getOrCreate("GN84_ActiveRecyclers")

	if not modData.list then
		modData.list = {}
	end
end

Events.OnInitGlobalModData.Add(InitRecyclerGlobalData)

local function AddActiveRecycler(x, y, z)
	local modData = ModData.getOrCreate("GN84_ActiveRecyclers")
	local key = getKey(x, y, z)

	modData.list[key] = {x = x, y = y, z = z}
	ModData.transmit("GN84_ActiveRecyclers")	
end

local function RemoveActiveRecycler(x, y, z)
	local modData = ModData.getOrCreate("GN84_ActiveRecyclers")
	local key = getKey(x, y, z)

	modData.list[key] = nil
	ModData.transmit("GN84_ActiveRecyclers")
end


------------------------------------------------------------------------
--                      CHECK ACTIVE RECYCLERS
------------------------------------------------------------------------

local MAX_SOUND_DIST = 50
local MAX_DIST_SQ = MAX_SOUND_DIST * MAX_SOUND_DIST

local function CheckGlobalRecyclers()
	if not isClient() then return end

	local player = getPlayer()
	if not player then return end

	local modData = ModData.get("GN84_ActiveRecyclers")
	if not modData or not modData.list then return end


	local px = player:getX()
	local py = player:getY()
	-- local pz = player:getZ()

	local seen = {}



	for key, entry in pairs(modData.list) do
		seen[key] = true

		local dx = entry.x - px
		local dy = entry.y - py	
		local distSq = dx * dx + dy * dy

		if distSq <= MAX_DIST_SQ then
			RecyclerAudio.StartEmitter(entry.x, entry.y, entry.z)
		else
			RecyclerAudio.StopEmitter(entry.x, entry.y, entry.z)
		end
	end

	-- Cleanup
	for key, data in pairs(RecyclerAudio.activeEmitters) do
		if not seen[key] then			
			RecyclerAudio.StopEmitter(data.x, data.y, data.z)
		end
	end
end

Events.EveryOneMinute.Add(CheckGlobalRecyclers)


local function RecyclerCleanup(object)
	if instanceof(object, "IsoWorldInventoryObject") then
		local item = object:getItem()
		if item and item:getType() == "SmokeyShredderRecycler" then
			RemoveActiveRecycler(object:getX(), object:getY(), object:getZ())
		end
	end
end

Events.OnObjectAboutToBeRemoved.Add(RecyclerCleanup)


------------------------------------------------------------------------
--                         ATTRACT ZOMBIES
------------------------------------------------------------------------

AttractZombiesToRecycler = function(player)
	local odds = ZombRand(0,100) + 1
	-- print("Odds: ", odds)
	if odds > 99 then
		-- print("Attracting Zombies to Recycler")
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100)
	end
end

------------------------------------------------------------------------
--                           VALID ITEMS
------------------------------------------------------------------------

local recyclerItems =
	{
		"Base.Money",
		"GN84-WNDR.MoneyStackX",
		"GN84-WNDR.WandererTokenStackX",
		"GN84-WNDR.MoneyStack100",
		"GN84-WNDR.MoneyStack500",
		"GN84-WNDR.MoneyStack1000",
		"GN84-WNDR.MoneyStack5000",
		"GN84-WNDR.MoneyStack10000",
		"GN84-WNDR.MoneyStack50000",
		"GN84-WNDR.MoneyStack100000",
		"GN84-WNDR.MoneyStack500000",
		"GN84-WNDR.MoneyStack1000000",
		"GN84-WNDR.MoneyStack5000000",
		"GN84-WNDR.MoneyStack10000000",
		"GN84-WNDR.WandererToken",
		"GN84-WNDR.WandererTokenStack5",
		"GN84-WNDR.WandererTokenStack10",
		"GN84-WNDR.WandererTokenStack25",
		"GN84-WNDR.WandererTokenStack50",
		"GN84-WNDR.WandererTokenStack100",
		"GN84-WNDR.WandererTokenStack250",
		"GN84-WNDR.WandererTokenStack500",
		"GN84-WNDR.WandererTokenStack1000",
		"GN84-WNDR.WandererTokenStack5000",
	}

function GN84_AcceptItemsRecycler(container, item)

	for i = 1, #recyclerItems do
    	if item:getFullType() == recyclerItems[i] then
			return true		
		end
	end
	return false
end


------------------------------------------------------------------------
--                  CREATE CUSTOM STACK OF CASH
------------------------------------------------------------------------


CreateCash = function(amount, recycler)
    if not amount then return end

    local player = getPlayer()
    if not player then return end

    -- Instantiate MoneyStackX Item
    local moneyStackX = InventoryItemFactory.CreateItem("GN84-WNDR.MoneyStackX")
	if recycler then
		recycler:getInventory():AddItem(moneyStackX)
	else
		player:getInventory():AddItem(moneyStackX)
	end

    local moneyStackData = moneyStackX:getModData()
    if not moneyStackData then return end

    -- Set Money Stack Amount in modData
    moneyStackData.CashAmount = amount

    -- Rename Money Stack to Reflect Cash Amount
    moneyStackX:setName(moneyStackX:getName() .. "  -  $" .. Utils.CurrencyFormatter(moneyStackData.CashAmount))
end


------------------------------------------------------------------------
--                        RECYCLER FUNCTIONS
------------------------------------------------------------------------

local function CashOutBalance(target, recycler, player)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  439  |  FUNCTION:  CashOutBalance  |  ERROR:  recycler is Invalid or Missing")
		return
	end	

	ISTimedActionQueue.add(CashoutTimedAction:new(recycler, player))
end


local function ActivateRecycler(player, recycler)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  139  |  FUNCTION:  ActivateRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end

	local modData = recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  146  |  FUNCTION:  ActivateRecycler  |  ERROR:  modData is Invalid or Missing")
		return
	end

	modData.RecyclerActivated = true
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()
	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = nil, RecyclerLastUsed = modData.RecyclerLastUsed })
end


local function DeActivateRecycler(player, recycler)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  159  |  FUNCTION:  DeActivateRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end

	local modData = recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  166  |  FUNCTION:  DeActivateRecycler  |  ERROR:  modData is Invalid or Missing")
		return
	end

	modData.RecyclerActivated = false
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = nil, RecyclerLastUsed = modData.RecyclerLastUsed })
end


-- POWER ON
local function PowerOnRecycler(target, recycler, player)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  439  |  FUNCTION:  PowerOnRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end	

	ISTimedActionQueue.add(PowerOnTimedAction:new(recycler, player))
end

-- POWER OFF
local function PowerOffRecycler(target, recycler, player)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  447  |  FUNCTION:  PowerOffRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end	

	ISTimedActionQueue.add(PowerOffTimedAction:new(recycler, player))
end

-- RESET
local function ResetRecycler(target, recycler, player)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  506  |  FUNCTION:  ResetRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end

	ISTimedActionQueue.add(ResetRecyclerTimedAction:new(recycler, player))
end

local function AdminPurgeRecyclers(player)
	if not isClient() then return end

	sendClientCommand("GN84-WNDR", "PurgeAllRecyclers", {})
end


------------------------------------------------------------------------
--                        CONTEXT MENU
------------------------------------------------------------------------

local function RecyclerContext(playerNum, context, worldObjects, test)
	local player = getPlayerByOnlineID(playerNum)
	local username = player:getUsername()

	local objects = worldObjects[1] and worldObjects[1]:getSquare():getObjects()
    for i = 0, objects:size()-1 do

	---@type IsoWorldInventoryObject
    local object = objects:get(i)
        if instanceof(object, "IsoWorldInventoryObject") and object:getItem():getType() == "SmokeyShredderRecycler" then

			local modData = object:getItem():getModData()

			-- Self Heal Emitter State
			if modData.RecyclerEnabled ~= nil then
				RecyclerAudio.SyncEmitterToModData(object)
			end

			-- Admin Activate/Deactivate
			if isAltKeyDown() then
				if getAccessLevel() == "admin" then

					if isShiftKeyDown() then
						context:addOptionOnTop("(ADMIN) Purge All Recycler Audio", nil, AdminPurgeRecyclers, player)
					end

					if not modData.RecyclerActivated then
						local activate = context:addOptionOnTop("(ADMIN) Activate Recycler", nil, ActivateRecycler, object)
					else
						local deactivate = context:addOptionOnTop("(ADMIN) De-Activate Recycler", nil, DeActivateRecycler, object)
					end
				end
			end			

			if modData.RecyclerActivated then

				-- Power Status
				local statusText = ""
				if modData.RecyclerEnabled then
					statusText = " On"
				else
					statusText = " Off"
				end

				-- Session Timeout / Timer
				local currentTime = getTimeInMillis()
				local timeoutEnd = modData.RecyclerLastUsed + (recyclerTimeout * MS_TO_MINUTES)
				local timeoutInMillis = timeoutEnd - currentTime
				local timeoutInMinutes = (timeoutEnd - currentTime) / 60000
				local timeoutInSeconds = (timeoutEnd - currentTime) / 1000
				local remainingSeconds = math.floor((timeoutInMillis % 60000) / 1000)
				local formattedSeconds = string.format("%02d", remainingSeconds)

				if modData.CurrentUser ~= nil and modData.CurrentUser ~= username then

					if currentTime > timeoutEnd then

						-- Wait 5 Minutes for Timeout and Give Reset Option
						local option = context:addOptionOnTop("Reset Recycler", nil, ResetRecycler, object, player)
						local toolTip = ISWorldObjectContextMenu.addToolTip()
						toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Resets<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.2,1,0.2>Cashes Out <SPACE><SPACE><RGB:1,1,1,1> any Remaining Balance into Previous User's Smokey Bank")
						option.toolTip = toolTip

						return
					else

						local unauthorized = context:addOptionOnTop("Unauthorized User", nil, nil)
						local toolTip = ISWorldObjectContextMenu.addToolTip()

						-- Display Session Timeout
						if timeoutInMinutes < 1 then
							toolTip.description = getText("<SIZE:medium>Session Timeout:<SPACE><SPACE>" .. math.ceil(timeoutInSeconds) .. " Seconds")
						else
							toolTip.description = getText("<SIZE:medium>Session Timeout:<SPACE><SPACE>" .. math.floor(timeoutInMinutes) .. ":" .. formattedSeconds)
						end
						unauthorized.toolTip = toolTip
						unauthorized.notAvailable = true

						return
					end
				elseif (modData.CurrentUser == username) and (currentTime > timeoutEnd) then

					local status = context:addOptionOnTop("Status:  Session Timed Out", nil, nil)
					local statustoolTip = ISWorldObjectContextMenu.addToolTip()
					statustoolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Session has Timed Out.<LINE><LINE><RGB:0.0,0.886,1.0,1>Please Reset Recycler to Continue")
					status.toolTip = statustoolTip
					status.notAvailable = true

					local option = context:addOptionOnTop("Reset Recycler and Cash Out", nil, ResetRecycler, object, player)
					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Resets<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.2,1,0.2>Cashes Out <SPACE><SPACE><RGB:1,1,1,1> any Remaining Balance into User's Smokey Bank")
					option.toolTip = toolTip

					return
				end

				if modData.RecyclerEnabled then
					

					local option = context:addOptionOnTop("Turn Off Recycler", nil, PowerOffRecycler, object, player)
					local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
					toggletoolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Turns Off<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.2,1,0.2>Cashes Out <SPACE><SPACE><RGB:1,1,1,1> Remaining Balance")
					option.toolTip = toggletoolTip

					local status = context:addOptionOnTop("Status: " .. statusText, nil, nil)
					local toolTip = ISWorldObjectContextMenu.addToolTip()
					
					-- Display Session Timer
					if timeoutInMinutes < 1 then
						toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Recycler is Running...<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!<LINE><LINE><RGB:0.0,0.886,1.0,1>Current User:  " .. modData.CurrentUser .. "<LINE><RGB:1,1,1,1>Session Timeout:<SPACE><SPACE>" .. math.ceil(timeoutInSeconds) .. " Seconds")
					else
						toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Recycler is Running...<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!<LINE><LINE><RGB:0.0,0.886,1.0,1>Current User:  " .. modData.CurrentUser .. "<LINE><RGB:1,1,1,1>Session Timeout:<SPACE><SPACE>" .. math.floor(timeoutInMinutes) .. ":" .. formattedSeconds)
					end

					status.toolTip = toolTip
					status.notAvailable = false

					if modData.CashBalance then
						if (modData.CashBalance or 0) > 0 then

							local cashBalance = modData.CashBalance or 0
							cashBalance = Utils.CurrencyFormatter(cashBalance)
							-- local cashOut = context:addOptionOnTop("Cash Out", nil, CashOutBalance, object, player)
							local balance = context:addOptionOnTop("Balance: $" .. cashBalance, nil, CashOutBalance, object, player)
							local toolTip = ISWorldObjectContextMenu.addToolTip()
							toolTip.description = getText("<SIZE:medium>Displays Current Recycler Balance.<LINE><LINE><RGB:0.2,1,0.2>Click to Cash Out!")
							balance.toolTip = toolTip

						else

							local balance = context:addOptionOnTop("Balance: $0", nil, nil)
							balance.notAvailable = true
							local toolTip = ISWorldObjectContextMenu.addToolTip()
							toolTip.description = getText("<SIZE:medium>Displays Current Recycler Balance.<LINE><LINE><RGB:0.0,0.886,1.0,1>Recycle Items to Earn Cash!")
							balance.toolTip = toolTip

						end
					end

				elseif not modData.RecyclerEnabled then

					local option = context:addOptionOnTop("Turn On Recycler", nil, PowerOnRecycler, object, player)
					local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
					toggletoolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Turns On<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.0,0.886,1.0,1>Access Restricted to Current User")
					option.toolTip = toggletoolTip

					local status = context:addOptionOnTop("Status: " .. statusText, nil, nil)
					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Recycler is Powered Down.<LINE><LINE><RGB:0.0,0.886,1.0,1>Turn On to Recycle Items.")
					status.toolTip = toolTip
					status.notAvailable = true

				end
			else

				local activated = context:addOptionOnTop("Deactivated", nil, nil)
				activated.notAvailable = true
				local toolTip = ISWorldObjectContextMenu.addToolTip()
				toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Recycler Disabled<LINE><LINE><RGB:0.0,0.886,1.0,1>Must be Activated by an Admin")
				activated.toolTip = toolTip

			end
        end
    end
end



Events.OnFillWorldObjectContextMenu.Add(RecyclerContext)



------------------------------------------------------------------------
--                          
--                          
--                         MOD DATA SYNCING 
--                          
--                          
------------------------------------------------------------------------


------------------------------------------------------------------------
--                   GET RECYCLER WORLD OBJECT 
------------------------------------------------------------------------
local function getWorldItemByID(x, y, z, id)

    local square = getCell():getGridSquare(x, y, z)
    if not square then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  248  |  FUNCTION:  getWorldItemByID  |  ERROR:  gridSquare is Invalid or Missing")
		return nil
	end

    local objects = square:getObjects()

    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)

        if instanceof(obj, "IsoWorldInventoryObject") then
            local item = obj:getItem()

            if item and item:getType() == "SmokeyShredderRecycler" and item:getID() == id then
                return item
            end
        end
    end

    return nil
end

------------------------------------------------------------------------
--                        GET RECYCLER ITEM 
------------------------------------------------------------------------

local function getRecyclerObject(sources)
	for i = 0, sources:size() - 1 do
		---@type InventoryItem
		local item = sources:get(i)
		if item:getType() == "SmokeyShredderRecycler" then
			return item
		end
	end
end


------------------------------------------------------------------------
--                      CLIENT > SERVER    
------------------------------------------------------------------------

local function ReceiveRecyclerModDataFromClient(module, command, player, args)
	if module ~= "GN84-WNDR" then return end

	if command == "PurgeAllRecyclers" then
		if not player or player:getAccessLevel() ~= "Admin" then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  972  |  FUNCTION:  PurgeAllRecyclers  |  WARN:  Unauthorized PurgeAllRecyclers Attempt!")
			return
		end

		print("ADMIN: Purging all active recyclers")

		local modData = ModData.getOrCreate("GN84_ActiveRecyclers")
		modData.list = {}

		ModData.transmit("GN84_ActiveRecyclers")

		sendServerCommand("GN84-WNDR", "ClientPurgeAllRecyclers", {})
	end

	if command == "RequestRecyclerLock" then
		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
		if not recycler then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  945  |  FUNCTION:  ReceiveRecyclerModDataFromClient  |  ERROR:  Recycler Item Not Found")
			return
		end

		local modData = recycler:getModData()
		if not modData then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  951  |  FUNCTION:  ReceiveRecyclerModDataFromClient  |  ERROR:  modData is Invalid or Missing")
			return
		end

		if not modData.CurrentUser then
			modData.CurrentUser = args.username

			sendServerCommand("GN84-WNDR", "ReceiveRecyclerLockConfirmation",
		{
			RecyclerID = args.RecyclerID,
			X = args.X,
			Y = args.Y,
			Z = args.Z,
			CurrentUser = modData.CurrentUser
		})
		end
	end

	if command == "ReceiveRecyclerModDataFromClient" then

		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)

		if not recycler then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  283  |  FUNCTION:  ReceiveRecyclerModDataFromClient  |  ERROR:  Recycler Item Not Found")
			return
		end

		local modData = recycler:getModData()
		if not modData then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  289  |  FUNCTION:  ReceiveRecyclerModDataFromClient  |  ERROR:  modData is Invalid or Missing")
			return
		end

		-- SYNC MOD DATA ON SERVER
		modData.RecyclerActivated = args.RecyclerActivated
		modData.RecyclerEnabled = args.RecyclerEnabled
		modData.CashBalance = args.CashBalance
		modData.CurrentUser = args.CurrentUser
		modData.RecyclerLastUsed = args.RecyclerLastUsed

		if args.RecyclerEnabled then
			AddActiveRecycler(args.X, args.Y, args.Z)			
		else
			RemoveActiveRecycler(args.X, args.Y, args.Z)
		end

		-- Send Mod Data back to Local Clients
		sendServerCommand("GN84-WNDR", "ReceiveRecyclerModDataFromServer", { RecyclerID = args.RecyclerID, X = args.X, Y = args.Y, Z = args.Z, RecyclerActivated = args.RecyclerActivated, RecyclerEnabled = args.RecyclerEnabled, CashBalance = args.CashBalance, CurrentUser = args.CurrentUser, RecyclerLastUsed = args.RecyclerLastUsed })
	end
end

Events.OnClientCommand.Remove(ReceiveRecyclerModDataFromClient)
Events.OnClientCommand.Add(ReceiveRecyclerModDataFromClient)


------------------------------------------------------------------------
--                      SERVER > ALL CLIENTS    
------------------------------------------------------------------------

local function ReceiveRecyclerModDataFromServer(module, command, args)
	if module ~= "GN84-WNDR" then return end

	if command == "ClientPurgeAllRecyclers" then
		print("CLIENT: Purging all recycler emitters")

		for key, data in pairs(RecyclerAudio.activeEmitters) do
			if data.emitter then
				data.emitter:stopSoundByName(SOUND_NAME)				
			end
		end

		RecyclerAudio.activeEmitters = {}

		CheckGlobalRecyclers()
	end

	if command == "ReceiveRecyclerLockConfirmation" then
		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)

		if not recycler then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  1011  |  FUNCTION:  ReceiveRecyclerModDataFromServer  |  ERROR:  Recycler Item Not Found")
			return
		end

		local modData = recycler:getModData()
		if not modData then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  996  |  FUNCTION:  ReceiveRecyclerModDataFromServer  |  ERROR:  modData is Invalid or Missing")
			return
		end

		modData.CurrentUser = args.CurrentUser
	end

	if command == "ReceiveRecyclerModDataFromServer" then

		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)

		if not recycler then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  315  |  FUNCTION:  ReceiveRecyclerModDataFromServer  |  ERROR:  Recycler Item Not Found")
			return
		end

		local modData = recycler:getModData()
		if not modData then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  328  |  FUNCTION:  ReceiveRecyclerModDataFromClient  |  ERROR:  modData is Invalid or Missing")
			return
		end

		-- SYNC LOCAL MOD DATA
		modData.RecyclerActivated = args.RecyclerActivated
		modData.RecyclerEnabled = args.RecyclerEnabled
		modData.CashBalance = args.CashBalance
		modData.CurrentUser = args.CurrentUser
		modData.RecyclerLastUsed = args.RecyclerLastUsed

		if isClient() then
			if args.RecyclerEnabled then
				RecyclerAudio.StartEmitter(args.X, args.Y, args.Z)
			else
				RecyclerAudio.StopEmitter(args.X, args.Y, args.Z)
			end
		end
	end
end

Events.OnServerCommand.Remove(ReceiveRecyclerModDataFromServer)
Events.OnServerCommand.Add(ReceiveRecyclerModDataFromServer)



------------------------------------------------------------------------
--                   CHECK IF RECYCLER IS POWERED ON
------------------------------------------------------------------------

local function IsRecyclerEnabled(recycler)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  176  |  FUNCTION:  IsRecyclerEnabled  |  ERROR:  recycler is Invalid or Missing")
		return false
	end

	local modData = recycler:getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  117  |  FUNCTION:  IsRecyclerEnabled  |  WARN:  modData is Invalid or Missing")
		return false
	end

	if modData.RecyclerEnabled then
		return true
	else
		return false
	end
end


------------------------------------------------------------------------
--                 CHECK IF RECYCLER WAS CLICKED ITEM
------------------------------------------------------------------------

function GN84_IsRecyclerUsed(recipe, character, item)
	if item == nil then
		-- print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  258  |  FUNCTION:  GN84_IsRecyclerUsed  |  WARN:  Recycler was not right clicked for recipe")
		return true
	end

	if item:getType() == "SmokeyShredderRecycler" then
		-- print("Item is Recycler")
		return true
	else
		-- print("Item is NOT Recycler")
		return false
	end
end


------------------------------------------------------------------------
--      CHECK IF RECYCLER ENABLED AND ITEMS NOT FAVORITE / EQUIPPED
------------------------------------------------------------------------

function GN84_IsRecycleable(item, result)
	if item:getType() == "SmokeyShredderRecycler" then
		-- Check if Recycler is Powered On
		if not IsRecyclerEnabled(item) then
			return false
		end

		-- Check if Player is Current User
		local modData = item:getModData()
		if modData.CurrentUser ~= getPlayer():getUsername() then
			return false
		end
	end

    return not item:isFavorite() and not item:isEquipped()
end


------------------------------------------------------------------------
--                         CONDITION SCALING
------------------------------------------------------------------------

local function GetConditionScalar(sources)
	if not sources then return 0.0 end

	for i = 0, sources:size() - 1 do
		---@type InventoryItem
		local item = sources:get(i)
		if item:getType() ~= "SmokeyShredderRecycler" then
			return (item:getCurrentCondition() / 100) or 1.0
		end
	end

	return 1.0
end



------------------------------------------------------------------------
--                          
--                          
--                             RECIPES
--                          
--                          
------------------------------------------------------------------------
------------------------------------------------------------------------
--                              JEWELRY
------------------------------------------------------------------------

function ShredderRecycleWatches(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local watchesValueRoll = ZombRand(watchesMinValue, watchesMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", watchesMinValue)
	print("Max Value: ", watchesMaxValue)
	print("Value Roll: ", watchesValueRoll)

	local finalValue = math.max(1, math.floor(watchesValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)

	local modData = recycler:getModData()
	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  563  |  FUNCTION:  ShredderRecycleWatches  |  ERROR:  modData is Invalid or Missing")
		return
	end
	modData.CashBalance = modData.CashBalance + finalValue
	modData.RecyclerLastUsed = getTimeInMillis()
	
	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getID(), X = recycler:getWorldItem():getX(), Y = recycler:getWorldItem():getY(), Z = recycler:getWorldItem():getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = modData.CurrentUser, RecyclerLastUsed = modData.RecyclerLastUsed })

	--PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleJewelrySimple(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local jewelryValueRoll = ZombRand(jewelrySimpleMinValue, jewelrySimpleMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", jewelrySimpleMinValue)
	print("Max Value: ", jewelrySimpleMaxValue)
	print("Value Roll: ", jewelryValueRoll)

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleJewelryPrecious(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local jewelryValueRoll = ZombRand(jewelryPreciousMinValue, jewelryPreciousMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", jewelryPreciousMinValue)
	print("Max Value: ", jewelryPreciousMaxValue)
	print("Value Roll: ", jewelryValueRoll)

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleJewelryGemstones(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local jewelryValueRoll = ZombRand(jewelryGemsMinValue, jewelryGemsMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", jewelryGemsMinValue)
	print("Max Value: ", jewelryGemsMaxValue)
	print("Value Roll: ", jewelryValueRoll)

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleJewelryDiamond(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local jewelryValueRoll = ZombRand(jewelryDiamondMinValue, jewelryDiamondMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", jewelryDiamondMinValue)
	print("Max Value: ", jewelryDiamondMaxValue)
	print("Value Roll: ", jewelryValueRoll)

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end




------------------------------------------------------------------------
--                            TOOLS
------------------------------------------------------------------------

function ShredderRecycleSimpleTool(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local toolValueRoll = ZombRand(simpleToolMinValue, simpleToolMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", simpleToolMinValue)
	print("Max Value: ", simpleToolMaxValue)
	print("Value Roll: ", toolValueRoll)

	local finalValue = math.max(1, math.floor(toolValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleLargeTool(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local toolValueRoll = ZombRand(largeToolMinValue, largeToolMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", largeToolMinValue)
	print("Max Value: ", largeToolMaxValue)
	print("Value Roll: ", toolValueRoll)

	local finalValue = math.max(1, math.floor(toolValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleComplexTool(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local toolValueRoll = ZombRand(complexToolMinValue, complexToolMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", complexToolMinValue)
	print("Max Value: ", complexToolMaxValue)
	print("Value Roll: ", toolValueRoll)

	local finalValue = math.max(1, math.floor(toolValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end




------------------------------------------------------------------------
--                     LEATHER / CLOTHING ITEMS
------------------------------------------------------------------------

function ShredderRecycleLeather(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local leatherValueRoll = ZombRand(leatherMinValue, leatherMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", leatherMinValue)
	print("Max Value: ", leatherMaxValue)
	print("Value Roll: ", leatherValueRoll)

	local finalValue = math.max(1, math.floor(leatherValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleClothing(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local clothingValueRoll = ZombRand(clothingMinValue, clothingMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", clothingMinValue)
	print("Max Value: ", clothingMaxValue)
	print("Value Roll: ", clothingValueRoll)

	local finalValue = math.max(1, math.floor(clothingValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleBulletVest(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local vestValueRoll = ZombRand(bulletVestMinValue, bulletVestMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", bulletVestMinValue)
	print("Max Value: ", bulletVestMaxValue)
	print("Value Roll: ", vestValueRoll)

	local finalValue = math.max(1, math.floor(vestValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleGlasses(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local glassesValueRoll = ZombRand(glassesMinValue, glassesMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", glassesMinValue)
	print("Max Value: ", glassesMaxValue)
	print("Value Roll: ", glassesValueRoll)

	local finalValue = math.max(1, math.floor(glassesValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end



------------------------------------------------------------------------
--                          PAPER PRODUCTS
------------------------------------------------------------------------

function ShredderRecyclePaperProduct(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local paperValueRoll = ZombRand(paperProductMinValue, paperProductMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", paperProductMinValue)
	print("Max Value: ", paperProductMaxValue)
	print("Value Roll: ", paperValueRoll)

	local finalValue = math.max(1, math.floor(paperValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end



------------------------------------------------------------------------
--                          ELECTRONICS
------------------------------------------------------------------------

function ShredderRecycleLowElectronics(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local electronicsValueRoll = ZombRand(lowElectronicsMinValue, lowElectronicsMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", lowElectronicsMinValue)
	print("Max Value: ", lowElectronicsMaxValue)
	print("Value Roll: ", electronicsValueRoll)

	local finalValue = math.max(1, math.floor(electronicsValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end


function ShredderRecycleHighElectronics(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local electronicsValueRoll = ZombRand(highElectronicsMinValue, highElectronicsMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", highElectronicsMinValue)
	print("Max Value: ", highElectronicsMaxValue)
	print("Value Roll: ", electronicsValueRoll)

	local finalValue = math.max(1, math.floor(electronicsValueRoll * multiplier * recyclerValueMultiplier))
	print("Final Value: ", finalValue)


	if finalValue >= 10 then
		CreateCash(finalValue, recycler)
	else
		local t = 0
		while t ~= finalValue do
			if recycler then
				recycler:getInventory():AddItem("Money")
			else
				player:getInventory():AddItem("Money")
			end
			t = t+1
		end
	end
	PlayCashoutSound(player)
	AttractZombiesToRecycler(player)
end