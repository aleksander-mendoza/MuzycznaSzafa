//
//  EntFilteredRecordsTable.swift
//  MuzSzafaShared
//
//  Created by Alagris on 08/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
public protocol EntFilteredRecordsTable:EntRecordsTable{
    var filter:((NSManagedObject)->Bool)? {get set}
    var filteredObjects:[NSManagedObject]{get set}
}
public extension EntFilteredRecordsTable{
    public func updateFiltered(){
        let fetched = controller?.fetchedObjects ?? [NSManagedObject]()
        if let f = filter{
            filteredObjects = fetched.filter(f)
        }else{
            filteredObjects = fetched
        }
    }
    public func getFiltered(at row: Int) -> NSManagedObject? {
        if row >= 0 && row < numberOfRows(){
            return filteredObjects[row]
        }
        return nil
    }
    public func numberOfFilteredRows() -> Int {
        return filteredObjects.count
    }
}
