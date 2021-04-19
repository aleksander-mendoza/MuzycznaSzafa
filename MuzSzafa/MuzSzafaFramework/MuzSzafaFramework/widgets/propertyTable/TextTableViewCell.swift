//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class TextTableViewCell: UITableViewCell, PropertyTableCell, UITextViewDelegate,PropertyCell{
	var isEnabled: Bool{
		get{
			return textField.isEditable
		}
		set{
			textField.isEditable = newValue
		}
	}
	
    func propertyTableCell(newValue: Any?) {
        textField.text = newValue as? String? ?? ""
    }
    
    var property: PropertyTableEntry?
    
    var type: PropertyType = .text
    @IBOutlet weak var textField: UITextView!
    
    func textViewDidEndEditing(_ textView: UITextView) {
        update(value: textField.text)
    }
    
}
