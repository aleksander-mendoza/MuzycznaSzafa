//
//  CoreDataRelatSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

open class CoreDataRelatToManySerializer:CoreDataGenericSerializer{
    public typealias T = NSSet
    private var relatEnt:CoreDataEntity{
        get{
            return relat.destEnt
        }
    }
    private let relat:CoreDataRelatEntry
    public init(relat:CoreDataRelatEntry){
        self.relat = relat
    }
    
    public func serialize(maybe val: T?) -> String {
        if let v = val{
            return serialize(v)
        }
        return ""
    }
    public func serialize(any: Any) -> String {
        if let val = any as? NSSet{
            return serialize(val)
        }
        return ""
    }
    public func serialize(_ val: T) -> String {
		let pk = relatEnt.primaryKeyAttr
		return val.allObjects.map(){
			let pkVal = pk.get(from: $0 as! NSManagedObject)
			let pkStr = pk.serializer.stringify(maybeAny: pkVal) ?? ""
			return pkStr.escape(char: ";", with: "\\")
		}.joined(separator: ";")
    }
	
    public func deserialize(_ val:String)->T?{
        let serializer = relatEnt.primaryKeyAttr.serializer
		let deserializedSet = NSMutableSet()
		for sub in val.split(separator: ";", escapeChar: "\\"){
			if sub == ""{continue}
			if let primaryKey = serializer.deserialize(any: sub){
				let moForPk = relatEnt.ensureExists(primaryKey)
				deserializedSet.add(moForPk)
			}
		}
        return deserializedSet
    }
	
    public func stringify(maybe val: T?) -> String? {
        if let v = val{
            return stringify(v)
        }
        return nil
    }
    public func stringify(any: Any) -> String? {
        if let val = any as? NSSet{
            return stringify(val)
        }
        return ""
    }
    public func stringify(_ val:T)->String?{
		if val.count == 1{
			return "1 \(getLocalizedString(for: "one_value"))"
		}
       	return "\(val.count) \(getLocalizedString(for: "n_values"))"
    }
}
