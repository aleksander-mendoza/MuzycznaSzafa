//
//  EntityManagement.swift
//  MuzSzafa
//
//  Created by Alagris on 16/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
public extension Instrument{
	
	public static var ent:CoreDataEntity{
		get{
			return CoreContext.find(ent: "Instrument")!
		}
	}
	
	public static var deal:CoreDataRelatEntry{
		get{
			return ent.find(attr: "deal")! as! CoreDataRelatEntry
		}
	}
	
	func delete(_ cntx:NSManagedObjectContext)->String?{
		if deal?.count ?? 0 == 0{
			cntx.delete(self)
			return nil
		}
		return "cant_delete_instrument_with_deals"
	}
	
    public func getTypeName() -> String?{
        return type?.type
    }
    private func filterValidDealsArgs(for date:Date)->[Any]{
        return Deal.filterValidArgs(for: date) + ["instrument",self]
    }
    private var filterValidDealsFormat:String{
        get{
            return Deal.filterValidFormat + "&& ANY %K == %@"
        }
    }
    func filterValidDeals(for date:Date)->SafePredicate.Node{
//        let args = filterValidDealsArgs(for: date)
//        let format = filterValidDealsFormat
//        let pred = NSPredicate(format:format , argumentArray: args)
//        return pred
		return Deal.filterValid(for:date).and(Deal.instrument.any(self))
    }
    
    func updateAvailablility(cntx:CoreContext){
        let pred = filterValidDeals(for: Date())
        let count = Deal.ent.safePred(expr: pred).count()
        available = count == 0
    }
	public static func cast(_ any:Any)->Instrument?{
		return cast(any, ent: Instrument.ent)
	}
	public static func cast(_ any:Any?)->Instrument?{
		return cast(any, ent: Instrument.ent)
	}
	public static func cast(_ mo:NSManagedObject)->Instrument?{
		return cast(mo, ent: Instrument.ent)
	}
	public static func cast(_ mo:NSManagedObject?)->Instrument?{
		if let mo = mo{
			return cast(mo)
		}
		return nil
	}
}



