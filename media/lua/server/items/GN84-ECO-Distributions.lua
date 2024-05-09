require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"


Distributions = Distributions or {};

local distributionTableCash = {
    all = {        
        inventoryfemale = {
            rolls = 100,
            items = {    
                "Money", 80,
                "Money", 80, 
                "Money", 80, 
                "Money", 80, 
                "Money", 80,
                "Money", 80,
                "Money", 80, 
                "Money", 80, 
                "Money", 80, 
                "Money", 80, 
                "Money", 50,
                "Money", 50,
                "Money", 50, 
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,  
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
            }
        },
        inventorymale = {
            rolls = 100,
            items = {     
                "Money", 80,
                "Money", 80, 
                "Money", 80, 
                "Money", 80, 
                "Money", 80,
                "Money", 80,
                "Money", 80, 
                "Money", 80, 
                "Money", 80, 
                "Money", 80, 
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,
                "Money", 50,  
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
            }
        },
        cashregister = {
            rolls = 100,
            items = {     
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 100,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20,
                "Money", 20,
                "Money", 20,
                "Money", 20,
                "Money", 20,                
            }
        },
        vendingsnack = {
            rolls = 15,
            items = { 
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,
                "Money", 80,    
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
                }
            },
            vendingpop = {
                rolls = 10,
                items = {  
                    "Money", 80,
                    "Money", 80,
                    "Money", 80,  
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
            }
        },
        Briefcase = {
            rolls = 7,
            items = {    
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
                "Money", 20, 
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
            }
        },
    },
}

local distributionTableWallets = {
    all = {
        inventoryfemale = {
            rolls = 1,
            items = {
                "Wallet2", 100,
                "Wallet4", 100,
            }
        },
        inventorymale = {
            rolls = 1,
            items = {
                "Wallet", 100,
                "Wallet3", 100,
                "Wallet4", 100,
            }
        },
    },
}

table.insert(Distributions, 1, distributionTableCash);
table.insert(Distributions, 1, distributionTableWallets);

table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, 150);

table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["PoliceDesk"].items, 20);

table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, 10000);

table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["PoliceEvidence"].items, 50);

table.insert(ProceduralDistributions["list"]["SchoolLockers"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["SchoolLockers"].items, 50);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["Locker"].items, 10);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["Locker"].items, 10);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["Locker"].items, 10);

table.insert(ProceduralDistributions["list"]["Locker"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["Locker"].items, 10);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["PoliceLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 10);

table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["FireDeptLockers"].items, 10);


table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);


table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Money");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 2800);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 20);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 20);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 20);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 20);


table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet");
table.insert(VehicleDistributions["GloveBox"].items, 3);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet2");
table.insert(VehicleDistributions["GloveBox"].items, 3);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet3");
table.insert(VehicleDistributions["GloveBox"].items, 3);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Wallet4");
table.insert(VehicleDistributions["GloveBox"].items, 3);

table.insert(VehicleDistributions["GloveBox"].items, "Base.Money");
table.insert(VehicleDistributions["GloveBox"].items, 150);


ItemPickerJava.Parse()