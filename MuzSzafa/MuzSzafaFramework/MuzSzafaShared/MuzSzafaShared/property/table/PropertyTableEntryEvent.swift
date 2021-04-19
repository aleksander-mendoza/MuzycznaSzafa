//
//  PropertyTableEntryEvent.swift
//  MuzSzafaShared
//
//  Created by Alagris on 22/08/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public protocol PropertyTableEntryEvent {
    var meta:[Any]?{get}
}
public extension PropertyTableEntryEvent{
    var meta:[Any]?{
        get{
            return nil
        }
    }
}
