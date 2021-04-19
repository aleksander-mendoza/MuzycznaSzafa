//
//  CSVCoreDataEntWriter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 07/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public extension CoreDataEntity{
    fileprivate var exportableAttrs:[CoreDataAttr]{
        get{
            return attrs
//			.filter(){
//                if let r = $0 as? CoreDataRelatEntry{
//                    return !r.isToMany
//                }
//                return true
//            }
        }
    }
    public func makeCSVWriter(to stream:OutputStream,humanReadable:Bool=false)
        -> CSVCoreDataEntWriterBasic{
            return makeCSVWriter(to: stream,
                                 with:exportableAttrs,
                                 humanReadable: humanReadable)
    }
    public func makeCSVWriter(to stream:OutputStream,
                              with attrs:[CoreDataAttr],
                              humanReadable:Bool=false)
        -> CSVCoreDataEntWriterBasic{
            
        let writer:CSVCoreDataWriter = humanReadable ?
            CSVCoreDataHumanReadableWriterBasic(stream: stream) :
            CSVCoreDataWriterBasic(stream: stream)
        let w = CSVCoreDataEntWriterBasic(writer: writer, ent: self,attrs:attrs)
        return w
    }
}

public protocol CSVCoreDataEntWriter{
    var ent:CoreDataEntity{get}
    var attrs:[CoreDataAttr]{get}
    var writer:CSVCoreDataWriter{get}
    init(writer:CSVCoreDataWriter,ent:CoreDataEntity,attrs:[CoreDataAttr])
    func printNextRow(_ mo:NSManagedObject) throws
    func printNextHeader() throws
    func printNextEnt() throws
}

public extension CSVCoreDataEntWriter{
    init(writer:CSVCoreDataWriter,ent:CoreDataEntity){
        self.init(writer:writer, ent: ent, attrs: ent.exportableAttrs)
    }
    func printNextRow(_ mo:NSManagedObject) throws {
        try writer.printNext(row: attrs, with: mo)
    }
    func printNextHeader() throws {
        try writer.printNext(headerFor: attrs)
    }
    func printNextEnt() throws {
        try printNextHeader()
        try writer.printNext(rows: ent, with: attrs)
    }

}


open class CSVCoreDataEntWriterBasic:CSVCoreDataEntWriter{
    public required init(writer: CSVCoreDataWriter, ent: CoreDataEntity, attrs: [CoreDataAttr]) {
        self.writer = writer
        self.ent = ent
        self.attrs = attrs
    }
    
    public var ent: CoreDataEntity
    
    public var attrs: [CoreDataAttr]
    
    public var writer: CSVCoreDataWriter
    
}
