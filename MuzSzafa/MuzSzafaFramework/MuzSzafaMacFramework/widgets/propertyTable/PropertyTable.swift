//
//  PropertyTable.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 31/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


import Cocoa
import CoreData
import MuzSzafaShared
open class PropertyTable: NSTableView, NSTableViewDataSource, NSTableViewDelegate, PropertyTableProtocol, HelpPopoverRequestDelegate {
	

	public func helpPopoverRequest(for cell: CoreDataAttrHelp,sender:Any?) {
		if let sender = sender as? NSView{
			HelpPopover.present(for: sender, with: cell)
		}
	}
    
    public var entries:[PropertyTableEntry] = []
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return entries.count
    }
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return getTableRowHeight(entries[row].type)
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let e = entries[row]
        let id = NSUserInterfaceItemIdentifier(rawValue: e.type.rawValue)
        let c = makeView(withIdentifier: id, owner: nil)
		
        if let cell = c as! PropertyTableCellMac?{
            cell.assign(e)
			cell.isEnabled = isEnabled
			cell.helpPopoverRequestDelegate = self
        }
        return c
    }
    open func cell(at row:Int)->PropertyTableCellMac?{
		assert(tableColumns.count==1)
		assert(row < numberOfRows)
		assert(0 <= row)
        let v = view(atColumn: 0, row: row, makeIfNecessary: false)
        return v as! PropertyTableCellMac?
    }
    open func updateResponderKeySequence(){
		if numberOfRows == 0 {return}
        var previous = cell(at: 0)
        for row in 1..<numberOfRows{
            if let this = cell(at: row),
                let r = this.firstCellResponder{
                previous?.firstCellResponder?.nextKeyView = r
                previous = this
            }
        }
    }
    open override func viewWillDraw() {
		updateResponderKeySequence()
    }
    
    public override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    open override func viewDidMoveToWindow() {
        sizeLastColumnToFit()
        self.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        self.rowHeight = 44
        self.rowSizeStyle = RowSizeStyle.default
    }
    private static let mainColID = NSUserInterfaceItemIdentifier(rawValue: "main")
    private var col:NSTableColumn!
    open func setTitle(title:String){
        col.title = title
    }
    open func setLocalizedTitle(title:String){
        setTitle(title: getLocalizedString(for: title))
    }
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let c = cell(at: row),
            let fr = c.firstCellResponder,
            let w = window{
            w.makeFirstResponder(fr)
        }
        return false
    }
    func setup(){
        delegate = self
        dataSource = self
        col = NSTableColumn(identifier: PropertyTable.mainColID)
        col.resizingMask = .autoresizingMask
        addTableColumn(col)
        allowsColumnSelection = false
        allowsMultipleSelection = false
        allowsTypeSelect = false
		
        registerNib("BoolPropertyCell", PropertyType.bool)
        registerNib("IntPropertyCell", PropertyType.int)
        registerNib("StringPropertyCell", PropertyType.string)
        registerNib("DatePropertyCell", PropertyType.date)
        registerNib("MoneyPropertyCell", PropertyType.money)
        registerNib("DisplayPropertyCell", PropertyType.display)
        registerNib("TextPropertyCell", PropertyType.text)
        registerNib("TelephonePropertyCell", PropertyType.telephone)
        registerNib("EmailPropertyCell", PropertyType.email)
        registerNib("ListPropertyCell", PropertyType.list)
        registerNib("RelatPropertyCell", PropertyType.relat)
		registerNib("RelatListPropertyCell", PropertyType.relatList)
		registerNib("RelatToManyPropertyCell", PropertyType.relatToMany)
        registerNib("ButtonPropertyCell", PropertyType.button)
        registerNib("TogglePropertyCell", PropertyType.toggle)
		registerNib("MOListPropertyCell", PropertyType.moList)
    }
    
    private func registerNib(_ nibName:String,_ t:PropertyType){
        registerNib(nibName, t.rawValue)
    }
        
}
