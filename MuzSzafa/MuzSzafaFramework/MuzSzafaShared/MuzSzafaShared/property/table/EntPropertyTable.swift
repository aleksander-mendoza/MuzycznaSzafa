//
//  EntityPropertyTable.swift
//  MuzSzafaShared
//
//  Created by Alagris on 26/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
public typealias EntPropertyObeserver =
    (
        _ val:Any?,
        _ attr:CoreDataAttr,
        _ event:PropertyTableEntryEvent
    )->Void

public protocol EntPropertyTable:PropertyTableProtocol{
    var ent:CoreDataEntity?{get set}
    var obj:NSManagedObject?{get set}
    var onChangeImpl:EntPropertyObeserver?{get set}
	var areRecordsSetManually:Bool{get set}
    func reloadData(attr:String)
}
public extension EntPropertyTable{
	
	public func attr(at row:Int)->CoreDataAttr?{
		if ent?.attrs.count ?? 0 > 0{
			return ent?.attrs[row]
		}
		return nil
	}
	
    public func updateAllValues(){
        for i in 0..<size{
            updateValue(at: i)
        }
    }
    
    private func set(entries:[PropertyTableEntry]){
        self.ent = nil
        self.entries = entries
    }
    private func set(ent:CoreDataEntity?){
        self.ent = ent
        reloadEnt()
    }
    private func set(ent name:String){
        set(ent: CoreContext.shared.cache.find(name))
    }
    
    private func set(obj: NSManagedObject?){
        var obj = obj //local copy
        if let o = obj,let e = ent{
            if o.entity != e.description {
                obj = nil
            }
		}
        self.obj = obj
    }
    private func set(ent:CoreDataEntity?,obj: NSManagedObject?){
        set(ent: ent)
        set(obj: obj)
    }
    public func reloadData(ent:CoreDataEntity?,obj: NSManagedObject?){
        set(ent: ent, obj: obj)
        reloadData()
    }
    public func reloadData(entries:[PropertyTableEntry]){
        ent = nil
        set(entries: entries)
		areRecordsSetManually = true
        reloadData()
    }
    public func updateValue(at index:Int){
        guard let ent = ent else{
            return
        }
        let entry = entries[index]
        let attr = ent.attrs[index]
		if attr.type == .relatList{
			let relatAttr = attr as! CoreDataRelatEntry
			entry.value = CellRelatListEntry(mo:obj,relat:relatAttr)
		}else{
			let val = obj?.value(forKey: attr.name)
			
			if attr.type == .relat{
				let mo = val as! NSManagedObject?
				let relatAttr = attr as! CoreDataRelatEntry
				if mo != nil && mo!.entity != relatAttr.destEnt.description{
					entry.value = nil
					assertionFailure("Relat attr \(relatAttr.name) was expected to return NSManagedObject of type \(relatAttr.destEnt.name ?? "?") but found \(mo!.entity.name ?? "?") instead!")
				}else{
					let pair:CellRelatEntry = (mo:mo,attr:relatAttr)
					entry.value = pair
				}
				
			}else if attr.type == .relatToMany{
				let mos = (val as! NSSet?) ?? NSSet()
				let relatAttr = attr as! CoreDataRelatEntry
				let pair:CellRelatToManyEntry = (mos:mos,attr:relatAttr)
				entry.value = pair
			}else{
				entry.value = val
			}
		}
		assert(entry.isCurrentValueAcceptable(), "Type \(entry.value==nil ? "Nil" : "Optional<\(type(of:entry.value!))>") is illegal for \(entry.type) in attribute \(attr.parent.name ?? "?").\(attr.name)!")
    }
    
    public func makePropertyObserver(forIndex:Int)->PropertyObeserver{
        guard let ent = ent else{
            return {_ ,_ in}
        }
        return makePropertyObserver(attr: ent.attrs[forIndex])
    }
    public func makePropertyObserver(attr:CoreDataAttr)->PropertyObeserver{
		
        return {[weak self] val,event in
            guard let mo = self!.obj else {return}
            if event is PropertyTableEntryValChangeEvent {
                attr.set(for: mo, val: {
                    if attr.type == .relat{
                        return (val as! CellRelatEntry).mo
                    }else{
                        return val
                    }
                }())
                attr.parent.cntx.save()
            }
            if let c = self!.onChangeImpl{
                c(val,attr,event)
            }
        }
    }
    
    public func reloadEnt(){
        guard let ent = ent else{
            return
        }
        self.entries = []
        for attr in ent.attrs{
			if attr.hideFromUser{
				continue
			}
            let new = attr.makeEntry()
            new.onChangeImpl = makePropertyObserver(attr: attr)
            entries.append(new)
        }
		areRecordsSetManually = false
    }
    public func index(attr:String)->Int?{
        return ent?.attrs.index(where: {$0.name == attr})
    }
    
}
