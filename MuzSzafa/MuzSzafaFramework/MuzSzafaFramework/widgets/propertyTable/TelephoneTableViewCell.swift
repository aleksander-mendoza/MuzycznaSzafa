//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class TelephoneTableViewCell: UITableViewCell, PropertyTableCell, PropertyCell{
	var isEnabled: Bool{
		get{
			return telephoneField.isEnabled
		}
		set{
			telephoneField.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        telephoneField.text = newValue as! String? ?? ""
    }
    
    var type: PropertyType = .telephone
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var telephoneField: TelephoneField!
    
    @IBAction func telephoneChanged(_ sender: TelephoneField) {
        update(value: telephoneField.text)
    }
}
