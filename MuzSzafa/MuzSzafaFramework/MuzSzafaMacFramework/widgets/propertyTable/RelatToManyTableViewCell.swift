//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class RelatToManyTableViewCell: NSTableCellView,AutomaticTitleCell, PropertyTableCellMac {
	var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			cellValue.isEnabled = newValue
		}
		get{
			return cellValue.isEnabled
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newOptions: PropertyOptionDict) {
    }
	
    func propertyTableCell(newOption: PropertyOptions) {
    }
	
    func propertyTableCell(newValue: Any?) {
        
        guard let newValue = newValue else{
            cellValue.title = String?.OR
            return
        }
        let val = newValue as! CellRelatToManyEntry
        let mos = val.mos
        let attr = val.attr
        let serializer = attr.serializer
        let str = serializer.stringify(maybeAny: mos)
        cellValue.title = str.or()
        
    }
    
    var type: PropertyType = .relatToMany
	
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
	
	@IBOutlet weak var help: NSButton!
	
	@IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: NSButton!
    
    @IBAction func pressed(_ sender: Any) {
		let val = property?.value as! CellRelatToManyEntry?
		property?.onChange(event: PropertyTableEntryRelatPressEvent(mo: nil, relat: val?.attr))
    }
}
