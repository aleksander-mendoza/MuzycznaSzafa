//
//  NSTextTableBlockArray.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 20/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public extension Array where Element == NSTextTableBlock{
    
    func row(_ row:Int)->[NSTextTableBlock]{
        var out:[NSTextTableBlock] = []
        for b in self{
            if b.startingRow <= row && row < b.startingRow + b.rowSpan{
                out.append(b)
            }
        }
        return out
    }
    func column(_ column:Int)->[NSTextTableBlock]{
        var out:[NSTextTableBlock] = []
        for b in self{
            if b.startingColumn <= column && column < b.startingColumn + b.columnSpan{
                out.append(b)
            }
        }
        return out
    }
    
//    var totalRange:NSRange{
//        get{
//            var begin,end:Int
//            for r in self{
//                if r. < begin{
//                    begin = r.startingColumn
//                }
//                if r.end < begin{
//                    begin = r.startingColumn
//                }
//            }
//        }
//    }
    
}
