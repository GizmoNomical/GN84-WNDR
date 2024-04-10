require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"

-- table.insert(SuburbsDistributions["all"]["inventorymale"].items, "Base.Wallet")
-- table.insert(SuburbsDistributions["all"]["inventorymale"].items, 10)

-- table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "Base.Wallet2")
-- table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 10)

-- table.insert(SuburbsDistributions["all"]["inventorymale"].items, "GN84-ECO-TEST.MoneyStack100")
-- table.insert(SuburbsDistributions["all"]["inventorymale"].items, 10)

-- table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "GN84-ECO-TEST.MoneyStack100")
-- table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 10)

-- table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet")
-- table.insert(VehicleDistributions["GloveBox"].items, 0.1)

-- table.insert(VehicleDistributions["GloveBox"].items, "Base.Money")
-- table.insert(VehicleDistributions["GloveBox"].items, 0.1)

Distributions = Distributions or {};

local distributionTable = {
    all = {
        inventoryfemale = {
            rolls = 1,
            items = {
                "Wallet2", 300,
                "Wallet4", 300,
            }
        },
        inventoryfemale = {
            rolls = 5,
            items = { 
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
            }
        },
        inventorymale = {
            rolls = 1,
            items = {
                "Wallet", 300,
                "Wallet3", 300,
                "Wallet4", 300,
            }
        },
        inventorymale = {
            rolls = 5,
            items = { 
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
            }
        },
    },


}

table.insert(Distributions, 1, distributionTable);


ItemPickerJava.Parse()