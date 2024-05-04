require "recipecode"

local pointsPerZombieKill = SandboxVars.GN84ECO.PointsPerZombieKill  		-- 6   - Smokey Points per Zombie Kill
local eFundOdds = SandboxVars.GN84ECO.EFundOdds	          				-- 90  - Must roll >= to this number to get eFunds
local walletCashMultiplier = SandboxVars.GN84ECO.WalletCashMultiplier		-- 1.0 -   Adjust total Wallet Cash
local eFundCashMultiplier = SandboxVars.GN84ECO.EFundCashMultiplier		-- 1.0 - Adjust total eFund Cash
local wealthyCash = SandboxVars.GN84ECO.WealthyCash						-- 20 - Max cash found in Wealthy Zombie Wallet
local averageCash = SandboxVars.GN84ECO.AverageCash						-- 10 - Max cash found in Average Zombie Wallet
local poorCash = SandboxVars.GN84ECO.PoorCash								-- 5  - Max cash found in Poor Zombie Wallet


-- Adding Smokey Points

function GivePlayerSmokeyPoints100()
	sendClientCommand("GN84-ECO-TEST", "add", {getPlayer():getUsername(), 100})
end

function GivePlayerSmokeyPoints1000()
	sendClientCommand("GN84-ECO-TEST", "add", {getPlayer():getUsername(), 1000})
end

function GivePlayerSmokeyPoints10000()
	sendClientCommand("GN84-ECO-TEST", "add", {getPlayer():getUsername(), 10000})
end

-- Add Smokey Points on Zombie Kill
-- ------------------------------- --

function SmokeyPointsOnZombieKill(zombie)	
	local lastAttacker = zombie:getAttackedBy()
	local isoPlayer = getPlayer()

	if isoPlayer == lastAttacker then
		sendClientCommand("GN84-ECO-TEST", "add", {getPlayer():getUsername(), pointsPerZombieKill})		
	end	

end

Events.OnZombieDead.Add(SmokeyPointsOnZombieKill)


	

-- Searching Wallets for Money
--  VARIABLES

	local wealth;  		-- Zombie Wealth - Upper Class, Middle Class, Lower Class
	local eFunds;  		-- Zombie EFunds Odds
	local walletCash; 	-- Total Money found from Wallets
	local eFundCash;	-- Total Money found from hidden Emergency Funds
	local combinedCash; -- Total of Wallet / EFunds
	local eFundBill;	-- Efund Roll


	
function searchEFunds()

	if (eFunds <= eFundOdds)  -- Check if Zombie had EFunds
		then
			eFundBill = ZombRand(100)+1;
			
			if (eFundBill >= 99)
				then
					eFundCash = 200
					return
			end				
			if (eFundBill >= 93 and eFundBill <97)
				then
					eFundCash = 100
					return
			end
			if (eFundBill <= 22)
				then
					eFundCash = 50
					return
			end
			if (eFundBill >28 and eFundBill <83)
				then
					eFundCash = 20
					return
			end		

			-- DEBUGGING
			-- print ("***Zombie Had Emergency Funds -", eFundCash, "***")
		end
end

function searchWalletCash()
					
	if (wealth >=94) -- Wealthy
		then
			walletCash = ZombRand(wealthyCash)+1
			return
		end

	if (wealth < 50) -- Poor
		then
			walletCash = ZombRand(poorCash)+1
			return
		end

	if (wealth >=52 and wealth <=86) -- Average
		then
			walletCash = ZombRand(averageCash)+1
			return
		end

	-- DEBUGGING
	-- print ("Wallet Cash: ", walletCash)

end

function CollectMoneyFromWallet(items, result, player)
	
	wealth = ZombRand(100)+1; -- Zombie Wealth Roll
	eFunds = ZombRand(100)+1; -- Zombie EFunds Roll
	walletCash = 0;
	eFundCash = 0;
	combinedCash = 0;
	eFundBill = 0;

	searchEFunds()
	searchWalletCash()
	
	local t = 0;
	eFundCash = eFundCash * eFundCashMultiplier       -- Adjusted by Multiplier
	walletCash = walletCash * walletCashMultiplier    -- Adjusted by Multiplier

	combinedCash = eFundCash + walletCash             -- Total Cash from Wallet

	-- DEBUGGING
	-- print ("Total: ", combinedCash)

	-- print ("-------------------------")
	-- print ("-------------------------")
	
	while(t ~= combinedCash) do
		player:getInventory():AddItem("Money");
		t = t+1
	end
end


-- Cutting up Wallets for Leather Strips
--  VARIABLES

local leatherRoll;
local extraLeatherOdds = 90
local maxExtraLeather = 3
local extraLeatherStrips;

function CutLeatherWallet(items, result, player)
	leatherRoll = ZombRand(100)+1;  -- Extra Leather Roll
	extraLeatherStrips = 0;	
	
	if (leatherRoll >= extraLeatherOdds)
		then
			-- Roll for Amount of Extra Strips
			extraLeatherStrips = ZombRand(maxExtraLeather);			
		end
		
	local t = 0;

	while(t ~= extraLeatherStrips)
		do
			player:getInventory():AddItem("LeatherStrips");
			t = t+1
		end
end

-- Shredding and  Recycling
-- VARIABLES

local watchesMinValue = SandboxVars.GN84ECO.WatchesMinValue		
local watchesMaxValue = SandboxVars.GN84ECO.WatchesMaxValue		
local jewelrySimpleMinValue = SandboxVars.GN84ECO.JewelrySimpleMinValue
local jewelrySimpleMaxValue= SandboxVars.GN84ECO.JewelrySimpleMaxValue
local jewelryPreciousMinValue = SandboxVars.GN84ECO.JewelryPreciousMinValue
local jewelryPreciousMaxValue= SandboxVars.GN84ECO.JewelryPreciousMaxValue
local jewelryGemsMinValue = SandboxVars.GN84ECO.JewelryGemsMinValue
local jewelryGemsMaxValue= SandboxVars.GN84ECO.JewelryGemsMaxValue
local jewelryDiamondMinValue = SandboxVars.GN84ECO.JewelryDiamondMinValue
local jewelryDiamondMaxValue= SandboxVars.GN84ECO.JewelryDiamondMaxValue


function PlayGrinderSound()
end

function PlayCashoutSound()
end


function ShredderRecycleWatches(items, result, player)
	local watchesValueRoll = ZombRand(watchesMinValue, watchesMaxValue)+1
	
	local t = 0;

	print("Watch Value: ", watchesValueRoll)

	while(t ~= watchesValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleJewelrySimple(items, result, player)
	local jewelryValueRoll = ZombRand(jewelrySimpleMinValue, jewelrySimpleMaxValue)+1
	
	local t = 0;

	print("Jewelry Value: ", jewelryValueRoll)

	while(t ~= jewelryValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleJewelryPrecious(items, result, player)
	local jewelryValueRoll = ZombRand(jewelryPreciousMinValue, jewelryPreciousMaxValue)+1
	
	local t = 0;

	print("Jewelry Value: ", jewelryValueRoll)

	while(t ~= jewelryValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleJewelryGemstones(items, result, player)
	local jewelryValueRoll = ZombRand(jewelryGemsMinValue, jewelryGemsMaxValue)+1
	
	local t = 0;

	print("Jewelry Value: ", jewelryValueRoll)

	while(t ~= jewelryValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleJewelryDiamond(items, result, player)
	local jewelryValueRoll = ZombRand(jewelryDiamondMinValue, jewelryDiamondMaxValue)+1
	
	local t = 0;

	print("Jewelry Value: ", jewelryValueRoll)

	while(t ~= jewelryValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end






-- Safehouse Claiming

buildingSqFootage = nil;

function debuggingKey(_keyPressed)
	local key = _keyPressed
	if getAccessLevel() == "admin" then
		-- print (tostring(key))
		if key == 71
			then		
				--ClaimResidentialSafehouse()
				CheckSafehouseSize()
			end	
	end
end

function ClaimResidentialSafehouse(worldobjects, square, player)
	
	CheckSafehouseSize()
	if not buildingSqFootage
	then
		print ("Error in Returning Safehouse Size")
		return
	elseif buildingSqFootage >= 2000 and buildingSqFootage < 10000
			then
				print ("You must purchase a Residential Permit to Claim this Building!")
				return

	elseif buildingSqFootage >= 10000
			then
				print ("You must purchase a Faction Bunker Permit to Claim this Building!")
				return

	elseif buildingSqFootage == 0
			then
				print ("Invalid Safehouse")
				return

	else
								-- Claim as Normal
				print ("You can claim this building")
				playerSafehouseClaim()
				-- Remove Permit from Inventory
				-- player:getInventory():RemoveOneOf("ResidentialClaimPermit")
	end
end

-- Check Safehouse Sq Footage and Amount of Floors
function CheckSafehouseSize(worldobjects, square, player)	
		
		buildingSqFootage = nil
		if not getPlayer():getSquare():getBuilding() -- Error Handling
			then
				print ("Error: Not In Building")
				return
			end

		-- Get building definition

		local buildingDef = getPlayer():getSquare():getBuilding():getDef();
		
		if buildingDef == nil -- Error Handling
			then 
				print ("Error: No Building Def")
				return
		elseif buildingDef
			then
				
				-- Check if player is still in a building
				local buildingCenterX = ((buildingDef:getX() + buildingDef:getX2()) / 2) 
				local buildingCenterY = ((buildingDef:getY() + buildingDef:getY2()) / 2)

				local x, y, z = buildingCenterX, buildingCenterY, getPlayer():getZ();
				-- local x, y, z = getPlayer():getX(), getPlayer():getY(), getPlayer():getZ();
				local currentTile = getCell():getGridSquare(x, y, z)
				local buildingStories = z

				if currentTile
				then					
					-- Check how many Floors Building Has
					
					while currentTile:isSolidFloor()
					do				
						--print ("Is Solid Floor : ", z)
						
						z = z + 1
						currentTile = getCell():getGridSquare(x, y, z)
						
						if not currentTile -- Error Handling
						then
							--print ("Warning: Finished Iteration over Floors")
							break
						end

						buildingStories = z
						--print("Building Stories: ",buildingStories)
					end	
					--print ("Warning: Exited Loop")
				end

				
				local buildingHeight = buildingDef:getH();
				local buildingWidth = buildingDef:getW();		
				
				

				print ("#############################")
				print ("Coords: X: ", buildingDef:getX(), " X2: ", buildingDef:getX2(), " Y: ", buildingDef:getY(), " Y2: ", buildingDef:getY2())
				print ("Safehouse Center: ", buildingCenterX, " x ", buildingCenterY)
				print ("Running Safehouse Size Check...")
				print ("Safehouse Size is: ", buildingWidth, " Wide -- ", buildingHeight, " Tall")	
				print ("#############################")
				-- Check Safehouse Sq Footage and Stories

				
				if buildingStories == nil
				then
					return
				end

				
					if (buildingStories == 0)
					then
						print ("Building is ", (buildingStories + 1)," Story Tall")
						buildingSqFootage = buildingHeight * buildingWidth * 9
						print ("Safehouse Sq Footage: ", (buildingSqFootage))
						return
					elseif (buildingStories >= 1)
						then
							print ("Building is ", (buildingStories)," Story Tall")
							buildingSqFootage = (buildingHeight * buildingWidth * 9 * buildingStories)
							print ("Safehouse Sq Footage: ", (buildingSqFootage))	
							return
					else
						return
					end			
			end
end


-- Claiming Functions

function playerSafehouseClaim(worldobjects, square, player)
	local builddef = getPlayer():getSquare():getBuilding():getDef()
    SafeHouse.addSafeHouse(builddef:getX() - 2, builddef:getY() - 2, builddef:getW() + 2*2, builddef:getH() + 2*2, getPlayer():getUsername(), false)
end


local function Context_safezone(player, context, worldobjects, test)	
	for _, opt in pairs(context.options) do
        if opt.name == getText("ContextMenu_SafehouseClaim") then
					opt.onSelect = ClaimResidentialSafehouse
				end			
            break
        end
    end
		

Events.OnFillWorldObjectContextMenu.Add(Context_safezone)
Events.OnKeyPressed.Add(debuggingKey);