//
//  RelatPropertyTableCell.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public protocol RelatPropertyTableCell:PropertyTableCell{}

public extension RelatPropertyTableCell{
    func getVal()->CellRelatEntry?{
        return property?.value as! CellRelatEntry?
    }
    var mo:NSManagedObject?{
        get{
            return getVal()?.mo
        }
        set{
            guard let attr = getAttr() else {return}
            guard let prop = property else{return}
            let new = CellRelatEntry(mo:newValue,attr:attr)
            prop.set(value: new)
			prop.onChange()
        }
    }
    func getAttr()->CoreDataRelatEntry?{
        return getVal()?.attr
    }
}
