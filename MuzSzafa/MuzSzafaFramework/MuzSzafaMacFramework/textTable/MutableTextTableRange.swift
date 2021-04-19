//
//  TextTableRange.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

public protocol MutableTextTableRange:TextTableRange,MutableAttributedStringRange
where Element:MutableTextTableBlockRange{
    var table:NSTextTable{get}
    init(table:NSTextTable,range:NSRange,fromMut:NSMutableAttributedString)
}



public extension MutableTextTableRange{
    public init(table:NSTextTable,
                range: NSRange,
                from src: NSAttributedString) {
        let mut = src.mutableCopy() as! NSMutableAttributedString
        self.init(table:table,range:range,fromMut:mut)
    }
    public init(table:NSTextTable,fromMut src:NSMutableAttributedString,at index:Int){
        self.init(table:table,range:src.range(of: table, at: index),fromMut:src)
    }
    
    public func mutCell(at index:Int)->Element?{
        guard let t = str.textBlock(for: table, at: index) else{
            return nil
        }
        return Element(block: t, fromMut: mutablestr, at: index)
    }
    func lastCell()->Element?{
        return mutCell(at: top)
    }
}


public extension MutableTextTableRange{
    public func makeNext(rowSpan:Int=1,colSpan:Int=1) -> NSTextTableBlock{
        let last = lastCell()!
        return make(row: nextRow(last),
                    column: nextColumn(last),
                    rowSpan:rowSpan,
                    colSpan:colSpan)
    }
    
    public func make(row:Int,column:Int,rowSpan:Int=1,colSpan:Int=1)->NSTextTableBlock{
        return NSTextTableBlock(table: table,
                                startingRow: row,
                                rowSpan: rowSpan,
                                startingColumn: column,
                                columnSpan: colSpan)
        
    }
    public func make(cell:String,block:NSTextTableBlock)->NSMutableAttributedString{
        let par = NSMutableParagraphStyle()
        par.textBlocks = [block]
        let attrs = [NSAttributedStringKey.paragraphStyle:par]
        return NSMutableAttributedString(string:cell+"\n",attributes:attrs)
    }
}
public extension MutableTextTableRange{
    
    public func append(cell:String,rowSpan:Int=1,colSpan:Int=1) {
        let next = makeNext(rowSpan: rowSpan, colSpan: colSpan)
        insert(cell:cell,block:next,at:range.upperBound)
    }
    public func insert(cell:String,row:Int,column:Int,rowSpan:Int=1,colSpan:Int=1,at index:Int) {
        let b = make(row: row,
                     column: column,
                     rowSpan: rowSpan,
                     colSpan: colSpan)
        insert(cell: cell, block: b,at:index)
        
    }
    public func insert(cell:String,block:NSTextTableBlock,at index:Int){
        let str = make(cell: cell,block:block)
        mutablestr.insert(str, at:index)
    }
    
}
public extension MutableTextTableRange{
//    public func moveCell(
//        atRow:Int,
//        atCol:Int,
//        toRow:Int,
//        toCol:Int,
//        newRowSpan:Int?=nil,
//        newColSpan:Int?=nil)
//    {
//        guard let c = cell(row: atRow, column: atCol) else{
//            return
//        }
//        let newRS = newRowSpan ?? c.rowSpan
//        let newCS = newColSpan ?? c.columnSpan
//        let newPos = make(row: toRow, column: toCol, rowSpan: newRS, colSpan: newCS)
//        c.set(block: newPos)
//    }
//    public func duplicate(row:Int){
//        let cellRow = cells(inRow: row)
//        let rn = cellRow.totalRange
//        let copy = mutablestr.attributedSubstring(from: rn)
//        
//        for c in self where c.row >= row{
//            let new = make(row:c.row+1,column:c.column, rowSpan: c.rowSpan, colSpan: c.columnSpan)
//            c.set(block: new)
//        }
//        mutablestr.insert(copy, at: rn.lowerBound)
//    }
}

public extension MutableTextTableRange
where Iterator:MutableTextTableCellRangeIterator<Self>{
    public func makeIterator() -> MutableTextTableCellRangeIterator<Self> {
        return MutableTextTableCellRangeIterator<Self>(table: self)
    }
}
