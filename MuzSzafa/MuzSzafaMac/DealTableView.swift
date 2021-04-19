//
//  InstrumentTableView.swift
//  MuzSzafaMac
//
//  Created by Alagris on 06/10/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import MuzSzafaShared
import MuzSzafaMacFramework

open class DealTableView: EntitiesTableView{
	open override func prepare(cell: BasicTableCell,mo:NSManagedObject?) {
		if let deal =  Deal.cast(mo){
			switch deal.status{
			case 1:
				cell.textField?.textColor = NSColor.systemGreen
			case 2:
				cell.textField?.textColor = NSColor.systemBlue
			case 3:
				cell.textField?.textColor = NSColor.systemRed
			default:
				cell.textField?.textColor = NSColor.black
			}
		}else{
			assertionFailure()
		}
	}
}


