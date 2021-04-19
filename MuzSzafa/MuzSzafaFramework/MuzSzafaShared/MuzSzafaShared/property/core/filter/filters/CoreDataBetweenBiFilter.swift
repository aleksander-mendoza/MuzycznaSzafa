//
//  CoreDataBetweenBiFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Foundation

public class CoreDataBetweenBiFilter:CoreDataBiFilter{
	public var value: (from: Any?, to: Any?)
	
	public var attr: CoreDataAttr
	
	public var pred: SafePredicate.Node{
		get{
			return attr.gt(value.from).and(attr.lt(value.to))
		}
	}
	
	public var isEnabled: Bool = true
	
	required public init(parent: CoreDataAttr) {
		attr = parent
	}
}
