//
//  SeparatedSequence.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
open class SeparatedSequence<S>: Sequence where S:Sequence{
    
    
    public typealias Element = S.Element
    public typealias Iterator = SeparatedSequenceIterator<S.Iterator>
    private let original:S
    private let separator:Element
    
    public func makeIterator() -> Iterator {
        return SeparatedSequenceIterator(iterator: original.makeIterator(), separator: separator)
    }
    
    open class SeparatedSequenceIterator<I>:IteratorProtocol where I: IteratorProtocol{
        public func next() -> I.Element? {
            if useSeparator{
                useSeparator = false
                if nextElem != nil{
                   return separator
                }else{
                    return nil
                }
            }else{
                let out = nextElem
                nextElem = plainIterator.next()
                useSeparator = true
                return out
            }
        }
        private var useSeparator:Bool = false
        private var plainIterator:I
        private let separator:I.Element
        private var nextElem:I.Element?
        init(iterator:I,separator:I.Element) {
            self.separator = separator
            self.plainIterator = iterator
            self.nextElem = plainIterator.next()
        }
    }
    
    init(original:S,separator:Element)  {
        self.original = original
        self.separator = separator
    }
}
