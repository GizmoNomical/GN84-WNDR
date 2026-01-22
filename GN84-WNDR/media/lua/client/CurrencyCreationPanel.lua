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
-- ##                                           GN84-WNDR                                                  ##
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################

local Utils = require "Gizmo/GN84LIB_Utils"

require "WandererTokensAdminPanel"

------------------------------------------------------------------------
--                  CREATE CUSTOM STACK OF CASH       
------------------------------------------------------------------------


local function CreateCash(amount)
    if not amount then return end

    local player = getPlayer()
    if not player then return end
    
    -- Instantiate MoneyStackX Item
    local moneyStackX = InventoryItemFactory.CreateItem("GN84-WNDR.MoneyStackX")
    player:getInventory():AddItem(moneyStackX)

    local moneyStackData = moneyStackX:getModData()
    if not moneyStackData then return end

    -- Set Money Stack Amount in modData
    moneyStackData.CashAmount = amount

    -- Rename Money Stack to Reflect Cash Amount
    moneyStackX:setName(moneyStackX:getName() .. "  -  $" .. Utils.CurrencyFormatter(moneyStackData.CashAmount))    
end



------------------------------------------------------------------------
--               CREATE CUSTOM STACK OF WANDERER TOKENS    
------------------------------------------------------------------------


local function CreateTokens(amount)
    if not amount then return end

    local player = getPlayer()
    if not player then return end
    
    local tokenStackX = InventoryItemFactory.CreateItem("GN84-WNDR.WandererTokenStackX")
    player:getInventory():AddItem(tokenStackX)

    local tokenStackXData = tokenStackX:getModData()
    if not tokenStackXData then return end

    -- Set Money Stack Amount in modData
    tokenStackXData.TokenAmount = amount

    -- Rename Money Stack to Reflect Cash Amount
    tokenStackX:setName(tokenStackX:getName() .. "  -  " .. Utils.CurrencyFormatter(tokenStackXData.TokenAmount))
end


------------------------------------------------------------------------
--                    CURRENCY CREATION PANEL UI   
------------------------------------------------------------------------

local CurrencyCreationPanel = ISPanel:derive("CurrencyCreationPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_SCALE = FONT_HGT_SMALL / 14

local buttonBorderColorDisabled = {r=1.0, g=0.0, b=0.0, a=0.5}           -- RED
local buttonBorderColorEnabled  = {r=0.0, g=1.0, b=0.0, a=0.75}          -- GREEN
local buttonBorderColorActive   = {r=0.341, g=0.561, b=0.875, a=1.0}     -- BLUE
local buttonBorderColorCaution  = {r=0.874, g=0.560, b=0.341, a=1.0}     -- ORANGE


function CurrencyCreationPanel:createChildren()
    local btnWid = 125 * FONT_SCALE
    local btnHgt = FONT_HGT_SMALL + 5 * 2 * FONT_SCALE
    local padBottom = 10 * FONT_SCALE

    self.currencyType = ISComboBox:new(self.width / 2 - 30, 80, 60, btnHgt, self)
    self.currencyType:initialise()
    self.currencyType:instantiate()
    self:addChild(self.currencyType)
    self.currencyType:addOption("Cash")
    self.currencyType:addOption("Token")

    local z = (self.currencyType.y + self.currencyType.height * 2.25) + padBottom
    self.pointsEntry = ISTextEntryBox:new("0", (self.width) / 2 - (btnWid - 20) / 2, z, btnWid-20, FONT_HGT_SMALL + 4)
    self.pointsEntry:initialise()
    self.pointsEntry:instantiate()
    self.pointsEntry:setMaxTextLength(13)
    self.pointsEntry:setOnlyNumbers(true)
    self:addChild(self.pointsEntry)

    z = self.pointsEntry.y + self.pointsEntry.height + padBottom * 2
    self.createButton = ISButton:new((self.width) / 2 - (btnWid - 20) / 2, z, btnWid-20, btnHgt, "Create Currency", self, CurrencyCreationPanel.onOptionMouseDown)
    self.createButton.internal = "CREATE"
    self.createButton:initialise()
    self.createButton:instantiate()
    self:addChild(self.createButton)


    self.cancelButton = ISButton:new((self.width - btnWid) / 2, self.height - padBottom - btnHgt, btnWid, btnHgt, getText("UI_btn_close"), self, CurrencyCreationPanel.close)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self:addChild(self.cancelButton)
end

function CurrencyCreationPanel:render()
    local padBottom = 10 * FONT_SCALE
    self:drawTextCentre("Currency Creation Panel", self.width / 2, 10 * FONT_SCALE, 1, 1, 1, 1, UIFont.Medium)    
    self:drawTextCentre("Currency Type", self.width / 2, 50, 1, 1, 1, 1, UIFont.Medium)    
    local z = self.currencyType.y + self.currencyType.height * 1.25 + padBottom
    self:drawTextCentre("Amount", self.width / 2, z, 1, 1, 1, 1, UIFont.Medium)    

    local currencyAmount = tonumber(self.pointsEntry:getInternalText()) or 0
    if currencyAmount == 0 or self.pointsEntry:getInternalText() == "" then
        self.createButton.borderColor = buttonBorderColorDisabled
        self.createButton:setTooltip("Please enter a valid number")    
    elseif currencyAmount > 0 then
        self.createButton.borderColor = buttonBorderColorEnabled
        self.createButton:setTooltip("Create Currency")
    end

    if self.currencyType:getSelectedText() == "Cash" then
        self.pointsEntry:setMaxTextLength(13)
        self.createButton.title = "Create Cash"
    elseif self.currencyType:getSelectedText() == "Token" then
        self.pointsEntry:setMaxTextLength(6)
        self.createButton.title = "Create Tokens"
    end
end

function CurrencyCreationPanel:onOptionMouseDown(button)
    if button.internal == "CREATE" then        
        local currencyType = self.currencyType:getSelectedText() or nil
        local amount = tonumber(self.pointsEntry:getInternalText()) or 0

        if amount > 0 and currencyType ~= nil then
            print("Creating Currency")
            if currencyType == "Cash" then
                CreateCash(amount)
            elseif currencyType == "Token" then
                CreateTokens(amount)
            end            
        end
    end    
end

function CurrencyCreationPanel:close()
    self:setVisible(false)
    self:removeFromUIManager()
    CurrencyCreationPanel.instance = nil
end

function CurrencyCreationPanel:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.moveWithMouse = true
    CurrencyCreationPanel.instance = o
    return o
end

local function openUI(button)
    if CurrencyCreationPanel.instance then
        CurrencyCreationPanel.instance:close()
    end
    local core = getCore()
    local width = 250 * FONT_SCALE
    local height = 270 * FONT_SCALE
    local ui = CurrencyCreationPanel:new((core:getScreenWidth() - width) / 2, (core:getScreenHeight() - height) / 2, width, height)
    ui:initialise()
    ui:addToUIManager()
end

local oldISAdminPanelUI_create = ISAdminPanelUI.create
function ISAdminPanelUI:create()
    oldISAdminPanelUI_create(self)

    if getAccessLevel() == "admin" then
        local lastButton = self.children[self.IDMax-1].internal == "CANCEL" and self.children[self.IDMax-2] or self.children[self.IDMax-1]
        self.CurrencyCreationPanelBtn = ISButton:new(lastButton.x, lastButton.y + 5 + lastButton.height, self.sandboxOptionsBtn.width, self.sandboxOptionsBtn.height, "Currency Creation Panel", nil, openUI)
        self.CurrencyCreationPanelBtn.internal = "CURRENCYCREATIONPANEL"
        self.CurrencyCreationPanelBtn:initialise()
        self.CurrencyCreationPanelBtn:instantiate()
        self.CurrencyCreationPanelBtn.borderColor = self.buttonBorderColor
        self:addChild(self.CurrencyCreationPanelBtn)
    end
end
