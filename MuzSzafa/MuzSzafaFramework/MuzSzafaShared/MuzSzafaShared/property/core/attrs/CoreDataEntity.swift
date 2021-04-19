//
//  CoreDataEntity.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
open class CoreDataEntity: Hashable{
    
    public var delegate: NSFetchedResultsControllerDelegate?
    
    public var cntx: CoreContext!{
        get{
            return cache.cntx
        }
    }
    
    static public func == (_ lhs:CoreDataEntity,_ rhs:CoreDataEntity)->Bool{
        return rhs.description == lhs.description
    }
    
	public let repr:EntPropRepr
    open var attrs:[CoreDataAttr] = []
	public let description:NSEntityDescription
	
	public func hash(into hasher: inout Hasher) {
		return description.hash(into: &hasher)
	}
	
    open var name:String?{
        get{
            return description.name
        }
    }
	public weak var cache:CoreDataCache!
	public let primaryKeyAttr:CoreDataAttr
    public convenience init(ent:String,
                            json:[[String:String]],
                            cntx:NSManagedObjectContext,
                            _ src:CoreDataCache){
        self.init(ent:NSEntityDescription.entity(forEntityName: ent, in: cntx)!,json:json,src)
    }
    public init(ent:NSEntityDescription,
                json:[[String:String]],
                _ src:CoreDataCache){
        self.description = ent
        self.cache = src
        
        let attrsDict = ent.attributesByName
        let relatsDict = ent.relationshipsByName
       
        
        for attr in json{
            let name = attr["name"]!
            if let a = attrsDict[name]{
                attrs.append(CoreDataAttrEntry(value:a,json:attr))
            }else if let r = relatsDict[name]{
                attrs.append(CoreDataRelatEntry(value:r,json:attr,cache))
            }else{
                fatalError("Attribute \(name) not found!")
            }
        }
        
        
        func findPrimaryKey(attrs:[CoreDataAttr]) -> CoreDataAttr?{
            var result:CoreDataAttr? = nil
            for a in attrs{
                if a.isPrimaryKey{
                    if let r = result{
                        fatalError("Multiple primary keys:\(a.name) and \(r.name)")
                    }else{
                        result = a
                    }
                }
            }
            return result
        }
        if let pk = findPrimaryKey(attrs:attrs){
            primaryKeyAttr = pk
        }else{
            fatalError("Invalid configuration. No primary key for \(ent.name ?? "nil")!")
        }
        repr = AutoPropertyRepr(attrs: attrs)
        /////////////////
        //post-init stage
        ////////////////
        for attr in attrs{
            attr.parent = self
        }
    }
   
}


public extension CoreDataEntity{
    func index(of attr:CoreDataAttr)->Int?{
        if attr.parent.description != description{
            return nil
        }
        return attrs.index(){$0.name == attr.name}
    }
    func contains(attr:CoreDataAttr)->Bool{
        return index(of: attr) != nil
    }
    func fuzzyMatch(attr name:String)->Int?{
        for (i,attr) in attrs.enumerated(){
            let n = attr.name
            let r = ComparisonResult.orderedSame
            if n.caseInsensitiveCompare(name) == r ||
                getLocalizedString(for: n).caseInsensitiveCompare(name) == r{
                return i
            }
        }
        return nil
    }
    
    var localizedAttrNames:[String]{
        get{
            return attrs.map(){getLocalizedString(for: $0.name)}
        }
    }
}


public extension CoreDataEntity{
	
	public func primaryKey(of obj:NSManagedObject)->Any?{
		return obj.value(forKey: primaryKeyAttr.name)
	}
	
	public func safePred(expr:SafePredicate.Node)->SafePredicate{
		return SafePredicate(ent: self, expr: expr)
	}
	
	public func filterBy(attr:CoreDataAttr,_ val:Any?)->SafePredicate{
		return safePred(expr: attr.equals(val))
	}
	
	public func filterBy(mainAttrVal:Any?)->SafePredicate{
		return filterBy(attr:primaryKeyAttr,mainAttrVal)
	}
	
	public func count()->Int{
		return (try? cntx.get().count(for: fetchReq())) ?? 0
	}
	
	public func count(attr:CoreDataAttr,_ val:Any?)->Int{
		return filterBy(attr:attr,val).count()
	}
	
	public func count(_ mainAttrVal:Any?)->Int{
		return filterBy(mainAttrVal: mainAttrVal).count()
	}
	
	public func exists(attr:CoreDataAttr,_ val:Any?)->Bool{
		return filterBy(attr:attr,val).exists()
	}
	
	public func exists(_ mainAttrVal:Any?)->Bool{
		return filterBy(mainAttrVal: mainAttrVal).exists()
	}
	
	public func getFirst(_ mainAttrVal:Any?)->NSManagedObject?{
		return filterBy(mainAttrVal: mainAttrVal).getFirst()
	}
	
	public func getFirst(attr:CoreDataAttr,_ val:Any?)->NSManagedObject?{
		return filterBy(attr:attr, val).getFirst()
	}
	
	public func sortByPk(_ ascending:Bool=true)->NSSortDescriptor{
		return NSSortDescriptor(key: primaryKeyAttr.name, ascending: ascending)
	}
	
	public func newBlank()->NSManagedObject{
	    return NSEntityDescription.insertNewObject(forEntityName: name!, into: cntx.get());
	}
	
	/**Just an acronym for ensureExists. It's often not so obvious what 'ensureExists' stands for*/
	public func new(pk val:Any) -> NSManagedObject? {
		return ensureExists(val)
	}
	
	
	public func fetchReq(pred:SafePredicate?=nil,
						 limit:Int=0,
						 sort:[NSSortDescriptor]?=nil) -> NSFetchRequest<NSManagedObject>{
		let req = NSFetchRequest<NSManagedObject>(entityName: name!)
		req.sortDescriptors = sort ?? [sortByPk()]
		assert(pred==nil ? true : pred!.ent==self,"expected \(name ?? "nil") but was \(pred!.ent.name ?? "nil")")
		req.predicate = pred?.pred
		req.fetchLimit = limit
		return req
	}
	
	public func makeReqController(sort:[NSSortDescriptor]?=nil, delegate:NSFetchedResultsControllerDelegate?=nil)-> NSFetchedResultsController<NSManagedObject>{
		let req = fetchReq(sort:sort)
		let cnt = NSFetchedResultsController<NSManagedObject>(
			fetchRequest: req,
			managedObjectContext: cntx.get(),
			sectionNameKeyPath: nil,
			cacheName: nil)
		cnt.delegate = delegate
		return cnt
	}
	
	public func fetch(pred:SafePredicate?=nil,
					  limit:Int=0,
					  sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
		return try? cntx.get().fetch(fetchReq(pred:pred, limit:limit, sort:sort))
	}
	
	public func fetch(attr:CoreDataAttr,
					  val:Any?,
					  limit:Int=0,
					  sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
		return fetch(pred: safePred(expr: attr.equalsOrAny(val)), limit: limit, sort: sort)
	}
	
	public func fetch(_ maintAttrVal:Any?,
					  limit:Int=0,
					  sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
		return fetch(attr: primaryKeyAttr, val: maintAttrVal, limit: limit, sort: sort)
	}
	
	func newAutogenerated() -> NSManagedObject? {
		var mainVal = primaryKeyAttr.rawType.autogenerate()
		while exists(mainVal){
			mainVal = primaryKeyAttr.rawType.autogenerate()
		}
		let new = newBlank()
		primaryKeyAttr.set(for: new, val: mainVal)
		return new
	}
	
	public func ensureExists(_ mainAttrVal:Any)->NSManagedObject{
		if let i = getFirst(mainAttrVal){
			return i
		}else{
			let mo = newBlank()
			primaryKeyAttr.set(for: mo, val: mainAttrVal)
			return mo
		}
	}
	
	
	
//	func selectByRelats(mos:[NSManagedObject],
//						limit:Int=0,
//						sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
//		return select(filterByRelats(mos: mos), limit: limit,sort:sort)
//	}
	
//	func filterByRelats(mos:[NSManagedObject])->NSPredicate{
//		var format = [String]()
//		var args = [Any]()
//		for mo in mos{
//			if let relat = findRelatAttrBy(mo: mo){
//				if relat.isToMany{
//					format += "ANY %K == %@"
//					args += [relat.name, mo]
//				}else{
//					format += "%K == %@"
//					args += [relat.name, mo]
//				}
//			}
//		}
//		let str = format.joined(separator: " && ")
//		return NSPredicate(format: str, argumentArray: args)
//	}
//	func findRelatAttrBy(ent:NSEntityDescription)->CoreDataRelatEntry?{
//		for attr in attrs{
//			if let relat = attr as? CoreDataRelatEntry{
//				if relat.destEnt.description == ent{
//					return relat
//				}
//			}
//		}
//		assertionFailure("relationship to entity \(ent.name ?? "???") not found!")
//		return nil
//	}
//	func findRelatAttrBy(mo:NSManagedObject)->CoreDataRelatEntry?{
//		return findRelatAttrBy(ent: mo.entity)
//	}
	func find<S>(attr name:S)->CoreDataAttr? where S:StringProtocol{
		for attr in attrs{
			if name.elementsEqual(attr.name){
				return attr
			}
		}
		return nil
	}
	func find(relat desc:NSRelationshipDescription)->CoreDataRelatEntry?{
		for attr in attrs{
			if let r = attr as? CoreDataRelatEntry,
				desc == r.description{
				return r
			}
		}
		return nil
	}
}


