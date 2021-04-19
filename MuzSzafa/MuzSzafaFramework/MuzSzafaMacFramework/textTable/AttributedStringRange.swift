//
//  AttributedStringRange.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public protocol AttributedStringRange:Equatable{
    var str:NSAttributedString{get}
    var range:NSRange{get}
}
public extension AttributedStringRange{
    var substr:NSAttributedString{
        get{
            return str.attributedSubstring(from: range)
        }
    }
    static func == <T>(lhs: Self, rhs: T) -> Bool where T:AttributedStringRange{
        return lhs.range == rhs.range && lhs.str == rhs.str
    }
}

public struct AttrStringRange:AttributedStringRange{
    public init(range: NSRange, from str: NSAttributedString) {
        self.range = range
        self.str = str
    }
    
    public var str: NSAttributedString
    
    public var range: NSRange
    
    
}

