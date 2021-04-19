//
//  PrefGeneralViewController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 15/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaMacFramework
import MuzSzafaShared



class PrefGeneralViewController: NSViewController {

    @IBOutlet weak var properties: PropertyTable!{
        didSet{
            properties.setLocalizedTitle(title: "Settings")
            properties.entries = UserDefaultsPropertyEntry.generateSettings()
        }
    }
    
}
