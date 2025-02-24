require "recipecode"
require "ISUI/ISContextMenu"


--------------------------
-- Sandbox Variables
--------------------------

local pointsPerZombieKill = SandboxVars.GN84ECO.PointsPerZombieKill or 18 		-- 6   - Smokey Points per Zombie Kill
local eFundOdds = SandboxVars.GN84ECO.EFundOdds	or 10          				-- 10  - Must roll <= to this number to get eFunds
local walletCashMultiplier = SandboxVars.GN84ECO.WalletCashMultiplier or 1.0		-- 1.0 -   Adjust total Wallet Cash
local eFundCashMultiplier = SandboxVars.GN84ECO.EFundCashMultiplier	or 1.0	-- 1.0 - Adjust total eFund Cash
local wealthyCash = SandboxVars.GN84ECO.WealthyCash	or 50					-- 20 - Max cash found in Wealthy Zombie Wallet
local averageCash = SandboxVars.GN84ECO.AverageCash	or 15					-- 10 - Max cash found in Average Zombie Wallet
local poorCash = SandboxVars.GN84ECO.PoorCash or 5								-- 5  - Max cash found in Poor Zombie Wallet
local playerLuckBonus = SandboxVars.GN84ECO.PlayerLuckBonus or 1.2
local playerUnluckyPenalty = SandboxVars.GN84ECO.PlayerUnluckyPenalty or 0.95
local lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds or 3.25
local rareTicketCashValue = SandboxVars.GN84ECO.RareTicketCashValue or 1          -- Value to trade in Rare Blue Ticket for cash Stacks (in Thousands)
local VIPTokenCashValue = SandboxVars.GN84ECO.VIPTokenCashValue or 25000          -- Value to trade in Rare Blue Ticket for cash Stacks (in Thousands)
local EventTokenCashValue = SandboxVars.GN84ECO.EventTokenCashValue or 10000          -- Value to trade in Rare Blue Ticket for cash Stacks (in Thousands)
--------------------------
-- New Player Add Items
--------------------------

--[[ 
function OnCreatePlayer(playerIndex, player)
    if not player:getModData().wallet then
        local wallet = player:getInventory():AddItem("VM.Leather_Wallet")
        wallet:getInventory():AddItem("VM.10Bill")
        wallet:getInventory():AddItem("VM.5Bill")
        wallet:getInventory():AddItem("VM.5Bill")
        player:getModData().wallet = true
    end
end

Events.OnCreatePlayer.Add(OnCreatePlayer) ]]


--------------------------
-- Adding Smokey Points
--------------------------

function GivePlayerSmokeyPoints100()
	sendClientCommand("GN84-ECO", "redeemCash", {getPlayer():getUsername(), 100})
end

function GivePlayerSmokeyPoints1000()
	sendClientCommand("GN84-ECO", "redeemCash", {getPlayer():getUsername(), 1000})
end

function GivePlayerSmokeyPoints10000()
	sendClientCommand("GN84-ECO", "redeemCash", {getPlayer():getUsername(), 10000})
end

function GivePlayerSmokeyPoints100000()
	sendClientCommand("GN84-ECO", "redeemCash", {getPlayer():getUsername(), 100000})
end

function GivePlayerSmokeyPoints1000000()
	sendClientCommand("GN84-ECO", "redeemCash", {getPlayer():getUsername(), 1000000})
end

function GivePlayerSmokeyPointsVariable(amount)
	sendClientCommand("GN84-ECO", "redeemCash", {getPlayer():getUsername(), amount})
end

function GivePlayerSmokeyPointsLottoTicket(amount)
	sendClientCommand("GN84-ECO", "redeemLottoTicket", {getPlayer():getUsername(), amount})
end

function GivePlayerSmokeyPointsVIPToken()
	sendClientCommand("GN84-ECO", "redeemVIPToken", {getPlayer():getUsername(), VIPTokenCashValue})
end

function GivePlayerSmokeyPointsEventToken()
	sendClientCommand("GN84-ECO", "redeemEventToken", {getPlayer():getUsername(), EventTokenCashValue})
end

-- Add Smokey Points on Zombie Kill
-- ------------------------------- --

function SmokeyPointsOnZombieKill(zombie)	
	local lastAttacker = zombie:getAttackedBy()
	local isoPlayer = getPlayer()

	if isoPlayer == nil then
		return
	end

	if isoPlayer == lastAttacker then
		sendClientCommand("GN84-ECO", "zombieKillPts", {getPlayer():getUsername(), pointsPerZombieKill})		
	end	

end

Events.OnZombieDead.Add(SmokeyPointsOnZombieKill)
	

------------------------------
-- Searching Wallets for Money
------------------------------

--  VARIABLES

	local wealth;  		-- Zombie Wealth - Upper Class, Middle Class, Lower Class
	local eFunds;  		-- Zombie EFunds Odds
	local walletCash; 	-- Total Money found from Wallets
	local eFundCash;	-- Total Money found from hidden Emergency Funds
	local combinedCash; -- Total of Wallet / EFunds
	local eFundBill;	-- Efund Roll
	local lottoTicketWinnings;  -- Lottery Ticket Winnings

	
function searchEFunds()

	-- Check for Luck

	--print("EFunds - Checking Luck...")

	if getPlayer():HasTrait("Lucky") 
	then
		--print ("Player is Lucky!")
		eFundOdds = SandboxVars.GN84ECO.EFundOdds + 5
	elseif getPlayer():HasTrait("Unlucky")
	then
		--print ("Player is Un-Lucky!")
		eFundOdds = SandboxVars.GN84ECO.EFundOdds - 5
	else
		--print("Player is neither Lucky or Unlucky...")
		eFundOdds = SandboxVars.GN84ECO.EFundOdds
	end

	--print ("eFunds Roll: ", eFunds)
	--print ("eFunds Odds: ", eFundOdds)

	if (eFunds <= eFundOdds)  -- Check if Zombie had EFunds
		then
			eFundBill = ZombRand(100)+1;
			--print ("eFundBill Roll: ", eFundBill)
			
			if (eFundBill >= 98)
				then
					eFundCash = 200
			elseif (eFundBill >= 90 and eFundBill <98)
				then
					eFundCash = 100
					
			elseif (eFundBill <= 25)
				then
					eFundCash = 50
			elseif (eFundBill >28 and eFundBill <83)
				then
					eFundCash = 20
			else
				--print ("eFund Success but No Money...")
			end

			-- DEBUGGING
			--print ("***Zombie Had Emergency Funds -", eFundCash, "***")
		end
end

function searchWalletCash()
	
	--print ("Wealth Roll: ", wealth)
	if (wealth >=90) -- Wealthy
		then
			walletCash = ZombRand(wealthyCash)+1
		
	elseif (wealth < 40) -- Poor
		then
			walletCash = ZombRand(poorCash)+1		
	elseif (wealth >=42 and wealth <=86) -- Average
		then
			walletCash = ZombRand(averageCash)+1
	else
		--print ("Found NO Cash in Wallet...")
	end


	-- DEBUGGING
	--print ("Wallet Cash: ", walletCash)

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
	
	local luckBonus = 1

	-- print("Wallet Total - Checking Luck...")

	if getPlayer():HasTrait("Lucky") 
	then
		-- print ("Player is Lucky!")
		luckBonus = playerLuckBonus
	elseif getPlayer():HasTrait("Unlucky")
	then
		-- print ("Player is Un-Lucky!")
		luckBonus = playerUnluckyPenalty
	else
		-- print("Player is neither Lucky or Unlucky...")
		luckBonus = 1
	end

	--print ("Standard Cash: ", (math.floor(eFundCash + walletCash)))
	combinedCash = math.floor((eFundCash + walletCash) * luckBonus)          -- Total Cash from Wallet

	--print ("Standard + Bonus Cash: ", combinedCash)

	-- DEBUGGING
	-- print ("Total: ", combinedCash)

	-- print ("-------------------------")
	-- print ("-------------------------")
	
	while(t ~= combinedCash) do
		player:getInventory():AddItem("Money");
		t = t+1
	end
end


----------------------------------------
-- Scratch Lotto Tickets
----------------------------------------

function CheckForWinner()

-- Check for Luck

	if getPlayer():HasTrait("Lucky") 
	then
		--print ("Player is Lucky!")
		lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds - 0.15

	elseif getPlayer():HasTrait("Unlucky")
	then
		--print ("Player is Un-Lucky!")
		lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds + 0.15

	else
		--print("Player is neither Lucky or Unlucky...")
		lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds

	end

	--print ("Lottery Odds: 1 in ", lotteryTicketOdds)


	isWinner = ZombRand(100)+1;
	if isWinner <= ((1 / lotteryTicketOdds) * 100)
	then
		return true
	else		
		return false
	end

end

function CalcLottoWinnings()

	lottoTicketRoll = ZombRand(10000)+1;
		--print ("Lotto Ticket Roll: ", lottoTicketRoll)
		
		if (lottoTicketRoll >= 9994)
			then
				lottoTicketWinnings = 50000

		elseif (lottoTicketRoll >= 9953 and lottoTicketRoll <9994)
			then
				lottoTicketWinnings = 25000

		elseif (lottoTicketRoll >= 9851 and lottoTicketRoll <9953)
		then
			lottoTicketWinnings = 10000		

		elseif (lottoTicketRoll >= 9700 and lottoTicketRoll <9851)
		then
			lottoTicketWinnings = 5000

		elseif (lottoTicketRoll >= 8290 and lottoTicketRoll <9700)
		then
			lottoTicketWinnings = 2500

		elseif (lottoTicketRoll >= 6034 and lottoTicketRoll <8290)
		then
			lottoTicketWinnings = 1000
		
		elseif (lottoTicketRoll >= 3200 and lottoTicketRoll <6034)
		then
			lottoTicketWinnings = 500

		else
			lottoTicketWinnings = 250				
		end

		-- DEBUGGING
		--print ("***Lottery Ticket Winnings -", lottoTicketWinnings, "***")
		GivePlayerSmokeyPointsLottoTicket(lottoTicketWinnings)
		winningText = ("Ticket is a Winner!  You Won " .. lottoTicketWinnings .. " Smokey Points!")
		getPlayer():Say(winningText)
	
end


function ScratchLottoTicketStandard()

		if CheckForWinner()
			then
				print("Ticket is a Winner!")
				CalcLottoWinnings()
				PlayLottoWinnerSound()
			else
				print("Sorry, Ticket is Not a Winner..  Play again!")
				getPlayer():Say("Sorry, Ticket is Not a Winner..  Play Again!")
				PlayLottoLoserSound()
		end		
end

function TradeRareTicketForStandardTickets(items, result, player)
	local t = 0;

	while(t ~= 5)
		do
			player:getInventory():AddItem("GN84-ECO.LottoTicketStandard");
			t = t+1
		end
end

function TradeRareTicketForCashStack(items, result, player)
	local t = 0;

	while(t ~= rareTicketCashValue)
		do
			player:getInventory():AddItem("GN84-ECO.MoneyStack1000");
			t = t+1
		end
end


function PlayLottoWinnerSound()
	getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1);
end

function PlayLottoLoserSound()
	getSoundManager():PlaySound("ShredLottoTicket", false, 1):setVolume(1);
end


----------------------------------------
-- Cutting up Wallets for Leather Strips
----------------------------------------

--  VARIABLES

local leatherRoll;
local extraLeatherOdds = 90
local maxExtraLeather = 1
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

----------------------------------------
-- Limit Money Clip to holding Money / Stacks
----------------------------------------

function GN84_AcceptItemCash(container, item)
	if item:getFullType() == "Base.Money" or item:getFullType() == "GN84-ECO.MoneyStack100" or item:getFullType() == "GN84-ECO.MoneyStack1000" or item:getFullType() == "GN84-ECO.MoneyStack10000" or item:getFullType() == "GN84-ECO.MoneyStack100000" or item:getFullType() == "GN84-ECO.MoneyStack1000000" or item:getFullType() == "GN84-ECO.LottoTicketStandard" or item:getFullType() == "GN84-ECO.LottoTicketRare" or item:getFullType() == "GN84-ECO.LottoTicketGolden" or item:getFullType() == "GN84-ECO.WheelSpinToken" or item:getFullType() == "GN84-ECO.SuperWheelSpinToken" or item:getFullType() == "GN84-ECO.VIPToken" or item:getFullType() == "GN84-ECO.EventToken"or item:getFullType() == "GN84-ECO.SafehouseExpansionPermit10" or item:getFullType() == "GN84-ECO.SafehouseExpansionPermit100" or item:getFullType() == "GN84-ECO.SafehouseExpansionPermit1000" or item:getFullType() == "GN84-ECO.AdditionalSafehousePermit" or item:getFullType() == "GN84-ECO.ResidentialPermitSmall" or item:getFullType() == "GN84-ECO.ResidentialPermitLarge" or item:getFullType() == "GN84-ECO.ResidentialPermitMansion" or item:getFullType() == "GN84-ECO.CommercialClaimPermit" or item:getFullType() == "GN84-ECO.FactionPermitSmall" or item:getFullType() == "GN84-ECO.FactionPermitLarge" or item:getFullType() == "GN84-ECO.FactionPermitMassive"
	then
		return true
	end
end



---------------------------
-- Shredding and  Recycling
---------------------------

-- VARIABLES

local watchesMinValue = SandboxVars.GN84ECO.WatchesMinValue	or 3	
local watchesMaxValue = SandboxVars.GN84ECO.WatchesMaxValue	or 10	
local jewelrySimpleMinValue = SandboxVars.GN84ECO.JewelrySimpleMinValue or 1
local jewelrySimpleMaxValue = SandboxVars.GN84ECO.JewelrySimpleMaxValue or 5
local jewelryPreciousMinValue = SandboxVars.GN84ECO.JewelryPreciousMinValue or 10
local jewelryPreciousMaxValue = SandboxVars.GN84ECO.JewelryPreciousMaxValue or 50
local jewelryGemsMinValue = SandboxVars.GN84ECO.JewelryGemsMinValue or 25
local jewelryGemsMaxValue = SandboxVars.GN84ECO.JewelryGemsMaxValue or 100
local jewelryDiamondMinValue = SandboxVars.GN84ECO.JewelryDiamondMinValue or 100
local jewelryDiamondMaxValue = SandboxVars.GN84ECO.JewelryDiamondMaxValue or 200

local simpleToolMinValue = SandboxVars.GN84ECO.SimpleToolMinValue or 1
local simpleToolMaxValue = SandboxVars.GN84ECO.simpleToolMaxValue or 10
local largeToolMinValue = SandboxVars.GN84ECO.LargeToolMinValue or 10
local largeToolMaxValue = SandboxVars.GN84ECO.LargeToolMaxValue or 40
local complexToolMinValue = SandboxVars.GN84ECO.ComplexToolMinValue or 40
local complexToolMaxValue = SandboxVars.GN84ECO.ComplexToolMaxValue or 100

local leatherMinValue = SandboxVars.GN84ECO.LeatherMinValue or 20
local leatherMaxValue = SandboxVars.GN84ECO.LeatherMaxValue or 50

local clothingMinValue = SandboxVars.GN84ECO.ClothingMinValue or 5
local clothingMaxValue = SandboxVars.GN84ECO.ClothingMaxValue or 25

local bulletVestMinValue = SandboxVars.GN84ECO.BulletVestMinValue or 100
local bulletVestMaxValue = SandboxVars.GN84ECO.BulletVestMaxValue or 250

local glassesMinValue = SandboxVars.GN84ECO.GlassesMinValue or 5
local glassesMaxValue = SandboxVars.GN84ECO.GlassesMaxValue or 20

local paperProductMinValue = SandboxVars.GN84ECO.PaperProductMinValue or 5
local paperProductMaxValue = SandboxVars.GN84ECO.PaperProductMaxValue or 10

local lowElectronicsMinValue = SandboxVars.GN84ECO.LowElectronicsMinValue or 15
local lowElectronicsMaxValue = SandboxVars.GN84ECO.LowElectronicsMaxValue or 35

local highElectronicsMinValue = SandboxVars.GN84ECO.HighElectronicsMinValue or 50
local highElectronicsMaxValue = SandboxVars.GN84ECO.HighElectronicsMaxValue or 100





-- TODO - NEEDS IMPLEMENTED
function PlayGrinderSound()
end

function PlayCashoutSound()
end
-----------------------


-- JEWELRY

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


--TOOLS

function ShredderRecycleSimpleTool(items, result, player)
	local toolValueRoll = ZombRand(simpleToolMinValue, simpleToolMaxValue)+1
	
	local t = 0;

	print("Tool Value: ", toolValueRoll)

	while(t ~= toolValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleLargeTool(items, result, player)
	local toolValueRoll = ZombRand(largeToolMinValue, largeToolMaxValue)+1
	
	local t = 0;

	print("Tool Value: ", toolValueRoll)

	while(t ~= toolValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleComplexTool(items, result, player)
	local toolValueRoll = ZombRand(complexToolMinValue, complexToolMaxValue)+1
	
	local t = 0;

	print("Tool Value: ", toolValueRoll)

	while(t ~= toolValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

-- LEATHER / CLOTHING ITEMS

function ShredderRecycleLeather(items, result, player)
	local leatherValueRoll = ZombRand(leatherMinValue, leatherMaxValue)+1
	
	local t = 0;

	print("Leather Value: ", leatherValueRoll)

	while(t ~= leatherValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleClothing(items, result, player)
	local clothingValueRoll = ZombRand(clothingMinValue, clothingMaxValue)+1
	
	local t = 0;

	print("Clothing Value: ", clothingValueRoll)

	while(t ~= clothingValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleBulletVest(items, result, player)
	local vestValueRoll = ZombRand(bulletVestMinValue, bulletVestMaxValue)+1
	
	local t = 0;

	print("Vest Value: ", vestValueRoll)

	while(t ~= vestValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleGlasses(items, result, player)
	local glassesValueRoll = ZombRand(glassesMinValue, glassesMaxValue)+1
	
	local t = 0;

	print("Glasses Value: ", glassesValueRoll)

	while(t ~= glassesValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

-- PAPER PRODUCTS

function ShredderRecyclePaperProduct(items, result, player)
	local paperValueRoll = ZombRand(paperProductMinValue, paperProductMaxValue)+1
	
	local t = 0;

	print("Paper Value: ", paperValueRoll)

	while(t ~= paperValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

-- ELECTRONICS

function ShredderRecycleLowElectronics(items, result, player)
	local electronicsValueRoll = ZombRand(lowElectronicsMinValue, lowElectronicsMaxValue)+1
	
	local t = 0;

	print("Electronic Value: ", electronicsValueRoll)

	while(t ~= electronicsValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end

function ShredderRecycleHighElectronics(items, result, player)
	local electronicsValueRoll = ZombRand(highElectronicsMinValue, highElectronicsMaxValue)+1
	
	local t = 0;

	print("Electronic Value: ", electronicsValueRoll)

	while(t ~= electronicsValueRoll)
		do
			player:getInventory():AddItem("Money");
			t = t+1
		end
end







----------------------------------
-- Safehouse Validation & Claiming
----------------------------------

-- VARIABLES

buildingSqFootage = nil;

local residentialPermitSmall = SandboxVars.GN84ECO.ResidentialPermitSmall or 1500
local residentialPermitLarge = SandboxVars.GN84ECO.ResidentialPermitLarge or 3500
local residentialPermitMansion = SandboxVars.GN84ECO.ResidentialPermitMansion or 7500
local factionPermitSmall = SandboxVars.GN84ECO.FactionPermitSmall or 10000
local factionPermitLarge = SandboxVars.GN84ECO.FactionPermitLarge or 25000
local factionPermitMassive = SandboxVars.GN84ECO.FactionPermitMassive or 50000





function ValidateSafehouseClaim(worldobjects, square, player)
	
	-- print ("Enteirng ValidateSafehouseClaim")
	CheckSafehouseSize()
	if not buildingSqFootage
	then
		-- print ("Error in Returning Safehouse Size")
		return

	-- SMALL RESIDENTIAL CLAIM
	elseif buildingSqFootage >= residentialPermitSmall and buildingSqFootage < residentialPermitLarge
	then
		-- Check for Permit
		if getPlayer():getInventory():contains("ResidentialPermitSmall")
			then
				-- print ("You can claim this building")
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("ResidentialPermitSmall")
				getPlayer():Say("Claimed Residential Building (Small House)")
				return
			else
				getPlayer():Say("You must purchase a Residential Permit (Small House) to Claim this Building!")
				return
			end					
		return

	-- MEDIUM RESIDENTIAL CLAIM
	elseif buildingSqFootage >= residentialPermitLarge and buildingSqFootage < residentialPermitMansion
	then
		-- Check for Permit
		if getPlayer():getInventory():contains("ResidentialPermitLarge")
			then
				-- print ("You can claim this building")
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("ResidentialPermitLarge")
				getPlayer():Say("Claimed Residential Building (Large House)")
				return
			else
				getPlayer():Say("You must purchase a Residential Permit (Large House) to Claim this Building!")
				return
			end					
		return

	-- LARGE RESIDENTIAL CLAIM
	elseif buildingSqFootage >= residentialPermitMansion and buildingSqFootage < factionPermitSmall
	then
		-- Check for Permit
		if getPlayer():getInventory():contains("ResidentialPermitMansion")
			then
				-- print ("You can claim this building")
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("ResidentialPermitMansion")
				getPlayer():Say("Claimed Residential Building (Mansion)")
				return
			else
				getPlayer():Say("You must purchase a Residential Permit (Mansion) to Claim this Building!")
				return
			end					
		return


			--SMALL FACTION BUNKER CLAIM
	elseif buildingSqFootage >= factionPermitSmall and buildingSqFootage < factionPermitLarge
			then
				-- Check for Permit
				if getPlayer():getInventory():contains("FactionPermitSmall")
					then
						-- print ("You can claim this building")
						playerSafehouseClaim()												
				        getPlayer():getInventory():RemoveOneOf("FactionPermitSmall")
						getPlayer():Say("Claimed Faction Building (Small Bunker)")
						return
					else
						getPlayer():Say("You must purchase a Faction Permit (Small Bunker) to Claim this Building!")
						return
					end				
				return

				--LARGE FACTION BUNKER CLAIM
	elseif buildingSqFootage >= factionPermitLarge and buildingSqFootage < factionPermitMassive
	then
		-- Check for Permit
		if getPlayer():getInventory():contains("FactionPermitLarge")
			then
				-- print ("You can claim this building")
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("FactionPermitLarge")
				getPlayer():Say("Claimed Faction Building (Large Bunker)")
				return
			else
				getPlayer():Say("You must purchase a Faction Permit (Large Bunker) to Claim this Building!")
				return
			end				
		return

	-- MASSIVE FACTION BUNKER CLAIM
	elseif buildingSqFootage >= factionPermitMassive   
	then
		-- Check for Permit
		if getPlayer():getInventory():contains("FactionPermitMassive")
			then
				-- print ("You can claim this building")
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("FactionPermitMassive")
				getPlayer():Say("Claimed Faction Building (Massive Bunker)")
				return
			else
				getPlayer():Say("You must purchase a Faction Permit (Massive Bunker) to Claim this Building!")
				return
			end				
		return


	elseif buildingSqFootage == 0 -- Invalid Safehouse
			then
				print ("Invalid Safehouse")
				return

	else  -- Standard Claim
							
				-- print ("You can claim this building")
				playerSafehouseClaim()
				getPlayer():Say("Claimed Residential Building (Bungalow)")
				
	end
end

function CheckSafehouseSizeDebug(worldobjects, square, player)	
		
	buildingSqFootage = nil
	if not getPlayer():getSquare():getBuilding() -- Error Handling
		then
			print ("Error: Not In Building")			
			getPlayer():Say("Error: Not In Building")
			return
		end

	
		-- Get building definition
	local buildingDef = getPlayer():getSquare():getBuilding():getDef();
	
	if buildingDef == nil -- Error Handling
		then 
			print ("Error: No Building Def") -- Check if player is still in a building
			getPlayer():Say("Error: No Building Def")
			return
	elseif buildingDef
		then
			
			-- Get Building Center Coordinates
			local buildingCenterX = ((buildingDef:getX() + buildingDef:getX2()) / 2) 
			local buildingCenterY = ((buildingDef:getY() + buildingDef:getY2()) / 2)
			
			-- NEW
			local buildingCornerX = buildingDef:getX()
			local buildingCornerX2 = buildingDef:getX2()
			local buildingCornerY = buildingDef:getY()
			local buildingCornerY2 = buildingDef:getY2()

			local storyCount = 0


			-------------------------
			-- BEGIN FLOOR CHECKS  --
			-------------------------


			print ("#############################")

			-- Set Building Check location to Center Coordinates
			local x, y, z = buildingCenterX, buildingCenterY, getPlayer():getZ();				
			local currentTile = getCell():getGridSquare(x, y, z)
			local cachedTile
			local buildingStories = z


			--------------------
			--  CENTER CHECK  --
			--------------------
			

			if currentTile -- Check if Player is Standing on Valid Tile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(x, y, z)
					
					if not currentTile -- Error Handling
					then						
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile
				
				while currentTile:isSolidFloor()
				do		

					z = z + 2
					currentTile = getCell():getGridSquare(x, y, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end

				print ("Center Height: ", buildingStories)
				
				z = 0

			end


			---------------------
			--  CORNER CHECKS  --
			---------------------
			

			-------------
			--  X / Y  --
			-------------
			
			currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY, z)

			if currentTile
			then
				cachedTile = currentTile

				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do						
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X / Y Corner Height: ", buildingStories)

				z = 0

			end
			

			---------------
			--  X2 / Y2  --
			---------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY2, z)

			if currentTile
			then
				cachedTile = currentTile
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	

					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X2 / Y2 Corner Height: ", buildingStories)

				z = 0

			end


			--------------
			--  X / Y2  --
			--------------


			currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY2, z)

			if currentTile
			then
				cachedTile = currentTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X / Y2 Corner Height: ", buildingStories)

				z = 0

			end


			--------------
			--  X2 / Y  --
			--------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY, z)

			if currentTile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X2 / Y Corner Height: ", buildingStories)

			end

			---------------------------
			--  CORNER INSET CHECKS  --
			---------------------------
			
			---------------------
			--  X + 5 / Y + 5  --
			---------------------
			
			currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY + 5, z)

			if currentTile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end					
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do				
										
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then						
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end					
				end	

				print ("X + 5 / Y + 5 Inset Corner Height: ", buildingStories)

				z = 0

			end

			-----------------------
			--  X2 - 5 / Y2 - 5  --
			-----------------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY2 - 5, z)

			if currentTile
			then
				cachedTile = currentTile
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	

					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X2 -5 / Y2 -5 Inset Corner Height: ", buildingStories)

				z = 0

			end

			----------------------
			--  X + 5 / Y2 - 5  --
			----------------------


			currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY2 - 5, z)

			if currentTile
			then
				cachedTile = currentTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X + 5 / Y2 - 5 Inset Corner Height: ", buildingStories)

				z = 0

			end

			---------------------
			--  X2 - 5 / Y + 5  --
			---------------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY + 5, z)

			if currentTile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("X2 - 5 / Y + 5 Inset Corner Height: ", buildingStories)

			end

			--------------------------
			-- CENTER OFFSET CHECKS --
			--------------------------

			------------------
			--  +- 3 TILES  --
			------------------

			-----------------------
			--  X + 3  /  Y + 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY + 3, z)

			if currentTile and (buildingCenterX + 3 < buildingCornerX2) and (buildingCenterY + 3 < buildingCornerY2) 
			then			
				
				while currentTile:isSolidFloor()
				do		
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY + 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 3 / Y + 3 Height: ", buildingStories)

			end


			-----------------------
			--  X + 3  /  Y - 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY - 3, z)

			if currentTile and (buildingCenterX + 3 < buildingCornerX2) and (buildingCenterY - 3 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY - 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 3 / Y - 3 Height: ", buildingStories)

			end


			-----------------------
			--  X - 3  /  Y + 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY + 3, z)

			if currentTile and (buildingCenterX - 3 > buildingCornerX) and (buildingCenterY + 3 > buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY + 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 3 / Y + 3 Height: ", buildingStories)

			end


			-----------------------
			--  X - 3  /  Y - 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY - 3, z)

			if currentTile and (buildingCenterX - 3 > buildingCornerX) and (buildingCenterY - 3 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY - 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 3 / Y - 3 Height: ", buildingStories)

			end


			------------------
			--  +- 5 TILES  --
			------------------
			
			-----------------------
			--  X + 5  /  Y + 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY + 5, z)

			if currentTile and (buildingCenterX + 5 < buildingCornerX2) and (buildingCenterY + 5 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 5 / Y + 5 Height: ", buildingStories)

			end


			-----------------------
			--  X + 5  /  Y - 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY - 5, z)

			if currentTile and (buildingCenterX + 5 < buildingCornerX2) and (buildingCenterY - 5 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 5 / Y - 5 Height: ", buildingStories)

			end


			-----------------------
			--  X - 5  /  Y + 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY + 5, z)

			if currentTile and (buildingCenterX - 5 > buildingCornerX) and (buildingCenterY + 5 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 5 / Y + 5 Height: ", buildingStories)

			end


			-----------------------
			--  X - 5  /  Y - 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY - 5, z)

			if currentTile and (buildingCenterX - 5 > buildingCornerX) and (buildingCenterY - 5 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 5 / Y - 5 Height: ", buildingStories)

			end


			------------------
			--  +- 7 TILES  --
			------------------
			
			-----------------------
			--  X + 7  /  Y + 7  --
			-----------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY + 7, z)

			if currentTile and (buildingCenterX + 7 < buildingCornerX2) and (buildingCenterY + 7 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY + 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 7 / Y + 7 Height: ", buildingStories)

			end


			-----------------------
			--  X + 7  /  Y - 7  --
			-----------------------
			

			currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY - 7, z)

			if currentTile and (buildingCenterX + 7 < buildingCornerX2) and (buildingCenterY - 7 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY - 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 7 / Y - 7 Height: ", buildingStories)

			end


			-----------------------
			--  X - 7  /  Y + 7  --
			-----------------------
			
			currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY + 7, z)

			if currentTile and (buildingCenterX - 7 > buildingCornerX) and (buildingCenterY + 7 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY + 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 7 / Y + 7 Height: ", buildingStories)

			end


			-----------------------
			--  X - 7  /  Y - 7  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY - 7, z)

			if currentTile and (buildingCenterX - 7 > buildingCornerX) and (buildingCenterY - 7 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY - 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 7 / Y - 7 Height: ", buildingStories)

			end



			-------------------
			--  +- 10 TILES  --
			-------------------
			
			-------------------------
			--  X + 10  /  Y + 10  --
			-------------------------
			

			currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY + 10, z)

			if currentTile and (buildingCenterX + 10 < buildingCornerX2) and (buildingCenterY + 10 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY + 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 10 / Y + 10 Height: ", buildingStories)

			end


			-------------------------
			--  X + 10  /  Y - 10  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY - 10, z)

			if currentTile and (buildingCenterX + 10 < buildingCornerX2) and (buildingCenterY - 10 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY - 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 10 / Y - 10 Height: ", buildingStories)

			end


			-------------------------
			--  X - 10  /  Y + 10  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY + 10, z)
			
			if currentTile and (buildingCenterX - 10 > buildingCornerX) and (buildingCenterY + 10 < buildingCornerY2)  
			then
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY + 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 10 / Y + 10 Height: ", buildingStories)

			end


			-------------------------
			--  X - 10  /  Y - 10  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY - 10, z)

			if currentTile and (buildingCenterX - 10 > buildingCornerX) and (buildingCenterY - 10 > buildingCornerY) 
			then
				
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY - 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 10 / Y - 10 Height: ", buildingStories)

			end

			-------------------
			--  +- 20 TILES  --
			-------------------
			
			-------------------------
			--  X + 20  /  Y + 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY + 20, z)

			if currentTile and (buildingCenterX + 20 < buildingCornerX2) and (buildingCenterY + 20 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY + 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 20 / Y + 20 Height: ", buildingStories)

			end

					
			-------------------------
			--  X + 20  /  Y - 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY - 20, z)

			if currentTile and (buildingCenterX + 20 < buildingCornerX2) and (buildingCenterY - 20 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY - 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 20 / Y - 20 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 20  /  Y + 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY + 20, z)

			if currentTile and (buildingCenterX - 20 > buildingCornerX)	and (buildingCenterY + 20 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY + 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 20 / Y + 20 Height: ", buildingStories)

			end


			-------------------------
			--  X - 20  /  Y - 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY - 20, z)

			if currentTile and (buildingCenterX - 20 > buildingCornerX)	and (buildingCenterY - 20 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY - 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 20 / Y - 20 Height: ", buildingStories)

			end

			-------------------
			--  +- 30 TILES  --
			-------------------
			
			-------------------------
			--  X + 30  /  Y + 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY + 30, z)

			if currentTile and (buildingCenterX + 30 < buildingCornerX2) and (buildingCenterY + 30 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY + 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 30 / Y + 30 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 30  /  Y - 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY - 30, z)

			if currentTile and (buildingCenterX + 30 < buildingCornerX2) and (buildingCenterY - 30 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY - 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 30 / Y - 30 Height: ", buildingStories)

			end



			-------------------------
			--  X - 30  /  Y + 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY + 30, z)

			if currentTile and (buildingCenterX - 30 > buildingCornerX)	and (buildingCenterY + 30 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY + 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 30 / Y + 30 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 30  /  Y - 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY - 30, z)
						
			if currentTile and (buildingCenterX - 30 > buildingCornerX)	and (buildingCenterY - 30 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY - 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 30 / Y - 30 Height: ", buildingStories)

			end

			-------------------
			--  +- 40 TILES  --
			-------------------
			
			-------------------------
			--  X + 40  /  Y + 40  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY + 40, z)

			if currentTile and (buildingCenterX + 40 < buildingCornerX2) and (buildingCenterY + 40 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY + 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 40 / Y + 40 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 40  /  Y - 40  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY - 40, z)

			if currentTile and (buildingCenterX + 40 < buildingCornerX2) and (buildingCenterY - 40 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY - 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 40 / Y - 40 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 40  /  Y + 40  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY + 40, z)

			if currentTile and (buildingCenterX - 40 > buildingCornerX)	and (buildingCenterY + 40 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY + 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 40 / Y + 40 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 40  /  Y - 40  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY - 40, z)
			
			if currentTile and (buildingCenterX - 40 > buildingCornerX)	and (buildingCenterY - 40 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY - 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 40 / Y - 40 Height: ", buildingStories)

			end

			-------------------
			--  +- 50 TILES  --
			-------------------
			
			-------------------------
			--  X + 50  /  Y + 50  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY + 50, z)

			if currentTile and (buildingCenterX + 50 < buildingCornerX2) and (buildingCenterY + 50 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY + 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 50 / Y + 50 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 50  /  Y - 50  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY - 50, z)

			if currentTile and (buildingCenterX + 50 < buildingCornerX2) and (buildingCenterY - 50 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY - 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 50 / Y - 50 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 50  /  Y + 50  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY + 50, z)

			if currentTile and (buildingCenterX - 50 > buildingCornerX)	and (buildingCenterY + 50 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY + 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 50 / Y + 50 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 50  /  Y - 50  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY - 50, z)
						
			if currentTile and (buildingCenterX - 50 > buildingCornerX)	and (buildingCenterY - 50 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY - 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 50 / Y - 50 Height: ", buildingStories)

			end

			-------------------
			--  +- 60 TILES  --
			-------------------
			
			-------------------------
			--  X + 60  /  Y + 60  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY + 60, z)

			if currentTile and (buildingCenterX + 60 < buildingCornerX2) and (buildingCenterY + 60 < buildingCornerY2)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY + 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 60 / Y + 60 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 60  /  Y - 60  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY - 60, z)

			if currentTile and (buildingCenterX + 60 < buildingCornerX2) and (buildingCenterY - 60 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY - 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 60 / Y - 60 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 60  /  Y + 60  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY + 60, z)

			if currentTile and (buildingCenterX - 60 > buildingCornerX)	and (buildingCenterY + 60 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY + 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 60 / Y + 60 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 60  /  Y - 60  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY - 60, z)
						
			if currentTile and (buildingCenterX - 60 > buildingCornerX)	and (buildingCenterY - 60 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY - 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 60 / Y - 60 Height: ", buildingStories)

			end

			-------------------
			--  +- 70 TILES  --
			-------------------
			
			-------------------------
			--  X + 70  /  Y + 70  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY + 70, z)

			if currentTile and (buildingCenterX + 70 < buildingCornerX2) and (buildingCenterY + 70 < buildingCornerY2)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY + 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 70 / Y + 70 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 70  /  Y - 70  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY - 70, z)

			if currentTile and (buildingCenterX + 70 < buildingCornerX2) and (buildingCenterY - 70 > buildingCornerY)
			then
							
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY - 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X + 70 / Y - 70 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 70  /  Y + 70  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY + 70, z)

			if currentTile and (buildingCenterX - 70 > buildingCornerX)	and (buildingCenterY + 70 < buildingCornerY2)
			then			
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY + 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 70 / Y + 70 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 70  /  Y - 70  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY - 70, z)
						
			if currentTile and (buildingCenterX - 70 > buildingCornerX)	and (buildingCenterY - 70 > buildingCornerY)
			then	

				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY - 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				print ("Center X - 70 / Y - 70 Height: ", buildingStories)

			end
			
			-----------------------
			-- END FLOOR CHECKS
			-----------------------
			

			print ("Story Count: ", storyCount)
			buildingStories = storyCount

			-- Get Width and Height of Building Bounds
			local buildingHeight = buildingDef:getH();
			local buildingWidth = buildingDef:getW();		
							

			print ("#############################")
			print ("Coords: X: ", buildingDef:getX(), " X2: ", buildingDef:getX2(), " Y: ", buildingDef:getY(), " Y2: ", buildingDef:getY2())
			print ("Safehouse Center: ", buildingCenterX, " x ", buildingCenterY)
			print ("Running Safehouse Size Check...")
			print ("Safehouse Size is: ", buildingWidth, " Wide -- ", buildingHeight, " Tall")	
			print ("#############################")
			
			if buildingStories == nil -- Error Handling
			then
				return
			end
			
				if (buildingStories == 0) -- Single Story Building
				then
					print ("Building is ", (buildingStories + 1)," Story Tall")
					getPlayer():Say("Building is " .. (buildingStories + 1) .. " Story Tall")
					buildingSqFootage = buildingHeight * buildingWidth * 9					
					
				elseif (buildingStories >= 1) -- Multi-Story Building
					then
						print ("Building is ", (buildingStories)," Story Tall")
						getPlayer():Say("Building is " .. (buildingStories + 1) .. " Story Tall")
						buildingSqFootage = (buildingHeight * buildingWidth * 9 * buildingStories)						
					
				else -- Invalid Building
					
				end	
						print ("Safehouse Single Floor Square Footage: ", (buildingHeight * buildingWidth * 9))	
						print ("Safehouse Total Square Footage: ", (buildingSqFootage))	
						print ("#############################")
						getPlayer():Say("Safehouse Single Floor Square Footage: " .. (buildingHeight * buildingWidth * 9))
						getPlayer():Say("Safehouse Total Square Footage: " .. (buildingSqFootage))

			
						-- PRINT PERMIT REQUIRED
			if not buildingSqFootage
			then
				-- print ("Error in Returning Safehouse Size")
			return

			-- SMALL RESIDENTIAL CLAIM
			elseif buildingSqFootage >= residentialPermitSmall and buildingSqFootage < residentialPermitLarge
			then
					getPlayer():Say("Residential Permit (Small House) Required to Claim!")
					return

			-- MEDIUM RESIDENTIAL CLAIM
			elseif buildingSqFootage >= residentialPermitLarge and buildingSqFootage < residentialPermitMansion
			then
				
					getPlayer():Say("Residential Permit (Large House) Required to Claim!")
					return

			-- LARGE RESIDENTIAL CLAIM
			elseif buildingSqFootage >= residentialPermitMansion and buildingSqFootage < factionPermitSmall
			then
				
					getPlayer():Say("Residential Permit (Mansion) Required to Claim!")
					return

					--SMALL FACTION BUNKER CLAIM
			elseif buildingSqFootage >= factionPermitSmall and buildingSqFootage < factionPermitLarge
			then		
					getPlayer():Say("Faction Permit (Small Bunker) Required to Claim!")
					return

						--LARGE FACTION BUNKER CLAIM
			elseif buildingSqFootage >= factionPermitLarge and buildingSqFootage < factionPermitMassive
			then
					getPlayer():Say("Faction Permit (Large Bunker) Required to Claim!")
					return

			-- MASSIVE FACTION BUNKER CLAIM
			elseif buildingSqFootage >= factionPermitMassive   
			then
				
					getPlayer():Say("Faction Permit (Massive Bunker) Required to Claim!")
					return

			elseif buildingSqFootage == 0 -- Invalid Safehouse
			then
					print ("Invalid Safehouse")
					return

			else  -- Standard Claim									
						
					getPlayer():Say("No Permit Required to Claim!")
						
			end
		end
		

end

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
			print ("Error: No Building Def") -- Check if player is still in a building
			return
	elseif buildingDef
		then
			
			-- Get Building Center Coordinates
			local buildingCenterX = ((buildingDef:getX() + buildingDef:getX2()) / 2) 
			local buildingCenterY = ((buildingDef:getY() + buildingDef:getY2()) / 2)
			
			-- NEW
			local buildingCornerX = buildingDef:getX()
			local buildingCornerX2 = buildingDef:getX2()
			local buildingCornerY = buildingDef:getY()
			local buildingCornerY2 = buildingDef:getY2()

			local storyCount = 0


			-------------------------
			-- BEGIN FLOOR CHECKS  --
			-------------------------


			print ("#############################")

			-- Set Building Check location to Center Coordinates
			local x, y, z = buildingCenterX, buildingCenterY, getPlayer():getZ();				
			local currentTile = getCell():getGridSquare(x, y, z)
			local cachedTile
			local buildingStories = z


			--------------------
			--  CENTER CHECK  --
			--------------------
			

			if currentTile -- Check if Player is Standing on Valid Tile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(x, y, z)
					
					if not currentTile -- Error Handling
					then						
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile
				
				while currentTile:isSolidFloor()
				do		

					z = z + 2
					currentTile = getCell():getGridSquare(x, y, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end

				--print ("Center Height: ", buildingStories)
				
				z = 0

			end


			---------------------
			--  CORNER CHECKS  --
			---------------------
			

			-------------
			--  X / Y  --
			-------------
			
			currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY, z)

			if currentTile
			then
				cachedTile = currentTile

				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do						
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X / Y Corner Height: ", buildingStories)

				z = 0

			end
			

			---------------
			--  X2 / Y2  --
			---------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY2, z)

			if currentTile
			then
				cachedTile = currentTile
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	

					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X2 / Y2 Corner Height: ", buildingStories)

				z = 0

			end


			--------------
			--  X / Y2  --
			--------------


			currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY2, z)

			if currentTile
			then
				cachedTile = currentTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX, buildingCornerY2, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X / Y2 Corner Height: ", buildingStories)

				z = 0

			end


			--------------
			--  X2 / Y  --
			--------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY, z)

			if currentTile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2, buildingCornerY, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X2 / Y Corner Height: ", buildingStories)

			end

			---------------------------
			--  CORNER INSET CHECKS  --
			---------------------------
			
			---------------------
			--  X + 5 / Y + 5  --
			---------------------
			
			currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY + 5, z)

			if currentTile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end					
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do				
										
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then						
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end					
				end	

				--print ("X + 5 / Y + 5 Inset Corner Height: ", buildingStories)

				z = 0

			end

			-----------------------
			--  X2 - 5 / Y2 - 5  --
			-----------------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY2 - 5, z)

			if currentTile
			then
				cachedTile = currentTile
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	

					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X2 -5 / Y2 -5 Inset Corner Height: ", buildingStories)

				z = 0

			end

			----------------------
			--  X + 5 / Y2 - 5  --
			----------------------


			currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY2 - 5, z)

			if currentTile
			then
				cachedTile = currentTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX + 5, buildingCornerY2 - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X + 5 / Y2 - 5 Inset Corner Height: ", buildingStories)

				z = 0

			end

			---------------------
			--  X2 - 5 / Y + 5  --
			---------------------
			

			currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY + 5, z)

			if currentTile
			then
				cachedTile = currentTile
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--CHECK FOR HIGHER CEILING
				z = 0
				currentTile = cachedTile

				while currentTile:isSolidFloor()
				do	
					
					z = z + 2
					currentTile = getCell():getGridSquare(buildingCornerX2 - 5, buildingCornerY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("X2 - 5 / Y + 5 Inset Corner Height: ", buildingStories)

			end

			--------------------------
			-- CENTER OFFSET CHECKS --
			--------------------------

			------------------
			--  +- 3 TILES  --
			------------------

			-----------------------
			--  X + 3  /  Y + 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY + 3, z)

			if currentTile and (buildingCenterX + 3 < buildingCornerX2) and (buildingCenterY + 3 < buildingCornerY2) 
			then			
				
				while currentTile:isSolidFloor()
				do		
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY + 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 3 / Y + 3 Height: ", buildingStories)

			end


			-----------------------
			--  X + 3  /  Y - 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY - 3, z)

			if currentTile and (buildingCenterX + 3 < buildingCornerX2) and (buildingCenterY - 3 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 3, buildingCenterY - 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 3 / Y - 3 Height: ", buildingStories)

			end


			-----------------------
			--  X - 3  /  Y + 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY + 3, z)

			if currentTile and (buildingCenterX - 3 > buildingCornerX) and (buildingCenterY + 3 > buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY + 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 3 / Y + 3 Height: ", buildingStories)

			end


			-----------------------
			--  X - 3  /  Y - 3  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY - 3, z)

			if currentTile and (buildingCenterX - 3 > buildingCornerX) and (buildingCenterY - 3 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 3, buildingCenterY - 3, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 3 / Y - 3 Height: ", buildingStories)

			end


			------------------
			--  +- 5 TILES  --
			------------------
			
			-----------------------
			--  X + 5  /  Y + 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY + 5, z)

			if currentTile and (buildingCenterX + 5 < buildingCornerX2) and (buildingCenterY + 5 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 5 / Y + 5 Height: ", buildingStories)

			end


			-----------------------
			--  X + 5  /  Y - 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY - 5, z)

			if currentTile and (buildingCenterX + 5 < buildingCornerX2) and (buildingCenterY - 5 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 5, buildingCenterY - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 5 / Y - 5 Height: ", buildingStories)

			end


			-----------------------
			--  X - 5  /  Y + 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY + 5, z)

			if currentTile and (buildingCenterX - 5 > buildingCornerX) and (buildingCenterY + 5 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY + 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 5 / Y + 5 Height: ", buildingStories)

			end


			-----------------------
			--  X - 5  /  Y - 5  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY - 5, z)

			if currentTile and (buildingCenterX - 5 > buildingCornerX) and (buildingCenterY - 5 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 5, buildingCenterY - 5, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 5 / Y - 5 Height: ", buildingStories)

			end


			------------------
			--  +- 7 TILES  --
			------------------
			
			-----------------------
			--  X + 7  /  Y + 7  --
			-----------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY + 7, z)

			if currentTile and (buildingCenterX + 7 < buildingCornerX2) and (buildingCenterY + 7 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY + 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 7 / Y + 7 Height: ", buildingStories)

			end


			-----------------------
			--  X + 7  /  Y - 7  --
			-----------------------
			

			currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY - 7, z)

			if currentTile and (buildingCenterX + 7 < buildingCornerX2) and (buildingCenterY - 7 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 7, buildingCenterY - 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 7 / Y - 7 Height: ", buildingStories)

			end


			-----------------------
			--  X - 7  /  Y + 7  --
			-----------------------
			
			currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY + 7, z)

			if currentTile and (buildingCenterX - 7 > buildingCornerX) and (buildingCenterY + 7 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY + 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 7 / Y + 7 Height: ", buildingStories)

			end


			-----------------------
			--  X - 7  /  Y - 7  --
			-----------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY - 7, z)

			if currentTile and (buildingCenterX - 7 > buildingCornerX) and (buildingCenterY - 7 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 7, buildingCenterY - 7, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 7 / Y - 7 Height: ", buildingStories)

			end



			-------------------
			--  +- 10 TILES  --
			-------------------
			
			-------------------------
			--  X + 10  /  Y + 10  --
			-------------------------
			

			currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY + 10, z)

			if currentTile and (buildingCenterX + 10 < buildingCornerX2) and (buildingCenterY + 10 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY + 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 10 / Y + 10 Height: ", buildingStories)

			end


			-------------------------
			--  X + 10  /  Y - 10  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY - 10, z)

			if currentTile and (buildingCenterX + 10 < buildingCornerX2) and (buildingCenterY - 10 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 10, buildingCenterY - 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 10 / Y - 10 Height: ", buildingStories)

			end


			-------------------------
			--  X - 10  /  Y + 10  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY + 10, z)
			
			if currentTile and (buildingCenterX - 10 > buildingCornerX) and (buildingCenterY + 10 < buildingCornerY2)  
			then
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY + 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 10 / Y + 10 Height: ", buildingStories)

			end


			-------------------------
			--  X - 10  /  Y - 10  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY - 10, z)

			if currentTile and (buildingCenterX - 10 > buildingCornerX) and (buildingCenterY - 10 > buildingCornerY) 
			then
				
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 10, buildingCenterY - 10, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 10 / Y - 10 Height: ", buildingStories)

			end

			-------------------
			--  +- 20 TILES  --
			-------------------
			
			-------------------------
			--  X + 20  /  Y + 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY + 20, z)

			if currentTile and (buildingCenterX + 20 < buildingCornerX2) and (buildingCenterY + 20 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY + 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 20 / Y + 20 Height: ", buildingStories)

			end

					
			-------------------------
			--  X + 20  /  Y - 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY - 20, z)

			if currentTile and (buildingCenterX + 20 < buildingCornerX2) and (buildingCenterY - 20 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 20, buildingCenterY - 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 20 / Y - 20 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 20  /  Y + 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY + 20, z)

			if currentTile and (buildingCenterX - 20 > buildingCornerX)	and (buildingCenterY + 20 < buildingCornerY2) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY + 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 20 / Y + 20 Height: ", buildingStories)

			end


			-------------------------
			--  X - 20  /  Y - 20  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY - 20, z)

			if currentTile and (buildingCenterX - 20 > buildingCornerX)	and (buildingCenterY - 20 > buildingCornerY) 
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 20, buildingCenterY - 20, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 20 / Y - 20 Height: ", buildingStories)

			end

			-------------------
			--  +- 30 TILES  --
			-------------------
			
			-------------------------
			--  X + 30  /  Y + 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY + 30, z)

			if currentTile and (buildingCenterX + 30 < buildingCornerX2) and (buildingCenterY + 30 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY + 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 30 / Y + 30 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 30  /  Y - 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY - 30, z)

			if currentTile and (buildingCenterX + 30 < buildingCornerX2) and (buildingCenterY - 30 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 30, buildingCenterY - 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 30 / Y - 30 Height: ", buildingStories)

			end



			-------------------------
			--  X - 30  /  Y + 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY + 30, z)

			if currentTile and (buildingCenterX - 30 > buildingCornerX)	and (buildingCenterY + 30 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY + 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 30 / Y + 30 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 30  /  Y - 30  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY - 30, z)
						
			if currentTile and (buildingCenterX - 30 > buildingCornerX)	and (buildingCenterY - 30 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 30, buildingCenterY - 30, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 30 / Y - 30 Height: ", buildingStories)

			end

			-------------------
			--  +- 40 TILES  --
			-------------------
			
			-------------------------
			--  X + 40  /  Y + 40  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY + 40, z)

			if currentTile and (buildingCenterX + 40 < buildingCornerX2) and (buildingCenterY + 40 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY + 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 40 / Y + 40 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 40  /  Y - 40  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY - 40, z)

			if currentTile and (buildingCenterX + 40 < buildingCornerX2) and (buildingCenterY - 40 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 40, buildingCenterY - 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 40 / Y - 40 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 40  /  Y + 40  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY + 40, z)

			if currentTile and (buildingCenterX - 40 > buildingCornerX)	and (buildingCenterY + 40 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY + 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 40 / Y + 40 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 40  /  Y - 40  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY - 40, z)
			
			if currentTile and (buildingCenterX - 40 > buildingCornerX)	and (buildingCenterY - 40 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 40, buildingCenterY - 40, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 40 / Y - 40 Height: ", buildingStories)

			end

			-------------------
			--  +- 50 TILES  --
			-------------------
			
			-------------------------
			--  X + 50  /  Y + 50  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY + 50, z)

			if currentTile and (buildingCenterX + 50 < buildingCornerX2) and (buildingCenterY + 50 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY + 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 50 / Y + 50 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 50  /  Y - 50  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY - 50, z)

			if currentTile and (buildingCenterX + 50 < buildingCornerX2) and (buildingCenterY - 50 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 50, buildingCenterY - 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 50 / Y - 50 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 50  /  Y + 50  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY + 50, z)

			if currentTile and (buildingCenterX - 50 > buildingCornerX)	and (buildingCenterY + 50 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY + 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 50 / Y + 50 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 50  /  Y - 50  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY - 50, z)
						
			if currentTile and (buildingCenterX - 50 > buildingCornerX)	and (buildingCenterY - 50 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 50, buildingCenterY - 50, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 50 / Y - 50 Height: ", buildingStories)

			end

			-------------------
			--  +- 60 TILES  --
			-------------------
			
			-------------------------
			--  X + 60  /  Y + 60  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY + 60, z)

			if currentTile and (buildingCenterX + 60 < buildingCornerX2) and (buildingCenterY + 60 < buildingCornerY2)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY + 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 60 / Y + 60 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 60  /  Y - 60  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY - 60, z)

			if currentTile and (buildingCenterX + 60 < buildingCornerX2) and (buildingCenterY - 60 > buildingCornerY)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 60, buildingCenterY - 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 60 / Y - 60 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 60  /  Y + 60  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY + 60, z)

			if currentTile and (buildingCenterX - 60 > buildingCornerX)	and (buildingCenterY + 60 < buildingCornerY2)
			then
			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY + 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 60 / Y + 60 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 60  /  Y - 60  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY - 60, z)
						
			if currentTile and (buildingCenterX - 60 > buildingCornerX)	and (buildingCenterY - 60 > buildingCornerY)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 60, buildingCenterY - 60, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 60 / Y - 60 Height: ", buildingStories)

			end

			-------------------
			--  +- 70 TILES  --
			-------------------
			
			-------------------------
			--  X + 70  /  Y + 70  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY + 70, z)

			if currentTile and (buildingCenterX + 70 < buildingCornerX2) and (buildingCenterY + 70 < buildingCornerY2)
			then			
				
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY + 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 70 / Y + 70 Height: ", buildingStories)

			end

			
			-------------------------
			--  X + 70  /  Y - 70  --
			-------------------------

			currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY - 70, z)

			if currentTile and (buildingCenterX + 70 < buildingCornerX2) and (buildingCenterY - 70 > buildingCornerY)
			then
							
				while currentTile:isSolidFloor()
				do	
					
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX + 70, buildingCenterY - 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X + 70 / Y - 70 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 70  /  Y + 70  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY + 70, z)

			if currentTile and (buildingCenterX - 70 > buildingCornerX)	and (buildingCenterY + 70 < buildingCornerY2)
			then			
				
				while currentTile:isSolidFloor()
				do				
										
					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY + 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 70 / Y + 70 Height: ", buildingStories)

			end

			
			-------------------------
			--  X - 70  /  Y - 70  --
			-------------------------


			currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY - 70, z)
						
			if currentTile and (buildingCenterX - 70 > buildingCornerX)	and (buildingCenterY - 70 > buildingCornerY)
			then	

				while currentTile:isSolidFloor()
				do	

					z = z + 1
					currentTile = getCell():getGridSquare(buildingCenterX - 70, buildingCenterY - 70, z)
					
					if not currentTile -- Error Handling
					then
						break
					end

					buildingStories = z					
					if buildingStories > storyCount
						then
							storyCount = buildingStories
						end
				end	

				--print ("Center X - 70 / Y - 70 Height: ", buildingStories)

			end
			
			-----------------------
			-- END FLOOR CHECKS
			-----------------------
			
			buildingStories = storyCount

			-- Get Width and Height of Building Bounds
			local buildingHeight = buildingDef:getH();
			local buildingWidth = buildingDef:getW();		
							

			print ("#############################")
			
			if buildingStories == nil -- Error Handling
			then
				return
			end
			
				if (buildingStories == 0) -- Single Story Building
				then
					print ("Building is ", (buildingStories + 1)," Story Tall")
					buildingSqFootage = buildingHeight * buildingWidth * 9					
					
				elseif (buildingStories >= 1) -- Multi-Story Building
					then
						print ("Building is ", (buildingStories)," Story Tall")
						buildingSqFootage = (buildingHeight * buildingWidth * 9 * buildingStories)						
					
				else -- Invalid Building
					
				end	
						--print ("Safehouse Single Floor Square Footage: ", (buildingHeight * buildingWidth * 9))	
						print ("Safehouse Total Square Footage: ", (buildingSqFootage))	
						print ("#############################")
				
		end
end


-----------------------------
-- Vanilla Claiming Functions
-----------------------------

function playerSafehouseClaim(worldobjects, square, player)
	local builddef = getPlayer():getSquare():getBuilding():getDef()
    SafeHouse.addSafeHouse(builddef:getX() - 2, builddef:getY() - 2, builddef:getW() + 2*2, builddef:getH() + 2*2, getPlayer():getUsername(), false)
end


--THE FIX.  THANK FUCKING GOD!
--[[ Events.OnFillWorldObjectContextMenu.Add(function(player, context, worldobjects, test)
    local option = nil
    for _, opt in pairs(context.options) do
        if opt.name == getText("ContextMenu_SafehouseClaim") then
            option = opt
            break
        end
    end
    if not option then return end    
        option.onSelect = ValidateSafehouseClaim
    end
) ]]


local function Context_safezone(player, context, worldobjects, test)
	local option = nil
    for _, opt in pairs(context.options) do
        if opt.name == getText("ContextMenu_SafehouseClaim") then
            option = opt
            break
        end
    end
    if not option then return end    
        option.onSelect = ValidateSafehouseClaim   
end

Events.OnFillWorldObjectContextMenu.Add(Context_safezone)

----------------------------
-- ADMIN DEBUGGING FUNCTIONS
----------------------------

--  CHECK FOR FAVORITED OR EQUIPPED ITEM

function Recipe.OnTest.IsNotFavorited(item, result)
    return not item:isFavorite() and not item:isEquipped()
end

--  HOTKEY FOR SAFEHOUSE SIZE CHECK

function debuggingKey(_keyPressed)
	local key = _keyPressed
	if getAccessLevel() == "admin" then
		-- print (tostring(key))
		if key == 71
			then		
				--ValidateSafehouseClaim()
				CheckSafehouseSizeDebug()
			end	
	end
end

Events.OnKeyPressed.Add(debuggingKey);