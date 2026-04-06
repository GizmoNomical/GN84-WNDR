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
-- ##                               Copyright © GizmoNomical - 2026                                       ##
-- ##                                           GN84-WNDR                                                 ##
-- ##                                 The Wanderers - Recycler Module                                     ##
-- #########################################################################################################
-- #########################################################################################################


local Utils = require "Gizmo/GN84LIB_Utils"

local DEBUG_RECYCLER = SandboxVars.GN84WNDR.RecyclerDebug	or false

------------------------------------------------------------------------
--                       SANDBOX SETTINGS
------------------------------------------------------------------------

local recyclerValueMultiplier = SandboxVars.GN84WNDR.RecyclerValueMultiplier	or 1.0
local recyclerTimeout = SandboxVars.GN84WNDR.RecyclerTimeout					or 5

local watchesGlassesMinValue = SandboxVars.GN84WNDR.WatchesGlassesMinValue		or 20
local watchesGlassesMaxValue = SandboxVars.GN84WNDR.WatchesGlassesMaxValue		or 60

local jewelrySimpleMinValue = SandboxVars.GN84WNDR.JewelrySimpleMinValue 		or 10
local jewelrySimpleMaxValue = SandboxVars.GN84WNDR.JewelrySimpleMaxValue 		or 40

local jewelryPreciousMinValue = SandboxVars.GN84WNDR.JewelryPreciousMinValue 	or 40
local jewelryPreciousMaxValue = SandboxVars.GN84WNDR.JewelryPreciousMaxValue 	or 80

local jewelryGemsMinValue = SandboxVars.GN84WNDR.JewelryGemsMinValue 			or 50
local jewelryGemsMaxValue = SandboxVars.GN84WNDR.JewelryGemsMaxValue 			or 100

local jewelryDiamondMinValue = SandboxVars.GN84WNDR.JewelryDiamondMinValue 		or 50
local jewelryDiamondMaxValue = SandboxVars.GN84WNDR.JewelryDiamondMaxValue 		or 150

local simpleToolMinValue = SandboxVars.GN84WNDR.SimpleToolMinValue 				or 75
local simpleToolMaxValue = SandboxVars.GN84WNDR.SimpleToolMaxValue 				or 200

local complexToolMinValue = SandboxVars.GN84WNDR.ComplexToolMinValue 			or 200
local complexToolMaxValue = SandboxVars.GN84WNDR.ComplexToolMaxValue 			or 400

local meleeOneHandMinValue = SandboxVars.GN84WNDR.MeleeOneHandMinValue			or 100
local meleeOneHandMaxValue = SandboxVars.GN84WNDR.MeleeOneHandMaxValue			or 300

local meleeTwoHandMinValue = SandboxVars.GN84WNDR.MeleeTwoHandMinValue			or 200
local meleeTwoHandMaxValue = SandboxVars.GN84WNDR.MeleeTwoHandMaxValue			or 650

local clothItemMinValue = SandboxVars.GN84WNDR.ClothItemMinValue 				or 50
local clothItemMaxValue = SandboxVars.GN84WNDR.ClothItemMaxValue 				or 100

local leatherItemMinValue = SandboxVars.GN84WNDR.LeatherItemMinValue			or 85
local leatherItemMaxValue = SandboxVars.GN84WNDR.LeatherItemMaxValue			or 150

local armorMinValue = SandboxVars.GN84WNDR.ArmorMinValue 						or 250
local armorMaxValue = SandboxVars.GN84WNDR.ArmorMaxValue 						or 700

local bagsMinValue = SandboxVars.GN84WNDR.BagsMinValue							or 150
local bagsMaxValue = SandboxVars.GN84WNDR.BagsMaxValue							or 450

local lowElectronicsMinValue = SandboxVars.GN84WNDR.LowElectronicsMinValue 		or 75
local lowElectronicsMaxValue = SandboxVars.GN84WNDR.LowElectronicsMaxValue 		or 275

local highElectronicsMinValue = SandboxVars.GN84WNDR.HighElectronicsMinValue 	or 275
local highElectronicsMaxValue = SandboxVars.GN84WNDR.HighElectronicsMaxValue 	or 750

local glassItemMinValue = SandboxVars.GN84WNDR.GlassItemMinValue 				or 15
local glassItemMaxValue = SandboxVars.GN84WNDR.GlassItemMaxValue 				or 40

local paperProductMinValue = SandboxVars.GN84WNDR.PaperProductMinValue 			or 35
local paperProductMaxValue = SandboxVars.GN84WNDR.PaperProductMaxValue 			or 65

local fabricStripsMinValue = SandboxVars.GN84WNDR.FabricStripsMinValue 			or 10
local fabricStripsMaxValue = SandboxVars.GN84WNDR.FabricStripsMaxValue 			or 20

local emptyWalletMinValue = SandboxVars.GN84WNDR.EmptyWalletMinValue 			or 25
local emptyWalletMaxValue = SandboxVars.GN84WNDR.EmptyWalletMaxValue 			or 35

local junkItemMinValue = SandboxVars.GN84WNDR.JunkItemMinValue 					or 10
local junkItemMaxValue = SandboxVars.GN84WNDR.JunkItemMaxValue 					or 35


local MS_TO_MINUTES = 60000
local BUSY_TIMEOUT = 5000

local CreateCash
local AttractZombiesToRecycler
local getWorldItemByID
local getRecyclerObject





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
		return false
	end

	if modData.RecyclerEnabled then
		return false
	end

	local username = self.character:getUsername()

	return modData.CurrentUser == nil or modData.CurrentUser == username
end


function PowerOnTimedAction:update() -- Trigger every game update when the action is perform
    -- print("Action is update")
	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
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

	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	modData.ActionBusyUntil = getTimeInMillis() + BUSY_TIMEOUT

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = modData.ActionBusyUntil
	})

	self.character:faceThisObject(self.recycler)
	self:setActionAnim("VehicleWorkOnMid")

	self.recyclerStartEmitter = getWorld():getFreeEmitter(self.recycler:getX(), self.recycler:getY(), self.recycler:getZ())
	if self.recyclerStartEmitter then
		self.recyclerStartSound = self.recyclerStartEmitter:playSound("RecyclerMotorStart", self.recycler:getSquare())
	end

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

	if self.recyclerStartEmitter and self.recyclerStartSound then
		self.recyclerStartEmitter:stopSound(self.recyclerStartSound)
	end
	self.recyclerStartSound = nil
	self.recyclerStartEmitter = nil

	local emitter = getWorld():getFreeEmitter(self.recycler:getX(), self.recycler:getY(), self.recycler:getZ())
    if emitter then
        emitter:playSound("RecyclerMotorStop", self.recycler:getSquare())
    end

	local modData = self.recycler:getItem():getModData()

	if not modData then
		ISBaseTimedAction.stop(self)
		return
	end

	if modData.CurrentUser == self.character:getUsername() then
		modData.CurrentUser = nil

		sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
		{
			RecyclerID = self.recycler:getItem():getID(),
			X = self.recycler:getX(),
			Y = self.recycler:getY(),
			Z = self.recycler:getZ(),
			ActionBusyUntil = 0,
			ClearCurrentUser = true
		})
	end


    ISBaseTimedAction.stop(self)
end


function PowerOnTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	if DEBUG_RECYCLER then
		print("Recycler Powered On")
	end

	self.recyclerStartSound = nil
	self.recyclerStartEmitter = nil

	local modData = self.recycler:getItem():getModData()

	if not modData then
		ISBaseTimedAction.perform(self)
		return
	end

	if modData.CurrentUser ~= nil and modData.CurrentUser ~= self.character:getUsername() then
		if DEBUG_RECYCLER then
			print("Recycler Lock Lost, Aborting Action")
		end
		ISBaseTimedAction.perform(self)
		return
	end


	AttractZombiesToRecycler(self.character, 20)

	modData.RecyclerEnabled = true
	modData.RecyclerLastUsed = getTimeInMillis()
	modData.CurrentUser = self.character:getUsername()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		RecyclerEnabled = true,
		RecyclerLastUsed = modData.RecyclerLastUsed,
		CurrentUser = modData.CurrentUser
	})

    ISBaseTimedAction.perform(self)
end


function PowerOnTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 230 -- Time take by the action
    return o;
end


------------------------------------------------------------------------
--                         POWER OFF RECYCLER
------------------------------------------------------------------------

PowerOffTimedAction = ISBaseTimedAction:derive("PowerOffTimedAction")

function PowerOffTimedAction:isValid() -- Check if the action can be done
	local modData = self.recycler:getItem():getModData()

	if not modData then
		return false
	end

	if not modData.RecyclerEnabled then
		return false
	end

	if modData.CurrentUser and modData.CurrentUser ~= self.character:getUsername() then
		return false
	end

    return true
end


function PowerOffTimedAction:update()
	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		self:forceStop()
		return
	end

	if not modData.RecyclerEnabled then
		self:forceStop()
		return
	end
end


function PowerOffTimedAction:waitToStart() -- Wait until return false
    return false
end


function PowerOffTimedAction:start() -- Trigger when the action start
    -- print("Action start")
	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	modData.ActionBusyUntil = getTimeInMillis() + BUSY_TIMEOUT

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = modData.ActionBusyUntil
	})

	self.character:faceThisObject(self.recycler)
	self:setActionAnim("VehicleWorkOnMid")
end


function PowerOffTimedAction:stop() -- Trigger if the action is cancel

    sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = 0
	})

    ISBaseTimedAction.stop(self)
end


function PowerOffTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	if DEBUG_RECYCLER then
		print("Recycler Powered Off")
	end

	local modData = self.recycler:getItem():getModData()

	if not modData then
		ISBaseTimedAction.perform(self)
		return
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		if DEBUG_RECYCLER then
			print("Recycler Lock Lost, Aborting PowerOffTimedAction:perform")
		end
		ISBaseTimedAction.perform(self)
		return
	end


	local emitter = getWorld():getFreeEmitter(self.recycler:getX(), self.recycler:getY(), self.recycler:getZ())
    if emitter then
        emitter:playSound("RecyclerMotorStop", self.recycler:getSquare())
    end

	AttractZombiesToRecycler(self.character, 20)

	modData.RecyclerEnabled = false
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		RecyclerEnabled = false,
		RecyclerLastUsed = modData.RecyclerLastUsed,
		ClearCurrentUser = true
	})

    ISBaseTimedAction.perform(self)
end


function PowerOffTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 60 -- Time take by the action
    return o;
end


------------------------------------------------------------------------
--                         RESET RECYCLER
------------------------------------------------------------------------

ResetRecyclerTimedAction = ISBaseTimedAction:derive("ResetRecyclerTimedAction")

function ResetRecyclerTimedAction:isValid() -- Check if the action can be done
	local modData = self.recycler:getItem():getModData()

	if not modData then
		return false
	end

	if not modData.RecyclerActivated then
		return false
	end

	if not modData.RecyclerEnabled then
		return false
	end

	if not modData.CurrentUser then
		return false
	end

	local lastUsed = modData.RecyclerLastUsed or 0
	local timeoutMs = recyclerTimeout * MS_TO_MINUTES
	local timedOut = getTimeInMillis() > (lastUsed + timeoutMs)

	if not timedOut then
		return false
	end

	return true
end


function ResetRecyclerTimedAction:update() -- Trigger every game update when the action is perform
	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	if not modData.RecyclerActivated then
		self:forceStop()
		return
	end

	if not modData.RecyclerEnabled then
		self:forceStop()
		return
	end

	if not modData.CurrentUser then
		self:forceStop()
		return
	end

	local lastUsed = modData.RecyclerLastUsed or 0
	local timeoutMs = recyclerTimeout * MS_TO_MINUTES
	local timedOut = getTimeInMillis() > (lastUsed + timeoutMs)

	if not timedOut then
		self:forceStop()
		return
	end
end


function ResetRecyclerTimedAction:waitToStart() -- Wait until return false
    return false
end


function ResetRecyclerTimedAction:start() -- Trigger when the action start
	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	modData.ActionBusyUntil = getTimeInMillis() + BUSY_TIMEOUT

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = modData.ActionBusyUntil
	})

	self.character:faceThisObject(self.recycler)
	self:setActionAnim("VehicleWorkOnMid")

	local emitter = getWorld():getFreeEmitter(self.recycler:getX(), self.recycler:getY(), self.recycler:getZ())
    if emitter then
        emitter:playSound("RecyclerKeyPad", self.recycler:getSquare())
    end

end


function ResetRecyclerTimedAction:stop() -- Trigger if the action is cancel

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = 0
	})

    ISBaseTimedAction.stop(self)
end


function ResetRecyclerTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	if DEBUG_RECYCLER then
		print("Recycler Reset")
	end

	local modData = self.recycler:getItem():getModData()

	if not modData then
		ISBaseTimedAction.perform(self)
		return
	end

	AttractZombiesToRecycler(self.character, 10)

	sendClientCommand("GN84-WNDR", "RequestRecyclerResetAndNewUser",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		username = self.character:getUsername()
	})

	ISBaseTimedAction.perform(self)
end


function ResetRecyclerTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 130 -- Time take by the action
    return o;
end


------------------------------------------------------------------------
--                            CASH OUT
------------------------------------------------------------------------

CashoutTimedAction = ISBaseTimedAction:derive("CashoutTimedAction")

function CashoutTimedAction:isValid() -- Check if the action can be done
	local modData = self.recycler:getItem():getModData()

	if not modData then
		return false
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		return false
	end

	if (modData.CashBalance or 0) <= 0 then
		return false
	end

    return true
end


function CashoutTimedAction:update() -- Trigger every game update when the action is perform
	local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		self:forceStop()
		return
	end

	if (modData.CashBalance or 0) <= 0 then
		self:forceStop()
		return
	end
end


function CashoutTimedAction:waitToStart() -- Wait until return false
    return false
end


function CashoutTimedAction:start() -- Trigger when the action start
    local modData = self.recycler:getItem():getModData()

	if not modData then
		self:forceStop()
		return
	end

	modData.ActionBusyUntil = getTimeInMillis() + BUSY_TIMEOUT

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = modData.ActionBusyUntil
	})

	self.character:faceThisObject(self.recycler)
	self:setActionAnim("VehicleWorkOnMid")

	local emitter = getWorld():getFreeEmitter(self.recycler:getX(), self.recycler:getY(), self.recycler:getZ())
    if emitter then
        emitter:playSound("RecyclerKeyPad", self.recycler:getSquare())
    end
end


function CashoutTimedAction:stop() -- Trigger if the action is cancel

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ(),
		ActionBusyUntil = 0
	})

    ISBaseTimedAction.stop(self)
end


function CashoutTimedAction:perform() -- Trigger when the action is complete
    -- print("Action perform")
	if DEBUG_RECYCLER then
		print("Recycler Cashed Out")
	end

	local modData = self.recycler:getItem():getModData()

	if not modData then
		ISBaseTimedAction.perform(self)
		return
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		ISBaseTimedAction.perform(self)
		return
	end

	local amount = modData.CashBalance or 0
	if amount <= 0 then
		ISBaseTimedAction.perform(self)
		return
	end

	sendClientCommand("GN84-WNDR", "RequestRecyclerCashout",
	{
		RecyclerID = self.recycler:getItem():getID(),
		X = self.recycler:getX(),
		Y = self.recycler:getY(),
		Z = self.recycler:getZ()
	})

    ISBaseTimedAction.perform(self)
end


function CashoutTimedAction:new(recycler, character) -- What to call in you code
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
	o.recycler = recycler
    o.maxTime = 130 -- Time take by the action
    return o;
end





------------------------------------------------------------------------
--
--
--                     RECYCLER AUDIO SYSTEM (CLIENT)
--
--
------------------------------------------------------------------------

local RecyclerAudio = {}
RecyclerAudio.activeEmitters = {}
RecyclerAudio.globalRecyclerData = RecyclerAudio.globalRecyclerData or nil

local SOUND_NAME = "RecyclerMotorRunning"

local MAX_SOUND_DIST = 52
local MAX_DIST_SQ = MAX_SOUND_DIST * MAX_SOUND_DIST


local function getKey(x, y, z)
	return x .. "," .. y .. "," .. z
end


------------------------------------------------------------------------
--                        START EMITTER
------------------------------------------------------------------------

function RecyclerAudio.StartEmitter(x, y, z)
	local key = getKey(x, y, z)

	if RecyclerAudio.activeEmitters[key] then return end

	local square = getCell():getGridSquare(x, y, z)
	if not square then return end

	local emitter = getWorld():getFreeEmitter(x, y, z)
	if not emitter then
		print("Recycler Audio Manager: Failed to get free emitter at " .. x .. "," .. y .. "," .. z)
		return
	end

	if DEBUG_RECYCLER then
		print("StartEmitter adding local emitter:", key)
	end

	emitter:playSoundLoopedImpl(SOUND_NAME)
	RecyclerAudio.activeEmitters[key] =
	{
		emitter = emitter,
		x = x,
		y = y,
		z = z
	}
end


------------------------------------------------------------------------
--                          STOP EMITTER
------------------------------------------------------------------------

function RecyclerAudio.StopEmitter(x, y, z)
	local key = getKey(x, y, z)

	local data = RecyclerAudio.activeEmitters[key]

	if not data then return end

	if DEBUG_RECYCLER then
		print("StopEmitter removing local emitter:", key)
	end

	if data.emitter then
		data.emitter:stopAll()
		getWorld():returnOwnershipOfEmitter(data.emitter)
	end

	data.emitter = nil
	RecyclerAudio.activeEmitters[key] = nil
end


------------------------------------------------------------------------
--                   ACTIVE EMITTER CHECK
------------------------------------------------------------------------

function RecyclerAudio.IsEmitterActive(x, y, z)
	local key = getKey(x, y, z)
	return RecyclerAudio.activeEmitters[key] ~= nil
end


------------------------------------------------------------------------
--            CLIENT - SYNC EMITTER TO RECYCLER MOD DATA
------------------------------------------------------------------------

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
			if DEBUG_RECYCLER then
				print("Recycler Audio Manager: Recovered missing emitter at " .. x .. "," .. y .. "," .. z)
			end
			RecyclerAudio.StartEmitter(x, y, z)
		end
	else
		if emitterActive then
			if DEBUG_RECYCLER then
				print("Recycler Audio Manager: Removed ghost emitter at " .. x .. "," .. y .. "," .. z)
			end
			RecyclerAudio.StopEmitter(x, y, z)
		end
	end
end


------------------------------------------------------------------------
--                     STARTUP RECYCLER SYNCING
------------------------------------------------------------------------

local ticks = 0
local delayTicks = 120

local function StartupRecyclerAudioSync()
    ticks = ticks + 1

    if ticks < delayTicks then
        return
    end

	if isClient() then
		ModData.request("GN84_ActiveRecyclers")
	end

    local player = getPlayer()
    if not player then return end

    local px = math.floor(player:getX())
    local py = math.floor(player:getY())
    local pz = player:getZ()
    local radius = MAX_SOUND_DIST

    for x = px - radius, px + radius do
        for y = py - radius, py + radius do
            local square = getCell():getGridSquare(x, y, pz)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)

                    if instanceof(object, "IsoWorldInventoryObject") then
                        local item = object:getItem()
                        if item and item:getType() == "SmokeyShredderRecycler" then
                            local modData = item:getModData()
                            if modData and modData.RecyclerEnabled then
                                RecyclerAudio.SyncEmitterToModData(object)
                            end
                        end
                    end
                end
            end
        end
    end

    Events.OnTick.Remove(StartupRecyclerAudioSync)
end

Events.OnTick.Add(StartupRecyclerAudioSync)




------------------------------------------------------------------------
--
--
--                          GLOBAL MOD DATA
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                      Initialize Global ModData
------------------------------------------------------------------------

local function InitRecyclerGlobalData()
	local modData = ModData.getOrCreate("GN84_ActiveRecyclers")

	if not modData.list then
		modData.list = {}
	end
end

Events.OnInitGlobalModData.Add(InitRecyclerGlobalData)


------------------------------------------------------------------------
--                    Add Active Recycler to ModData
------------------------------------------------------------------------

local function AddActiveRecycler(x, y, z)
	local modData = ModData.getOrCreate("GN84_ActiveRecyclers")
	modData.list = modData.list or {}

	local key = getKey(x, y, z)
	local existing = modData.list[key]

	if existing and existing.x == x and existing.y == y and existing.z == z then
		return
	end

	modData.list[key] = {x = x, y = y, z = z}
	ModData.transmit("GN84_ActiveRecyclers")

	-- if DEBUG_RECYCLER then
	-- 	print("AddActiveRecycler:", key)
	-- end
end


------------------------------------------------------------------------
--                   Remove Active Recycle from ModData
------------------------------------------------------------------------

local function RemoveActiveRecycler(x, y, z)
	local modData = ModData.getOrCreate("GN84_ActiveRecyclers")
	modData.list = modData.list or {}

	local key = getKey(x, y, z)

	if not modData.list[key] then
		return
	end

	modData.list[key] = nil
	ModData.transmit("GN84_ActiveRecyclers")

	-- if DEBUG_RECYCLER then
	-- 	print("RemoveActiveRecycler:", key)
	-- end
end


------------------------------------------------------------------------
--                      FIND RECYCLER AT WORLD SQUARE
------------------------------------------------------------------------

local function getRecyclerAtSquare(x, y, z)
	local square = getCell():getGridSquare(x, y, z)
	if not square then return nil end

	local objects = square:getObjects()

	for i = 0, objects:size() - 1 do
		local obj = objects:get(i)

		if instanceof(obj, "IsoWorldInventoryObject") then
			local item = obj:getItem()
			if item and item:getType() == "SmokeyShredderRecycler" then
				return item
			end
		end
	end

	return nil
end


------------------------------------------------------------------------
--                       REMOVE STALE EMITTER
------------------------------------------------------------------------

local function RemoveStaleEmitter(x, y, z)
	local key = getKey(x, y, z)
	local data = RecyclerAudio.activeEmitters[key]

	if not data then return end

	if DEBUG_RECYCLER then
		print("[GN84-WNDR-TEST] \tForce removing stale emitter:\t" .. key)
	end

	if data.emitter then
		data.emitter:stopAll()
		getWorld():returnOwnershipOfEmitter(data.emitter)
		data.emitter = nil
	end

	RecyclerAudio.activeEmitters[key] = nil
end


------------------------------------------------------------------------
--                  REMOVE STALE EMITTER FROM MODDATA
------------------------------------------------------------------------

local function RemoveStaleRecyclerEntry(key)
	if RecyclerAudio.globalRecyclerData
	and RecyclerAudio.globalRecyclerData.list
	and RecyclerAudio.globalRecyclerData.list[key] then
		if DEBUG_RECYCLER then
			print("[GN84-WNDR-TEST] \tRemoving stale recycler from client cache:\t" .. key)
		end
		RecyclerAudio.globalRecyclerData.list[key] = nil
	end
end


------------------------------------------------------------------------
--                     CHECK GLOBAL RECYCLERS
------------------------------------------------------------------------

local function CheckGlobalRecyclers(overrideModData)
	if not isClient() then return end

	local player = getPlayer()
	if not player then return end

	local modData = overrideModData or RecyclerAudio.globalRecyclerData or ModData.get("GN84_ActiveRecyclers")
	if not modData or not modData.list then return end

	local px = player:getX()
	local py = player:getY()
	local seen = {}
	local staleKeys = {}

	for _, entry in pairs(modData.list) do
		local entryKey = getKey(entry.x, entry.y, entry.z)
		local valid = true

		local square = getCell():getGridSquare(entry.x, entry.y, entry.z)

		if square then
			local item = getRecyclerAtSquare(entry.x, entry.y, entry.z)

			if not item then
				if DEBUG_RECYCLER then
					print("[GN84-WNDR-TEST] \tActive list recycler missing locally:\t" .. entryKey)
				end
				RemoveStaleEmitter(entry.x, entry.y, entry.z)
				table.insert(staleKeys, entryKey)
				valid = false
			else
				local itemModData = item:getModData()

				if not itemModData or not itemModData.RecyclerEnabled then
					if DEBUG_RECYCLER then
						print("[GN84-WNDR-TEST] \tActive list recycler disabled locally:\t" .. entryKey)
					end
					RecyclerAudio.StopEmitter(entry.x, entry.y, entry.z)
					valid = false
				end
			end
		end

		if valid then
			seen[entryKey] = true

			local dx = entry.x - px
			local dy = entry.y - py
			local distSq = dx * dx + dy * dy

			if distSq <= MAX_DIST_SQ then
				RecyclerAudio.StartEmitter(entry.x, entry.y, entry.z)
			else
				RecyclerAudio.StopEmitter(entry.x, entry.y, entry.z)
			end
		end
	end

	-- Remove stale keys after iteration
	for i = 1, #staleKeys do
		local key = staleKeys[i]

		if modData.list and modData.list[key] then
			if DEBUG_RECYCLER then
				print("[GN84-WNDR-TEST] \tRemoving stale recycler from current modData:\t" .. key)
			end
			modData.list[key] = nil
		end

		RemoveStaleRecyclerEntry(key)
	end

	for key, data in pairs(RecyclerAudio.activeEmitters) do
		if not seen[key] then
			local square = getCell():getGridSquare(data.x, data.y, data.z)

			if not square then
				if DEBUG_RECYCLER then
					print("[GN84-WNDR-TEST] \tCleanup skipped, square not loaded:\t" .. key)
				end
			else
				local item = getRecyclerAtSquare(data.x, data.y, data.z)

				if not item then
					if DEBUG_RECYCLER then
						print("[GN84-WNDR-TEST] \tCleanup removing emitter, recycler missing:\t" .. key)
					end
					RemoveStaleEmitter(data.x, data.y, data.z)
					RemoveStaleRecyclerEntry(key)
				else
					local itemModData = item:getModData()

					if not itemModData or not itemModData.RecyclerEnabled then
						if DEBUG_RECYCLER then
							print("[GN84-WNDR-TEST] \tCleanup removing emitter, recycler disabled:\t" .. key)
						end
						RecyclerAudio.StopEmitter(data.x, data.y, data.z)
					else
						if DEBUG_RECYCLER then
							print("[GN84-WNDR-TEST] \tCleanup keeping emitter, local recycler still enabled:\t" .. key)
						end
					end
				end
			end
		end
	end
end

Events.EveryOneMinute.Add(CheckGlobalRecyclers)


------------------------------------------------------------------------
--                 ON RECEIVE GLOBAL MOD DATA SYNC
------------------------------------------------------------------------

local function OnReceiveRecyclerGlobalData(key, modData)
	if not isClient() then return end
	if key ~= "GN84_ActiveRecyclers" then return end

	RecyclerAudio.globalRecyclerData = modData

	if DEBUG_RECYCLER then
		print("[GN84-WNDR-TEST] \tReceived global recycler modData")
	end

	CheckGlobalRecyclers(modData)
end

Events.OnReceiveGlobalModData.Remove(OnReceiveRecyclerGlobalData)
Events.OnReceiveGlobalModData.Add(OnReceiveRecyclerGlobalData)


------------------------------------------------------------------------
--                RECYCLER CLEANUP ON WORLD REMOVAL
------------------------------------------------------------------------

local function RecyclerCleanup(object)
	if not isServer() then return end

	if instanceof(object, "IsoWorldInventoryObject") then
		local item = object:getItem()
		if item and item:getType() == "SmokeyShredderRecycler" then
			RemoveActiveRecycler(object:getX(), object:getY(), object:getZ())
		end
	end
end

Events.OnObjectAboutToBeRemoved.Add(RecyclerCleanup)




------------------------------------------------------------------------
--
--
--                       RECYCLER FUNCTIONS
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                         ATTRACT ZOMBIES
------------------------------------------------------------------------

AttractZombiesToRecycler = function(player, uniqueOdds)
	local odds = 1
	local attractRoll = ZombRand(0, 101)

	if uniqueOdds and type(uniqueOdds) == "number" then
		odds = uniqueOdds
	end

	-- print("Odds: ", odds)
	if attractRoll <= odds then
		-- print("Attracting Zombies to Recycler")
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100)
	end
end


------------------------------------------------------------------------
--                      VALID RECYCLER ITEMS
------------------------------------------------------------------------

-- local recyclerItems =
-- {
-- 	"Base.Money",
-- 	"GN84-WNDR.MoneyStackX",
-- 	"GN84-WNDR.WandererTokenStackX",
-- 	"GN84-WNDR.MoneyStack100",
-- 	"GN84-WNDR.MoneyStack500",
-- 	"GN84-WNDR.MoneyStack1000",
-- 	"GN84-WNDR.MoneyStack5000",
-- 	"GN84-WNDR.MoneyStack10000",
-- 	"GN84-WNDR.MoneyStack50000",
-- 	"GN84-WNDR.MoneyStack100000",
-- 	"GN84-WNDR.MoneyStack500000",
-- 	"GN84-WNDR.MoneyStack1000000",
-- 	"GN84-WNDR.MoneyStack5000000",
-- 	"GN84-WNDR.MoneyStack10000000",
-- 	"GN84-WNDR.WandererToken",
-- 	"GN84-WNDR.WandererTokenStack5",
-- 	"GN84-WNDR.WandererTokenStack10",
-- 	"GN84-WNDR.WandererTokenStack25",
-- 	"GN84-WNDR.WandererTokenStack50",
-- 	"GN84-WNDR.WandererTokenStack100",
-- 	"GN84-WNDR.WandererTokenStack250",
-- 	"GN84-WNDR.WandererTokenStack500",
-- 	"GN84-WNDR.WandererTokenStack1000",
-- 	"GN84-WNDR.WandererTokenStack5000",
-- }

-- function GN84_AcceptItemsRecycler(container, item)

-- 	for i = 1, #recyclerItems do
--     	if item:getFullType() == recyclerItems[i] then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end


------------------------------------------------------------------------
--                    CREATE CUSTOM STACK OF CASH
------------------------------------------------------------------------

CreateCash = function(amount, recycler)
    if not amount then return end

    -- Instantiate MoneyStackX Item
    local moneyStackX = InventoryItemFactory.CreateItem("GN84-WNDR.MoneyStackX")
	if not moneyStackX then return end

	local moneyStackData = moneyStackX:getModData()
    if not moneyStackData then return end

	-- Set Money Stack Amount in modData
    moneyStackData.CashAmount = amount

    -- Rename Money Stack to Reflect Cash Amount
    moneyStackX:setName(moneyStackX:getName() .. "  -  $" .. Utils.CurrencyFormatter(moneyStackData.CashAmount))

	if recycler then
		recycler:getInventory():addItemOnServer(moneyStackX)

		if isServer() then
			sendItemsInContainer(recycler, recycler:getInventory())
			print("isServer")
		else
			print("isClient")
		end

		recycler:getContainer():setDrawDirty(true);
	else
		local player = getPlayer()
		if not player then return end

		player:getInventory():AddItem(moneyStackX)
	end
end


------------------------------------------------------------------------
--                      PLAYER PROXIMITY CHECK
------------------------------------------------------------------------

local INTERACT_DIST = 2.75
local INTERACT_DIST_SQ = INTERACT_DIST * INTERACT_DIST

local function IsPlayerNearRecycler(player, object)
	if not player or not object then return false end

	local dx = object:getX() - player:getX()
	local dy = object:getY() - player:getY()
	local dz = math.abs(object:getZ() - player:getZ())

	if dz > 0 then
		return false
	end

	local distSq = dx * dx + dy * dy

	return distSq <= INTERACT_DIST_SQ
end



local function IsRecyclerBusy(recycler)
	if not recycler then return false end

	local item = recycler

	-- If a world object was passed in, extract the InventoryItem from it.
	if recycler.getItem then
		item = recycler:getItem()
	end

	if not item then return false end

	local modData = item:getModData()
	if not modData then return false end

	local busyUntil = modData.ActionBusyUntil or 0

	return getTimeInMillis() < busyUntil
end




------------------------------------------------------------------------
--
--
--                      CONTEXT MENU FUNCTIONS
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                            CASH OUT
------------------------------------------------------------------------

local function CashOutBalance(target, recycler, player)
	if not recycler then return	end

	ISTimedActionQueue.add(CashoutTimedAction:new(recycler, player))
end


------------------------------------------------------------------------
--                      ACTIVATE RECYCLER (ADMIN)
------------------------------------------------------------------------

---@param player IsoPlayer
---@param recycler IsoWorldInventoryObject
local function ActivateRecycler(player, recycler)
	if not recycler then return end

	local modData = recycler:getItem():getModData()
	if not modData then return end

	modData.RecyclerActivated = true
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	-- Make Recycler Unmovable
	recycler:getItem():setActualWeight(2000)
	recycler:getItem():setCustomWeight(true)

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = recycler:getItem():getID(),
		X = recycler:getX(),
		Y = recycler:getY(),
		Z = recycler:getZ(),
		RecyclerActivated = true,
		RecyclerEnabled = false,
		CashBalance = 0,
		ClearCurrentUser = true,
		RecyclerLastUsed = modData.RecyclerLastUsed
	})
end


------------------------------------------------------------------------
--                     DEACTIVATE RECYCLER (ADMIN)
------------------------------------------------------------------------

---@param player IsoPlayer
---@param recycler IsoWorldInventoryObject
local function DeActivateRecycler(player, recycler)
	if not recycler then return end

	local modData = recycler:getItem():getModData()
	if not modData then return end

	modData.RecyclerActivated = false
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	-- Reset Recycler Weight
	recycler:getItem():setActualWeight(50)
	recycler:getItem():setCustomWeight(true)

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
	{
		RecyclerID = recycler:getItem():getID(),
		X = recycler:getX(),
		Y = recycler:getY(),
		Z = recycler:getZ(),
		RecyclerActivated = false,
		RecyclerEnabled = false,
		CashBalance = 0,
		ClearCurrentUser = true,
		RecyclerLastUsed = modData.RecyclerLastUsed
	})
end


------------------------------------------------------------------------
--                            POWER ON
------------------------------------------------------------------------

local function PowerOnRecycler(target, recycler, player)
	if not recycler then return end

	ISTimedActionQueue.add(PowerOnTimedAction:new(recycler, player))
end


------------------------------------------------------------------------
--                            POWER OFF
------------------------------------------------------------------------

local function PowerOffRecycler(target, recycler, player)
	if not recycler then return end

	ISTimedActionQueue.add(PowerOffTimedAction:new(recycler, player))
end


------------------------------------------------------------------------
--                             RESET
------------------------------------------------------------------------

local function ResetRecycler(target, recycler, player)
	if not recycler then return end

	ISTimedActionQueue.add(ResetRecyclerTimedAction:new(recycler, player))
end

local function AdminPurgeRecyclers(player)
	if not isClient() then return end

	sendClientCommand("GN84-WNDR", "PurgeAllRecyclers", {})
end




------------------------------------------------------------------------
--
--                          CONTEXT MENU
--
------------------------------------------------------------------------

local function RecyclerContext(playerNum, context, worldObjects, test)
	local player = getPlayer()
	if not player then return end

	local username = player:getUsername()

	-- Admin Recovery Command
	if isAltKeyDown() and isShiftKeyDown() and getAccessLevel() == "admin" then
		context:addOptionOnTop("(ADMIN) Purge All Active Recycler Data", nil, AdminPurgeRecyclers, player)
	end

	local objects = worldObjects[1] and worldObjects[1]:getSquare():getObjects()

    for i = 0, objects:size()-1 do

	---@type IsoWorldInventoryObject
    local object = objects:get(i)
        if instanceof(object, "IsoWorldInventoryObject") and object:getItem():getType() == "SmokeyShredderRecycler" then

			local modData = object:getItem():getModData()

			-- Check Player Proximity to Recycler
			if not IsPlayerNearRecycler(player, object) then
				local tooFar = context:addOptionOnTop("Too Far Away", nil, nil)
				tooFar.notAvailable = true

				local toolTip = ISWorldObjectContextMenu:addToolTip()
				toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Move Closer<LINE><LINE><RGB:1,1,1,1>You must be within 3 tiles to use the Recycler.")
				tooFar.toolTip = toolTip
				return
			end

			-- Self Heal Emitter State
			if modData.RecyclerEnabled ~= nil then
				RecyclerAudio.SyncEmitterToModData(object)
			end

			if IsRecyclerBusy(object) then
				local busyOption = context:addOptionOnTop("Recycler Busy", nil, nil)
				busyOption.notAvailable = true

				local toolTip = ISWorldObjectContextMenu.addToolTip()
				toolTip.description = getText("<SIZE:medium><RGB:1.0,0.6,0.11,1>Machine Busy - Operation in Progress<LINE><LINE><RGB:0.0,0.886,1.0,1>Please Wait")
				busyOption.toolTip = toolTip
				return
			end


			-- Clean Divider for Context Menu Options
			local divider = context:addOptionOnTop("", nil, nil)

			-- Admin Activate/Deactivate/Purge
			if isAltKeyDown() then
				if getAccessLevel() == "admin" then
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
					statusText = " Session Active"
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

						local option = context:addOptionOnTop("Start New Session", nil, ResetRecycler, object, player)

						local toolTip = ISWorldObjectContextMenu.addToolTip()
						toolTip.description = getText("<SIZE:medium><RGB:0.0,0.886,1.0,1>Starts a New Session<LINE><LINE><RGB:0.2,1,0.2>Deposits <SPACE><SPACE><RGB:1,1,1,1> Remaining Balance into Previous User's Smokey Bank")
						option.toolTip = toolTip

						return
					else

						local unauthorized = context:addOptionOnTop("Unauthorized:  Recycler In Use", nil, nil)
						unauthorized.notAvailable = true

						local toolTip = ISWorldObjectContextMenu.addToolTip()

						-- Display Session Timeout
						if timeoutInMinutes < 1 then
							toolTip.description = getText("<SIZE:medium><RGB:1.0,0.6,0.11,1>Recycler In Use<LINE><LINE><RGB:1,1,1,1>Time Remaining:<SPACE><SPACE>" .. math.ceil(timeoutInSeconds) .. " Seconds")
						else
							toolTip.description = getText("<SIZE:medium><RGB:1.0,0.6,0.11,1>Recycler In Use<LINE><LINE><RGB:1,1,1,1>Time Remaining:<SPACE><SPACE>" .. math.floor(timeoutInMinutes) .. ":" .. formattedSeconds)
						end

						unauthorized.toolTip = toolTip

						return
					end
				elseif (modData.CurrentUser == username) and (currentTime > timeoutEnd) then

					local status = context:addOptionOnTop("Status:  Session Expired", nil, nil)
					status.notAvailable = true

					local statustoolTip = ISWorldObjectContextMenu.addToolTip()
					statustoolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Your Session Has Expired<LINE><LINE><RGB:0.0,0.886,1.0,1>Please Start New Session to Continue")
					status.toolTip = statustoolTip


					local option = context:addOptionOnTop("Start New Session", nil, ResetRecycler, object, player)

					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<SIZE:medium><RGB:0.0,0.886,1.0,1>Starts a New Session")

					if (modData.CashBalance or 0) > 0 then
						toolTip.description = getText("<SIZE:medium><RGB:0.0,0.886,1.0,1>Starts a New Session<LINE><LINE><RGB:0.2,1,0.2>Deposits <SPACE><SPACE><RGB:1,1,1,1> Remaining Balance into Previous User's Smokey Bank")
					end

					option.toolTip = toolTip

					return
				end

				if modData.RecyclerEnabled then

					if modData.CashBalance then
						if (modData.CashBalance or 0) > 0 then

							local option = context:addOptionOnTop("Turn Off Recycler", nil, nil)
							option.notAvailable = true

							local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
							toggletoolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>-> Cash Out <- <RGB:1.0,0.6,0.11,1><SPACE><SPACE><RGB:1,1,1,1>before Powering Down Recycler")
							option.toolTip = toggletoolTip

							local cashBalance = modData.CashBalance or 0
							cashBalance = Utils.CurrencyFormatter(cashBalance)

							local cashOut = context:addOptionOnTop("-> Cash Out <-", nil, CashOutBalance, object, player)
							local balance = context:addOptionOnTop("Balance:  $" .. cashBalance, nil,nil)

							local toolTip = ISWorldObjectContextMenu.addToolTip()
							toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Click to Cash Out!<LINE><LINE><RGB:0.0,0.886,1.0,1>Deposits Cash Balance into Smokey Bank")
							cashOut.toolTip = toolTip
						else

							local option = context:addOptionOnTop("Turn Off Recycler", nil, PowerOffRecycler, object, player)

							local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
							toggletoolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Turns Off <SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.0,0.886,1.0,1>Ends Current Session")
							option.toolTip = toggletoolTip

							local balance = context:addOptionOnTop("Balance: $0", nil, nil)
							balance.notAvailable = true

							local toolTip = ISWorldObjectContextMenu.addToolTip()
							toolTip.description = getText("<SIZE:medium><RGB:0.0,0.886,1.0,1>Recycle Items to Earn Cash!")
							balance.toolTip = toolTip
						end
					end

					local status = context:addOptionOnTop("Status: " .. statusText, nil, nil)
					status.notAvailable = false

					local toolTip = ISWorldObjectContextMenu.addToolTip()

					-- Display Session Timer
					if timeoutInMinutes < 1 then
						toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Session Active<LINE><LINE><RGB:0.0,0.886,1.0,1>User:  " .. modData.CurrentUser .. "<LINE><RGB:1,1,1,1>Time Remaining:<SPACE><SPACE>" .. math.ceil(timeoutInSeconds) .. " Seconds<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!")
					else
						toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Session Active<LINE><LINE><RGB:0.0,0.886,1.0,1>User:  " .. modData.CurrentUser .. "<LINE><RGB:1,1,1,1>Time Remaining:<SPACE><SPACE>" .. math.floor(timeoutInMinutes) .. ":" .. formattedSeconds .. "<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!")
					end

					status.toolTip = toolTip


				elseif not modData.RecyclerEnabled then

					local option = context:addOptionOnTop("Turn On Recycler", nil, PowerOnRecycler, object, player)

					local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
					toggletoolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Turns On<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.0,0.886,1.0,1>Starts a New Session<LINE><LINE><RGB:1.0,0.6,0.11,1>[SECURED TO OPERATOR]<LINE><RGB:0.0,0.886,1.0,1>[AUTO-UNLOCK: 5 MIN]")
					option.toolTip = toggletoolTip

					local status = context:addOptionOnTop("Status: " .. statusText, nil, nil)
					status.notAvailable = true

					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Recycler is Powered Down.<LINE><LINE><RGB:0.0,0.886,1.0,1>Turn On to Recycle Items.")
					status.toolTip = toolTip

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
--                      ITEM MOD DATA SYNCING
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                    GET RECYCLER WORLD OBJECT
------------------------------------------------------------------------

getWorldItemByID = function(x, y, z, id)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return nil end

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
--                   GET RECYCLER INVENTORY ITEM
------------------------------------------------------------------------

getRecyclerObject = function(sources)
	for i = 0, sources:size() - 1 do
		---@type InventoryItem
		local item = sources:get(i)
		if item:getType() == "SmokeyShredderRecycler" then
			return item
		end
	end
end

------------------------------------------------------------------------
--                      HANDLE RECYCLER CASHOUT
------------------------------------------------------------------------

local function HandleRecyclerCashout(player, args)
	if not player or not args then
		return
	end

	local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
	if not recycler then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: recycler not found")
		end
		return
	end

	local modData = recycler:getModData()
	if not modData then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: modData missing")
		end
		return
	end

	if not modData.RecyclerActivated then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: recycler not activated")
		end
		return
	end

	if not modData.RecyclerEnabled then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: recycler not enabled")
		end
		return
	end

	local actualUsername = player:getUsername()
	if modData.CurrentUser ~= actualUsername then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: player does not own recycler lock")
		end
		return
	end

	if not IsPlayerNearRecycler(player, recycler:getWorldItem()) then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: player too far from recycler")
		end
		return
	end

	local MAX_RECYCLER_CASHOUT = 1000000

	local amount = modData.CashBalance or 0
	if amount <= 0 then
		if DEBUG_RECYCLER then
			print("RequestRecyclerCashout: no balance to cash out")
		end
		return
	end

	local approvedAmount = math.min(amount, MAX_RECYCLER_CASHOUT)

	if DEBUG_RECYCLER then
		if approvedAmount < amount then
			print("RequestRecyclerCashout: partial payout approved " .. tostring(approvedAmount) .. ", remainder " .. tostring(amount - approvedAmount))
		end

		print("Recycler cashout approved")
		print("User: " .. tostring(actualUsername))
		print("Amount: " .. tostring(amount))
	end

	modData.CashBalance = amount - approvedAmount
	modData.ActionBusyUntil = 0
	modData.RecyclerLastUsed = getTimeInMillis()

	-- SYNC WITH ALL CLIENTS
	sendServerCommand("GN84-WNDR", "ReceiveRecyclerModDataFromServer",
	{
		RecyclerID = args.RecyclerID,
		X = args.X,
		Y = args.Y,
		Z = args.Z,
		RecyclerActivated = modData.RecyclerActivated,
		RecyclerEnabled = modData.RecyclerEnabled,
		CashBalance = modData.CashBalance,
		CurrentUser = modData.CurrentUser,
		RecyclerLastUsed = modData.RecyclerLastUsed,
		ActionBusyUntil = modData.ActionBusyUntil
	})

	-- APPROVE CASHOUT FOR REQUESTING PLAYER
	sendServerCommand(player, "GN84-WNDR", "RecyclerCashoutApproved",
	{
		RecyclerID = args.RecyclerID,
		X = args.X,
		Y = args.Y,
		Z = args.Z,
		Amount = approvedAmount
	})
end


local function DepositCashLoopback(args)

	if not args then
		return
	end

	local username = args.Username
	local amount = args.Amount or 0

	if not username or username == "" then
		return
	end

	if type(amount) ~= "number" or amount <= 0 then
		return
	end

	sendClientCommand("GN84-WNDR", "depositCash",
	{
		username,
		amount
	})

	local recycler = nil

	if args.RecyclerID and args.X and args.Y and args.Z then
		recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
	end

	if recycler then
		local worldItem = recycler:getWorldItem()
		local square = worldItem and worldItem:getSquare() or nil

		if square then
			local emitter = getWorld():getFreeEmitter(args.X, args.Y, args.Z)
			if emitter then
				emitter:playSound("ReceiptSound", recycler:getWorldItem():getSquare())
			end
		end
	end
end


------------------------------------------------------------------------
--                  HANDLE RECYCLER RESET AND NEW USER
------------------------------------------------------------------------

local function HandleRecyclerResetAndNewUser(player, args)
	if not player or not args then
		return
	end

	local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
	if not recycler then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: recycler not found")
		end
		return
	end

	local modData = recycler:getModData()
	if not modData then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: modData missing")
		end
		return
	end

	if not modData.RecyclerActivated then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: recycler not activated")
		end
		return
	end

	if not modData.RecyclerEnabled then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: recycler not enabled")
		end
		return
	end

	if not modData.CurrentUser then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: no current user to reset from")
		end
		return
	end

	local now = getTimeInMillis()
	local lastUsed = modData.RecyclerLastUsed or 0
	local timeoutMs = recyclerTimeout * MS_TO_MINUTES
	local timedOut = now > (lastUsed + timeoutMs)

	if not timedOut then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: session not timed out")
		end
		return
	end

	local previousUser = modData.CurrentUser
	local amount = modData.CashBalance or 0

	local actualUsername = player:getUsername()
	if args.username ~= actualUsername then
		if DEBUG_RECYCLER then
			print("RequestRecyclerResetAndNewUser: username mismatch")
		end
		return
	end

	local newUser = actualUsername

	if DEBUG_RECYCLER then
		print("Recycler reset handoff starting")
		print("Previous User: " .. tostring(previousUser))
		print("New User: " .. tostring(newUser))
		print("Previous Balance: " .. tostring(amount))
	end

	-- Deposit old balance to previous user BEFORE ownership transfer.
	if previousUser and previousUser ~= "" and amount > 0 then
		if DEBUG_RECYCLER then
			print("Depositing previous recycler balance of " .. tostring(amount) .. " to " .. tostring(previousUser))
		end

		sendServerCommand(player, "GN84-WNDR", "DepositCashLoopback",
		{
			Username = previousUser,
			Amount = amount,
			RecyclerID = args.RecyclerID,
			X = args.X,
			Y = args.Y,
			Z = args.Z
		})
	end

	modData.CashBalance = 0
	modData.CurrentUser = newUser
	modData.RecyclerEnabled = true
	modData.RecyclerLastUsed = now
	modData.ActionBusyUntil = 0

	AddActiveRecycler(args.X, args.Y, args.Z)

	sendServerCommand("GN84-WNDR", "ReceiveRecyclerModDataFromServer",
	{
		RecyclerID = args.RecyclerID,
		X = args.X,
		Y = args.Y,
		Z = args.Z,
		RecyclerActivated = modData.RecyclerActivated,
		RecyclerEnabled = modData.RecyclerEnabled,
		CashBalance = modData.CashBalance,
		CurrentUser = modData.CurrentUser,
		RecyclerLastUsed = modData.RecyclerLastUsed,
		ActionBusyUntil = modData.ActionBusyUntil
	})
end


------------------------------------------------------------------------
--
--                       (CLIENT > SERVER)  SYNC
--
------------------------------------------------------------------------

local function ReceiveRecyclerModDataFromClient(module, command, player, args)
	if module ~= "GN84-WNDR" then return end


	if command == "PurgeAllRecyclers" then
		if not player or player:getAccessLevel() ~= "Admin" then
			print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  1360  |  FUNCTION:  PurgeAllRecyclers  |  WARN:  Unauthorized PurgeAllRecyclers Attempt!")
			return
		end

		if DEBUG_RECYCLER then
			print("ADMIN: Purging all Active Recyclers")
		end
		player:Say("ADMIN: Purging all Active Recyclers")

		local modData = ModData.getOrCreate("GN84_ActiveRecyclers")
		modData.list = {}

		ModData.transmit("GN84_ActiveRecyclers")

		sendServerCommand("GN84-WNDR", "ClientPurgeAllRecyclers", {})
	end


	if command == "RequestRecyclerLock" then
		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
		if not recycler then return end

		local modData = recycler:getModData()
		if not modData then return end

		if not modData.RecyclerActivated then return end
		if modData.RecyclerEnabled then return end
		if modData.CurrentUser then return end
		if IsRecyclerBusy(recycler) then return end

		if not modData.CurrentUser then
			local actualUsername = player:getUsername()
			modData.CurrentUser = actualUsername

			sendServerCommand(player, "GN84-WNDR", "ReceiveRecyclerLockConfirmation",
			{
				RecyclerID = args.RecyclerID,
				X = args.X,
				Y = args.Y,
				Z = args.Z,
				CurrentUser = modData.CurrentUser
			})
		end
	end


	if command == "RequestRecyclerResetAndNewUser" then
		HandleRecyclerResetAndNewUser(player, args)
		return
	end


	if command == "RequestRecyclerCashout" then
		HandleRecyclerCashout(player, args)
		return
	end


	if command == "ReceiveRecyclerModDataFromClient" then

		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
		if not recycler then return end

		local modData = recycler:getModData()
		if not modData then return end

		-- SYNC VALID MOD DATA ON SERVER

		if args.RecyclerActivated ~= nil then
			modData.RecyclerActivated = args.RecyclerActivated
		end

		if args.RecyclerEnabled ~= nil then
			modData.RecyclerEnabled = args.RecyclerEnabled
		end

		if args.CashBalance ~= nil then
			modData.CashBalance = args.CashBalance
		end

		if args.ClearCurrentUser then
			modData.CurrentUser = nil
		elseif args.CurrentUser ~= nil then
			modData.CurrentUser = args.CurrentUser
		end

		if args.RecyclerLastUsed ~= nil then
			modData.RecyclerLastUsed = args.RecyclerLastUsed
		end

		if args.ActionBusyUntil ~= nil then
			modData.ActionBusyUntil = args.ActionBusyUntil
		end

		if modData.RecyclerEnabled then
			AddActiveRecycler(args.X, args.Y, args.Z)
		else
			RemoveActiveRecycler(args.X, args.Y, args.Z)
		end

		-- Send Full Mod Data back to All Clients
		sendServerCommand("GN84-WNDR", "ReceiveRecyclerModDataFromServer",
		{
			RecyclerID = args.RecyclerID,
			X = args.X,
			Y = args.Y,
			Z = args.Z,
			RecyclerActivated = modData.RecyclerActivated,
			RecyclerEnabled = modData.RecyclerEnabled,
			CashBalance = modData.CashBalance,
			CurrentUser = modData.CurrentUser,
			RecyclerLastUsed = modData.RecyclerLastUsed,
			ActionBusyUntil = modData.ActionBusyUntil
		})
	end
end

Events.OnClientCommand.Remove(ReceiveRecyclerModDataFromClient)
Events.OnClientCommand.Add(ReceiveRecyclerModDataFromClient)




------------------------------------------------------------------------
--
--                    (SERVER > ALL CLIENTS) SYNC
--
------------------------------------------------------------------------

local function ReceiveRecyclerModDataFromServer(module, command, args)
	if module ~= "GN84-WNDR" then return end


	if command == "ClientPurgeAllRecyclers" then
		if DEBUG_RECYCLER then
			print("CLIENT: Purging all recycler emitters")
		end

		local keysToPurge = {}

		for key, data in pairs(RecyclerAudio.activeEmitters) do
			table.insert(keysToPurge, {x = data.x, y = data.y, z = data.z})
		end

		for i = 1, #keysToPurge do
			local entry = keysToPurge[i]
			RecyclerAudio.StopEmitter(entry.x, entry.y, entry.z)
		end

		RecyclerAudio.activeEmitters = {}
		RecyclerAudio.globalRecyclerData = { list = {} }
	end


	if command == "ReceiveRecyclerLockConfirmation" then
		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)

		if not recycler then return end

		local modData = recycler:getModData()
		if not modData then return end

		modData.CurrentUser = args.CurrentUser
	end


	if command == "RecyclerCashoutApproved" then
		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)

		local player = getPlayer()
		if not player then
			return
		end

		local amount = args.Amount or 0
		if amount <= 0 then
			if DEBUG_RECYCLER then
				print("RecyclerCashoutApproved: invalid approved amount")
			end
			return
		end

		sendClientCommand("GN84-WNDR", "depositCash",
		{
			player:getUsername(),
			amount
		})

		player:Say("Deposited:  $" .. Utils.CurrencyFormatter(amount))
		player:Say("Funds transferred successfully")

		if recycler then
			local worldItem = recycler:getWorldItem()
			local square = worldItem and worldItem:getSquare() or nil

			if square then
				local emitter = getWorld():getFreeEmitter(args.X, args.Y, args.Z)
				if emitter then
					emitter:playSound("ReceiptSound", recycler:getWorldItem():getSquare())
				end
			end
		end

		return
	end


	if command == "DepositCashLoopback" then
		DepositCashLoopback(args)
		return
	end


	if command == "ReceiveRecyclerModDataFromServer" then

		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
		if not recycler then return end

		local modData = recycler:getModData()
		if not modData then return end

		-- SYNC LOCAL CLIENT MOD DATA
		modData.RecyclerActivated = args.RecyclerActivated
		modData.RecyclerEnabled = args.RecyclerEnabled
		modData.CashBalance = args.CashBalance
		modData.CurrentUser = args.CurrentUser
		modData.RecyclerLastUsed = args.RecyclerLastUsed
		modData.ActionBusyUntil = args.ActionBusyUntil

		if isClient() then
			if modData.RecyclerEnabled then
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
--
--
--                         SCRIPT FUNCTIONS
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                   CHECK IF RECYCLER IS POWERED ON
------------------------------------------------------------------------

local function IsRecyclerEnabled(recycler)
	if not recycler then return false end

	local modData = recycler:getModData()

	if not modData then return false end

	if modData.RecyclerEnabled then
		return true
	else
		return false
	end
end


------------------------------------------------------------------------
--           CHECK IF RECYCLER WAS USED TO INITIATE REQUEST
------------------------------------------------------------------------

function GN84_IsRecyclerUsed(recipe, character, item)
	if item == nil then return true end

	if item:getType() == "SmokeyShredderRecycler" then
		return true
	else
		return false
	end
end


------------------------------------------------------------------------
--      CHECK IF RECYCLER ENABLED AND ITEMS NOT FAVORITE / EQUIPPED
------------------------------------------------------------------------

function GN84_IsRecycleable(item, result)
	if item:getType() == "SmokeyShredderRecycler" then

		if not IsRecyclerEnabled(item) then
			return false
		end

		local modData = item:getModData()
		if modData.CurrentUser ~= getPlayer():getUsername() then
			return false
		end
	end

	if item:isFavorite() or item:isEquipped() then
		return false
	end

	if instanceof(item, "InventoryContainer") then
		local innerInventory = item:getInventory()
		if innerInventory and not innerInventory:isEmpty() then
			return false
		end
	end

	return true
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
--                              RECIPES
--
--
------------------------------------------------------------------------

------------------------------------------------------------------------
--                           HELPER FUNCTIONS
------------------------------------------------------------------------

local function SyncRecyclerModData(recycler, modData)
    local worldItem = recycler:getWorldItem()

    sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient",
    {
        RecyclerID = recycler:getID(),
        X = worldItem:getX(),
        Y = worldItem:getY(),
        Z = worldItem:getZ(),
        CashBalance = modData.CashBalance,
        RecyclerLastUsed = modData.RecyclerLastUsed
    })
end


local function DebugRecycleRange(multiplier, minValue, maxValue, valueRoll, finalValue)
    if not DEBUG_RECYCLER then return end

    print("Item Condition: ", multiplier)
    print("Min Value: ", minValue)
    print("Max Value: ", maxValue)
    print("Value Roll: ", valueRoll)
    print("Final Value: ", finalValue)
end


local function DebugRecycleFixed(multiplier, finalValue)
    if not DEBUG_RECYCLER then return end

    print("Item Condition: ", multiplier)
    print("Final Value: ", finalValue)
end


local function ExecuteRecycleRange(sources, player, minValue, maxValue, noise)
    if not sources then return end

    local recycler = getRecyclerObject(sources)
    if not recycler then return end

    local valueRoll = ZombRand(minValue, maxValue) + 1
    local multiplier = GetConditionScalar(sources)
    local finalValue = math.max(1, math.floor(valueRoll * multiplier * recyclerValueMultiplier))

    DebugRecycleRange(multiplier, minValue, maxValue, valueRoll, finalValue)

    local modData = recycler:getModData()
    if not modData then return end

    modData.CashBalance = modData.CashBalance + finalValue
    modData.RecyclerLastUsed = getTimeInMillis()

    SyncRecyclerModData(recycler,
	{
		CashBalance = modData.CashBalance,
		RecyclerLastUsed = modData.RecyclerLastUsed
	})
    AttractZombiesToRecycler(player, noise)
end


local function ExecuteRecycleFixed(sources, player, baseValue, noise)
    if not sources then return end

    local recycler = getRecyclerObject(sources)
    if not recycler then return end

    local multiplier = GetConditionScalar(sources)
    local finalValue = math.max(1, math.floor(baseValue * multiplier * recyclerValueMultiplier))

    DebugRecycleFixed(multiplier, finalValue)

    local modData = recycler:getModData()
    if not modData then return end

    modData.CashBalance = modData.CashBalance + finalValue
    modData.RecyclerLastUsed = getTimeInMillis()

    SyncRecyclerModData(recycler,
	{
		CashBalance = modData.CashBalance,
		RecyclerLastUsed = modData.RecyclerLastUsed
	})
    AttractZombiesToRecycler(player, noise)
end


local function PlayRecyclerShreddingSound(sources, soundName)
	local recycler = getRecyclerObject(sources)
    if not recycler then return end
	local recyclerWorldObject = recycler:getWorldItem()

	local emitter = getWorld():getFreeEmitter(recyclerWorldObject:getX(), recyclerWorldObject:getY(), recyclerWorldObject:getZ())
    if emitter then
        emitter:playSound(soundName, recyclerWorldObject:getSquare())
    end
	emitter = nil
end


------------------------------------------------------------------------
--
--                           JEWELRY ITEMS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                              WATCHES
------------------------------------------------------------------------

function ShredderRecycleWatchesGlasses(sources, result, player, item)
    ExecuteRecycleRange(sources, player, watchesGlassesMinValue, watchesGlassesMaxValue, 3)

	PlayRecyclerShreddingSound(sources, "RecyclerJewelry")
end


------------------------------------------------------------------------
--                         JEWELRY - SIMPLE
------------------------------------------------------------------------

function ShredderRecycleJewelrySimple(sources, result, player, item)
    ExecuteRecycleRange(sources, player, jewelrySimpleMinValue, jewelrySimpleMaxValue, 3)

	PlayRecyclerShreddingSound(sources, "RecyclerJewelry")
end


------------------------------------------------------------------------
--                         JEWELRY - PRECIOUS
------------------------------------------------------------------------

function ShredderRecycleJewelryPrecious(sources, result, player, item)
    ExecuteRecycleRange(sources, player, jewelryPreciousMinValue, jewelryPreciousMaxValue, 2)

	PlayRecyclerShreddingSound(sources, "RecyclerJewelry")
end


------------------------------------------------------------------------
--                         JEWELRY - GEMSTONES
------------------------------------------------------------------------

function ShredderRecycleJewelryGemstones(sources, result, player, item)
    ExecuteRecycleRange(sources, player, jewelryGemsMinValue, jewelryGemsMaxValue, 5)

	PlayRecyclerShreddingSound(sources, "RecyclerJewelry")
end


------------------------------------------------------------------------
--                         JEWELRY - DIAMOND
------------------------------------------------------------------------

function ShredderRecycleJewelryDiamond(sources, result, player, item)
    ExecuteRecycleRange(sources, player, jewelryDiamondMinValue, jewelryDiamondMaxValue, 10)

	PlayRecyclerShreddingSound(sources, "RecyclerJewelry")
end




------------------------------------------------------------------------
--
--                             TOOLS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                         TOOLS - SIMPLE
------------------------------------------------------------------------

function ShredderRecycleSimpleTool(sources, result, player, item)
    ExecuteRecycleRange(sources, player, simpleToolMinValue, simpleToolMaxValue, 20)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 10 then
		PlayRecyclerShreddingSound(sources, "RecyclerSmallMetal")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerLargeMetal")
	end
end


------------------------------------------------------------------------
--                         TOOLS - LARGE
------------------------------------------------------------------------

function ShredderRecycleComplexTool(sources, result, player, item)
    ExecuteRecycleRange(sources, player, complexToolMinValue, complexToolMaxValue, 25)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 25 then
		PlayRecyclerShreddingSound(sources, "RecyclerLargeMetal")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerSmallMetal")
	end
	
end


------------------------------------------------------------------------
--
--                           MELEE WEAPONS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                             ONE-HANDED
------------------------------------------------------------------------

function ShredderRecycleMeleeWeaponOneHand(sources, result, player, item)
    ExecuteRecycleRange(sources, player, meleeOneHandMinValue, meleeOneHandMaxValue, 20)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 33 then
		PlayRecyclerShreddingSound(sources, "RecyclerSmallMetal")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerLargeMetal")
	end
end


------------------------------------------------------------------------
--                             TWO-HANDED
------------------------------------------------------------------------

function ShredderRecycleMeleeWeaponTwoHand(sources, result, player, item)
    ExecuteRecycleRange(sources, player, meleeTwoHandMinValue, meleeTwoHandMaxValue, 25)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 66 then
		PlayRecyclerShreddingSound(sources, "RecyclerLargeMetal")
	else
		PlayRecyclerShreddingSound(sources, "RecyclerSmallMetal")
	end
end




------------------------------------------------------------------------
--
--                        CLOTHING - WEARABLE
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                            LEATHER ITEMS
------------------------------------------------------------------------

function ShredderRecycleLeather(sources, result, player, item)
    ExecuteRecycleRange(sources, player, leatherItemMinValue, leatherItemMaxValue, 5)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 25 then
		PlayRecyclerShreddingSound(sources, "RecyclerLeather")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerCloth")
	end
end


------------------------------------------------------------------------
--                        		CLOTH ITEMS
------------------------------------------------------------------------

function ShredderRecycleCloth(sources, result, player, item)
    ExecuteRecycleRange(sources, player, clothItemMinValue, clothItemMaxValue, 2)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 25 then
		PlayRecyclerShreddingSound(sources, "RecyclerCloth")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerLeather")
	end
end


------------------------------------------------------------------------
--                       		ARMOR
------------------------------------------------------------------------

function ShredderRecycleArmor(sources, result, player, item)
    ExecuteRecycleRange(sources, player, armorMinValue, armorMaxValue, 10)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 25 then
		PlayRecyclerShreddingSound(sources, "RecyclerArmor")		
	elseif soundOdds > 10 then
		PlayRecyclerShreddingSound(sources, "RecyclerLeather")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerCloth")
	end

end



------------------------------------------------------------------------
--                       		BAGS
------------------------------------------------------------------------

function ShredderRecycleBags(sources, result, player, item)
    ExecuteRecycleRange(sources, player, bagsMinValue, bagsMaxValue, 7)

	local soundOdds = ZombRand(1, 100) + 1
	if soundOdds > 25 then
		PlayRecyclerShreddingSound(sources, "RecyclerLeather")		
	elseif soundOdds > 10 then
		PlayRecyclerShreddingSound(sources, "RecyclerArmor")		
	else
		PlayRecyclerShreddingSound(sources, "RecyclerCloth")
	end
end


------------------------------------------------------------------------
--
--                          ELECTRONICS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                    ELECTRONICS - LOW QUALITY
------------------------------------------------------------------------

function ShredderRecycleLowElectronics(sources, result, player, item)
    ExecuteRecycleRange(sources, player, lowElectronicsMinValue, lowElectronicsMaxValue, 5)

	PlayRecyclerShreddingSound(sources, "RecyclerElectronics")
end


------------------------------------------------------------------------
--                     ELECTRONICS - HIGH QUALITY
------------------------------------------------------------------------

function ShredderRecycleHighElectronics(sources, result, player, item)
    ExecuteRecycleRange(sources, player, highElectronicsMinValue, highElectronicsMaxValue, 5)

	PlayRecyclerShreddingSound(sources, "RecyclerElectronics")
end




------------------------------------------------------------------------
--
--                          JUNK / MISC
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                            GLASS ITEMS
------------------------------------------------------------------------

function ShredderRecycleGlassItems(sources, result, player, item)
    ExecuteRecycleRange(sources, player, glassItemMinValue, glassItemMaxValue, 3)

	PlayRecyclerShreddingSound(sources, "RecyclerGlass")
end


------------------------------------------------------------------------
--                          PAPER PRODUCTS
------------------------------------------------------------------------

function ShredderRecyclePaperProduct(sources, result, player, item)
    ExecuteRecycleRange(sources, player, paperProductMinValue, paperProductMaxValue, 1)

	PlayRecyclerShreddingSound(sources, "RecyclerPaper")
end


------------------------------------------------------------------------
--                          EMPTY WALLETS
------------------------------------------------------------------------

function ShredderRecycleEmptyWallets(sources, result, player, item)
    ExecuteRecycleRange(sources, player, emptyWalletMinValue, emptyWalletMaxValue, 3)

	PlayRecyclerShreddingSound(sources, "RecyclerLeatherStrips")
end


------------------------------------------------------------------------
--                          FABRIC STRIPS
------------------------------------------------------------------------

function ShredderRecycleFabricStrips(sources, result, player, item)
    ExecuteRecycleRange(sources, player, fabricStripsMinValue, fabricStripsMaxValue, 3)

	PlayRecyclerShreddingSound(sources, "RecyclerLeatherStrips")
end

------------------------------------------------------------------------
--                            MISC JUNK
------------------------------------------------------------------------

function ShredderRecycleJunk(sources, result, player, item)
    ExecuteRecycleRange(sources, player, junkItemMinValue, junkItemMaxValue, 5)

	PlayRecyclerShreddingSound(sources, "RecyclerJunk")
end