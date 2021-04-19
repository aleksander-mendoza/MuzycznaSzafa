//
//  CoreDataNoUniFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//


public class CoreDataNoUniFilter:CoreDataUniFilter{
	public var attr: CoreDataAttr
	
	public var pred: SafePredicate.Node {
		get{
			return SafePredicate.Node.empty()
		}
	}
	
	required public init(parent: CoreDataAttr) {
        attr = parent
    }
	
    public var isEnabled: Bool{
        set{}
        get{
            return false
        }
    }
    public var value: Any?{
        get{
            return nil
        }
        set{}
    }
	
}
