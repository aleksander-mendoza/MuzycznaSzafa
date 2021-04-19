//
//  MutableAttributedStringRange.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public protocol MutableAttributedStringRange: AttributedStringRange{
    var mutablestr:NSMutableAttributedString{get}
}

public extension MutableAttributedStringRange{
    public var str: NSAttributedString{
        get{
            return mutablestr
        }
    }
    public var mutsubstr: NSMutableAttributedString{
        get{
            let sub = mutablestr.attributedSubstring(from: range)
            return NSMutableAttributedString(attributedString: sub)
        }
    }
}


public struct MutableAttrStringRange:MutableAttributedStringRange{
    public init(range: NSRange, from str: NSMutableAttributedString) {
        self.range = range
        self.mutablestr = str
    }
    
    public var mutablestr: NSMutableAttributedString
    
    public var range: NSRange
    
    
}

