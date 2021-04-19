//
//  PropertyType.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData

public enum PropertyType:String{
    case int = "int"
    case string = "string"
    case bool = "bool"
    case date = "date"
    case money = "money"
    case display = "display"
    case text = "text"
    case telephone = "telephone"
    case email = "email"
    case list = "list"
    case relat = "relat"
	case relatList = "relatList"
	case relatToMany = "relatToMany"
    case button = "button"
	case moList = "moList"
    case toggle = "toggle"
	
    public static let allValues = [int,
                                   string,
                                   bool,
                                   date,
                                   money,
                                   display,
                                   text,
                                   telephone,
                                   email,
                                   list,
                                   relat,
								   relatList,
								   relatToMany,
                                   button,
								   moList,
                                   toggle]
    
    public func isTypeAllowed(_ type:NSAttributeType) -> Bool{
        switch self {
        case .list:
            fallthrough
        case .int:
            return type == .integer16AttributeType ||
            type == .integer32AttributeType ||
            type == .integer64AttributeType
        case .string:
            return type == .stringAttributeType
        case .bool:
            fallthrough
        case .toggle:
            return type == .booleanAttributeType
        case .date:
            return type == .dateAttributeType
        case .money:
            return type == .integer64AttributeType
        case .display:
            return true
        case .text:
            return type == .stringAttributeType
        case .telephone:
            return type == .stringAttributeType
        case .email:
            return type == .stringAttributeType
        case .relat:
			fallthrough
		case .relatList:
			fallthrough
		case .relatToMany:
            return type == .objectIDAttributeType
        case .button:
            return false
		case .moList:
			return false
		}
		
	}
	public func isValueAllowed(_ val:Any?)->Bool{
		if let v = val{
			return isValueAllowed(v)
		}
		return true
	}
	public func isValueAllowed(_ val:Any)->Bool{
		let t = type(of:val)
		switch self {
		case .list:
			fallthrough
		case .int:
			return t == Int32.self ||
				t == Int16.self ||
				t == Int64.self
		case .string:
			return t == String.self
		case .bool:
			fallthrough
		case .toggle:
			return t == Bool.self
		case .date:
			return t == Date.self
		case .money:
			return t == Int64.self
		case .display:
			return true
		case .text:
			return t == String.self
		case .telephone:
			return t == String.self
		case .email:
			return t == String.self
		case .relat:
			return t == NSManagedObject.self
		case .relatToMany:
			return t == NSSet.self
		case .button:
			return false
		case .relatList:
			return t == NSSet.self
		case .moList:
			return t == [NSManagedObject].self
		}
	}
    static func getByName(_ name:String)->PropertyType{
        for e in PropertyType.allValues{
            if e.rawValue == name{
                return e
            }
        }
        return .display
    }
    
    public static func getByName(_ name:String,_ type:NSAttributeType)->PropertyType{
        let found = getByName(name)
		assert(found.isTypeAllowed(type))
        return found
    }
	
    public var usedOptions:[PropertyOptions]{
        get{
            switch self {
			case .moList:
				return [.editable]
			case .relatList:
				fallthrough
            case .relat:
                return [.editable]
            case .list:
                return [.size]
            default:
                return []
            }
        }
    }
}

