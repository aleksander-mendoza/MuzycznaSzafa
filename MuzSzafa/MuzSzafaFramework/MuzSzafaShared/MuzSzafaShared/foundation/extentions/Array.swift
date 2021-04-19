//
//  Array.swift
//  MuzSzafaShared
//
//  Created by Alagris on 27/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension Array{
    public static func += (_ arr:inout Array,_ new:Element){
        arr.append(new)
    }
    public mutating func append<Val>(arr:[Val],convert:(Val)->Element){
        for val in arr{
            let elem = convert(val)
            append(elem)
        }
    }
    public init<Val>(arr:[Val],convert:(Val)->Element){
        self.init()
        append(arr: arr, convert: convert)
    }
    public mutating func append<Val>(arr:[Val],convert:(Val,Int)->Element){
        for (i,val) in arr.enumerated(){
            let elem = convert(val,i)
            append(elem)
        }
    }
    public init<Val>(arr:[Val],convert:(Val,Int)->Element){
        self.init()
        append(arr: arr, convert: convert)
    }
    
    
    
    
}
