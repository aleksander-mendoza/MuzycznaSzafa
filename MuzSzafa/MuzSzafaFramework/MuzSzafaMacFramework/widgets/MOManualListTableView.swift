//
//  NSSetTableView.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 23/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
import MuzSzafaShared
open class MOManualListTableView:MOListTableView,MOListDataDelegate, EntListTable{
	
	open var value:[NSManagedObject] = []
	
	
	public func get(at row: Int) -> NSManagedObject? {
		guard row < value.count else{
			assertionFailure("\(row) but max is \(value.count)")
			return nil
		}
		guard 0 <= row else{
			return nil
		}
		return value[row]
	}
	
	public func numberOfRows() -> Int {
		return value.count
	}
	
	public func find(obj: NSManagedObject) -> Int? {
		return value.firstIndex(of: obj)
	}
	
	
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		dataDelegate = self
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		dataDelegate = self
	}
	
	open func reloadData(list: [NSManagedObject]) {
		value = list
		for mo in list{
			assert(mo.entity==self.ent?.description,"expected \(ent?.name ?? "???") but found \(mo.entity.name ?? "???")")
		}
		reloadData()
	}
	
	open func reloadData(ent:CoreDataEntity?,list: [NSManagedObject]) {
		self.ent = ent
		reloadData(list:list)
	}
	
	open func append(mo:NSManagedObject, allowDuplicates:Bool=false){
		if allowDuplicates{
			guard !value.contains(mo) else{return}
		}
		value.append(mo)
		reloadData()
	}
	
	open func remove(at index:Int){
		value.remove(at: index)
		reloadData()
		selectRowIndexes([min(index,max(0,value.count-1))], byExtendingSelection: false)
	}
}
