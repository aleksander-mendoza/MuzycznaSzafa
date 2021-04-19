//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class EmailTableViewCell: NSTableCellView,AutomaticTitleCell,PropertyTableCellMac, NSTextFieldDelegate {
	var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			cellValue.isEnabled = newValue
		}
		get{
			return cellValue.isEnabled
		}
	}
	
    var firstCellResponder: NSView?{
        get{
            return cellValue
        }
    }
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        cellValue.stringValue = newValue as! String? ?? ""
    }
    
    var type: PropertyType = .email
    
    override func controlTextDidChange(_ obj: Notification) {
        update(value: cellValue.stringValue)
    }
    
    @IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: NSTextField!{
        didSet{
            cellValue.delegate = self
        }
    }
	@IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
