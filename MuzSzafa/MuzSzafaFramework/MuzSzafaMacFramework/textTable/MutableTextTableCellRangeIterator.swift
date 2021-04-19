//
//  TextTableCellRangeIterator.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public class MutableTextTableCellRangeIterator<T>:IteratorProtocol
where T:MutableTextTableRange{
    
    public typealias Element = T.Element
    private let src:T
    private var index:Int
    public func next() -> Element? {
        while index >= 0{
            if let block = src.mutCell(at: index){
                index = block.range.lowerBound - 1
                return block
            }else{
                index -= 1
            }
        }
        return nil
    }
    
    init(table:T){
        src = table
        index = src.range.upperBound - 1
    }
}

