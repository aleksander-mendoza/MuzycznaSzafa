//
//  PropertyCell.swift
//  MuzSzafa
//
//  Created by Alagris on 20/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import UIKit
public protocol PropertyCell{
    var cellTitle:UILabel!{get}
}
public extension PropertyCell where Self:UITableViewCell{
    var cellTitle:UILabel!{
        get{
            return textLabel
        }
    }
}
