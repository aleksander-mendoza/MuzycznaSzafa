//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class DisplayTableViewCell: NSTableCellView,PropertyTableCellMac, AutomaticTitleCell {
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
    
    var type: PropertyType = .display
    
	
	func propertyTableCell(newValue: Any?) {
        cellValue.stringValue = stringify(maybe:newValue).or()
    }
	
	
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender:sender)
	}
	
	@IBOutlet weak var help: NSButton!
	
    @IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: NSTextField!
    
    
}
