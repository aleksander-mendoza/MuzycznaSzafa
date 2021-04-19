//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class RelatTableViewCell: NSTableCellView,AutomaticTitleCell, RelatPropertyTableCellMac, NSDraggingSource {
	var helpPopoverRequestDelegate: HelpPopoverRequestDelegate?
	var isEnabled: Bool{
		set{
			linkButton.isEnabled = newValue
			cellValue.isEnabled = newValue
		}
		get{
			return cellValue.isEnabled
		}
	}
	
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .link
    }
    
    
    var property: PropertyTableEntry?
    
    func propertyTableCell(newOptions: PropertyOptionDict) {
        propertyTableCell(newOption: .editable)
    }
    func propertyTableCell(newOption: PropertyOptions) {
		assert(newOption==PropertyOptions.editable)
        if property?.options[newOption] as! Bool? ?? false{
            linkButton.isHidden = false
        }else{
            linkButton.isHidden = true
        }
    }
	
	
    
    func propertyTableCell(newValue: Any?) {
        
        guard let newValue = newValue else{
            cellValue.title = String?.OR
            return
        }
        let val = newValue as! CellRelatEntry
        let mo = val.mo
        let attr = val.attr
        let serializer = attr.serializer
        let str = serializer.stringify(maybeAny: mo)
        cellValue.title = str.or()
        
    }
    
    var type: PropertyType = .relat
	
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
	
	@IBOutlet weak var help: NSButton!
	
	@IBOutlet weak var cellTitle: NSTextField!
    
    @IBOutlet weak var cellValue: NSButton!
    
    @IBOutlet weak var linkButton: DraggableButton!{
        didSet{
            linkButton.pboardType = .string
            linkButton.source = self
        }
    }
    
    @IBAction func pressed(_ sender: Any) {
		let val = property?.value as! CellRelatEntry?
        property?.onChange(event: PropertyTableEntryRelatPressEvent(mo: val?.mo, relat: val?.attr))
    }
}
