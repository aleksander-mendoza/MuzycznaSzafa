//
//  TextTable.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public class MutableTextTableCell:MutableTextTableBlockRange{
    
    public required  init(block: NSTextTableBlock, range: NSRange, fromMut str: NSMutableAttributedString) {
        self.range = range
        self.mutablestr = str
        self.block = block
        
    }
    
    public var block: NSTextTableBlock

    public var mutablestr: NSMutableAttributedString
    
    public var range: NSRange
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return MutableTextTableCell(block: block, range: range, fromMut: mutablestr)
    }
}
    
public class MutableTextTable:MutableTextTableRange{
    
    public required init(table: NSTextTable, range: NSRange, fromMut str: NSMutableAttributedString) {
        self.range = range
        self.mutablestr = str
        self.table = table
        
    }
    
    public typealias Element = MutableTextTableCell
    public typealias Iterator = MutableTextTableCellRangeIterator<MutableTextTable>
    
    public var table: NSTextTable
    
    public var mutablestr: NSMutableAttributedString
    
    public var range: NSRange
    
    
}
