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
-- ##                                           GN84-WNDR                                                 ##
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################

local Utils = require "Gizmo/GN84LIB_Utils"

local MoneyClipData = {Owner = nil, SteamID = nil, BankBalance = nil, CashBalance = nil, TokenBalance = nil,}
local recheckTimer = true

local ConsolidateMoneyClip
local CreateCashStack
local ConsolidateCash
local ConsolidateTokens
local UpdateBalanceItems

local currentUUID = nil
local lastUUID = nil


------------------------------------------------------------------------
--                       REMOVE BALANCE ITEMS
------------------------------------------------------------------------

local function RemoveBalanceItems(item)
    local moneyClipContainer = item:getItemContainer()
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
--                    CREATE BALANCE ITEMS
------------------------------------------------------------------------

local function CreateBalanceItems(item)

    -- Spawn Dummy Tooltip Items if not already Spawned
	local moneyClipContainer = item:getItemContainer()
    local items = moneyClipContainer:getItems()

    if not items then
        print("Warning: No Item List")
        return
    else

        if items:size() == 0 then
            moneyClipContainer:AddItem("GN84-WNDR.BankBalance")
            moneyClipContainer:AddItem("GN84-WNDR.CashBalance")
            moneyClipContainer:AddItem("GN84-WNDR.TokenBalance")
            return

        elseif items:size() ~= 0 then
            local spawnBankItem  = true
            local spawnCashItem  = true
            local spawnTokenItem = true

            for i = items:size()-1, 0, -1 do
                local item = items:get(i)

                if item:getType() == "BankBalance" then
                    spawnBankItem = false
                elseif item:getType() == "CashBalance" then
                    spawnCashItem = false
                elseif item:getType() == "TokenBalance" then
                    spawnTokenItem = false
                end
            end

            -- Spawn Missing Items
            if spawnBankItem or spawnCashItem or spawnTokenItem then
                if spawnBankItem  then moneyClipContainer:AddItem("GN84-WNDR.BankBalance") end
                if spawnCashItem  then moneyClipContainer:AddItem("GN84-WNDR.CashBalance") end
                if spawnTokenItem then moneyClipContainer:AddItem("GN84-WNDR.TokenBalance") end
            end
        end
	end
end


------------------------------------------------------------------------
--                     BIND MONEY CLIP TO PLAYER
------------------------------------------------------------------------

local function BindMoneyClipToPlayer(target, player, item)

    if not item then return end

	local MoneyClip = item:getModData()
	if not MoneyClip then return end

	local username = player:getUsername()
    if not username then return end

	if not MoneyClip.Owner then
		MoneyClip.Owner = username
		MoneyClip.AutoConsolidate = true
        MoneyClip.UUID = getRandomUUID()
        MoneyClip.CashBalance = 0
	end

	-- Change Item Name to Reflect Bound Status + Favorite Money Clip
	local itemName = item:getName()
	if itemName == "Money Clip" then
		item:setName(username .. "'s Money Clip")
	end

	item:setFavorite(true)
    -- TODO:  PLAY SOUND

    CreateBalanceItems(item)
end


------------------------------------------------------------------------
--                     UNBIND MONEY CLIP - ADMIN
------------------------------------------------------------------------

local function UnBindMoneyClip(target, player, item)
    if not item then return end

	local modData = item:getModData()
	if not modData then return end

    if (modData.CashBalance ~= nil) and (modData.CashBalance > 0) then        
        CreateCashStack(item, modData.CashBalance)        
    end
    
    item:setFavorite(false)
    RemoveBalanceItems(item)

	modData.Owner = nil
	modData.BankBalance = nil
	modData.CashBalance = nil
	modData.TokenBalance = nil
    modData.UUID = nil
end

------------------------------------------------------------------------
--                          CONTEXT MENUS
------------------------------------------------------------------------
------------------------------------------------------------------------
--                     MONEY STACK CONTEXT MENU   
------------------------------------------------------------------------



------------------------------------------------------------------------
--                      MONEY CLIP CONTEXT MENU
------------------------------------------------------------------------

local function _ConsolidateCurrencies(item)
	ConsolidateMoneyClip(item)
end

function MoneyClipContext(playerNum, context, items)

	local player = getSpecificPlayer(playerNum)
    items = ISInventoryPane.getActualItems(items)

	for _, item in ipairs(items) do
		if item:getType() == "MoneyClip" then
			if not item:isInPlayerInventory() then return end

			local MoneyClip = item:getModData()

			if MoneyClip.Owner == nil then
				context:addOptionOnTop("Bind Money Clip", items, BindMoneyClipToPlayer, player, item)

			elseif MoneyClip.Owner == player:getUsername() then
					context:addOptionOnTop("Consolidate All Currency", items, function() _ConsolidateCurrencies(item) end, player, item)
			end

			-- Admin Un-Bind Option
			if player:getAccessLevel() == "Admin" then
				if MoneyClip.Owner ~= nil then
				context:addOptionOnTop("Un-Bind Money Clip (Admin)", items, UnBindMoneyClip, player, item)
				end
			end
		end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(MoneyClipContext)



------------------------------------------------------------------------
--                      BANK BALANCE CONTEXT MENU
------------------------------------------------------------------------

local function DepositCashBalance(item)
    if MoneyClipData.CashBalance == nil then return end

    if MoneyClipData.CashBalance ~= nil and MoneyClipData.CashBalance > 0 then
        
        local moneyClipContainer = item:getContainer():getContainingItem()        
        
        if moneyClipContainer:getType() == "MoneyClip" then
            
            local modData = moneyClipContainer:getModData()
            if modData == nil then return end
            
            local player = getPlayer()

            if modData.Owner == player:getUsername() then
                modData.CashBalance = 0
                print("Depositing Cash Balance")
                local amount = MoneyClipData.CashBalance or 0
                sendClientCommand("GN84-WNDR", "depositCash", {getPlayer():getUsername(), amount})
                recheckTimer = true
                UpdateBalanceItems(moneyClipContainer)
            else
                getPlayer():Say("I am not the owner..")
            end    
            
        end
    end
end

local function _DepositCash(item)
	DepositCashBalance(item)
end

function BankBalanceContext(playerNum, context, items)

	local player = getSpecificPlayer(playerNum)
    items = ISInventoryPane.getActualItems(items)

	for _, item in ipairs(items) do
		if item:getType() == "BankBalance" then
			if not item:isInPlayerInventory() then return end                
                                
            local moneyClipContainer = item:getContainer():getContainingItem()        
            if moneyClipContainer:getType() == "MoneyClip" then
                local modData = moneyClipContainer:getModData()

                if modData == nil then return end

                if modData.CashBalance > 0 then
                    local option = context:addOptionOnTop("Deposit Cash Balance into Smokey Bank", items, function () _DepositCash(item) end, player, item)    
                    option.notAvailable = false
                elseif modData.CashBalance == 0 then
                    local option = context:addOptionOnTop("Deposit Cash Balance into Smokey Bank", items, nil, player, item)    
                    option.notAvailable = true                    
                end                
            end                
		end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(BankBalanceContext)



------------------------------------------------------------------------
--                      CASH BALANCE CONTEXT MENU
------------------------------------------------------------------------

CreateCashStack = function(moneyClip)
    if not moneyClip then return false end

    local modData = moneyClip:getModData()
    if not modData then return false end

    local moneyStack = InventoryItemFactory.CreateItem("GN84-WNDR.MoneyStackX")

    moneyClip:getItemContainer():AddItem(moneyStack)
    moneyStackData = moneyStack:getModData()
    moneyStackData.CashAmount = modData.CashBalance or 0

    moneyStack:setName(moneyStack:getName() .. " - $" .. Utils.CurrencyFormatter(moneyStackData.CashAmount))
    return true
end


local function GrabFullStackOfCash(item)
    if MoneyClipData.CashBalance == nil then return end

    if MoneyClipData.CashBalance ~= nil and MoneyClipData.CashBalance > 0 then
        
        local moneyClipContainer = item:getContainer():getContainingItem()        
        
        if moneyClipContainer:getType() == "MoneyClip" then
            
            local modData = moneyClipContainer:getModData()

            if modData == nil then return end
            
            local player = getPlayer()

            if modData.Owner == player:getUsername() then                
                if CreateCashStack(moneyClipContainer, modData.CashBalance) then
                    modData.CashBalance = 0    
                    recheckTimer = true
                    UpdateBalanceItems(moneyClipContainer)
                else
                    print("Full Stack of Cash Failed")
                end
            else
                getPlayer():Say("I am not the owner..")
            end              
        end
    end
end

-- TODO
local function GrabStackOfCash(item)
    if MoneyClipData.CashBalance == nil then return end

    if MoneyClipData.CashBalance ~= nil and MoneyClipData.CashBalance > 0 then
        
        local moneyClipContainer = item:getContainer():getContainingItem()        
        
        if moneyClipContainer:getType() == "MoneyClip" then
            
            local modData = moneyClipContainer:getModData()

            if modData == nil then return end
            
            local player = getPlayer()

            if modData.Owner == player:getUsername() then
                print("Grabbing a Stack of Cash")
                if CreateCashStack(moneyClipContainer, modData.CashBalance) then
                    modData.CashBalance = 0
                    print("Stack of Cash Successful")
                    recheckTimer = true
                    UpdateBalanceItems(moneyClipContainer)
                else
                    print("Stack of Cash Failed")
                end
            else
                getPlayer():Say("I am not the owner..")
            end               
        end
    end
end



-- Passthrough Functions
local function _GrabFullCashStack(item)
	GrabFullStackOfCash(item)
end

local function _GrabCashStack(item)
	GrabStackOfCash(item)
end

local function _ConsolidateCash(item)
    ConsolidateCash(item)
end



function CashBalanceContext(playerNum, context, items)

	local player = getSpecificPlayer(playerNum)
    items = ISInventoryPane.getActualItems(items)

	for _, item in ipairs(items) do
		if item:getType() == "CashBalance" then
			if not item:isInPlayerInventory() then return end                
                                
            local moneyClipContainer = item:getContainer():getContainingItem()        
            if moneyClipContainer:getType() == "MoneyClip" then

                local modData = moneyClipContainer:getModData()
                if modData == nil then return end
                if modData.CashBalance == nil then modData.CashBalance = 0 end

                if modData.CashBalance > 0 then
                    local variableStack = context:addOptionOnTop("Grab a Stack of Cash", items, function () _GrabCashStack(item) end, player, item)    
                    variableStack.notAvailable = true

                    local fullStack = context:addOptionOnTop("Grab a Stack of Cash (Full Balance)", items, function () _GrabFullCashStack(item) end, player, item)    
                    fullStack.notAvailable = false                    

                elseif modData.CashBalance == 0 then
                    local option = context:addOptionOnTop("Grab a Stack of Cash", items, nil, player, item)    
                    option.notAvailable = true                    
                end

                local consolidate = context:addOptionOnTop("Consolidate Loose Cash", items, function () _ConsolidateCash(moneyClipContainer) end, player, item) 
                consolidate.notAvailable = false
            end                
		end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(CashBalanceContext)



------------------------------------------------------------------------
--                       SERVER REQUEST LIMITER
------------------------------------------------------------------------

local function UpdateAllMoneyClips()
    local player = getPlayer()
    if not player then return end

    local inventory = player:getInventory()
    if not inventory then return end

    local items = inventory:getItems()
    if not items then return end
    if items:size() == 0 then return end 

    for i = items:size()-1, 0, -1 do
        local item = items:get(i)

        if item:getType() == "MoneyClip" then
            --print("Updating Money Clip" .. tostring(item))
            UpdateBalanceItems(item)       
        end
    end
end


local function ReCheckDataTimer()
    if recheckTimer == false then
        recheckTimer = true
    end

    UpdateAllMoneyClips()    
end

Events.EveryOneMinute.Add(ReCheckDataTimer)


------------------------------------------------------------------------
--              MODDATA RETREIVAL FUNCTIONS - TOOLTIPS
------------------------------------------------------------------------
------------------------------------------------------------------------
--                        MoneyClip Owner
------------------------------------------------------------------------

local function updateOwnerToolTip(item)
    local modData = item:getModData()
    if modData then
        MoneyClipData.Owner = modData.Owner
        MoneyClipData.UUID = modData.UUID
        currentUUID = modData.UUID
    end
end

------------------------------------------------------------------------
--                        BANK - SMOKEY POINTS
------------------------------------------------------------------------

local function OnServerCommand(module, command, arguments)
    if module == "GN84-WNDR" and command == "get" then
        if arguments then
            MoneyClipData.BankBalance = Utils.CurrencyFormatter(arguments[1])
        end
        Events.OnServerCommand.Remove(OnServerCommand)
    end
end


local function updateSmokeyPointBalance(item)
    if recheckTimer then
        Events.OnServerCommand.Add(OnServerCommand)
        sendClientCommand("GN84-WNDR", "get", nil)
    end
end


------------------------------------------------------------------------
--                      BANK - WANDERER TOKENS
------------------------------------------------------------------------

local function OnServerCommand(module, command, arguments)
    if module == "GN84-WNDR" and command == "getTokens" then
        if arguments then
            MoneyClipData.TokenBalance = Utils.CurrencyFormatter(arguments[1])
        end
        Events.OnServerCommand.Remove(OnServerCommand)
    end
end


local function updateWandererTokenBalance(item)
    if recheckTimer then
        Events.OnServerCommand.Add(OnServerCommand)
        sendClientCommand("GN84-WNDR", "getTokens", nil)
    end
end

------------------------------------------------------------------------
--                         Cash Balance
------------------------------------------------------------------------

local function updateCashBalanceToolTip(item)
    if recheckTimer then
        local modData = item:getModData()
        if modData then
            MoneyClipData.CashBalance = modData.CashBalance
        end
    end
end

------------------------------------------------------------------------
--                        UPDATER FUNCTIONS
------------------------------------------------------------------------

local function AutoUpdateMoneyClipData(item)
    updateSmokeyPointBalance(item)
    updateCashBalanceToolTip(item)
    updateWandererTokenBalance(item)
    UpdateBalanceItems(item)
    recheckTimer = false
end

local function ManualUpdateMoneyClipData(item)
    recheckTimer = true
    updateSmokeyPointBalance(item)
    updateCashBalanceToolTip(item)
    updateWandererTokenBalance(item)
    UpdateBalanceItems(item)
end


UpdateBalanceItems = function(item)
    if not item then return end
    
    local modData = item:getModData()
    if not modData then return end

    local moneyClipContainer = item:getItemContainer()
    local items = moneyClipContainer:getItems()

    if not items then
        print("Warning: No Item List")
        return
    else

        if items:size() == 0 then return

        elseif items:size() ~= 0 then

            for i = items:size()-1, 0, -1 do
                local item = items:get(i)

                updateSmokeyPointBalance(moneyClipContainer)                
                updateWandererTokenBalance(moneyClipContainer)

                local BankBalance = MoneyClipData.BankBalance
                local CashBalance = modData.CashBalance
                local TokenBalance = MoneyClipData.TokenBalance


                if item:getType() == "BankBalance" then
                    if BankBalance == nil then
                        item:setName("-----[   Bank Balance:     ...")
                    else
                        item:setName("-----[   Bank Balance:     $" ..  BankBalance)
                    end                    
                elseif item:getType() == "CashBalance" then
                    if CashBalance == nil then
                        item:setName("-----[   Cash Balance:     ...")
                    else
                        item:setName("-----[   Cash Balance:     $" ..  Utils.CurrencyFormatter(CashBalance))
                    end
                elseif item:getType() == "TokenBalance" then
                    if TokenBalance == nil then
                        item:setName("-----[   Token Balance:    ...")
                    else
                        item:setName("-----[   Token Balance:    " ..  TokenBalance)
                    end
                end
            end
        end
    end
end

------------------------------------------------------------------------
--                      CURRENCY CONSOLIDATION
------------------------------------------------------------------------


local listOfMoneyStacks =
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


ConsolidateCash = function(moneyclip)
    local modData = moneyclip:getModData()
    local moneyClipContainer = moneyclip:getItemContainer()
    local items = moneyClipContainer:getItems()

    local runningTotal = 0

    if items ~= nil then

        for i = items:size()-1, 0, -1 do
            local item = items:get(i)

            if not item:isFavorite() then

                -- Standard Cash Stacks
                for _moneyStack, _stats in pairs(listOfMoneyStacks) do
                    if item:getType() == _moneyStack then
                        print(item:getType())
                        print("Value: " .. _stats.value)

                        moneyClipContainer:DoRemoveItem(item)
                        runningTotal = runningTotal + _stats.value
                        print("Total: " .. runningTotal)
                    end
                end

                --Variable Cash Stacks
                if item:getType() == "MoneyStackX" then
                    print(item:getType())
                    local cashStack = item:getModData()
                    cashAmount = cashStack.CashAmount or 0
                    print("Value: " .. cashAmount)
                    moneyClipContainer:DoRemoveItem(item)
                    runningTotal = runningTotal + cashAmount
                    print("Total: " .. runningTotal)
                end
            end
        end

        local cashBalance = modData.CashBalance or 0
        cashBalance = cashBalance + runningTotal
        modData.CashBalance = cashBalance
        print("Consolidating Cash")
        UpdateBalanceItems(moneyclip)
    end

end

local listOfTokenStacks =
{
    WandererToken                       =   {type = "GN84-WNDR.WandererToken",                      value = 1,          },
    WandererTokenStack5                 =   {type = "GN84-WNDR.WandererTokenStack5",                value = 5,          },
    WandererTokenStack10                =   {type = "GN84-WNDR.WandererTokenStack10",               value = 10,         },
    WandererTokenStack25                =   {type = "GN84-WNDR.WandererTokenStack25",               value = 25,         },
    WandererTokenStack50                =   {type = "GN84-WNDR.WandererTokenStack50",               value = 50,         },
    WandererTokenStack100               =   {type = "GN84-WNDR.WandererTokenStack100",              value = 100,        },
    WandererTokenStack250               =   {type = "GN84-WNDR.WandererTokenStack250",              value = 250,        },
    WandererTokenStack500               =   {type = "GN84-WNDR.WandererTokenStack500",              value = 500,        },
    WandererTokenStack500               =   {type = "GN84-WNDR.WandererTokenStack500",              value = 500,        },
    WandererTokenStack1000              =   {type = "GN84-WNDR.WandererTokenStack1000",             value = 1000,       },
    WandererTokenStack5000              =   {type = "GN84-WNDR.WandererTokenStack5000",             value = 5000,       },
}


ConsolidateTokens = function(moneyclip)
    local modData = moneyclip:getModData()
    local moneyClipContainer = moneyclip:getItemContainer()
    local items = moneyClipContainer:getItems()

    local runningTotal = 0

    if items ~= nil then
        for i = items:size()-1, 0, -1 do
            local item = items:get(i)

            -- Standard Token Stacks
            for _tokenStack, _stats in pairs(listOfTokenStacks) do
                if item:getType() == _tokenStack then
                    print(item:getType())
                    print("Value: " .. _stats.value)

                    moneyClipContainer:DoRemoveItem(item)
                    runningTotal = runningTotal + _stats.value
                    print("Total: " .. runningTotal)

                end

            end

            --Variable Token Stacks
                if item:getType() == "WandererTokenStackX" then
                    print(item:getType())
                    local tokenStack = item:getModData()
                    tokenAmount = tokenStack.TokenAmount or 0
                    print("Value: " .. tokenAmount)
                    moneyClipContainer:DoRemoveItem(item)
                    runningTotal = runningTotal + tokenAmount
                    print("Total: " .. runningTotal)
                end
        end

        sendClientCommand("GN84-WNDR", "depositTokens", {getPlayer():getUsername(), runningTotal})
        print("Consolidating Wanderer Tokens")
        UpdateBalanceItems(moneyclip)
    end


end

ConsolidateMoneyClip = function(moneyclip)
    getPlayer():Say("Consolidating All Currency")
    ConsolidateCash(moneyclip)
    ConsolidateTokens(moneyclip)
    ManualUpdateMoneyClipData(moneyclip)
end


------------------------------------------------------------------------
--                             TOOLTIPS
------------------------------------------------------------------------

local oldRender = ISToolTipInv.render
function ISToolTipInv:render()

    local itemType = self.item:getType()
    if not itemType == "MoneyClip" then return oldRender(self) end

    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
        if not MoneyClipData then return end

        -- Call the original render function first to draw the original tooltip content
        oldRender(self)

        ------------------------------------------------------------------------
        --                       MONEY CLIP TOOLTIP
        ------------------------------------------------------------------------

                -- Update Owner Constantly
            local item = self.item
            updateOwnerToolTip(item)

            -- Error Handling
            if MoneyClipData.Owner == nil then return end
            if MoneyClipData.UUID == nil then return end

            -- Check if Money Clip is Different then previously viewed
            if lastUUID ~= currentUUID then
                recheckTimer = true
                AutoUpdateMoneyClipData(item)
                UpdateBalanceItems(item)
                lastUUID = currentUUID
                currentUUID = MoneyClipData.UUID
            end

            -- Limit Data Updates to Reduce Server Lag
            if recheckTimer then
                AutoUpdateMoneyClipData(item)
                UpdateBalanceItems(item)
            end

            local player = getPlayer()
            local username = player:getUsername()
            local blankString = " "

            -- Information Display Strings
            local moneyClipOwner        = MoneyClipData.Owner or blankString
            local smokeyPointBalance    = MoneyClipData.BankBalance or 0
            local cashBalance           = MoneyClipData.CashBalance or 0
            local wandererTokenBalance  = MoneyClipData.TokenBalance or 0


            ------------------------------------------------------------------------
            --                          RENDERING
            ------------------------------------------------------------------------

            -- Define Fonts
            local font = getCore():getOptionTooltipFont()
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
                end
            end
    end
end