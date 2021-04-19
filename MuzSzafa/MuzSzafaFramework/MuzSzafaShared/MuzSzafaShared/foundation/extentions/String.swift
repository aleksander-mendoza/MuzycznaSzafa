//
//  String.swift
//  MuzSzafaShared
//
//  Created by Alagris on 27/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public extension String {
    
    init?(file:String,
          for dir: FileManager.SearchPathDirectory = .documentDirectory,
          in mask: FileManager.SearchPathDomainMask = .userDomainMask) throws{
        guard let url = FileManager.default.urls(for: dir,in: mask).first else{
            return nil
        }
        try self.init(file: file,dir: url)
    }
    init(file:String,dir:URL) throws{
        try self.init(file: dir.appendingPathComponent(file))
    }
    init(file:URL) throws{
        try self.init(contentsOf: file, encoding: .utf8)
    }
    
    
    public init(length: Int = 20, randomAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") {
        var arr = [Character](repeating:"\0", count:length)
        
        for i in 0..<length {
            let randomValue = arc4random_uniform(UInt32(randomAlphabet.count))
            let begin = randomAlphabet.startIndex
            let index = randomAlphabet.index(begin, offsetBy: Int(randomValue))
            let letter = randomAlphabet[index]
            arr[i] = letter
        }
        self.init(arr)
    }
    public func replace(dict: [Character:Character]) {
        var arr = Array(self)
        for i in 0..<arr.count{
            if let replacement = dict[arr[i]]{
                arr[i] = replacement
            }
        }
    }
    
    func lastIndex(of char:Character)->String.Index?{
        for i in self.indices.reversed() where self[i] == char{
            return i
        }
        return nil
    }
    
    func index(of char:Character,offset index:String.Index)->String.Index?{
        var i = index
        while i < self.endIndex{
            i = self.index(after: i)
            if self[i] == char{
                return i
            }
        }
        return nil
    }
    
//
//    private func replacing(key:String,
//                           val:String,
//                           iter:SinglyLinkedList<Character>.Iterator) -> Bool {
//        if let tail = iter.prev?.skipIfMatches(arr: key){
//            let linkedVal = SinglyLinkedList(arr: val)
//            linkedVal.append(node: tail.next)
//            iter.prev?.next = linkedVal.root
//            return true
//        }
//        return false
//
//    }
//    public func replacing(dict: [String:String]) -> String {
//        let str = SinglyLinkedList(arr: self)
//        let iter = str.makeIterator()
//        while iter.next() != nil{
//            for (key,val) in dict{
//                if replacing(key: key, val: val, iter: iter){
//                    break
//                }
//            }
//        }
//        return String(str)
//    }
//    public func replacing(swappedDict: [String:String]) -> String {
//        let str = SinglyLinkedList(arr: self)
//        let iter = str.makeIterator()
//        while iter.next() != nil{
//            for (key,val) in swappedDict{
//                if replacing(key: val, val: key, iter: iter){
//                    break
//                }
//            }
//        }
//        return String(str)
//    }
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
    /**Tries to find letters from this string inside given other string*/
    func fuzzyCompare(_ str:String)->Bool{
        var i = str.lowercased().unicodeScalars.makeIterator()
        l1:for char in self.lowercased().unicodeScalars{
            if CharacterSet.whitespaces.contains(char){
                continue
            }
            while let char2 = i.next(){
                if char == char2{continue l1}
            }
            return false
        }
        return true
    }
	
	
	
}

