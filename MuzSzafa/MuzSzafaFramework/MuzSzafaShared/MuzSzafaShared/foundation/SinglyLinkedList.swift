//
//  SinglyLinkedList.swift
//  MuzSzafaShared
//
//  Created by Alagris on 22/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class SinglyLinkedList<Element>:Sequence{
    public typealias Node = SinglyLinkedNode
    open class SinglyLinkedNode:Sequence{
        var val:Element
        var next:SinglyLinkedNode?
        init(val:Element){
            self.val = val
        }
        open func insert(list:SinglyLinkedList<Element>){
            list.last?.next = next
            append(list: list)
        }
        open func append(list:SinglyLinkedList<Element>){
            next = list.root
        }
        open func startsWith<S>(arr: S) -> Bool where Element == S.Element,Element : Equatable,S : Sequence {
            return skipIfMatches(arr: arr) != nil
        }
        open func skipIfMatches<S>(arr: S) -> Node? where Element == S.Element,Element : Equatable,S : Sequence {
            var next:Node? = self
            var prev:Node = self
            for i in arr{
                guard let n = next else{
                    return nil
                }
                if i != n.val{
                    return nil
                }
                prev = n
                next = n.next
            }
            return prev
        }
        open func forEach(value perform: (Element,Int)->Bool)->Int{
            return forEach(node: {return perform($0.val,$1)})
        }
        open func forEach(node perform: (Node,Int)->Bool)->Int{
            var next:Node? = self
            var performed = 0
            while let n = next{
                if !perform(n,performed){
                    break
                }
                next = n.next
                performed += 1
            }
            return performed
        }
        open func makeIterator() -> Iterator {
            return SinglyLinkedIterator(root:self)
        }
    }
    open class SinglyLinkedIterator:IteratorProtocol,NSCopying{
        public func copyTypesafe() -> SinglyLinkedIterator {
            let copy = SinglyLinkedIterator(root:node)
            return copy
        }
        public func copy(with zone: NSZone? = nil) -> Any {
            return copyTypesafe()
        }
        
        public func next() -> Element? {
            guard let n = node else{
                return nil
            }
            prev = node
            node = n.next
            return n.val
        }
        public private(set) var node:Node?
        public private(set) var prev:Node?
        public init(root:Node?) {
            node = root
        }
        open func insert(list:SinglyLinkedList<Element>){
            node?.insert(list: list)
        }
        open func append(list:SinglyLinkedList<Element>){
            node?.append(list: list)
        }
        open var val:Element?{
            get{
                return node?.val
            }
        }
        open func startsWith<S>(arr: S) -> Bool where Element == S.Element,Element : Equatable,S : Sequence {
            return node?.startsWith(arr: arr) ?? false
        }
    }
    
    public typealias Iterator = SinglyLinkedIterator
    
    open var root:Node?
    open var last:Node?
    private func initRoot(node: Node?){
        root = node
        last = root
    }
    private func initRoot(val: Element){
        initRoot(node: Node(val: val))
    }
    init() {
    }
    init(elem:Element) {
        initRoot(val: elem)
    }
    init<S>(arr: S) where Element == S.Element, S : Sequence{
        append(arr:arr)
    }
    
    init<S,Val>(arr: S,convert:(Val)->Element) where Val == S.Element, S : Sequence{
        append(arr: arr, convert: convert)
    }
    open func append<S>(arr: S) where Element == S.Element, S : Sequence{
        for elem in arr{
            append(elem)
        }
    }
    open func append<S,Val>(arr: S,convert:(Val)->Element) where Val == S.Element, S : Sequence{
        for val in arr{
            let elem = convert(val)
            append(elem)
        }
    }
    open func append(_ new:Element){
        append(node: Node(val: new))
        
    }
    open func append(node:Node?){
        if let l = last{
            l.next = node
            last = l.next
        }else{
            initRoot(node: node)
        }
    }
    static func += (_ list:SinglyLinkedList<Element>,_ new:Element){
        list.append(new)
    }
    static func += (_ list:SinglyLinkedList<Element>,_ new:[Element]){
        list.append(arr:new)
    }
    static func += (_ list:SinglyLinkedList<Element>,_ new:Node){
        list.append(node:new)
    }
    open func insert(list:SinglyLinkedList<Element>, at index:Int){
        node(at: index)?.insert(list:list)
    }
    open func append(list:SinglyLinkedList<Element>, at index:Int){
        node(at: index)?.append(list:list)
    }
    open subscript (_ index:Int)->Element?{
        return node(at: index)?.val
    }
    open func node(at index:Int)->Node?{
        let iter = makeIterator()
        for _ in 0 ... index{
            if iter.next() == nil{
                return nil
            }
        }
        return iter.node
    }
    open func makeIterator() -> Iterator {
        return SinglyLinkedIterator(root:root)
    }
    open func toArray()->[Element]{
        var arr:[Element] = []
        for elem in self{
            arr += elem
        }
        return arr
    }
}

public extension SinglyLinkedList where Element == String{
//    public func joined(separator:String)->String{
//        var sum = String()
//        for str in self{
//            sum += str
//        }
//        return sum
//    }
}
