//
//  NSFetchedResultsController.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public extension NSFetchedResultsController where ResultType == NSManagedObject{
    public var count:Int{
        get{
            return fetchedObjects?.count ?? 0
        }
    }
    public func exists() -> Bool {
        return count > 0
    }
    public var first:NSManagedObject?{
        get{
            return fetchedObjects?.first
        }
    }
}

