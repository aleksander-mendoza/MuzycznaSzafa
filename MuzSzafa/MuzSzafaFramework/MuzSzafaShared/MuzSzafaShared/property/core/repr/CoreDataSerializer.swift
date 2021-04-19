//
//  CoreDataSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public protocol CoreDataSerializer{
    func serialize(maybeAny:Any?)->String
    func serialize(any:Any)->String
    func deserialize(any :String)->Any?
    func stringify(any :Any)->String?
    func stringify(maybeAny :Any?)->String?
}

public extension CoreDataSerializer{
    func serialize(maybeAny:Any?)->String{
        guard let n = maybeAny else{
            return ""
        }
        return serialize(any: n)
    }
    func stringify(maybeAny :Any?)->String?{
        guard let n = maybeAny else{
            return nil
        }
        return stringify(any: n)
    }
//    func stringifyOrDefault(maybeAny val:Any?)->String{
//        return stringify(maybeAny:val, orElse: "? ? ?")
//    }
//    func stringify(maybeAny val:Any?, orElse:String)->String{
//        return stringify(maybeAny:val) ?? orElse
//    }
    
}


public func newCoreDataSerializer(from attr:CoreDataAttr)->CoreDataSerializer{
    switch attr.type {
    case .bool:
        fallthrough
    case .toggle:
        return CoreDataBoolSerializer()
    case .string:
        fallthrough
    case .telephone:
        fallthrough
    case .email:
        fallthrough
    case .text:
        return CoreDataStringSerializer()
    case .date:
        return CoreDataDateSerializer()
    case .int:
        fallthrough
    case .list:
        return CoreDataListSerializer(parent: attr)
    case .money:
        return CoreDataMoneySerializer()
    case .display:
        return CoreDataFlexibleSerializer(attr: attr)
    case .relat:
		let relat = attr as! CoreDataRelatEntry
		assert(!relat.isToMany, "It shouldn't be To Many relationship")
		return CoreDataRelatSerializer(relat: relat)
	case .relatList:
		fallthrough
	case .relatToMany:
		let relatToMany = attr as! CoreDataRelatEntry
		assert( relatToMany.isToMany, "It should be To Many relationship")
		return CoreDataRelatToManySerializer(relat: relatToMany)
    case .button:
        return CoreDataDummySerializer()
	case .moList:
		return CoreDataDummySerializer()
    }
}






