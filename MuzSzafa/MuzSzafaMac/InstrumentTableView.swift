//
//  InstrumentTableView.swift
//  MuzSzafaMac
//
//  Created by Alagris on 06/10/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import MuzSzafaShared
import MuzSzafaMacFramework

open class InstrumentTableView: EntitiesTableView{
	open override func prepare(cell: BasicTableCell,mo:NSManagedObject?) {
		if let inst =  Instrument.cast(mo), inst.available{
			cell.textField?.textColor = NSColor.black
		} else {
			cell.textField?.textColor = NSColor.red
		}
	}
}


