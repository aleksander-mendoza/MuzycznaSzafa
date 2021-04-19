//
//  PropertyTableEntry.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Foundation
import CoreData
public typealias PropertyObeserver = (Any?,PropertyTableEntryEvent)->Void
public protocol PropertyTableEntry:class{
    var name:String{get set}
    var value:Any?{get set}
	var userHelp:CoreDataAttrHelp?{get set}
    var onChangeImpl:PropertyObeserver?{get set}
    var type:PropertyType{get}
    var delegate:PropertyTableCellDelegate?{get set}
    var options:PropertyOptionDict{get set}
}
public extension PropertyTableEntry{
	public func isValueAllowed(_ val:Any?)->Bool{
		if let v = val{
			return isValueAllowed(v)
		}
		return true
	}
	public func isValueAllowed(_ val:Any)->Bool{
		return MuzSzafaShared.isValueAllowed(self.type, val)
	}
	public func isCurrentValueAllowed()->Bool{
		return isValueAllowed(value)
	}
	
	public func isValueAcceptable(maybe val:Any?)->Bool{
		if let v = val{
			return isValueAcceptable(v)
		}
		return true
	}
	public func isValueAcceptable(_ val:Any)->Bool{
		return MuzSzafaShared.isValueAcceptable(self.type, val)
	}
	public func isCurrentValueAcceptable()->Bool{
		return isValueAcceptable(maybe:value)
	}
	
    func onChange(){
        onChange(event:PropertyTableEntryValChangeEvent.singleton)
    }
    func onChange(event:PropertyTableEntryEvent){
        if let c = onChangeImpl{
			let v = value
			let e = event
            c(v,e)
        }
    }
    func set(option:PropertyOptions,val:Any){
        self.options[option] = val
        delegate?.propertyTableCell(newOption: option)
    }
    func set(options:PropertyOptionDict){
        self.options = options
        delegate?.propertyTableCell(newOptions: options)
    }
    func set(value:Any?){
        self.value = value
        delegate?.propertyTableCell(newValue: self.value)
    }
    func set(name:String){
        self.name = name
        delegate?.propertyTableCell(newName: self.name)
    }
	func set(userHelp:CoreDataAttrHelp?){
		self.userHelp = userHelp
		delegate?.propertyTableCell(newUserHelp: self.userHelp)
	}
	
	var isEditable:Bool?{
		get{
			return options[.editable] as! Bool?
		}
	}
	
	var ent:CoreDataEntity?{
		get{
			switch type {
			case .relat:
				assert(value is CellRelatEntry?)
				guard let t = value as? CellRelatEntry else {
					return nil
				}
				return t.attr.destEnt
			case .relatList:
				assert(value is CellRelatListEntry?)
				guard let t = value as? CellRelatListEntry else {
					return nil
				}
				return t.relat.destEnt
			case .relatToMany:
				assert(value is CellRelatToManyEntry?)
				guard let t = value as? CellRelatToManyEntry else {
					return nil
				}
				return t.attr.destEnt
			default:
				guard let ent = options[.ent] else{
					return nil
				}
				assert(ent is CoreDataEntity)
				guard let t = ent as? CoreDataEntity else {
					return nil
				}
				return t
			}
		}
	}
}

private func isValueAllowed(_ propType:PropertyType,_ val:Any)->Bool{
	let t = type(of:val)
	switch propType {
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
		return t == CellRelatEntry.self
	case .relatList:
		return t == CellRelatListEntry.self
	case .relatToMany:
		return t == CellRelatToManyEntry.self
	case .button:
		return false
	case .moList:
		return t == [NSManagedObject].self
	}
}

/**isValueAllowed tests if the type matches exactly what's expected. isValueAcceptable tests if expected type is assignable from actual type*/
private func isValueAcceptable(_ propType:PropertyType,_ val:Any)->Bool{
	switch propType {
	case .list:
		fallthrough
	case .int:
		return ((val as? Int) != nil)
	case .string:
		return ((val as? String) != nil)
	case .bool:
		fallthrough
	case .toggle:
		return ((val as? Bool) != nil)
	case .date:
		return ((val as? Date) != nil)
	case .money:
		return ((val as? Int64) != nil)
	case .display:
		return true
	case .text:
		return ((val as? String) != nil)
	case .telephone:
		return ((val as? String) != nil)
	case .email:
		return ((val as? String) != nil)
	case .relat:
		return ((val as? CellRelatEntry) != nil)
	case .relatList:
		return ((val as? CellRelatListEntry) != nil)
	case .relatToMany:
		return ((val as? CellRelatToManyEntry) != nil)
	case .button:
		return false
	case .moList:
		return ((val as? [NSManagedObject]) != nil)
	}
}
