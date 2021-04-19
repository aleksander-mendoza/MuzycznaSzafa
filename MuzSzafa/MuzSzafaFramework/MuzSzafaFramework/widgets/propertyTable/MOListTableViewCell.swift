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
class MOListTableViewCell: UITableViewCell,PropertyTableCell,PropertyCell{
	var isEnabled: Bool {
		set{
			valueTable.isEnabled = newValue
		}
		get{
			return valueTable.isEnabled
		}
	}
	
    var property: PropertyTableEntry?
	
	func propertyTableCell(newOptions: PropertyOptionDict) {
		if newOptions.keys.contains(.editable) {
//			updateEditable() //not applicable to iOS
		}
		if newOptions.keys.contains(.ent) {
			updateEnt()
		}
	}
	func propertyTableCell(newOption: PropertyOptions) {
		switch(newOption){
		case .editable:
//			updateEditable() //not applicable to iOS
			break
		case .ent:
			updateEnt()
		default:
			assertionFailure()
		}
	}
	
	private func updateEnt(){
		if let ent = self.ent{
			if valueTable.ent?.description != ent.description{
				valueTable.reloadData(ent: ent, list: [])
			}
		}
	}
	
	public var ent:CoreDataEntity?{
		get{
			return property?.options[.ent] as! CoreDataEntity?
		}
	}
	
    func propertyTableCell(newValue: Any?) {
		guard let newValue = newValue else{
			valueTable.reloadData(ent: nil, list:[])
			return
		}
		let val = newValue as! [NSManagedObject]
		assert(ent != nil)
		valueTable.reloadData(ent: ent, list:val)
    }
    
    var type: PropertyType = .moList
    
	@IBOutlet weak var valueTable: MOManualListTableView!{
		didSet{
			valueTable.onChangeImpl = { [weak self] _ in
				self!.property?.onChange()
			}
		}
	}
    
}
