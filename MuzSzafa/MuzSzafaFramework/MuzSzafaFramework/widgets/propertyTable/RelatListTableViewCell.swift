//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
import CoreData
class RelatListTableViewCell: UITableViewCell,PropertyTableCell,PropertyCell{
	var isEnabled: Bool {
		set{
			valueTable.isEnabled = newValue
		}
		get{
			return valueTable.isEnabled
		}
	}
	
    var property: PropertyTableEntry?
	
	public var ent:CoreDataEntity?{
		get{
			return property?.options[.ent] as! CoreDataEntity?
		}
	}
	
	func propertyTableCell(newLocalizedName: String) {
//		valueTable.reloadData(ent: nil)
		textLabel?.text = newLocalizedName
	}
	
	func propertyTableCell(newValue: Any?) {
		
		guard let newValue = newValue else{
			valueTable.reloadData(ent: nil)
			return
		}
		let val = newValue as! CellRelatListEntry
		let mo = val.mo
		let attr = val.relat
		valueTable.reloadData(mo: mo, relat: attr, cache: attr.getCache())
	}
	
    
    var type: PropertyType = .relatList
    
	@IBOutlet weak var valueTable: EntitiesTableView!{
		didSet{
			valueTable.onChangeImpl = { [weak self] _ in
				guard let selected = self!.valueTable.getSelected() else {return}
				self!.property?.onChange(event: PropertyTableEntryMOSelectEvent(mo: selected))
			}
			valueTable.reloadData(ent: nil)
		}
	}
    
}
