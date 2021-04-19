//
//  NSRect.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 25/09/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public extension NSRect{
	func scale(_ scale:CGFloat)->NSRect{
		let w = width * scale
		let h = height * scale
		return NSRect(x:minX,y:minY,width:w,height:h)
	}
}
