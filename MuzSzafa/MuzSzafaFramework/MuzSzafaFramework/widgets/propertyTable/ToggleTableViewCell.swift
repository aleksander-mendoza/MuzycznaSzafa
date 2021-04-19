//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class ToggleTableViewCell: UITableViewCell,PropertyTableCell,PropertyCell{
	var isEnabled: Bool{
		get{
			return valueButton.isEnabled
		}
		set{
			valueButton.isEnabled = newValue
		}
	}
	
    func propertyTableCell(newName: String) {
        cellTitle?.text = getLocalizedString(for: newName)
        valueButton.textOff = getLocalizedString(for: newName+"_off")
        valueButton.textOn = getLocalizedString(for: newName+"_on")
    }
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        valueButton.isOn = newValue as! Bool? ?? false
    }
    
    var type: PropertyType = .toggle
    
    @IBOutlet weak var valueButton: ToggleButton!{
        didSet{
            valueButton.onChangeImpl = {
                [weak self] in
                self!.update(value: self!.valueButton.isOn)
            }
        }
    }
}
