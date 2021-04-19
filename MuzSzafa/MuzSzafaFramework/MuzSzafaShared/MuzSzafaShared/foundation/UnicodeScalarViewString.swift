//
//  UnicodeScalarViewString.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public class UnicodeScalarViewString:UnicodeScalarViewProtocol{
	private let substr:String.UnicodeScalarView
	public typealias Iterator = UnicodeScalarStringIterator
	public init(_ substr:String) {
		self.substr = substr.unicodeScalars
	}
	public func makeIterator() -> Iterator {
		return Iterator(substr)
	}
	public subscript(i: Index) -> Unicode.Scalar {
		get {
			return substr[i]
		}
	}
	public subscript(i: Range<Index>) -> Substring {
		return Substring(substr[i])
	}
	
	public var lastIndex:Index? {
		get{
			return substr.indices.last
		}
	}
	
	public var firstIndex:Index? {
		get{
			return substr.indices.first
		}
	}
	
	public func index(after i: Index)->Index{
		return substr.index(after: i)
	}
}
