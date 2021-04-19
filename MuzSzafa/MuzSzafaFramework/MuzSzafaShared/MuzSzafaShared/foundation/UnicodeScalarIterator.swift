//
//  UnicodeScalarIterator.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public protocol UnicodeScalarIterator{
	func next()->String.Index?
}
