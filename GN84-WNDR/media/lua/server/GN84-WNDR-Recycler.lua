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
local simpleToolMaxValue = SandboxVars.GN84WNDR.simpleToolMaxValue 				or 10
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


------------------------------------------------------------------------
--                   TODO: IMPLEMENT RECYCLER SOUNDS
------------------------------------------------------------------------

local function PlayGrinderSound()
	print("Playing Grinder Motor Sound")
end

local function PlayCashoutSound(player)
	print("Playing Cashout Sound")
end

------------------------------------------------------------------------
--                         ATTRACT ZOMBIES 
------------------------------------------------------------------------

local function AttractZombiesToRecycler(player)
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
end



------------------------------------------------------------------------
--                        TURN ON RECYCLER
------------------------------------------------------------------------

local function ActivateRecycler(player, recycler)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  114  |  FUNCTION:  ActivateRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end

	local modData = recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  120  |  FUNCTION:  ActivateRecycler  |  ERROR:  modData is Invalid or Missing")
		return
	end


	modData.RecyclerActivated = true
	modData.RecyclerEnabled = false
	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled })
end


local function DeActivateRecycler(player, recycler)
	if not recycler then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  114  |  FUNCTION:  ActivateRecycler  |  ERROR:  recycler is Invalid or Missing")
		return
	end

	local modData = recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  120  |  FUNCTION:  ActivateRecycler  |  ERROR:  modData is Invalid or Missing")
		return
	end

	modData.RecyclerActivated = false
	modData.RecyclerEnabled = false
	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled })
end


local function ToggleRecycler(player, recycler)
	local modData = recycler:getItem():getModData()

	if not modData then
		print("FILE:  GN84-WNDR-Recycler.lua  |  LINE:  115  |  FUNCTION:  ToggleRecycler  |  WARN:  modData is Invalid or Missing")
		return
	end

	modData.RecyclerEnabled = not modData.RecyclerEnabled

	if modData.RecyclerEnabled then
		AttractZombiesToRecycler(player)
		PlayGrinderSound()
	end

	sendClientCommand("GN84-WNDR", "ReceiveRecyclerModDataFromClient", { RecyclerID = recycler:getItem():getID(), X = recycler:getX(), Y = recycler:getY(), Z = recycler:getZ(), RecyclerActivated = modData.RecyclerActivated, RecyclerEnabled = modData.RecyclerEnabled })
end


local function RecyclerContext(player, context, worldObjects, test)

	local objects = worldObjects[1] and worldObjects[1]:getSquare():getObjects()
    for i = 0, objects:size()-1 do

	---@type IsoWorldInventoryObject
    local object = objects:get(i)
        if instanceof(object, "IsoWorldInventoryObject") and object:getItem():getType() == "SmokeyShredderRecycler" then

			local modData = object:getItem():getModData()

			-- Admin Activate/Deactivate
			if isAltKeyDown() then
				if getAccessLevel() == "admin" then
					if modData.RecyclerActivated == nil then
						local activate = context:addOptionOnTop("(ADMIN) Activate Recycler", nil, ActivateRecycler, object)
					elseif not modData.RecyclerActivated then
						local activate = context:addOptionOnTop("(ADMIN) Activate Recycler", nil, ActivateRecycler, object)
					elseif modData.RecyclerActivated then
						local deactivate = context:addOptionOnTop("(ADMIN) De-Activate Recycler", nil, DeActivateRecycler, object)
					end
				end
			end


			-- Power Status
			local statusText = ""
			if modData.RecyclerEnabled then
				statusText = " On"
			elseif not modData.RecyclerEnabled then
				statusText = " Off"
			end

			if modData.RecyclerActivated then
				if modData.RecyclerEnabled then
					local option = context:addOptionOnTop("Turn Off Recycler", nil, ToggleRecycler, object)

					local status = context:addOptionOnTop("Power: " .. statusText, nil, nil)
					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<RGB:0.2,1,0.2>Recycler is Running...<LINE><LINE><RGB:1.0,0.6,0.11,1>May Attract Zombies!")
					status.toolTip = toolTip
					status.notAvailable = false
				elseif not modData.RecyclerEnabled then
					local option = context:addOptionOnTop("Turn On Recycler", nil, ToggleRecycler, object)

					local status = context:addOptionOnTop("Power: " .. statusText, nil, nil)
					local toolTip = ISWorldObjectContextMenu.addToolTip()
					toolTip.description = getText("<RGB:1,0,0,1>Recycler is Powered Down.<LINE><LINE><RGB:0.0,0.886,1.0,1>Turn On to Recycle Items.")
					status.toolTip = toolTip
					status.notAvailable = true
				end
			else
				local activated = context:addOptionOnTop("Deactivated", nil, nil)
				activated.notAvailable = true
				local toolTip = ISWorldObjectContextMenu.addToolTip()
				toolTip.description = getText("Recycler Disabled:  Must be Activated by an Admin")
				activated.toolTip = toolTip
			end
        end
    end
end



Events.OnFillWorldObjectContextMenu.Add(RecyclerContext)


------------------------------------------------------------------------
--                        MOD DATA SYNCING
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

-- Sync ModData on Server
local function ReceiveRecyclerModDataFromClient(module, command, player, args)
	if module ~= "GN84-WNDR" then return end

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

		modData.RecyclerActivated = args.RecyclerActivated
		modData.RecyclerEnabled = args.RecyclerEnabled

		-- Send Mod Data back to Local Clients
		sendServerCommand("GN84-WNDR", "ReceiveRecyclerModDataFromServer", { RecyclerID = args.RecyclerID, X = args.X, Y = args.Y, Z = args.Z, RecyclerActivated = args.RecyclerActivated, RecyclerEnabled = args.RecyclerEnabled })
	end
end

Events.OnClientCommand.Add(ReceiveRecyclerModDataFromClient)


-- Sync ModData back to Nearby Clients
local function ReceiveRecyclerModDataFromServer(module, command, args)
	if module ~= "GN84-WNDR" then return end

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

		modData.RecyclerActivated = args.RecyclerActivated
		modData.RecyclerEnabled = args.RecyclerEnabled
	end
end

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

	return false
end


------------------------------------------------------------------------
--                    CHECK IF RECYCLER WAS CLICKED ITEM
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
--                   CHECK IF FAVORITED AND RECYCLER ENABLED
------------------------------------------------------------------------

function GN84_IsRecycleable(item, result)
	if item:getType() == "SmokeyShredderRecycler" then
		if not IsRecyclerEnabled(item) then
			return false
		end
	end

    return not item:isFavorite() and not item:isEquipped()
end



------------------------------------------------------------------------
--                  CREATE CUSTOM STACK OF CASH
------------------------------------------------------------------------


local function CreateCash(amount, recycler)
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
--                        GET RECYCLER OBJECT
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

	local finalValue = math.max(1, math.floor(watchesValueRoll * multiplier))
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


function ShredderRecycleJewelrySimple(sources, result, player, item)
	if not sources then return end

	local recycler = getRecyclerObject(sources) or nil

	local jewelryValueRoll = ZombRand(jewelrySimpleMinValue, jewelrySimpleMaxValue) + 1

	local multiplier = GetConditionScalar(sources)
	print("Item Condition: ", multiplier)
	print("Min Value: ", jewelrySimpleMinValue)
	print("Max Value: ", jewelrySimpleMaxValue)
	print("Value Roll: ", jewelryValueRoll)

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(jewelryValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(toolValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(toolValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(toolValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(leatherValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(clothingValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(vestValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(glassesValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(paperValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(electronicsValueRoll * multiplier))
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

	local finalValue = math.max(1, math.floor(electronicsValueRoll * multiplier))
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