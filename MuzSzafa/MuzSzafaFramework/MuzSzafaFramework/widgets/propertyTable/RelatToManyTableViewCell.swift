//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class RelatToManyTableViewCell: UITableViewCell,PropertyTableCell,PropertyCell{
	var isEnabled: Bool {
		set{
			valueButton.isEnabled = newValue
		}
		get{
			return valueButton.isEnabled
		}
	}
	
    var property: PropertyTableEntry?
    
	
	func propertyTableCell(newValue: Any?) {
		
		guard let newValue = newValue else{
			valueButton.setTitle(String?.OR, for: UIControlState.normal)
			return
		}
		let val = newValue as! CellRelatToManyEntry
		let mos = val.mos
		let attr = val.attr
		let serializer = attr.serializer
		let str = serializer.stringify(maybeAny: mos)
		valueButton.setTitle(str.or(), for: UIControlState.normal)
		
	}

	var type: PropertyType = .relatToMany
    
    @IBOutlet weak var valueButton: UIButton!
    
    @IBAction func pressed(_ sender: Any) {
		let val = property?.value as! CellRelatToManyEntry?
		property?.onChange(event: PropertyTableEntryRelatPressEvent(mo: nil, relat: val?.attr))
    }
}
