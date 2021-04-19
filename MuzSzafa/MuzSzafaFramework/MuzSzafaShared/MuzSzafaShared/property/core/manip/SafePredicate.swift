//
//  SafePredicate.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData



public class SubqueryCount{
	
	private let sub: Subquery
	
	fileprivate init(sub: Subquery){
		self.sub = sub
	}
	
	public func equals(_ val:Int) -> SafePredicate.Node{
		return .countEqualsInt(sub, val)
	}
}


public class Subquery{
	
	public let relat: CoreDataRelatEntry
	public let context:String
	public let expr: SafePredicate.Node
	
	fileprivate init(relat: CoreDataRelatEntry,using context:String,_ expr:SafePredicate.Node){
		self.relat = relat
		self.expr = expr
		self.context = context
	}
	
	public func count() -> SubqueryCount{
		return SubqueryCount(sub:self)
	}
}

open class SafePredicate{
	
	public indirect enum Node{
		case equals(String?,CoreDataAttr,Any?)
		case contains(String?,CoreDataAttr,Any?)
		case matches(String?,CoreDataAttr,Any?)
		case like(String?,CoreDataAttr,Any?)
		case likeIgnoreCase(String?,CoreDataAttr,Any?)
		case any(String?,CoreDataAttr,Any?)
		case all(String?,CoreDataAttr,Any?)
		case gt(String?,CoreDataAttr,Any?)
		case lt(String?,CoreDataAttr,Any?)
		case ge(String?,CoreDataAttr,Any?)
		case le(String?,CoreDataAttr,Any?)
		case empty()
		case and(Node,Node)
		case or(Node,Node)
		case countEqualsInt(Subquery,Int)
	}
	
	public let ent:CoreDataEntity
	public let pred:NSPredicate
	
	public var cntx:NSManagedObjectContext{
		get{
			return ent.cntx.get()
		}
	}
	
	public init(ent:CoreDataEntity, expr:Node){
		self.ent=ent
		let formula:String
		let params:[Any?]
		func compile(ent:CoreDataEntity,expr:Node)->(String,[Any?]){
			func resolve(_ context:String?)->String{
				if let c = context{
					return "\(c)."
				}
				return ""
			}
			switch expr{
			case .equals(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K == %@",[resolve(context)+attr.name,val])
			case .any(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == true, "\(attr.name) is not to-many!")
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("ANY %K == %@",[resolve(context)+attr.name,val])
			case .all(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == true)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("ALL %K == %@",[resolve(context)+attr.name,val])
			case .gt(let context,let attr, let val):
				assert(val != nil)
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K > %@",[resolve(context)+attr.name,val])
			case .lt(let context,let attr, let val):
				assert(val != nil)
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K < %@",[resolve(context)+attr.name,val])
			case .ge(let context,let attr, let val):
				assert(val != nil)
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K >= %@",[resolve(context)+attr.name,val])
			case .le(let context,let attr, let val):
				assert(val != nil)
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K <= %@",[resolve(context)+attr.name,val])
			case .and(let nodeL, let nodeR):
				let l = compile(ent:ent, expr: nodeL)
				let r = compile(ent:ent, expr: nodeR)
				if l.0 == ""{
					return r
				}
				if r.0 == ""{
					return l
				}
				return ( "(\(l.0) && (\(r.0)))",l.1 + r.1)
			case .or(let nodeL, let nodeR):
				let l = compile(ent:ent, expr: nodeL)
				let r = compile(ent:ent, expr: nodeR)
				if l.0 == ""{
					return r
				}
				if r.0 == ""{
					return l
				}
				return ( "(\(l.0) || (\(r.0)))",l.1 + r.1)
			case .contains(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K CONTAINS %@",[resolve(context)+attr.name,val])
			case .matches(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K MATCHES %@",[resolve(context)+attr.name,val])
			case .like(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K LIKE %@",[resolve(context)+attr.name,val])
			case .likeIgnoreCase(let context,let attr, let val):
				assert((attr as? CoreDataRelatEntry)?.isToMany ?? false == false)
				assert(attr.parent.description==ent.description,"expected \(ent.name ?? "???") but was \(attr.parent.name ?? "???")")
				return ("%K LIKE [c] %@",[resolve(context)+attr.name,val])
			case .empty:
				return ("",[])
			case .countEqualsInt(let subquery,let val):
				let (str,vals) = compile(ent:subquery.relat.destEnt, expr: subquery.expr)
				return ("SUBQUERY(\(subquery.relat.name),\(subquery.context),\(str)).@count == %@", vals + [val])
			}
		}
		(formula,params) = compile(ent:ent, expr: expr)
		pred = NSPredicate(format: formula, argumentArray: params as [Any])
	}
	
	open func fetchReq(limit:Int=0,sort:[NSSortDescriptor]?=nil)-> NSFetchRequest<NSManagedObject>{
		return ent.fetchReq(pred: self, limit: limit, sort: sort)
	}
	
	
	open func fetch(limit:Int=0,sort:[NSSortDescriptor]?=nil) -> [NSManagedObject]?{
		return try? cntx.fetch(fetchReq(limit:limit,sort:sort))
	}
	
	open func count()->Int{
		return (try? cntx.count(for: fetchReq())) ?? 0
	}
	
	open func max(_ attrName:CoreDataAttr)->NSManagedObject?{
		return top(attrName, min: false)
	}
	
	open func min(_ attrName:CoreDataAttr)->NSManagedObject?{
		return top(attrName, min: true)
	}
	
	open func top(_ attrName:CoreDataAttr, min:Bool)->NSManagedObject?{
		assert(ent.description == attrName.parent.description)
		let sortDescriptor = NSSortDescriptor(key: attrName.name, ascending: min)
		let out = fetch(limit: 1, sort: [sortDescriptor])
		return out?.first
	}
	
	open func exists()->Bool{
		return 0 < (try? cntx.count(for: fetchReq(limit: 1))) ?? 0
	}
	
	open func getFirst(sort: [NSSortDescriptor]?=nil)->NSManagedObject?{
		return fetch(limit: 1, sort:sort)?.first
	}
	
	public func makeReqController(sort:[NSSortDescriptor]?=nil, delegate:NSFetchedResultsControllerDelegate?=nil)-> NSFetchedResultsController<NSManagedObject>{
		let req = fetchReq(sort:sort)
		let cnt = NSFetchedResultsController<NSManagedObject>(
			fetchRequest: req,
			managedObjectContext: cntx,
			sectionNameKeyPath: nil,
			cacheName: nil)
		cnt.delegate = delegate
		return cnt
	}
	
}



public extension SafePredicate.Node{
	func and(_ r:SafePredicate.Node)->SafePredicate.Node{
		return .and(self,r)
	}
	
	func or(_ r:SafePredicate.Node)->SafePredicate.Node{
		return .or(self,r)
	}
}



public extension CoreDataAttr{
	func equalsOrAny(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		if let relat = self as? CoreDataRelatEntry, relat.isToMany == true{
			return any(val,using:context)
		}
		return equals(val,using:context)
	}
	func equals(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val), "\(rawType.name) doesn't accept \(val ?? "nil")!")
		return .equals(context,self,val)
	}
	
	func contains(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		assert(rawType==NSAttributeType.stringAttributeType)
		return .contains(context,self,val)
	}
	func matches(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		assert(rawType==NSAttributeType.stringAttributeType)
		return .matches(context,self,val)
	}
	func like(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		assert(rawType==NSAttributeType.stringAttributeType)
		return .like(context,self,val)
	}
	func likeIgnoreCase(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		assert(rawType==NSAttributeType.stringAttributeType)
		return .likeIgnoreCase(context,self,val)
	}
	func any(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		return .any(context,self,val)
	}
	func all(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		return .all(context,self,val)
	}
	func lt(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		return .lt(context,self,val)
	}
	func gt(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		return .gt(context,self,val)
	}
	func le(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		return .le(context,self,val)
	}
	func ge(_ val:Any?,using context:String?=nil)->SafePredicate.Node{
		assert(rawType.checkType(of: val))
		return .ge(context,self,val)
	}
	
}




public extension CoreDataRelatEntry{
	func subquery(using context:String, _ expr:SafePredicate.Node) -> Subquery{
		return Subquery(relat: self, using:context, expr)
	}
}

public extension SafePredicate{
	public convenience init(ent:CoreDataEntity, mainAttrVal val: Any?){
		self.init(ent: ent, expr: ent.primaryKeyAttr.equals(val))
	}
	public convenience init(relat attr:CoreDataRelatEntry,to mo:NSManagedObject?){
//		let arg:[Any] = [attr.inverseAttr.name,mo as Any]
		if let mo = mo{
			assert(mo.entity==attr.parent.description, "mo should be of type \(attr.parent.name ?? "???") but was \(mo.entity.name ?? "???") !")
		}
//		self.init(format: "ANY %K == %@", argumentArray: arg)
		self.init(ent: attr.destEnt, expr: attr.inverseAttr.equalsOrAny(mo))
	}
}
