//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class StringTableViewCell: UITableViewCell, PropertyTableCell,PropertyCell{
	var isEnabled: Bool{
		get{
			return stringField.isEnabled
		}
		set{
			stringField.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        stringField.text = newValue as! String? ?? ""
    }
    
    var type: PropertyType = .string
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var stringField: UITextField!
    
    @IBAction func stringChanged(_ sender: UITextField) {
        update(value: stringField.text)
    }
}
