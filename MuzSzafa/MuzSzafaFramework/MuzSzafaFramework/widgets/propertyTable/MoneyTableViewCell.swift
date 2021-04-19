//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class MoneyTableViewCell: UITableViewCell, PropertyTableCell, PropertyCell{
	var isEnabled: Bool{
		get{
			return moneyField.isEnabled
		}
		set{
			moneyField.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        moneyField.setMoneyValue(numerifyToInt64(maybe:newValue))
    }
    
    var type: PropertyType = .money
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var moneyField: MoneyTextField!
    
    @IBAction func moneyChanged(_ sender: MoneyTextField) {
        update(value: moneyField.getMoneyValue())
    }
}
