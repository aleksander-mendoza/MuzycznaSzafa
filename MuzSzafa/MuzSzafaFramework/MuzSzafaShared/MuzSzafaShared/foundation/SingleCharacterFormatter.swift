//
//  SingleCharacterFormatter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 14/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class SingleCharacterFormatter:Formatter{
	
	open override func string(for obj: Any?) -> String? {
		if let c = (obj as? String?)??.last{
			return String(c)
		}
		return nil
	}
	open override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
		obj?.pointee = string.last as AnyObject?
		return true
	}
}
