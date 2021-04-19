//
//  CoreContextObserver.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/09/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData


open class CoreContextObserver{
	
	public convenience init(cntx:CoreContext){
		self.init(cntx:cntx.get())
	}
	
	public init(cntx:NSManagedObjectContext){
		let name = Notification.Name.NSManagedObjectContextObjectsDidChange
		NotificationCenter.default.addObserver(self,
											   selector: #selector(modification),
											   name: name,
											   object: cntx)
		
	}
	
	open class CoreContextChangeCache{
		open private(set) var inserted:Set<NSManagedObject>?
		open private(set) var updated:Set<NSManagedObject>?
		open private(set) var deleted:Set<NSManagedObject>?
		open var first:NSManagedObject?{
			if let i = inserted, let o = i.first{
				return o
			} else if let i = updated, let o = i.first{
				return o
			} else if let i = deleted, let o = i.first{
				return o
			}
			return nil
		}
		func set(_ notification:Notification){
			guard let info = notification.userInfo else {return}
			typealias MOSet = Set<NSManagedObject>
			func nilIfEmpty(_ set:MOSet?)->Set<NSManagedObject>?{
				if set?.isEmpty ?? false {return nil}
				return set
			}
			inserted = nilIfEmpty(info[NSInsertedObjectsKey] as? MOSet)
			updated = nilIfEmpty(info[NSUpdatedObjectsKey] as? MOSet)
			deleted = nilIfEmpty(info[NSDeletedObjectsKey] as? MOSet)
		}
		
		
	}
	
	open var cacheLast:CoreContextChangeCache?
	
	open var cacheLastEnabled:Bool{
		get{
			return cacheLast != nil
		}
		set{
			if newValue{
				cacheLast = CoreContextChangeCache()
			}else{
				cacheLast = nil
			}
		}
	}
	
	@objc private func modification(_ notification:Notification){
		cacheLast?.set(notification)
	}
}
