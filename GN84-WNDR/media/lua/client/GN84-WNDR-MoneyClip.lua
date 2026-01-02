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

local MoneyClipData = {Owner = nil, SteamID = nil, SmokeyPointBalance = nil, CashBalance = nil, WandererTokenBalance = nil,}
local recheckTimer = true

------------------------------------------------------------------------
--                       SERVER REQUEST LIMITER
------------------------------------------------------------------------

local function ReCheckDataTimer()
    if recheckTimer == false then
        recheckTimer = true        
    end
end

Events.EveryOneMinute.Add(ReCheckDataTimer)


------------------------------------------------------------------------
--                   MODDATA RETREIVAL FUNCTIONS
------------------------------------------------------------------------
------------------------------------------------------------------------
--                        MoneyClip Owner
------------------------------------------------------------------------

local function updateMoneyClipOwner(item)    
    local modData = item:getModData()
    if modData then 
        MoneyClipData.Owner = modData.Owner            
    end    
end

------------------------------------------------------------------------
--                         Smokey Points 
------------------------------------------------------------------------

local function OnServerCommand(module, command, arguments)
    if module == "GN84-WNDR" and command == "get" then
        if arguments then
            MoneyClipData.SmokeyPointBalance = Utils.CurrencyFormatter(arguments[1])
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
--                         Cash Balance   
------------------------------------------------------------------------

local function updateCashBalance(item)    
    if recheckTimer then
        local modData = item:getModData()
        if modData then 
            MoneyClipData.CashBalance = modData.CashBalance
        end    
    end   
end

------------------------------------------------------------------------
--                     Wanderer Token Balance 
------------------------------------------------------------------------

local function updateWandererTokenBalance(item)    
    if recheckTimer then
        local modData = item:getModData()
        if modData then 
            MoneyClipData.WandererTokenBalance = modData.WandererTokenBalance
        end 
    end  
end

------------------------------------------------------------------------
--                        UPDATER FUNCTIONS  
------------------------------------------------------------------------

local function AutoUpdateMoneyClipData(item)    
    updateSmokeyPointBalance(item)
    updateCashBalance(item)
    updateWandererTokenBalance(item)
    recheckTimer = false
end

local function ManualUpdateMoneyClipData(item)
    recheckTimer = true    
    updateSmokeyPointBalance(item)
    updateCashBalance(item)
    updateWandererTokenBalance(item)
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


local function ConsolidateCash(moneyclip)
    local modData = moneyclip:getModData()
    local moneyClipContainer = moneyclip:getItemContainer()
    local items = moneyClipContainer:getItems()

    local runningTotal = 0

    if items ~= nil then
        
        for i = items:size()-1, 0, -1 do
            local item = items:get(i)

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
                cashAmount = cashStack.Total or 0
                print("Value: " .. cashAmount)
                moneyClipContainer:DoRemoveItem(item)
                runningTotal = runningTotal + cashAmount
                print("Total: " .. runningTotal)
             end
        
        end

        local cashBalance = modData.CashBalance or 0
        cashBalance = cashBalance + runningTotal
        modData.CashBalance = cashBalance
        print("Consolidating Cash")
    end
    
end

local function ConsolidateWandererTokens(moneyclip)
    local modData = moneyclip:getModData()
    local moneyClipContainer = moneyclip:getItemContainer()
    local items = moneyClipContainer:getItems()

    local runningTotal = 0

    if items ~= nil then
        for i = items:size()-1, 0, -1 do
            local item = items:get(i)

            if item:getType() == "WandererToken" then
                print(item:getType())
                moneyClipContainer:DoRemoveItem(item)
                runningTotal = runningTotal + 1
            end
        end

        local tokenBalance = modData.WandererTokenBalance or 0
        tokenBalance = tokenBalance + runningTotal
        modData.WandererTokenBalance = tokenBalance
        print("Consolidating Wanderer Tokens")
    end

    
end

function ConsolidateMoneyClip(moneyclip)
    ConsolidateCash(moneyclip)
    ConsolidateWandererTokens(moneyclip)
    ManualUpdateMoneyClipData(moneyclip)
end


------------------------------------------------------------------------
--                             TOOLTIP
------------------------------------------------------------------------

local oldRender = ISToolTipInv.render
function ISToolTipInv:render()   

    local itemType = self.item:getType()
    if not (itemType == "MoneyClip") then return oldRender(self) end

    if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then
        if not MoneyClipData then return end

        -- Call the original render function first to draw the original tooltip content
        oldRender(self)

        -- Update Owner Constantly
        local item = self.item
        updateMoneyClipOwner(item)

        -- Error Handling
        if MoneyClipData.Owner == nil then return end

        -- Limit Data Updates to Reduce Server Lag
        if recheckTimer then            
            AutoUpdateMoneyClipData(item)    
        end
        
        local player = getPlayer()
        local username = player:getUsername()  
        local blankString = " "
        
        -- Information Display Strings
        local moneyClipOwner        = MoneyClipData.Owner or blankString
        local smokeyPointBalance    = MoneyClipData.SmokeyPointBalance or 0
        local cashBalance           = MoneyClipData.CashBalance or 0
        local wandererTokenBalance  = MoneyClipData.WandererTokenBalance or 0
     

        ------------------------------------------------------------------------
        --                          RENDERING
        ------------------------------------------------------------------------

        -- Define Fonts
        local font = getCore():getOptionTooltipFont()
        local fontType = UIFont.Medium           
        local fontHeight = getTextManager():getFontHeight(fontType)

        -- Measure the text width and the tooltip's width
        
        local moneyClipOwnerTextWidth       = getTextManager():MeasureStringX(fontType, "Owner:  " .. moneyClipOwner)
        local smokeyPointBalanceTextWidth   = getTextManager():MeasureStringX(fontType, "Smokey Points:  $" .. Utils.CurrencyFormatter(smokeyPointBalance))
        local cashBalanceTextWidth          = getTextManager():MeasureStringX(fontType, "Cash Balance:  $" .. Utils.CurrencyFormatter(cashBalance))
        local wandererTokenBalanceTextWidth = getTextManager():MeasureStringX(fontType, "Wanderer Tokens:   " .. Utils.CurrencyFormatter(wandererTokenBalance))
        
        -- Tooltip Widths
        local tooltipWidth = self:getWidth()        
        local longestToolTip = math.max(moneyClipOwnerTextWidth, smokeyPointBalanceTextWidth, cashBalanceTextWidth, wandererTokenBalanceTextWidth)
        local startX = (tooltipWidth) + 10

        -- Render Tooltip
        if moneyClipOwner and (moneyClipOwner == username) then
            self:drawRect(tooltipWidth, 0, longestToolTip + 40, fontHeight * 3.5, 1, 0, 0, 0)
            self:drawRectBorder(tooltipWidth, 0, longestToolTip + 40, (fontHeight * 3.5) + 4, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
            self.tooltip:DrawText(fontType, "Smokey Points:  $" .. Utils.CurrencyFormatter(smokeyPointBalance), startX, 12, 1.0, 0.6, 0.11, 1)
            self.tooltip:DrawText(fontType, "Cash Balance:  $" .. Utils.CurrencyFormatter(cashBalance), startX, 28, 0.17255, 1.0, 0.01961, 1)
            self.tooltip:DrawText(fontType, "Wanderer Tokens:   " .. Utils.CurrencyFormatter(wandererTokenBalance), startX, 44, 0.0, 0.886, 1.0, 1)
            
        elseif moneyClipOwner and (moneyClipOwner ~= username) then
            if (getAccessLevel() == "admin") then
                self:drawRect(tooltipWidth, 0, moneyClipOwnerTextWidth + 60, fontHeight * 1.5, 1, 0, 0, 0)
                self:drawRectBorder(tooltipWidth, 0, moneyClipOwnerTextWidth + 60, (fontHeight * 1.5) + 4, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
                self.tooltip:DrawText(fontType, "Bound To:  " .. moneyClipOwner, startX, 6, 1.0, 0.6, 0.11, 1)
            end
        end     
    end
end
