function Recipe.OnTest.MakeDiabloSandwich(sourceItem, result)
    if sourceItem:getFullType() == "DS77.DiabloFixins" then
        return sourceItem:isCooked()
    end
    return true
end

function Recipe.OnTest.BottleSmokeyBBQSauce(sourceItem, result)
    if sourceItem:getFullType() == "DS77.SmokeyBBQSauceBase" then
        return sourceItem:isCooked()
    end
    return true
end

function Recipe.OnCreate.ReturnPanAfterUse(sources, result, player, item)
    player:getInventory():AddItem("Base.Pan");
end

function Recipe.OnCreate.ReturnSaucePanAfterUse(sources, result, player, item)
    player:getInventory():AddItem("Base.Saucepan");
end