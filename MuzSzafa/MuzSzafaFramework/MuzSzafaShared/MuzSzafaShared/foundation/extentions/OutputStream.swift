//
//  FileOutputStream.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension OutputStream{
    convenience init?(url file:String,dir:URL){
        self.init(url: dir.appendingPathComponent(file))
    }
    convenience init?(url file:URL){
        self.init(url: file, append: false)
    }
    static func doWith(url:String,dir:URL,function:(OutputStream)throws->Void) throws{
        try doWith(stream: OutputStream(url: url,dir: dir), function: function)
    }
    static func doWith(url:URL,function:(OutputStream)throws->Void) throws{
        try doWith(stream: OutputStream(url: url), function: function)
    }
    static func doWith(url:String,function:(OutputStream)throws->Void) throws{
        try doWith(stream: OutputStream(url: try URL(file: url)), function: function)
    }
    static func doWith(stream:OutputStream?,
                               function:(OutputStream)throws->Void) throws{
        if let stream = stream{
            stream.open()
            defer{
                stream.close()
            }
            try function(stream)
        }else{
            throw URLError(.badURL)
        }
    }
    
    
    func write<S,Val>(arr: S,
                      separator:String="",
                      encoding: String.Encoding = String.Encoding.utf8,
                      allowLossyConversion: Bool = false,
                      convert:@escaping (Val)->String) -> Int
        where Val == S.Element, S : Sequence
    {
        var total = 0
        for str in arr.converted(with: convert).separated(with:","){
            let written = write(str: str, encoding: encoding, allowLossyConversion: allowLossyConversion)
            if written < 0 {
                return -1
            }
            total += written
        }
        return total
    }
    func write(date:Date,
               format:String? = nil,
               encoding: String.Encoding = String.Encoding.utf8,
               allowLossyConversion: Bool = false) -> Int
    {
        let formatter = DateFormatter()
        if let f = format {
            formatter.dateFormat = f
        }
        let str = formatter.string(from: date)
        return write(str: str, encoding: encoding, allowLossyConversion: allowLossyConversion)
    }
    
    func write(str: String, encoding: String.Encoding = String.Encoding.utf8, allowLossyConversion: Bool = false) -> Int {
        if let data = str.data(using: encoding, allowLossyConversion: allowLossyConversion) {
            return write(data: data)
        }
        return -1
    }
    func write(int:Int,
               encoding: String.Encoding = String.Encoding.utf8,
               allowLossyConversion: Bool = false) -> Int
    {
        return write(str: String(int), encoding: encoding, allowLossyConversion: allowLossyConversion)
    }
    
    func write<S>(chars: S,
               encoding: String.Encoding = String.Encoding.utf8,
               allowLossyConversion: Bool = false) -> Int
        where Character == S.Element, S : Sequence
    {
        return write(str: String(chars), encoding: encoding, allowLossyConversion: allowLossyConversion)
    }
    
    func write(data: Data) -> Int {
        var bytesRemaining = data.count
        var totalBytesWritten = 0
        while bytesRemaining > 0 {
            let bytesWritten = data.withUnsafeBytes() {
                (val:UnsafePointer<UInt8>) -> Int in
                let advanced = val.advanced(by: totalBytesWritten)
                return self.write(
                    advanced,
                    maxLength: bytesRemaining
                )
            }
            if bytesWritten < 0 {
                // "Can not OutputStream.write(): \(self.streamError?.localizedDescription)"
                return -1
            } else if bytesWritten == 0 {
                // "OutputStream.write() returned 0"
                return totalBytesWritten
            }
            
            bytesRemaining -= bytesWritten
            totalBytesWritten += bytesWritten
        }
        
        return totalBytesWritten
    }
}


