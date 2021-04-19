//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class RelatTableViewCell: UITableViewCell,PropertyTableCell,PropertyCell{
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
			valueButton.setTitle(String?.OR,for:.normal)
			return
		}
        let val = newValue as! CellRelatEntry
        let mo = val.mo
        let attr = val.attr
        let str = attr.serializer.stringify(maybeAny: mo).or()
        valueButton.setTitle(str, for: .normal)
    }
    
    var type: PropertyType = .relat
    
    @IBOutlet weak var valueButton: UIButton!
    
    @IBAction func pressed(_ sender: Any) {
		let val = property?.value as! CellRelatEntry?
		property?.onChange(event: PropertyTableEntryRelatPressEvent(mo: val?.mo, relat: val?.attr))
    }
}
