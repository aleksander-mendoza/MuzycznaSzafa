//
//  UITableView.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 14/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import Foundation

public extension UITableView{
	public func registerNib(_ nibName:String,_ forCellReuseIdentifier:String){
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: nibName, bundle: bundle)
		register(nib, forCellReuseIdentifier: forCellReuseIdentifier)
	}
}
