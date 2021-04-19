//
//  EntPropPrepr.swift
//  MuzSzafaShared
//
//  Created by Alagris on 09/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
public protocol EntPropRepr:PropertyRepresentation {
    var attrs:[CoreDataAttr]{get}
    func loadExternal(mo:NSManagedObject)
    func loadPrimary(mo:NSManagedObject)
    func loadSecondary(mo:NSManagedObject)
}
public extension EntPropRepr{
    
    
    private func loadFields(vis:PropertyVisibility,
                            mo:NSManagedObject){
        var index = 0
        for attr in attrs where vis.accepts(attr.vis){
            fields[vis]![index] = attr.stringify(maybe:mo)
            index += 1
        }
    }
    
    func loadExternal(mo:NSManagedObject){
        loadFields(vis: .external,mo: mo)
    }
    func loadPrimary(mo:NSManagedObject){
        loadFields(vis: .primary,mo: mo)
    }
    func loadSecondary(mo:NSManagedObject){
        loadFields(vis: .secondary,mo: mo)
    }
    func loadAll(mo:NSManagedObject){
        loadPrimary(mo: mo)
        loadSecondary(mo: mo)
        loadExternal(mo: mo)
    }
    func computeField(mo:NSManagedObject,at:Int,vis:PropertyVisibility)->String?{
        let attr = getAttr(at: at, vis: vis)
        let val = attr?.stringify(maybe: mo)
        return val
    }
    func getAttr(at: Int, vis: PropertyVisibility)->CoreDataAttr?{
        var index = 0
        for attr in attrs where vis.accepts(attr.vis){
            if index == at{
                return attr
            }
            index += 1
        }
        return nil
    }
    var primaryAttrs:[CoreDataAttr]{
        get{
            return attrs.filter(){
                PropertyVisibility.primary.accepts($0.vis)
            }
        }
    }
    var secondaryAttrs:[CoreDataAttr]{
        get{
            return attrs.filter(){
                PropertyVisibility.secondary.accepts($0.vis)
            }
        }
    }
    var externalAttrs:[CoreDataAttr]{
        get{
            return attrs.filter(){
                PropertyVisibility.external.accepts($0.vis)
            }
        }
    }
    
}
