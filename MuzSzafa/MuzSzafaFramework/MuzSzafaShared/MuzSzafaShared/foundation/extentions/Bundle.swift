//
//  Bundle.swift
//  MuzSzafaShared
//
//  Created by Alagris on 15/08/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension Bundle{
    var versionString:String?{
        get{
            let any = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            return any as! String?
        }
    }
}
