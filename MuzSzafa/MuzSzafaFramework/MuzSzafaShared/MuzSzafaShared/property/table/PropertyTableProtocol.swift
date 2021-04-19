//
//  PropertyTableProtocol.swift
//  MuzSzafaShared
//
//  Created by Alagris on 03/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

public protocol PropertyTableProtocol:Reloadable {
    var entries:[PropertyTableEntry]{get set}
}
public extension PropertyTableProtocol{
    public var size:Int{
        get{
            return entries.count
        }
    }
	public func get(at row:Int)->PropertyTableEntry?{
		guard row < entries.count else{
			assertionFailure("\(row) buc max is \(entries.count)")
			return nil
		}
		guard 0 <= row else {return nil}
		return entries[row]
	}
}
