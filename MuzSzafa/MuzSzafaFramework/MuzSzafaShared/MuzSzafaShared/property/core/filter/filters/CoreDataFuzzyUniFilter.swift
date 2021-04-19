//
//  CoreDataFuzzyUniFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


public class CoreDataFuzzyUniFilter:CoreDataUniFilter{
	public var attr: CoreDataAttr
	
	public var pred: SafePredicate.Node{
		get{
			return attr.likeIgnoreCase(value)
		}
	}
	
	public var isEnabled: Bool = true
	
	
	
    required public init(parent: CoreDataAttr) {
        attr = parent
    }
	
	public static func prepareLikeQuery(for string:String)->String{
		let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
		let words = trimmed.components(separatedBy: .whitespacesAndNewlines)
		if words.count > 0{
			let out = "*"+words.joined(separator: "*")+"*"
			return out
		}
		return "*"
	}
    private var val:Any?
    public var value: Any?{
        get{
            if let v = val, let s = v as? String{
                return CoreDataFuzzyUniFilter.prepareLikeQuery(for: s)
            }
            return "*"
        }
        set(new){
            val = new
        }
    }
    public subscript(at:Int)->Any?{
        get{
            if at == 0{
                return val
            }
            return nil
        }
        set{
            if at == 0{
                value = newValue
            }
        }
    }
}

