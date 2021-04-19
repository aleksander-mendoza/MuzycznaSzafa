//
//  Property.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import MuzSzafaShared
public extension PropertyTableCell where Self:AutomaticTitleCell{
    public func propertyTableCell(newLocalizedName: String) {
        self.cellTitle?.stringValue = newLocalizedName
    }
}

