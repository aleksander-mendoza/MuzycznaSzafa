//
//  NSAttributeType.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public extension NSAttributeType{
	
	func checkType(of val:Any?)->Bool{
		guard let val = val else{
			return true
		}
		switch self{
		case .undefinedAttributeType:
			assertionFailure()
			return true
		case .integer16AttributeType:
			return (val as? Int) != nil
		case .integer32AttributeType:
			return (val as? Int) != nil
		case .integer64AttributeType:
			return (val as? Int) != nil || (val as? Int64) != nil
		case .decimalAttributeType:
			return (val as? Decimal) != nil
		case .doubleAttributeType:
			return (val as? Double) != nil
		case .floatAttributeType:
			return (val as? Float) != nil
		case .stringAttributeType:
			return (val as? String) != nil
		case .booleanAttributeType:
			return (val as? Bool) != nil
		case .dateAttributeType:
			return (val as? Date) != nil
		case .binaryDataAttributeType:
			return (val as? [UInt8]) != nil
		case .UUIDAttributeType:
			return (val as? UUID) != nil
		case .URIAttributeType:
			return (val as? URL) != nil
		case .transformableAttributeType:
			return false
		case .objectIDAttributeType:
			return (val as? NSManagedObject) != nil
		}
	}
	
	
	public var name:String{
		get{
			switch self{
			case .undefinedAttributeType:
				return "undefinedAttributeType"
			case .integer16AttributeType:
				return "integer16AttributeType"
			case .integer32AttributeType:
				return "integer32AttributeType"
			case .integer64AttributeType:
				return "integer64AttributeType"
			case .decimalAttributeType:
				return "decimalAttributeType"
			case .doubleAttributeType:
				return "doubleAttributeType"
			case .floatAttributeType:
				return "floatAttributeType"
			case .stringAttributeType:
				return "stringAttributeType"
			case .booleanAttributeType:
				return "booleanAttributeType"
			case .dateAttributeType:
				return "dateAttributeType"
			case .binaryDataAttributeType:
				return "binaryDataAttributeType"
			case .UUIDAttributeType:
				return "UUIDAttributeType"
			case .URIAttributeType:
				return "URIAttributeType"
			case .transformableAttributeType:
				return "transformableAttributeType"
			case .objectIDAttributeType:
				return "objectIDAttributeType"
			}
		}
	}
	
	public func autogenerate()->Any?{
		switch self{
		case .stringAttributeType:
			return String(length: 32)
		case .decimalAttributeType:
			return Decimal(integerLiteral: Int(arc4random()))
		case .integer16AttributeType:
			return Int16(arc4random())
		case .integer32AttributeType:
			return Int32(arc4random())
		case .integer64AttributeType:
			return Int64(arc4random())
		case .floatAttributeType:
			return Float(arc4random())
		case .doubleAttributeType:
			return Double(arc4random())
		default:
			return nil
		}
	}
}
