//
//  FilterPropertyEntry.swift
//  MuzSzafaShared
//
//  Created by Alagris on 16/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

open class FilterPropertyEntry: PropertyTableEntry {
	public var userHelp: CoreDataAttrHelp?
    public var delegate: PropertyTableCellDelegate?
    public let paramIndex:Int
    public let subname:String?
    private var filter:CoreDataFilter
    
    public var options: PropertyOptionDict{
        get{
            return filter.attr.options
        }
        set{
            filter.attr.options = newValue
        }
    }
    
    public var name: String{
        get{
            if let s = subname{
                let n = getLocalizedString(for: filter.attr.name)
                return "("+n+") "+getLocalizedString(for: s)
            }else{
                return filter.attr.name
            }
        }
        set{}
    }
    
    public var value: Any?{
        get{
            return filter[paramIndex]
        }
        set{
            filter[paramIndex] = newValue
        }
    }
    
    public var onChangeImpl: PropertyObeserver?{
        get{
            return{
                if $1 is PropertyTableEntryValChangeEvent{
                    self.value = $0
                }
            }
        }
        set{}
    }
    
    public var type: PropertyType{
        get{
            let t = filter.attr.type
			if t == .display{
				switch filter.attr.rawType{
				case .undefinedAttributeType:
					return .display
				case .integer16AttributeType:
					return .int
				case .integer32AttributeType:
					return .int
				case .integer64AttributeType:
					return .int
				case .decimalAttributeType:
					return .int
				case .doubleAttributeType:
					return .int
				case .floatAttributeType:
					return .int
				case .stringAttributeType:
					return .string
				case .booleanAttributeType:
					return .bool
				case .dateAttributeType:
					return .date
				case .binaryDataAttributeType:
					return .display
				case .UUIDAttributeType:
					return .display
				case .URIAttributeType:
					return .display
				case .transformableAttributeType:
					return .display
				case .objectIDAttributeType:
					return .display
				}
			}else{
            	return t
			}
        }
    }
    
    public init(filter:CoreDataFilter,
                param index:Int,
                subname:String?=nil){
        paramIndex = index
        self.filter = filter
        self.subname = subname
    }
}
