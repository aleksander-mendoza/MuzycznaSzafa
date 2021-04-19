//
//  CSVReader.swift
//  MuzSzafaShared
//
//  Created by Alagris on 12/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class CSVReader{
	
	private var iterator:StringIterator<UnicodeScalarViewString>
	private var isNextRowExpected = false
	public var separator:UnicodeScalar = ","
	
	public init(data: String) {
		iterator = StringIterator(data: UnicodeScalarViewString(data))
		isNextRowExpected = false
	}
	public func nextRow()->CSVRow?{
		var isInsideQuotes = false
		guard let beginIndex:String.UnicodeScalarView.Index = iterator.current else{
			if isNextRowExpected{
				isNextRowExpected = false
				return CSVRow("", sep:separator)
			}else{
				return nil
			}
		}
		isNextRowExpected = false
		var endIndex:String.UnicodeScalarView.Index = iterator.afterLastIndex!
		outter:while iterator.hasCurrent{
			if isInsideQuotes{
				
				if iterator.currentCharacter == "\""{
					if iterator.peekNextCharacter == "\""{
						iterator.next()
					}else{
						isInsideQuotes = false
					}
				}
				
			}else{
				switch iterator.currentCharacter{
				case "\"":
					isInsideQuotes = true;
				case "\r":
					fallthrough
				case "\n":
					endIndex = iterator.current!
					isNextRowExpected = true
					if (iterator.currentCharacter == "\r" && iterator.peekNextCharacter == "\n" ) || (iterator.currentCharacter == "\n" && iterator.peekNextCharacter == "\r" ){
						iterator.next()
					}
					iterator.next()
					break outter
				default:
					break
				}
			}
			iterator.next()
		}
		return CSVRow(iterator.data[beginIndex..<endIndex], sep:separator)
	}
}



public extension CSVReader{
	
	
	convenience init(url: URL,encoding:String.Encoding = .utf8) throws{
		self.init(data:try String(contentsOf: url,encoding: encoding))
	}
	convenience init(url: URL)throws{
		try self.init(url: url, encoding: .utf8)
	}
	
	convenience init(file: String,dir:URL,encoding:String.Encoding = .utf8)throws{
		try self.init(url: dir.appendingPathComponent(file), encoding: encoding)
	}
	
	public func rewind(){
		iterator.rewind()
		isNextRowExpected = false
	}

	/**Returns false if there was no row to skip*/
	@discardableResult
	func skipRow()->Bool{
		return nextRow() != nil
	}
	func skipNRows(n:Int){
		for _ in 0..<n{
			guard skipRow() else{break}
		}
	}
	func nextNonEmptyNRowsAsArr(n:Int)->[[String]]?{
		var array = [[String]]()
		guard n>0 else {return nil}
		var i = 0
		while let next = nextRowAsArr(){
			if i>=n {break}
			if !next.isEmpty{
				array.append(next)
			}
			i += 1
		}
		if array.isEmpty{
			return nil
		}
		return array
	}
	func nextRowAsArr()->[String]?{
		var array = [String]()
		guard let row = nextRow() else{return nil}
		while let cell = row.nextCell(){
			array.append(cell)
		}
		return array
	}
	func nextNRowsAsArr(n:Int)->[[String]]?{
		var array = [[String]]()
		for _ in 0..<n{
			if let next = nextRowAsArr(){
				array.append(next)
			}else{
				break
			}
		}
		if array.isEmpty{
			return nil
		}
		return array
	}
}
