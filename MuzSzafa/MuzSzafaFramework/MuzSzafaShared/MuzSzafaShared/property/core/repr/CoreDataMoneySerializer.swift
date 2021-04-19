//
//  CoreDataMoneySerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


open class CoreDataMoneySerializer:CoreDataGenericSerializer{
    public typealias T = Int64
    public func deserialize(_ val:String)->T?{
		return parseMoney(val)
    }
    public func stringify(_ val:T)->String?{
        return moneyToString(val)
    }
}
