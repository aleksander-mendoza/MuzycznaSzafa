//
//  UIView.swift
//  MuzSzafaFramework
//
//  Created by Alagris on 16/02/2019.
//  Copyright © 2019 alagris. All rights reserved.
//

import Foundation

extension UIView {
	func findViewController() -> UIViewController? {
		if let nextResponder = self.next as? UIViewController {
			return nextResponder
		} else if let nextResponder = self.next as? UIView {
			return nextResponder.findViewController()
		} else {
			return nil
		}
	}
}
