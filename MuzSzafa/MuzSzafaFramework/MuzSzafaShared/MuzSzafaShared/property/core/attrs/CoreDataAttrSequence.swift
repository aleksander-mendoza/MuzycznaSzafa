//
//  CoreDataAttrSequence.swift
//  MuzSzafaShared
//
//  Created by Alagris on 07/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension Sequence where Element == CoreDataAttr{
    public func stringify()->ConvertedSequence<Self,String>{
        return converted(){getLocalizedString(for: $0.name)}
    }
    public func serialize()->ConvertedSequence<Self,String>{
        return converted(){$0.name}
    }
}
