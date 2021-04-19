//
//  EntitiesFilteredTableView.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 08/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
open class EntitiesFilteredTableView: EntitiesTableView, EntFilteredRecordsTable{
    public var filter: ((NSManagedObject) -> Bool)?
    
    public var filteredObjects: [NSManagedObject] = []
	
	
	
	private class MOListDataDelegateImpl:MOListDataDelegate{
		func getField(of mo: NSManagedObject, attr index: Int) -> String? {
			return parent.getField(of: mo, attr: index)
		}
		
		let parent:EntitiesFilteredTableView
		init(parent:EntitiesFilteredTableView){
			self.parent=parent
		}
		
		func get(at row: Int) -> NSManagedObject? {
			return parent.getFiltered(at:row)
		}
		func numberOfRows() -> Int {
			return parent.numberOfFilteredRows()
		}
		func find(obj mo: NSManagedObject) -> Int? {
			return parent.filteredObjects.firstIndex(of: mo)
		}
		
	}
	
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		dataDelegate = MOListDataDelegateImpl(parent: self);
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		dataDelegate = MOListDataDelegateImpl(parent: self);
	}
    open override func reloadData() {
        reloadController()
        updateFiltered()
        superReloadData()
    }
	
}
