//
//  MOListDataDelegate.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 23/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public protocol MOListDataDelegate{
	func get(at row:Int)->NSManagedObject?
	func numberOfRows()->Int
	func getField(of mo:NSManagedObject,attr index:Int)->String?
	func find(obj:NSManagedObject)->Int?
}

public extension MOListDataDelegate{
	func getField(at row:Int,attr index:Int)->String?{
		guard let mo = get(at:row) else{
			return nil
		}
		return getField(of: mo, attr:index)
	}
}
