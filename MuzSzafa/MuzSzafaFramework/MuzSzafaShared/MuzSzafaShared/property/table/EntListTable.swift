//
//  EntListTable.swift
//  MuzSzafaShared
//
//  Created by Alagris on 23/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
import CoreData
public protocol EntListTable:Reloadable{
	var ent:CoreDataEntity?{get}
	func numberOfRows()->Int
	func get(at row:Int)->NSManagedObject?
	func find(obj:NSManagedObject)->Int?
}
public extension EntListTable{
	public func getField(at row:Int,attr index:Int)->String?{
		guard let mo = get(at:row) else{
			return nil
		}
		return getField(of: mo, attr: index)
	}
	public func getField(of mo:NSManagedObject,attr index:Int)->String?{
		var index = index;
		var vis:PropertyVisibility = .primary
		let repr = ent?.repr
		let primaryCount = repr?.primaryAttrs.count ?? 0
		if index >= primaryCount {
			index -= primaryCount
			vis = .secondary
		}
		let out = repr?.computeField(mo:mo,at:index,vis:vis)
		return out
	}
}
