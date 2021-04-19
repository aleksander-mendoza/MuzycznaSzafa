//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class IntTableViewCell: UITableViewCell, PropertyTableCell,PropertyCell{
	var isEnabled: Bool{
		get{
			return counter.isEnabled
		}
		set{
			counter.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        counter?.numberValue = numerifyToInt(newValue ?? 0)
    }
    
    var type: PropertyType = .int
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var counter: CounterField!{
        didSet{
            counter.onChangeImpl = {
                [weak self] in
                self!.update(value: $0)
            }
        }
    }
    
}
