//
//  Money.swift
//  MuzSzafa
//
//  Created by Alagris on 15/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Foundation
import QuartzCore


public func parseMoney(_ text:String)->Int64?{
    var val:Int64 = 0
    var powOfTen:Int64 = 1
    var foundDecimalPointAtIndex:Float = -1
    for (i,c) in text.unicodeScalars.reversed().enumerated(){
        if c == "."{
            if i >= 3 || foundDecimalPointAtIndex > -1{
                return nil
            }
            foundDecimalPointAtIndex = Float(i)
            continue
        }
        if "0" > c || c > "9"{
            return nil
        }
        let digit = Int64(c.value - UnicodeScalar("0").value)
        val += digit*powOfTen
        powOfTen *= 10
    }
    if foundDecimalPointAtIndex<0{
        foundDecimalPointAtIndex = 0
    }
    val *= Int64(pow(Float(10),2-foundDecimalPointAtIndex))
    return val
}

public func looselyParseMoney(_ text:String)->Int64?{
    var val:Int64 = 0
    let scalars = text.unicodeScalars
    var digitsLeft = -1
    for c in scalars{
        
        if c == "."{
            if digitsLeft <= -1{
                digitsLeft = 2
            }
            continue
        } else if c == ","{
            continue
        }
        if "0" > c || c > "9"{
            continue
        }
        if digitsLeft == 0{
            return val
        }
        digitsLeft -= 1
        let digit = Int64(c.value - UnicodeScalar("0").value)
        val = val * 10 + digit
    }
    if digitsLeft == 1{
        return val * 10
    }else if digitsLeft == 0{
        return val
    }
    return val * 100
}

public func moneyToDouble(_ money:Int64)->Double{
    return Double(money)/100.0
}
public func moneyToString(_ money:Int64)->String{
    if money <= 0 {
        return "0.00"
    }
    let digits = Int(log10(Double(money))) + 1
    let arrLen = (digits < 3 ? 3 : digits) + 1
    var array = [UInt8](repeating: 48, count: arrLen) //48 is ASCII "0"
    var mutCopy = money
    var i = arrLen-1
    while i>arrLen-3{
        array[i] += UInt8(mutCopy % 10)
        mutCopy /= 10
        i -= 1
    }
    array[arrLen-3] = 46//ASCII "."
    i -= 1
    while mutCopy>0{
        array[i] += UInt8(mutCopy % 10)
        mutCopy /= 10
        i -= 1
    }
    return String(bytes: array, encoding: String.Encoding.utf8)!
}

    
    
