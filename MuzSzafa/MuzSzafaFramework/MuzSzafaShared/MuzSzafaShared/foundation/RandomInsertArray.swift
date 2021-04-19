//
//  RandomInsertArray.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public protocol RandomInsertArrayProtocol:Sequence{
    
}

open class RandomInsertArray<E>:RandomInsertArrayProtocol{
    public init(){}
    public func makeIterator() -> RandomInsertArray<E>.RIAIterator {
        return RIAIterator(parent:self)
    }
    
    public typealias Iterator = RIAIterator
    
    public typealias Element = E?
    
    open class RIAIterator:IteratorProtocol{
        private var parent:RandomInsertArray
        fileprivate init(parent:RandomInsertArray) {
            self.parent = parent
        }
        public func next() -> Element? {
            if index < parent.data.count{
                return parent.data[index]
            }
            return nil
        }
        private var index = 0
        
        public typealias Element = RandomInsertArray.Element
    }
    
    private var data:[Element] = []
    
    open subscript(_ index:Int)->Element{
        get{
            guard 0<=index && index < data.count else{
                return nil
            }
            return data[index]
        }
        set{
            guard index >= 0 else{
                fatalError("negative index")
            }
            while index >= data.count{
                data.append(nil)
            }
            data[index] = newValue
        }
    }
    
    
    
    
}
