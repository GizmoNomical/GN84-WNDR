require "recipecode"

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


-- Searching Wallets for Money

function CollectMoneyFromWallet(items, result, player)
	
	local wealth = ZombRand(10)+1;
	local eFunds = ZombRand(10)+1;
	local i = 0;
	local e = 0;
	local ei = 0;
	local billChosen = 0;
	
	print ("-------------------------")
	print ("Wealth Roll         : ", wealth)
	print ("Emergency Funds Roll: ", eFunds)
	print ("-------------------------")

	-- High Roll - Emergency Funds
	if (eFunds >= 9)
	then
		billChosen = ZombRand(10)+1;
		print ("Zombie Had Emergency Funds")
		-- print ("Bill Roll: ", billChosen)
		
		if (billChosen == 10)
			then
				e = 200
				print ("Amount: ",e)
		end				
		if (billChosen == 9)
			then
				e = 100
				print ("Amount: ",e)
		end
		if (billChosen <= 2)
			then
				e = 50
				print ("Amount: ",e)
		end
		if (billChosen >2 and billChosen <9)
			then
				e = 20
				print ("Amount: ",e)
		end
	end
	print ("-------------------------")
	
	-- Normal Roll - 	
	-- if (wealth < 9)
	
	-- then
	-- Roll for Wealth Class of Zombie
				
		if (wealth >=7)
			then
				print ("Class: Wealthy")
				i = ZombRand(50)+1
				print ("Amount: ", i)
		end
		if (wealth < 2)
			then
				print ("Class: Poor")
				i = ZombRand(10)+1
				print ("Amount: ", i)
		end
		if (wealth >=2 and wealth <=6)
			then
				print ("Class: Average")
				i = ZombRand(20)+1
				print ("Amount: ", i)
		end
		print ("-------------------------")
		
	-- end
	
	local t = 0;
	ei = e + i;
	print ("Total: ", ei)

	print ("-------------------------")
	print ("-------------------------")
	
	while(t ~= ei) do
		player:getInventory():AddItem("Money");
		t = t+1
	end

end


-- Cutting up Wallets for Leather Strips

function CutLeatherWallet(items, result, player)
	local rand = ZombRand(10)+1;
	local amount = 0;
	
	-- print ("Extra Leather Roll: ", rand)
	
	
	if (rand >= 9)
	then
		-- Roll for Amount of Extra Strips
		amount = ZombRand(3);		
		-- print ("Extra Amount: ",amount)
		
	end
		
	local t = 0;

	while(t ~= amount) do
		player:getInventory():AddItem("LeatherStrips");
		t = t+1
	end
end