//
//  InstrumentTableView.swift
//  MuzSzafaMac
//
//  Created by Alagris on 06/10/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import MuzSzafaShared
import MuzSzafaMacFramework

open class ClientTableView: EntitiesTableView{
	open override func prepare(cell: BasicTableCell,mo:NSManagedObject?) {
		if let cl = Client.cast(mo), cl.hasActiveDealWithoutDate(cntx: CoreContext.shared){
			cell.textField?.textColor = NSColor.black
		} else {
			cell.textField?.textColor = NSColor.red
		}
	}
}


