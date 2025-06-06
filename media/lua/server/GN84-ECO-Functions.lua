require "recipecode"
require "ISUI/ISContextMenu"


--------------------------
-- Sandbox Variables
--------------------------

local pointsPerZombieKill 		= SandboxVars.GN84ECO.PointsPerZombieKill 		or 18 				-- 6   - Smokey Points per Zombie Kill
local eFundOdds 				= SandboxVars.GN84ECO.EFundOdds					or 10          		-- 10  - Must roll <= to this number to get eFunds
local walletCashMultiplier 		= SandboxVars.GN84ECO.WalletCashMultiplier 		or 1.0				-- 1.0 -   Adjust total Wallet Cash
local eFundCashMultiplier 		= SandboxVars.GN84ECO.EFundCashMultiplier		or 1.0				-- 1.0 - Adjust total eFund Cash
local wealthyCash 				= SandboxVars.GN84ECO.WealthyCash				or 50				-- 20 - Max cash found in Wealthy Zombie Wallet
local averageCash 				= SandboxVars.GN84ECO.AverageCash				or 15				-- 10 - Max cash found in Average Zombie Wallet
local poorCash 					= SandboxVars.GN84ECO.PoorCash 					or 5				-- 5  - Max cash found in Poor Zombie Wallet
local playerLuckBonus 			= SandboxVars.GN84ECO.PlayerLuckBonus 			or 1.2
local playerUnluckyPenalty 		= SandboxVars.GN84ECO.PlayerUnluckyPenalty 		or 0.95
local lotteryTicketOdds 		= SandboxVars.GN84ECO.LotteryTicketOdds 		or 3.25
local rareTicketCashValue 		= SandboxVars.GN84ECO.RareTicketCashValue 		or 1          		-- Value to trade in Rare Blue Ticket for cash Stacks (in Thousands)
local VIPTokenCashValue 		= SandboxVars.GN84ECO.VIPTokenCashValue 		or 1000000          -- Value to trade in VIP Tokens for cash
local WandererTokenCashValue	= SandboxVars.GN84ECO.WandererTokenCashValue 	or 10000          	-- Value to trade in Wanderer Tokens for cash



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

function GivePlayerLottoTicketBonusPrize(item)
	sendClientCommand("GN84-ECO", "redeemLottoTicketBonusPrize", {getPlayer():getUsername(), item})
end

function GivePlayerSmokeyPointsVIPToken()
	sendClientCommand("GN84-ECO", "redeemVIPToken", {getPlayer():getUsername(), VIPTokenCashValue})
end

function GivePlayerSmokeyPointsWandererToken()
	sendClientCommand("GN84-ECO", "redeemWandererToken", {getPlayer():getUsername(), WandererTokenCashValue})
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

	local wealth 				-- Zombie Wealth - Upper Class, Middle Class, Lower Class
	local eFunds 				-- Zombie EFunds Odds
	local walletCash			-- Total Money found from Wallets
	local eFundCash				-- Total Money found from hidden Emergency Funds
	local combinedCash  		-- Total of Wallet / EFunds
	local eFundBill				-- Efund Roll
	local lottoTicketWinnings  	-- Lottery Ticket Winnings

	
function searchEFunds()

	if getPlayer():HasTrait("Lucky") then		
		eFundOdds = SandboxVars.GN84ECO.EFundOdds + 5

	elseif getPlayer():HasTrait("Unlucky") then		
		eFundOdds = SandboxVars.GN84ECO.EFundOdds - 5

	else		
		eFundOdds = SandboxVars.GN84ECO.EFundOdds
	end

	if (eFunds <= eFundOdds) then
			eFundBill = ZombRand(100)+1			
			
		if (eFundBill >= 98) then
				eFundCash = 200

		elseif (eFundBill >= 90 and eFundBill <98) then
				eFundCash = 100
				
		elseif (eFundBill <= 25) then
				eFundCash = 50

		elseif (eFundBill >28 and eFundBill <83) then
				eFundCash = 20

		else
			--print ("eFund Roll Success but No Money...")
		end

		--print ("***Zombie Had Emergency Funds -", eFundCash, "***")
	end
end

function searchWalletCash()
	
	if (wealth >=90) then
			walletCash = ZombRand(wealthyCash)+1
		
	elseif (wealth < 40) then
			walletCash = ZombRand(poorCash)+1
			
	elseif (wealth >=42 and wealth <=86) then
			walletCash = ZombRand(averageCash)+1

	else
		--print ("Found NO Cash in Wallet...")
	end

	--print ("Wallet Cash: ", walletCash)
end

function CollectMoneyFromWallet(sources, result, player, item)
	
	wealth = ZombRand(100)+1 -- Zombie Wealth Roll
	eFunds = ZombRand(100)+1 -- Zombie EFunds Roll
	walletCash = 0
	eFundCash = 0
	combinedCash = 0
	eFundBill = 0

	searchEFunds()
	searchWalletCash()
	
	local t = 0
	eFundCash  = eFundCash * eFundCashMultiplier      -- Adjusted by Multiplier
	walletCash = walletCash * walletCashMultiplier    -- Adjusted by Multiplier
	
	local luckBonus = 1

	if getPlayer():HasTrait("Lucky") then		
		luckBonus = playerLuckBonus

	elseif getPlayer():HasTrait("Unlucky") then				
		luckBonus = playerUnluckyPenalty
	else		
		luckBonus = 1
	end
	
	combinedCash = math.floor((eFundCash + walletCash) * luckBonus)          -- Total Cash from Wallet
	
	while t ~= combinedCash do
		player:getInventory():AddItem("Money")
		t = t+1
	end

	if item:getFullType() == "Base.Wallet" then
		player:getInventory():AddItem("GN84-ECO.EmptyWallet1")

	elseif item:getFullType() == "Base.Wallet2" then
		player:getInventory():AddItem("GN84-ECO.EmptyWallet2")

	elseif item:getFullType() == "Base.Wallet3" then
		player:getInventory():AddItem("GN84-ECO.EmptyWallet3")

	elseif item:getFullType() == "Base.Wallet4" then
		player:getInventory():AddItem("GN84-ECO.EmptyWallet4")

	end

end


----------------------------------------
-- LOTTO TICKET LOGIC
----------------------------------------

-- LISTS OF BONUS PRIZES

local bonusPrizeRare = 
{
	"Base.Katana",	
	"GN84-ECO.SuperWheelSpinToken",
	"TWeapons.LongSword",
	"GN84-HI.CrystalBall",
	"DynamicBackpacks.UpgradeCapacityMilitary",
	"DynamicBackpacks.UpgradeWeightReductionMilitary",
	"GN84-ECO.WheelSpinToken",
}

local bonusPrizeHigh = 
{
	"GN84-ECO.WandererToken",
	"GN84-ECO.WandererToken",
	"GN84-ECO.LottoTicketRare",
	"Base.Bullets9mmBox",
	"Base.ShotgunShellsBox",
	"Base.22Box",
	"Base.223Box",
	"GWP.357Box",
	"Base.Bullets38Box",
	"Base.Bullets44Box",
	"Base.Bullets45Box",
	"Base.545Box",
	"Base.556Box",
	"Base.762Box",
	"Base.308Box",
	"MoreMedical.SyretteAdrenalin",
	"MoreMedical.SyretteHighGradePainkillers",
	"MoreMedical.BurnTreatment",
	"MoreMedical.PowderPackHemostatic",
	"TAD.CloseKosmotsars",	
}

local bonusPrizeMed = 
{	
	"DS77.DiabloSandwich",
	"GN84-ECO.LottoTicketStandard",
	"Greenfire.OzCannabis",
	"Greenfire.PipeTobaccoBag",
	"Greenfire.CannabisSeed",
	"Greenfire.Hashish",
	"Greenfire.GFCigarettes",
	"Greenfire.GFMystery1",
	"Greenfire.GFSuspect1",
	"9301.SealedCassette9301",		
	"FixAFlat.FixAFlat",
	"MoreMedical.Tourniquet",
	"vacsdrinksaddon.VacsDrinks_Can_5HourEnergyDrink",
	"PompsItems.PIFireball",
}

local bonusPrizeLow = 
{
	"Base.Lighter",
	"Greenfire.Blunt",
	"Greenfire.GFCigar",
	"Greenfire.DelCannaCigar",
	"Greenfire.Joint",
	"Greenfire.RollingPapers",
	"Base.Battery",
	"MoreBrews.BeerCanAmericanLager",
	"MoreBrews.BeerCanAPA1",
	"MoreBrews.BeerCanIPA2",
	"MoreBrews.BeerCanAPA2",
	"MoreBrews.BeerCanIPA1",
	"MoreBrews.BeerCanLightLager",
	"MoreBrews.BeerCanPilsner",
	"MoreBrews.BeerCanPorter",
	"MoreBrews.BeerCanSkunked",
	"MoreBrews.BeerCanStout",
	"MoreMedical.SealedBandage",
	"farming.Bacon",
	"PompsItems.PIPowderDonutBag",
	"PompsItems.PIChocDonutBag",
	"PompsItems.BittersBar",
	"PompsItems.PIPopTartSWBox",
	"PompsItems.PISpam",
	"PompsItems.PICannedRavioli",
	"PompsItems.PICheeseStickDip",
	"PompsItems.Dabs",
	"PompsItems.COreoPackage",
	"PompsItems.GooberBar",
	"PompsItems.Pomps",
	"farming.Potato",
	"Ramen.RamenChickenPack",
	"vacsdrinks.VacsDrinks_Can_CocaCola",
	"vacsdrinks.VacsDrinks_Can_DrPepper",
	"vacsdrinks.VacsDrinks_Can_Fanta",
	"vacsdrinks.VacsDrinks_Can_MountainDew",
	"vacsdrinks.VacsDrinks_Can_MugRootBeer",
	"vacsdrinks.VacsDrinks_Can_Pepsi",
	"vacsdrinks.VacsDrinks_Can_Sprite",
}



function CheckForWinner()

-- Check for Luck

	if getPlayer():HasTrait("Lucky") then		
		lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds - 0.15
	elseif getPlayer():HasTrait("Unlucky") then		
		lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds + 0.15
	else		
		lotteryTicketOdds = SandboxVars.GN84ECO.LotteryTicketOdds
	end

	isWinner = ZombRand(100)+1
	if isWinner <= ((1 / lotteryTicketOdds) * 100) then
		return true
	else		
		return false
	end
end

function CalcLottoWinnings()

	local lottoTicketRoll = ZombRand(10000)+1
	local lottoBonusPrizeRoll = ZombRand(100)+1


	if (lottoTicketRoll >= 9994) then
		lottoTicketWinnings = 100000

	elseif (lottoTicketRoll >= 9953 and lottoTicketRoll < 9994)	then
		lottoTicketWinnings = 50000

	elseif (lottoTicketRoll >= 9851 and lottoTicketRoll < 9953)	then
		lottoTicketWinnings = 25000

	elseif (lottoTicketRoll >= 9700 and lottoTicketRoll < 9851)	then
		lottoTicketWinnings = 10000

	elseif (lottoTicketRoll >= 8290 and lottoTicketRoll < 9700)	then
		lottoTicketWinnings = 5000

	elseif (lottoTicketRoll >= 6034 and lottoTicketRoll < 8290)	then
		lottoTicketWinnings = 2500
				
	elseif(lottoTicketRoll >= 3200 and lottoTicketRoll < 6034)	then
		lottoTicketWinnings = 1000

	else
		lottoTicketWinnings = 250				
	end
		
	GivePlayerSmokeyPointsLottoTicket(lottoTicketWinnings)
	local winningText = ("Ticket is a Winner!  You Won " .. lottoTicketWinnings .. " Smokey Points!")
	getPlayer():Say(winningText)

	-- Roll for Bonus Prize	
	
	if lottoBonusPrizeRoll <= ((1 / lotteryTicketOdds) * 100) then
		local prizeCategory = ZombRand(10000)+1
		local bonusPrize = nil

		if prizeCategory >= 9933 then
			bonusPrize = bonusPrizeRare[ZombRand(1, #bonusPrizeRare)]

		elseif (prizeCategory >= 8600 and prizeCategory < 9933) then
			bonusPrize = bonusPrizeHigh[ZombRand(1, #bonusPrizeHigh)]

		elseif (prizeCategory >= 5000 and prizeCategory < 8600) then
			bonusPrize = bonusPrizeMed[ZombRand(1, #bonusPrizeMed)]

		else
			bonusPrize = bonusPrizeLow[ZombRand(1, #bonusPrizeLow)]

		end

		local bonusItem = ScriptManager.instance:getItem(bonusPrize):getName()
		local bonusText = ("Bonus Prize!  You Won - " .. bonusItem)

		
		GivePlayerLottoTicketBonusPrize(bonusItem)
		getPlayer():getInventory():AddItem(bonusPrize)
		getPlayer():Say(bonusText)
	end	

	
end


function ScratchLottoTicketStandard()
	if CheckForWinner()	then				
		CalcLottoWinnings()
		PlayLottoWinnerSound()
	else			
		getPlayer():Say("Sorry, Ticket is Not a Winner..  Play Again!")
		PlayLottoLoserSound()
	end		
end

function TradeRareTicketForStandardTickets(items, result, player)
	local t = 0

	while t ~= 5 do
		player:getInventory():AddItem("GN84-ECO.LottoTicketStandard")
		t = t+1
	end
end

function TradeRareTicketForCashStack(items, result, player)
	local t = 0

	while t ~= rareTicketCashValue do
		player:getInventory():AddItem("GN84-ECO.MoneyStack1000")
		t = t+1
	end
end

local randomAmmoList =
{
	[1]  = "Base.Bullets9mmBox",
	[2]  = "Base.ShotgunShellsBox",
	[3]  = "Base.22Box",
	[4]  = "Base.223Box",
	[5]  = "GWP.357Box",
	[6]  = "Base.Bullets38Box",
	[7]  = "Base.Bullets44Box",
	[8]  = "Base.Bullets45Box",
	[9]  = "Base.545Box",
	[10] = "Base.556Box",
	[11] = "Base.762Box",
	[12] = "Base.308Box",
}

function TradeRareTicketForRandomAmmo(items, result, player)
	local randNum = ZombRand(1, #randomAmmoList)
	player:getInventory():AddItem(randomAmmoList[randNum])
end


function PlayLottoWinnerSound()
	getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1)
end

function PlayLottoLoserSound()
	getSoundManager():PlaySound("ShredLottoTicket", false, 1):setVolume(1)
end


----------------------------------------
-- Cutting up Wallets for Leather Strips
----------------------------------------

--  VARIABLES

local leatherRoll
local extraLeatherOdds = 90
local maxExtraLeather = 1
local extraLeatherStrips

function CutLeatherWallet(items, result, player)
	leatherRoll = ZombRand(100)+1  -- Extra Leather Roll
	extraLeatherStrips = 0
	
	if (leatherRoll >= extraLeatherOdds) then			
		extraLeatherStrips = ZombRand(maxExtraLeather)
	end
		
	local t = 0

	while t ~= extraLeatherStrips do
		player:getInventory():AddItem("LeatherStrips")
		t = t+1
	end
end

----------------------------------------
-- LIMIT MONEY CLIP ITEMS
----------------------------------------

function GN84_AcceptItemsMoneyClip(container, item)

	local moneyClipItems = 
	{
		[1]  = "Base.Money",
		[2]  = "GN84-ECO.MoneyStack100",
		[3]  = "GN84-ECO.MoneyStack1000",
		[4]  = "GN84-ECO.MoneyStack10000",
		[5]  = "GN84-ECO.MoneyStack100000",
		[6]  = "GN84-ECO.MoneyStack1000000",
		[7]  = "GN84-ECO.LottoTicketStandard",
		[8]  = "GN84-ECO.LottoTicketRare",
		[9]  = "GN84-ECO.LottoTicketGolden",
		[10] = "GN84-ECO.WheelSpinToken",
		[11] = "GN84-ECO.SuperWheelSpinToken",
		[12] = "GN84-ECO.VIPToken",
		[13] = "GN84-ECO.VIPTokenNew",
		[14] = "GN84-ECO.EventToken",
		[15] = "GN84-ECO.WandererToken",
		[16] = "GN84-ECO.SafehouseExpansionPermit10",
		[17] = "GN84-ECO.SafehouseExpansionPermit100",
		[18] = "GN84-ECO.SafehouseExpansionPermit1000",
		[19] = "GN84-ECO.AdditionalSafehousePermit",
		[20] = "GN84-ECO.CommercialClaimPermit",
		[21] = "GN84-ECO.ResidentialPermitSmall",
		[22] = "GN84-ECO.ResidentialPermitLarge",
		[23] = "GN84-ECO.ResidentialPermitMansion",
		[24] = "GN84-ECO.FactionPermitSmall",
		[25] = "GN84-ECO.FactionPermitLarge",
		[26] = "GN84-ECO.FactionPermitMassive",
		[27] = "Base.AVCSClaimOrb",
	}

	for i, v in ipairs(moneyClipItems) do
		if item:getFullType() == v then
			return true
		end
	end
	
end



---------------------------
-- SHREDDING AND RECYCLING
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
	local t = 0

	--print("Watch Value: ", watchesValueRoll)

	while t ~= watchesValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelrySimple(items, result, player)
	local jewelryValueRoll = ZombRand(jewelrySimpleMinValue, jewelrySimpleMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelryPrecious(items, result, player)
	local jewelryValueRoll = ZombRand(jewelryPreciousMinValue, jewelryPreciousMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelryGemstones(items, result, player)
	local jewelryValueRoll = ZombRand(jewelryGemsMinValue, jewelryGemsMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleJewelryDiamond(items, result, player)
	local jewelryValueRoll = ZombRand(jewelryDiamondMinValue, jewelryDiamondMaxValue)+1	
	local t = 0

	--print("Jewelry Value: ", jewelryValueRoll)

	while t ~= jewelryValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end



--TOOLS

function ShredderRecycleSimpleTool(items, result, player)
	local toolValueRoll = ZombRand(simpleToolMinValue, simpleToolMaxValue)+1	
	local t = 0

	--print("Tool Value: ", toolValueRoll)

	while t ~= toolValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleLargeTool(items, result, player)
	local toolValueRoll = ZombRand(largeToolMinValue, largeToolMaxValue)+1	
	local t = 0

	--print("Tool Value: ", toolValueRoll)

	while t ~= toolValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleComplexTool(items, result, player)
	local toolValueRoll = ZombRand(complexToolMinValue, complexToolMaxValue)+1	
	local t = 0

	--print("Tool Value: ", toolValueRoll)

	while t ~= toolValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end



-- LEATHER / CLOTHING ITEMS

function ShredderRecycleLeather(items, result, player)
	local leatherValueRoll = ZombRand(leatherMinValue, leatherMaxValue)+1	
	local t = 0

	--print("Leather Value: ", leatherValueRoll)

	while t ~= leatherValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleClothing(items, result, player)
	local clothingValueRoll = ZombRand(clothingMinValue, clothingMaxValue)+1	
	local t = 0

	--print("Clothing Value: ", clothingValueRoll)

	while t ~= clothingValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleBulletVest(items, result, player)
	local vestValueRoll = ZombRand(bulletVestMinValue, bulletVestMaxValue)+1	
	local t = 0

	--print("Vest Value: ", vestValueRoll)

	while t ~= vestValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleGlasses(items, result, player)
	local glassesValueRoll = ZombRand(glassesMinValue, glassesMaxValue)+1	
	local t = 0

	--print("Glasses Value: ", glassesValueRoll)

	while t ~= glassesValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end



-- PAPER PRODUCTS

function ShredderRecyclePaperProduct(items, result, player)
	local paperValueRoll = ZombRand(paperProductMinValue, paperProductMaxValue)+1	
	local t = 0

	--print("Paper Value: ", paperValueRoll)

	while t ~= paperValueRoll do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end



-- ELECTRONICS

function ShredderRecycleLowElectronics(items, result, player)
	local electronicsValueRoll = ZombRand(lowElectronicsMinValue, lowElectronicsMaxValue)+1	
	local t = 0

	--print("Electronic Value: ", electronicsValueRoll)

	while t ~= electronicsValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end

function ShredderRecycleHighElectronics(items, result, player)
	local electronicsValueRoll = ZombRand(highElectronicsMinValue, highElectronicsMaxValue)+1	
	local t = 0

	--print("Electronic Value: ", electronicsValueRoll)

	while t ~= electronicsValueRoll	do
		player:getInventory():AddItem("Money")
		t = t+1
	end
end







----------------------------------
-- Safehouse Validation & Claiming
----------------------------------

local residentialPermitSmall = SandboxVars.GN84ECO.ResidentialPermitSmall or 1500
local residentialPermitLarge = SandboxVars.GN84ECO.ResidentialPermitLarge or 3500
local residentialPermitMansion = SandboxVars.GN84ECO.ResidentialPermitMansion or 7500
local factionPermitSmall = SandboxVars.GN84ECO.FactionPermitSmall or 10000
local factionPermitLarge = SandboxVars.GN84ECO.FactionPermitLarge or 25000
local factionPermitMassive = SandboxVars.GN84ECO.FactionPermitMassive or 50000

local function CalculateBuildingSize(worldobjects, square, player)	
		
    local player = getPlayer()
    local buildingSqFootage = nil

    local isResidential = nil
    local isFlaggedResidential = nil
    local hasBedroom = nil
    local hasLivingRoom = nil
	
    -- ERROR HANDLING - CHECK IF NOT ON THE MAP / MOVING
    if player:getSquare() == nil then
        return nil, nil
    end

    -- ERROR HANDLING - CHECK IF NOT IN BUILDING
	if player:getSquare():getBuilding() == nil then			
        player:Say("Error: Not In Building")
        return nil, nil
    end
	

    -- GET BUILDING DEFINITION AND ID
	local buildingDef = player:getSquare():getBuilding():getDef()
    local buildingID = player:getSquare():getBuilding()
    

    -- Double Check if player is still in a building
	if (buildingDef == nil) or (buildingID == nil) then 
        print ("Error: No Building Def") 
        player:Say("Error: No Building Def")
        return nil, nil
    end

	if buildingDef then
			
            -- CHECK IF BUILDING IS RESIDENTIAL
            isFlaggedResidential = buildingID:isResidential()
            hasBedroom = buildingDef:containsRoom("bedroom")
            hasLivingRoom = buildingDef:containsRoom("livingroom")

            -- print("Flagged Residential: ", isFlaggedResidential)
            -- print("Has Kitchen: ", hasKitchen)
            -- print("Has Bedroom: ", hasBedroom)
            -- print("Has Living Room: ", hasLivingRoom)

            if isFlaggedResidential then
                isResidential = true
            elseif not isFlaggedResidential then
                if hasBedroom or hasLivingRoom then
                    isResidential = true
                else
                    isResidential = false
                end                
            end


			-- Get Building Center Coordinates
			local buildingCenterX = ((buildingDef:getX() + buildingDef:getX2()) / 2) 
			local buildingCenterY = ((buildingDef:getY() + buildingDef:getY2()) / 2)
			
			-- Get Building Corners
			local buildingCornerX = buildingDef:getX()
			local buildingCornerX2 = buildingDef:getX2()
			local buildingCornerY = buildingDef:getY()
			local buildingCornerY2 = buildingDef:getY2()

           
            local z = player:getZ()
            local currentCell = getCell()
			
			local buildingStories = 0
            local storyCount = 0
            local heightChecks = 6
            local currentHeightCheck = 0

            -- LIST OF POINTS TO CHECK
            tileCheckList = 
            {
                [1]  = { X = buildingCenterX, Y = buildingCenterY},                
                [2]  = { X = buildingCornerX,  Y = buildingCornerY},
                [3]  = { X = buildingCornerX2, Y = buildingCornerY2},
                [4]  = { X = buildingCornerX, Y = buildingCornerY2},
                [5]  = { X = buildingCornerX2, Y = buildingCornerY},
                [6]  = { X = buildingCornerX + 5,  Y = buildingCornerY + 5},
                [7]  = { X = buildingCornerX2 - 5,  Y = buildingCornerY2 - 5},
                [8]  = { X = buildingCornerX + 5,  Y = buildingCornerY2 - 5},
                [9]  = { X = buildingCornerX2 - 5,  Y = buildingCornerY + 5},
                [10] = { X = buildingCenterX + 1, Y = buildingCenterY + 1},
                [11] = { X = buildingCenterX + 1, Y = buildingCenterY - 1},
                [12] = { X = buildingCenterX - 1, Y = buildingCenterY + 1},
                [13] = { X = buildingCenterX - 1, Y = buildingCenterY - 1},
                [14] = { X = buildingCenterX + 2, Y = buildingCenterY + 2},
                [15] = { X = buildingCenterX + 2, Y = buildingCenterY - 2},
                [16] = { X = buildingCenterX - 2, Y = buildingCenterY + 2},
                [17] = { X = buildingCenterX - 2, Y = buildingCenterY - 2},
                [18] = { X = buildingCenterX + 3, Y = buildingCenterY + 3},
                [19] = { X = buildingCenterX + 3, Y = buildingCenterY - 3},
                [20] = { X = buildingCenterX - 3, Y = buildingCenterY + 3},
                [21] = { X = buildingCenterX - 3, Y = buildingCenterY - 3},
                [22] = { X = buildingCenterX + 4, Y = buildingCenterY + 4},
                [23] = { X = buildingCenterX + 4, Y = buildingCenterY - 4},
                [24] = { X = buildingCenterX - 4, Y = buildingCenterY + 4},
                [25] = { X = buildingCenterX - 4, Y = buildingCenterY - 4},
                [26] = { X = buildingCenterX + 5, Y = buildingCenterY + 5},
                [27] = { X = buildingCenterX + 5, Y = buildingCenterY - 5},
                [28] = { X = buildingCenterX - 5, Y = buildingCenterY + 5},
                [29] = { X = buildingCenterX - 5, Y = buildingCenterY - 5},
                [30] = { X = buildingCenterX + 6, Y = buildingCenterY + 6},
                [31] = { X = buildingCenterX + 6, Y = buildingCenterY - 6},
                [32] = { X = buildingCenterX - 6, Y = buildingCenterY + 6},
                [33] = { X = buildingCenterX - 6, Y = buildingCenterY - 6},
                [34] = { X = buildingCenterX + 7, Y = buildingCenterY + 7},
                [35] = { X = buildingCenterX + 7, Y = buildingCenterY - 7},
                [36] = { X = buildingCenterX - 7, Y = buildingCenterY + 7},
                [37] = { X = buildingCenterX - 7, Y = buildingCenterY - 7},
                [38] = { X = buildingCenterX + 10, Y = buildingCenterY + 10},
                [39] = { X = buildingCenterX + 10, Y = buildingCenterY - 10},
                [40] = { X = buildingCenterX - 10, Y = buildingCenterY + 10},
                [41] = { X = buildingCenterX - 10, Y = buildingCenterY - 10},
                [42] = { X = buildingCenterX + 15, Y = buildingCenterY + 15},
                [43] = { X = buildingCenterX + 15, Y = buildingCenterY - 15},
                [44] = { X = buildingCenterX - 15, Y = buildingCenterY + 15},
                [45] = { X = buildingCenterX - 15, Y = buildingCenterY - 15},
                [46] = { X = buildingCenterX + 20, Y = buildingCenterY + 20},
                [47] = { X = buildingCenterX + 20, Y = buildingCenterY - 20},
                [48] = { X = buildingCenterX - 20, Y = buildingCenterY + 20},
                [49] = { X = buildingCenterX - 20, Y = buildingCenterY - 20},
                [50] = { X = buildingCenterX + 25, Y = buildingCenterY + 25},
                [51] = { X = buildingCenterX + 25, Y = buildingCenterY - 25},
                [52] = { X = buildingCenterX - 25, Y = buildingCenterY + 25},
                [53] = { X = buildingCenterX - 25, Y = buildingCenterY - 25},
                [54] = { X = buildingCenterX + 30, Y = buildingCenterY + 30},
                [55] = { X = buildingCenterX + 30, Y = buildingCenterY - 30},
                [56] = { X = buildingCenterX - 30, Y = buildingCenterY + 30},
                [57] = { X = buildingCenterX - 30, Y = buildingCenterY - 30},
                [58] = { X = buildingCenterX + 35, Y = buildingCenterY + 35},
                [59] = { X = buildingCenterX + 35, Y = buildingCenterY - 35},
                [60] = { X = buildingCenterX - 35, Y = buildingCenterY + 35},
                [61] = { X = buildingCenterX - 35, Y = buildingCenterY - 35},
                [62] = { X = buildingCenterX + 40, Y = buildingCenterY + 40},
                [63] = { X = buildingCenterX + 40, Y = buildingCenterY - 40},
                [64] = { X = buildingCenterX - 40, Y = buildingCenterY + 40},
                [65] = { X = buildingCenterX - 40, Y = buildingCenterY - 40},
                [66] = { X = buildingCenterX + 50, Y = buildingCenterY + 50},
                [67] = { X = buildingCenterX + 50, Y = buildingCenterY - 50},
                [68] = { X = buildingCenterX - 50, Y = buildingCenterY + 50},
                [69] = { X = buildingCenterX - 50, Y = buildingCenterY - 50},
                [70] = { X = buildingCenterX + 60, Y = buildingCenterY + 60},
                [71] = { X = buildingCenterX + 60, Y = buildingCenterY - 60},
                [72] = { X = buildingCenterX - 60, Y = buildingCenterY + 60},
                [73] = { X = buildingCenterX - 60, Y = buildingCenterY - 60},
                [74] = { X = buildingCenterX + 70, Y = buildingCenterY + 70},
                [75] = { X = buildingCenterX + 70, Y = buildingCenterY - 70},
                [76] = { X = buildingCenterX - 70, Y = buildingCenterY + 70},
                [77] = { X = buildingCenterX - 70, Y = buildingCenterY - 70},
                [78] = { X = buildingCenterX + 80, Y = buildingCenterY + 80},
                [79] = { X = buildingCenterX + 80, Y = buildingCenterY - 80},
                [80] = { X = buildingCenterX - 80, Y = buildingCenterY + 80},
                [81] = { X = buildingCenterX - 80, Y = buildingCenterY - 80},
                [82] = { X = buildingCenterX + 90, Y = buildingCenterY + 90},
                [83] = { X = buildingCenterX + 90, Y = buildingCenterY - 90},
                [84] = { X = buildingCenterX - 90, Y = buildingCenterY + 90},
                [85] = { X = buildingCenterX - 90, Y = buildingCenterY - 90},
                [86] = { X = buildingCenterX + 99, Y = buildingCenterY + 99},
                [87] = { X = buildingCenterX + 99, Y = buildingCenterY - 99},
                [88] = { X = buildingCenterX - 99, Y = buildingCenterY + 99},
                [89] = { X = buildingCenterX - 99, Y = buildingCenterY - 99},
            }


			-------------------------------
			--  Building Height Checks  --
			-------------------------------
			
			
                for i, v in ipairs(tileCheckList) do                       
                        
                    currentTile = currentCell:getGridSquare(tileCheckList[i]["X"], tileCheckList[i]["Y"], z)  

                    if currentTile and (currentTile:getBuilding() == buildingID) then 

                        while currentHeightCheck < heightChecks do
                    
                            --print("Checking Height: " .. currentHeightCheck)
                            z = currentHeightCheck

                            currentTile = currentCell:getGridSquare(tileCheckList[i]["X"], tileCheckList[i]["Y"], z)                        

                            if currentTile and (currentTile:getBuilding() == buildingID) then  

                                    while currentTile:isSolidFloor() do				
                                        coordX = tileCheckList[i]["X"]
                                        coordY = tileCheckList[i]["Y"]
                
                                        --print("X: " .. coordX)
                                        --print("Y: " .. coordY)
                                        --print("Z: " .. z)
                                                            
                                        z = z + 1

                                        currentTile = currentCell:getGridSquare(tileCheckList[i]["X"], tileCheckList[i]["Y"], z)                                    

                                        if not currentTile then						
                                            break
                                        end                                

                                        buildingStories = z					
                                        if buildingStories > storyCount then
                                            storyCount = buildingStories
                                        end
                                    end                                  
                            end

                            currentHeightCheck = currentHeightCheck + 1  
                        end
                    end
                
                    currentHeightCheck = 0
                    z = 0
                end		
            
			buildingStories = storyCount

			-- Get Width and Height of Building Bounds
			local buildingHeight = buildingDef:getH()
			local buildingWidth = buildingDef:getW()	
			
			if buildingStories == nil then
				return nil, nil
			end
			
            -- SINGLE STORY BUILDINGS
            if (buildingStories == 0) then
                            
                if getAccessLevel() == "admin" then
                    --getPlayer():Say("Building is " .. (buildingStories + 1) .. " Story Tall")
                end

                buildingSqFootage = buildingHeight * buildingWidth * 9					
                
            -- MULTI-STORY BUILDINGS
            elseif (buildingStories >= 1) then
                            
                if getAccessLevel() == "admin" then
                    --getPlayer():Say("Building is " .. (buildingStories) .. " Stories Tall")
                end

                buildingSqFootage = (buildingHeight * buildingWidth * 9 * buildingStories)						
                
            -- INVALID BUILDINGS
            else
                --print("Invalid Building")               
            end	        
            
            return buildingSqFootage, isResidential
            
    end
end

function ValidateSafehouseClaim(worldobjects, square, player)
	
	-- print ("Enteirng ValidateSafehouseClaim")
	local squareFootage, residentialBuilding = CalculateBuildingSize()

	if (squareFootage == nil) or (residentialBuilding == nil) then
				getPlayer():Say("Error: Invalid Claim")
		return
	end

	if residentialBuilding then

		-- SMALL HOUSE CLAIM
		if squareFootage >= residentialPermitSmall and squareFootage < residentialPermitLarge then
			
			if getPlayer():getInventory():contains("ResidentialPermitSmall") then
					
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("ResidentialPermitSmall")
				getPlayer():Say("Claimed Property (Small House)")
				return
			else
				getPlayer():Say("You must purchase a Property Claim Permit (Small House) to Claim this Building!")
				return
			end					
		return

		-- LARGE HOUSE CLAIM
		elseif squareFootage >= residentialPermitLarge and squareFootage < residentialPermitMansion	then
			
			if getPlayer():getInventory():contains("ResidentialPermitLarge") then
					
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("ResidentialPermitLarge")
				getPlayer():Say("Claimed Property (Large House)")
				return
			else
				getPlayer():Say("You must purchase a Property Claim Permit (Large House) to Claim this Building!")
				return
			end					
		return

		-- MANSION CLAIM
		elseif squareFootage >= residentialPermitMansion and squareFootage < factionPermitSmall	then
			
			if getPlayer():getInventory():contains("ResidentialPermitMansion") then
				
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("ResidentialPermitMansion")
				getPlayer():Say("Claimed Property (Mansion)")
				return
			else
				getPlayer():Say("You must purchase a Property Claim Permit (Mansion) to Claim this Building!")
				return
			end					
		return

		--SMALL BUNKER CLAIM
		elseif squareFootage >= factionPermitSmall and squareFootage < factionPermitLarge then
					
			if getPlayer():getInventory():contains("FactionPermitSmall") then
				
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("FactionPermitSmall")
				getPlayer():Say("Claimed Property (Small Bunker)")
				return
			else
				getPlayer():Say("You must purchase a Property Claim Permit (Small Bunker) to Claim this Building!")
				return
			end				
		return

		--LARGE FACTION BUNKER CLAIM
		elseif squareFootage >= factionPermitLarge and squareFootage < factionPermitMassive	then
			
			if getPlayer():getInventory():contains("FactionPermitLarge") then
					-- print ("You can claim this building")
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("FactionPermitLarge")
				getPlayer():Say("Claimed Property (Large Bunker)")
				return
			else
				getPlayer():Say("You must purchase a Property Claim Permit (Large Bunker) to Claim this Building!")
				return
			end				
		return

		-- MASSIVE BUNKER CLAIM
		elseif squareFootage >= factionPermitMassive then
			
			if getPlayer():getInventory():contains("FactionPermitMassive") then
				
				playerSafehouseClaim()												
				getPlayer():getInventory():RemoveOneOf("FactionPermitMassive")
				getPlayer():Say("Claimed Property (Massive Bunker)")
				return
			else
				getPlayer():Say("You must purchase a Property Claim Permit (Massive Bunker) to Claim this Building!")
				return
			end				
		return


		elseif squareFootage == 0 then
			print ("Error: Invalid Claim")
			return
		
		-- STANDARD CLAIM - NO PERMIT NEEDED
		else
			
			playerSafehouseClaim()
			getPlayer():Say("Claimed Property (Bungalow)")
					
		end

	elseif not residentialBuilding then
			getPlayer():Say("--Non-Residential Building--")
			getPlayer():Say("Contact an Admin for Assistance")
	end	
end

local function DisplayRequiredClaimPermit(squareFootage, residentialBuilding)

			if (squareFootage == nil) or (residentialBuilding == nil) then
				-- print ("Error in Returning Safehouse Size")
			    return
            end

            if getAccessLevel() == "admin" then
                --getPlayer():Say("Safehouse Single Floor Square Footage: " .. (buildingHeight * buildingWidth * 9))
                getPlayer():Say("Safehouse Square Footage: " .. (squareFootage))
            end   

            if residentialBuilding then
                -- SMALL RESIDENTIAL CLAIM
                if squareFootage >= residentialPermitSmall and squareFootage < residentialPermitLarge then
                        getPlayer():Say("Property Claim Permit (Small House) Required!")					

                -- MEDIUM RESIDENTIAL CLAIM
                elseif squareFootage >= residentialPermitLarge and squareFootage < residentialPermitMansion then				
                        getPlayer():Say("Property Claim Permit (Large House) Required!")					

                -- LARGE RESIDENTIAL CLAIM
                elseif squareFootage >= residentialPermitMansion and squareFootage < factionPermitSmall then				
                        getPlayer():Say("Property Claim Permit (Mansion) Required!")					

                        --SMALL FACTION BUNKER CLAIM
                elseif squareFootage >= factionPermitSmall and squareFootage < factionPermitLarge then		
                        getPlayer():Say("Property Claim Permit (Small Bunker) Required!")					

                            --LARGE FACTION BUNKER CLAIM
                elseif squareFootage >= factionPermitLarge and squareFootage < factionPermitMassive then
                        getPlayer():Say("Property Claim Permit (Large Bunker) Required!")					

                -- MASSIVE FACTION BUNKER CLAIM
                elseif squareFootage >= factionPermitMassive then				
                        getPlayer():Say("Property Claim Permit (Massive Bunker) Required!")					

                elseif squareFootage == 0 then -- Invalid Safehouse			
                        print ("Invalid Safehouse")					

                else  -- Standard Claim			
                        getPlayer():Say("No Permit Required to Claim!")
                            
                end
            end

            if not residentialBuilding then
                getPlayer():Say("--Non-Residential Building--")
                getPlayer():Say("Contact an Admin for Assistance")
            end
end

local function DisplayPermitAction()
    DisplayRequiredClaimPermit(CalculateBuildingSize())
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

local function ShowCheckPermitContextOption(player, context, worldobjects, test)
    
    local player = getPlayer()
    local object = nil
    	
    -- ERROR HANDLING - CHECK IF NOT ON THE MAP / MOVING
    if player:getSquare() == nil then
        return
    end

    -- ERROR HANDLING - CHECK IF NOT IN BUILDING
	if player:getSquare():getBuilding() == nil then			        
        return
    end

    context:addOptionOnTop("Safehouse Claim Requirements", object, DisplayPermitAction, playerObj)     
end

Events.OnFillWorldObjectContextMenu.Add(Context_safezone)
Events.OnFillWorldObjectContextMenu.Add(ShowCheckPermitContextOption)

----------------------------
-- ADMIN DEBUGGING FUNCTIONS
----------------------------

--  CHECK FOR FAVORITED OR EQUIPPED ITEM

function Recipe.OnTest.IsNotFavorited(item, result)
    return not item:isFavorite() and not item:isEquipped()
end


--  HOTKEY FOR DEBUGGING

function debuggingKey(_keyPressed)
	local key = _keyPressed
	if getAccessLevel() == "admin" then
		-- print (tostring(key))
		if key == 71
			then
				
			end	
	end
end

Events.OnKeyPressed.Add(debuggingKey);