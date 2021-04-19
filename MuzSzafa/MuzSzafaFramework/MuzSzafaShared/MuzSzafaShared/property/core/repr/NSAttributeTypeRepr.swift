//
//  NSAttributeType.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public typealias Stringifier = (Any)->String?
public typealias Deserializer = (String)->Any?
public extension NSAttributeType{
    public func genStringifier()->Stringifier{
        switch self{
        case .binaryDataAttributeType:
            return {
                return String(data: ($0 as! NSData) as Data, encoding: .utf8)
            }
        case .booleanAttributeType:
            return {
                return String($0 as! Bool)
            }
        case .dateAttributeType:
            return {
                let f = DateFormatter()
                f.dateFormat = "dd-MM-YYYY"
                return f.string(from: $0 as! Date)
            }
        case .integer16AttributeType:
            return {
                return String($0 as! Int16)
            }
        case .integer32AttributeType:
            return {
                return String($0 as! Int32)
            }
        case .integer64AttributeType:
            return {
                return String($0 as! Int64)
            }
        case .floatAttributeType:
            return {
                return String($0 as! Float)
            }
        case .doubleAttributeType:
            return {
                return String($0 as! Double)
            }
        case .stringAttributeType:
            return {
                return ($0 as! String)
            }
        default:
            return {_ in return nil}
        }
    }
    public func genDeserializer()->Deserializer{
        switch self{
        case .binaryDataAttributeType:
            return {
                return $0.data(using: .utf8)
            }
        case .booleanAttributeType:
            return {
                return Bool($0)
            }
        case .dateAttributeType:
            return {
                let f = DateFormatter()
                f.dateFormat = "dd-MM-YYYY"
                return f.date(from: $0)
            }
        case .integer16AttributeType:
            return {
                return Int16($0)
            }
        case .integer32AttributeType:
            return {
                return Int32($0)
            }
        case .integer64AttributeType:
            return {
                return Int64($0)
            }
        case .floatAttributeType:
            return {
                return Float($0)
            }
        case .doubleAttributeType:
            return {
                return Double($0)
            }
        case .stringAttributeType:
            return {
                return $0
            }
        default:
            return {_ in return nil}
        }
    }
}
