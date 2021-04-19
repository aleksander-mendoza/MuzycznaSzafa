//
//  String.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 16/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Cocoa
public extension String{
    func convertHtml() -> NSAttributedString?{
        guard let data = data(using: .utf8) else { return nil }
        return NSAttributedString(html: data, options: [:], documentAttributes: nil)
    }
	func heightWithConstrainedWidth(width: CGFloat, font: NSFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox =
			self.boundingRect(with: constraintRect,
						 options: [.usesLineFragmentOrigin,.usesFontLeading],
						 attributes: [NSAttributedStringKey.font: font],
						 context: nil)
		return boundingBox.height
	}
}
