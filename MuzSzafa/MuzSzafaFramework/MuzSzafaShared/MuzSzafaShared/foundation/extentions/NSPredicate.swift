//
//  NSPredicate.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
public extension NSPredicate{
    
    public convenience init(_ attrName:String,_ attrVal:Any?){
        self.init(format: "%K == %@", argumentArray: [attrName,attrVal ?? "NIL"])
    }
    public convenience init(_ attrName:String,count attrVal:Any?){
        let arg:[Any] = [attrName,attrVal ?? "NIL"]
        self.init(format: "(%K == %@).@count", argumentArray: arg)
    }
    public convenience init(_ attrName:String,like:String){
        self.init(format: "%K LIKE %@", argumentArray: [attrName,like])
    }
	public convenience init(relat attr:CoreDataRelatEntry,to mo:NSManagedObject?){
		let arg:[Any] = [attr.inverseAttr.name,mo as Any]
		if let mo = mo{
			assert(mo.entity==attr.parent.description, "mo should be of type \(attr.parent.name ?? "???") but was \(mo.entity.name ?? "???") !")
		}
		self.init(format: "ANY %K == %@", argumentArray: arg)
		
	}
    public convenience init(_ attrName:String,contains:String){
        self.init(format: "%K CONTAINS %@", argumentArray: [attrName,contains])
    }
    public convenience init(_ attrName:String,regex:String){
        self.init(format: "%K MATCHES %@", argumentArray: [attrName,regex])
    }
    
    public convenience init(_ val:Any,between smaller:String,and bigger:String){
        self.init(format: "%K < %@ && %@ < %K", argumentArray: [smaller,val,val,bigger])
    }
    public convenience init(_ val:Any,greaterEqual smaller:String,lessEqual bigger:String){
        self.init(format: "%K <= %@ && %@ <= %K", argumentArray: [smaller,val,val,bigger])
    }
    public convenience init(_ val:Any,greater smaller:String,lessEqual bigger:String){
        self.init(format: "%K < %@ && %@ <= %K", argumentArray: [smaller,val,val,bigger])
    }
    public convenience init(_ val:Any,greaterEqual smaller:String,less bigger:String){
        self.init(format: "%K <= %@ && %@ < %K", argumentArray: [smaller,val,val,bigger])
    }
}
