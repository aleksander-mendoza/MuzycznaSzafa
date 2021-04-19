//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class DisplayTableViewCell: UITableViewCell, PropertyTableCell,PropertyCell{

	var isEnabled: Bool {
		set{
			
		}
		get{
			return false
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
		detailTextLabel?.text = stringify(maybe:newValue)
    }
    
    var type: PropertyType = .display
    
}
