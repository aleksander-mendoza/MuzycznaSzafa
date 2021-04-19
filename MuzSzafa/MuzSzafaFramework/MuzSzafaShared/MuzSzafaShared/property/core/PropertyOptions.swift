//
//  PropertyOptions.swift
//  MuzSzafaShared
//
//  Created by Alagris on 24/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public typealias PropertyOptionDict = [PropertyOptions:Any]
public enum PropertyOptions:String{
    case size = "size"
    case editable = "editable"
	case ent = "ent"
	case enabled = "enabled"
    case data = "data"
    
    public static let allValues = [size,editable]
    public func parse(json:[String:Any]?)->Any?{
        if let js = json{
            return parse(json: js)
        }
        return nil
    }
    public func parse(json:[String:Any])->Any?{
        if let elem = json[self.rawValue]{
            return parse(val: elem)
        }
        return nil
    }
    public func parse(val:Any)->Any?{
        switch self {
        case .size:
            return Int(val as! String)
		case .enabled:
			fallthrough
        case .editable:
            return Bool(val as! String)
        case .data:
            return val as! [String]
		case .ent:
			return CoreContext.find(ent: val as! String)
        }
    }
    public func test(typeOf val:Any)->Bool{
        switch self {
        case .size:
            return val is Int
		case .enabled:
			fallthrough
        case .editable:
            return val is Bool
        case .data:
            return val is [String]
		case .ent:
			return val is CoreDataEntity
		}
    }
    public func test(typeOf val:PropertyType)->Bool{
        return val.usedOptions.contains(self)
    }
}
