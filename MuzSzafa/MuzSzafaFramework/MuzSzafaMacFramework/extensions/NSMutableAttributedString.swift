//
//  NSAttributedString.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 20/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public extension NSMutableAttributedString{
    
    func mutParagraphStyle(at index:Int)->NSMutableParagraphStyle?{
        guard let s = paragraphStyle(at: index) else{
            return nil
        }
        if let p = s as? NSMutableParagraphStyle{
            return p
        }else{
            return (s.mutableCopy() as! NSMutableParagraphStyle)
        }
    }
    
    func mutOutterTableRange<T>(at index:Int)->T? where T:MutableTextTableRange{
        guard let t = outterTable(at:index) else{
            return nil
        }
        return T(table: t, fromMut: self, at: index)
    }
    func mutOutterTableRanges<T>()->[T] where T:MutableTextTableRange{
        var index = 0
        let len = length
        var output:[T] = []
        while index < len{
            if let tab:T = mutOutterTableRange(at: index){
                output.append(tab)
                index = tab.range.upperBound
            }else{
                index += 1
            }
        }
        return output
    }
    func remove(textBlock:NSTextBlock){
        for i in 0..<length{
            if let s = mutParagraphStyle(at: i),
                let i = s.textBlocks.index(of: textBlock){
                s.textBlocks.remove(at: i)
            }
        }
    }
}
