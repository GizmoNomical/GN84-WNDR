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

local GNStamp = "media/ui/GizmoNomical.png"

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
local WithdrawCashAmountFromBank
local WithdrawAllCashFromBank
local _WithdrawAllCashFromBank

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
local ConsolidateAllDaily
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
local WithdrawTokenAmountFromBank
local WithdrawAllTokensFromBank
local _WithdrawAllTokensFromBank


local listOfMoneyStacks
local listOfTokenStacks

local currentUUID = nil
local lastUUID = nil

local withdrawCashFromBankUI
local withdrawTokensFromBankUI




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
        modData.UUID = getRandomUUID()
		modData.AutoConsolidateOnTransfer = true
        modData.AutoConsolidateDaily = true
        modData.ConsolidateCash = true
        modData.ConsolidateTokens = true
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
    getSoundManager():PlaySound("BindMoneyClip", false, 1):setVolume(0.8)

    -- Announce Binding to Player
    player:Say("Money Clip Bound to Player Account")

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
    modData.AutoConsolidateOnTransfer = nil
    modData.AutoConsolidateDaily = nil
    modData.ConsolidateCash = nil
    modData.ConsolidateTokens = nil
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
                    item:setFavorite(true)
                elseif item:getType() == "CashBalance" then
                    spawnCashItem = false
                    item:setFavorite(true)
                elseif item:getType() == "TokenBalance" then
                    spawnTokenItem = false
                    item:setFavorite(true)
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


ConsolidateCash = function(item, playSound, override)
    if not item then return end
    local moneyClip = item

    local modData = moneyClip:getModData()
    if not modData then return end
    
    if override or modData.ConsolidateCash then
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


ConsolidateTokens = function(item, playSound, override)
    if not item then return end
    local moneyClip = item

    local modData = moneyClip:getModData()
    if not modData then return end

    if override or modData.ConsolidateTokens then
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
end





------------------------------------------------------------------------
--                        MANUAL CONSOLIDATION
------------------------------------------------------------------------


ConsolidateAll = function(moneyClip)
    if not moneyClip then return end

    local modData = moneyClip:getModData()
    if not modData then return end
    if not modData.Owner then return end

    local player = getPlayer()
    if not player then return end

    local username = player:getUsername()

    if modData.Owner == username then
        ConsolidateCash(moneyClip, true)
        ConsolidateTokens(moneyClip, true)        
    end    
    UpdateMoneyClipDisplayData(moneyClip, true)
end



------------------------------------------------------------------------
--                       DAILY CONSOLIDATION
------------------------------------------------------------------------


ConsolidateAllDaily = function(moneyClip)
    if not moneyClip then return end

    local modData = moneyClip:getModData()
    if not modData then return end
    if not modData.Owner then return end

    local player = getPlayer()
    if not player then return end

    local username = player:getUsername()

    if modData.Owner == username then
        if modData.AutoConsolidateDaily then
            ConsolidateCash(moneyClip, true)
            ConsolidateTokens(moneyClip, true)
        end
        UpdateMoneyClipDisplayData(moneyClip, true)
    end    
end



------------------------------------------------------------------------
--                       ON-TRANSFER CONSOLIDATION
------------------------------------------------------------------------


ConsolidateAllOnTransfer = function(moneyClip)
    if not moneyClip then return end

    local modData = moneyClip:getModData()
    if not modData then return end
    if not modData.Owner then return end

    local player = getPlayer()
    if not player then return end

    local username = player:getUsername()

    if modData.Owner == username then
        if modData.AutoConsolidateOnTransfer then
            ConsolidateCash(moneyClip, false)
            ConsolidateTokens(moneyClip, false)
        end
        UpdateMoneyClipDisplayData(moneyClip, true)
    end    
end



------------------------------------------------------------------------
--                         PASSTHROUGH
------------------------------------------------------------------------


local function _ConsolidateAll(item)
	ConsolidateAll(item)
    getPlayer():Say("Refreshing Money Clip")
end


------------------------------------------------------------------------
--                     CONSOLIDATION TOGGLES     
------------------------------------------------------------------------


local function _ToggleDailyConsolidate(item)
    if not item then return end

    local modData = item:getModData()
    if not modData then return end

    modData.AutoConsolidateDaily = not modData.AutoConsolidateDaily
end


local function _ToggleOnTransferConsolidate(item)
    if not item then return end

    local modData = item:getModData()
    if not modData then return end

    modData.AutoConsolidateOnTransfer = not modData.AutoConsolidateOnTransfer
end


local function _ToggleConsolidateCash(item)
    if not item then return end

    local modData = item:getModData()
    if not modData then return end

    modData.ConsolidateCash = not modData.ConsolidateCash
end

local function _ToggleConsolidateTokens(item)
    if not item then return end

    local modData = item:getModData()
    if not modData then return end

    modData.ConsolidateTokens = not modData.ConsolidateTokens
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
				local bindMoneyClip = context:addOptionOnTop("Bind Money Clip", items, BindMoneyClipToPlayer, player, item)
                local toolTip = ISWorldObjectContextMenu.addToolTip()
                toolTip.description = getText("Bind this Money Clip to your Player Account.\n\nPrevents Unauthorized Access\nProvides Quick Access to Smokey Bank")
                bindMoneyClip.toolTip = toolTip

			elseif modData.Owner == player:getUsername() then   

                local refreshMoneyClip = context:addOptionOnTop("Refresh Money Clip", items, function() _ConsolidateAll(moneyClip) end, player, item)
                local toolTip = ISWorldObjectContextMenu.addToolTip()
                toolTip.description = getText("Consolidate All Non-Favorited Currency within your Money Clip\n\nRefreshes Money Clip Data")
                refreshMoneyClip.toolTip = toolTip


                -- SUBMENU
				local option = context:insertOptionAfter("Refresh Money Clip", "Settings:", worldobjects, nil)
                option.iconTexture = getTexture(GNStamp)
                
                local subMenu = context:getNew(context)
                context:addSubMenu(option, subMenu)

                if modData.AutoConsolidateDaily then
                    local dailyConsolidate = subMenu:addOptionOnTop("Toggle Currency Auto-Consolidation (Daily)", items, function() _ToggleDailyConsolidate(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Disable Daily Auto-Consolidation")
                    dailyConsolidate.toolTip = toolTip
                    dailyConsolidate.iconTexture = getTexture(GNStamp)

                elseif not modData.AutoConsolidateDaily then
                    local dailyConsolidate = subMenu:addOptionOnTop("Toggle Currency Auto-Consolidation (Daily)", items, function() _ToggleDailyConsolidate(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Enable Daily Auto-Consolidation of Non-Favorited Currency within your Money Clip\n\nScheduled: 12am Daily In-Game")
                    dailyConsolidate.toolTip = toolTip
                end

                if modData.AutoConsolidateOnTransfer then
                    local onTransferConsolidate = subMenu:addOptionOnTop("Toggle Currency Auto-Consolidation (On-Transfer)", items, function() _ToggleOnTransferConsolidate(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Disable On-Transfer Auto-Consolidation")
                    onTransferConsolidate.toolTip = toolTip
                    onTransferConsolidate.iconTexture = getTexture(GNStamp)
                elseif not modData.AutoConsolidateOnTransfer then
                    local onTransferConsolidate = subMenu:addOptionOnTop("Toggle Currency Auto-Consolidation (On-Transfer)", items, function() _ToggleOnTransferConsolidate(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Enable On-Transfer Auto-Consolidation of Non-Favorited Currency within your Money Clip")
                    onTransferConsolidate.toolTip = toolTip
                end               

                if modData.ConsolidateTokens then
                    local consolidateTokens = subMenu:addOptionOnTop("Toggle Wanderer Token Consolidation", items, function() _ToggleConsolidateTokens(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Disable Consolidation of Non-Favorited Wanderer Tokens within your Money Clip")
                    consolidateTokens.toolTip = toolTip
                    consolidateTokens.iconTexture = getTexture(GNStamp)
                elseif not modData.ConsolidateTokens then
                    local consolidateTokens = subMenu:addOptionOnTop("Toggle Wanderer Token Consolidation", items, function() _ToggleConsolidateTokens(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Enable Consolidation of Non-Favorited Wanderer Tokens within your Money Clip")
                    consolidateTokens.toolTip = toolTip
                end

                if modData.ConsolidateCash then
                    local consolidateCash = subMenu:addOptionOnTop("Toggle Cash Consolidation", items, function() _ToggleConsolidateCash(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Disable Consolidation of Non-Favorited Cash within your Money Clip")
                    consolidateCash.toolTip = toolTip
                    consolidateCash.iconTexture = getTexture(GNStamp)
                elseif not modData.ConsolidateCash then
                    local consolidateCash = subMenu:addOptionOnTop("Toggle Cash Consolidation", items, function() _ToggleConsolidateCash(moneyClip) end, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Enable Consolidation of Non-Favorited Cash within your Money Clip")
                    consolidateCash.toolTip = toolTip
                end

			end

			-- Admin Un-Bind Option
			if player:getAccessLevel() == "Admin" then
				if modData.Owner ~= nil then
				    local unBindMoneyClip = context:addOptionOnTop("Un-Bind Money Clip (Admin)", items, UnBindMoneyClip, player, item)
                    local toolTip = ISWorldObjectContextMenu.addToolTip()
                    toolTip.description = getText("Un-Bind Money Clip from Player Account (Admin)\n\nNote: Any remaining Cash Balance will be converted to a Stack of Cash")
                    unBindMoneyClip.toolTip = toolTip
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
                UpdateSmokeyPointBalance()

                if modData.Owner ~= player:getUsername() then player:Say("Error:  Unauthorized") return end
                if not modData.BankBalance then return end

                if modData.BankBalance > 0 then

                    local option = context:addOptionOnTop("Withdraw (Amount)", items, function () _WithdrawCashFromBankUI(moneyClip) end, player, item)
                    option.notAvailable = false
                    local option = context:addOptionOnTop("Withdraw (All)", items, function () _WithdrawAllCashFromBank(moneyClip) end, player, item)
                    option.notAvailable = false

                elseif modData.BankBalance == 0 then
                    local option = context:addOptionOnTop("Withdraw)", items, nil, player, item)
                    option.notAvailable = true
                end
            end
		end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(BankBalanceContext)


------------------------------------------------------------------------
--                  WITHDRAW FROM BANK UI TOGGLE
------------------------------------------------------------------------

_WithdrawCashFromBankUI = function(moneyClip)
    if not moneyClip then return end

    local modData = moneyClip:getModData()
    if not modData then return end
    if not modData.BankBalance then return end

    local player = getPlayer()
    if not player then return end

    local username = player:getUsername()

    if modData.Owner == username then
        if modData.BankBalance > 0 then
            if withdrawCashFromBankUI == nil then
                local width = 200
                local height = 200

                withdrawCashFromBankUI = WithdrawCashFromBankUI:new((getCore():getScreenWidth() / 2) - (width / 2), (getCore():getScreenHeight() / 2) - (height / 2), width, height, modData.BankBalance, moneyClip)
                withdrawCashFromBankUI:initialise()
                withdrawCashFromBankUI:addToUIManager()
            end
        end
    end
end



------------------------------------------------------------------------
--                       PASSTHROUGH   
------------------------------------------------------------------------


_WithdrawAllCashFromBank = function(moneyClip)
    WithdrawAllCashFromBank(moneyClip)
end



------------------------------------------------------------------------
--                  WITHDRAW ALL CASH FROM SMOKEY BANK
------------------------------------------------------------------------


WithdrawAllCashFromBank = function(item)
    if not item then return end

    local moneyClip = item

    if moneyClip:getType() == "MoneyClip" then

        local modData = moneyClip:getModData()
        if not modData then return end
        if not modData.Owner then return end
        if not modData.BankBalance then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if modData.Owner == username then
            if modData.BankBalance > 0 then
                if CreateCashStack(moneyClip, modData.BankBalance) then
                    sendClientCommand("GN84-WNDR", "withdrawCash", {username, modData.BankBalance})
                    getSoundManager():PlaySound("ReceiptSound", false, 1):setVolume(1)
                    UpdateSmokeyPointBalance()
                else
                    print("Error: Withdraw (All) Smokey Points Failed!")
                end
            end
        else
            getPlayer():Say("Error:  Unauthorized")
        end
    end
end


------------------------------------------------------------------------
--                 WITHDRAW CASH AMOUNT FROM SMOKEY BANK
------------------------------------------------------------------------


WithdrawCashAmountFromBank = function(item, amount)
    if not item then return end
    if not amount then return end

    local moneyClip = item

    if moneyClip:getType() == "MoneyClip" then

        local modData = moneyClip:getModData()
        if not modData then return end
        if not modData.Owner then return end
        if not modData.BankBalance then return end

        local player = getPlayer()
        if not player then return end

        local username = player:getUsername()

        if amount > modData.BankBalance then
            player:Say("Error: Insufficient Funds")
            return
        end

        if modData.Owner == username then
            if CreateCashStack(moneyClip, amount) then
                sendClientCommand("GN84-WNDR", "withdrawCash", {username, amount})
                getSoundManager():PlaySound("ReceiptSound", false, 1):setVolume(1)
                UpdateSmokeyPointBalance()
            else
                print("Error: Withdraw (Amount) Smokey Points Failed!")
            end
        else
            getPlayer():Say("Error:  Unauthorized")
        end
    end
end



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

                local consolidate = context:addOptionOnTop("Consolidate Loose Cash", items, function () _ConsolidateCash(moneyClip, true) end, player, item)
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
    moneyStackX:setName(moneyStackX:getName() .. "  -  $" .. Utils.CurrencyFormatter(moneyStackData.CashAmount))
    --moneyStackX:setFavorite(true)
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
            if not modData then return end

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()

            if modData.Owner == username then

                local amount = modData.CashBalance or 0
                if amount > 0 then
                    sendClientCommand("GN84-WNDR", "depositCash", {username, amount})
                    modData.CashBalance = 0
                    getSoundManager():PlaySound("ReceiptSound", false, 1):setVolume(1)
                    player:Say("Depositing  $" .. Utils.CurrencyFormatter(amount) .. "  into Smokey Bank")
                    UpdateMoneyClipDisplayData(moneyClip, true)
                end
            else
               player:Say("Error:  Unauthorized")
            end
        end
end


------------------------------------------------------------------------
--                        PASSTHROUGH  
------------------------------------------------------------------------


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
            if not modData then return end
            if not modData.Owner then return end
            if not modData.CashBalance then return end

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
--                          PASSTHROUGH
------------------------------------------------------------------------


_GrabStackOfCashAll = function(item)
	GrabStackOfCashAll(item)
end


_GrabStackOfCashAmount = function(item)
	GrabStackOfCashAmount(item)
end


_ConsolidateCash = function(item, override)
    ConsolidateCash(item, true, override)
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

                UpdateWandererTokenBalance()

                if modData.Owner ~= player:getUsername() then player:Say("Error:  Unauthorized") return end
                if not modData.TokenBalance then return end

                if modData.TokenBalance > 0 then
                    local variableStack = context:addOptionOnTop("Withdraw (Amount)", items, function () _WithdrawTokensFromBankUI(moneyClip) end, player, item)
                    variableStack.notAvailable = false

                    local fullStack = context:addOptionOnTop("Withdraw (All)", items, function () _WithdrawAllTokensFromBank(moneyClip) end, player, item)
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

                local consolidate = context:addOptionOnTop("Deposit Wanderer Tokens into Smokey Bank", items, function () _ConsolidateTokens(moneyClip, true) end, player, item)
                consolidate.notAvailable = hideConsolidate
		    end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(TokenBalanceContext)



------------------------------------------------------------------------
--                 WITHDRAW TOKENS FROM BANK UI TOGGLE
------------------------------------------------------------------------

_WithdrawTokensFromBankUI = function(moneyClip)
    if not moneyClip then return end

    local modData = moneyClip:getModData()
    if not modData then return end
    if not modData.TokenBalance then return end

    local player = getPlayer()
    if not player then return end

    local username = player:getUsername()

    if modData.Owner == username then
        if modData.TokenBalance > 0 then
            if withdrawTokensFromBankUI == nil then
                local width = 200
                local height = 200

                withdrawTokensFromBankUI = WithdrawTokensFromBankUI:new((getCore():getScreenWidth() / 2) - (width / 2), (getCore():getScreenHeight() / 2) - (height / 2), width, height, modData.TokenBalance, moneyClip)
                withdrawTokensFromBankUI:initialise()
                withdrawTokensFromBankUI:addToUIManager()
            end
        end
    end
end



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
    tokenStackX:setName(tokenStackX:getName() .. "  -  " .. Utils.CurrencyFormatter(tokenStackXData.TokenAmount))
    --tokenStackX:setFavorite(true)
    return true
end



------------------------------------------------------------------------
--                      WITHDRAW TOKENS - ALL
------------------------------------------------------------------------


WithdrawAllTokensFromBank = function(item)
        if not item then return end

        local moneyClip = item

        if moneyClip:getType() == "MoneyClip" then

            local modData = moneyClip:getModData()
            if not modData then return end

            if not modData.Owner then return end
            if not modData.TokenBalance then return end

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()

            if modData.Owner == username then
                if CreateTokenStack(moneyClip, modData.TokenBalance) then
                    sendClientCommand("GN84-WNDR", "withdrawTokens", {username, modData.TokenBalance})
                    getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1)
                    UpdateWandererTokenBalance()
                else
                    print("Error: Withdraw (All) Wanderer Tokens Failed!")
                end
            else
                getPlayer():Say("Error:  Unauthorized")
            end
        end
end



------------------------------------------------------------------------
--                  WITHDRAW TOKEN AMOUNT FROM SMOKEY BANK
------------------------------------------------------------------------

WithdrawTokenAmountFromBank = function(item, amount)
    if not item then return end
    if not amount then return end

    local moneyClip = item

        if moneyClip:getType() == "MoneyClip" then

            local modData = moneyClip:getModData()
            if not modData then return end
            if not modData.Owner then return end
            if not modData.TokenBalance then return end

            local player = getPlayer()
            if not player then return end

            local username = player:getUsername()

            if amount > modData.TokenBalance then
                player:Say("Error: Insufficient Funds")
                return
            end

            if modData.Owner == username then
                if CreateTokenStack(moneyClip, amount) then
                    sendClientCommand("GN84-WNDR", "withdrawTokens", {username, amount})
                    getSoundManager():PlaySound("WinningTicketChime", false, 1):setVolume(1)
                    UpdateWandererTokenBalance()
                else
                    print("Error: Withdraw (Amount) Wanderer Tokens Failed!")
                end
            else
                getPlayer():Say("Error:  Unauthorized")
            end
        end
end



------------------------------------------------------------------------
--                          PASSTHROUGH
------------------------------------------------------------------------


_WithdrawAllTokensFromBank = function(item)
	WithdrawAllTokensFromBank(item)
end

_ConsolidateTokens = function(item, override)
    ConsolidateTokens(item, true, override)
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

        if modData.Owner then
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

            if modData.Owner then                
                if modData.Owner == username then
                    isOwner = true
                elseif modData.Owner ~= username then
                    isOwner = false
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

    UpdateContainerButtonTooltip(inventoryPage)
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


UpdateSmokeyPointBalance = function()
    sendClientCommand("GN84-WNDR", "get", nil)
    --print("Sent Smokey Points Update Request")
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

        if modData.Owner then
            if modData.Owner == username then
                modData.BankBalance = balance
                UpdateMoneyClipDisplayData(v, true)
            end
        end
    end
end


GetBankBalance = function(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if module == "GN84-WNDR" and command == "get" then
        if arguments then
            SaveBankBalance(arguments[1])
        end
    end
end


Events.OnServerCommand.Add(GetBankBalance)




------------------------------------------------------------------------
--                  BANK BALANCE - WANDERER TOKENS
------------------------------------------------------------------------


UpdateWandererTokenBalance = function()
    sendClientCommand("GN84-WNDR", "getTokens", nil)
    --print("Sent Wanderer Tokens Update Request")
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

        if modData.Owner then
            if modData.Owner == username then
                modData.TokenBalance = balance
                UpdateMoneyClipDisplayData(v, true)
            end
        end
    end
end


GetTokenBalance = function(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if module == "GN84-WNDR" and command == "getTokens" then
        if arguments then
            SaveTokenBalance(arguments[1])
        end
    end
end

Events.OnServerCommand.Add(GetTokenBalance)



------------------------------------------------------------------------
--                  RECEIVE / REQUEST SMOKEY BANK DATA
------------------------------------------------------------------------


ReceiveSmokeyBankData = function(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if module == "GN84-WNDR" and command == "UpdateSmokeyBankData" then
        if arguments and arguments[1] == getPlayer():getUsername() then
            print("Specific Player Update: " .. arguments[1])
            UpdateSmokeyBankData()
        elseif arguments == nil then
            print("Point/Token Tick Update")
            UpdateSmokeyBankData()
        end
    end
end

Events.OnServerCommand.Add(ReceiveSmokeyBankData)


UpdateSmokeyBankData = function()
    UpdateSmokeyPointBalance()
    UpdateWandererTokenBalance()
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
--               AUTO-CONSOLIDATE - ON TRANSFER OVERRIDE
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
    player:Say("Refreshing All Money Clips")

    for k, v in pairs(MoneyClips) do

        if v:getModData().Owner then
            ConsolidateAllDaily(v)
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

        if modData.Owner then
            if modData.Owner ~= username then
                if getAccessLevel() == "admin" then
                    return true
                else
                    player:Say("Error:  Unauthorized")
                    return false
                end
            elseif modData.Owner == username then
                return true
            end
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


UpdateContainerButtonTooltip = function(inventoryPage)
    if not inventoryPage then return end
    if not inventoryPage.onCharacter then return end

    local containers = inventoryPage.backpacks
    if not containers then return end

    for i,v in ipairs(containers) do
        local container = v.inventory
        if container then
            if container:getType() == "MoneyClip" then
                local moneyClip = container:getContainingItem()

                local modData = container:getContainingItem():getModData()
                if not modData then return end

                local player = getPlayer()
                if not player then return end

                local username = player:getUsername()
                if modData.Owner then
                    if modData.Owner == username then

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

                        local moneyClipName = moneyClip:getName() or ""

                        local currentWeight = 0
                        currentWeight = math.floor(moneyClip:getUnequippedWeight() * 10 + 0.5) / 10 or 0

                        local maxWeight = 0
                        maxWeight = moneyClip:getCapacity() or 0

                        v.tooltip = "<RGB:0.17255,1.0,0.01961,1>" .. moneyClipName .. "<LINE><RGB:1,1,1,1>" .. currentWeight .. " / " .. maxWeight .. "<H2><LINE><LINE> <RGB:1.0,0.6,0.11,1>Bank Balance:  $" .. smokeyPointBalance .. "<LINE><RGB:0.17255,1.0,0.01961,1>Cash Balance:  $" .. cashBalance .. "<LINE><RGB:0.0,0.886,1.0,1>Token Balance:   " .. wandererTokenBalance
                    end
                end                
            end
        end
    end
end




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
        if not modData.Owner then return end
        if not modData.UUID then return end

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
            if (getAccessLevel() == "admin") then
                self:drawRect(tooltipWidth, 0, moneyClipOwnerTextWidth + 60, fontHeight * 1.5, 1, 0, 0, 0)
                self:drawRectBorder(tooltipWidth, 0, moneyClipOwnerTextWidth + 60, (fontHeight * 1.5) + 4, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
                self.tooltip:DrawText(fontType, "Bound To:  " .. moneyClipOwner, startX, 6, 1.0, 0.6, 0.11, 1)
                self.tooltip:DrawText(fontType, "Cash Balance:  $" .. Utils.CurrencyFormatter(cashBalance), startX, 28, 0.17255, 1.0, 0.01961, 1)
            end
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

require "ISUI/ISPanel"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)
local FONT_SCALE = FONT_HGT_SMALL / 14

local buttonBorderColorDisabled = {r=1.0, g=0.0, b=0.0, a=0.5}           -- RED
local buttonBorderColorEnabled  = {r=0.0, g=1.0, b=0.0, a=0.75}          -- GREEN
local buttonBorderColorActive   = {r=0.341, g=0.561, b=0.875, a=1.0}     -- BLUE
local buttonBorderColorCaution  = {r=0.874, g=0.560, b=0.341, a=1.0}     -- ORANGE

-- ITEM TEXTURES
local BankTexture
local CashTexture
local TokenTexture

-- if CashTexture == nil then
--     local CashItem = InventoryItemFactory.CreateItem("GN84-WNDR.MoneyStack10000000")
--     CashTexture = CashItem:getTexture()
-- end


------------------------------------------------------------------------
--                    SMOKEY BANK WITHDRAW UI
------------------------------------------------------------------------


WithdrawCashFromBankUI = ISPanel:derive("WithdrawCashFromBankUI")

function WithdrawCashFromBankUI:initialise()
    ISPanel.initialise(self)
    self:create()
end

function WithdrawCashFromBankUI:prerender()
    ISPanel.prerender(self)
    self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.8, 1.0, 1.0, 1.0)
    self:drawRectBorder(0, 0, self:getWidth(), 40, 0.8, 1.0, 1.0, 1.0)
end

function WithdrawCashFromBankUI:render()
    if not self.moneyClip or not self.moneyClip:isInPlayerInventory() then
        getPlayer():Say("Error: Invalid MoneyClip Data")
        withdrawCashFromBankUI:setVisible(false)
        withdrawCashFromBankUI:removeFromUIManager()
        withdrawCashFromBankUI = nil
        return
    end

    local modData = self.moneyClip:getModData()
    if not modData then return end

    if BankTexture == nil then
        local BankCard = InventoryItemFactory.CreateItem("GN84-WNDR.BankBalance")
        BankTexture = BankCard:getTexture()
    end

    -- VISA ICON
    self:drawTextureScaledAspect2(BankTexture, self.width - 30, 10 * FONT_SCALE, FONT_HGT_LARGE, FONT_HGT_LARGE, 1, 1, 1, 1)
    self:drawTextureScaledAspect2(BankTexture, 5, 10 * FONT_SCALE, FONT_HGT_LARGE, FONT_HGT_LARGE, 1, 1, 1, 1)

    self:drawTextCentre("Smokey Bank", self.width / 2, 10 * FONT_SCALE, 1, 1, 1, 1, UIFont.Medium)
    self:drawTextCentre("Cash Balance ", self.width / 2, 50, 1, 1, 1, 1, UIFont.Medium)
    local balanceText = Utils.CurrencyFormatter(modData.BankBalance) or 0
    self:drawTextCentre("$" .. balanceText, self.width / 2, 70, 1, 1, 1, 1, UIFont.Medium)

    local bankBalance = modData.BankBalance
    local withdrawAmount = tonumber(self._pointsEntry:getInternalText()) or 0

    if withdrawAmount == 0 or self._pointsEntry:getInternalText() == "" then
        self._withdrawButton.borderColor = buttonBorderColorDisabled
        self._withdrawButton:setTooltip("Please enter a valid number")
    elseif withdrawAmount > bankBalance then
        self._withdrawButton.borderColor = buttonBorderColorDisabled
        self._withdrawButton:setTooltip("Insufficient Funds")
    elseif withdrawAmount > 0 and withdrawAmount <= bankBalance then
        self._withdrawButton.borderColor = buttonBorderColorEnabled
        self._withdrawButton:setTooltip("Withdraw Cash from your Smokey Bank")
    end
end

function WithdrawCashFromBankUI:create()
    local btnWidth = 50
    local btnHeight = getTextManager():getFontHeight(UIFont.Small) + 4 * 2
    local padBottom = 20

    -- Currency Entry Box
    self._pointsEntry = ISTextEntryBox:new("0", (self.width - 80) / 2, 100, 80, FONT_HGT_SMALL + 8)
    self._pointsEntry:initialise()
    self._pointsEntry:instantiate()
    self._pointsEntry:setMaxTextLength(9)
    self._pointsEntry:setOnlyNumbers(true)
    self:addChild(self._pointsEntry)

    -- Withdraw Button
    local z = self._pointsEntry.y + self._pointsEntry.height + 10
    self._withdrawButton = ISButton:new((self.width - 80) / 2, z, 80 , btnHeight, "WITHDRAW", self, WithdrawCashFromBankUI.onOptionMouseDown)
    self._withdrawButton.internal = "WITHDRAW"
    self._withdrawButton:initialise()
    self._withdrawButton:instantiate()
    self:addChild(self._withdrawButton)

    -- Close UI Button
    z = self._withdrawButton.y + self._withdrawButton.height + 10
    self._closeUIButton = ISButton:new((self.width - btnWidth) / 2, z, btnWidth, btnHeight, getText("UI_btn_close"), self, WithdrawCashFromBankUI.onOptionMouseDown)
    self._closeUIButton.internal = "CLOSE_UI"
    self._closeUIButton:initialise()
    self._closeUIButton:instantiate()
    self:addChild(self._closeUIButton)
end

function WithdrawCashFromBankUI:onOptionMouseDown(button, x, y)

    if button.internal == "CLOSE_UI" then
        withdrawCashFromBankUI:setVisible(false)
        withdrawCashFromBankUI:removeFromUIManager()
        withdrawCashFromBankUI = nil
    end

    if button.internal == "WITHDRAW" then
        if not self.moneyClip then return end

        local modData = self.moneyClip:getModData()
        if not modData then return end
        if not modData.BankBalance then return end

        local bankBalance = modData.BankBalance
        local withdrawAmount = tonumber(self._pointsEntry:getInternalText()) or 0

        local player = getPlayer()
        if not player then return end

        if withdrawAmount == 0 or self._pointsEntry:getInternalText() == "" then
            player:Say("Error: Invalid Entry")
        elseif withdrawAmount > bankBalance then
            player:Say("Error: Insufficient Funds")
        elseif withdrawAmount > 0 and withdrawAmount <= bankBalance then
            player:Say("Withdrawing  $" .. Utils.CurrencyFormatter(withdrawAmount) .. "  from Smokey Bank")
            WithdrawCashAmountFromBank(self.moneyClip, withdrawAmount)

            -- Close UI After Transaction
            withdrawCashFromBankUI:setVisible(false)
            withdrawCashFromBankUI:removeFromUIManager()
            withdrawCashFromBankUI = nil
        end
    end

end

function WithdrawCashFromBankUI:new(x, y, width, height, _balance, _moneyClip)
    local o = {}
    o = ISPanel:new(x, y + 50, width, height)
    setmetatable(o, self)
    self.__index = self
    o.balance = _balance or 0
    o.moneyClip = _moneyClip
    o.moveWithMouse = true
    o.variableColor= {r=0.9, g=0.55, b=0.1, a=1}
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.75}
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
    o.zOffsetSmallFont = 25
    WithdrawCashFromBankUI.instance = o

    if not _moneyClip then return nil end

    return o
end




------------------------------------------------------------------------
--                    WITHDRAW TOKENS FROM BANK UI
------------------------------------------------------------------------


WithdrawTokensFromBankUI = ISPanel:derive("WithdrawTokensFromBankUI")

function WithdrawTokensFromBankUI:initialise()
    ISPanel.initialise(self)
    self:create()
end

function WithdrawTokensFromBankUI:prerender()
    ISPanel.prerender(self)
    self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.8, 1.0, 1.0, 1.0)
    self:drawRectBorder(0, 0, self:getWidth(), 40, 0.8, 1.0, 1.0, 1.0)
end

function WithdrawTokensFromBankUI:render()
    if not self.moneyClip or not self.moneyClip:isInPlayerInventory() then
        getPlayer():Say("Error: Invalid MoneyClip Data")
        withdrawTokensFromBankUI:setVisible(false)
        withdrawTokensFromBankUI:removeFromUIManager()
        withdrawTokensFromBankUI = nil
        return
    end

    local modData = self.moneyClip:getModData()
    if not modData then return end

    if TokenTexture == nil then
        local TokenItem = InventoryItemFactory.CreateItem("GN84-WNDR.WandererTokenStack100")
        TokenTexture = TokenItem:getTexture()
    end

    -- VISA ICON
    self:drawTextureScaledAspect2(TokenTexture, self.width - 30, 10 * FONT_SCALE, FONT_HGT_LARGE, FONT_HGT_LARGE, 1, 1, 1, 1)
    self:drawTextureScaledAspect2(TokenTexture, 5, 10 * FONT_SCALE, FONT_HGT_LARGE, FONT_HGT_LARGE, 1, 1, 1, 1)

    self:drawTextCentre("Smokey Bank", self.width / 2, 10 * FONT_SCALE, 1, 1, 1, 1, UIFont.Medium)
    self:drawTextCentre("Token Balance ", self.width / 2, 50, 1, 1, 1, 1, UIFont.Medium)
    local balanceText = Utils.CurrencyFormatter(modData.TokenBalance) or 0
    self:drawTextCentre(balanceText, self.width / 2, 70, 1, 1, 1, 1, UIFont.Medium)

    local tokenBalance = modData.TokenBalance
    local withdrawAmount = tonumber(self._pointsEntry:getInternalText()) or 0

    if withdrawAmount == 0 or self._pointsEntry:getInternalText() == "" then
        self._withdrawButton.borderColor = buttonBorderColorDisabled
        self._withdrawButton:setTooltip("Please enter a valid number")
    elseif withdrawAmount > tokenBalance then
        self._withdrawButton.borderColor = buttonBorderColorDisabled
        self._withdrawButton:setTooltip("Insufficient Funds")
    elseif withdrawAmount > 0 and withdrawAmount <= tokenBalance then
        self._withdrawButton.borderColor = buttonBorderColorEnabled
        self._withdrawButton:setTooltip("Withdraw Wanderer Tokens from your Smokey Bank")
    end
end

function WithdrawTokensFromBankUI:create()
    local btnWidth = 50
    local btnHeight = getTextManager():getFontHeight(UIFont.Small) + 4 * 2
    local padBottom = 20

    -- Currency Entry Box
    self._pointsEntry = ISTextEntryBox:new("0", (self.width - 80) / 2, 100, 80, FONT_HGT_SMALL + 8)
    self._pointsEntry:initialise()
    self._pointsEntry:instantiate()
    self._pointsEntry:setMaxTextLength(9)
    self._pointsEntry:setOnlyNumbers(true)
    self:addChild(self._pointsEntry)

    -- Withdraw Button
    local z = self._pointsEntry.y + self._pointsEntry.height + 10
    self._withdrawButton = ISButton:new((self.width - 80) / 2, z, 80 , btnHeight, "WITHDRAW", self, WithdrawTokensFromBankUI.onOptionMouseDown)
    self._withdrawButton.internal = "WITHDRAW"
    self._withdrawButton:initialise()
    self._withdrawButton:instantiate()
    self:addChild(self._withdrawButton)

    -- Close UI Button
    z = self._withdrawButton.y + self._withdrawButton.height + 10
    self._closeUIButton = ISButton:new((self.width - btnWidth) / 2, z, btnWidth, btnHeight, getText("UI_btn_close"), self, WithdrawTokensFromBankUI.onOptionMouseDown)
    self._closeUIButton.internal = "CLOSE_UI"
    self._closeUIButton:initialise()
    self._closeUIButton:instantiate()
    self:addChild(self._closeUIButton)
end

function WithdrawTokensFromBankUI:onOptionMouseDown(button, x, y)

    if button.internal == "CLOSE_UI" then
        withdrawTokensFromBankUI:setVisible(false)
        withdrawTokensFromBankUI:removeFromUIManager()
        withdrawTokensFromBankUI = nil
    end

    if button.internal == "WITHDRAW" then
        if not self.moneyClip then return end

        local modData = self.moneyClip:getModData()
        if not modData then return end
        if not modData.TokenBalance then return end

        local tokenBalance = modData.TokenBalance
        local withdrawAmount = tonumber(self._pointsEntry:getInternalText()) or 0

        local player = getPlayer()
        if not player then return end

        if withdrawAmount == 0 or self._pointsEntry:getInternalText() == "" then
            player:Say("Error: Invalid Entry")
        elseif withdrawAmount > tokenBalance then
            player:Say("Error: Insufficient Funds")
        elseif withdrawAmount > 0 and withdrawAmount <= tokenBalance then
            player:Say("Withdrawing  " .. Utils.CurrencyFormatter(withdrawAmount) .. "  Wanderer Tokens from Smokey Bank")
            WithdrawTokenAmountFromBank(self.moneyClip, withdrawAmount)

            -- Close UI After Transaction
            withdrawTokensFromBankUI:setVisible(false)
            withdrawTokensFromBankUI:removeFromUIManager()
            withdrawTokensFromBankUI = nil
        end
    end

end

function WithdrawTokensFromBankUI:new(x, y, width, height, _balance, _moneyClip)
    local o = {}
    o = ISPanel:new(x, y + 50, width, height)
    setmetatable(o, self)
    self.__index = self
    o.balance = _balance or 0
    o.moneyClip = _moneyClip
    o.moveWithMouse = true
    o.variableColor= {r=0.9, g=0.55, b=0.1, a=1}
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.75}
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
    o.zOffsetSmallFont = 25
    WithdrawTokensFromBankUI.instance = o

    if not _moneyClip then return nil end

    return o
end







local function debugTestKey(key)
    if key == 73 then
        local width = 200
        local height = 200
        withdrawCashFromBankUI = WithdrawCashFromBankUI:new((getCore():getScreenWidth() / 2) - (width / 2), (getCore():getScreenHeight() / 2) - (height / 2), width, height, 654321, nil)
        if withdrawCashFromBankUI then
            withdrawCashFromBankUI:initialise()
            withdrawCashFromBankUI:addToUIManager()
        end
    end
end

Events.OnCustomUIKeyPressed.Add(debugTestKey)