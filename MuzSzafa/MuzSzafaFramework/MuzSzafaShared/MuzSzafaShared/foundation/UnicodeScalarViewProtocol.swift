//
//  UnicodeScalarViewProtocol.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public protocol UnicodeScalarViewProtocol{
	
	typealias Index = String.Index
	associatedtype Iterator : UnicodeScalarIterator

	func makeIterator()->Iterator
	
	subscript(_ i:Index)->Unicode.Scalar { get }
	subscript(_ i:Range<Index>)->Substring { get }
	
	var lastIndex:Index? { get }
	var firstIndex:Index? { get }
	func index(after i: Index)->Index
	
}
