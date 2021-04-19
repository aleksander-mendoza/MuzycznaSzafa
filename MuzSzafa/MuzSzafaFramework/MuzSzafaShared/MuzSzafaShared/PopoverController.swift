//
//  PopoverController.swift
//  MuzSzafaShared
//
//  Created by Alagris on 10/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


public protocol PopoverController {
    var parentResource:Reloadable?{get set}
    func fail()
    func success()
    func cancel()
}
