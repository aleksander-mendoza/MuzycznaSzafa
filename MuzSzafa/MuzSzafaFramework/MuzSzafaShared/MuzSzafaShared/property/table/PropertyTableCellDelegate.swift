//
//  PropertyTableCellDelegate.swift
//  MuzSzafaShared
//
//  Created by Alagris on 19/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public protocol PropertyTableCellDelegate{
    func propertyTableCell(newName:String)
    func propertyTableCell(newLocalizedName:String)
    func propertyTableCell(newValue:Any?)
    func propertyTableCell(newOptions:PropertyOptionDict)
    func propertyTableCell(newOption:PropertyOptions)
	func propertyTableCell(newUserHelp:CoreDataAttrHelp?)
}
public extension PropertyTableCellDelegate{
    public func propertyTableCell(newOption: PropertyOptions) {}
    public func propertyTableCell(newOptions: PropertyOptionDict) {}
    public func propertyTableCell(newName: String) {
        let loc = getLocalizedString(for: newName)
        propertyTableCell(newLocalizedName: loc)
    }
    public func propertyTableCell(newLocalizedName:String){}
	public func propertyTableCell(newUserHelp:CoreDataAttrHelp?){}
}
