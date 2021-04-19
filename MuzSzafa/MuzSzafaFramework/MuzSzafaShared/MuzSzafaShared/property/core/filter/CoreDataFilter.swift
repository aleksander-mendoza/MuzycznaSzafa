//
//  CoreDataFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 13/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData
public protocol CoreDataFilter:class {
    var attr:CoreDataAttr{get}
    var pred:SafePredicate.Node{get}
    var isEnabled:Bool{get set}
	init(parent: CoreDataAttr)
    subscript(at:Int)->Any?{get set}
}

internal func concatenate(filters:[CoreDataFilter])->SafePredicate.Node?{
	let iter = filters.makeIterator()
	guard var sum:SafePredicate.Node = iter.first(where:{$0.isEnabled})?.pred else{
		return nil
	}
    for filter in iter where filter.isEnabled{
		sum = sum.and(filter.pred)
    }
    return sum
}
