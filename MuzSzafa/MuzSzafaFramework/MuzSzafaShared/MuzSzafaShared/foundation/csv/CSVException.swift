//
//  CSVException.swift
//  MuzSzafaShared
//
//  Created by Alagris on 08/06/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public enum CSVException: Error{
    case WritingFail(String)
    case ReadingFail(String)
}
