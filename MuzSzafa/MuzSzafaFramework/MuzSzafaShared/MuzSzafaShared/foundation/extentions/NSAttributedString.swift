//
//  NSAttributedString.swift
//  MuzSzafaShared
//
//  Created by Alagris on 17/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public extension NSAttributedString {
    func rangeOf(string: String) -> Range<String.Index>? {
        return self.string.range(of: string)
    }
    func rangesOf(string: String, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
        return self.string.ranges(of:string,options:options,locale:locale)
    }
    func attributes(at index:Int)->[NSAttributedStringKey:Any]{
        return attributes(at: index, effectiveRange: nil)
    }
    func attribute(_ attrName:NSAttributedStringKey,at index:Int)->Any?{
        return attribute(attrName,at: index, effectiveRange: nil)
    }
    var totalRange:NSRange{
        get{
            return NSMakeRange(0, length)
        }
    }
    
    
    
}
