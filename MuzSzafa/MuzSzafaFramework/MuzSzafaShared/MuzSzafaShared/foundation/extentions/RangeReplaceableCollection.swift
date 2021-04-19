//
//  RangeReplaceableCollection.swift
//  MuzSzafaShared
//
//  Created by Alagris on 27/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
extension RangeReplaceableCollection {
    public mutating func resize(_ size: Int, fillWith value: Iterator.Element) {
        let c = count
        if c < size {
            let missing = size - c
            let rep = repeatElement(value, count: missing)
            append(contentsOf: rep)
        } else if c > size {
            let newEnd = index(startIndex, offsetBy: size)
            removeSubrange(newEnd ..< endIndex)
        }
    }
    
    public func count(filter:(Self.Element)->Bool)->Int{
        var out:Int = 0
        for elem in self where filter(elem){
            out += 1
        }
        return out
    }
    
//    public func appendOrSet(at index:Int,_ element:Self.Element){
//        if index >= count{
//            
//        }
//    }
}
