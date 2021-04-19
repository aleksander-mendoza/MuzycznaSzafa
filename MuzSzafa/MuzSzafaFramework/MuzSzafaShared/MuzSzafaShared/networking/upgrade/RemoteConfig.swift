//
//  RemoteConfig.swift
//  MuzSzafaShared
//
//  Created by Alagris on 02/07/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
open class RemoteConfig{
    open static let CONFIG_URL = URL(string: "https://dl.dropboxusercontent.com/s/g7t31j3983sor61/mock?dl=0")!
    
    
    public let version:Int
    public let subversion:Int
    public let snapshot:Int
    
    public var fullVersion:String{
        get{
            return "\(version).\(subversion).\(snapshot)"
        }
    }
    /**returns -1, 0 or 1 if remote version is earlier, equal or later than given other version*/
    public func compareTo(version:String)->Int{
        let number = version.components(separatedBy: .whitespaces)[0]
        let parts = number.split(separator: ".")
        let ver2 = Int(parts[0])!
        if self.version < ver2{
            return -1;
        }else if self.version > ver2{
            return 1;
        }
        let subver2 = Int(parts[1])!
        if self.subversion < subver2{
            return -1;
        }else if self.subversion > subver2{
            return 1;
        }
        let snapshot2 = Int(parts[2])!
        if self.snapshot < snapshot2{
            return -1;
        }else if self.snapshot > snapshot2{
            return 1;
        }
        return 0
    }
    public let osxURL:URL?
    public let iosURL:URL?
    
    public init?(){
        do{
            let d = try Data(contentsOf: RemoteConfig.CONFIG_URL)
            let json = try JSONSerialization.jsonObject(with: d) as! [String:Any]
            let ver = json["version"] as! String
            let verParts =  ver.split(separator: ".").map(){Int($0)!}
            version = verParts[0]
            subversion = verParts[1]
            snapshot = verParts[2]
            osxURL = URL(string: json["osx_url"] as! String)
            iosURL = URL(string: json["ios_url"] as! String)
        }catch{
            print(error)
            return nil
        }
    }
}

