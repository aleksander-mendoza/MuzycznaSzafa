//
//  Sequence.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension Sequence{
    var firstElem:Element?{
        get{
            return first(where: {_ in true})
        }
    }
    
    func separated(with separator:Element)->SeparatedSequence<Self>{
        return SeparatedSequence(original: self, separator: separator)
    }
    
    func converted<ResultType>(with converter:@escaping (Element)->ResultType)->ConvertedSequence<Self,ResultType>{
        
        return ConvertedSequence(arr:self,converter:converter)
    }
    
    func summed<T:BinaryInteger>(with converter:@escaping (Element)->T)->T{
        var sum:T = 0
        for elem in self{
            sum += converter(elem)
        }
        return sum
    }
    
}

public extension Sequence where Element : Equatable{
    func contains(element:Element)->Bool{
        return contains(){$0 == element}
    }
}

