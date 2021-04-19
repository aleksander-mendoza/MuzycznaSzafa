//
//  CoreDataTable.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 03/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
import MuzSzafaShared
open class CoreDataTable:PropertyTable,EntPropertyTable{
	public var areRecordsSetManually: Bool = false
	
    public func reloadData(attr: String) {
        if let i = index(attr: attr){
            updateValue(at: i)
            reloadData(forRowIndexes: [i], columnIndexes: [0])
        }
    }
    
    public var ent: CoreDataEntity?
    
    public var obj: NSManagedObject?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var onChangeImpl: EntPropertyObeserver?
    open override func reloadData() {
        reloadEnt()
        updateAllValues()
		isEnabled = areRecordsSetManually || obj != nil
        super.reloadData()
    }
	
}
