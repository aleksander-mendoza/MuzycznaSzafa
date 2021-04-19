//
//  EntFilterGroup.swift
//  MuzSzafaShared
//
//  Created by Alagris on 16/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

open class EntFilterGroup{
    public let all:[EntFilter]
    open var allEntries:[PropertyTableEntry]{
        get{
            var out = [PropertyTableEntry]()
            for one in all{
                let subEntries = one.entires
                
                if subEntries.count > 0{
                    let title = one.parent.name!
                    let label = ManualPropertyEntry(name: title, type: .display)
                    label.value = ""
                    out.append(label)
                    out += subEntries
                }
            }
            return out
        }
    }
    open var allAccessEntires:[PropertyTableEntry]{
        var out = [PropertyTableEntry]()
        for one in all{
            let title = one.parent.name!
            let label = ManualPropertyEntry(name: title, type: .display)
            label.value = ""
            out.append(label)
            out += one.accessEntires
        }
        return out
    }
    convenience public init(cntx:CoreContext){
        self.init(cache:cntx.cache)
    }
    convenience public init(cache:CoreDataCache){
        self.init(ents: cache.ents)
    }
    public init(ents:[CoreDataEntity]){
        var tmpAll = [EntFilter]()
        for ent in ents{
            tmpAll.append(EntFilter(from: ent))
        }
        all = tmpAll
    }
    open func find(ent name:String)->EntFilter?{
        for one in all{
            if one.parent.name == name{
                return one
            }
        }
        return nil
    }
}
