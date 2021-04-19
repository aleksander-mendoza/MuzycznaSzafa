//
//  Optional.swift
//  MuzSzafaShared
//
//  Created by Alagris on 02/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension Array where Element : ExpressibleByNilLiteral {
    init(count:Int){
        self.init(repeating: nil, count: count)
    }
}

public extension Optional where Wrapped == String{
    public static let OR = "? ? ?"
    func or() -> String{
        return self ?? Optional<Wrapped>.OR
    }
}
public extension Sequence where Element == String?{
    func joined<S>(separator:S) -> String where S:StringProtocol {
        guard let f = firstElem else{
            return ""
        }
        var out:String = f.or()
        for elem in self.dropFirst(){
            out += separator + elem.or()
        }
        return out
    }
}
