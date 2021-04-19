//
//  UnicodeScalarSubstringIterator.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public class UnicodeScalarSubstringIterator:UnicodeScalarIterator{
	private var iterator:IndexingIterator<DefaultIndices<String.UnicodeScalarView>>
	init(_ str:Substring.UnicodeScalarView) {
		self.iterator = str.indices.makeIterator()
	}
	
	public func next() -> String.Index? {
		return iterator.next()
	}
}
