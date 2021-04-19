//
//  PropertyTableCell.swift
//  MuzSzafaShared
//
//  Created by Alagris on 19/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public protocol PropertyTableCell:class,PropertyTableCellDelegate{
    var property:PropertyTableEntry?{get set}
    var type:PropertyType{get}
	var isEnabled:Bool{get set}
}

public extension PropertyTableCell{
    func assign(_ entry:PropertyTableEntry){
        if type == entry.type{
            property = entry
            property!.delegate = self
            //order of these delegate functions matters!
            //options have to be the first one!
            propertyTableCell(newOptions: property!.options)
            propertyTableCell(newName: property!.name)
			propertyTableCell(newUserHelp: property!.userHelp)
            //value has to be the last one!
            propertyTableCell(newValue: property!.value)
		}else{
			assertionFailure("mismatched type in PropertyTableCell. Expected \(type) but got \(entry.type)")
		}
    }
    func update(value:Any?){
        property?.value = value
        property?.onChange()
    }
    
}
