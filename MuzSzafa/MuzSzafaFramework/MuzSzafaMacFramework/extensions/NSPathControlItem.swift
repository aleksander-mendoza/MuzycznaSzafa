//
//  NSPathControlItem.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 30/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public extension NSPathControlItem{
    public convenience init(title:String,img:NSImage?=nil){
        self.init()
        self.image = img
        self.title = title
    }
    public convenience init(title:NSAttributedString,img:NSImage?=nil){
        self.init()
        self.image = img
        self.attributedTitle = title
    }
}
