//
//  CoreDataStringSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

open class CoreDataStringSerializer:CoreDataGenericSerializer{
    public typealias T = String
    
    public func deserialize(_ val:String)->T?{
        return val
    }
    public func stringify(_ val:T)->String?{
        return val
    }
}
