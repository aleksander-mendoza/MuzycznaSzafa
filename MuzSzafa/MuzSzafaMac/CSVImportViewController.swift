//
//  CSVImportViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 14/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
import MuzSzafaMacFramework
class CSVImportViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {
    var dest:URL!
    var parentResource:Reloadable?
    private let basicCellID = NSUserInterfaceItemIdentifier("basicCell")
    private let popUpButtonCellID = NSUserInterfaceItemIdentifier("popUpButtonCell")
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53{
            dismiss(nil)
        }
    }
    
	@IBOutlet weak var separatorCharacter: CharacterChooser!
	@IBOutlet weak var firstRowAsHeader: NSButton!
    @IBAction func goBack(_ sender: Any) {
        dismiss(sender)
    }
    
    @IBOutlet weak var entSelector: NSPopUpButton!{
        didSet{
            let ents = CoreContext.shared.cache.ents
            entSelector.removeAllItems()
            for ent in ents{
                let n = getLocalizedString(for: ent.name.or())
                entSelector.addItem(withTitle: n)
            }
        }
    }
    private var hasHeaderRow:Bool{
        get{
            return firstRowAsHeader.state == .on
        }
        set{
            firstRowAsHeader.state = newValue ? .on : .off
        }
    }
    @IBAction func readyToImport(_ sender: Any) {
        
        dialogException(msg: "Failed to import CSV"){
            guard let r = reader else{
                return
            }
            r.rewind()
            if hasHeaderRow{
                r.skipRow()
            }
            let attrs = selectedAttrs
            let ent = selectedEnt
            try r.setHeaderManually(ent: ent, attrs: attrs)
            while try r.loadNextRow(){
                
            }
            parentResource?.reloadData()
            dismiss(nil)
        }
    }
    
    private var selectedEnt:CoreDataEntity{
        get{
            let i = entSelector.indexOfSelectedItem
            let ent = CoreContext.shared.cache.ents[i]
            return ent
        }
    }
    private var selectedAttrs:[CoreDataAttr?]{
        get{
            return (0..<table.numberOfColumns).map(){
                guard let v = table.view(atColumn: $0, row: 0, makeIfNecessary: false) else{
                    return nil
                }
                let p = v as! PopUpButtonTableCell
                let i = p.value - 1 // 0 = ignore
                guard i >= 0 && i < selectedEnt.attrs.count else{
                    return nil
                }
                return selectedEnt.attrs[i]
            }
        }
    }
    private var reader:CSVCoreDataReader?
    private var rows:[[String]] = []
    private var columnsCount:Int{
        get{
            return rows.isEmpty ? 0 : rows[0].count
        }
    }
    
    @IBAction func selectedEntChanged(_ sender: Any) {
        table.reloadData(row: 0)
        for i in 0..<table.numberOfColumns{
            heuristicGuessAtrribute(forCol: i)
        }
    }
    @IBOutlet weak var path: NSPathControl!
    @IBOutlet weak var table: NSTableView!{
        didSet{
            table.delegate = self
            table.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        path.url = dest
		separatorCharacter.title = getLocalizedString(for: "separator_character")
		separatorCharacter.charValue = ","
		separatorCharacter.onChangeImpl = {
			[weak self] char in
			if char != nil {
				self!.reloadFirst20Rows()
			}
		}
        table.registerNib("BasicTableCell", basicCellID, bundle: BasicTableCell.self)
        table.registerNib("PopUpButtonTableCell", popUpButtonCellID, bundle: PopUpButtonTableCell.self)
        reader = nil
        dialogException(msg: "Could not open file"){
            reader = try CSVCoreDataReader(url: dest)
        }
		loadFirst20Rows()
    }
	
	func reloadFirst20Rows(){
		reader?.rewind()
		loadFirst20Rows()
		table.reloadData()
	}
	
	func loadFirst20Rows(){
		if let u = separatorCharacter.charValue.unicodeScalars.first{
			reader?.separator = u
		}
		if let r = reader{
			rows = r.nextNRowsAsArr(n: 20) ?? []
		}
		
		if columnsCount > table.numberOfColumns{
			for i in table.numberOfColumns..<columnsCount{
				table.addTableColumn(id:"\(i)")
			}
		}else{
			for i in columnsCount..<table.numberOfColumns{
				table.removeTableColumn(id: "\(i)")
			}
		}
		
		let guessedEntity = CoreContext.shared.cache.fuzzyFind(indexOf:dest.fileName)
		entSelector.selectItem(at: guessedEntity ?? 0)
		
		hasHeaderRow = false
	}
   
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rows.count + 1 
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
        if row == 0{
            guard let v = table.makeView(withIdentifier: popUpButtonCellID, owner: self) else{
                    return nil
            }
            let cell = v as! PopUpButtonTableCell
            cell.dataSource = {[weak self] in
                ["("+getLocalizedString(for: "ignore")+")"] + self!.selectedEnt.localizedAttrNames
            }
            cell.onLoadImpl = {[weak self] in
                self!.heuristicGuessAtrribute(maybeForCol: tableColumn)
            }
            return cell
        }else{
            guard let v = table.makeView(withIdentifier: basicCellID, owner: self),
                let id = tableColumn?.identifier else{
                return nil
            }
            let cell = v as! BasicTableCell
			guard row < numberOfRows(in: table) else {return cell}
			let colIndex = table.column(withIdentifier:id)
			let rowValues = rows[row-1]
			if colIndex >= 0 && colIndex < rowValues.count{
				let str = rowValues[colIndex]
				cell.textField?.stringValue = str
			}else{
				
			}
            return cell
        }
    }
}


extension CSVImportViewController {
    func heuristicGuessAtrribute(maybeForCol column:NSTableColumn?){
        if let c = column{
            heuristicGuessAtrribute(forCol: c)
        }
    }
    func heuristicGuessAtrribute(forCol column:NSTableColumn){
        heuristicGuessAtrribute(forCol: column.identifier)
    }
    func heuristicGuessAtrribute(forCol column:NSUserInterfaceItemIdentifier){
        if let i = Int(column.rawValue){
            heuristicGuessAtrribute(forCol: i)
        }
    }
    func heuristicGuessAtrribute(forCol column:Int){
        guard rows.count > 1 else{return}
		guard rows[0].count > column else{return}
        let string = rows[0][column]
        guard let cell = table.view(atColumn: column, row: 0, makeIfNecessary: false) else{
            return
        }
        let popUp = cell as! PopUpButtonTableCell
        heuristicGuessAtrribute(string: string, popUp)
    }
    func heuristicGuessAtrribute(string:String)->Int?{
        return selectedEnt.fuzzyMatch(attr: string)
    }
    func heuristicGuessAtrribute(string:String,_ popUpButton:PopUpButtonTableCell){
        if let i = heuristicGuessAtrribute(string: string){
            popUpButton.value = i+1
            if !hasHeaderRow {
                hasHeaderRow = true
            }
        }
        
    }
}
