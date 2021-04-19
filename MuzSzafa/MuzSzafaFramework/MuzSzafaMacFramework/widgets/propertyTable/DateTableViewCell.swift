//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class DateTableViewCell: NSTableCellView,AutomaticTitleCell,PropertyTableCellMac {
    var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			cellValue.isEnabled = newValue
		}
		get{
			return cellValue.isEnabled
		}
	}
    
    @IBOutlet weak var caution: NSButton!
    
    var firstCellResponder: NSView?{
        get{
            return cellValue
        }
    }
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        caution.isHidden = newValue != nil
        cellValue.dateValue = newValue as! Date? ?? Date()
    }
    
    var type: PropertyType = .date
    
    @IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: NSDatePicker!{
        didSet{
            cellValue.action = #selector(dateSelected)
        }
    }
    @objc func dateSelected(){
        caution.isHidden = true
        update(value: cellValue.dateValue)
    }
	@IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
