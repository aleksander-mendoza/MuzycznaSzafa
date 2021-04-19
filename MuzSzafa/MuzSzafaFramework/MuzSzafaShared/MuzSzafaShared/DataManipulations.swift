//
//  DataManipulations.swift
//  MuzSzafa
//
//  Created by Alagris on 08/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
//
//open class DataManipulation<T>:CoreDataPkManip{
//    public let primaryKey: String
//    public let name:String
//    
//    public init(_ mainAttr:String,_ name:String) {
//        self.primaryKey = mainAttr
//        self.name = name
//    }
//    
//    
//    
//}


public func validateName(_ name:String?)->Bool{
    return !(name?.isEmpty ?? true)
}

public func validateName(_ name:String)->Bool{
    return !name.isEmpty
}

