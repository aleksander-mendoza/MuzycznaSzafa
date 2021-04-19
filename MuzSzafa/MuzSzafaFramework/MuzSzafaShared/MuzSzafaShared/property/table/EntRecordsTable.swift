//
//  EntRecordsTable.swift
//  MuzSzafaShared
//
//  Created by Alagris on 12/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
public protocol EntRecordsTable:EntListTable {
	
    var sort:[NSSortDescriptor]?{get set}
    var pred:SafePredicate?{get set}
    var controller:NSFetchedResultsController<NSManagedObject>?{get}
    var tickable:Bool{get set}
    func isTicked(at row:Int)->Bool
    
    func ticked()->TickedSequence
	func reloadData(ent: CoreDataEntity?,pred:SafePredicate?,sort:[NSSortDescriptor]?)
}
public extension EntRecordsTable{
    public func makeReqController()->NSFetchedResultsController<NSManagedObject>?{
		if let p = pred{
			assert(p.ent == ent,"expected \((ent?.name).or()) but was \(p.ent.name.or())")
        	return p.makeReqController(sort: sort, delegate: ent?.delegate)
		}else{
			return ent?.makeReqController(sort: sort, delegate: ent?.delegate)
		}
    }
    public func get(at row:Int)->NSManagedObject?{
        guard let c = controller else{
            return nil
        }
        if row < 0 || row >= c.count{
            return nil
        }
        return c.object(at: IndexPath(arrayLiteral: 0, row))
    }
    public func find(obj:NSManagedObject)->Int?{
        let c = controller
        let p = c?.indexPath(forObject: obj)
        let out = p?[1]
        return out
    }
	
	
	
    public func updateController()->Bool{
        if let c = controller, c.fetchRequest.entity == ent?.description{
            if let s = sort{
                c.fetchRequest.sortDescriptors = s
            }
			assert(pred == nil ? true : pred!.ent==ent,"expected \(ent?.name ?? "nil") but was \(pred!.ent.name ?? "nil")")
            c.fetchRequest.predicate = pred?.pred
            c.delegate = ent?.delegate
            return true
        }
        return false
    }
    public func numberOfRows()->Int{
        let c = controller
        let count = c?.count
        return count ?? 0
    }
    public func reloadData(pred:SafePredicate?) {
        self.pred = pred
        reloadData()
    }
	
	public func reloadData(ent: CoreDataEntity?){
		reloadData(ent: ent,pred:nil,sort:nil)
	}
	public func reloadData(ent: CoreDataEntity?,pred:SafePredicate?){
		reloadData(ent: ent,pred:pred,sort:nil)
	}
	public func reloadData(mo: NSManagedObject?,
						   relat attr:CoreDataRelatEntry,
						   cache:CoreDataCache){
		
		assert(attr.isToMany, "attribute \(attr.name) must be to-many!")
		assert(mo != nil ? mo!.findEnt(in: cache) == attr.parent : true, "mo is of type \((mo!.findEnt(in: cache)?.name).or()) but should be \(attr.parent.name.or())!")
		
		reloadData(ent: attr.destEnt,pred: SafePredicate(relat: attr, to: mo))
	}
    
    public func ticked()->TickedSequence{
        return TickedSequence(parent:self)
    }
}
public class TickedSequence:Sequence{
    public func makeIterator() -> TickedIterator {
        return TickedIterator(parent: parent)
    }
    
    public typealias Element = NSManagedObject
    public typealias Iterator = TickedIterator
    private let parent:EntRecordsTable
    fileprivate init(parent:EntRecordsTable){
        self.parent = parent
    }
}
public class TickedIterator:IteratorProtocol{
    public func next() -> NSManagedObject? {
        while index < parent.numberOfRows(){
            let i = index
            index += 1
            guard parent.isTicked(at: i) else{
                continue
            }
            guard let v = parent.get(at: i) else{
                continue
            }
            return v
        }
        return nil
    }
    private var index = 0
    private let parent:EntRecordsTable
    public typealias Element = NSManagedObject
    fileprivate init(parent:EntRecordsTable){
        self.parent = parent
    }
}


