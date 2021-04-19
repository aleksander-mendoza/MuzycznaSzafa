//
//  UIView.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 16/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import MuzSzafaShared
public extension UIViewController{
	func dialogOK(msg:String,title:String=""){
		let alertController = UIAlertController(
			title: getLocalizedString(for: title),
			message: getLocalizedString(for: msg),
			preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		
		self.present(alertController, animated: true, completion: nil)
	}
}
