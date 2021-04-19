////
////  CoreDataControlledManip.swift
////  MuzSzafaShared
////
////  Created by Alagris on 12/04/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//import CoreData
//public protocol CoreDataControlledManip: CoreDataCntxManip {
//    var delegate:NSFetchedResultsControllerDelegate?{get set}
//}
//
//public extension CoreDataControlledManip{
//    
//    public func makeReqController(_ attrName: String,
//                                  _ attrVal: Any,
//                                  sort:[NSSortDescriptor]?=nil)-> NSFetchedResultsController<NSManagedObject>{
//		
//        let pred = NSPredicate(attrName, attrVal)
//        return makeReqController(pred:pred ,sort: sort)
//    }
//    
//    public func makeReqController(pred:NSPredicate?=nil,
//                                  sort:[NSSortDescriptor]?=nil,
//                                  delegate:NSFetchedResultsControllerDelegate?=nil)-> NSFetchedResultsController<NSManagedObject>{
//        let req = manip.fetchReq()
//        req.predicate = pred
//        req.sortDescriptors = sort ?? [manip.sortByPk()]
//        let cnt = NSFetchedResultsController<NSManagedObject>(
//            fetchRequest: req,
//            managedObjectContext: cntx.get(),
//            sectionNameKeyPath: nil,
//            cacheName: nil)
//        cnt.delegate = delegate ?? self.delegate
//        return cnt
//    }
//    public func makePlainReqController(sort:[NSSortDescriptor]?=nil)-> NSFetchedResultsController<NSManagedObject>{
//        let req = manip.fetchReq()
//        req.sortDescriptors = sort ?? [manip.sortByPk()]
//        let cnt = NSFetchedResultsController<NSManagedObject>(
//            fetchRequest: req,
//            managedObjectContext: cntx.get(),
//            sectionNameKeyPath: nil,
//            cacheName: nil)
//        return cnt
//    }
//}
