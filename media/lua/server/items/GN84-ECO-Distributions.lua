require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"


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
        cashregister = {
            rolls = 20,
            items = {     
                "Money", 20,
                "Money", 20,
                "Money", 20,
                "Money", 20,
                "Money", 20,
                "Money", 20,
                "Money", 13,
                "Money", 11,            
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
        vendingsnack = {
            rolls = 5,
            items = {                    
                "Money", 13,
                "Money", 11,            
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,
                "Money", 5,                
                }
            },
            vendingpop = {
                rolls = 3,
                items = {                    
                    "Money", 13,
                    "Money", 11,            
                    "Money", 5,
                    "Money", 5,
                    "Money", 5,
                    "Money", 5,
                    "Money", 5,                
            }
        },
        Briefcase = {
            rolls = 7,
            items = {           
                "Money", 13,
                "Money", 11,            
                "Money", 5,
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

table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, 100);

table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, 10);

table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, 1000);

table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, 100);

table.insert(ProceduralDistributions["list"]["SchoolLockers"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["SchoolLockers"].items, 25);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["Locker"].items, 5);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["Locker"].items, 5);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["Locker"].items, 5);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["Locker"].items, 5);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 5);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 5);


table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 5);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 5);


table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 100);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 5);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 5);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 5);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 5);


table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet");
table.insert(VehicleDistributions["GloveBox"].items, 6);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet2");
table.insert(VehicleDistributions["GloveBox"].items, 6);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet3");
table.insert(VehicleDistributions["GloveBox"].items, 6);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet4");
table.insert(VehicleDistributions["GloveBox"].items, 6);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Money");
table.insert(VehicleDistributions["GloveBox"].items, 250);


ItemPickerJava.Parse()