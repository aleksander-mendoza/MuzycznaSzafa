//
//  NSMutableAttributedString.swift
//  MuzSzafaShared
//
//  Created by Alagris on 20/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension NSMutableAttributedString {
    func replaceOccurrences(of key: String, with new:String){
        for r in rangesOf(string: key).reversed(){
            let rn = NSRange(r,in:string)
            replaceCharacters(in: rn, with: new)
        }
    }
    
}
