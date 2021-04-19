//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class ToggleTableViewCell: NSTableCellView,PropertyTableCellMac {
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
    
    func propertyTableCell(newName: String) {
        cellTitle?.stringValue = getLocalizedString(for: newName)
        cellValue.textOff = getLocalizedString(for: newName+"_off")
        cellValue.textOn = getLocalizedString(for: newName+"_on")
    }
    
    func propertyTableCell(newValue: Any?) {
        cellValue.isOn = newValue as! Bool? ?? false
    }
    
    var delegate: PropertyTableCellDelegate?
    
    var type: PropertyType = .toggle
    
    @IBOutlet weak var cellTitle: NSTextField!
    @IBOutlet weak var cellValue: ToggleButton!{
        didSet{
            cellValue.onChangeImpl = {
                [weak self] in
                self!.update(value:self!.cellValue.isOn)
            }
        }
    }
    @IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
