//
//  NSAttributedString.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 20/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public extension NSAttributedString{
    
    func paragraphStyle(at index:Int)->NSParagraphStyle?{
        let key = NSAttributedStringKey.paragraphStyle
        return attribute(key, at: index) as! NSParagraphStyle?
    }
    
    func textBlocks(at index:Int)->[NSTextBlock]?{
        return paragraphStyle(at: index)?.textBlocks
    }
    func tables(at index:Int)->[NSTextTable]?{
        guard let tbs = textBlocks(at: index) else{
            return nil
        }
        var output = Set<NSTextTable>()
        for tb in tbs{
            if let t = tb as? NSTextTableBlock{
                output.insert(t.table)
            }
        }
        return Array(output)
    }
    func outterTableCell(at index:Int)->NSTextTableBlock?{
        guard let tbs = textBlocks(at: index) else{
            return nil
        }
        for tb in tbs{
            if let t = tb as? NSTextTableBlock{
                return t
            }
        }
        return nil
    }
    func outterTable(at index:Int)->NSTextTable?{
        return outterTableCell(at:index)?.table
    }
    func outterTableRange<T>(at index:Int)->T? where T:TextTableRange{
        guard let t = outterTable(at:index) else{
            return nil
        }
        return T(table: t, from: self, at: index)
    }
    var outterTables:[NSTextTable]{
        var index = 0
        let len = length
        var output:[NSTextTable] = []
        while index < len{
            if let tab = outterTable(at: index){
                output.append(tab)
                index = range(of: tab, at: index).upperBound
            }else{
                index += 1
            }
        }
        return output
    }
    func outterTableRanges<T>()->[T] where T:TextTableRange{
        var index = 0
        let len = length
        var output:[T] = []
        while index < len{
            if let tab:T = outterTableRange(at: index){
                output.append(tab)
                index = tab.range.upperBound
            }else{
                index += 1
            }
        }
        return output
    }
    func textBlock(for table:NSTextTable, at index:Int)->NSTextTableBlock?{
        guard let tbs = textBlocks(at: index) else{
            return nil
        }
        for tb in tbs{
            if let t = tb as? NSTextTableBlock{
                if t.table == table{
                    return t
                }
            }
        }
        return nil
    }
    
    func tableCells(_ table:NSTextTable,at index:Int)->[NSTextTableBlock]{
        let rn = range(of: table, at: index)
        var index = rn.lowerBound
        var cells:[NSTextTableBlock] = []
        while index < rn.upperBound{
            if let block = textBlock(for: table, at: index){
                cells.append(block)
                index = range(of: block, at: index).upperBound
            }else{
                index += 1
            }
        }
        return cells
    }
    
    
    
    func makePDF(to url:URL) {
        let printOpts: [NSPrintInfo.AttributeKey: Any] = [NSPrintInfo.AttributeKey.jobDisposition: NSPrintInfo.JobDisposition.save, NSPrintInfo.AttributeKey.jobSavingURL: url]
        let printInfo = NSPrintInfo(dictionary: printOpts)
        printInfo.horizontalPagination = NSPrintInfo.PaginationMode.autoPagination
        printInfo.verticalPagination = NSPrintInfo.PaginationMode.autoPagination
        printInfo.topMargin = 20.0
        printInfo.leftMargin = 20.0
        printInfo.rightMargin = 20.0
        printInfo.bottomMargin = 20.0
        
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 570, height: 740))
        
         let frameRect = NSRect(x: 0, y: 0, width: 570, height: 740)
         let textField = NSTextField(frame: frameRect)
         textField.attributedStringValue = self
         view.addSubview(textField)
        
         let printOperation = NSPrintOperation(view: view, printInfo: printInfo)
         printOperation.showsPrintPanel = false
         printOperation.showsProgressPanel = false
         printOperation.run()
    }

    
}
