//
//  CoreDataDummySerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


open class CoreDataDummySerializer:CoreDataGenericSerializer{
    public typealias T = Any
    
    public func deserialize(_ val:String)->T?{
        return nil
    }
    public func stringify(_ val:T)->String?{
        return nil
    }
}
