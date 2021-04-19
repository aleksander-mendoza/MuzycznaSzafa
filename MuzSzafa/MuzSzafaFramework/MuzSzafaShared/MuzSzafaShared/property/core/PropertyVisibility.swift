//
//  PropertyVisibility.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

public enum PropertyVisibility:String{
    case none = "none"
    case primary = "primary"
    case secondary = "secondary"
    case external = "external"
    
    public static let allValues = [none, primary, secondary, external]
    
    public static func getByName(_ c:String)->PropertyVisibility{
        for e in allValues{
            if e.rawValue == c{
                return e
            }
        }
        return .none
    }
    public func accepts(_ other:PropertyVisibility)->Bool{
        return (self == other) || (self == .primary && other == .external)
    }
    
    
}
