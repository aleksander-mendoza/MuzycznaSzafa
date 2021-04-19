//
//  CoreDataTable.swift
//  MuzSzafa
//
//  Created by Alagris on 20/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
import MuzSzafaShared
open class CoreDataTable:PropertyTable,EntPropertyTable{
	
	
	public var isEnabled:Bool{
		get{
			return isUserInteractionEnabled
		}
		set{
			isUserInteractionEnabled = newValue
		}
	}
	
	public var areRecordsSetManually: Bool = false
	
    public func reloadData(attr: String) {
		if let i = index(attr: attr){
			updateValue(at: i)
			reloadRows(at: [IndexPath(index: i)], with: UITableViewRowAnimation.none)
		}
    }
    
    
    public var ent: CoreDataEntity?
    
    public var obj: NSManagedObject?
	
	public override var onAddRequestImpl: ((IndexPath) -> ())? {
		get{
			return { [weak self] index in
				guard let a = self!.attr(at: index.row) else {return}
				self!.onChangeImpl?(
					nil,
					a,
					PropertyTableEntryMOAddEvent.singleton
				)
			}
		}
		set{
			
		}
	}
	
	public override var onModifyRequestImpl: ((IndexPath) -> ())? {
		get{
			return { [weak self] index in
				guard let a = self!.attr(at: index.row) else {return}
				self!.onChangeImpl?(
					nil,
					a,
					PropertyTableEntryValChangeEvent.singleton
				)
			}
		}
		set{
			
		}
	}
	
	public override var onRemoveRequestImpl: ((IndexPath) -> ())? {
		get{
			return { [weak self] index in
				guard let a = self!.attr(at: index.row) else {return}
				self!.onChangeImpl?(
					nil,
					a,
					PropertyTableEntryMORemoveEvent.singleton
				)
			}
		}
		set{
			
		}
	}
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var onChangeImpl: EntPropertyObeserver?
	
	open override func reloadData() {
		reloadEnt()
		updateAllValues()
		isEnabled = areRecordsSetManually || obj != nil
		super.reloadData()
	}
	
}

