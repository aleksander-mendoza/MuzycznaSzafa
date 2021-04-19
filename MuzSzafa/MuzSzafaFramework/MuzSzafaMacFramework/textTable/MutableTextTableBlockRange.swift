//
//  TextTableBlockRange.swift
//  MuzSzafaMacFramework
//
//  Created by Alagris on 22/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import Cocoa
public protocol MutableTextTableBlockRange:TextTableBlockRange, MutableAttributedStringRange{
    var block:NSTextTableBlock{get}
    init(block:NSTextTableBlock,range:NSRange,fromMut:NSMutableAttributedString)
}

public extension MutableTextTableBlockRange{
    public init(block: NSTextTableBlock,
                range: NSRange,
                from src: NSAttributedString) {
        let mut = src.mutableCopy() as! NSMutableAttributedString
        self.init(block:block,range:range,fromMut:mut)
    }
    public init(block:NSTextTableBlock,fromMut src:NSMutableAttributedString,at index:Int){
        self.init(block:block,range:src.range(of: block, at: index),fromMut:src)
    }
}
public extension MutableTextTableBlockRange{
    public func replace(_ str:NSMutableAttributedString,rangeRelative:NSRange){
        replace(str, range: cellRelativeToStringAbsolute(range: rangeRelative))
    }
    public func replace(_ str:NSMutableAttributedString,range:NSRange){
        let currentStyle = mutablestr.paragraphStyle(at: range.lowerBound)!
        
        if let s = str.mutParagraphStyle(at: 0){
            s.textBlocks.append(contentsOf: currentStyle.textBlocks)
        }else{
            let attrs = [NSAttributedStringKey.paragraphStyle:currentStyle]
            str.addAttributes(attrs, range: str.totalRange)
        }
        mutablestr.replaceCharacters(in: range, with: str)
    }
    public func replace(_ str:NSAttributedString,rangeRelative:NSRange){
        replace(str, range: cellRelativeToStringAbsolute(range: rangeRelative))
    }
    public func replace(_ str:NSAttributedString,range:NSRange){
        replace(str.mutableCopy() as! NSMutableAttributedString, range: range)
    }
}

public extension MutableTextTableBlockRange{
    public func insert(_ str:NSMutableAttributedString,at index:Int){
        replace(str, range: NSMakeRange(index, 0))
    }
    public func insert(_ str:NSAttributedString,at index:Int){
        replace(str, range: NSMakeRange(index, 0))
    }
    public func insert(_ str:NSMutableAttributedString,atRelative index:Int){
        insert(str, at:cellRelativeToStringAbsolute(index:index))
    }
    public func insert(_ str:NSAttributedString,atRelative index:Int){
        insert(str, at:cellRelativeToStringAbsolute(index:index))
    }
}

public extension MutableTextTableBlockRange{
    public func append(_ str:String){
        append(NSMutableAttributedString(string: str))
    }
    public func append(_ str:NSMutableAttributedString){
        insert(str, at:range.upperBound)
    }
    public func append(_ str:NSAttributedString){
        insert(str, at:range.upperBound)
    }
}

public extension MutableTextTableBlockRange{
    public func cellRelativeToStringAbsolute(index:Int)->Int{
        return index + range.lowerBound
    }
    public func cellRelativeToStringAbsolute(range:NSRange)->NSRange{
        return NSMakeRange(range.lowerBound + self.range.lowerBound, range.length)
    }
    public func removeCell(){
        mutablestr.deleteCharacters(in: range)
    }
    public func rangeOf(string:String)->Range<String.Index>?{
        return mutablestr.rangeOf(string: string)
    }
    public func contains(string:String)->Bool{
        return rangeOf(string: string) != nil
    }
    public func set(block:NSTextTableBlock){
        for i in range.lowerBound..<range.upperBound{
            if let s = mutablestr.mutParagraphStyle(at: i),
                let i = s.textBlocks.index(of: block){
                s.textBlocks[i] = block
            }
        }
    }
    public func removeBlock(){
        for i in range.lowerBound..<range.upperBound{
            if let s = mutablestr.mutParagraphStyle(at: i),
                let i = s.textBlocks.index(of: block){
                s.textBlocks.remove(at: i)
            }
        }
    }
}



