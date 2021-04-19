//
//  TextTableRange.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

public protocol TextTableRange:AttributedStringRange,Sequence
where Element:TextTableBlockRange{
    var table:NSTextTable{get}
    init(table:NSTextTable,range:NSRange,from:NSAttributedString)
}



public extension TextTableRange{
    public init(table:NSTextTable,from src:NSAttributedString,at index:Int){
        self.init(table:table,range:src.range(of: table, at: index),from:src)
    }
    
    public func cell(at index:Int)->Element?{
        guard let t = str.textBlock(for: table, at: index) else{
            return nil
        }
        return Element(block: t, from: str, at: index)
    }
    public func cell(row:Int,column:Int)->Element?{
        for cell in self where cell.contains(row: row, column: column){
            return cell
        }
        return nil
    }
    public func cells(inRow r:Int)->[Element]{
        var arr = [Element]()
        for cell in self where cell.contains(row: r){
            arr.append(cell)
        }
        return arr
    }
}



public extension TextTableRange{
    var top:Int{
        get{
            return Swift.max(range.lowerBound,range.upperBound - 1)
        }
    }
    func lastCell()->Element?{
        return cell(at: top)
    }
    public func nextCellRow(row:Int,column:Int)->Int{
        let out = (column+1) >= table.numberOfColumns ? row + 1 : row
        return out
    }
    public func nextCellColumn(row:Int,column:Int)->Int{
        let out = (column+1) % table.numberOfColumns
        return out
    }
    public func nextRow<T>(_ cell:T)->Int where T:TextTableBlockRange{
        return nextCellRow(row: cell.row,
                           column: cell.column)
    }
    public func nextColumn<T>(_ cell:T)->Int where T:TextTableBlockRange{
        return nextCellColumn(row: cell.row,
                              column: cell.column)
    }
}

public extension TextTableRange where Iterator:TextTableCellRangeIterator<Self>{
    public func makeIterator() -> TextTableCellRangeIterator<Self> {
        return TextTableCellRangeIterator<Self>(table: self)
    }
}
