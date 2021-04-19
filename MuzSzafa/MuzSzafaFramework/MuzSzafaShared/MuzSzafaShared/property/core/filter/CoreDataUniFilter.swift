//
//  CoreDataUniFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

public protocol CoreDataUniFilter:CoreDataFilter{
    var value:Any?{get set}
}



public extension CoreDataUniFilter{
	
	public subscript(at:Int)->Any?{
		get{
			if at == 0{
				return value
			}
			assertionFailure()
			return nil
		}
		set{
			if at == 0{
				value = newValue
			}else{
				assertionFailure()
			}
		}
	}
}
