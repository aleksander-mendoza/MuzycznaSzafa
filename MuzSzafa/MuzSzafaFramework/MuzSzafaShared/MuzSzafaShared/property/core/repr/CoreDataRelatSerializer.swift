//
//  CoreDataRelatSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

open class CoreDataRelatSerializer:CoreDataGenericSerializer{
    public typealias T = NSManagedObject
    private var relatEnt:CoreDataEntity{
        get{
            return relat.destEnt
        }
    }
    private let relat:CoreDataRelatEntry
    public init(relat:CoreDataRelatEntry){
        self.relat = relat
		assert(!relat.isToMany, "To Many relationship attribute found! Use CoreDataRelatToManySerializer instead")
    }
    
    public func serialize(maybe val: T?) -> String {
        if let v = val{
            return serialize(v)
        }
        return ""
    }
    public func serialize(any: Any) -> String {
        if let val = any as? NSManagedObject{
            return serialize(val)
        }
        return ""
    }
    public func serialize(_ val: T) -> String {
		let pk = relatEnt.primaryKeyAttr
		let v = pk.get(from: val)
		return pk.serializer.stringify(maybeAny: v) ?? ""
    }
	
    public func deserialize(_ val:String)->T?{
		if val == "" {return nil}
        let serializer = relatEnt.primaryKeyAttr.serializer
		if let primaryKey = serializer.deserialize(any: val){
			return relatEnt.ensureExists(primaryKey)
		}
        return nil
        
    }
    public func stringify(maybe val: T?) -> String? {
        if let v = val{
            return stringify(v)
        }
        return nil
    }
    public func stringify(any: Any) -> String? {
        if let val = any as? NSManagedObject{
            return stringify(val)
        }
        return ""
    }
    public func stringify(_ val:T)->String?{
        let repr = relatEnt.repr
        repr.loadPrimary(mo: val)
        let str = repr.combinePrimary()
        return str
    }
}
