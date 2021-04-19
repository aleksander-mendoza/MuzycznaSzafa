//
//  MainWindowController.swift
//  MuzSzafaMac
//
//  Created by Alagris on 13/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController,NSWindowDelegate {

    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(sender)
        return false
    }
    
}
