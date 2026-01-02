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

local WandererTokensAdminPanel = ISPanel:derive("WandererTokensAdminPanel")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_SCALE = FONT_HGT_SMALL / 14


local function OnServerCommand(module, command, arguments)
    if module == "GN84-WNDR" and command == "getTokens" then
        WandererTokensAdminPanel.instance.balance = "Balance:   " .. tostring(arguments[1])
        Events.OnServerCommand.Remove(OnServerCommand)
    end
end

function WandererTokensAdminPanel:createChildren()
    local btnWid = 125 * FONT_SCALE
    local btnHgt = FONT_HGT_SMALL + 5 * 2 * FONT_SCALE
    local padBottom = 10 * FONT_SCALE

    local x = padBottom + getTextManager():MeasureStringX(UIFont.Medium, "Player:") + padBottom
    self.playerSelect = ISComboBox:new(x, padBottom * 2 + FONT_HGT_MEDIUM, self.width - x - padBottom, btnHgt, nil, function(_, combo)
        Events.OnServerCommand.Add(OnServerCommand)
        sendClientCommand("GN84-WNDR", "getTokens", { combo.options[combo.selected] })
    end)

    self.playerSelect:initialise()
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        self.playerSelect:addOption(players:get(i):getUsername())
    end
    table.sort(self.playerSelect.options)
    self.playerSelect.selected = 1
    Events.OnServerCommand.Add(OnServerCommand)
    sendClientCommand("GN84-WNDR", "getTokens", { self.playerSelect.options[self.playerSelect.selected] })
    self:addChild(self.playerSelect)

    local z = self.playerSelect.y + self.playerSelect.height + padBottom + FONT_HGT_MEDIUM + padBottom * 2
    self.pointsEntry = ISTextEntryBox:new("0", (self.width - btnWid) / 2, z, btnWid, FONT_HGT_SMALL + 4)
    self.pointsEntry:initialise()
    self.pointsEntry:instantiate()
    self.pointsEntry:setMaxTextLength(9)
    self.pointsEntry:setOnlyNumbers(true)
    self:addChild(self.pointsEntry)

    z = self.pointsEntry.y + self.pointsEntry.height + padBottom
    self.addButton = ISButton:new((self.width - btnWid) / 2 - 5, z, btnWid / 2, btnHgt, "GIVE", self, WandererTokensAdminPanel.onOptionMouseDown)
    self.addButton.internal = "GIVE"
    self.addButton:initialise()
    self.addButton:instantiate()
    self:addChild(self.addButton)

    self.takeButton = ISButton:new(self.width / 2 + 5, z, btnWid / 2, btnHgt, "TAKE", self, WandererTokensAdminPanel.onOptionMouseDown)
    self.takeButton.internal = "TAKE"
    self.takeButton:initialise()
    self.takeButton:instantiate()
    self:addChild(self.takeButton)

    self.cancelButton = ISButton:new((self.width - btnWid) / 2, self.height - padBottom - btnHgt, btnWid, btnHgt, getText("UI_btn_close"), self, WandererTokensAdminPanel.close)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self:addChild(self.cancelButton)

    self.reloadButton = ISButton:new(self.cancelButton.x, self.cancelButton.y - padBottom - btnHgt, btnWid, btnHgt, "RELOAD CONFIG", nil, WandererTokensAdminPanel.onReload)
    self.reloadButton:initialise()
    self.reloadButton:instantiate()
    self:addChild(self.reloadButton)
end

function WandererTokensAdminPanel:render()
    self:drawTextCentre("Wanderer Tokens Panel", self.width / 2, 10 * FONT_SCALE, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Player:", 10 * FONT_SCALE, self.playerSelect.y + (self.playerSelect.height - FONT_HGT_MEDIUM) / 2, 1, 1, 1, 1, UIFont.Medium)
    self:drawText(Utils.CurrencyFormatter(self.balance), 12 * FONT_SCALE, self.playerSelect.y + self.playerSelect.height + 10 * FONT_SCALE, 1, 1, 1, 1, UIFont.Medium)
end

function WandererTokensAdminPanel:onOptionMouseDown(button)
    if button.internal == "GIVE" then
        sendClientCommand("GN84-WNDR", "addTokens", { self.playerSelect:getSelectedText(), tonumber(self.pointsEntry:getText()) })
    elseif button.internal == "TAKE" then
        sendClientCommand("GN84-WNDR", "addTokens", { self.playerSelect:getSelectedText(), -tonumber(self.pointsEntry:getText()) })
    end
    Events.OnServerCommand.Add(OnServerCommand)
    sendClientCommand("GN84-WNDR", "getTokens", { self.playerSelect.options[self.playerSelect.selected] })
end



function WandererTokensAdminPanel.onReload()
    sendClientCommand("GN84-WNDR", "reload", nil)
end

function WandererTokensAdminPanel:close()
    self:setVisible(false)
    self:removeFromUIManager()
    WandererTokensAdminPanel.instance = nil
end

function WandererTokensAdminPanel:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.moveWithMouse = true
    o.balance = "Balance:  0"
    WandererTokensAdminPanel.instance = o
    return o
end

local function openUI(button)
    if WandererTokensAdminPanel.instance then
        WandererTokensAdminPanel.instance:close()
    end
    local core = getCore()
    local width = 250 * FONT_SCALE
    local height = 270 * FONT_SCALE
    local ui = WandererTokensAdminPanel:new((core:getScreenWidth() - width) / 2, (core:getScreenHeight() - height) / 2, width, height)
    ui:initialise()
    ui:addToUIManager()
end

local oldISAdminPanelUI_create = ISAdminPanelUI.create
function ISAdminPanelUI:create()
    oldISAdminPanelUI_create(self)

    if getAccessLevel() == "admin" then
        local lastButton = self.children[self.IDMax-1].internal == "CANCEL" and self.children[self.IDMax-2] or self.children[self.IDMax-1]
        self.WandererTokensBtn = ISButton:new(lastButton.x, lastButton.y + 5 + lastButton.height, self.sandboxOptionsBtn.width, self.sandboxOptionsBtn.height, "Wanderer Tokens Panel", nil, openUI)
        self.WandererTokensBtn.internal = "WANDERERTOKENSPANEL"
        self.WandererTokensBtn:initialise()
        self.WandererTokensBtn:instantiate()
        self.WandererTokensBtn.borderColor = self.buttonBorderColor
        self:addChild(self.WandererTokensBtn)
    end
end
