//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class TextTableViewCell: NSTableCellView,AutomaticTitleCell, PropertyTableCellMac, NSTextViewDelegate {
	
	var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			cellValue.isEditable = newValue
		}
		get{
			return cellValue.isEditable
		}
	}
	
    var firstCellResponder: NSView?{
        get{
            return cellValue
        }
    }
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        cellValue.string = newValue as! String? ?? ""
    }
    
    var type: PropertyType = .text
    
    @IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet var cellValue: NSTextView!{
        didSet{
            cellValue.delegate = self
        }
    }
    func textDidChange(_ notification: Notification) {
        update(value: cellValue.string)
    }
	@IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
