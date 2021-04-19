//
//  CSVRow.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public class CSVRow{
	private let substr:Substring
	private let iterator:StringIterator<UnicodeScalarViewSubstring>
	private var isNextCellExpected = false
	private let separator:UnicodeScalar;
	public init(_ substr:Substring, sep:UnicodeScalar=",") {
		self.substr = substr
		separator = sep
		iterator = StringIterator(data: UnicodeScalarViewSubstring(substr))
	}
	
	private func nextRawCell()->Substring?{
		var isInsideQuotes = false
		guard let beginIndex:String.UnicodeScalarView.Index = iterator.current else{
			if isNextCellExpected{
				isNextCellExpected = false
				return ""
			}else{
				return nil
			}
		}
		var endIndex:String.UnicodeScalarView.Index = iterator.afterLastIndex!
		isNextCellExpected = false
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
				case separator:
					isNextCellExpected = true
					endIndex = iterator.current!
					iterator.next()
					break outter
				default:
					break
				}
			}
			iterator.next()
		}
		
		return Substring(iterator.data[beginIndex..<endIndex])
	}
	
	public func nextCell()->String?{
		guard let raw = nextRawCell() else{
			return nil
		}
		var cell = String()
		cell.reserveCapacity(raw.count)
		var isInsideQuotes = false
		var wasPreviousQuote = false
		for char in raw{
			if isInsideQuotes{
				if char == "\""{
					if wasPreviousQuote{
						wasPreviousQuote = false
					}else{
						wasPreviousQuote = true
						continue
					}
				}
			}else if char == "\""{
				isInsideQuotes = true
				continue
			}
			cell.append(char)
		}
		return cell
	}
}
