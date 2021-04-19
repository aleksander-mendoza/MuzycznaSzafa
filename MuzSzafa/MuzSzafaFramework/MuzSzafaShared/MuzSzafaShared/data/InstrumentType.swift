//
//  InstrumentType.swift
//  MuzSzafaShared
//
//  Created by Alagris on 24/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
public extension InstrumentType{
	public static var ent:CoreDataEntity{
		get{
			return CoreContext.find(ent: "InstrumentType")!
		}
	}
	func delete(_ cntx:NSManagedObjectContext)->String?{
		if instrument?.count ?? 0 == 0{
			cntx.delete(self)
			return nil
		}
		return "cant_delete_instrument_type_with_instruments"
	}
	public static func cast(_ any:Any)->InstrumentType?{
		return cast(any, ent: CoreContext.find(ent:"InstrumentType")!)
	}
	public static func cast(_ any:Any?)->InstrumentType?{
		return cast(any, ent: CoreContext.find(ent:"InstrumentType")!)
	}
	public static func cast(_ mo:NSManagedObject)->InstrumentType?{
		return cast(mo, ent: CoreContext.find(ent:"InstrumentType")!)
	}
	public static func cast(_ mo:NSManagedObject?)->InstrumentType?{
		if let mo = mo{
			return cast(mo)
		}
		return nil
	}
}
