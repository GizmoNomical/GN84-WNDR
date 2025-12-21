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
                "Wallet2", 40,
                "Wallet4", 40,
            }
        },
        inventorymale = {
            rolls = 1,
            items = {
                "Wallet", 40,
                "Wallet3", 40,
                "Wallet4", 40,
            }
        },
    },
}

local distributionTableLottoTickets = {
    all = {
        inventoryfemale = {
            rolls = 1,
            items = {
                "GN84-WNDR.LottoTicketStandard", 7,
                "GN84-WNDR.LottoTicketRare", 0.000001,
            }
        },
        inventorymale = {
            rolls = 2,
            items = {
                "GN84-WNDR.LottoTicketStandard", 7,                
                "GN84-WNDR.LottoTicketRare", 0.000001,
            }
        },        
        cashregister = {
            rolls = 50,
            items = {                     
                "GN84-WNDR.LottoTicketStandard", 45,   
                "GN84-WNDR.LottoTicketRare", 0.0000001,         
            }
        },
    },
}


table.insert(Distributions, 1, distributionTableCash);
table.insert(Distributions, 1, distributionTableWallets);
table.insert(Distributions, 1, distributionTableLottoTickets);

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

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "GN84-WNDR.LottoTicketStandard");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 10);

table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, "GN84-WNDR.LottoTicketRare");
table.insert(ProceduralDistributions["list"]["BedroomSideTable"].items, 0.000001);


table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet2");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet3");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "Base.Wallet4");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 7);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "GN84-WNDR.LottoTicketStandard");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 10);

table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, "GN84-WNDR.LottoTicketRare");
table.insert(ProceduralDistributions["list"]["BedroomDresser"].items, 0.000001);


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

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "GN84-WNDR.LottoTicketStandard");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 25);

table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, "GN84-WNDR.LottoTicketRare");
table.insert(ProceduralDistributions["list"]["BarCounterMisc"].items, 0.000001);


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

table.insert(VehicleDistributions["GloveBox"].items, "GN84-WNDR.LottoTicketStandard");
table.insert(VehicleDistributions["GloveBox"].items, 0.5);


table.insert(ProceduralDistributions.list["BinBar"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["BinBar"].items, 5)


table.insert(ProceduralDistributions.list["BinDumpster"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["BinDumpster"].items, 5)


table.insert(ProceduralDistributions.list["BinGeneric"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["BinGeneric"].items, 5)


table.insert(ProceduralDistributions.list["GunStoreCounter"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["GunStoreCounter"].items, 25)


table.insert(ProceduralDistributions.list["JanitorCleaning"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["JanitorCleaning"].items, 5)


table.insert(ProceduralDistributions.list["JunkBin"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["JunkBin"].items, 5)


table.insert(ProceduralDistributions.list["LivingRoomShelf"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["LivingRoomShelf"].items, 10)


table.insert(ProceduralDistributions.list["LivingRoomSideTable"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["LivingRoomSideTable"].items, 10)


table.insert(ProceduralDistributions.list["OfficeDeskHome"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["OfficeDeskHome"].items, 10)


table.insert(ProceduralDistributions.list["OtherGeneric"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["OtherGeneric"].items, 10)


table.insert(ProceduralDistributions.list["RandomFiller"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["RandomFiller"].items, 10)


table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, 10)


table.insert(ProceduralDistributions.list["CrateCigarettes"].items, "GN84-WNDR.LottoTicketStandard")
table.insert(ProceduralDistributions.list["CrateCigarettes"].items, 1)



ItemPickerJava.Parse()