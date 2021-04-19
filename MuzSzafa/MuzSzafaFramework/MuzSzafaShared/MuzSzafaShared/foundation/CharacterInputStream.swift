//
//  CharacterInputStream.swift
//  MuzSzafaShared
//
//  Created by Alagris on 13/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

open class CharacterInputStream{
    private let stream:BufferedInputStream
    public init?(url: URL,capacity:Int=1024) {
        guard let s = BufferedInputStream(url: url, capacity: capacity) else{
            return nil
        }
        stream = s
    }
    public init(data: Data,capacity:Int=1024) {
        stream = BufferedInputStream(data: data, capacity: capacity)
    }
    open func nextCharacter(){
//        Character(
    }
}
