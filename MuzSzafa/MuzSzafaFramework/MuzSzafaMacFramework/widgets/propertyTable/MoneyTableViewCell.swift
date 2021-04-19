//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class MoneyTableViewCell: NSTableCellView,AutomaticTitleCell,PropertyTableCellMac, NSTextFieldDelegate {
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
        cellValue.setMoneyValue(numerifyToInt64(maybe: newValue))
    }
    
    @IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: MoneyTextField!{
        didSet{
            cellValue.onChangeImpl = {
                [weak self] in
                self!.update(value: $0)
            }
        }
    }
    
    var type: PropertyType = .money
	@IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
