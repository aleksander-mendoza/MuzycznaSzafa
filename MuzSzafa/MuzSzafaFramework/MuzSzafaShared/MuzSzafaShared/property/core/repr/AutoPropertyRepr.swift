//
//  AutoPropertyRepr.swift
//  MuzSzafaShared
//
//  Created by Alagris on 27/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
open class AutoPropertyRepr:EntPropRepr{
    public var fields: [PropertyVisibility : [String?]] = [:]
    
    public var attrs:[CoreDataAttr]
    public init(attrs:[CoreDataAttr]){
        self.attrs = attrs
        let p = attrs.count(){
            PropertyVisibility.primary.accepts($0.vis)
        }
        let s = attrs.count(){
            PropertyVisibility.secondary.accepts($0.vis)
        }
        let e = attrs.count(){
            PropertyVisibility.external.accepts($0.vis)
        }
        fields[.primary] = [String?](count: p)
        fields[.secondary] = [String?](count: s)
        fields[.external] = [String?](count: e)
    }
}
