//
//  DataRecord.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public protocol CoreDataAttr:class,CoreDataAttrHelp{
    var type:PropertyType{get}
    var name:String{get}
    var rawType:NSAttributeType{get}
    var vis:PropertyVisibility{get}
	var hideFromUser:Bool{get}
    var serializer:CoreDataSerializer{get}
    var isPrimaryKey:Bool{get}
    var isAutogenerated:Bool{get}
    var isFiltrable:Bool{get}
    var parent:CoreDataEntity!{get set}
    var options:PropertyOptionDict{get set}
	var attrUserHelp:CoreDataAttrHelp{get}
    
    func getContext()->CoreContext
    func getCache()->CoreDataCache
    func stringify(maybe mo:NSManagedObject?)->String?
    func get(maybe mo:NSManagedObject?)->Any?
    func set(for mo:NSManagedObject,serialized val:String)
    func set(for mo:NSManagedObject,val:Any?)
    func get(from mo:NSManagedObject)->Any?
    func makeEntry()->ManualPropertyEntry
    func makeFilter()->CoreDataFilter
    static func parseType(json:[String:String],rawType:NSAttributeType)->PropertyType
    static func parseName(json:[String:String])->String
    static func parseVisibility(json:[String:String])->PropertyVisibility
    static func parseIsPrimaryKey(json:[String:String])->Bool
    static func parseIsAutogenerated(json:[String:String])->Bool
    static func parseIsFiltrable(json:[String:String])->Bool
    static func parseOptions(json:[String:String],type:PropertyType)->PropertyOptionDict
	func findUserHelpInLocalizebleStrings()->String?
    func genStringifier()->Stringifier
}
public func == (lhs: CoreDataAttr, rhs: CoreDataAttr) -> Bool {
    return lhs.name == rhs.name
}
public func != (lhs: CoreDataAttr, rhs: CoreDataAttr) -> Bool {
    return lhs.name != rhs.name
}
public extension CoreDataAttr{
	
	public var hashValue: Int {
		get{
			return parent.description.attributesByName[name]!.hashValue
		}
		
	}
    
    public func getContext()->CoreContext{
        return parent.cntx
    }
    public func getCache()->CoreDataCache{
        return parent.cache
    }
    public func stringify(maybe mo:NSManagedObject?)->String?{
        return serializer.stringify(maybeAny: get(maybe: mo))
    }
    public func get(maybe mo:NSManagedObject?)->Any?{
        if let m = mo{
            return get(from: m)
        }
        return nil
    }
    public func set(for mo:NSManagedObject,serialized val:String){
        set(for: mo, val: serializer.deserialize(any: val))
    }
    public func set(for mo:NSManagedObject,val:Any?){
		assert(mo.entity == parent.description, "expected \(parent.name.or()) but was \(mo.entity.name.or())")
		assert(mo.entity.attributesByName[name] != nil,"\(mo.entity.name.or()) doesn't contain \(name)")
        mo.setValue(val, forKey: name)
    }
    public func get(from mo:NSManagedObject)->Any?{
        if mo.entity == parent.description{
            let out = mo.value(forKey: name)
            return out
        }else{
            print("Error! Tried to get \(name) (applicable to \(parent.description.name ?? "?")) from NSManagedObject of type \(mo.entity.name ?? "?")!")
            return nil
        }
    }
    public func makeEntry()->ManualPropertyEntry{
		return ManualPropertyEntry(name: name, type: type, opts: options, userHelp: attrUserHelp)
    }
    public func makeFilter()->CoreDataFilter{
        let f = type.makeFilter(for: self)
        f.isEnabled = isFiltrable
        return f
    }
    static func parseType(json:[String:String],rawType:NSAttributeType)->PropertyType{
        if let t = json["type"]{
            return PropertyType.getByName(t,rawType)
        }else{
			assertionFailure("No type is specified in JSON")
            return rawType == .objectIDAttributeType ? .relat : .display
        }
    }
    static func parseName(json:[String:String])->String{
        return json["name"]!
    }
	static func parseHideFromUser(json:[String:String])->Bool{
		if let pk = json["hideFromUser"]{
			return Bool(pk)!
		}else{
			return false
		}
	}
	
    static func parseVisibility(json:[String:String])->PropertyVisibility{
        if let vis = json["visibility"]{
            return PropertyVisibility.getByName(vis)
        }else{
            return .none
        }
    }
    static func parseIsPrimaryKey(json:[String:String])->Bool{
        if let pk = json["primaryKey"]{
            return Bool(pk)!
        }else{
            return false
        }
    }
    static func parseIsAutogenerated(json:[String:String])->Bool{
        if let ag = json["autogenerated"]{
            return Bool(ag)!
        }else{
            return false
        }
    }
    static func parseIsFiltrable(json:[String:String])->Bool{
        if let ag = json["filtrable"]{
            return Bool(ag)!
        }else{
            return false
        }
    }
    static func parseOptions(json:[String:String],type:PropertyType)->PropertyOptionDict{
        var out = PropertyOptionDict()
        for opt in type.usedOptions{
            if let e = opt.parse(json: json){
                out[opt] = e
            }
        }
        return out
    }
    
    public func genStringifier()->Stringifier{
        
        if self.type == .relat{
            return {
                [weak self] in
                
                guard let relatedMO = $0 as? NSManagedObject else{
                    return nil
                }
                guard let rattr = self! as? CoreDataRelatEntry else{
                    return nil
                }
                let relatedEnt = rattr.destEnt
                let relatRepr = relatedEnt.repr
                relatRepr.loadExternal(mo: relatedMO)
                let out = relatRepr.combineExternal()
                return out
            }
        }
        return self.rawType.genStringifier()
    }
    
    
	public func findUserHelpInLocalizebleStrings()->String?{
		if let ent = parent.name{
			let help = getLocalizedString(for: "Help:\(ent):\(name)")
			return help == "" ? nil : help
		}
		return nil
	}
	
	public var userHelpInfo: String? {
		get{
			return findUserHelpInLocalizebleStrings()
		}
	}
	
	public var attrUserHelp:CoreDataAttrHelp{
		get{
			return self
		}
	}
	
	public func makeSearchPred(for searchText:String)->SafePredicate.Node?{
		switch rawType{
		case .undefinedAttributeType:
			assertionFailure()
		case .integer16AttributeType:
			return equals(Int16(searchText))
		case .integer32AttributeType:
			return equals(Int32(searchText))
		case .integer64AttributeType:
			return equals(Int64(searchText))
		case .decimalAttributeType:
			return equals(Decimal(string: searchText))
		case .doubleAttributeType:
			return equals(Double(searchText))
		case .floatAttributeType:
			return equals(Float(searchText))
		case .stringAttributeType:
			let like = CoreDataFuzzyUniFilter.prepareLikeQuery(for: searchText)
			return likeIgnoreCase(like)
		case .booleanAttributeType:
			let bool = CoreDataBoolSerializer.deserialize(searchText)
			return equals(bool)
		case .dateAttributeType:
			let date = CoreDataDateSerializer.deserialize(searchText)
			return equals(date)
		case .binaryDataAttributeType:
			assertionFailure()
		case .UUIDAttributeType:
			assertionFailure()
		case .URIAttributeType:
			assertionFailure()
		case .transformableAttributeType:
			assertionFailure()
		case .objectIDAttributeType:
			assert(self is CoreDataRelatEntry)
			assertionFailure("unimplemented!")
			if let relat = self as? CoreDataRelatEntry{
				let destEntPK = relat.destEnt.primaryKeyAttr
				let foreignPred = destEntPK.makeSearchPred(for:searchText)
				if relat.isToMany{
//					return any(foreignPred)
				}else{
					
//					return dot(foreignPred)
				}
			}
		}
		return nil
	}
}