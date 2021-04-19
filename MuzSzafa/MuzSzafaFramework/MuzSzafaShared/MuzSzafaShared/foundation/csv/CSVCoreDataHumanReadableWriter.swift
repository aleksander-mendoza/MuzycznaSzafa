//
//  CSVCoreDataHumanReadableWriter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 07/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public protocol CSVCoreDataHumanReadableWriter:CSVCoreDataWriter{
    
}

public extension CSVCoreDataHumanReadableWriter{
    func printNext(headerFor attrs: [CoreDataAttr]) throws {
        try printNext(row: attrs.stringify())
    }
}

open class CSVCoreDataHumanReadableWriterBasic:CSVCoreDataHumanReadableWriter{
    public var stream: OutputStream
    
    public var cellsInRow: Int = 0
    
    public required init(stream: OutputStream) {
        self.stream = stream
    }
    
    
}
