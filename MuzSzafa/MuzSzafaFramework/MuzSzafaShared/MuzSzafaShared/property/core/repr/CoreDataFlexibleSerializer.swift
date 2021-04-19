//
//  CoreDataFlexibleSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
open class CoreDataFlexibleSerializer:CoreDataGenericSerializer{
    public typealias T = Any
    convenience public init(attr:CoreDataAttr){
        self.init(type: attr.rawType)
    }
    private let stringifier:Stringifier
    private let deserializer:Deserializer
    public init(type:NSAttributeType){
        stringifier = type.genStringifier()
        deserializer = type.genDeserializer()
    }
    public func deserialize(_ val:String)->T?{
        return deserializer(val)
    }
    public func stringify(_ val:T)->String?{
        return stringifier(val)
    }
}
