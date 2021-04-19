//
//  EntSort.swift
//  MuzSzafaShared
//
//  Created by Alagris on 13/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class EntSortGroup{
    public let all:[EntSort]
    open var allAccessEntires:[PropertyTableEntry]{
        var out = [PropertyTableEntry]()
        for one in all{
            out += one.makeEntries()
        }
        return out
    }
    convenience public init(cntx:CoreContext){
        self.init(cache: cntx.cache)
    }
    convenience public init(cache:CoreDataCache){
        self.init(ents: cache.ents)
    }
    public init(ents:[CoreDataEntity]){
        var tmpAll = [EntSort]()
        for ent in ents{
            tmpAll.append(EntSort(ent:ent))
        }
        all = tmpAll
    }
    open func find(ent name:String)->EntSort?{
        for one in all{
            if one.ent.name == name{
                return one
            }
        }
        return nil
    }
}
