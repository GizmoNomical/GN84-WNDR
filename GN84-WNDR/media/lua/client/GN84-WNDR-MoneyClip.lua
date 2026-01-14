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
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################


local Utils = require "Gizmo/GN84LIB_Utils"



------------------------------------------------------------------------
--                     FORWARD FUNCTION DECLARATIONS     
------------------------------------------------------------------------

local BindMoneyClipToPlayer
local UnBindMoneyClip

local CreateBalanceItems
local RemoveBalanceItems

local ReceiveSmokeyBankData
local UpdateSmokeyBankData

local UpdateSmokeyPointBalance
local GetBankBalance
local SaveBankBalance

local UpdateWandererTokenBalance
local GetTokenBalance
local SaveTokenBalance

local GetAllMoneyClips
local UpdateAllMoneyClips
local UpdateBalanceItems
local UpdateMoneyClipDisplayData
local UpdateContainerButtonTooltip

local MoneyClipContext
local BankBalanceContext
local CashBalanceContext
local TokenBalanceContext

local ConsolidateAll
local ConsolidateAllOnTransfer
local ConsolidateCash
local _ConsolidateCash
local ConsolidateTokens
local _ConsolidateTokens

local CreateCashStack
local DepositCashBalance
local _DepositCashBalance
local GrabStackOfCashAll
local _GrabStackOfCashAll
local GrabStackOfCashAmount
local _GrabStackOfCashAmount

local CreateTokenStack
local WithdrawAllTokens
local _WithdrawAllTokens


local listOfMoneyStacks
local listOfTokenStacks

local currentUUID = nil
local lastUUID = nil




------------------------------------------------------------------------
--                          
--                          
--                        INITIALIZATION  
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                     BIND MONEY CLIP TO PLAYER
------------------------------------------------------------------------


BindMoneyClipToPlayer = function(target, player, item)
    if not item then return end
    local moneyClip = item

	local modData = moneyClip:getModData()
	if not modData then return end

	local username = player:getUsername()
    if not username then return end

    -- Set Default Values
	if not modData.Owner then
		modData.Owner = username
        -- modData.Owner = "TestUser"
		-- modData.AutoConsolidate = true
        modData.UUID = getRandomUUID()
        modData.BankBalance = 0
        modData.CashBalance = 0
        modData.TokenBalance = 0
	end

	-- Change Item Name to Reflect Bound Status
	local itemName = moneyClip:getName()
	if itemName == "Money Clip" then
		item:setName(username .. "'s Money Clip")
	end

    -- Favorite Item
	moneyClip:setFavorite(true)

    -- Play Notification Sound
    getSoundManager():PlaySound("BindMoneyClip", false, 1):setVolume(1)

    -- Announce Binding to Player
    player:Say("Money Clip Bound to Player")

    CreateBalanceItems(moneyClip)
end



------------------------------------------------------------------------
--                     UNBIND MONEY CLIP - (ADMIN)
------------------------------------------------------------------------


UnBindMoneyClip = function(target, player, item)
    if not item then return end
    local moneyClip = item

	local modData = moneyClip:getModData()
	if not modData then return end

    if (modData.CashBalance ~= nil) and (modData.CashBalance > 0) then
        CreateCashStack(moneyClip, modData.CashBalance)
    end

    moneyClip:setFavorite(false)
    RemoveBalanceItems(moneyClip)

	modData.Owner = nil
    modData.UUID = nil
	modData.BankBalance = nil
	modData.CashBalance = nil
	modData.TokenBalance = nil
end



------------------------------------------------------------------------
--                    CREATE BALANCE ITEMS
------------------------------------------------------------------------


CreateBalanceItems = function(moneyclip)
    if not moneyclip then return end

    -- Spawn Dummy Tooltip Items if not already Spawned
	local moneyClip = moneyclip:getItemContainer()
    local items = moneyClip:getItems()

    if not items then
        print("Error: Invalid Container")
        return
    else
        -- Instantiate Balance Items
        local BankItem = InventoryItemFactory.CreateItem("GN84-WNDR.BankBalance")
        local CashItem = InventoryItemFactory.CreateItem("GN84-WNDR.CashBalance")
        local TokenItem = InventoryItemFactory.CreateItem("GN84-WNDR.TokenBalance")

        if items:size() == 0 then
            -- Create New Balance Items
            moneyClip:AddItem(BankItem)
            moneyClip:AddItem(CashItem)
            moneyClip:AddItem(TokenItem)

            -- Set Balance Items to Favorite
            BankItem:setFavorite(true)
            CashItem:setFavorite(true)
            TokenItem:setFavorite(true)
            return

        elseif items:size() ~= 0 then
            local spawnBankItem  = true
            local spawnCashItem  = true
            local spawnTokenItem = true

            for i = items:size()-1, 0, -1 do
                local item = items:get(i)

                -- Check for Missing Items
                if item:getType() == "BankBalance" then
                    spawnBankItem = false
                elseif item:getType() == "CashBalance" then
                    spawnCashItem = false
                elseif item:getType() == "TokenBalance" then
                    spawnTokenItem = false
                end
            end

            if spawnBankItem or spawnCashItem or spawnTokenItem then
                
                -- Spawn Missing Items & Set to Favorite
                if spawnBankItem  then
                    moneyClip:AddItem(BankItem)
                    BankItem:setFavorite(true)
                end
                if spawnCashItem then
                    moneyClip:AddItem(CashItem)
                    CashItem:setFavorite(true)
                end
                if spawnTokenItem then
                    moneyClip:AddItem(TokenItem)
                    TokenItem:setFavorite(true)
                end
            end
        end
	end
end




------------------------------------------------------------------------
--                       REMOVE BALANCE ITEMS
------------------------------------------------------------------------


RemoveBalanceItems = function(moneyClip)
    if not moneyClip then return end

    local moneyClipContainer = moneyClip:getItemContainer()
    local items = moneyClipContainer:getItems()

    if not items then
        print("Warning: No Item List")
        return
    else

        if items:size() == 0 then
            return

        elseif items:size() ~= 0 then
            for i = items:size()-1, 0, -1 do
                local item = items:get(i)

                if item:getType() == "BankBalance" then
                    moneyClipContainer:DoRemoveItem(item)
                elseif item:getType() == "CashBalance" then
                    moneyClipContainer:DoRemoveItem(item)
                elseif item:getType() == "TokenBalance" then
                    moneyClipContainer:DoRemoveItem(item)
                end
            end
        end
	end
end








------------------------------------------------------------------------
--                          
--                          
--                      CURRENCY CONSOLIDATION    
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                        CASH CONSOLIDATION
------------------------------------------------------------------------


listOfMoneyStacks =
{
    Money                   =   {type = "Base.Money",                       value = 1,              },
    MoneyStack100           =   {type = "GN84-WNDR.MoneyStack100",          value = 100,            },
    MoneyStack500           =   {type = "GN84-WNDR.MoneyStack500",          value = 500,            },
    MoneyStack1000          =   {type = "GN84-WNDR.MoneyStack1000",         value = 1000,           },
    MoneyStack5000          =   {type = "GN84-WNDR.MoneyStack5000",         value = 5000,           },
    MoneyStack10000         =   {type = "GN84-WNDR.MoneyStack10000",        value = 10000,          },
    MoneyStack50000         =   {type = "GN84-WNDR.MoneyStack50000",        value = 50000,          },
    MoneyStack100000        =   {type = "GN84-WNDR.MoneyStack100000",       value = 100000,         },
    MoneyStack500000        =   {type = "GN84-WNDR.MoneyStack500000",       value = 500000,         },
    MoneyStack1000000       =   {type = "GN84-WNDR.MoneyStack1000000",      value = 1000000,        },
    MoneyStack5000000       =   {type = "GN84-WNDR.MoneyStack5000000",      value = 5000000,        },
    MoneyStack10000000      =   {type = "GN84-WNDR.MoneyStack10000000",     value = 10000000,       },
}


ConsolidateCash = function(item, playSound)
    if not item then return end
    local moneyClip = item

    local modData = moneyClip:getModData()
    if not modData then return end

    local moneyClipContainer = item:getItemContainer()
    local items = moneyClipContainer:getItems()
    if items == nil then return end

    local runningTotal = 0

        for i = items:size()-1, 0, -1 do
            local cashStack = items:get(i)

            if not cashStack:isFavorite() then

                -- Standard Cash Stacks
                for _moneyStack, _stats in pairs(listOfMoneyStacks) do
                    if cashStack:getType() == _moneyStack then
                        moneyClipContainer:DoRemoveItem(cashStack)
                        runningTotal = runningTotal + _stats.value
                    end
                end

                --Variable Cash Stacks
                if cashStack:getType() == "MoneyStackX" then
                    --print(item:getType())
                    local moneyStackX = cashStack:getModData()
                    local cashAmount = moneyStackX.CashAmount or 0

                    moneyClipContainer:DoRemoveItem(cashStack)
                    runningTotal = runningTotal + cashAmount

                end
            end
        end

        local cashBalance = modData.CashBalance or 0
        cashBalance = cashBalance + runningTotal
        modData.CashBalance = cashBalance

        UpdateMoneyClipDisplayData(moneyClip, true)

        if playSound then
            getSoundManager():PlaySound("CountingMoney", false, 1):setVolume(1)
        end
end




------------------------------------------------------------------------
--                    WANDERER TOKEN CONSOLIDATION
------------------------------------------------------------------------


listOfTokenStacks =
{
    WandererToken                       =   {type = "GN84-WNDR.WandererToken",                      value = 1,          },
    WandererTokenStack5                 =   {type = "GN84-WNDR.WandererTokenStack5",                value = 5,          },
    WandererTokenStack10                =   {type = "GN84-WNDR.WandererTokenStack10",               value = 10,         },
    WandererTokenStack25                =   {type = "GN84-WNDR.WandererTokenStack25",               value = 25,         },
    WandererTokenStack50                =   {type = "GN84-WNDR.WandererTokenStack50",               value = 50,         },
    WandererTokenStack100               =   {type = "GN84-WNDR.WandererTokenStack100",              value = 100,        },
    WandererTokenStack250               =   {type = "GN84-WNDR.WandererTokenStack250",              value = 250,        },
    WandererTokenStack500               =   {type = "GN84-WNDR.WandererTokenStack500",              value = 500,        },
    WandererTokenStack1000              =   {type = "GN84-WNDR.WandererTokenStack1000",             value = 1000,       },
    WandererTokenStack5000              =   {type = "GN84-WNDR.WandererTokenStack5000",             value = 5000,       },
}


ConsolidateTokens = function(item, playSound)
    if not item then return end
    local moneyClip = item

    local modData = moneyClip:getModData()
    if not modData then return end

    local moneyClipContainer = moneyClip:getItemContainer()
    local items = moneyClipContainer:getItems()
    if items == nil then return end

    local runningTotal = 0

        for i = items:size()-1, 0, -1 do
            local tokenStack = items:get(i)

            -- Standard Token Stacks
            for _tokenStack, _stats in pairs(listOfTokenStacks) do
                if tokenStack:getType() == _tokenStack then
                    moneyClipContainer:DoRemoveItem(tokenStack)
                    runningTotal = runningTotal + _stats.value
                end
            end

            --Variable Token Stacks
                if tokenStack:getType() == "WandererTokenStackX" then
                    local tokenStackX = tokenStack:getModData()
                    local tokenAmount = tokenStackX.TokenAmount or 0

                    moneyClipContainer:DoRemoveItem(tokenStack)
                    runningTotal = runningTotal + tokenAmount
                end
        end

        if runningTotal > 0 then
            sendClientCommand("GN84-WNDR", "depositTokens", {getPlayer():getUsername(), runningTotal})

            UpdateMoneyClipDisplayData(moneyClip, true)

            if playSound then
                getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1)
            end
        end
end



------------------------------------------------------------------------
--             DAILY CONSOLIDATION / MANUAL CONSOLIDATION     
------------------------------------------------------------------------


ConsolidateAll = function(moneyClip)
    ConsolidateCash(moneyClip, true)
    ConsolidateTokens(moneyClip, true)
    UpdateMoneyClipDisplayData(moneyClip, true)
end

------------------------------------------------------------------------
--                       ON-TRANSFER CONSOLIDATION   
------------------------------------------------------------------------


ConsolidateAllOnTransfer = function(moneyClip)
    ConsolidateCash(moneyClip, false)
    ConsolidateTokens(moneyClip, false)
    UpdateMoneyClipDisplayData(moneyClip, true)
end


------------------------------------------------------------------------
--                         PASSTHROUGH 
------------------------------------------------------------------------


local function _ConsolidateAll(item)
	ConsolidateAll(item)
    getPlayer():Say("Consolidating All Currency")
end




------------------------------------------------------------------------
--                          
--                          
--                     CONTEXT MENUS & FUNCTIONS    
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                          
--                          
--                           MONEY CLIP
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                     MONEY CLIP - CONTEXT MENU
------------------------------------------------------------------------


MoneyClipContext = function(playerNum, context, items)

	local player = getPlayer()
    if not player then return end

    items = ISInventoryPane.getActualItems(items)
    if not items then return end

	for _, item in ipairs(items) do
		if item:getType() == "MoneyClip" then
			if not item:isInPlayerInventory() then return end

			local moneyClip = item
            local modData = moneyClip:getModData()

            if not modData then return end

            UpdateSmokeyBankData()

			if modData.Owner == nil then
				context:addOptionOnTop("Bind Money Clip", items, BindMoneyClipToPlayer, player, item)

			elseif modData.Owner == player:getUsername() then
					context:addOptionOnTop("Consolidate All Currency", items, function() _ConsolidateAll(moneyClip) end, player, item)
			end

			-- Admin Un-Bind Option
			if player:getAccessLevel() == "Admin" then
				if modData.Owner ~= nil then
				    context:addOptionOnTop("Un-Bind Money Clip (Admin)", items, UnBindMoneyClip, player, item)
				end
			end
		end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(MoneyClipContext)




------------------------------------------------------------------------
--                          
--                          
--                            BANK BALANCE
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                       BANK BALANCE - CONTEXT MENU
------------------------------------------------------------------------


BankBalanceContext = function(playerNum, context, _items)

	local player = getPlayer()
    if not player then return end

    local items = ISInventoryPane.getActualItems(_items)
    if not items then return end

	for _, item in ipairs(items) do
		if item:getType() == "BankBalance" then
			if not item:isInPlayerInventory() then return end

            if not item:getContainer():getContainingItem() then return end

            local moneyClip = item:getContainer():getContainingItem()
            if moneyClip:getType() == "MoneyClip" then
                local modData = moneyClip:getModData()

                if modData == nil then return end
                UpdateSmokeyPointBalance(nil, true)

                if modData.Owner ~= player:getUsername() then player:Say("Error:  Unauthorized") return end
                if modData.CashBalance == nil then return end

                if modData.CashBalance > 0 then
                    -- local option = context:addOptionOnTop("Deposit Cash Balance into Smokey Bank", items, function () _DepositCashBalance(moneyClip) end, player, item)
                    -- option.notAvailable = false

                elseif modData.CashBalance == 0 then
                    -- local option = context:addOptionOnTop("Deposit Cash Balance into Smokey Bank", items, nil, player, item)
                    -- option.notAvailable = true

                end
            end
		end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(BankBalanceContext)



------------------------------------------------------------------------
--                          
--                          
--                            CASH BALANCE
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                     CASH BALANCE - CONTEXT MENU
------------------------------------------------------------------------


CashBalanceContext = function(playerNum, context, _items)

	local player = getSpecificPlayer(playerNum)
    if not player then return end

    local items = ISInventoryPane.getActualItems(_items)
    if not items then return end


	for _, item in ipairs(items) do
		if item:getType() == "CashBalance" then
			if not item:isInPlayerInventory() then return end

            if not item:getContainer():getContainingItem() then return end

            local moneyClip = item:getContainer():getContainingItem()
            if moneyClip:getType() == "MoneyClip" then

                local modData = moneyClip:getModData()
                if modData == nil then return end

                if modData.Owner ~= player:getUsername() then player:Say("Error:  Unauthorized") return end
                if modData.CashBalance == nil then modData.CashBalance = 0 end

                if modData.CashBalance > 0 then
                    local variableStack = context:addOptionOnTop("Grab a Stack of Cash (Amount)", items, function () _GrabStackOfCashAmount(moneyClip) end, player, item)
                    variableStack.notAvailable = true

                    local fullStack = context:addOptionOnTop("Grab a Stack of Cash (All)", items, function () _GrabStackOfCashAll(moneyClip) end, player, item)
                    fullStack.notAvailable = false

                    local depositBalance = context:addOptionOnTop("Deposit Cash Balance into Smokey Bank", items, function () _DepositCashBalance(moneyClip) end, player, item)
                    depositBalance.notAvailable = false

                elseif modData.CashBalance == 0 then
                    local option = context:addOptionOnTop("Grab a Stack of Cash", items, nil, player, item)
                    option.notAvailable = true

                    local depositBalance = context:addOptionOnTop("Deposit Cash Balance into Smokey Bank", items, nil, player, item)
                    depositBalance.notAvailable = true
                end

                local inv = moneyClip:getItemContainer():getItems()
                if not inv then return end
                if inv:size() == 0 then return end

                local hideConsolidate = true
                for i = inv:size()-1, 0, -1 do
                    local cashStack = inv:get(i)

                    if not cashStack:isFavorite() then

                        -- Standard Cash Stacks
                        for _moneyStack, _stats in pairs(listOfMoneyStacks) do
                            if (cashStack:getType() == _moneyStack) or (cashStack:getType() == "MoneyStackX") then
                                hideConsolidate = false
                            end
                        end
                    end
                end

                local consolidate = context:addOptionOnTop("Consolidate Loose Cash", items, function () _ConsolidateCash(moneyClip) end, player, item)
                consolidate.notAvailable = hideConsolidate
		    end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(CashBalanceContext)




------------------------------------------------------------------------
--                       CREATE MONEYSTACKX
------------------------------------------------------------------------


CreateCashStack = function(moneyClip, amount)
    if not moneyClip then return false end
    if not amount then return false end

    local modData = moneyClip:getModData()
    if not modData then return false end

    -- Instantiate MoneyStackX Item
    local moneyStackX = InventoryItemFactory.CreateItem("GN84-WNDR.MoneyStackX")
    moneyClip:getItemContainer():AddItem(moneyStackX)

    local moneyStackData = moneyStackX:getModData()
    if not moneyStackData then return false end

    -- Set Money Stack Amount in modData
    moneyStackData.CashAmount = amount

    -- Rename Money Stack to Reflect Cash Amount
    moneyStackX:setName(moneyStackX:getName() .. " - $" .. Utils.CurrencyFormatter(moneyStackData.CashAmount))
    moneyStackX:setFavorite(true)
    return true
end




------------------------------------------------------------------------
--                              DEPOSIT
------------------------------------------------------------------------


DepositCashBalance = function(item)
    if not item then return end

        local moneyClip = item

        if moneyClip:getType() == "MoneyClip" then

            local modData = moneyClip:getModData()
            if modData == nil then return end

            local player = getPlayer()            
            if not player then return end

            local username = player:getUsername()

            if modData.Owner == username then

                local amount = modData.CashBalance or 0
                if amount ~= 0 then
                    sendClientCommand("GN84-WNDR", "depositCash", {username, amount})
                    modData.CashBalance = 0
                    getSoundManager():PlaySound("ReceiptSound", false, 1):setVolume(1)
                    player:Say("Depositing $" .. Utils.CurrencyFormatter(amount) .. " into Smokey Bank")
                    UpdateMoneyClipDisplayData(moneyClip, true)
                end
            else
               player:Say("Error:  Unauthorized")
            end
        end
end

-- Passthrough Function
_DepositCashBalance = function(item)
	DepositCashBalance(item)
end



------------------------------------------------------------------------
--                       GRAB CASH STACK - ALL
------------------------------------------------------------------------


GrabStackOfCashAll = function(item)
        if not item then return end

        local moneyClip = item

        if moneyClip:getType() == "MoneyClip" then

            local modData = moneyClip:getModData()
            if modData == nil then return end
            if modData.Owner == nil then return end
            if modData.CashBalance == nil then return end

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()

            if modData.Owner == username then
                if CreateCashStack(moneyClip, modData.CashBalance) then
                    modData.CashBalance = 0
                    getSoundManager():PlaySound("CountingMoney", false, 1):setVolume(1)
                    UpdateMoneyClipDisplayData(moneyClip, true)
                else
                    print("Error: Grabbing Full Stack of Cash Failed!")
                end
            else
                player:Say("Error:  Unauthorized")
            end
        end
end



------------------------------------------------------------------------
--                     GRAB CASH STACK - AMOUNT
------------------------------------------------------------------------

-- TODO
GrabStackOfCashAmount = function(item)
    if not item then return end

    local moneyClip = item

    if moneyClip:getType() == "MoneyClip" then

        local modData = moneyClip:getModData()
        if modData == nil then return end
        if modData.Owner == nil then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if modData.Owner == username then
            if CreateCashStack(moneyClip, modData.CashBalance) then
                modData.CashBalance = 0
                getSoundManager():PlaySound("CountingMoney", false, 1):setVolume(1)
            else
                print("Error: Grabbing Stack of Cash (Amount) Failed!")
            end
        else
            player:Say("Error:  Unauthorized")
        end
    end
end


------------------------------------------------------------------------
--                      PASSTHROUGH FUNCTIONS    
------------------------------------------------------------------------


_GrabStackOfCashAll = function(item)
	GrabStackOfCashAll(item)
end

_GrabStackOfCashAmount = function(item)
	GrabStackOfCashAmount(item)
end

_ConsolidateCash = function(item)
    ConsolidateCash(item, true)
end





------------------------------------------------------------------------
--                          
--                          
--                          TOKEN BALANCE
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                    TOKEN BALANCE - CONTEXT MENU
------------------------------------------------------------------------


TokenBalanceContext = function(playerNum, context, _items)

	local player = getPlayer()
    if not player then return end

    local items = ISInventoryPane.getActualItems(_items)
    if not items then return end

	for _, item in ipairs(items) do
		if item:getType() == "TokenBalance" then
			if not item:isInPlayerInventory() then return end

            if not item:getContainer():getContainingItem() then return end

            local moneyClip = item:getContainer():getContainingItem()
            if moneyClip:getType() == "MoneyClip" then

                local modData = moneyClip:getModData()
                if not modData then return end

                UpdateWandererTokenBalance(nil, true)

                if modData.Owner ~= player:getUsername() then player:Say("Error:  Unauthorized") return end
                if modData.TokenBalance == nil then return end

                if modData.TokenBalance > 0 then
                    local variableStack = context:addOptionOnTop("Withdraw (Amount)", items, function () _GrabTokenStack(moneyClip) end, player, item)
                    variableStack.notAvailable = true

                    local fullStack = context:addOptionOnTop("Withdraw (All)", items, function () _WithdrawAllTokens(moneyClip) end, player, item)
                    fullStack.notAvailable = false

                elseif modData.TokenBalance == 0 then
                    local option = context:addOptionOnTop("Withdraw", items, nil, player, item)
                    option.notAvailable = true
                end

                local inv = moneyClip:getItemContainer():getItems()
                if not inv then return end
                if inv:size() == 0 then return end

                local hideConsolidate = true
                for i = inv:size()-1, 0, -1 do
                    local tokenStack = inv:get(i)

                    if not tokenStack:isFavorite() then

                        -- Standard Cash Stacks
                        for _tokenStack, _stats in pairs(listOfTokenStacks) do
                            if (tokenStack:getType() == _tokenStack) or (tokenStack:getType() == "WandererTokenStackX") then
                                hideConsolidate = false
                            end
                        end
                    end
                end

                local consolidate = context:addOptionOnTop("Deposit Wanderer Tokens into Smokey Bank", items, function () _ConsolidateTokens(moneyClip) end, player, item)
                consolidate.notAvailable = hideConsolidate
		    end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(TokenBalanceContext)




------------------------------------------------------------------------
--                     CREATE WANDERERTOKENSTACKX
------------------------------------------------------------------------


CreateTokenStack = function(moneyClip, amount)
    if not moneyClip then return false end
    if not amount then return false end

    local modData = moneyClip:getModData()
    if not modData then return false end

    -- Instantiate MoneyStackX Item
    local tokenStackX = InventoryItemFactory.CreateItem("GN84-WNDR.WandererTokenStackX")
    moneyClip:getItemContainer():AddItem(tokenStackX)

    local tokenStackXData = tokenStackX:getModData()
    if not tokenStackXData then return false end

    -- Set Money Stack Amount in modData
    tokenStackXData.TokenAmount = amount

    -- Rename Money Stack to Reflect Cash Amount
    tokenStackX:setName(tokenStackX:getName() .. " -  " .. Utils.CurrencyFormatter(tokenStackXData.TokenAmount))
    tokenStackX:setFavorite(true)
    return true
end



------------------------------------------------------------------------
--                      WITHDRAW TOKENS - ALL
------------------------------------------------------------------------


WithdrawAllTokens = function(item)
        if not item then return end

        local moneyClip = item

        if moneyClip:getType() == "MoneyClip" then

            local modData = moneyClip:getModData()
            if not modData then return end

            if modData.Owner == nil then return end
            if modData.TokenBalance == nil then return end

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()

            if modData.Owner == username then
                if CreateTokenStack(moneyClip, modData.TokenBalance) then
                    sendClientCommand("GN84-WNDR", "withdrawTokens", {username, modData.TokenBalance})
                    getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1)
                    UpdateWandererTokenBalance(nil, true)
                else
                    print("Error: Withdraw (All) Wanderer Tokens Failed!")
                end
            else
                getPlayer():Say("Error:  Unauthorized")
            end
        end
end


------------------------------------------------------------------------
--                          PASSTHROUGH
------------------------------------------------------------------------


_WithdrawAllTokens = function(item)
	WithdrawAllTokens(item)
end

_ConsolidateTokens = function(item)
    ConsolidateTokens(item, true)
end





------------------------------------------------------------------------
--                          
--                          
--                      MONEY CLIP DATA UPDATE    
--                          
--                          
------------------------------------------------------------------------



------------------------------------------------------------------------
--                GET ALL MONEY CLIPS FROM INVENTORY
------------------------------------------------------------------------


GetAllMoneyClips = function()
    local player = getPlayer()
    if not player then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local items = inventory:getItems()
    if not items then return end
    if items:size() == 0 then return end

    local MoneyClips = {}

    for i = items:size()-1, 0, -1 do
        local item = items:get(i)

        if item:getType() == "MoneyClip" then
            table.insert(MoneyClips, item)
        end
    end

    return MoneyClips
end




------------------------------------------------------------------------
--                     UPDATE ALL MONEY CLIPS     
------------------------------------------------------------------------


UpdateAllMoneyClips = function()

    local MoneyClips = GetAllMoneyClips()
    if not MoneyClips then return end

    for k, v in pairs(MoneyClips) do
        local modData = v:getModData()
        if not modData then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if modData.Owner ~= nil then
            if modData.Owner == username then
            CreateBalanceItems(v)
            UpdateMoneyClipDisplayData(v, true)
            end
        end
    end
end



------------------------------------------------------------------------
--                     UPDATE ALL BALANCE ITEMS
------------------------------------------------------------------------


UpdateBalanceItems = function(item)
    if not item then return end
    local moneyClip = item

    local modData = moneyClip:getModData()
    if not modData then return end

    local moneyClipContainer = moneyClip:getItemContainer()
    local items = moneyClipContainer:getItems()

    if not items then
        print("Error: Invalid Container")
        return
    else

        if items:size() == 0 then return

        elseif items:size() ~= 0 then

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()
            local isOwner = nil

            if (modData.Owner) then
                if modData.Owner ~= username then
                    isOwner = false
                elseif modData.Owner == username then
                    isOwner = true
                end
            end

            local BankBalance  = nil
            local CashBalance  = nil
            local TokenBalance = nil

            for i = items:size()-1, 0, -1 do
                local infoItem = items:get(i)

                BankBalance = modData.BankBalance
                CashBalance = modData.CashBalance
                TokenBalance = modData.TokenBalance

                if infoItem:getType() == "BankBalance" then
                    if BankBalance == nil then
                        infoItem:setName("-----[   Bank Balance:     ... ... ...")
                    elseif isOwner == false then
                        infoItem:setName("-----[   Bank Balance:     ... ... ...")
                    elseif isOwner == true then
                        infoItem:setName("-----[   Bank Balance:     $" ..  Utils.CurrencyFormatter(BankBalance))
                    end

                elseif infoItem:getType() == "CashBalance" then
                    if CashBalance == nil then
                        infoItem:setName("-----[   Cash Balance:     ... ... ...")
                    elseif isOwner == false then
                        infoItem:setName("-----[   Cash Balance:     ... ... ...")
                    elseif isOwner == true then
                        infoItem:setName("-----[   Cash Balance:     $" ..  Utils.CurrencyFormatter(CashBalance))
                    end

                elseif infoItem:getType() == "TokenBalance" then
                    if TokenBalance == nil then
                        infoItem:setName("-----[   Token Balance:    ... ... ...")
                    elseif isOwner == false then
                        infoItem:setName("-----[   Token Balance:    ... ... ...")
                    elseif isOwner == true then
                        infoItem:setName("-----[   Token Balance:    " ..  Utils.CurrencyFormatter(TokenBalance))
                    end
                end
            end
        end
    end
end



------------------------------------------------------------------------
--                 UPDATE MONEY CLIP DISPLAY DATA
------------------------------------------------------------------------


UpdateMoneyClipDisplayData = function(moneyClip, override)
    if not moneyClip then return end

    UpdateBalanceItems(moneyClip)

    local inventoryPage = getPlayerInventory(0).inventoryPane.inventoryPage
    if not inventoryPage then return end
    UpdateContainerButtonTooltip(inventoryPage, "end")
end





------------------------------------------------------------------------
--                          
--                          
--                     SMOKEY BANK DATA UPDATE     
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                   BANK BALANCE - SMOKEY POINTS
------------------------------------------------------------------------


UpdateSmokeyPointBalance = function(item, override)

    if override then
        sendClientCommand("GN84-WNDR", "get", nil)
    end
end

Events.OnServerCommand.Add(GetBankBalance)



GetBankBalance = function(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if module == "GN84-WNDR" and command == "get" then
        if arguments then
            SaveBankBalance(arguments[1])
        end
    end
end



SaveBankBalance = function(balance)
    if not balance then return end

    local MoneyClips = GetAllMoneyClips()
    if not MoneyClips then return end

    for k, v in pairs(MoneyClips) do
        local modData = v:getModData()
        if not modData then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if modData.Owner ~= nil then
            if modData.Owner == username then
                modData.BankBalance = balance
                UpdateMoneyClipDisplayData(v, true)
            end
        end
    end
end





------------------------------------------------------------------------
--                  BANK BALANCE - WANDERER TOKENS
------------------------------------------------------------------------


UpdateWandererTokenBalance = function(item, override)

    if override then
        sendClientCommand("GN84-WNDR", "getTokens", nil)
    end
end

Events.OnServerCommand.Add(GetTokenBalance)



GetTokenBalance = function(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if module == "GN84-WNDR" and command == "getTokens" then
        if arguments then
            SaveTokenBalance(arguments[1])
        end
    end
end



SaveTokenBalance = function(balance)
    if not balance then return end

    local MoneyClips = GetAllMoneyClips()
    if not MoneyClips then return end

    for k, v in pairs(MoneyClips) do
        local modData = v:getModData()
        if not modData then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if modData.Owner ~= nil then
            if modData.Owner == username then
                modData.TokenBalance = balance
                UpdateMoneyClipDisplayData(v, true)
            end
        end
    end
end





------------------------------------------------------------------------
--                  RECEIVE / REQUEST SMOKEY BANK DATA
------------------------------------------------------------------------

ReceiveSmokeyBankData = function(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if module == "GN84-WNDR" and command == "UpdateSmokeyBankData" then
        UpdateSmokeyBankData()
    end
end

Events.OnServerCommand.Add(ReceiveSmokeyBankData)



UpdateSmokeyBankData = function()
    UpdateSmokeyPointBalance(nil, true)
    UpdateWandererTokenBalance(nil, true)
    UpdateAllMoneyClips()
end




------------------------------------------------------------------------
--                          
--                          
--                        SYSTEM FUNCTIONS  
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                       SERVER REQUEST TIMER
------------------------------------------------------------------------

-- local function ReCheckDataTimer()
--     if recheckTimer == false then
--         recheckTimer = true
--     end
--     --ReceiveSmokeyBankData()
-- end

-- Events.EveryOneMinute.Add(ReCheckDataTimer)




------------------------------------------------------------------------
--                  AUTO-CONSOLIDATE - ON TRANSFER
------------------------------------------------------------------------


local oldTransferPerform = ISInventoryTransferAction.perform

function ISInventoryTransferAction:perform()
    local moneyClip = nil

    if self.destContainer and self.destContainer:getType() == "MoneyClip" then
        moneyClip = self.destContainer:getContainingItem()
    end

    oldTransferPerform(self)

    if not moneyClip then return end

    -- Run once all items are transferred
    if #self.queueList == 0 then
        ConsolidateAllOnTransfer(moneyClip)
    end
end



------------------------------------------------------------------------
--                  AUTO-CONSOLIDATE - DAILY @12AM
------------------------------------------------------------------------


local function DailyAutoConsolidate()

    local MoneyClips = GetAllMoneyClips()
    if not MoneyClips then return end

    local player = getPlayer()
    player:Say("Consolidating All Currency")

    for k, v in pairs(MoneyClips) do

        if v:getModData().Owner ~= nil then
            ConsolidateAll(v)
        end
    end
end

Events.EveryDays.Add(DailyAutoConsolidate)



------------------------------------------------------------------------
--    PREVENT UNAUTHORIZED ACCESS OF ITEMS / MOVING OF BALANCE ITEMS
------------------------------------------------------------------------


local oldTransferIsValid = ISInventoryTransferAction.isValid

function ISInventoryTransferAction:isValid()
    if not self.item then return false end

    local item = self.item


    -- Limit Movement of Balance Items by Non Admins
        if item:getType() == "BankBalance" or item:getType() == "CashBalance" or item:getType() == "TokenBalance" then
            if getAccessLevel() == "admin" then
                return true
            else
                return false
            end
        end

    -- Limit Manipulation of Items from Unauthorized Players
    if item:getContainer() and item:getContainer():getContainingItem() and item:getContainer():getContainingItem():getType() == "MoneyClip" then
        local moneyClip = item:getContainer():getContainingItem()

        local modData = moneyClip:getModData()
        if not modData then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if username ~= modData.Owner then
            if getAccessLevel() == "admin" then
                return true
            else
                player:Say("Error:  Unauthorized")
                return false
            end
        elseif username == modData.Owner then
            return true
        end
    end

    -- Run Original Function After Custom Checks
    return oldTransferIsValid(self)
end





------------------------------------------------------------------------
--                          
--                          
--                         INVENTORY TOOLTIPS 
--                          
--                          
------------------------------------------------------------------------

------------------------------------------------------------------------
--                     CONTAINER BUTTON TOOLTIP
------------------------------------------------------------------------


UpdateContainerButtonTooltip = function(inventoryPage, state)
    if not inventoryPage then return end
    if not state then return end

    if state ~= "end" then return end
    if not inventoryPage.onCharacter then return end

    local containers = inventoryPage.backpacks
    if not containers then return end

    for i,v in ipairs(containers) do
        local container = v.inventory
        if container:getType() == "MoneyClip" then

            local modData = container:getContainingItem():getModData()
            if not modData then return end

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()

            if modData.Owner ~= username then return end

            local smokeyPointBalance = modData.BankBalance
            local cashBalance = modData.CashBalance
            local wandererTokenBalance = modData.TokenBalance

            if type(smokeyPointBalance) == "number" then
                smokeyPointBalance = Utils.CurrencyFormatter(smokeyPointBalance)
            else
                smokeyPointBalance = "... ... ..."
            end

            if type(cashBalance) == "number" then
                cashBalance = Utils.CurrencyFormatter(cashBalance)
            else
                cashBalance = "... ... ..."
            end

            if type(wandererTokenBalance) == "number" then
                wandererTokenBalance = Utils.CurrencyFormatter(wandererTokenBalance)
            else
                wandererTokenBalance = "... ... ..."
            end

            v.tooltip = nil
            ISInventoryPage.renderDirty = true
            ISInventoryPage.dirtyUI()

            local balanceText = "<H2><LINE><LINE> <RGB:1.0,0.6,0.11,1>Bank Balance:  $" .. smokeyPointBalance .. "<LINE><RGB:0.17255,1.0,0.01961,1>Cash Balance:  $" .. cashBalance .. "<LINE><RGB:0.0,0.886,1.0,1>Token Balance:   " .. wandererTokenBalance

            local newTooltip = v.tooltip .. balanceText
            v.tooltip = newTooltip
        end
    end
end

Events.OnRefreshInventoryWindowContainers.Add(UpdateContainerButtonTooltip)



------------------------------------------------------------------------
--                       MONEY CLIP TOOLTIP
------------------------------------------------------------------------

local oldRender = ISToolTipInv.render

function ISToolTipInv:render()

    local itemType = self.item:getType()
    if not itemType == "MoneyClip" then return oldRender(self) end

    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then

        -- Call the original render function first to draw the original tooltip content
        oldRender(self)


        local moneyClip = self.item
        local modData = moneyClip:getModData()

        if not modData then return end
        if modData.Owner == nil then return end
        if modData.UUID == nil then return end

        -- Check if Money Clip UUID is Different & Update
        if lastUUID ~= currentUUID then
            UpdateMoneyClipDisplayData(moneyClip, true)
            currentUUID = modData.UUID
            lastUUID = currentUUID
        end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()
        local blankString = " "


        -- Information Display Strings
        local moneyClipOwner        = modData.Owner or blankString
        local smokeyPointBalance    = modData.BankBalance or 0
        local cashBalance           = modData.CashBalance or 0
        local wandererTokenBalance  = modData.TokenBalance or 0



        ------------------------------------------------------------------------
        --                          RENDERING
        ------------------------------------------------------------------------

        -- Define Fonts
        local fontType = UIFont.Medium
        local fontHeight = getTextManager():getFontHeight(fontType)

        -- Measure the text width and the tooltip's width

        local moneyClipOwnerTextWidth       = getTextManager():MeasureStringX(fontType, "Owner:  " .. moneyClipOwner)
        local smokeyPointBalanceTextWidth   = getTextManager():MeasureStringX(fontType, "Bank Balance:  $" .. Utils.CurrencyFormatter(smokeyPointBalance))
        local cashBalanceTextWidth          = getTextManager():MeasureStringX(fontType, "Cash Balance:  $" .. Utils.CurrencyFormatter(cashBalance))
        local wandererTokenBalanceTextWidth = getTextManager():MeasureStringX(fontType, "Token Balance:   " .. Utils.CurrencyFormatter(wandererTokenBalance))

        -- Tooltip Widths
        local tooltipWidth = self:getWidth()
        local longestToolTip = math.max(moneyClipOwnerTextWidth, smokeyPointBalanceTextWidth, cashBalanceTextWidth, wandererTokenBalanceTextWidth)
        local startX = (tooltipWidth) + 10

        -- Render Tooltip
        if moneyClipOwner and (moneyClipOwner == username) then
            self:drawRect(tooltipWidth, 0, longestToolTip + 40, fontHeight * 3.5, 1, 0, 0, 0)
            self:drawRectBorder(tooltipWidth, 0, longestToolTip + 40, (fontHeight * 3.5) + 4, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
            self.tooltip:DrawText(fontType, "Bank Balance:  $" .. Utils.CurrencyFormatter(smokeyPointBalance), startX, 12, 1.0, 0.6, 0.11, 1)
            self.tooltip:DrawText(fontType, "Cash Balance:  $" .. Utils.CurrencyFormatter(cashBalance), startX, 28, 0.17255, 1.0, 0.01961, 1)
            self.tooltip:DrawText(fontType, "Token Balance:   " .. Utils.CurrencyFormatter(wandererTokenBalance), startX, 44, 0.0, 0.886, 1.0, 1)

        elseif moneyClipOwner and (moneyClipOwner ~= username) then
            -- if (getAccessLevel() == "admin") then
            --     self:drawRect(tooltipWidth, 0, moneyClipOwnerTextWidth + 60, fontHeight * 1.5, 1, 0, 0, 0)
            --     self:drawRectBorder(tooltipWidth, 0, moneyClipOwnerTextWidth + 60, (fontHeight * 1.5) + 4, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
            --     self.tooltip:DrawText(fontType, "Bound To:  " .. moneyClipOwner, startX, 6, 1.0, 0.6, 0.11, 1)
            -- end
        end
    end
end


------------------------------------------------------------------------
--                          
--                          
--                        CUSTOM UI FUNCTIONS
--                          
--                          
------------------------------------------------------------------------


