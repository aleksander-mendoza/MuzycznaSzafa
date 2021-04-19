//
//  ManualPropertyEntry.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

open class ManualPropertyEntry:PropertyTableEntry{
	public var userHelp: CoreDataAttrHelp?
	
    public var options: PropertyOptionDict
    
    public var delegate: PropertyTableCellDelegate?
    
    open var name: String
    
    open var value: Any?
    
    open var onChangeImpl: PropertyObeserver?
    
    open var type: PropertyType
    
    public init(name:String,
                type: PropertyType,
                val:Any?=nil,
                opts:PropertyOptionDict=[:],
				userHelp:CoreDataAttrHelp?=nil,
                callback:PropertyObeserver?=nil
				) {
        self.name = name
        self.type = type
        self.value = val
        self.options = opts
        self.onChangeImpl = callback
		self.userHelp = userHelp
		assert(isValueAcceptable(maybe:val))
    }
	
	
    public convenience init(localizedName:String,
                            type: PropertyType,
                            val:Any?=nil,
                            opts:PropertyOptionDict=[:],
							userHelp:CoreDataAttrHelp?=nil,
                            callback:PropertyObeserver?=nil) {
		self.init(name: getLocalizedString(for: localizedName), type: type, val: val, opts:opts, userHelp:userHelp, callback: callback)
    }
    
}
