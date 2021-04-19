//
//  CoreDataCacheExports.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

///////////////////
// import archive
///////////////////
public extension CoreDataCache{
    public func importArchive(file:String,dir:URL) throws{
        try importArchive(file: dir.appendingPathComponent(file))
    }
    public func importArchive(file:URL) throws{
        let data = try String(contentsOf: file, encoding: .utf8)
        try importArchive(str: data)
    }
    func importArchive(str data:String)throws{
        let reader = CSVCoreDataReader(data: data)
        while let row = reader.nextRowAsArr(){
			if row.isEmpty{continue}
            let entStr = row[0]
            guard let rowsCount = Int(row[1]) else{
                throw CSVException.ReadingFail("Wrong format! Number of rows missing")
            }
            if let ent = find(entStr){
                try reader.loadNextRowAsHeader(for:ent)
                try reader.loadNextNRows(n: rowsCount)
            }else{
                reader.skipNRows(n:rowsCount+1)
            }
        }
    }
}


///////////////////
// export archive
///////////////////
public extension CoreDataCache{
    func exportArchive(stream:OutputStream) throws{
        for ent in ents{
            try ent.exportCSV(stream: stream,humanReadable:false)
        }
    }
}
