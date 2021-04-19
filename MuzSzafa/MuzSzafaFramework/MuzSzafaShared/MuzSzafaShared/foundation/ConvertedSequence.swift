//
//  ConvertedSequence.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
open class ConvertedSequence<S,ResultType>: Sequence where S : Sequence{
   
    
    public typealias Element = ResultType
    public typealias Iterator = ConvertedSequenceIterator<S.Iterator,ResultType>
    private let arr:S
    private let converter:(S.Element)->ResultType
    
    
    public func makeIterator() -> Iterator {
        return ConvertedSequenceIterator(iterator:arr.makeIterator(),converter:converter)
    }
    open class ConvertedSequenceIterator<I,ResultType>:IteratorProtocol where I : IteratorProtocol{
        public func next() -> ResultType? {
            if let e = iterator.next(){
                return converter(e)
            }
            return nil
        }
        private var iterator:I
        private let converter:(I.Element)->ResultType
        
        init(iterator:I,converter: @escaping (I.Element)->ResultType)  {
            self.iterator = iterator
            self.converter = converter
        }
    }
    
    open func collect()->[ResultType]{
        var out = [ResultType]()
        for elem in self{
            out += elem
        }
        return out
    }
    
    init(arr:S,converter: @escaping (S.Element)->ResultType)  {
        self.arr = arr
        self.converter = converter
    }
}
