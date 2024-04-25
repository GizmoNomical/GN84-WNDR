require "recipecode"

local pointsPerZombieKill = 6  		-- Smokey Points per Zombie Kill
local eFundsOdds = 90          		-- Must roll >= to this number to get eFunds
local walletCashMultiplier = 1.0	-- Adjust total Wallet Cash
local eFundCashMultiplier = 1.0		-- Adjust total eFund Cash
local wealthyCash = 20				-- Max cash found in Wealthy Zombie Wallet
local averageCash = 10				-- Max cash found in Average Zombie Wallet
local poorCash = 5					-- Max cash found in Poor Zombie Wallet


-- Adding Smokey Points

function GivePlayerSmokeyPoints100()
	sendClientCommand("ServerPoints", "add", {getPlayer():getUsername(), 100})
end

function GivePlayerSmokeyPoints1000()
	sendClientCommand("ServerPoints", "add", {getPlayer():getUsername(), 1000})
end

function GivePlayerSmokeyPoints10000()
	sendClientCommand("ServerPoints", "add", {getPlayer():getUsername(), 10000})
end

-- Add Smokey Points on Zombie Kill
-- ------------------------------- --

function SmokeyPointsOnZombieKill(zombie)	
	local lastAttacker = zombie:getAttackedBy()
	local isoPlayer = getPlayer()

	if isoPlayer == lastAttacker then
		sendClientCommand("ServerPoints", "add", {getPlayer():getUsername(), pointsPerZombieKill})		
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

	if (eFunds >= eFundsOdds)  -- Check if Zombie had EFunds
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