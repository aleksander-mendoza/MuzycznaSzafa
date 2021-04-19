//
//  URL.swift
//  MuzSzafaShared
//
//  Created by Alagris on 17/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import AppKit

public extension URL{
    
    var documentType:NSAttributedString.DocumentType{
        get{
            switch pathExtension.lowercased(){
            case "html":
                fallthrough
            case "htm":
                return NSAttributedString.DocumentType.html
            case "rtf":
                return NSAttributedString.DocumentType.rtf
            case "rtfd":
                return NSAttributedString.DocumentType.rtfd
            case "webarchive":
                return NSAttributedString.DocumentType.webArchive
            case "doc":
                return NSAttributedString.DocumentType.docFormat
            case "xml":
                return NSAttributedString.DocumentType.officeOpenXML
            case "odt":
                return NSAttributedString.DocumentType.openDocument
            case "txt":
                return NSAttributedString.DocumentType.plain
            case "xslt":
                fallthrough
            case "xsl":
                return NSAttributedString.DocumentType.wordML
            default:
                return NSAttributedString.DocumentType.macSimpleText
                
            }
        }
    }
}
public extension NSAttributedString.DocumentType{
    static var supportedExtensions:[String]{
        get{
            return [
            "html",
            "htm",
            "rtf",
            "rtfd",
            "webarchive",
            "doc",
            "xml",
            "odt",
            "txt",
            "xslt",
            "xsl"
            ]
        }
    }
}
