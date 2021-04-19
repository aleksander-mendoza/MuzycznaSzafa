////
////  CoreDataCntxManip.swift
////  MuzSzafaShared
////
////  Created by Alagris on 28/03/2018.
////  Copyright © 2018 alagris. All rights reserved.
////
//import CoreData
//public protocol CoreDataCntxManip{
//    var cntx:CoreContext!{get}
//    var manip:CoreDataPkManip{get}
//    
//    func fetch()->[NSManagedObject]?
//    func getEntity()->NSEntityDescription?
//    func getNew()->NSManagedObject?
//    func getNew(mainAttrVal:Any)->NSManagedObject?
//    func count(mainAttrVal: Any?) -> Int
//    func count(_ attrName: String, _ attrVal: Any?) -> Int
//    func count(_ pred:NSPredicate?)->Int
//    func exists(_ attrName:String,_ attrVal:Any)->Bool
//    func select(mainAttrVal: Any?,
//                limit: Int,
//                sort:[NSSortDescriptor]?) -> [NSManagedObject]?
//    func select(_ attrName:String,
//                _ attrVal:Any,
//                limit:Int,
//                sort:[NSSortDescriptor]?)->[NSManagedObject]?
//    func select(_ predicate:NSPredicate,
//                limit:Int,
//                sort:[NSSortDescriptor]?)->[NSManagedObject]?
//    func getFirst(_ attrName:String,_ attrVal:Any)->NSManagedObject?
//    func exists(_ attrVal:Any)->Bool
//    func getFirst(_ attrVal:Any) -> NSManagedObject?
//    func ensureExists( mainAttrVal:Any)->NSManagedObject?
//    func addIfNotExists(_ mainAttrVal:Any)->NSManagedObject?
//    func primaryKey(of obj:NSManagedObject)->Any?
//}
//public extension CoreDataCntxManip{
//    
//    func fetch()->[NSManagedObject]?{
//        if let c = cntx?.get(){
//            return manip.fetch(c)
//        }
//        return nil
//    }
//    func getEntity()->NSEntityDescription?{
//        if let c = cntx?.get(){
//            return manip.getEntity(c)
//        }
//        return nil
//    }
//    func getNew()->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.getNew(c)
//        }
//        return nil
//    }
//    func getNew(mainAttrVal:Any)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.getNew(c,mainAttrVal:mainAttrVal)
//        }
//        return nil
//    }
//    func count(mainAttrVal: Any?) -> Int {
//        if let c = cntx?.get(){
//            return manip.count(c, mainAttrVal:mainAttrVal)
//        }
//        return 0
//    }
//    func count(_ attrName: String, _ attrVal: Any?) -> Int{
//        if let c = cntx?.get(){
//            return manip.count(c, attrName,attrVal)
//        }
//        return 0
//    }
//    func count(_ pred:NSPredicate?)->Int{
//        if let c = cntx?.get(){
//            return manip.count(c, pred)
//        }
//        return 0
//    }
//    func max(_ pred:NSPredicate, _ attrName:String)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.max(c, pred,attrName)
//        }
//        return nil
//    }
//    func min(_ pred:NSPredicate, _ attrName:String)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.min(c, pred,attrName)
//        }
//        return nil
//    }
//    func top(_ pred:NSPredicate, _ attrName:String, min:Bool)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.top(c, pred,attrName,min:min)
//        }
//        return nil
//    }
//    func exists(_ attrName:String,_ attrVal:Any)->Bool{
//        if let c = cntx?.get(){
//            return manip.exists(c,attrName, attrVal)
//        }
//        return false
//    }
//    func select(mainAttrVal: Any?,
//                limit: Int,
//                sort:[NSSortDescriptor]?=nil) -> [NSManagedObject]?{
//        if let c = cntx?.get(){
//            return manip.select(c,mainAttrVal:mainAttrVal, limit:limit,sort:sort)
//        }
//        return nil
//    }
//    func select(_ attrName:String,
//                _ attrVal:Any,
//                limit:Int=0,
//                sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
//        if let c = cntx?.get(){
//            return manip.select(c,attrName,attrVal, limit:limit,sort:sort)
//        }
//        return nil
//    }
//    func select(_ predicate:NSPredicate,
//                limit:Int=0,
//                sort:[NSSortDescriptor]?=nil)->[NSManagedObject]?{
//        if let c = cntx?.get(){
//            return manip.select(c,predicate, limit:limit,sort:sort)
//        }
//        return nil
//    }
//    func getFirst(_ attrName:String,_ attrVal:Any)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.getFirst(c,attrName, attrVal)
//        }
//        return nil
//    }
//    
//    func exists(_ attrVal:Any)->Bool{
//        if let c = cntx?.get(){
//            return manip.exists(c, attrVal)
//        }
//        return false
//    }
//    func getFirst(_ attrVal:Any) -> NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.getFirst(c, attrVal)
//        }
//        return nil
//    }
//    func ensureExists( mainAttrVal:Any)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.ensureExists(c, mainAttrVal)
//        }
//        return nil
//    }
//    func addIfNotExists(_ mainAttrVal:Any)->NSManagedObject?{
//        if let c = cntx?.get(){
//            return manip.addIfNotExists(c, mainAttrVal)
//        }
//        return nil
//    }
//    
//    func primaryKey(of obj:NSManagedObject)->Any?{
//        return manip.primaryKey(of: obj)
//    }
//    
//    
//}
