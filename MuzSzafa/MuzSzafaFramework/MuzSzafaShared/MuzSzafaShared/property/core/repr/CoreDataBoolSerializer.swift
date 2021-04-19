//
//  CoreDataBoolSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


open class CoreDataBoolSerializer:CoreDataGenericSerializer{
    public typealias T = Bool
    public func deserialize(_ val:String)->T?{
        return CoreDataBoolSerializer.deserialize(val)
    }
	public static func deserialize(_ val:String)->Bool?{
		let val = val.trimmingCharacters(in: .whitespacesAndNewlines)
		if val == "1"{return true}
		if val == "0"{return false}
		if val == "+"{return true}
		if val == "-"{return false}
		if getLocalizedString(for: "yes") == val{
			return true
		}
		if getLocalizedString(for: "no") == val{
			return true
		}
		return Bool(val)
	}
    public func stringify(_ val:T)->String?{
        return String(val)
    }
}
