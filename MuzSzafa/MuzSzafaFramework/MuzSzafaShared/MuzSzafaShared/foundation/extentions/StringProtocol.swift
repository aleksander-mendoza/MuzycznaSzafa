//
//  StringProtocol.swift
//  MuzSzafaShared
//
//  Created by Alagris on 15/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension StringProtocol{
	func escape(char illegalChar:UnicodeScalar, with escapeChar:UnicodeScalar)->String{
		var escaped = [UnicodeScalar]()
		for scalar in unicodeScalars{
			if scalar == illegalChar || scalar == escapeChar{
				escaped += escapeChar
			}
			escaped += scalar
		}
		return String(String.UnicodeScalarView(escaped))
	}
	
	func stripEscapes(_ escaper:UnicodeScalar)->String{
		var escaped = [UnicodeScalar]()
		var isEscaped = false
		for scalar in unicodeScalars{
			if isEscaped{
				isEscaped = false
			}else if scalar == escaper{
				isEscaped = true
				continue
			}
			escaped += scalar
		}
		
		return String(String.UnicodeScalarView(escaped))
	}
	
	func split(separator:UnicodeScalar, escapeChar escaper:UnicodeScalar)->[String]{
		var substrings = [String]()
		var newSubstring = [UnicodeScalar]()
		var escaped = false
		for scalar in unicodeScalars{
			if escaped{
				escaped = false
			}else{
				if scalar == escaper{
					escaped = true
					continue
				}else if scalar == separator{
					substrings += String(String.UnicodeScalarView(newSubstring))
					newSubstring = []
					continue
				}
			}
			newSubstring += scalar
		}
		substrings += String(String.UnicodeScalarView(newSubstring))
		return substrings
	}
}
