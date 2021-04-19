//
//  ReloadableCallback.swift
//  MuzSzafaShared
//
//  Created by Alagris on 06/10/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

open class ReloadableCallback:Reloadable{
	init() {}
	
	public init(callback:@escaping (()->())) {
		self.callback = callback
	}
	var callback:(()->())?
	public func reloadData() {
		callback?()
	}
	
}
