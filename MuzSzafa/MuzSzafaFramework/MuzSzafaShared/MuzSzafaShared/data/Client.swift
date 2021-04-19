//
//  Client.swift
//  MuzSzafaShared
//
//  Created by Alagris on 15/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData


public extension Client{
	public static var ent:CoreDataEntity{
		get{
			return CoreContext.find(ent: "Client")!
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
		return "cant_delete_client_with_deals"
	}
	
    func filterValidDeals(for date:Date)->SafePredicate.Node{
//        let args = Deal.filterValidArgs(for: date) + ["client",self]
//        let format = Deal.filterValidFormat + "&& %K == %@"
//        let pred = NSPredicate(format:format , argumentArray: args)
//        return pred
		return Deal.filterValid(for:date).and(Deal.client.equals(self))
		
    }
	
	
	
	var filterValidDealsWithoutDate:SafePredicate.Node{
//		let args = Deal.filterValidArgsWithoutDate + ["client",self]
//		let format = " ( " + Deal.filterValidFormatWithoutDate + " ) && %K == %@"
//		let pred = NSPredicate(format:format , argumentArray: args)
//		return pred
		return Deal.status.equals(1)
			.or(Deal.status.equals(2))
			.and(Deal.client.equals(self))
	}
	
	func hasActiveDealWithoutDate(cntx:CoreContext)->Bool{
		let ent = cntx.cache.find("Deal")!
		let count = ent.safePred(expr: filterValidDealsWithoutDate).count()
		return count > 0
	}
	public static func cast(_ any:Any)->Client?{
		return cast(any, ent: CoreContext.find(ent:"Client")!)
	}
	public static func cast(_ any:Any?)->Client?{
		return cast(any, ent: CoreContext.find(ent:"Client")!)
	}
	public static func cast(_ mo:NSManagedObject)->Client?{
		return cast(mo, ent: CoreContext.find(ent:"Client")!)
	}
	public static func cast(_ mo:NSManagedObject?)->Client?{
		if let mo = mo{
			return cast(mo)
		}
		return nil
	}
}
