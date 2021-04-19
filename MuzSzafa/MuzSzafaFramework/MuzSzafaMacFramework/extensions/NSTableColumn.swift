//
//  NSTableColumn.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 14/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension NSTableColumn{
    public convenience init(id:String) {
        self.init(identifier: NSUserInterfaceItemIdentifier(id))
    }
}
