//
//  BoolTableViewCell.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import UIKit
import MuzSzafaShared
class ListTableViewCell: UITableViewCell, PropertyTableCell,PropertyCell{
	var isEnabled: Bool{
		get{
			return listPicker.isEnabled
		}
		set{
			listPicker.isEnabled = newValue
		}
	}
	
    var property: PropertyTableEntry?
    
    func propertyTableCell(newValue: Any?) {
        listPicker.setSelectedRow(numerifyToInt(newValue ?? 0))
    }
    
    func propertyTableCell(newName: String) {
        update()
    }
    func propertyTableCell(newOption: PropertyOptions) {
        if newOption == .size{
            update()
        }
    }
    func propertyTableCell(newOptions: PropertyOptionDict) {
        update()
    }
    private func update(){
        guard let p = property else{
            return
        }
        var array:[String]? = nil
        let name = CoreDataListSerializer.parseList(property: p, &array)
        listPicker.array = array
        listPicker.reloadAllComponents()
        listPicker.refreshSelection()
        cellTitle?.text = getLocalizedString(for:name)
    }
    
    var type: PropertyType = .list
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet private weak var listPicker: GenericPicker!{
        didSet{
            func cast(_ a:Any)->String{
                return a as! String
            }
            listPicker.stringifyImpl = cast
            listPicker.onChangeImpl = {
                [weak self] in
                self!.update(value: $0)
            }
        }
    }
    
}
