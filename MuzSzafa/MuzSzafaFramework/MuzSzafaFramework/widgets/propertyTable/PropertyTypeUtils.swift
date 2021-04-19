//
//  PropertyType.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import UIKit
import MuzSzafaShared
func getTableRowHeight(_ propertyType:PropertyType) -> CGFloat{
    switch(propertyType){
    case .date:
        fallthrough
    case .text:
        fallthrough
    case .list:
        return 128
    case .bool:
        fallthrough
    case .display:
        fallthrough
    case .relat:
        return 44
    default:
        return 88
    }
}


