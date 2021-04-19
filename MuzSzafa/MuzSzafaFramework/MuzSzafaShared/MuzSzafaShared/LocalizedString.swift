//
//  LocalizedString.swift
//  MuzSzafaShared
//
//  Created by Alagris on 03/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public func getLocalizedString(for key:String)->String{
    let bundle = SharedBundle.get()
//    print(NSLocale.preferredLanguages)
    return NSLocalizedString(key, tableName: nil, bundle: bundle, comment: "")
}
