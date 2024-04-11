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

local distributionTableCash = {
    all = {        
        inventoryfemale = {
            rolls = 7,
            items = {    
                "Money", 20,                                 
                "Money", 13,
                "Money", 11,           
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
            }
        },
        inventorymale = {
            rolls = 7,
            items = {     
                "Money", 20,
                "Money", 13,
                "Money", 11,            
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
            }
        },
    },
}

local distributionTableWallets = {
    all = {
        inventoryfemale = {
            rolls = 1,
            items = {
                "Wallet2", 7,
                "Wallet4", 7,
            }
        },
        inventorymale = {
            rolls = 1,
            items = {
                "Wallet", 7,
                "Wallet3", 7,
                "Wallet4", 7,
            }
        },
    },
}




table.insert(Distributions, 1, distributionTableCash);
table.insert(Distributions, 1, distributionTableWallets);


ItemPickerJava.Parse()