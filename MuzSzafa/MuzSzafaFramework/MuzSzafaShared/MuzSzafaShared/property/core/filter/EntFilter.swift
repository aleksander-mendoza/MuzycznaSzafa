//
//  EntFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 16/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
open class EntFilter{
    public let parent:CoreDataEntity
    public var filters = [CoreDataFilter]()
    open var entires:[PropertyTableEntry]{
        get{
            var out = [PropertyTableEntry]()
			for filter in filters where filter.isEnabled{
                if let f = filter as? CoreDataUniFilter{
                    let entry = FilterPropertyEntry(filter: f, param: 0)
                    out.append(entry)
                }else if let f = filter as? CoreDataBiFilter{
                    let from = FilterPropertyEntry(filter: f, param: 0,subname:"from")
                    out.append(from)
                    let to = FilterPropertyEntry(filter: f, param: 1,subname:"to")
                    out.append(to)
                }
                
            }
            return out
        }
    }
    open var accessEntires:[PropertyTableEntry]{
        get{
            var out = [PropertyTableEntry]()
            for filter in filters{
                out.append(FilterAccessPropertyEntry(filter: filter))
            }
            return out
        }
    }
    open var pred:SafePredicate.Node?{
        get{
            return concatenate(filters: filters)
        }
    }
    
    public init(from ent:CoreDataEntity){
        parent = ent
        for attr in parent.attrs{
            filters.append(attr.makeFilter())
        }
    }
    
    
}
