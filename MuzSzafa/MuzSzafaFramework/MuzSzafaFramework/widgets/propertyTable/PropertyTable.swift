//
//  PropertyTable.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
open class PropertyTable: UITableView, UITableViewDelegate, UITableViewDataSource,PropertyTableProtocol {
    
    
    public var entries:[PropertyTableEntry] = []
	
	public var onAddRequestImpl:((IndexPath)->())?
	public var onModifyRequestImpl:((IndexPath)->())?
	public var onRemoveRequestImpl:((IndexPath)->())?
//    private var cells:PropertyTableCellList
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return size
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getTableRowHeight(entries[indexPath.row].type)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let r = indexPath.row
        let e = entries[r]
        let c = dequeueReusableCell(withIdentifier: e.type.rawValue, for: indexPath)
        guard let cell = c as? PropertyTableCell  else {
            fatalError("The dequeued cell is not an instance of Property.")
        }
//        cells.set(cell:cell,at:r)
        cell.assign(e)
        return c
    }
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame,style:style)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
       
    }
	
	
	public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		guard let a = get(at:indexPath.row) else {return nil}
		if a.type == .relat{
			let modify = UITableViewRowAction(style: .normal, title: getLocalizedString(for: "modify")) {
				[weak self] (action, indexPath) in
				self!.onModifyRequestImpl?(indexPath)
			}
			return [modify]
		}
		if a.type == .relatList || a.type == .relatToMany || a.type == .moList{
			let add = UITableViewRowAction(style: .normal, title: getLocalizedString(for: "add")) {
				[weak self] (action, indexPath) in
				self!.onAddRequestImpl?(indexPath)
			}
			let remove = UITableViewRowAction(style: .normal, title: getLocalizedString(for: "remove")) {
				[weak self] (action, indexPath) in
				self!.onRemoveRequestImpl?(indexPath)
			}
			return [add,remove]
		}
		return nil
	}
	public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return get(at: indexPath.row)?.isEditable ?? false
	}
	public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
	}
	
    func setup(){
        keyboardDismissMode = .onDrag
        clipsToBounds = true
        delegate = self
        dataSource = self
        registerNib("BoolPropertyCell", PropertyType.bool.rawValue)
        registerNib("IntPropertyCell", PropertyType.int.rawValue)
        registerNib("StringPropertyCell", PropertyType.string.rawValue)
        registerNib("DatePropertyCell", PropertyType.date.rawValue)
        registerNib("MoneyPropertyCell", PropertyType.money.rawValue)
        registerNib("DisplayPropertyCell", PropertyType.display.rawValue)
        registerNib("TextPropertyCell", PropertyType.text.rawValue)
        registerNib("TelephonePropertyCell", PropertyType.telephone.rawValue)
        registerNib("EmailPropertyCell", PropertyType.email.rawValue)
        registerNib("ListPropertyCell", PropertyType.list.rawValue)
        registerNib("RelatPropertyCell", PropertyType.relat.rawValue)
        registerNib("ButtonPropertyCell", PropertyType.button.rawValue)
        registerNib("TogglePropertyCell", PropertyType.toggle.rawValue)
		registerNib("RelatToManyPropertyCell", PropertyType.relatToMany.rawValue)
		registerNib("RelatListPropertyCell", PropertyType.relatList.rawValue)
		registerNib("MOListPropertyCell", PropertyType.moList.rawValue)
    }
    
    
    
}


