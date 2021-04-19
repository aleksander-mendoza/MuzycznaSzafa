//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class ButtonTableViewCell: UITableViewCell,PropertyTableCell{
	var isEnabled: Bool{
		get{
			return valueButton.isEnabled
		}
		set{
			valueButton.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newName: String) {
        valueButton.setTitle(newName, for: .normal)
    }
    
    func propertyTableCell(newValue: Any?) {}
    
    var type: PropertyType = .button
    
    @IBOutlet weak var valueButton: UIButton!
    
    @IBAction func pressed(_ sender: Any) {
        property?.onChange()
    }
}
