//
//  CSVCoreDataWriter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 07/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public protocol CSVCoreDataWriter:CSVWriter{
    func printNext(cell attr: CoreDataAttr,with mo:NSManagedObject) throws
    func printNext(row attrs:[CoreDataAttr],with mo:NSManagedObject) throws
    func printNext(rows ent:CoreDataEntity,with attrs:[CoreDataAttr]) throws
    func printNext(headerFor attrs:[CoreDataAttr]) throws
}
public extension CSVCoreDataWriter{
    func printNext(cell attr: CoreDataAttr,with mo:NSManagedObject) throws{
        try printNext(cell: Self.serialize(cell: attr, with: mo))
    }
    func printNext(row attrs:[CoreDataAttr],with mo:NSManagedObject) throws{
        let seq = attrs.converted(){Self.serialize(cell: $0, with: mo)}
        try printNext(row: seq)
    }
    func printNext(rows ent:CoreDataEntity,with attrs:[CoreDataAttr]) throws{
        guard let mos = ent.fetch() else{
            throw CSVException.WritingFail("Could not fetch records for writing")
        }
        for mo in mos{
            try printNext(row: attrs, with: mo)
        }
    }
    func printNext(headerFor attrs:[CoreDataAttr]) throws{
        try printNext(row: attrs.serialize())
    }
    static func serialize(cell attr: CoreDataAttr,with mo:NSManagedObject) -> String{
        if let val = attr.get(from: mo){
            let str = attr.serializer.serialize(any: val)
            return str
        }
        return ""
    }
}


open class CSVCoreDataWriterBasic:CSVCoreDataWriter{
    public var stream: OutputStream
    
    public var cellsInRow: Int = 0
    
    public required init(stream: OutputStream) {
        self.stream = stream
    }
    
    
}
