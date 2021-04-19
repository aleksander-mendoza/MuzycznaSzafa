//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class MOListTableViewCell: NSTableCellView,AutomaticTitleCell,PropertyTableCellMac, NSDraggingSource {
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
		if newOptions.keys.contains(.editable) {
			updateEditable()
		}
		if newOptions.keys.contains(.ent) {
			updateEnt()
		}
    }
    func propertyTableCell(newOption: PropertyOptions) {
		switch(newOption){
		case .editable:
			updateEditable()
		case .ent:
			updateEnt()
		default:
			assertionFailure()
		}
    }
	
	private func updateEnt(){
		if let ent = self.ent{
			if cellValue.ent?.description != ent.description{
				cellValue.reloadData(ent: ent, list: [])
			}
		}
	}
	
	public var ent:CoreDataEntity?{
		get{
			return property?.options[.ent] as! CoreDataEntity?
		}
	}
	
	private func updateEditable(){
		if property?.options[PropertyOptions.editable] as! Bool? ?? false{
			linkButton.isHidden = false
			minusButton.isHidden = false
		}else{
			linkButton.isHidden = true
			minusButton.isHidden = true
		}
	}
	
	func append(mo:NSManagedObject){
		assert(mo.entity==cellValue.ent?.description,"expected \(cellValue.ent?.description.name ?? "???") but got \(mo.entity.name ?? "???")")
		cellValue.append(mo:mo)
		property?.value = cellValue.value
		property?.onChange(event: PropertyTableEntryMOAddEvent.singleton)
	}
	
	
	
	
	@IBOutlet weak var minusButton: NSButton!
	
    
    func propertyTableCell(newValue: Any?) {
        
        guard let newValue = newValue else{
			cellValue.reloadData(ent: nil, list:[])
            return
        }
        let val = newValue as! [NSManagedObject]
		assert(ent != nil)
		cellValue.reloadData(ent: ent, list:val)
    }
    
    var type: PropertyType = .moList
	
	@IBAction func removeSelected(_ sender: Any) {
		let i = cellValue.selectedRow
		if i >= 0 {
			assert(i < cellValue.value.count,"\(i) < \(cellValue.value.count)")
			cellValue.remove(at: i)
			property?.value = cellValue.value
			property?.onChange(event: PropertyTableEntryMORemoveEvent.singleton)
		}
		
	}
	
	@IBAction func helpSelected(_ sender: Any) {
		requestHelp(sender: sender)
	}
	
	@IBOutlet weak var help: NSButton!
	
	@IBOutlet weak var cellTitle: NSTextField!
    
	@IBOutlet weak var cellValue: MOManualListTableView! {
		didSet{
			cellValue.selectionCallback = {
				[weak self] in
				self!.property?.onChange(event: PropertyTableEntryMOSelectEvent(mo: self!.cellValue.selectedObj))
			}
		}
	}
	
	@IBOutlet weak var linkButton: DraggableButton!{
        didSet{
            linkButton.pboardType = .string
            linkButton.source = self
        }
    }
    
}
