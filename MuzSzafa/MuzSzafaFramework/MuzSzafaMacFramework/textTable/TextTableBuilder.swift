//
//  TextTableBuilder.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 24/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

open class TextTableBuilder{
    open class Block:NSCopying{
        var block:NSTextBlock
        var str:NSMutableAttributedString
        init(block:NSTextBlock,str:NSMutableAttributedString) {
            self.block = block
            self.str = str
        }
        public func copy(with zone: NSZone? = nil) -> Any {
            let bc = block.copy() as! NSTextBlock
            let sc = NSMutableAttributedString(attributedString: str)
            return Block(block: bc, str: sc)
        }
    }
    private var grid:[[Block?]]
    private var table:NSTextTable
    public var columns:Int{
        get{
            return grid.count
        }
        set{
            table.numberOfColumns = newValue
        }
    }
    public private(set) var rows:Int = 0
    private func isValid(row:Int)->Bool{
        return 0 <= row && row < rows
    }
    private func isValid(column:Int)->Bool{
        return 0 <= column && column < columns
    }
    private func isValid(row:Int,column:Int)->Bool{
        return isValid(row: row) && isValid(column: column)
    }
    public func cellAt(row:Int,column:Int)->Block?  {
        guard isValid(row: row, column: column)  else{
            return nil
        }
        if grid[column].count < row{
            grid[column].resize(row+1, fillWith: nil)
        }
        return grid[column][row]
    }
    public func cellAt(_ val:Block?, row:Int,column:Int){
        guard isValid( column: column)  else{
            print("column (\(column)) out of bounds (\(columns))")
            return
        }
        if grid[column].count <= row{
            grid[column].resize(row+1, fillWith: nil)
        }
        if row >= rows{
            rows = row + 1
        }
        grid[column][row] = val
    }
    public func insertCell(_ val:Block?, intoRow:Int,column:Int){
        guard isValid( column: column)  else{
            print("column (\(column)) out of bounds (\(columns))")
            return
        }
        let rowsInThisColumn = grid[column].count
        if rowsInThisColumn <= intoRow{
            grid[column].resize(intoRow+1, fillWith: nil)
            grid[column][intoRow] = val
        }else{
            grid[column].insert(val, at: intoRow)
        }
        if rowsInThisColumn >= rows{
            rows = rowsInThisColumn+1
        }
        
    }
    
    
    
    public init<T>(table:T) where T:MutableTextTableRange{
        self.table = table.table
        let columns = self.table.numberOfColumns
        grid = [[Block]](repeating: [], count: columns)
        for cell in table{
            let str = cell.mutsubstr
            str.remove(textBlock: cell.block)
            let blk = cell.block.copy() as! NSTextBlock
            let block = Block(block:blk, str: str)
            for row in cell.row..<(cell.row+cell.rowSpan){
                for col in cell.column..<(cell.column+cell.columnSpan){
                    cellAt(block, row: row, column: col)
                }
            }
        }
    }
    public func contains(str:String,inRow:Int)->Bool{
        guard isValid(row: inRow) else{
            return false
        }
        for column in grid{
            if column.count <= inRow{
                continue
            }
            if column[inRow]?.str.mutableString.contains(str) ?? false{
                return true
            }
        }
        return false
    }
    public func remove(row:Int){
        guard isValid(row: row) else{
            return
        }
        for i in 0..<grid.count{
            if grid[i].count <= row{
                continue
            }
            grid[i].remove(at: row)
        }
    }
    public func duplicate(row:Int,as newRow:Int){
        guard isValid(row: row) else{
            return
        }
        for (col,column) in grid.enumerated(){
            if column.count <= row{
                continue
            }
            guard let cell = column[row] else{
                continue
            }
            let copy = cell.copy() as! Block
            insertCell(copy, intoRow: newRow, column: col)
        }
    }
    
    public var buildStr:NSMutableAttributedString{
        get{
            let out = NSMutableAttributedString()
            for row in 0..<rows{
                for col in 0..<columns{
                    let r = grid[col]
                    guard r.count > row else{
                        continue
                    }
                    guard let cell = r[row] else{
                        continue
                    }
                    let c = NSTextTableBlock(table: table, startingRow: row, rowSpan: 1, startingColumn: col, columnSpan: 1)
                    c.assing(cell.block)
                    let par = NSMutableParagraphStyle()
                    par.textBlocks = [c]
                    let copy = NSMutableAttributedString(attributedString: cell.str)
                    copy.addAttributes([NSAttributedStringKey.paragraphStyle:par], range: NSMakeRange(0, copy.length))
                    out.append(copy)
                }
            }
            return out
        }
    }
}


public extension TextTableBuilder{
    public func contains<T:Sequence>(str:T,inRow:Int)->Bool where T.Element == String{
        for s in str{
            if contains(str: s, inRow: inRow){
                return true
            }
        }
        return false
    }
    /**both parameters are inclusive*/
    public func remove(rowsFrom:Int,upto:Int){
        for _ in rowsFrom...min(rows-1,upto){
            remove(row: rowsFrom)
        }
    }
    /**both parameters are inclusive*/
    @discardableResult
    public func duplicate(rowsFrom:Int,upto:Int,into newRow:Int,times:Int=1)->Bool{
        guard rowsFrom > newRow || newRow > upto else{
            return false
        }
        guard times > 0 else{
            return true
        }
        let size = upto - rowsFrom + 1
        if newRow < rowsFrom{
            for n in 0..<times{
                for _ in (rowsFrom+n*size)...(upto+n*size){
                    duplicate(row: upto, as: newRow)
                }
            }
        }else{//newRow > upto
            for _ in 0..<times{
                for i in stride(from: upto, to: rowsFrom-1, by: -1){
                    duplicate(row: i, as: newRow)
                }
            }
        }
        return true
    }
    public func replace(str old:String,with new:String,inRow:Int){
        for column in grid{
            if column.count <= inRow{
                continue
            }
            guard let cell = column[inRow] else{
                continue
            }
            cell.str.replaceOccurrences(of: old, with: new)
        }
    }
}
