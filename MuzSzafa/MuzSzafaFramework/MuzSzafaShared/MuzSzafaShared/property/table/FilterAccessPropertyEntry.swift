//
//  FilterAccessPropertyEntry.swift
//  MuzSzafaShared
//
//  Created by Alagris on 16/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

open class FilterAccessPropertyEntry: PropertyTableEntry {
	public var userHelp: CoreDataAttrHelp?
	
    public var options: PropertyOptionDict = [:]
    
    public var delegate: PropertyTableCellDelegate?
    
    private var filter:CoreDataFilter
    
    public var name: String{
        get{
            return getLocalizedString(for: filter.attr.name)
        }
        set{}
    }
    
    public var value: Any?{
        get{
            return filter.isEnabled
        }
        set{
            filter.isEnabled = (newValue as! Bool?) ?? false
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
            return .bool
        }
    }
    
    public init(filter:CoreDataFilter){
        self.filter = filter
    }
    
}
