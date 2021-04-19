//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class BoolTableViewCell: NSTableCellView,PropertyTableCellMac {
	var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			cellValue.isEnabled = newValue
		}
		get{
			return cellValue.isEnabled
		}
	}
	
    func propertyTableCell(newLocalizedName: String) {
        cellValue.title = newLocalizedName
    }
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        cellValue.state = (newValue as! Bool? ?? false) ? .on : .off
    }
    
    @IBAction func stateChanged(_ sender: NSButton) {
        update(value: cellValue.state == .on)
    }
    
    var type: PropertyType = .bool
    
    @IBOutlet weak var cellValue: NSButton!
	
	@IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
