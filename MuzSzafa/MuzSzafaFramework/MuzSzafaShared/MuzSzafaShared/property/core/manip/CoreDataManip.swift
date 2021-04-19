////
////  CoreDataManip.swift
////  MuzSzafaShared
////
////  Created by Alagris on 28/03/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//
//
//import CoreData
//
//public protocol CoreDataManip{
//    var name:String{get}
//    
//    func fetchReq()->NSFetchRequest<NSManagedObject>
//    func fetch(_ context:NSManagedObjectContext)->[NSManagedObject]?
//    func count(_ context:NSManagedObjectContext,_ pred:NSPredicate?)->Int
//    func getEntity(_ context:NSManagedObjectContext)->NSEntityDescription?
//    func getNew(_ context:NSManagedObjectContext)->NSManagedObject
//    func exists(_ context:NSManagedObjectContext,_ attrName:String,_ attrVal:Any?)->Bool
//    func select(_ context:NSManagedObjectContext,
//                _ attrName:String,
//                _ attrVal:Any?,
//                limit:Int,
//                sort:[NSSortDescriptor]?)->[NSManagedObject]?
//    func select(_ context:NSManagedObjectContext,
//                _ predicate:NSPredicate,
//                limit:Int,
//                sort:[NSSortDescriptor]?)->[NSManagedObject]?
//    func getFirst(_ context:NSManagedObjectContext,_ attrName:String,_ attrVal:Any)->NSManagedObject?
//    func otherFetchReq<Result>()->NSFetchRequest<Result>
//}
//public extension CoreDataManip{
//    public func fetchReq()->NSFetchRequest<NSManagedObject>{
//        return NSFetchRequest<NSManagedObject>(entityName: name)
//    }
//    public func otherFetchReq<Result>()->NSFetchRequest<Result>{
//        return NSFetchRequest<Result>(entityName: name)
//    }
//    public func fetch(_ context:NSManagedObjectContext)->[NSManagedObject]?{
//        do {
//            return try context.fetch(fetchReq())
//        } catch {
//            return nil
//        }
//    }
//    public func getEntity(_ context:NSManagedObjectContext)->NSEntityDescription?{
//        return NSEntityDescription.entity(forEntityName: name, in: context);
//    }
//    public func getNew(_ context:NSManagedObjectContext)->NSManagedObject{
//        return NSEntityDescription.insertNewObject(forEntityName: name, into: context);
//    }
//    public func count(_ context:NSManagedObjectContext,_ attrName:String,_ attrVal:Any?)->Int{
//        return count(context, NSPredicate(attrName,attrVal))
//    }
//    public func count(_ context:NSManagedObjectContext,_ pred:NSPredicate?)->Int{
//        let fr = fetchReq()
//        fr.predicate = pred
//        do{
//            return try context.count(for: fr)
//        }catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return 0
//    }
//    public func max(_ context:NSManagedObjectContext,_ pred:NSPredicate, _ attrName:String)->NSManagedObject?{
//        return top(context, pred, attrName, min: false)
//    }
//    public func min(_ context:NSManagedObjectContext,_ pred:NSPredicate, _ attrName:String)->NSManagedObject?{
//        return top(context, pred, attrName, min: true)
//    }
//    public func top(_ context:NSManagedObjectContext,_ pred:NSPredicate, _ attrName:String, min:Bool)->NSManagedObject?{
//        let sortDescriptor = NSSortDescriptor(key: attrName, ascending: min)
//        let out = select(context, pred, limit: 1, sort: [sortDescriptor])
//        return out?.first
//    }
//    public func exists(_ context:NSManagedObjectContext,_ attrName:String,_ attrVal:Any?)->Bool{
//        return count(context,attrName,attrVal) > 0
//    }
//    public func select(_ context:NSManagedObjectContext,
//                       _ attrName:String,
//                       _ attrVal:Any?,
//                       limit:Int=0,
//                       sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
//        return select(context,NSPredicate(attrName, attrVal),limit: limit,sort:sort)
//    }
//    
//    public func select(_ context:NSManagedObjectContext,
//                       _ predicate:NSPredicate,
//                       limit:Int=0,
//                       sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
//        let fr = fetchReq()
//        fr.predicate=predicate
//        fr.fetchLimit = limit
//        fr.sortDescriptors = sort
//        do{
//            return try context.fetch(fr)
//        }catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return nil
//    }
//    public func getFirst(_ context:NSManagedObjectContext,_ attrName:String,_ attrVal:Any)->NSManagedObject?{
//        if let i = select(context, attrName, attrVal,limit:1){
//            if i.count > 0{
//                return i[0]
//            }
//        }
//        return nil
//    }
//    
//}
