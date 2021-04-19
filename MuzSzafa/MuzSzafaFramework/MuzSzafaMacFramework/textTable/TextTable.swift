//
//  TextTable.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public class TextTableCell:TextTableBlockRange{
    public required  init(block: NSTextTableBlock, range: NSRange, from str: NSAttributedString) {
        self.range = range
        self.str = str
        self.block = block
        
    }
    
    public var block: NSTextTableBlock
    
    public var str: NSAttributedString
    
    public var range: NSRange
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return TextTableCell(block: block, range: range, from: str)
    }
    
}
    
public class TextTable:TextTableRange{
    public required init(table: NSTextTable, range: NSRange, from str: NSAttributedString) {
        self.range = range
        self.str = str
        self.table = table
        
    }
    
    public typealias Element = TextTableCell
    public typealias Iterator = TextTableCellRangeIterator<TextTable>
    
    public var table: NSTextTable
    
    public var str: NSAttributedString
    
    public var range: NSRange
    
    
}
