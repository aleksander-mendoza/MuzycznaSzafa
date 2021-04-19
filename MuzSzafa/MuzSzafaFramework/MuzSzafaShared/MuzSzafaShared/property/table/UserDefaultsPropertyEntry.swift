//
//  UserDefaultsPropertyEntry.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation


open class UserDefaultsPropertyEntry:ManualPropertyEntry{
    
    public init(name:String,
                key:String,
                type: PropertyType,
                opts:PropertyOptionDict=[:],
                ud:UserDefaults=UserDefaults.standard) {
        super.init(name: name, type: type, val: ud.value(forKey: key), opts: opts){
            (val,type)->Void in
            if type is PropertyTableEntryValChangeEvent{
                ud.set(val, forKey: key)
            }
        }
    }
    public convenience init(localizedName:String,
                key:String,
                type: PropertyType,
                opts:PropertyOptionDict=[:],
                ud:UserDefaults=UserDefaults.standard) {
        self.init(name: getLocalizedString(for: localizedName), key: key, type: type, opts: opts, ud: ud)
    }
}
