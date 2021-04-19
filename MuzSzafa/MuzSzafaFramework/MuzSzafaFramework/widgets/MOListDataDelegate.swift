//
//  MOListDataDelegate.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 15/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import CoreData

public protocol MOListDataDelegate{
	func get(at row:Int)->NSManagedObject?
	func numberOfRows()->Int
	func find(obj:NSManagedObject)->Int?
	func delete(at row:Int)->Bool
}

public extension MOListDataDelegate{
}
