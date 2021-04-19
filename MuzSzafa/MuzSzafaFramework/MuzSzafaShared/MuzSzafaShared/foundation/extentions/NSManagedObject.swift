//
//  CoreDataMO.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public extension NSManagedObject{
	public static func cast<T>(_ mo:NSManagedObject,ent name:String,cntx:CoreContext)->T? where T:NSManagedObject{
		if let ent = cntx.cache.find(name){
			return cast(mo,ent:ent)
		}
		assertionFailure("Entity \(name) not found!")
		return nil
	}
	public static func cast<T>(_ mo:NSManagedObject,ent:CoreDataEntity)->T? where T:NSManagedObject{
		assert(mo.entity==ent.description,"expected \(ent.name ?? "???") but was \(mo.entity.name ?? "???")")
		if let t = mo as? T{
			assert(t.entity==ent.description,"expected \(ent.name ?? "???") but was \(t.entity.name ?? "???")")
			return t
		}
		return nil
	}
    public static func cast<T>(_ any:Any,ent name:String,cntx:CoreContext)->T? where T:NSManagedObject{
        if let mo = any as? NSManagedObject{
			return cast(mo,ent:name,cntx:cntx)
        }
        return nil
    }
	public static func cast<T>(_ any:Any,ent:CoreDataEntity)->T? where T:NSManagedObject{
		if let mo = any as? NSManagedObject{
			return cast(mo,ent:ent)
		}
		return nil
	}
	public static func cast<T>(_ any:Any?,ent name:String,cntx:CoreContext)->T? where T:NSManagedObject{
        if let a = any{
			return cast(a,ent:name,cntx:cntx)
        }
        return nil
    }
	public static func cast<T>(_ any:Any?,ent:CoreDataEntity)->T? where T:NSManagedObject{
		if let a = any{
			return cast(a,ent:ent)
		}
		return nil
	}
    public func findEnt(in context:CoreContext)->CoreDataEntity?{
        return findEnt(in: context.cache)
    }
    public func findEnt(in cache:CoreDataCache)->CoreDataEntity?{
        if let n = entity.name{
            return cache.find(n)
        }
        return nil
    }
	
	public func autodelete(_ cntx:NSManagedObjectContext)->String?{
		if let deal = self as? Deal{
			return deal.delete(cntx)
		}
		if let client = self as? Client{
			return client.delete(cntx)
		}
		if let instrument = self as? Instrument{
			return instrument.delete(cntx)
		}
		if let instrumentType = self as? InstrumentType{
			return instrumentType.delete(cntx)
		}
		cntx.delete(self)
		return nil
	}
}
