//
//  CoreDataEntityExports.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData

///////////////////
// export CSV
///////////////////
public extension CoreDataEntity{
   
    func exportCSV(stream:OutputStream,humanReadable:Bool=true) throws{
        if attrs.isEmpty{
            return
        }
        if !humanReadable{
            guard let name = name else{
                throw CSVException.WritingFail("Entity name is nil")
            }
			let length = self.count()
            guard stream.write(str: name) >= 0 &&
            stream.write(str: ",") >= 0 &&
            stream.write(int: length) >= 0 &&
            stream.write(str: "\n") >= 0 else {
                throw CSVException.WritingFail("Could not write to file")
            }
        }
        
        let writer = makeCSVWriter(to: stream, humanReadable: humanReadable)
        try writer.printNextEnt()
    }
    
}


///////////////////
// import archive
///////////////////

//public extension CoreDataEntity{
//    public func importArchive(records:String) throws{
//        let reader = CSVCoreDataReader(data: records)
//        try reader.loadNextRowAsHeader(for: self)
//        reader.loadTillEmptyRow()
//    }
//}

