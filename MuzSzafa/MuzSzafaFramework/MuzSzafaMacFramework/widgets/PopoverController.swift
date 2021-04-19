//
//  PopoverController.swift
//  MuzSzafa
//
//  Created by Alagris on 17/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Cocoa
import MuzSzafaShared

public extension PopoverController where Self: NSViewController{
    public func cancel(){
        dismiss(self)
    }
    public func success(){
        if let pr = parentResource{
            pr.reloadData()
        }
        CoreContext.shared.save()
        dismiss(self)
    }
    
}
