////
////  CoreDataPkManip.swift
////  MuzSzafaShared
////
////  Created by Alagris on 28/03/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//
//import CoreData
//public protocol CoreDataPkManip:CoreDataManip{
//    var primaryKey:String{get}
//}
//public extension CoreDataPkManip{
//    public func count(_ context: NSManagedObjectContext, mainAttrVal: Any?) -> Int {
//        return count(context, primaryKey, mainAttrVal)
//    }
//    public func select(_ context: NSManagedObjectContext,
//                       mainAttrVal: Any?,
//                       limit: Int=0,
//                       sort:[NSSortDescriptor]?=nil) -> [NSManagedObject]? {
//        return select(context, primaryKey, mainAttrVal, limit: limit,sort:sort)
//    }
//    public func exists(_ context:NSManagedObjectContext,_ attrVal:Any)->Bool{
//        return exists(context, primaryKey, attrVal)
//    }
//    public func getFirst(_ context:NSManagedObjectContext,_ attrVal:Any) -> NSManagedObject?{
//        return getFirst(context,primaryKey,attrVal)
//    }
//    
//    public func ensureExists(_ context:NSManagedObjectContext,_ mainAttrVal:Any)->NSManagedObject{
//        if let i = getFirst(context, mainAttrVal){
//            return i
//        }else{
//            let i = getNew(context)
//            i.setValue(mainAttrVal, forKey: primaryKey)
//            return i
//        }
//    }
//    
//    public func addIfNotExists(_ context:NSManagedObjectContext,_ mainAttrVal:Any)->NSManagedObject?{
//        if getFirst(context, mainAttrVal) == nil{
//            let i = getNew(context)
//            i.setValue(mainAttrVal, forKey: primaryKey)
//            return i
//        }
//        return nil
//    }
//    
//    public func sortByPk(_ ascending:Bool=true)->NSSortDescriptor{
//        return NSSortDescriptor(key: primaryKey, ascending: ascending)
//    }
//    public func primaryKey(of obj:NSManagedObject)->Any?{
//        return obj.value(forKey: primaryKey)
//    }
//    public func filterBy(mainAttrVal:Any?)->NSPredicate{
//        return NSPredicate(format: "%K == %@", argumentArray: [primaryKey, mainAttrVal ?? "NIL"])
//    }
//    public func getNew(_ context:NSManagedObjectContext,mainAttrVal:Any)->NSManagedObject?{
//        guard count(context,mainAttrVal: mainAttrVal) == 0 else{
//            return nil
//        }
//        let mo = getNew(context)
//        mo.setValue(mainAttrVal, forKey: primaryKey)
//        return mo
//    }
//}
