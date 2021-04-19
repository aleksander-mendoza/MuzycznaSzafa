//
//  CoreDataRelatSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

open class CoreDataListSerializer:CoreDataGenericSerializer{
    public typealias T = Int
    private let attr:CoreDataAttr
    public init(parent:CoreDataAttr){
        self.attr = parent
    }
    public func serialize(any: Any) -> String {
        return serialize(numerifyToInt(any))
    }
    public func serialize(_ val: T) -> String {
        return String(val)
    }
    public func deserialize(_ val:String)->T?{
        return Int(val)
    }
    public func stringify(any: Any) -> String? {
        return stringify(numerifyToInt(any))
    }
    public func stringify(_ val:T)->String?{
        return getLocalizedString(for:"\(attr.name)_\(val)")
    }
    
    
    
    public static func parseList(property:PropertyTableEntry,_ array:inout [String]?)->String{
        let size = property.options[.size] as! Int? ?? 0
        
        if array != nil{
            array!.resize(size, fillWith: "")
        }else{
            array = [String](repeating: "", count: size)
        }
        let n = property.name
        for i in 0..<size{
            array![i] = "\(i): \(getLocalizedString(for:"\(n)_\(i)"))"
        }
        return getLocalizedString(for: n)
    }
}
