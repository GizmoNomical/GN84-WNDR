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
-- ##                                           GN84-WND                                                  ##
-- ##                                       The Wanderers Core                                            ##
-- #########################################################################################################
-- #########################################################################################################

------------------------------------------------------------------------
--                  SAFEHOUSE VALIDATION & CLAIMING
------------------------------------------------------------------------

local residentialPermitSmall = SandboxVars.GN84WND.ResidentialPermitSmall or 1500
local residentialPermitLarge = SandboxVars.GN84WND.ResidentialPermitLarge or 3500
local residentialPermitMansion = SandboxVars.GN84WND.ResidentialPermitMansion or 7500
local factionPermitSmall = SandboxVars.GN84WND.FactionPermitSmall or 10000
local factionPermitLarge = SandboxVars.GN84WND.FactionPermitLarge or 25000
local factionPermitMassive = SandboxVars.GN84WND.FactionPermitMassive or 50000

local function CalculateBuildingSize(worldobjects, square, player)	
	
	local player = getPlayer()	

    local buildingSqFootage = nil

    local isResidential = nil
    local isFlaggedResidential = nil
    local hasBedroom = nil
    local hasLivingRoom = nil
	
    -- ERROR HANDLING - CHECK IF NOT ON THE MAP / MOVING
    if player:getSquare() == nil then
        return nil, nil
    end

    -- ERROR HANDLING - CHECK IF NOT IN BUILDING
	if player:getSquare():getBuilding() == nil then			
        player:Say("Error: Not In Building")
        return nil, nil
    end
	

    -- GET BUILDING DEFINITION AND ID
	local buildingDef = player:getSquare():getBuilding():getDef()
    local buildingID = player:getSquare():getBuilding()
    

    -- Double Check if player is still in a building
	if (buildingDef == nil) or (buildingID == nil) then 
        print ("Error: No Building Def") 
        player:Say("Error: No Building Def")
        return nil, nil
    end

	if buildingDef then
			
            -- CHECK IF BUILDING IS RESIDENTIAL
            isFlaggedResidential = buildingID:isResidential()
            hasBedroom = buildingDef:containsRoom("bedroom")
            hasLivingRoom = buildingDef:containsRoom("livingroom")

            -- print("Flagged Residential: ", isFlaggedResidential)
            -- print("Has Kitchen: ", hasKitchen)
            -- print("Has Bedroom: ", hasBedroom)
            -- print("Has Living Room: ", hasLivingRoom)

            if isFlaggedResidential then
                isResidential = true
            elseif not isFlaggedResidential then
                if hasBedroom or hasLivingRoom then
                    isResidential = true
                else
                    isResidential = false
                end                
            end


			-- Get Building Center Coordinates
			local buildingCenterX = ((buildingDef:getX() + buildingDef:getX2()) / 2) 
			local buildingCenterY = ((buildingDef:getY() + buildingDef:getY2()) / 2)
			
			-- Get Building Corners
			local buildingCornerX = buildingDef:getX()
			local buildingCornerX2 = buildingDef:getX2()
			local buildingCornerY = buildingDef:getY()
			local buildingCornerY2 = buildingDef:getY2()

           
            local z = player:getZ()
            local currentCell = getCell()
			
			local buildingStories = 0
            local storyCount = 0
            local heightChecks = 6
            local currentHeightCheck = 0

			-- List of Points to Check for Building Size
			local tileCheckList = 
            {
                { X = buildingCenterX, Y = buildingCenterY},                
                { X = buildingCornerX,  Y = buildingCornerY},
                { X = buildingCornerX2, Y = buildingCornerY2},
                { X = buildingCornerX, Y = buildingCornerY2},
                { X = buildingCornerX2, Y = buildingCornerY},
                { X = buildingCornerX + 5,  Y = buildingCornerY + 5},
                { X = buildingCornerX2 - 5,  Y = buildingCornerY2 - 5},
                { X = buildingCornerX + 5,  Y = buildingCornerY2 - 5},
                { X = buildingCornerX2 - 5,  Y = buildingCornerY + 5},
                { X = buildingCenterX + 1, Y = buildingCenterY + 1},
                { X = buildingCenterX + 1, Y = buildingCenterY - 1},
                { X = buildingCenterX - 1, Y = buildingCenterY + 1},
                { X = buildingCenterX - 1, Y = buildingCenterY - 1},
                { X = buildingCenterX + 2, Y = buildingCenterY + 2},
                { X = buildingCenterX + 2, Y = buildingCenterY - 2},
                { X = buildingCenterX - 2, Y = buildingCenterY + 2},
                { X = buildingCenterX - 2, Y = buildingCenterY - 2},
                { X = buildingCenterX + 3, Y = buildingCenterY + 3},
                { X = buildingCenterX + 3, Y = buildingCenterY - 3},
                { X = buildingCenterX - 3, Y = buildingCenterY + 3},
                { X = buildingCenterX - 3, Y = buildingCenterY - 3},
                { X = buildingCenterX + 4, Y = buildingCenterY + 4},
                { X = buildingCenterX + 4, Y = buildingCenterY - 4},
                { X = buildingCenterX - 4, Y = buildingCenterY + 4},
                { X = buildingCenterX - 4, Y = buildingCenterY - 4},
                { X = buildingCenterX + 5, Y = buildingCenterY + 5},
                { X = buildingCenterX + 5, Y = buildingCenterY - 5},
                { X = buildingCenterX - 5, Y = buildingCenterY + 5},
                { X = buildingCenterX - 5, Y = buildingCenterY - 5},
                { X = buildingCenterX + 6, Y = buildingCenterY + 6},
                { X = buildingCenterX + 6, Y = buildingCenterY - 6},
                { X = buildingCenterX - 6, Y = buildingCenterY + 6},
                { X = buildingCenterX - 6, Y = buildingCenterY - 6},
                { X = buildingCenterX + 7, Y = buildingCenterY + 7},
                { X = buildingCenterX + 7, Y = buildingCenterY - 7},
                { X = buildingCenterX - 7, Y = buildingCenterY + 7},
                { X = buildingCenterX - 7, Y = buildingCenterY - 7},
                { X = buildingCenterX + 10, Y = buildingCenterY + 10},
                { X = buildingCenterX + 10, Y = buildingCenterY - 10},
                { X = buildingCenterX - 10, Y = buildingCenterY + 10},
                { X = buildingCenterX - 10, Y = buildingCenterY - 10},
                { X = buildingCenterX + 15, Y = buildingCenterY + 15},
                { X = buildingCenterX + 15, Y = buildingCenterY - 15},
                { X = buildingCenterX - 15, Y = buildingCenterY + 15},
                { X = buildingCenterX - 15, Y = buildingCenterY - 15},
                { X = buildingCenterX + 20, Y = buildingCenterY + 20},
                { X = buildingCenterX + 20, Y = buildingCenterY - 20},
                { X = buildingCenterX - 20, Y = buildingCenterY + 20},
                { X = buildingCenterX - 20, Y = buildingCenterY - 20},
                { X = buildingCenterX + 25, Y = buildingCenterY + 25},
                { X = buildingCenterX + 25, Y = buildingCenterY - 25},
                { X = buildingCenterX - 25, Y = buildingCenterY + 25},
                { X = buildingCenterX - 25, Y = buildingCenterY - 25},
                { X = buildingCenterX + 30, Y = buildingCenterY + 30},
                { X = buildingCenterX + 30, Y = buildingCenterY - 30},
                { X = buildingCenterX - 30, Y = buildingCenterY + 30},
                { X = buildingCenterX - 30, Y = buildingCenterY - 30},
                { X = buildingCenterX + 35, Y = buildingCenterY + 35},
                { X = buildingCenterX + 35, Y = buildingCenterY - 35},
                { X = buildingCenterX - 35, Y = buildingCenterY + 35},
                { X = buildingCenterX - 35, Y = buildingCenterY - 35},
                { X = buildingCenterX + 40, Y = buildingCenterY + 40},
                { X = buildingCenterX + 40, Y = buildingCenterY - 40},
                { X = buildingCenterX - 40, Y = buildingCenterY + 40},
                { X = buildingCenterX - 40, Y = buildingCenterY - 40},
                { X = buildingCenterX + 50, Y = buildingCenterY + 50},
                { X = buildingCenterX + 50, Y = buildingCenterY - 50},
                { X = buildingCenterX - 50, Y = buildingCenterY + 50},
                { X = buildingCenterX - 50, Y = buildingCenterY - 50},
                { X = buildingCenterX + 60, Y = buildingCenterY + 60},
                { X = buildingCenterX + 60, Y = buildingCenterY - 60},
                { X = buildingCenterX - 60, Y = buildingCenterY + 60},
                { X = buildingCenterX - 60, Y = buildingCenterY - 60},
                { X = buildingCenterX + 70, Y = buildingCenterY + 70},
                { X = buildingCenterX + 70, Y = buildingCenterY - 70},
                { X = buildingCenterX - 70, Y = buildingCenterY + 70},
                { X = buildingCenterX - 70, Y = buildingCenterY - 70},
                { X = buildingCenterX + 80, Y = buildingCenterY + 80},
                { X = buildingCenterX + 80, Y = buildingCenterY - 80},
                { X = buildingCenterX - 80, Y = buildingCenterY + 80},
                { X = buildingCenterX - 80, Y = buildingCenterY - 80},
                { X = buildingCenterX + 90, Y = buildingCenterY + 90},
                { X = buildingCenterX + 90, Y = buildingCenterY - 90},
                { X = buildingCenterX - 90, Y = buildingCenterY + 90},
                { X = buildingCenterX - 90, Y = buildingCenterY - 90},
                { X = buildingCenterX + 99, Y = buildingCenterY + 99},
                { X = buildingCenterX + 99, Y = buildingCenterY - 99},
                { X = buildingCenterX - 99, Y = buildingCenterY + 99},
                { X = buildingCenterX - 99, Y = buildingCenterY - 99},
            }


			-------------------------------
			--  Building Height Checks  --
			-------------------------------
			
				for i = 1, #tileCheckList do
                        
                    currentTile = currentCell:getGridSquare(tileCheckList[i]["X"], tileCheckList[i]["Y"], z)  

                    if currentTile and (currentTile:getBuilding() == buildingID) then 

                        while currentHeightCheck < heightChecks do
                    
                            --print("Checking Height: " .. currentHeightCheck)
                            z = currentHeightCheck

                            currentTile = currentCell:getGridSquare(tileCheckList[i]["X"], tileCheckList[i]["Y"], z)                        

                            if currentTile and (currentTile:getBuilding() == buildingID) then  

                                    while currentTile:isSolidFloor() do				
                                        coordX = tileCheckList[i]["X"]
                                        coordY = tileCheckList[i]["Y"]
                
                                        --print("X: " .. coordX)
                                        --print("Y: " .. coordY)
                                        --print("Z: " .. z)
                                                            
                                        z = z + 1

                                        currentTile = currentCell:getGridSquare(tileCheckList[i]["X"], tileCheckList[i]["Y"], z)                                    

                                        if not currentTile then						
                                            break
                                        end                                

                                        buildingStories = z					
                                        if buildingStories > storyCount then
                                            storyCount = buildingStories
                                        end
                                    end                                  
                            end

                            currentHeightCheck = currentHeightCheck + 1  
                        end
                    end
                
                    currentHeightCheck = 0
                    z = 0
                end		
            
			buildingStories = storyCount

			-- Get Width and Height of Building Bounds
			local buildingHeight = buildingDef:getH()
			local buildingWidth = buildingDef:getW()	
			
			if buildingStories == nil then
				return nil, nil
			end
			
            -- SINGLE STORY BUILDINGS
            if (buildingStories == 0) then
                            
                if getAccessLevel() == "admin" then
                    --getPlayer():Say("Building is " .. (buildingStories + 1) .. " Story Tall")
                end

                buildingSqFootage = buildingHeight * buildingWidth * 9					
                
            -- MULTI-STORY BUILDINGS
            elseif (buildingStories >= 1) then
                            
                if getAccessLevel() == "admin" then
                    --getPlayer():Say("Building is " .. (buildingStories) .. " Stories Tall")
                end

                buildingSqFootage = (buildingHeight * buildingWidth * 9 * buildingStories)						
                
            -- INVALID BUILDINGS
            else
                --print("Invalid Building")               
            end	        
            
            return buildingSqFootage, isResidential
            
    end
end

local function ValidateSafehouseClaim(worldobjects, square, player)
	
	local player = getPlayer()

	-- print ("Enteirng ValidateSafehouseClaim")
	local squareFootage, residentialBuilding = CalculateBuildingSize()

	if (squareFootage == nil) or (residentialBuilding == nil) then
				player:Say("Error: Invalid Claim")
		return
	end

	if residentialBuilding then

		-- SMALL HOUSE CLAIM
		if squareFootage >= residentialPermitSmall and squareFootage < residentialPermitLarge then
			
			if player:getInventory():contains("ResidentialPermitSmall") then
					
				playerSafehouseClaim()												
				player:getInventory():RemoveOneOf("ResidentialPermitSmall")
				player:Say("Claimed Property (Small House)")
				return
			else
				player:Say("You must purchase a Property Claim Permit (Small House) to Claim this Building!")
				return
			end					
		return

		-- LARGE HOUSE CLAIM
		elseif squareFootage >= residentialPermitLarge and squareFootage < residentialPermitMansion	then
			
			if player:getInventory():contains("ResidentialPermitLarge") then
					
				playerSafehouseClaim()												
				player:getInventory():RemoveOneOf("ResidentialPermitLarge")
				player:Say("Claimed Property (Large House)")
				return
			else
				player:Say("You must purchase a Property Claim Permit (Large House) to Claim this Building!")
				return
			end					
		return

		-- MANSION CLAIM
		elseif squareFootage >= residentialPermitMansion and squareFootage < factionPermitSmall	then
			
			if player:getInventory():contains("ResidentialPermitMansion") then
				
				playerSafehouseClaim()												
				player:getInventory():RemoveOneOf("ResidentialPermitMansion")
				player:Say("Claimed Property (Mansion)")
				return
			else
				player:Say("You must purchase a Property Claim Permit (Mansion) to Claim this Building!")
				return
			end					
		return

		--SMALL BUNKER CLAIM
		elseif squareFootage >= factionPermitSmall and squareFootage < factionPermitLarge then
					
			if player:getInventory():contains("FactionPermitSmall") then
				
				playerSafehouseClaim()												
				player:getInventory():RemoveOneOf("FactionPermitSmall")
				player:Say("Claimed Property (Small Bunker)")
				return
			else
				player:Say("You must purchase a Property Claim Permit (Small Bunker) to Claim this Building!")
				return
			end				
		return

		--LARGE FACTION BUNKER CLAIM
		elseif squareFootage >= factionPermitLarge and squareFootage < factionPermitMassive	then
			
			if player:getInventory():contains("FactionPermitLarge") then
					-- print ("You can claim this building")
				playerSafehouseClaim()												
				player:getInventory():RemoveOneOf("FactionPermitLarge")
				player:Say("Claimed Property (Large Bunker)")
				return
			else
				player:Say("You must purchase a Property Claim Permit (Large Bunker) to Claim this Building!")
				return
			end				
		return

		-- MASSIVE BUNKER CLAIM
		elseif squareFootage >= factionPermitMassive then
			
			if player:getInventory():contains("FactionPermitMassive") then
				
				playerSafehouseClaim()												
				player:getInventory():RemoveOneOf("FactionPermitMassive")
				player:Say("Claimed Property (Massive Bunker)")
				return
			else
				player:Say("You must purchase a Property Claim Permit (Massive Bunker) to Claim this Building!")
				return
			end				
		return


		elseif squareFootage == 0 then
			print ("Error: Invalid Claim")
			return
		
		-- STANDARD CLAIM - NO PERMIT NEEDED
		else
			
			playerSafehouseClaim()
			player:Say("Claimed Property (Bungalow)")
					
		end

	elseif not residentialBuilding then
			player:Say("--Non-Residential Building--")
			player:Say("Contact an Admin for Assistance")
	end	
end

local function DisplayRequiredClaimPermit(squareFootage, residentialBuilding)

	local player = getPlayer()

	if (squareFootage == nil) or (residentialBuilding == nil) then
		-- print ("Error in Returning Safehouse Size")
		return
	end
	
	player:Say("Safehouse Square Footage: " .. (squareFootage))

	if residentialBuilding then
		-- SMALL RESIDENTIAL CLAIM
		if squareFootage >= residentialPermitSmall and squareFootage < residentialPermitLarge then
				player:Say("Property Claim Permit (Small House) Required!")					

		-- MEDIUM RESIDENTIAL CLAIM
		elseif squareFootage >= residentialPermitLarge and squareFootage < residentialPermitMansion then				
				player:Say("Property Claim Permit (Large House) Required!")					

		-- LARGE RESIDENTIAL CLAIM
		elseif squareFootage >= residentialPermitMansion and squareFootage < factionPermitSmall then				
				player:Say("Property Claim Permit (Mansion) Required!")					

				--SMALL FACTION BUNKER CLAIM
		elseif squareFootage >= factionPermitSmall and squareFootage < factionPermitLarge then		
				player:Say("Property Claim Permit (Small Bunker) Required!")					

					--LARGE FACTION BUNKER CLAIM
		elseif squareFootage >= factionPermitLarge and squareFootage < factionPermitMassive then
				player:Say("Property Claim Permit (Large Bunker) Required!")					

		-- MASSIVE FACTION BUNKER CLAIM
		elseif squareFootage >= factionPermitMassive then				
				player:Say("Property Claim Permit (Massive Bunker) Required!")					

		elseif squareFootage == 0 then -- Invalid Safehouse			
				print ("Invalid Safehouse")					

		else  -- Standard Claim			
				player:Say("No Permit Required to Claim!")
					
		end
	end

	if not residentialBuilding then
		player:Say("--Non-Residential Building--")
		player:Say("Contact an Admin for Assistance")
	end
end

local function DisplayPermitAction()
    DisplayRequiredClaimPermit(CalculateBuildingSize())
end


-----------------------------
-- Vanilla Claiming Functions
-----------------------------

function playerSafehouseClaim(worldobjects, square, player)
	local builddef = getPlayer():getSquare():getBuilding():getDef()
    SafeHouse.addSafeHouse(builddef:getX() - 2, builddef:getY() - 2, builddef:getW() + 2*2, builddef:getH() + 2*2, getPlayer():getUsername(), false)
end


--THE FIX.  THANK FUCKING GOD!
--[[ Events.OnFillWorldObjectContextMenu.Add(function(player, context, worldobjects, test)
    local option = nil
    for _, opt in pairs(context.options) do
        if opt.name == getText("ContextMenu_SafehouseClaim") then
            option = opt
            break
        end
    end
    if not option then return end    
        option.onSelect = ValidateSafehouseClaim
    end
) ]]


local function Context_safezone(player, context, worldobjects, test)

	local option = nil
    for _, opt in pairs(context.options) do
        if opt.name == getText("ContextMenu_SafehouseClaim") then
            option = opt
            break
        end
    end

    if not option then return end

    option.onSelect = ValidateSafehouseClaim   

end

local function ShowCheckPermitContextOption(player, context, worldobjects, test)
    
    local player = getPlayer()
    local object = nil
    	
    -- ERROR HANDLING - CHECK IF NOT ON THE MAP / MOVING
    if player:getSquare() == nil then
        return
    end

    -- ERROR HANDLING - CHECK IF NOT IN BUILDING
	if player:getSquare():getBuilding() == nil then			        
        return
    end

    context:addOptionOnTop("Safehouse Claim Requirements", object, DisplayPermitAction, playerObj)     
end

Events.OnFillWorldObjectContextMenu.Add(Context_safezone)
Events.OnFillWorldObjectContextMenu.Add(ShowCheckPermitContextOption)