//
//  SubstringIterator.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public class StringIterator<View:UnicodeScalarViewProtocol>{
	private typealias Index = View.Index
	private typealias IndicesIterator = View.Iterator
	public private(set) var data:View
	private var previousIndex:Index?
	private var currentIndex:Index?
	private var nextIndex:Index?
	private var iterator:IndicesIterator!
	
	
	public init(data: View) {
		self.data = data
		rewind()
	}
}

public extension StringIterator{
	
	var hasNext:Bool{
		get{
			return nextIndex != nil
		}
	}
	
	var hasCurrent:Bool{
		get{
			return currentIndex != nil
		}
	}
	
	@discardableResult
	func next()->String.UnicodeScalarView.Index?{
		previousIndex = currentIndex
		currentIndex = nextIndex
		nextIndex = iterator.next()
		return currentIndex
	}
	
	
	var current:String.UnicodeScalarView.Index?{
		get{
			return currentIndex
		}
	}
	
	var previous:String.UnicodeScalarView.Index?{
		get{
			return previousIndex
		}
	}
	
	var currentCharacter:Unicode.Scalar?{
		get{
			if let i = currentIndex{
				return data[i]
			}
			return nil
		}
	}
	
	var previousCharacter:Unicode.Scalar?{
		get{
			if let i = previousIndex{
				return data[i]
			}
			return nil
		}
	}
	
	var peekNextCharacter:Unicode.Scalar?{
		get{
			if let i = nextIndex{
				return data[i]
			}
			return nil
		}
	}
	
	func rewind(){
		iterator = data.makeIterator()
		next()
		next()
		previousIndex = nil
	}
	
	func skipTill(scalar:Unicode.Scalar){
		while hasNext{
			next()
			if currentCharacter == scalar{
				return
			}
		}
	}
	
	var lastIndex:String.UnicodeScalarView.Index?{
		get{
			return data.lastIndex
		}
	}
	
	var afterLastIndex:String.UnicodeScalarView.Index?{
		get{
			if let last = lastIndex{
				return data.index(after: last)
			}else{
				return nil
			}
		}
	}
}
