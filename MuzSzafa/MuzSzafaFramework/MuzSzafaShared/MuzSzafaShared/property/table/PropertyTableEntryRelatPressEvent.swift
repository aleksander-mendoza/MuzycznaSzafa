//
//  PropertyTableEntryRelatPressEvent.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/08/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
import CoreData
public class PropertyTableEntryRelatPressEvent: PropertyTableEntryMOSelectEvent {
	public let relat:CoreDataRelatEntry?
	public init(mo: NSManagedObject?,relat:CoreDataRelatEntry?) {
		self.relat = relat
		super.init(mo: mo)
	}
}
