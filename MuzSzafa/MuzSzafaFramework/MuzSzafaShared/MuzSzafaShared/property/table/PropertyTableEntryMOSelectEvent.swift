//
//  PropertyTableEntryRelatPressEvent.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/08/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData
public class PropertyTableEntryMOSelectEvent:PropertyTableEntryEvent{
	public let mo:NSManagedObject?
	public init(mo:NSManagedObject?){
		self.mo = mo
	}
}
