//
//  PropertyType.swift
//  MuzSzafa
//
//  Created by Alagris on 18/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import MuzSzafaShared
func getTableRowHeight(_ propertyType:PropertyType) -> CGFloat{
    switch(propertyType){
    case .text:
		fallthrough
	case .moList:
		fallthrough
	case .relatList:
        return 128
    default:
        return 28
    }
}


