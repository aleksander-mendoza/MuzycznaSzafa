//
//  DisplayTableViewCell.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared

class EntTableSelectionCell: NSTableCellView {
    
    var onChangeImpl:((Bool)->Void)?
    @IBAction func checked(_ sender: NSButton) {
        onChangeImpl?(sender.state == .on)
    }
    
}
