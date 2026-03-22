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

local DEBUG_RECYCLER = true

------------------------------------------------------------------------
--                       SANDBOX SETTINGS
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
	if DEBUG_RECYCLER then
		print("Recycler Powered On")
	end
	local modData = self.recycler:getItem():getModData()

	if not modData then
		return
	end

	if modData.CurrentUser ~= self.character:getUsername() then
		if DEBUG_RECYCLER then
			print("Recycler Lock Lost, Aborting Action")
		end
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
	if DEBUG_RECYCLER then
		print("Recycler Powered Off")
	end

	local modData = self.recycler:getItem():getModData()

	if not modData then
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
	if DEBUG_RECYCLER then
		print("Recycler Reset")
	end

	local modData = self.recycler:getItem():getModData()

	if not modData then
		return
	end

	if modData.CurrentUser ~= nil and (modData.CashBalance or 0) > 0 then
		if DEBUG_RECYCLER then
			print("Depositing Previous Balance of " .. modData.CashBalance .. " into " .. modData.CurrentUser .. "'s Smokey Bank")
		end
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
	if DEBUG_RECYCLER then
		print("Recycler Cashed Out")
	end

	local modData = self.recycler:getItem():getModData()

	if not modData then
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
--                        PLAY CASHOUT SOUND
------------------------------------------------------------------------

local function PlayCashoutSound(player)
	print("Playing Cashout Sound")
end





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

	if DEBUG_RECYCLER then
		print("AddActiveRecycler:", key)
	end
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

	if DEBUG_RECYCLER then
		print("RemoveActiveRecycler:", key)
	end
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

AttractZombiesToRecycler = function(player)
	local odds = ZombRand(0,100) + 1
	-- print("Odds: ", odds)
	if odds > 99 then
		-- print("Attracting Zombies to Recycler")
		addSound(player, player:getX(), player:getY(), player:getZ(), 100, 100)
	end
end


------------------------------------------------------------------------
--                      VALID RECYCLER ITEMS
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
--                    CREATE CUSTOM STACK OF CASH
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
--                      PLAYER PROXIMITY CHECK
------------------------------------------------------------------------

local INTERACT_DIST = 2.25
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

local function ActivateRecycler(player, recycler)
	if not recycler then return end

	local modData = recycler:getItem():getModData()
	if not modData then return end

	modData.RecyclerActivated = true
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()
	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = nil, RecyclerLastUsed = modData.RecyclerLastUsed })
end


------------------------------------------------------------------------
--                     DEACTIVATE RECYCLER (ADMIN)
------------------------------------------------------------------------

local function DeActivateRecycler(player, recycler)
	if not recycler then return end

	local modData = recycler:getItem():getModData()
	if not modData then return end

	modData.RecyclerActivated = false
	modData.RecyclerEnabled = false
	modData.CashBalance = 0
	modData.CurrentUser = nil
	modData.RecyclerLastUsed = getTimeInMillis()

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled, CashBalance = modData.CashBalance, CurrentUser = nil, RecyclerLastUsed = modData.RecyclerLastUsed })
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
	local player = getPlayerByOnlineID(playerNum)
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
				local tooFar = context:addOptionOnTop("..Too Far Away..", nil, nil)
				tooFar.notAvailable = true

				local toolTip = ISWorldObjectContextMenu:addToolTip()
				toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Move Closer<LINE><LINE><RGB:1,1,1,1>You must be within 2 tiles to use the Recycler.")
				tooFar.toolTip = toolTip
				return
			end

			-- Self Heal Emitter State
			if modData.RecyclerEnabled ~= nil then
				RecyclerAudio.SyncEmitterToModData(object)
			end

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

						local option = context:addOptionOnTop("Reset Recycler", nil, ResetRecycler, object, player)

						local toolTip = ISWorldObjectContextMenu.addToolTip()
						toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Resets<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.2,1,0.2>Cashes Out <SPACE><SPACE><RGB:1,1,1,1> any Remaining Balance into Previous User's Smokey Bank")
						option.toolTip = toolTip

						return
					else

						local unauthorized = context:addOptionOnTop("Unauthorized User", nil, nil)
						unauthorized.notAvailable = true

						local toolTip = ISWorldObjectContextMenu.addToolTip()

						-- Display Session Timeout
						if timeoutInMinutes < 1 then
							toolTip.description = getText("<SIZE:medium>Session Timeout:<SPACE><SPACE>" .. math.ceil(timeoutInSeconds) .. " Seconds")
						else
							toolTip.description = getText("<SIZE:medium>Session Timeout:<SPACE><SPACE>" .. math.floor(timeoutInMinutes) .. ":" .. formattedSeconds)
						end

						unauthorized.toolTip = toolTip

						return
					end
				elseif (modData.CurrentUser == username) and (currentTime > timeoutEnd) then

					local status = context:addOptionOnTop("Status:  Session Timed Out", nil, nil)
					status.notAvailable = true

					local statustoolTip = ISWorldObjectContextMenu.addToolTip()
					statustoolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Session has Timed Out.<LINE><LINE><RGB:0.0,0.886,1.0,1>Please Reset Recycler to Continue")
					status.toolTip = statustoolTip


					local option = context:addOptionOnTop("Reset Recycler and Cash Out", nil, ResetRecycler, object, player)

					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Resets<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.2,1,0.2>Cashes Out <SPACE><SPACE><RGB:1,1,1,1> any Remaining Balance into User's Smokey Bank")
					option.toolTip = toolTip

					return
				end

				if modData.RecyclerEnabled then

					if modData.CashBalance then
						if (modData.CashBalance or 0) > 0 then

							local option = context:addOptionOnTop("Turn Off Recycler", nil, nil)
							option.notAvailable = true

							local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
							toggletoolTip.description = getText("<SIZE:medium><RGB:1.0,0.6,0.11,1>Please Cash Out before Powering Down Recycler")
							option.toolTip = toggletoolTip

							local cashBalance = modData.CashBalance or 0
							cashBalance = Utils.CurrencyFormatter(cashBalance)

							local balance = context:addOptionOnTop("Balance: $" .. cashBalance, nil, CashOutBalance, object, player)

							local toolTip = ISWorldObjectContextMenu.addToolTip()
							toolTip.description = getText("<SIZE:medium>Displays Current Balance.<LINE><LINE><RGB:0.2,1,0.2>Click to Cash Out!")
							balance.toolTip = toolTip
						else

							local option = context:addOptionOnTop("Turn Off Recycler", nil, PowerOffRecycler, object, player)

							local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
							toggletoolTip.description = getText("<SIZE:medium><RGB:1,0,0,1>Turns Off<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:0.2,1,0.2>Cashes Out <SPACE><SPACE><RGB:1,1,1,1> Remaining Balance")
							option.toolTip = toggletoolTip

							local balance = context:addOptionOnTop("Balance: $0", nil, nil)
							balance.notAvailable = true

							local toolTip = ISWorldObjectContextMenu.addToolTip()
							toolTip.description = getText("<SIZE:medium>Displays Current Balance.<LINE><LINE><RGB:0.0,0.886,1.0,1>Recycle Items to Earn Cash!")
							balance.toolTip = toolTip
						end
					end					

					local status = context:addOptionOnTop("Status: " .. statusText, nil, nil)
					status.notAvailable = false

					local toolTip = ISWorldObjectContextMenu.addToolTip()

					-- Display Session Timer
					if timeoutInMinutes < 1 then
						toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Recycler is Running...<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!<LINE><LINE><RGB:0.0,0.886,1.0,1>Secured User:  " .. modData.CurrentUser .. "<LINE><RGB:1,1,1,1>Session Timeout:<SPACE><SPACE>" .. math.ceil(timeoutInSeconds) .. " Seconds")
					else
						toolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Recycler is Running...<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!<LINE><LINE><RGB:0.0,0.886,1.0,1>Secured User:  " .. modData.CurrentUser .. "<LINE><RGB:1,1,1,1>Session Timeout:<SPACE><SPACE>" .. math.floor(timeoutInMinutes) .. ":" .. formattedSeconds)
					end

					status.toolTip = toolTip
					

				elseif not modData.RecyclerEnabled then

					local option = context:addOptionOnTop("Turn On Recycler", nil, PowerOnRecycler, object, player)

					local toggletoolTip = ISWorldObjectContextMenu.addToolTip()
					toggletoolTip.description = getText("<SIZE:medium><RGB:0.2,1,0.2>Turns On<SPACE><SPACE><RGB:1,1,1,1> the Recycler<LINE><LINE><RGB:1.0,0.6,0.11,1>[SECURED TO OPERATOR]<LINE><RGB:0.0,0.886,1.0,1>[AUTO-UNLOCK: 5 MIN]")
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

	if not modData.CurrentUser then
		modData.CurrentUser = args.username

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


	if command == "ReceiveRecyclerModDataFromClient" then

		local recycler = getWorldItemByID(args.X, args.Y, args.Z, args.RecyclerID)
		if not recycler then return end

		local modData = recycler:getModData()
		if not modData then return end

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
--                              RECIPES
--
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--
--                           JEWELRY ITEMS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                              WATCHES
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


------------------------------------------------------------------------
--                         JEWELRY - SIMPLE
------------------------------------------------------------------------

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


------------------------------------------------------------------------
--                         JEWELRY - PRECIOUS
------------------------------------------------------------------------

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


------------------------------------------------------------------------
--                         JEWELRY - GEMSTONES
------------------------------------------------------------------------

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


------------------------------------------------------------------------
--                         JEWERLY - DIAMOND
------------------------------------------------------------------------

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
--
--                             TOOLS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                         TOOLS - SIMPLE
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


------------------------------------------------------------------------
--                         TOOLS - LARGE
------------------------------------------------------------------------

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


------------------------------------------------------------------------
--                         TOOLS - COMPLEX
------------------------------------------------------------------------

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
--
--                        CLOTHING - WEARABLE
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                            LEATHER
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


------------------------------------------------------------------------
--                        STANDARD CLOTHING
------------------------------------------------------------------------

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


------------------------------------------------------------------------
--                       BULLETPROOF VESTS
------------------------------------------------------------------------

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


------------------------------------------------------------------------
--                            GLASSES
------------------------------------------------------------------------

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
--
--                          PAPER PRODUCTS
--
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
--
--                          ELECTRONICS
--
------------------------------------------------------------------------
------------------------------------------------------------------------
--                    ELECTRONICS - LOW QUALITY
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


------------------------------------------------------------------------
--                     ELECTRONICS - HIGH QUALITY
------------------------------------------------------------------------

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