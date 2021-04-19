//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class ButtonTableViewCell: NSTableCellView,PropertyTableCellMac {
	var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			if let opt = property?.options[.enabled] as! Bool?{
				cellValue.isEnabled = opt
			}else{
				cellValue.isEnabled = newValue
			}
		}
		get{
			return cellValue.isEnabled
		}
	}
	
    func propertyTableCell(newName: String) {
        cellValue.title = newName
    }
    var firstCellResponder: NSView?{
        get{
            return cellValue
        }
    }
    
    var property: PropertyTableEntry?
	
	func propertyTableCell(newOptions: PropertyOptionDict) {
		propertyTableCell(newOption: .enabled)
	}
	
	func propertyTableCell(newOption: PropertyOptions) {
		if newOption == .enabled{
			cellValue.isEnabled = property?.options[.enabled] as! Bool? ?? true
		}else{
			assertionFailure()
		}
	}
    
    func propertyTableCell(newValue: Any?) {}
    
    @IBAction func pressed(_ sender: NSButtonCell) {
        property?.onChange()
    }
    
    var type: PropertyType = .button
    
    @IBOutlet weak var cellValue: NSButton!
	
	@IBOutlet weak var help: NSButton!
	
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
    
}
