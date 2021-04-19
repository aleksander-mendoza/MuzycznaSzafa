//
//  SharedBundle.swift
//  MuzSzafaShared
//
//  Created by Alagris on 03/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public class SharedBundle{
    class func get()->Bundle{
        return Bundle(for: self)
    }
}
