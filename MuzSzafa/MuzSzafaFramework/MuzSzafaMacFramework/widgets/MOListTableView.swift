//
//  EntitiesTableView.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 28/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import CoreData
import MuzSzafaShared

open class MOListTableView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {
	
	public typealias DropCallback = (
		_ fromRow:Int,
		_ from:NSManagedObject,
		_ toRow:Int,
		_ to:NSManagedObject
		)->Void
	public typealias DropValidationCallback = (_ from:NSManagedObject,_ to:NSManagedObject)->Bool
	
	public typealias FocusCallback = (_ selected:NSManagedObject?)->Void
	
	public typealias DropLinkValidationCallback = (_ from:Any,_ to:NSManagedObject)->Bool
	
	public typealias HeaderClickCallback = (_ attrName:String )->Bool
	/////////////////////////////
	///vars
	/////////////////////////////
	private let tickColID = NSUserInterfaceItemIdentifier("*")
	private let tickCellID = NSUserInterfaceItemIdentifier("selectionCell")
	private let basicCellID = NSUserInterfaceItemIdentifier("basicCell")
	open var dataDelegate:MOListDataDelegate?
	private struct Attr{
		let id:NSUserInterfaceItemIdentifier
		let val:CoreDataAttr
	}
	private var tickedRows = RandomInsertArray<Bool>()
	public var tickable: Bool = false{
		didSet{
			guard tickable != oldValue else{return}
			if tickable{
				if tableColumn(withIdentifier: tickColID) == nil{
					addTableColumn(id: tickColID, name: "")
				}
			}else{
				if let i = tableColumn(withIdentifier: tickColID){
					removeTableColumn(i)
				}
			}
		}
	}
	public func isTicked(at row: Int) -> Bool {
		return tickedRows[row] ?? false
	}
	private var attrs:[Attr] = []
	public internal(set) var ent:CoreDataEntity?{
		didSet{
			updateAttrColumns()
		}
	}
	public func updateAttrColumns(){
		for col in tableColumns where col.identifier != tickColID{
			removeTableColumn(col)
		}
		attrs.removeAll()
		assert(tableColumns.count==(tickable ? 1 : 0),"Some columns not removed!")
		if let repr = ent?.repr{
			
			for attr in repr.primaryAttrs + repr.secondaryAttrs{
				let id = NSUserInterfaceItemIdentifier(attr.name)
				attrs.append(Attr(id: id, val: attr))
				addTableColumn(id: id, localizedName: attr.name)
			}
		}
		assert(tableColumns.count==attrs.count+(tickable ? 1 : 0),"got \(tableColumns.count) comuns and \(attrs.count) attrs with tickable '\(tickable)'!")
	}
	open var selectionCallback:(()->Void)?
	open var dropValidationCallback:DropValidationCallback?
	open var dropLinkValidationCallback:DropLinkValidationCallback?
	open var dropCallback:DropCallback?
	open var focusCallback:FocusCallback?
	/**If returns true, then the data reloads*/
	open var headerClickCallback:HeaderClickCallback?
	private static let pboardType = NSPasteboard.PasteboardType.string
	/////////////////////////////
	///init
	/////////////////////////////
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setup()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	private func setup(){
		dataSource = self
		delegate = self
		usesAlternatingRowBackgroundColors = true
		columnAutoresizingStyle = .uniformColumnAutoresizingStyle
		registerForDraggedTypes([NSPasteboard.PasteboardType.string])
		registerNib("EntTableSelectionCell", tickCellID, bundle: EntTableSelectionCell.self)
		registerNib("BasicTableCell", basicCellID,bundle: BasicTableCell.self)
		action = #selector(onItemClicked)
	}
	
	/////////////////////////////
	///dragging
	/////////////////////////////
	public func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
		let i = NSPasteboardItem()
		i.setString(String(row), forType: MOListTableView.pboardType)
		return i
	}
	/////////////////////////////
	///headers
	/////////////////////////////
	
	public func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
		if headerClickCallback?(tableColumn.identifier.rawValue) ?? false{
			reloadData()
		}
	}
	
	/////////////////////////////
	///editing
	/////////////////////////////
	public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
		return false
	}
	
	/////////////////////////////
	///dropping
	/////////////////////////////
	public func tableView(_ tableView: NSTableView,
						  validateDrop info: NSDraggingInfo,
						  proposedRow row: Int,
						  proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
		guard dropOperation == .on else {return []}
		
		guard let src = info.draggingSource() else{return []}
		if let other = src as? EntitiesTableView{
			guard other != self else{return []}
			guard let fromMO = getSourceMO(info:info) else{return []}
			guard let toMO = dataDelegate?.get(at: row) else{return []}
			if let cb = dropValidationCallback{
				if !cb(fromMO,toMO) {
					return []
				}
			}
		}else{
			let myEnt = ent?.description
			if let other = src as?  RelatTableViewCell{
				let sourceEnt = other.getAttr()?.destEnt.description
				guard sourceEnt == myEnt else{return []}
			}else if let other = src as?  MOListTableViewCell{
				let sourceEnt = other.cellValue.ent?.description
				guard sourceEnt == myEnt else{return []}
			}else if let other = src as?  RelatListTableViewCell{
				let sourceEnt = other.cellValue.ent?.description
				guard sourceEnt == myEnt else{return []}
			}else{
				return []
			}
			guard let toMO = dataDelegate?.get(at: row) else{return []}
			if let cb = dropLinkValidationCallback{
				if !cb(src,toMO) {
					return []
				}
			}
		}
		info.animatesToDestination = true
		return .link
		
	}
	private func getSourceRow(info: NSDraggingInfo)->Int?{
		let pb = info.draggingPasteboard().string(forType: MOListTableView.pboardType)
		if let str = pb{
			return Int(str)
		}else{
			return nil
		}
	}
	private func getSourceMO(info: NSDraggingInfo)->NSManagedObject?{
		let pb = info.draggingPasteboard().string(forType: MOListTableView.pboardType)
		if let src = info.draggingSource(),
			let list = src as? EntitiesTableView,
			let str = pb,
			let fromRow = Int(str),
			let fromMO = list.get(at: fromRow){
			return fromMO
		}else{
			return nil
		}
	}
	public func tableView(_ tableView: NSTableView,
						  acceptDrop info: NSDraggingInfo,
						  row toRow: Int,
						  dropOperation: NSTableView.DropOperation) -> Bool {
		guard let toMO = dataDelegate?.get(at: toRow) else{return false}
		if let fromMO = getSourceMO(info:info){
			let fromRow = getSourceRow(info: info)!
			dropCallback?(fromRow,fromMO,toRow,toMO)
			return true
		}else if let relat = info.draggingSource() as? RelatTableViewCell{
			relat.mo = toMO
			return true
		}else if let relat = info.draggingSource() as? MOListTableViewCell{
			relat.append(mo: toMO)
			return true
		}
		return false
	}
	/////////////////////////////
	///focus
	/////////////////////////////
	open override func becomeFirstResponder() -> Bool {
		focusCallback?(selectedObj)
		return super.becomeFirstResponder()
	}
	/////////////////////////////
	///data
	/////////////////////////////
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return dataDelegate?.numberOfRows() ?? 0
	}
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		guard let id = tableColumn?.identifier else{
			return nil
		}
		if id == tickColID{
			guard let v = makeView(withIdentifier: tickCellID, owner: self)else{
				return nil
			}
			let cell = v as! EntTableSelectionCell
			cell.onChangeImpl = {
				[weak self] in self!.tickedRows[row] = $0
			}
			return cell
		}else{
			guard let v = makeView(withIdentifier: basicCellID, owner: self) else{
				return nil
			}
			let cell = v as! BasicTableCell
			let field = getField(at: row, id: id).or()
			cell.textField?.stringValue = field
			let mo = dataDelegate?.get(at: row)
			assert(ent?.description==mo?.entity, "Expetced \(ent?.description.name ?? "nil") but got \(mo?.entity.name ?? "nil" )")
			prepare(cell:cell, mo:mo)
			return cell
		}
	}
	
	@objc private func onItemClicked() {
		selectionCallback?()
	}
	
	open override func keyDown(with event: NSEvent) {
		super.keyDown(with: event)
		if event.keyCode == 125 || event.keyCode == 126{
			selectionCallback?()
		}
	}
	
	open func prepare(cell:BasicTableCell,mo:NSManagedObject?){
		//dummy method (but won't be if you override it ;) )
	}
	
	
	open func reloadData(id:NSUserInterfaceItemIdentifier){
		reloadData(row: selectedRow, id: id)
	}
	
	open func reloadData(attr:String){
		reloadData(row: selectedRow, attr: attr)
	}
	open func reloadData(row:Int,attr:String){
		reloadData(row:row,id:NSUserInterfaceItemIdentifier(attr))
	}
	
	public func getField(of mo: NSManagedObject, id: NSUserInterfaceItemIdentifier) -> String? {
		guard let i = getAttrIndex(id: id) else{
			return nil
		}
		return dataDelegate?.getField(of: mo, attr: i)
	}
	
	public func getField(at row: Int, id: NSUserInterfaceItemIdentifier) -> String? {
		guard let i = getAttrIndex(id: id) else{
			return nil
		}
		return dataDelegate?.getField(at: row, attr: i)
	}
	
	open func getAttrIndex(attr:CoreDataAttr)->Int?{
		return getAttrIndex(attr:attr.name)
	}
	open func getAttrIndex(attr:String)->Int?{
		return attrs.index(where: {$0.val.name == attr})
	}
	open func getAttrIndex(id:NSUserInterfaceItemIdentifier)->Int?{
		return attrs.index(where: {$0.id == id})
	}
	
	open var selectedObj:NSManagedObject?{
		get{
			return dataDelegate?.get(at: selectedRow)
		}
		set(new){
			if let obj = new{
				if let index = dataDelegate?.find(obj:obj){
					selectRowIndexes([index], byExtendingSelection: false)
				}
			}else{
				selectRowIndexes([], byExtendingSelection: false)
			}
		}
	}
}
