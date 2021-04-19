//
//  InputStream.swift
//  MuzSzafaShared
//
//  Created by Alagris on 29/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension InputStream{
    
    public enum Exception: Error{
        case ReadingFail(String)
    }
    
}
