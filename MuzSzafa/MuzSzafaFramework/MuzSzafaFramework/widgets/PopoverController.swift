//
//  PopoverController.swift
//  MuzSzafa
//
//  Created by Alagris on 17/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import UIKit
import MuzSzafaShared

public extension PopoverController where Self: UIViewController{
    public func cancel(){
        dismiss(animated: true, completion: nil)
    }
    public func success(){
        if let pr = parentResource{
            pr.reloadData()
        }
        CoreContext.shared.save()
        dismiss(animated: true, completion: nil)
    }
    
}
