//
//  TextTableCellRangeIterator.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public class TextTableCellRangeIterator<T>:IteratorProtocol
where T:TextTableRange{
    
    public typealias Element = T.Element
    private let src:T
    private var index:Int
    public func next() -> Element? {
        while index < src.range.upperBound{
            if let block = src.cell(at: index){
                index = block.range.upperBound
                return block
            }else{
                index += 1
            }
        }
        return nil
    }
    
    init(table:T){
        src = table
        index = src.range.lowerBound
    }
}

