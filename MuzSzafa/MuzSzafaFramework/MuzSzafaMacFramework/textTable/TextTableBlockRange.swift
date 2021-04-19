//
//  TextTableBlockRange.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Cocoa
public protocol TextTableBlockRange:AttributedStringRange,NSCopying{
    var block:NSTextTableBlock{get}
    init(block:NSTextTableBlock,range:NSRange,from:NSAttributedString)
}

public extension TextTableBlockRange{
    init(block:NSTextTableBlock,from src:NSAttributedString,at index:Int){
        self.init(block:block,range:src.range(of: block, at: index),from:src)
    }
    
    var row:Int{
        get{
            return block.startingRow
        }
    }
    var column:Int{
        get{
            return block.startingColumn
        }
    }
    var rowSpan:Int{
        get{
            return block.rowSpan
        }
    }
    var columnSpan:Int{
        get{
            return block.columnSpan
        }
    }
    func contains(row r:Int,column c:Int)->Bool{
        return contains(row:r) && contains(column: c)
    }
    func contains(row r:Int)->Bool{
        return row <= r && r < row + rowSpan
    }
    func contains(column c:Int)->Bool{
        return column <= c && c < column + columnSpan
    }
}


