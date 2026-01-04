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

require "ISUI/ISPanel"
local Utils = require "Gizmo/GN84LIB_Utils"



local SmokeyPointsUI = ISPanel:derive("SmokeyPointsUI")
SmokeyPointsUI.BuyType = {}
SmokeyPointsUI.DrawType = {}
SmokeyPointsUI.LoadType = {}


-- FONT DEFINITIONS
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)
local FONT_SCALE = FONT_HGT_SMALL / 14

-- ITEM TEXTURES
local BankTexture
local CashTexture
local TokenTexture

------------------------------------------------------------------------
--            GET PLAYER'S SMOKEY POINTS  & TOKEN COUNTS
------------------------------------------------------------------------

local function GetBankBalance(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if not SmokeyPointsUI then return end

    if module == "GN84-WNDR" and command == "get" then
        SmokeyPointsUI.instance.points = arguments[1]
    end
end

local function GetTokenBalance(module, command, arguments)
    if module ~= "GN84-WNDR" then return end

    if not SmokeyPointsUI then return end

    if module == "GN84-WNDR" and command == "getTokens" then
        SmokeyPointsUI.instance.tokens = arguments[1]
    end    
end


------------------------------------------------------------------------
--          SHOW SMOKEY POINTS WINDOW + REFRESH LISTINGS      
------------------------------------------------------------------------

function SmokeyPointsUI:setVisible(visible)
    if self.javaObject == nil then
        self:instantiate()
    end
    self.javaObject:setVisible(visible)    
    if visible then
        
        sendClientCommand("GN84-WNDR", "get", nil)
        sendClientCommand("GN84-WNDR", "getTokens", nil)
        SmokeyPointsUI.automaticRefresh()
    end
end

Events.OnServerCommand.Add(GetBankBalance)
Events.OnServerCommand.Add(GetTokenBalance)

------------------------------------------------------------------------
--                      ITEM LIST OBJECT      
------------------------------------------------------------------------

function SmokeyPointsUI.LoadType.ITEM(row, entry)    
    local item = getScriptManager():getItem(entry.target)
    if item then
        --print (item)
        row.quantity = entry.quantity or 1
        row.text = item:getDisplayName()
        row.texture = item:getNormalTexture()
    end
end

------------------------------------------------------------------------
--                         DIV LIST OBJECT
------------------------------------------------------------------------

function SmokeyPointsUI.LoadType.DIV(row, entry)
    row.target = row.target or {}
    if type(entry.target) == "string" then
        row.target = {}
        for text in entry.target:gmatch("([^\n]+)") do table.insert(row.target, text) end
    end
    row.font = row.height > #row.target * (FONT_HGT_LARGE + 1 * FONT_SCALE) and UIFont.Large or row.height > #row.target * (FONT_HGT_MEDIUM + 1 * FONT_SCALE) and UIFont.Medium or UIFont.Small
    row.fontHeight = getTextManager():getFontHeight(row.font)
end



------------------------------------------------------------------------
--                     LOAD LISTINGS INTO SHOP UI
------------------------------------------------------------------------

function SmokeyPointsUI.LoadListings(module, command, arguments)
    if module == "GN84-WNDR" and command == "load" then
        Events.OnServerCommand.Remove(SmokeyPointsUI.LoadListings)
        for k, v in pairs(arguments) do
            local scrollingList = ISScrollingListBox:new(1, 0, SmokeyPointsUI.instance.tabPanel.width - 2, SmokeyPointsUI.instance.tabPanel.height - SmokeyPointsUI.instance.tabPanel.tabHeight * 3)
            scrollingList.itemPadY = 10 * FONT_SCALE
            scrollingList.itemheight = FONT_HGT_LARGE + scrollingList.itemPadY * 2 + 1 * FONT_SCALE + FONT_HGT_SMALL
            scrollingList.textureHeight = scrollingList.itemheight - scrollingList.itemPadY * 2
            scrollingList.mouseoverselected = -1
            scrollingList:initialise()
            scrollingList.doDrawItem = SmokeyPointsUI.doDrawItem
            SmokeyPointsUI.instance.tabPanel:addView(k, scrollingList)

            for _, entry in ipairs(v) do
                local listItem = getScriptManager():getItem(tostring(entry.target))  -- Check if Item is Valid and Continue to next if not
                if listItem or entry.type == "DIV" then

                    
                    local row = scrollingList:addItem(entry.type, nil)
                    row.type = entry.type
                    row.target = entry.target
                    row.price = entry.price or 0
                    row.mult = entry.mult or 1.0
                    row.instock = entry.instock or "true"

                    if SmokeyPointsUI.LoadType[entry.type] then                        
                            SmokeyPointsUI.LoadType[entry.type](row, entry)                        
                    else
                        row.text = entry.type .. ":" .. tostring(entry.target)
                    end 
                end
            end
        end
    end
end


------------------------------------------------------------------------
--                    LOAD LISTINGS ON GAME START   
------------------------------------------------------------------------

local function OnTick()
    Events.OnTick.Remove(OnTick)
    Events.OnServerCommand.Add(SmokeyPointsUI.LoadListings)
    sendClientCommand("GN84-WNDR", "load", nil)
end





------------------------------------------------------------------------
--                CREATE MENU CHILDREN (TABPANEL, BUTTONS)
------------------------------------------------------------------------

function SmokeyPointsUI:createChildren()
    local z = 15 * FONT_SCALE * 2 + FONT_HGT_LARGE + 1
    local btnWid = 125 * FONT_SCALE
    local btnHgt = FONT_HGT_SMALL + 5 * 2 * FONT_SCALE
    local padBottom = 10 * FONT_SCALE

    self.tabPanel = ISTabPanel:new(0, z, self.width, self.height - z - padBottom - btnHgt - padBottom)
    self.tabPanel:initialise()
    self.tabPanel.tabFont = UIFont.Medium
    self.tabPanel.tabHeight = FONT_HGT_MEDIUM + 6
    self.tabPanel.render = self.tabPanelRender
    self.tabPanel.addView = self.addView
    self:addChild(self.tabPanel)
    Events.OnTick.Add(OnTick)
    
------------------------------------------------------------------------
--                          BUY BUTTON 
------------------------------------------------------------------------
    
    self.buyButton = ISButton:new(self.width - 120 * FONT_SCALE - padBottom, 0, 100 * FONT_SCALE, FONT_HGT_LARGE + 1 * FONT_SCALE + FONT_HGT_SMALL, "BUY", self, SmokeyPointsUI.onBuy)
    self.buyButton:initialise()
    self.buyButton:instantiate()
    self.buyButton.borderColor = self.buttonBorderColor
    self.buyButton:setVisible(false)
    self.buyButton.font = UIFont.Medium
    self:addChild(self.buyButton)

------------------------------------------------------------------------
--                        CLOSE UI BUTTON
------------------------------------------------------------------------
    
    self.cancelButton = ISButton:new(self.width - padBottom - btnWid, self.height - padBottom - btnHgt, btnWid, btnHgt, getText("UI_btn_close"), self, SmokeyPointsUI.close)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self:addChild(self.cancelButton)

------------------------------------------------------------------------
--                         RELOAD BUTTON     
------------------------------------------------------------------------
    
    self.reloadButton = ISButton:new(self.cancelButton.x - padBottom - btnWid, self.cancelButton.y, btnWid, btnHgt, "REFRESH LISTINGS", self, SmokeyPointsUI.onReload)
    self.reloadButton:initialise()
    self.reloadButton:instantiate()
    self:addChild(self.reloadButton)
   
end





------------------------------------------------------------------------
--                AUTO-CLOSE WINDOW WHEN NOT FOCUSED  
------------------------------------------------------------------------

function SmokeyPointsUI:autoCloseWindow()
    if not MainScreen.instance:isVisible() then
        if MainScreen.instance.SmokeyPoints:isVisible() then            
            MainScreen.instance.SmokeyPoints:setVisible(false)
        end  
    end
end

------------------------------------------------------------------------
--                    CLOSE / DESTROY WINDOW      
------------------------------------------------------------------------

function SmokeyPointsUI:close()
    self:setVisible(false) 
    SmokeyPointsUI:removeFromUIManager()
end



------------------------------------------------------------------------
--                SERVER COMMAND - FORCE REFRESH          
------------------------------------------------------------------------

function serverForceRefresh(module, command, player, args)
    if module == "GN84-WNDR" and command == "ServerForceRefresh" then
        SmokeyPointsUI.automaticRefresh()
        --print ("Server Updated Shop Listings")
    end
end

Events.OnServerCommand.Add(serverForceRefresh)




------------------------------------------------------------------------
--                 RELOAD LISTINGS - AUTOMATIC REFRESH 
------------------------------------------------------------------------

function SmokeyPointsUI:automaticRefresh()  
    if SmokeyPointsUI.instance ~= nil then
        if SmokeyPointsUI.instance.tabPanel.viewList ~= nil then
            for i, v in ipairs(SmokeyPointsUI.instance.tabPanel.viewList) do
                SmokeyPointsUI.instance.tabPanel:removeView(v.view)
            end
            Events.OnServerCommand.Add(SmokeyPointsUI.LoadListings)
            sendClientCommand("GN84-WNDR", "load", nil)
        end
    end 
end


------------------------------------------------------------------------
--                     RELOAD LISTINGS  - MANUAL
------------------------------------------------------------------------

function SmokeyPointsUI:onReload()    
    if self.instance ~= nil then    
        if self.instance.tabPanel.viewList ~= nil then
            for i, v in ipairs(self.tabPanel.viewList) do
                self.tabPanel:removeView(v.view)
            end
            Events.OnServerCommand.Add(SmokeyPointsUI.LoadListings)
            sendClientCommand("GN84-WNDR", "load", nil)
        end
    end
end


------------------------------------------------------------------------
--              ADD ITEMS TO PLAYER + PLAY PURCHASE SOUND        
------------------------------------------------------------------------

function SmokeyPointsUI.BuyType.ITEM(row)
    sendClientCommand("GN84-WNDR", "buy", { (row.price * row.mult), row.target })
    getPlayer():getInventory():AddItems(row.target, row.quantity)
    getSoundManager():PlaySound("CashRegisterSound", false, 1)
end

------------------------------------------------------------------------
--                 BUY BUTTON CLICKED - BUY COMMAND   
------------------------------------------------------------------------

function SmokeyPointsUI:onBuy()
    local row = self.tabPanel.activeView.view.items[self.tabPanel.activeView.view.mouseoverselected]
    self.points = self.points - (row.price * row.mult)
    if SmokeyPointsUI.BuyType[row.type] then
        SmokeyPointsUI.BuyType[row.type](row)
    end
    Events.OnServerCommand.Add(OnServerCommand)
    sendClientCommand("GN84-WNDR", "get", nil)
    sendClientCommand("GN84-WNDR", "getTokens", nil)
end




------------------------------------------------------------------------
--                          UI RENDERING    
------------------------------------------------------------------------
------------------------------------------------------------------------
--                        RENDER TAB PANEL
------------------------------------------------------------------------

function SmokeyPointsUI:tabPanelRender()
    local inset = 1 -- assumes a 1-pixel window border on the left to avoid

    local x = inset + self.scrollX
    local widthOfAllTabs = self:getWidthOfAllTabs()
    local overflowLeft = self.scrollX < 0
    local overflowRight = x + widthOfAllTabs > self.width

    if widthOfAllTabs > self.width then
        self:setStencilRect(0, 0, self.width, self.tabHeight)
    end

    for i, viewObject in ipairs(self.viewList) do
        local tabWidth = self.equalTabWidth and self.maxLength or viewObject.tabWidth
        -- if this tab is the active one, we make the tab btn lighter

        if viewObject == self.activeView then
            self:drawRect(x, 0, tabWidth, self.tabHeight, 1, 0.4, 0.4, 0.4)

        else
            self:drawRect(x + tabWidth, 0, 1, self.tabHeight, 1, 0.4, 0.4, 0.4)

            if self:getMouseY() >= 0 and self:getMouseY() < self.tabHeight and self:isMouseOver() and self:getTabIndexAtX(self:getMouseX()) == i then
                viewObject.fade:setFadeIn(true)
            else
                viewObject.fade:setFadeIn(false)
            end

            viewObject.fade:update()
            self:drawRect(x, 0, tabWidth, self.tabHeight, 0.2 * viewObject.fade:fraction(), 1, 1, 1)
        end

        self:drawTextCentre(viewObject.name, x + (tabWidth / 2), 3, 1, 1, 1, 1, self.tabFont)
        x = x + tabWidth
    end

    self:drawRect(0, self.tabHeight - 1, self.width, 1, 1, 0.4, 0.4, 0.4)
    local butPadX = 3

    if overflowLeft then
        local tex = getTexture("media/ui/ArrowLeft.png")
        local butWid = tex:getWidthOrig() + butPadX * 2

        self:drawRect(inset, 0, butWid, self.tabHeight - 1, 1, 0, 0, 0)
        self:drawRectBorder(inset, -1, butWid, self.tabHeight + 1, 1, 0.4, 0.4, 0.4)
        self:drawTexture(tex, inset + butPadX, (self.tabHeight - tex:getHeightOrig()) / 2, 1, 1, 1, 1)
    end

    if overflowRight then
        local tex = getTexture("media/ui/ArrowRight.png")
        local butWid = tex:getWidthOrig() + butPadX * 2

        self:drawRect(self.width - inset - butWid, 0, butWid, self.tabHeight - 1, 1, 0, 0, 0)
        self:drawRectBorder(self.width - inset - butWid, -1, butWid, self.tabHeight + 1, 1, 0.4, 0.4, 0.4)
        self:drawTexture(tex, self.width - butWid + butPadX, (self.tabHeight - tex:getHeightOrig()) / 2, 1, 1, 1, 1)
    end

    if widthOfAllTabs > self.width then
        self:clearStencilRect()
    end

    self:drawRect(0, self.height, self.width, 1, 1, 0.4, 0.4, 0.4)
end


------------------------------------------------------------------------
--                     RENDER OBJECTS IN LIST   
------------------------------------------------------------------------
function SmokeyPointsUI:addView(name, view)
    local viewObject = {}
    viewObject.name = name
    viewObject.view = view
    viewObject.tabWidth = getTextManager():MeasureStringX(self.tabFont, name) + self.tabPadX
    viewObject.fade = UITransition.new()

    table.insert(self.viewList, viewObject)
    view:setY(self.tabHeight * 3)
    self:addChild(view)
    view.parent = self

    if #self.viewList == 1 then
        view:setVisible(true)
        self.activeView = viewObject
        self.maxLength = viewObject.tabWidth

    else
        view:setVisible(false)

        if viewObject.tabWidth > self.maxLength then
            self.maxLength = viewObject.tabWidth
        end
    end
end


------------------------------------------------------------------------
--                       RENDER OBJECT - DIV   
------------------------------------------------------------------------

function SmokeyPointsUI.DrawType.DIV(self, y, item, alt)
    self:drawRectBorder(0, y, self:getWidth(), item.height, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    y = y + (item.height - #item.target * item.fontHeight) / 2

    for i, v in ipairs(item.target) do
        self:drawTextCentre(v, self.width / 2, y, 0.7, 0.7, 0.7, 1.0, item.font)
        y = y + item.fontHeight + 1 * FONT_SCALE
    end
end

------------------------------------------------------------------------
--                       RENDER OBJECT - ITEM
------------------------------------------------------------------------

function SmokeyPointsUI.DrawType.DEFAULT(self, y, item, alt)
    self:drawRectBorder(0, y, self:getWidth(), item.height, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    local x = self.itemPadY
    local z = y + self.itemPadY

    if item.texture then
        self:drawTextureScaledAspect2(item.texture, x, z, self.textureHeight, self.textureHeight, 1, 1, 1, 1)
    end

    x = x + self.itemPadY + self.textureHeight

    if item.quantity then
        self:drawText("Quantity:  ", x, z + FONT_HGT_LARGE + 1 * FONT_SCALE, 0.7, 0.7, 0.7, 1.0, UIFont.Medium)
        self:drawText(tostring(item.quantity), x + getTextManager():MeasureStringX(UIFont.Medium, "Quantity:  "), z + FONT_HGT_LARGE + 1 * FONT_SCALE, 0.7, 0.7, 0.7, 1.0, UIFont.Medium)
    else
        z = y + (item.height - FONT_HGT_LARGE) / 2
    end

    self:drawText(item.text, x, z, 0.7, 0.7, 0.7, 1.0, self.font)

    -- PRICE TAB WIDTH
    x = self.width - 215
    z = y + (item.height - FONT_HGT_LARGE) / 2

    -- CHECK FOR OUT OF STOCK ITEMS
    if item.instock == "false" then
        self:drawText("OUT OF STOCK", x, z, 0.871, 0.478, 0.341, 1.0, self.font) -- Out of Stock

    elseif SmokeyPointsUI.instance.points < (item.price * item.mult) then
        self:drawText("$" .. tostring(Utils.CurrencyFormatter(item.price * item.mult)), x, z, 0.733, 0.247, 0.215, 1.0, self.font) -- Insufficient Funds
    else   
        if item.mult > 1.0 then
            self:drawText("$" .. tostring(Utils.CurrencyFormatter(item.price * item.mult)), x, z, 0.871, 0.655, 0.341, 1.0, self.font) -- Overpriced
        elseif item.mult < 1.0 then
            self:drawText("$" .. tostring(Utils.CurrencyFormatter(item.price * item.mult)), x, z, 0.655, 0.871, 0.341, 1.0, self.font) -- Discounted
        else
            self:drawText("$" .. tostring(Utils.CurrencyFormatter(item.price * item.mult)), x, z, 0.905, 0.909, 0.898, 1.0, self.font) -- Standard Price
        end
    end
end

function SmokeyPointsUI:doDrawItem(y, item, alt)

    if SmokeyPointsUI.DrawType[item.type] then
        SmokeyPointsUI.DrawType[item.type](self, y, item, alt)

    else
        SmokeyPointsUI.DrawType.DEFAULT(self, y, item, alt)

    end

    return y + item.height
end


------------------------------------------------------------------------
--                       RENDER MAIN PANEL   
------------------------------------------------------------------------

function SmokeyPointsUI:render()

    if BankTexture == nil then
        local BankCard = InventoryItemFactory.CreateItem("GN84-WNDR.BankBalance")
        BankTexture = BankCard:getTexture()
    end
    
    if TokenTexture == nil then
        local TokenItem = InventoryItemFactory.CreateItem("GN84-WNDR.WandererTokenStack100")
        TokenTexture = TokenItem:getTexture()
    end

    local titleLength = getTextManager():MeasureStringX(UIFont.Large, self.title)

    local z = 15 * FONT_SCALE
    self:drawText(self.title, (self.width / 2) - (titleLength / 2), z, 1, 1, 1, 1, UIFont.Large)

    z = z + FONT_HGT_LARGE + z
    local x = self.width - 10 * FONT_SCALE - FONT_HGT_LARGE

    -- Draw Wanderer Token Icon & Token Bank Balance
    self:drawTextureScaledAspect2(TokenTexture, 20, (z - FONT_HGT_LARGE) / 2, FONT_HGT_LARGE, FONT_HGT_LARGE, 1, 1, 1, 1)
    local tokenBalanceLength = getTextManager():MeasureStringX(UIFont.Medium, "Token Balance:    " .. tostring(Utils.CurrencyFormatter(self.tokens)) .. "     ")
    self:drawText("Token Balance:    " .. tostring(Utils.CurrencyFormatter(self.tokens)) .. "     ", 60, (z - FONT_HGT_MEDIUM) / 2, 0.0, 0.886, 1.0, 1, UIFont.Large)

    -- Draw Bank Card Icon & Smokey Bank Balance
    self:drawTextureScaledAspect2(BankTexture, x-10, (z - FONT_HGT_LARGE) / 2, FONT_HGT_LARGE, FONT_HGT_LARGE, 1, 1, 1, 1)
    x = x - (3 * FONT_SCALE) - getTextManager():MeasureStringX(UIFont.Medium, "Bank Balance:   $" .. tostring(Utils.CurrencyFormatter(self.points)) .. "     ")
    self:drawText("Bank Balance:   $" .. tostring(Utils.CurrencyFormatter(self.points)) .. "     ", x - 40, (z - FONT_HGT_MEDIUM) / 2, 1.0, 0.66, 0.11, 1, UIFont.Large)

    self:drawRect(0, z, self.width, 1, 1, 0.4, 0.4, 0.4)
    self:drawText(self.serverMsg, 10 * FONT_SCALE, self.tabPanel:getBottom() + 1 + 10 * FONT_SCALE, 1, 1, 1, 1, UIFont.Medium)

    local view = self.tabPanel.activeView
    if view then view = view.view else return end



    -- MOUSEOVER SHOW BUY BUTTON
    if view.mouseoverselected == -1 then
        self.buyButton:setVisible(false)        
    else
        local row = view.items[view.mouseoverselected]
        z = (view.mouseoverselected - 1) * view.itemheight + view:getYScroll() + view.itemPadY + view.y + view.parent.y

        if SmokeyPointsUI.BuyType[row.type] then
            self.buyButton:setY(z)
            self.buyButton:setVisible(true)

            if row.instock == "false" then
                self.buyButton:setEnable(false)
                self.buyButton:setVisible(false)

            elseif self.points < (row.price * row.mult) then
                self.buyButton:setEnable(false)

            else
                self.buyButton:setEnable(true)

            end
        else
            self.buyButton:setVisible(false)

        end        
    end
end


------------------------------------------------------------------------
--                         CONSTRUCTOR   
------------------------------------------------------------------------
function SmokeyPointsUI:new(x, y, width, height)
    local o = ISPanel:new(x, y, width + 100, height + 100)
    setmetatable(o, self)
    self.__index = self
    o.variableColor = { r = 0.9, g = 0.55, b = 0.1, a = 1 }
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }    
    o.title = "    THE SMOKEY SHOP"
    o.available = " Bank Balance     "
    o.serverMsg = SandboxVars.GN84WNDR.ServerMessage
    o.points = 0
    o.tokens = 0

    SmokeyPointsUI.instance = o
    return o
end

return SmokeyPointsUI
