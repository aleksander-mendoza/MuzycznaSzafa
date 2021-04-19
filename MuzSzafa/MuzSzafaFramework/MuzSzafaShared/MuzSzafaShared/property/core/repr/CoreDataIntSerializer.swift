//
//  CoreDataIntSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
open class CoreDataIntSerializer:CoreDataGenericSerializer{
    public typealias T = Int
    public func deserialize(_ val:String)->T?{
        return Int(val)
    }
    public func stringify(_ val:T)->String?{
        return String(val)
    }
}
