//
//  NSTextTableBlockArray.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 20/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public extension Array where Element:TextTableBlockRange {
    
    
    var totalRange:NSRange{
        get{
            var begin = Int.max,end = Int.min
            for r in self{
                if r.range.lowerBound < begin{
                    begin = r.range.lowerBound
                }
                if r.range.upperBound > end{
                    end = r.range.upperBound
                }
            }
            return NSMakeRange(begin, end - begin)
        }
    }
    
}
