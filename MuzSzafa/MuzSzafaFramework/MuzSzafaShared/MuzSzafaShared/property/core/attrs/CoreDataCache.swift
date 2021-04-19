//
//  CoreDataCache.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
open class CoreDataCache{
    public var ents:[CoreDataEntity] = []
    public weak var cntx:CoreContext!
    init(mom:NSManagedObjectModel,json:[[String:Any]]) {
        for a in json{
            let name = a["name"] as! String
            let e = mom.entitiesByName[name]!
            let attrs = a["attrs"] as! [[String:String]]
            let ent = CoreDataEntity(ent: e,json:attrs,self)
            ents.append(ent)
        }
		
		for ent in ents{
			for attr in ent.attrs{
				if let relat = attr as? CoreDataRelatEntry{
					let p = relat.parent
					let n = relat.name
					let d = relat.description
					let i = relat.inverseDescription
					assert(p!.description.relationshipsByName[n]!==d)
					assert(p!.cache.find(i.entity) != nil, "\(i.entity.name ?? "???").\(i.name) for \(p!.name ?? "???").\(n) was not found! ")
					assert(p!.cache.find(i.entity) != nil)
					assert(p!.cache.find(i.entity)!.find(relat:i) != nil, "Could not find \(i.entity.name ?? "???").\(i.name)")
				}
				assert(attr.type.isTypeAllowed(attr.rawType))
			}
		}
		
    }
}
public extension CoreDataCache{
    func fuzzyFind<S:StringProtocol>(indexOf name:S)->Int?{
        for (i,e) in ents.enumerated(){
            if let n = e.name{
                if n.caseInsensitiveCompare(name) == ComparisonResult.orderedSame ||
                    getLocalizedString(for:n).caseInsensitiveCompare(name) == ComparisonResult.orderedSame{
                    return i
                }
            }
        }
        return nil
    }
    func fuzzyFind<S:StringProtocol>(_ name:S)->CoreDataEntity?{
        guard let i = fuzzyFind(indexOf: name) else {return nil}
        return ents[i]
    }
    func find<S>(_ name:S)->CoreDataEntity? where S:StringProtocol{
        for e in ents{
            if let n = e.name{
                if name.elementsEqual(n){
                    return e
                }
            }
        }
        return nil
    }
	func find(_ desc:NSEntityDescription)->CoreDataEntity?{
		for e in ents{
			if desc == e.description{
				return e
			}
		}
		return nil
	}
}

