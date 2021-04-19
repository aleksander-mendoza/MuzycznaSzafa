//
//  CoreDataBiFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


public protocol CoreDataBiFilter:CoreDataFilter{
    var value:(from:Any?,to:Any?){get set}
}
public extension CoreDataBiFilter{
    public var predParams:[Any]{
        get{
            return [value.from ?? "NIL", attr.name, attr.name, value.to ?? "NIL"]
        }
    }
    public subscript(at:Int)->Any?{
        get{
            switch at {
            case 0:
                return value.from
            case 1:
                return value.to
            default:
				assertionFailure()
                return nil
            }
        }
        set{
            switch at {
            case 0:
                value.from = newValue
            case 1:
                value.to = newValue
            default:
				assertionFailure()
                break
            }
        }
    }
}
