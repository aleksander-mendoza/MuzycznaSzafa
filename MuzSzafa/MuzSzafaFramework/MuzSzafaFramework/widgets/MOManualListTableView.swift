//
//  MOManualListTableView.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 15/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import CoreData
import MuzSzafaShared
open class MOManualListTableView:MOListTableView,MOListDataDelegate, EntListTable{
	
	public func delete(at row: Int) -> Bool {
		if row >= value.count {return false}
		value.remove(at: row)
		return true
	}
	
	open var value:[NSManagedObject] = []
	
	
	public func get(at row: Int) -> NSManagedObject? {
		return value[row]
	}
	
	public func numberOfRows() -> Int {
		return value.count
	}
	
	public func find(obj: NSManagedObject) -> Int? {
		return value.firstIndex(of: obj)
	}
	
	
	public override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		dataDelegate = self
	}
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
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
		selectRow(at: IndexPath(index: min(index,max(0,value.count-1))), animated: false, scrollPosition: UITableViewScrollPosition.none)
	}
	
	
}
