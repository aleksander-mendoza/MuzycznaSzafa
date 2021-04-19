//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class ListTableViewCell: NSTableCellView,PropertyTableCellMac {
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
    
    func propertyTableCell(newName: String) {
        update()
    }
    
    private func update(){
        if let p = property{
            if let data = p.options[.data]{
                let d = data as! [String]
                self.data = d
                cellTitle?.stringValue = getLocalizedString(for:p.name)
            }else{
                cellTitle?.stringValue = CoreDataListSerializer.parseList(property:p,&data)
            }
            cellValue.removeAllItems()
            cellValue.addItems(withTitles: data!)
        }
    }
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        cellValue.selectItem(at: numerifyToInt(newValue ?? 0))
    }
    func propertyTableCell(newOptions: PropertyOptionDict) {
        update()
    }
    func propertyTableCell(newOption: PropertyOptions) {
        if newOption == .size || newOption == .data{
            update()
        }
    }
    private var data:[String]?
    
    var type: PropertyType = .list
    
    @IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: NSPopUpButton!
    
    @IBAction func selectionChanged(_ sender: NSPopUpButton) {
        update(value: cellValue.indexOfSelectedItem)
    }
	@IBOutlet weak var help: NSButton!
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
}
