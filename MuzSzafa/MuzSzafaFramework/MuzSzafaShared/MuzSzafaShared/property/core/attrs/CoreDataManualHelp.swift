//
//  CoreDataManualHelp.swift
//  MuzSzafaShared
//
//  Created by Alagris on 21/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
open class CoreDataManualHelp:CoreDataAttrHelp{
	public var userHelpInfo: String?

	public init() {
	}

	public init(_ userHelpInfo: String?) {
		if let info = userHelpInfo{
			self.userHelpInfo = getLocalizedString(for: info)
		}
	}
}
