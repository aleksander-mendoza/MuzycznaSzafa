//
//  PropertyType.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

public extension PropertyType{
    public func makeFilter(for attr:CoreDataAttr) -> CoreDataFilter{
        switch self {
        case .list:
            fallthrough
        case .bool:
            fallthrough
        case .toggle:
            return CoreDataEqUniFilter(parent: attr)
        case .date:
            fallthrough
        case .int:
            fallthrough
        case .money:
            return CoreDataBetweenBiFilter(parent: attr)
        case .display:
			switch attr.rawType {
			case .stringAttributeType:
				return CoreDataFuzzyUniFilter(parent: attr)
			case .undefinedAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			case .integer16AttributeType:
				fallthrough
			case .integer32AttributeType:
				fallthrough
			case .integer64AttributeType:
				fallthrough
			case .decimalAttributeType:
				fallthrough
			case .doubleAttributeType:
				fallthrough
			case .floatAttributeType:
				return CoreDataBetweenBiFilter(parent: attr)
			case .booleanAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			case .dateAttributeType:
				return CoreDataBetweenBiFilter(parent: attr)
			case .binaryDataAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			case .UUIDAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			case .URIAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			case .transformableAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			case .objectIDAttributeType:
				return CoreDataEqUniFilter(parent: attr)
			}
        case .string:
            fallthrough
        case .text:
            fallthrough
        case .telephone:
            fallthrough
        case .email:
            return CoreDataFuzzyUniFilter(parent: attr)
        case .button:
            return CoreDataNoUniFilter(parent: attr)
        case .relat:
            return CoreDataRelatUniFilter(parent: attr)
		case .relatList:
			fallthrough
		case .relatToMany:
			return CoreDataRelatUniFilter(parent: attr)
		case .moList:
			return CoreDataNoUniFilter(parent: attr)
        }
    }
    public var isFiltrable:Bool{
        get{
            return self != .button
        }
    }
}
