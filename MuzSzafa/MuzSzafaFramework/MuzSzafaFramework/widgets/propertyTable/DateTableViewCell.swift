//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class DateTableViewCell: UITableViewCell, PropertyTableCell,PropertyCell{
	var isEnabled: Bool{
		get{
			return datePicker.isEnabled
		}
		set{
			datePicker.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        datePicker.date = newValue as! Date? ?? Date()
    }
    
    var type: PropertyType = .date
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        update(value: datePicker.date)
    }
}
