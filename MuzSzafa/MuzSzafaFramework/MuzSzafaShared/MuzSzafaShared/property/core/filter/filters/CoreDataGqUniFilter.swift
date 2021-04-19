//
//  CoreDataGqUniFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

public class CoreDataGqUniFilter:CoreDataUniFilter{
	public var value: Any?
	
	public var attr: CoreDataAttr
	
	public var pred: SafePredicate.Node{
		get{
			return attr.ge(value)
		}
	}
	
	public var isEnabled: Bool = true
	
	required public init(parent: CoreDataAttr) {
		attr = parent
	}
}
