//
//  BufferedInputStream.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation




open class BufferedInputStream{
    
    private let stream:InputStream
    private let buffer:UnsafeMutablePointer<UInt8>
    public let capacity:Int
    private var offset:Int = 0
    private var length:Int = 0
    private var beginInclusive:Int{
        get{
            return offset
        }
    }
    private var endExclusive:Int{
        get{
            return offset + length
        }
    }
    private var remaingSpace:Int{
        get{
            return capacity - offset - length
        }
    }
    private var byte:UInt8{
        get{
            return buffer.advanced(by: offset).pointee
        }
    }
    
    
    public init?(url: URL,capacity:Int=1024) {
        self.capacity = capacity
        buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: capacity)
        guard let s = InputStream(url: url) else{
            return nil
        }
        stream = s
        stream.open()
    }
    public init(data: Data,capacity:Int=1024) {
        self.capacity = capacity
        buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: capacity)
        stream = InputStream(data: data)
        stream.open()
    }
    deinit {
        stream.close()
    }
    
    open func nextByte()throws->UInt8?{
        try read()
        if length == 0{
            return nil
        }
        let out = byte
        moveForward()
        return out
    }
    
    private func moveForward(_ bytes:Int=1){
        let bytes = min(length,max(0,bytes))
        length -= bytes
        offset = (offset + bytes) % capacity
    }
    private func read() throws{
        if length == 0 && stream.hasBytesAvailable {
            if remaingSpace > 0{
                let b = buffer.advanced(by: endExclusive)
                let r = stream.read(b, maxLength: remaingSpace)
                if r < 0 {
                    throw InputStream.Exception.ReadingFail("Could not read from stream!")
                }
                length += r
            }
        }
    }
}
