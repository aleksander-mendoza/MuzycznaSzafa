//
//  EntSort.swift
//  MuzSzafaShared
//
//  Created by Alagris on 13/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

open class EntSort{
    public let ent:CoreDataEntity
    public init(ent:CoreDataEntity){
        self.ent = ent
    }
    private var selected:CoreDataAttr?
    open var sortBy:CoreDataAttr?{
        get{
            return selected
        }
        set{
            guard let new = newValue else{
                selected = nil
                return
            }
            selected = ent.contains(attr:new) ? new : nil
        }
    }
    open var ascending = true
    open var sort:[NSSortDescriptor]?{
        get{
            guard let n = selected?.name else{
                return nil
            }
            let desc = NSSortDescriptor(key: n, ascending: ascending)
            return [desc]
        }
    }
    open func makeEntries()->[PropertyTableEntry]{
        let n = ent.name.or()
        let v = selected==nil ? nil : ent.index(of: selected!)
        let data = ent.attrs.converted(with: {getLocalizedString(for:$0.name)}).collect()
        let opts:PropertyOptionDict = [.data : data]
        let list = ManualPropertyEntry(localizedName: n, type: .list, val: v, opts: opts){
            [weak self] (new,event)->Void in
            guard event is PropertyTableEntryValChangeEvent else {return}
            if let n = new{
                self!.selected = self!.ent.attrs[n as! Int]
            }else{
                self!.selected = nil
            }
        }
        let n2 = "order"
        let v2 = ascending
        let toggle = ManualPropertyEntry(name: n2, type: .toggle,val:v2){
            [weak self] (new,event)->Void in
            guard event is PropertyTableEntryValChangeEvent else {return}
            self!.ascending = new as! Bool? ?? false
        }
        return [list,toggle]
    }
}
