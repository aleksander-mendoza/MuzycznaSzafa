//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class EmailTableViewCell: UITableViewCell, PropertyTableCell, PropertyCell{
	var isEnabled: Bool{
		get{
			return emailField.isEnabled
		}
		set{
			emailField.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        emailField?.text = newValue as! String? ?? ""
    }
    
    var type: PropertyType = .email
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var emailField: EmailField!
    
    @IBAction func emailChanged(_ sender: EmailField) {
        update(value: emailField.text)
    }
}
