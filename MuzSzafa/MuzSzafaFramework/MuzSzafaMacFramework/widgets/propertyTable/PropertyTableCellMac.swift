//
//  PropertyCellResponder.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 10/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
import MuzSzafaShared
public protocol PropertyTableCellMac:PropertyTableCell{
    var firstCellResponder:NSView?{get}
	var helpPopoverRequestDelegate:HelpPopoverRequestDelegate?{get set}
	var help: NSButton!{get set}
}
public protocol RelatPropertyTableCellMac: PropertyTableCellMac, RelatPropertyTableCell{
}
public extension PropertyTableCellMac{
    var firstCellResponder: NSView?{
        get{
            return nil
        }
    }
	func requestHelp(sender:Any){
		if let help = property?.userHelp{
			helpPopoverRequestDelegate?.helpPopoverRequest(for: help,sender:sender)
		}
	}
	func propertyTableCell(newUserHelp: CoreDataAttrHelp?) {
		let hasInfo = newUserHelp?.userHelpInfo != nil
		help.isHidden = !hasInfo
	}
}
