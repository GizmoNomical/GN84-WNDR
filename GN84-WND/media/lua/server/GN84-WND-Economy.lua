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

require "recipecode"
require "ISUI/ISContextMenu"

------------------------------------------------------------------------
--                       SANDBOX VARIABLES   
------------------------------------------------------------------------

local pointsPerZombieKill 		= SandboxVars.GN84WND.PointsPerZombieKill 		or 18
local bonusCashOdds				= SandboxVars.GN84WND.EFundOdds					or 10
local walletCashMultiplier 		= SandboxVars.GN84WND.WalletCashMultiplier 		or 1.0
local eFundCashMultiplier 		= SandboxVars.GN84WND.EFundCashMultiplier		or 1.0
local wealthyCashAmount 		= SandboxVars.GN84WND.WealthyCash				or 50
local averageCashAmount 		= SandboxVars.GN84WND.AverageCash				or 15
local poorCashAmount 			= SandboxVars.GN84WND.PoorCash 					or 5
local playerLuckBonus 			= SandboxVars.GN84WND.PlayerLuckBonus 			or 1.2
local playerUnluckyPenalty 		= SandboxVars.GN84WND.PlayerUnluckyPenalty 		or 0.95
local lotteryTicketOdds 		= SandboxVars.GN84WND.LotteryTicketOdds 		or 3.25
local rareTicketCashValue 		= SandboxVars.GN84WND.RareTicketCashValue 		or 1
local VIPTokenCashValue 		= SandboxVars.GN84WND.VIPTokenCashValue 		or 1000000
local WandererTokenCashValue	= SandboxVars.GN84WND.WandererTokenCashValue 	or 10000




------------------------------------------------------------------------
--                          TODO: NEW PLAYER - ADD MONEY CLIP
------------------------------------------------------------------------

-- function OnCreatePlayer(playerIndex, player)
--     if not player:getModData().wallet then
--         local wallet = player:getInventory():AddItem("VM.Leather_Wallet")
--         wallet:getInventory():AddItem("VM.10Bill")
--         wallet:getInventory():AddItem("VM.5Bill")
--         wallet:getInventory():AddItem("VM.5Bill")
--         player:getModData().wallet = true
--     end
-- end

-- Events.OnCreatePlayer.Add(OnCreatePlayer)



------------------------------------------------------------------------
--                          ADDING SMOKEY POINTS
------------------------------------------------------------------------

function GivePlayerSmokeyPoints100()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 100})
end

function GivePlayerSmokeyPoints500()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 500})
end

function GivePlayerSmokeyPoints1000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 1000})
end

function GivePlayerSmokeyPoints5000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 5000})
end

function GivePlayerSmokeyPoints10000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 10000})
end

function GivePlayerSmokeyPoints50000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 50000})
end

function GivePlayerSmokeyPoints100000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 100000})
end

function GivePlayerSmokeyPoints500000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 500000})
end

function GivePlayerSmokeyPoints1000000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 1000000})
end

function GivePlayerSmokeyPoints5000000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 5000000})
end

function GivePlayerSmokeyPoints10000000()
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), 10000000})
end

function GivePlayerSmokeyPointsVariable(amount)
	sendClientCommand("GN84-WND", "redeemCash", {getPlayer():getUsername(), amount})
end

function GivePlayerSmokeyPointsLottoTicket(amount)
	sendClientCommand("GN84-WND", "redeemLottoTicket", {getPlayer():getUsername(), amount})
end

function GivePlayerLottoTicketBonusPrize(item)
	sendClientCommand("GN84-WND", "redeemLottoTicketBonusPrize", {getPlayer():getUsername(), item})
end

function GivePlayerSmokeyPointsVIPToken()
	sendClientCommand("GN84-WND", "redeemVIPToken", {getPlayer():getUsername(), VIPTokenCashValue})
end

function GivePlayerSmokeyPointsWandererToken()
	sendClientCommand("GN84-WND", "redeemWandererToken", {getPlayer():getUsername(), WandererTokenCashValue})
end


------------------------------------------------------------------------
--                  ADD SMOKEY POINTS ON ZOMBIE KILL
------------------------------------------------------------------------

function SmokeyPointsOnZombieKill(zombie)	
	local player = getPlayer()
	if player == nil then return end

	local lastAttacker = zombie:getAttackedBy()

	if player == lastAttacker then
		sendClientCommand("GN84-WND", "zombieKillPts", {player:getUsername(), pointsPerZombieKill})		
	end	
end

Events.OnZombieDead.Add(SmokeyPointsOnZombieKill)
	


------------------------------------------------------------------------
--                      SEARCH WALLETS FOR MONEY
------------------------------------------------------------------------

local function checkWalletForCash(player)
	if player == nil then return false end

	local baseOdds = 80
	local bonusOdds = 0
	
	-- Check for Trait Bonuses
	if player:HasTrait("Lucky") then		
		bonusOdds = baseOdds + 5
	elseif player:HasTrait("Unlucky") then		
		bonusOdds = baseOdds - 5
	else		
		bonusOdds = baseOdds
	end

	-- Roll Check for Cash
	local cashRoll = ZombRand(100) + 1 

	if (cashRoll <= bonusOdds) then
		--print("Standard Cash Roll Success!")
		return true
	else
		return false
	end
end


local function calculateWalletCash(player)
	local cashFound = 0
	local wealthRoll = ZombRand(100) + 1

	--print("Wealth Roll: " .. wealthRoll)
	-- Roll for Bonus Cash Stack
	if (wealthRoll >= 95) then
		player:getInventory():AddItem("GN84-WND.WandererToken")
	end

	-- Roll for Found Cash
	local wealth = ZombRand(100) + 1

	if (wealthRoll >=90) then
			cashFound = ZombRand(wealthyCashAmount) + 1		
	elseif (wealthRoll < 40) then
			cashFound = ZombRand(poorCashAmount) + 1
	elseif (wealthRoll >=42 and wealth <=86) then
			cashFound = ZombRand(averageCashAmount) + 1
	else		
			cashFound = 1
	end

	return cashFound
end




local function checkWalletForBonusCash(player)
	if player == nil then return false end

	local baseOdds = SandboxVars.GN84WND.EFundOdds
	local bonusOdds = 0
	
	-- Check for Trait Bonuses
	if player:HasTrait("Lucky") then		
		bonusOdds = baseOdds + 5
	elseif player:HasTrait("Unlucky") then		
		bonusOdds = baseOdds - 5
	else		
		bonusOdds = baseOdds
	end

	-- Roll Check for Bonus Cash
	local eFundsRoll = ZombRand(100) + 1 

	if (eFundsRoll <= bonusOdds) then
		--print("Bonus Cash Roll Success!")
		return true
	else		
		return false
	end
end


local function calculateBonusWalletCash(player)
	if player == nil then return end	

	local cashFound = 0
	local bonusCashRoll = ZombRand(100) + 1	

	--print("Bonus Cash Roll: " .. bonusCashRoll)

	-- Roll for Bonus Wanderer Token
	if (bonusCashRoll >= 95) then
		player:getInventory():AddItem("GN84-WND.MoneyStack1000")
	end

	-- Calculate Bonus Cash
	if (bonusCashRoll >= 98) then
		cashFound = 200
	elseif (bonusCashRoll >= 90 and bonusCashRoll < 98) then
		cashFound = 100			
	elseif (bonusCashRoll <= 25) then
		cashFound = 50
	elseif (bonusCashRoll > 28 and bonusCashRoll < 83) then
		cashFound = 20
	else			
		cashFound = 10
	end

	return cashFound
end




function CollectMoneyFromWallet(sources, result, player, item)
		
	local walletCash = 0
	local bonusCash = 0
	local combinedCash = 0
	
	local t = 0
	
	if checkWalletForCash(player) then
		walletCash = calculateWalletCash(player) * walletCashMultiplier
		print("Wallet Cash: " .. walletCash)
	end
	
	if checkWalletForBonusCash(player) then
		bonusCash = calculateBonusWalletCash(player) * eFundCashMultiplier		
		print("Bonus Cash: " .. walletCash)
	end
	
	
	-- Check for Luck Bonuses
	local luckBonus = 1

	if player:HasTrait("Lucky") then		
		luckBonus = playerLuckBonus
	elseif player:HasTrait("Unlucky") then				
		luckBonus = playerUnluckyPenalty
	end
	
	-- Total Cash Found in Wallet
	combinedCash = math.floor((walletCash + bonusCash) * luckBonus)

	local playerInv = player:getInventory()
	
	-- Add Cash to Inventory
	if combinedCash > 0 then

		while t ~= combinedCash do
			playerInv:AddItem("Money")
			t = t+1
		end
	end	

	-- Add Matching Empty Wallet to Inventory
	if item:getFullType() == "Base.Wallet" then
		playerInv:AddItem("GN84-WND.EmptyWallet1")

	elseif item:getFullType() == "Base.Wallet2" then
		playerInv:AddItem("GN84-WND.EmptyWallet2")

	elseif item:getFullType() == "Base.Wallet3" then
		playerInv:AddItem("GN84-WND.EmptyWallet3")

	elseif item:getFullType() == "Base.Wallet4" then
		playerInv:AddItem("GN84-WND.EmptyWallet4")

	end
end



------------------------------------------------------------------------
--                          LOTTO TICKETS
------------------------------------------------------------------------

local function PlayLottoWinnerSound()
	getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1)
end

local function PlayLottoLoserSound()
	getSoundManager():PlaySound("ShredLottoTicket", false, 1):setVolume(1)
end


-- LISTS OF BONUS PRIZES
local bonusPrizeRare = 
{
	"Base.Katana",	
	"GN84-WND.SuperWheelSpinToken",
	"GN84-WND.WheelSpinToken",
	"TWeapons.LongSword",
	"GN84-HI.CrystalBall",
	"DynamicBackpacks.UpgradeCapacityMilitary",
	"DynamicBackpacks.UpgradeWeightReductionMilitary",
	"GN84-WND.WheelSpinToken",
	"ToolsOfTheTrade.SpiffArmyKnife",
	"ToolsOfTheTrade.UtensilTool",
	"TWeapons.TacticalMachete",
	"ToolsOfTheTrade.WarHammer",
	"ToolsOfTheTrade.ExecutionersSword",
	"ToolsOfTheTradeKnickKnacks.Mjolnir",
	"Base.Sledgehammer",
	"GWP.ColtPython357",
	"GWP.Glock21",
	"GWP.R870Police",
	"GWP.VikingAxe",
	"Base.Pistol3",
	"Base.DoubleBarrelShotgun",
	"Base.MAC10Unfolded",
	"Base.Shotgun",
	"Base.Makarov",
	"Base.SKS",
}

local bonusPrizeHigh = 
{
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
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
	"MoreMedical.SyrettePrescriptionAntibiotic",
	"MoreMedical.BurnTreatment",
	"MoreMedical.PowderPackHemostatic",
	"TAD.CloseKosmotsars",	
	"newcontainersnc.NCroughbox",
	"TheyKnew.Zomboxivir",
	"TheyKnew.Zomboxycycline",
	"ScottsJumperCables.JumperCables",
	"DynamicBackpacks.UpgradeCapacityLeather",
	"DynamicBackpacks.UpgradeWeightReductionLeather",
	"NalMac.CassettePack",
	"NalMac.DancePack",
	"NalMac.VinylPack",
	"ToolsOfTheTrade.CombatKnife",
	"Base.Aerosolbomb",
	"Base.BoxOfBittersBars",
	"Base.BoxOfPomps",
	"Base.BoxOfHottieZ",
	"Base.BoxOfCanChili",
	"Base.ChipsBox",
	"Base.Bag_DuffelBag",
	"Base.FireKlean",
	"Base.FirearmLubricant",
	"Base.SwatFragGrenade",
	"Base.PetrolCan",
	"Base.GunPowder",
	"Base.Bag_ALICEpack",
	"Base.PipeBomb",
	"Base.PonchoYellow",
	"Base.SmokeBomb",
	"Base.BaseballBatNails",
}

local bonusPrizeMed = 
{	
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"GN84-WND.LottoTicketRare",
	"DS77.DiabloSandwich",
	"GN84-WND.LottoTicketStandard",
	"Greenfire.OzCannabis",
	"Greenfire.PipeTobaccoBag",
	"Greenfire.CannabisSeed",
	"Greenfire.Hashish",
	"Greenfire.GFCigarettes",
	"Greenfire.GFMystery1",
	"Greenfire.GFSuspect1",
	"9301.SealedCassette9301",
	"LFM.SealedCassette",
	"FixAFlat.FixAFlat",
	"MoreMedical.Tourniquet",
	"vacsdrinksaddon.VacsDrinks_Can_5HourEnergyDrink",
	"PompsItems.PIFireball",
	"ToolsOfTheTrade.ArmyCanOpener",
	"ToolsOfTheTrade.BandageScissors",
	"CanteensAndBottles.FlaskBourbon",
	"CanteensAndBottles.FlaskPetrol",
	"Computer.Disc_Game",
	"DynamicBackpacks.UpgradeCapacityJean",
	"DynamicBackpacks.UpgradeWeightReductionJean",
	"DynamicBackpacks.UpgradeCapacityCloth",
	"DynamicBackpacks.UpgradeWeightReductionCloth",
	"GMH.BlackSageseed",
	"GMH.Comfreyseed",
	"GMH.CommonMallowseed",
	"GMH.Ginsengseed",
	"GMH.LemonGrassseed",
	"GMH.Plantainseed",
	"GMH.WildGarlicseed",
	"Base.Pop2CanPack",
	"Base.Baloney",
	"Base.Book",
	"Base.NailsBox",
	"Base.ScrewsBox",
	"Base.PaperclipBox",
	"Base.PKCyanidePill",
	"Base.DuctTape",	
	"Base.Bag_FannyPackFront",
	"Base.Glue",
	"Base.HandAxe",
	"Base.HandTorch",
	"Base.AlcoholRippedSheets",
}

local bonusPrizeLow = 
{
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.WandererToken",
	"GN84-WND.LottoTicketRare",
	"Base.Lighter",
	"Base.Matches",
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
	"farming.Potato",
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
	"Ramen.RamenBeefPack",
	"Ramen.RamenCheesePack",
	"Ramen.RamenChiliPack",
	"Ramen.RamenOrientalPack",
	"Ramen.RamenPorkPack",
	"Ramen.RamenShrimpPack",
	"vacsdrinks.VacsDrinks_Can_CocaCola",
	"vacsdrinks.VacsDrinks_Can_DrPepper",
	"vacsdrinks.VacsDrinks_Can_Fanta",
	"vacsdrinks.VacsDrinks_Can_MountainDew",
	"vacsdrinks.VacsDrinks_Can_MugRootBeer",
	"vacsdrinks.VacsDrinks_Can_Pepsi",
	"vacsdrinks.VacsDrinks_Can_Sprite",
	"vacsdrinksaddon.VacsDrinks_Can_Nos",
	"vacsdrinksaddon.VacsDrinks_Can_Redbull",
	"vacsdrinksaddon.VacsDrinks_Can_Rockstar",
	"Base.Butter",
	"Base.CandyCorn",
	"Base.CandyPackage",
	"Base.TinnedBeans",
	"Base.CannedBolognese",
	"Base.Carrots",
	"Base.Crisps3",
	"Base.Crisps",
	"Base.Crisps2",
	"Base.Crisps4",
	"Base.Egg",
	"Base.Log",
	"Base.Pretzel",
	"Base.RippedSheets",
	"Base.TVDinner",
	"Base.Taco",
}



local function CheckForWinner(player)
	if player == nil then return end

-- Check for Luck

	if player:HasTrait("Lucky") then		
		lotteryTicketOdds = SandboxVars.GN84WND.LotteryTicketOdds - 0.15
	elseif player:HasTrait("Unlucky") then		
		lotteryTicketOdds = SandboxVars.GN84WND.LotteryTicketOdds + 0.15
	else		
		lotteryTicketOdds = SandboxVars.GN84WND.LotteryTicketOdds
	end

	isWinner = ZombRand(100)+1
	if isWinner <= ((1 / lotteryTicketOdds) * 100) then
		return true
	else		
		return false
	end
end



local function CalcLottoWinnings(player)
	if player == nil then return end

	local lottoTicketWinnings = 0
	local lottoTicketRoll = ZombRand(10000) + 1
	local lottoBonusPrizeRoll = ZombRand(100) + 1


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
	player:Say(winningText)

	-- Roll for Bonus Prize	
	
	if lottoBonusPrizeRoll <= ((1 / lotteryTicketOdds) * 100) then
		local prizeCategory = ZombRand(10000) + 1
		local bonusPrize = nil

		if prizeCategory >= 9900 then
			bonusPrize = bonusPrizeRare[ZombRand(1, #bonusPrizeRare)]

		elseif (prizeCategory >= 8500 and prizeCategory < 9900) then
			bonusPrize = bonusPrizeHigh[ZombRand(1, #bonusPrizeHigh)]

		elseif (prizeCategory >= 5000 and prizeCategory < 8500) then
			bonusPrize = bonusPrizeMed[ZombRand(1, #bonusPrizeMed)]

		else
			bonusPrize = bonusPrizeLow[ZombRand(1, #bonusPrizeLow)]

		end

		if ScriptManager.instance:getItem(bonusPrize) == nil then
			print("Error: Item Not Found")
			return
		else
			local bonusItem = ScriptManager.instance:getItem(bonusPrize):getDisplayName()
			local bonusText = ("Bonus Prize!  You Won - " .. bonusItem)
		
			GivePlayerLottoTicketBonusPrize(bonusItem)
			player:getInventory():AddItem(bonusPrize)
			player:Say(bonusText)
		end		
	end		
end


function ScratchLottoTicketStandard(sources, result, player, item)
	if CheckForWinner(player) then				
		CalcLottoWinnings(player)
		PlayLottoWinnerSound()
	else			
		player:Say("Sorry, Ticket is Not a Winner..  Play Again!")
		PlayLottoLoserSound()
	end		
end

function TradeRareTicketForStandardTickets(sources, result, player)
	local t = 0

	while t ~= 5 do
		player:getInventory():AddItem("GN84-WND.LottoTicketStandard")
		t = t+1
	end
end

function TradeRareTicketForCashStack(sources, result, player)
	local t = 0

	while t ~= rareTicketCashValue do
		player:getInventory():AddItem("GN84-WND.MoneyStack1000")
		t = t+1
	end
end

local randomAmmoList =
{
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
}

function TradeRareTicketForRandomAmmo(sources, result, player)
	local randNum = ZombRand(1, #randomAmmoList + 1)

	if ScriptManager.instance:getItem(randomAmmoList[randNum]) == nil then
		print("Error: Item Not Found")
		return
	else
		player:getInventory():AddItem(randomAmmoList[randNum])
	end
end




------------------------------------------------------------------------
--                       WHEEL SPIN FRAGMENTS   
------------------------------------------------------------------------

local randomWheelSpinFragmentList =
{
	"GN84-WND.WheelSpinFragment1",
	"GN84-WND.WheelSpinFragment2",
	"GN84-WND.WheelSpinFragment3",
	"GN84-WND.WheelSpinFragment4",
	"GN84-WND.WheelSpinFragment5",
}

function GiveRandomWheelSpinFragment(sources, result, player)
	local randNum = ZombRand(1, #randomWheelSpinFragmentList + 1)
	
	if ScriptManager.instance:getItem(randomWheelSpinFragmentList[randNum]) == nil then
		print("Error: Item Not Found")
		return
	else
		player:getInventory():AddItem(randomWheelSpinFragmentList[randNum])
	end
end

function GiveFiveRandomWheelSpinFragments(sources, result, player)
	
	for i=0, 4, 1 do
		local randNum = ZombRand(1, #randomWheelSpinFragmentList + 1)
	
		if ScriptManager.instance:getItem(randomWheelSpinFragmentList[randNum]) == nil then
			print("Error: Item Not Found")
			return
		else
			player:getInventory():AddItem(randomWheelSpinFragmentList[randNum])
		end
	end
end




------------------------------------------------------------------------
--                 CUTTING UP WALLETS FOR LEATHER STRIPS 
------------------------------------------------------------------------

function CutLeatherWallet(items, result, player)
	
	local leatherOdds = 20
	local extraLeatherOdds = 10
	local maxExtraLeather = 1
	local leatherStrips = 0
	local bonusOdds = 0

	-- Check for Trait Bonuses
	if player:HasTrait("Lucky") then		
		bonusOdds = extraLeatherOdds + 3
	elseif player:HasTrait("Unlucky") then		
		bonusOdds = extraLeatherOdds - 3
	else		
		bonusOdds = extraLeatherOdds
	end

	
	local leatherRoll = ZombRand(100) + 1  -- Extra Leather Roll
	--print("Leather Roll?:  "  ..  leatherRoll)
		
	if (leatherRoll <= leatherOdds) then
		--print("Wallet Had Leather")
		leatherStrips = 1
	end	

	if (leatherRoll <= bonusOdds) then			
		leatherStrips = leatherStrips + ZombRand(0, maxExtraLeather)
		--print("Extra Leather: " .. leatherStrips)
	end

	local t = 0

	while t ~= leatherStrips do
		player:getInventory():AddItem("Base.LeatherStrips")
		t = t+1
	end
end


------------------------------------------------------------------------
--                     MONEY CLIP ITEM VALIDATION  
------------------------------------------------------------------------

function GN84_AcceptItemsMoneyClip(container, item)

	local moneyClipItems = 
	{
		"Base.Money",
		"GN84-WND.MoneyStack100",
		"GN84-WND.MoneyStack500",
		"GN84-WND.MoneyStack1000",
		"GN84-WND.MoneyStack5000",
		"GN84-WND.MoneyStack10000",
		"GN84-WND.MoneyStack50000",
		"GN84-WND.MoneyStack100000",
		"GN84-WND.MoneyStack500000",
		"GN84-WND.MoneyStack1000000",
		"GN84-WND.MoneyStack5000000",
		"GN84-WND.MoneyStack10000000",
		"GN84-WND.LottoTicketStandard",
		"GN84-WND.LottoTicketRare",
		"GN84-WND.LottoTicketGolden",
		"GN84-WND.WheelSpinToken",
		"GN84-WND.SuperWheelSpinToken",
		"GN84-WND.WheelSpinFragment1",
		"GN84-WND.WheelSpinFragment2",
		"GN84-WND.WheelSpinFragment3",
		"GN84-WND.WheelSpinFragment4",
		"GN84-WND.WheelSpinFragment5",
		"GN84-WND.WheelSpinTokenNew",
		"GN84-WND.SuperWheelSpinTokenNew",
		"GN84-WND.MegaWheelSpinToken",
		"GN84-WND.UltimateWheelSpinToken",
		"GN84-WND.WanderersRaffleTicket",
		"GN84-WND.WanderersVIPCoupon",
		"GN84-WND.VIPToken",
		"GN84-WND.VIPTokenNew",
		"GN84-WND.EventToken",
		"GN84-WND.WandererToken",
		"GN84-WND.WandererTokenStack5",
		"GN84-WND.WandererTokenStack10",
		"GN84-WND.WandererTokenStack25",
		"GN84-WND.WandererTokenStack50",
		"GN84-WND.WandererTokenStack100",
		"GN84-WND.WandererTokenStack250",
		"GN84-WND.WandererTokenStack500",
		"GN84-WND.WandererTokenStack1000",
		"GN84-WND.WandererTokenStack5000",
		"GN84-WND.SafehouseExpansionPermit5",
		"GN84-WND.SafehouseExpansionPermit10",
		"GN84-WND.SafehouseExpansionPermit50",
		"GN84-WND.SafehouseExpansionPermit100",
		"GN84-WND.SafehouseExpansionPermit250",
		"GN84-WND.SafehouseExpansionPermit500",
		"GN84-WND.SafehouseExpansionPermit1000",
		"GN84-WND.SafehouseExpansionPermit5000",
		"GN84-WND.AdditionalSafehousePermit",
		"GN84-WND.CommercialClaimPermit",
		"GN84-WND.ResidentialPermitSmall",
		"GN84-WND.ResidentialPermitLarge",
		"GN84-WND.ResidentialPermitMansion",
		"GN84-WND.FactionPermitSmall",
		"GN84-WND.FactionPermitLarge",
		"GN84-WND.FactionPermitMassive",
		"Base.AVCSClaimOrb",		
		"TheyKnew.Zomboxivir",
		"TheyKnew.Zomboxycycline",		
	}

	for i = 1, #moneyClipItems do
    	if item:getFullType() == moneyClipItems[i] then
			return true
		end
	end	
end



------------------------------------------------------------------------
--                      ADMIN DEBUGGING FUNCTIONS 
------------------------------------------------------------------------

------------------------------------------------------------------------
--                CHECK FOR FAVORITED OR EQUIPPED ITEMS
------------------------------------------------------------------------

function Recipe.OnTest.IsNotFavorited(item, result)
    return not item:isFavorite() and not item:isEquipped()
end