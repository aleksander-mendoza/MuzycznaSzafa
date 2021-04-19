//
//  URL.swift
//  MuzSzafaShared
//
//  Created by Alagris on 13/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension URL{
    
    init(file:String,
         for dir: FileManager.SearchPathDirectory = .documentDirectory,
         in mask: FileManager.SearchPathDomainMask = .userDomainMask) throws{
        guard let url = FileManager.default.urls(for: dir,in: mask).first else{
            throw URLError(.badURL)
        }
        try self.init(resolvingAliasFileAt: url)
    }
    
    var fileName:String{
        get{
            let fileNameWithExt = self.lastPathComponent
            guard let dot = fileNameWithExt.lastIndex(of: ".") else{
                return fileNameWithExt
            }
            return String(fileNameWithExt[..<dot])
        }
    }
    var executable:Bool{
        get{
            return FileManager.default.isExecutableFile(atPath: path)
        }
    }
    func setExecutable(owner:Bool,group:Bool=false,others:Bool=false) throws{
        let attrs = try FileManager.default.attributesOfItem(atPath: path)
        let permissions = attrs[FileAttributeKey.posixPermissions] as! NSNumber
        
        func maskPart(_ bool:Bool)->Int32{
            let maskPartOn:Int32 = 0b001
            let maskPartOff:Int32 = 0b000
            return bool ? maskPartOn : maskPartOff
        }
        let mask = (maskPart(owner)<<3+maskPart(group))<<3+maskPart(others)
        let newPermissions = permissions.int32Value & ~mask + mask
        let newAttrs:[FileAttributeKey : Any] = [
            FileAttributeKey.posixPermissions:NSNumber(value:newPermissions)
        ]
        try FileManager.default.setAttributes(newAttrs, ofItemAtPath: path)
    }
    func delete(){
        do{
            try FileManager.default.removeItem(at: self)
        }catch let e{
            print(e.localizedDescription)
        }
    }
}
