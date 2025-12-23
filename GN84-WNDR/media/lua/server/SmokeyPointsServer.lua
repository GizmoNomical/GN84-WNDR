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
-- ##                                      The Wanderers Core                                             ##
-- #########################################################################################################
-- #########################################################################################################

local Utils = require "Gizmo/GN84LIB_Utils"


function Recipe.OnCreate.RedeemPoints(items, result, player)
    local points = items:get(0):getModData().serverPoints or 0
    sendClientCommand("GN84-WNDR", "add", { player:getUsername(), points })
    player:Say("Redeemed " .. points .. " " .. SandboxVars.GN84WNDR.PointsName)
end

if not isServer() then return end

local smokeyPointsData
local listings
local oldListings

------------------------------------------------------------------------
--                          ANSI PRINTER INIT
------------------------------------------------------------------------

local ANSIPrinter = require 'asledgehammer/util/ANSIPrinter'

local mod = 'The Wanderers'
local printer = ANSIPrinter:new(mod, { boolean = true})
local info = function(message, ...) printer:info(message, ...) end
local success = function(message, ...) printer:success(message, ...) end
local warn = function(message, ...) printer:warn(message, ...) end
local error = function(message, ...) printer:error(message, ...) end
local fatal = function(message, ...) printer:fatal(message, ...) end
local printf = function(message, ...) printer:printf(message, ...) end



------------------------------------------------------------------------
--            PLAYER POINTS PER TICK + SLEEP EXPLOIT REMOVAL
------------------------------------------------------------------------


local function PointsTick()
    local players = getOnlinePlayers()
    if IsoPlayer.allPlayersAsleep() then
        --print ("All Players Sleeping..")
        return    
    end    
    for i = 0, players:size() - 1 do
        if not players:get(i):isAsleep() then 
            --print (players:get(i), " is awake.")
            local username = players:get(i):getUsername()
            if not smokeyPointsData[username] then smokeyPointsData[username] = 0 end
            smokeyPointsData[username] = smokeyPointsData[username] + SandboxVars.GN84WNDR.PointsPerTick
            --print ("Adding Points to:", players:get(i))
        else
            --print (players:get(i), "is sleeping...")
        end        
    end
end


------------------------------------------------------------------------
--                LOAD SMOKEY POINT LISTINGS FROM FILE
------------------------------------------------------------------------

local function LoadListings()
    local fileReader = getFileReader("SmokeyShopListings.ini", true)
    local lines = {}
    local line = fileReader:readLine()
    while line do
        table.insert(lines, line)
        line = fileReader:readLine()
    end
    fileReader:close()
    listings = loadstring(table.concat(lines, "\n"))() or { ["Missing Configuration"] = {} }

    
    local sameContents = true        
    for i, value in ipairs(lines) do
        -- print (lines[i])
        if oldListings ~= nil then
            if  value ~= oldListings[i] then
                sameContents = false
                break
            end
        end        
    end

    if sameContents then
        --print ("listings are the same")
    else
        print ("Smokey Shop Listings Updated") 
        sendServerCommand("GN84-WNDR", "ServerForceRefresh", nil)        
    end

    oldListings = lines    
    
end




------------------------------------------------------------------------
--             FORCE SERVER RELOAD OF LISTINGS ON A TIMER
------------------------------------------------------------------------

Events.EveryTenMinutes.Add(LoadListings)

Events.OnInitGlobalModData.Add(function(isNewGame)
    smokeyPointsData = ModData.getOrCreate("smokeyPointsData")

    LoadListings()

    if SandboxVars.GN84WNDR.PointsFrequency == 2 then
        Events.EveryTenMinutes.Add(PointsTick)
    elseif SandboxVars.GN84WNDR.PointsFrequency == 3 then
        Events.EveryHours.Add(PointsTick)
    elseif SandboxVars.GN84WNDR.PointsFrequency == 4 then
        Events.EveryDays.Add(PointsTick)
    end
end)

local ServerPointsCommands = {}

function ServerPointsCommands.get(module, command, player, args)
    sendServerCommand(player, module, command, { smokeyPointsData[args and args[1] or player:getUsername()] or 0 })
end


------------------------------------------------------------------------
--                 PLAYER PURCHASE FROM SMOKEY SHOP
------------------------------------------------------------------------
function ServerPointsCommands.buy(module, command, player, args)
    print("###############")
    print(string.format("[SMOKEY SHOP]          %s bought %s for $%s Smokey Points", player:getUsername(), ScriptManager.instance:getItem(args[2]):getDisplayName(), Utils.CurrencyFormatter(args[1])))
    
    if not smokeyPointsData[player:getUsername()] then smokeyPointsData[player:getUsername()] = 0 end
    smokeyPointsData[player:getUsername()] = smokeyPointsData[player:getUsername()] - math.abs(args[1])

    print("[SMOKEY POINTS]        Balance:  $" .. Utils.CurrencyFormatter(smokeyPointsData[player:getUsername()]) .. " Smokey Points!")
    print("###############")
end



------------------------------------------------------------------------
--                  ADMIN PANEL - GIVE SMOKEY POINTS
------------------------------------------------------------------------

function ServerPointsCommands.add(module, command, player, args)
    --BACKUP - ORIGINAL WITHOUT ANSI
    
    print("###############")
    print(string.format("[SMOKEY POINTS]        %s gave %s $%s Smokey Points", player:getUsername(), args[1], Utils.CurrencyFormatter(args[2])))
    
    if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
    smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]

    print("[SMOKEY POINTS]        Balance:  $" .. Utils.CurrencyFormatter(smokeyPointsData[args[1]]) .. " Smokey Points!")
    print("###############")

    -- TEST ANSI CODE
    -- printf("###############", ANSIPrinter.KEYS['bright'] .. ANSIPrinter.KEYS['green'])
    -- printf(string.format("[SMOKEY POINTS]          %s gave %s %s Smokey Points", player:getUsername(), args[1], Utils.CurrencyFormatter(args[2])))
    
    -- if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
    -- smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]

    -- printf("[SMOKEY POINTS] ", "Balance: " .. Utils.CurrencyFormatter(smokeyPointsData[args[1]]) .. " Smokey Points!")
    -- printf("###############")

end



------------------------------------------------------------------------
--                    PER ZOMBIE - SMOKEY POINTS
------------------------------------------------------------------------

function ServerPointsCommands.zombieKillPts(module, command, player, args)   
   if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
   smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]      
end



------------------------------------------------------------------------
--                     REDEEM CASH FOR SMOKEY POINTS
------------------------------------------------------------------------

function ServerPointsCommands.redeemCash(module, command, player, args)
   print("###############")
   print("[SMOKEY POINTS]        " .. args[1] .. " redeemed $" .. Utils.CurrencyFormatter(args[2]) .. " dollars for Smokey Points!")      
   
    if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
   smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]
   
   print("[SMOKEY POINTS]        Balance:  $" .. Utils.CurrencyFormatter(smokeyPointsData[args[1]]) .. " Smokey Points!")
   print("###############")

end


------------------------------------------------------------------------
--                 REDEEM LOTTO TICKET FOR SMOKEY POINTS
------------------------------------------------------------------------

function ServerPointsCommands.redeemLottoTicket(module, command, player, args)
    print("###############")
    print("[WANDERERS LOTTO]      " .. args[1] .. " redeemed Winning Lotto Ticket for $" .. Utils.CurrencyFormatter(args[2]) .. " Smokey Points!")
    
    if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
    smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]

    print("[SMOKEY POINTS]        Balance:  $" .. Utils.CurrencyFormatter(smokeyPointsData[args[1]]) .. " Smokey Points!")
    print("###############")
 end



------------------------------------------------------------------------
--                          LOTTO BONUS PRIZE
------------------------------------------------------------------------

function ServerPointsCommands.redeemLottoTicketBonusPrize(module, command, player, args)
    print("###############")
    print("[ BONUS PRIZE ]        " .. args[1] .. " won a Bonus Prize - " .. args[2])
    print("###############")    
 end



------------------------------------------------------------------------
--            REDEEM VIP TOKEN FOR SMOKEY POINTS - DEPRECATED
------------------------------------------------------------------------

function ServerPointsCommands.redeemVIPToken(module, command, player, args)
    print("###############")
    print("[VIP TOKENS]           " .. args[1] .. " redeemed VIP Token for $" .. Utils.CurrencyFormatter(args[2]) .. " Smokey Points!")
        
    if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
    smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]

    print("[SMOKEY POINTS]        Balance:  $" .. Utils.CurrencyFormatter(smokeyPointsData[args[1]]) .. " Smokey Points!")
    print("###############")
 end



------------------------------------------------------------------------
--                REDEEM WANDERER TOKEN FOR SMOKEY POINTS
------------------------------------------------------------------------

function ServerPointsCommands.redeemWandererToken(module, command, player, args)
    print("#################")
    print("[WANDERER TOKENS]      " .. args[1] .. " redeemed WANDERER Token for $" .. Utils.CurrencyFormatter(args[2]) .. " Smokey Points!")
        
    if not smokeyPointsData[args[1]] then smokeyPointsData[args[1]] = 0 end
    smokeyPointsData[args[1]] = smokeyPointsData[args[1]] + args[2]

    print("[SMOKEY POINTS]        Balance:  $" .. Utils.CurrencyFormatter(smokeyPointsData[args[1]]) .. " Smokey Points!")
    print("###############")
 end


------------------------------------------------------------------------

function ServerPointsCommands.load(module, command, player, args)
    sendServerCommand(player, module, command, listings)
end

function ServerPointsCommands.reload(module, command, player, args)
    LoadListings()
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module == "GN84-WNDR" and ServerPointsCommands[command] then
        ServerPointsCommands[command](module, command, player, args)
    end
end)

return ServerPointsCommands