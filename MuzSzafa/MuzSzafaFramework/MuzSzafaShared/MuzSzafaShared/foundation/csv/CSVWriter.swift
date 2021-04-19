//
//  CSVWriter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 07/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public protocol CSVWriter:class{
    var stream:OutputStream{get}
    var cellsInRow:Int{set get}
    init(stream:OutputStream)
    func printNext() throws
    func printNext(cell str:String) throws
    func printNextRow() throws
    func printNext<T:Sequence>(row strs:T) throws where T.Element == String
}




public extension CSVWriter{
    fileprivate static var errMsg:String{get{return "Could not write to stream"}}
    private func incrementIfOk(_ writtenBytes:Int) throws{
        if writtenBytes < 0 {
            throw CSVException.WritingFail(Self.errMsg)
        }
        cellsInRow += 1
    }
    func printNext() throws{
        try incrementIfOk(stream.write(str: ","))
    }
    
    func printNext(cell str:String) throws{
        if cellsInRow > 0{
            try printNext()
        }
        let escaped = Self.escape(str:str)
        let writtenBytes = stream.write(str: escaped)
        try incrementIfOk(writtenBytes)
    }
    func printNextRow() throws{
        if stream.write(str: "\n") < 0 {
            throw CSVException.WritingFail(Self.errMsg)
        }
        cellsInRow = 0
    }
    
    func printNext<T:Sequence>(row strs:T) throws where T.Element == String{
        for str in strs{
            try printNext(cell:str)
        }
        try printNextRow()
    }
    
    
    static func escape(str:String)->String{
        let quote = "\""
        
        if str.contains(quote){
            let s = str.replacingOccurrences(of: quote, with: quote+quote)
            return quote+s+quote
        }
        if str.contains(",") || str.contains("\n"){
            return quote+str+quote
        }
        return str
    }
}

