//
//  Box.swift
//  MuzSzafaShared
//
//  Created by Alagris on 15/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import Foundation
open class Box<T> {
	open var value: T
	
	public init(_ value: T) {
		self.value = value
	}
}
