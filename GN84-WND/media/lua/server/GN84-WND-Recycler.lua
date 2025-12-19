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
-- ##                                           GN84-WND                                                  ##
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################


------------------------------------------------------------------------
--                     SHREDDING AND RECYCLING     
------------------------------------------------------------------------

local watchesMinValue = SandboxVars.GN84WND.WatchesMinValue	or 3	
local watchesMaxValue = SandboxVars.GN84WND.WatchesMaxValue	or 10	
local jewelrySimpleMinValue = SandboxVars.GN84WND.JewelrySimpleMinValue or 1
local jewelrySimpleMaxValue = SandboxVars.GN84WND.JewelrySimpleMaxValue or 5
local jewelryPreciousMinValue = SandboxVars.GN84WND.JewelryPreciousMinValue or 10
local jewelryPreciousMaxValue = SandboxVars.GN84WND.JewelryPreciousMaxValue or 50
local jewelryGemsMinValue = SandboxVars.GN84WND.JewelryGemsMinValue or 25
local jewelryGemsMaxValue = SandboxVars.GN84WND.JewelryGemsMaxValue or 100
local jewelryDiamondMinValue = SandboxVars.GN84WND.JewelryDiamondMinValue or 100
local jewelryDiamondMaxValue = SandboxVars.GN84WND.JewelryDiamondMaxValue or 200

local simpleToolMinValue = SandboxVars.GN84WND.SimpleToolMinValue or 1
local simpleToolMaxValue = SandboxVars.GN84WND.simpleToolMaxValue or 10
local largeToolMinValue = SandboxVars.GN84WND.LargeToolMinValue or 10
local largeToolMaxValue = SandboxVars.GN84WND.LargeToolMaxValue or 40
local complexToolMinValue = SandboxVars.GN84WND.ComplexToolMinValue or 40
local complexToolMaxValue = SandboxVars.GN84WND.ComplexToolMaxValue or 100

local leatherMinValue = SandboxVars.GN84WND.LeatherMinValue or 20
local leatherMaxValue = SandboxVars.GN84WND.LeatherMaxValue or 50

local clothingMinValue = SandboxVars.GN84WND.ClothingMinValue or 5
local clothingMaxValue = SandboxVars.GN84WND.ClothingMaxValue or 25

local bulletVestMinValue = SandboxVars.GN84WND.BulletVestMinValue or 100
local bulletVestMaxValue = SandboxVars.GN84WND.BulletVestMaxValue or 250

local glassesMinValue = SandboxVars.GN84WND.GlassesMinValue or 5
local glassesMaxValue = SandboxVars.GN84WND.GlassesMaxValue or 20

local paperProductMinValue = SandboxVars.GN84WND.PaperProductMinValue or 5
local paperProductMaxValue = SandboxVars.GN84WND.PaperProductMaxValue or 10

local lowElectronicsMinValue = SandboxVars.GN84WND.LowElectronicsMinValue or 15
local lowElectronicsMaxValue = SandboxVars.GN84WND.LowElectronicsMaxValue or 35

local highElectronicsMinValue = SandboxVars.GN84WND.HighElectronicsMinValue or 50
local highElectronicsMaxValue = SandboxVars.GN84WND.HighElectronicsMaxValue or 100




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