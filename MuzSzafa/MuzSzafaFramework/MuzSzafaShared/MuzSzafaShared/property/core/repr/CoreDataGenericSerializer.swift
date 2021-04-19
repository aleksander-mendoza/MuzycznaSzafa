//
//  CoreDataGenericSerializer.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


public protocol CoreDataGenericSerializer:CoreDataSerializer{
    associatedtype T
    func serialize(_ :T)->String
    func serialize(maybe:T?)->String
    func deserialize(_ :String)->T?
    func stringify(_ :T)->String?
    func stringify(maybe:T?)->String?
}

public extension CoreDataGenericSerializer {
    //////////////////////////
    ///default impl
    //////////////////////////
    func stringify(maybe val:T?)->String?{
        guard let v = val else{
            return nil
        }
        return stringify(v)
    }
    func serialize(_ val:T)->String{
        return stringify(val) ?? ""
    }
    func serialize(maybe val:T?)->String{
        if let v = val{
            return serialize(v)
        }
        return ""
    }
    //////////////////////////
    ///overriden from parent
    //////////////////////////
    public func serialize(any: Any) -> String {
        return serialize(any as! T)
    }
    public func serialize(maybeAny: Any?) -> String {
        return serialize(maybe: maybeAny as! T?)
    }
    public func deserialize(any: String)->Any?{
        return deserialize(any)
    }
    public func stringify(any: Any)->String?{
        return stringify(any as! T)
    }
    public func stringify(maybeAny: Any?) -> String? {
        return stringify(maybe: maybeAny as! T?)
    }
}
