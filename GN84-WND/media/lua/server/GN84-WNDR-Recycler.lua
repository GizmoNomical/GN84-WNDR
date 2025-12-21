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
-- ##                                           GN84-WNDR                                                  ##
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################


------------------------------------------------------------------------
--                     SHREDDING AND RECYCLING     
------------------------------------------------------------------------

local watchesMinValue = SandboxVars.GN84WNDR.WatchesMinValue	or 3	
local watchesMaxValue = SandboxVars.GN84WNDR.WatchesMaxValue	or 10	
local jewelrySimpleMinValue = SandboxVars.GN84WNDR.JewelrySimpleMinValue or 1
local jewelrySimpleMaxValue = SandboxVars.GN84WNDR.JewelrySimpleMaxValue or 5
local jewelryPreciousMinValue = SandboxVars.GN84WNDR.JewelryPreciousMinValue or 10
local jewelryPreciousMaxValue = SandboxVars.GN84WNDR.JewelryPreciousMaxValue or 50
local jewelryGemsMinValue = SandboxVars.GN84WNDR.JewelryGemsMinValue or 25
local jewelryGemsMaxValue = SandboxVars.GN84WNDR.JewelryGemsMaxValue or 100
local jewelryDiamondMinValue = SandboxVars.GN84WNDR.JewelryDiamondMinValue or 100
local jewelryDiamondMaxValue = SandboxVars.GN84WNDR.JewelryDiamondMaxValue or 200

local simpleToolMinValue = SandboxVars.GN84WNDR.SimpleToolMinValue or 1
local simpleToolMaxValue = SandboxVars.GN84WNDR.simpleToolMaxValue or 10
local largeToolMinValue = SandboxVars.GN84WNDR.LargeToolMinValue or 10
local largeToolMaxValue = SandboxVars.GN84WNDR.LargeToolMaxValue or 40
local complexToolMinValue = SandboxVars.GN84WNDR.ComplexToolMinValue or 40
local complexToolMaxValue = SandboxVars.GN84WNDR.ComplexToolMaxValue or 100

local leatherMinValue = SandboxVars.GN84WNDR.LeatherMinValue or 20
local leatherMaxValue = SandboxVars.GN84WNDR.LeatherMaxValue or 50

local clothingMinValue = SandboxVars.GN84WNDR.ClothingMinValue or 5
local clothingMaxValue = SandboxVars.GN84WNDR.ClothingMaxValue or 25

local bulletVestMinValue = SandboxVars.GN84WNDR.BulletVestMinValue or 100
local bulletVestMaxValue = SandboxVars.GN84WNDR.BulletVestMaxValue or 250

local glassesMinValue = SandboxVars.GN84WNDR.GlassesMinValue or 5
local glassesMaxValue = SandboxVars.GN84WNDR.GlassesMaxValue or 20

local paperProductMinValue = SandboxVars.GN84WNDR.PaperProductMinValue or 5
local paperProductMaxValue = SandboxVars.GN84WNDR.PaperProductMaxValue or 10

local lowElectronicsMinValue = SandboxVars.GN84WNDR.LowElectronicsMinValue or 15
local lowElectronicsMaxValue = SandboxVars.GN84WNDR.LowElectronicsMaxValue or 35

local highElectronicsMinValue = SandboxVars.GN84WNDR.HighElectronicsMinValue or 50
local highElectronicsMaxValue = SandboxVars.GN84WNDR.HighElectronicsMaxValue or 100




------------------------------------------------------------------------
--                   TODO: IMPLEMENT RECYCLER SOUNDS   
------------------------------------------------------------------------

local function PlayGrinderSound()
end

local function PlayCashoutSound()
end





------------------------------------------------------------------------
--                              JEWELRY
------------------------------------------------------------------------

function ShredderRecycleWatches(sources, result, player, item)
	local watchesValueRoll = ZombRand(watchesMinValue, watchesMaxValue)+1	
	local t = 0

	--print("Watch Value: ", watchesValueRoll)

	while t ~= watchesValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelrySimple(sources, result, player, item)
	local jewelryValueRoll = ZombRand(jewelrySimpleMinValue, jewelrySimpleMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelryPrecious(sources, result, player, item)
	local jewelryValueRoll = ZombRand(jewelryPreciousMinValue, jewelryPreciousMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelryGemstones(sources, result, player, item)
	local jewelryValueRoll = ZombRand(jewelryGemsMinValue, jewelryGemsMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelryDiamond(sources, result, player, item)
	local jewelryValueRoll = ZombRand(jewelryDiamondMinValue, jewelryDiamondMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end




------------------------------------------------------------------------
--                            TOOLS
------------------------------------------------------------------------

function ShredderRecycleSimpleTool(sources, result, player, item)
	local toolValueRoll = ZombRand(simpleToolMinValue, simpleToolMaxValue)+1	
	local t = 0

	--print("Tool Value: ", toolValueRoll)

	while t ~= toolValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleLargeTool(sources, result, player, item)
	local toolValueRoll = ZombRand(largeToolMinValue, largeToolMaxValue)+1	
	local t = 0

	--print("Tool Value: ", toolValueRoll)

	while t ~= toolValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleComplexTool(sources, result, player, item)
	local toolValueRoll = ZombRand(complexToolMinValue, complexToolMaxValue)+1	
	local t = 0

	--print("Tool Value: ", toolValueRoll)

	while t ~= toolValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end




------------------------------------------------------------------------
--                     LEATHER / CLOTHING ITEMS
------------------------------------------------------------------------

function ShredderRecycleLeather(sources, result, player, item)
	local leatherValueRoll = ZombRand(leatherMinValue, leatherMaxValue)+1	
	local t = 0

	--print("Leather Value: ", leatherValueRoll)

	while t ~= leatherValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleClothing(sources, result, player, item)
	local clothingValueRoll = ZombRand(clothingMinValue, clothingMaxValue)+1	
	local t = 0

	--print("Clothing Value: ", clothingValueRoll)

	while t ~= clothingValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleBulletVest(sources, result, player, item)
	local vestValueRoll = ZombRand(bulletVestMinValue, bulletVestMaxValue)+1	
	local t = 0

	--print("Vest Value: ", vestValueRoll)

	while t ~= vestValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleGlasses(sources, result, player, item)
	local glassesValueRoll = ZombRand(glassesMinValue, glassesMaxValue)+1	
	local t = 0

	--print("Glasses Value: ", glassesValueRoll)

	while t ~= glassesValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end



------------------------------------------------------------------------
--                          PAPER PRODUCTS
------------------------------------------------------------------------

function ShredderRecyclePaperProduct(sources, result, player, item)
	local paperValueRoll = ZombRand(paperProductMinValue, paperProductMaxValue)+1	
	local t = 0

	--print("Paper Value: ", paperValueRoll)

	while t ~= paperValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end



------------------------------------------------------------------------
--                          ELECTRONICS
------------------------------------------------------------------------

function ShredderRecycleLowElectronics(sources, result, player, item)
	local electronicsValueRoll = ZombRand(lowElectronicsMinValue, lowElectronicsMaxValue)+1	
	local t = 0

	--print("Electronic Value: ", electronicsValueRoll)

	while t ~= electronicsValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleHighElectronics(sources, result, player, item)
	local electronicsValueRoll = ZombRand(highElectronicsMinValue, highElectronicsMaxValue)+1	
	local t = 0

	--print("Electronic Value: ", electronicsValueRoll)

	while t ~= electronicsValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end