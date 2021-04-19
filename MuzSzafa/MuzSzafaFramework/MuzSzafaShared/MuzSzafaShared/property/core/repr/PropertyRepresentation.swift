//
//  PropertyRepresentation.swift
//  MuzSzafaShared
//
//  Created by Alagris on 25/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public protocol PropertyRepresentation:class {
    var fields:[PropertyVisibility:[String?]]{get set}
    var primaryFields:[String?]{get set}
    var secondaryFields:[String?]{get set}
    var externalFields:[String?]{get set}
    func combinePrimary()->String
    func combineSecondary()->String
    func combineExternal()->String
}

public extension PropertyRepresentation{
    var primaryFields:[String?]{
        get{
            return fields[.primary]!
        }
        set(new){
            fields[.primary] = new
        }
    }
    var secondaryFields:[String?]{
        get{
            return fields[.secondary]!
        }
        set(new){
            fields[.secondary] = new
        }
    }
    var externalFields:[String?]{
        get{
            return fields[.external]!
        }
        set(new){
            fields[.external] = new
        }
    }
    func combinePrimary()->String{
        if primaryFields.count == 2{
            return "\(primaryFields[0].or()) (\(primaryFields[1].or()))"
        }else{
            return primaryFields.joined(separator: ", ")
        }
    }
    func combineSecondary()->String{
        if secondaryFields.count == 2{
            return "\(secondaryFields[0].or()) (\(secondaryFields[1].or()))"
        }else{
            return secondaryFields.joined(separator: ", ")
        }
    }
    func combineExternal()->String{
        return externalFields.joined(separator: ", ")
    }
    
    func getFieldsCount(vis:PropertyVisibility)->Int{
        switch vis{
        case .primary:
            return primaryFields.count
        case .secondary:
            return secondaryFields.count
        case .external:
            return externalFields.count
        default:
            return 0
        }
    }
}

