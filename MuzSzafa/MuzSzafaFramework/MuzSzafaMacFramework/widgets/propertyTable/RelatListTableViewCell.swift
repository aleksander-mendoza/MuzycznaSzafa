//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class RelatListTableViewCell: NSTableCellView,AutomaticTitleCell, PropertyTableCellMac, NSDraggingSource {
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
	
	
	func propertyTableCell(newLocalizedName: String) {
		cellValue.reloadData(ent: nil)
		cellTitle.stringValue = newLocalizedName
	}
	
    func propertyTableCell(newValue: Any?) {
        
        guard let newValue = newValue else{
			cellValue.reloadData(ent: nil)
            return
        }
        let val = newValue as! CellRelatListEntry
        let mo = val.mo
        let attr = val.relat
		cellValue.reloadData(mo: mo, relat: attr, cache: attr.getCache())
    }
    
    var type: PropertyType = .relatList
	
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
	
	@IBOutlet weak var help: NSButton!
	
	@IBOutlet weak var cellTitle: NSTextField!
    
	@IBOutlet weak var cellValue: EntitiesTableView! {
		didSet{
			cellValue.selectionCallback = {
				guard let selected = self.cellValue.selectedObj else {return}
				self.property?.onChange(event: PropertyTableEntryMOSelectEvent(mo: selected))
			}
			cellValue.reloadData(ent: nil)
		}
	}
	
    @IBOutlet weak var linkButton: DraggableButton!{
        didSet{
            linkButton.pboardType = .string
            linkButton.source = self
        }
    }
    
}
