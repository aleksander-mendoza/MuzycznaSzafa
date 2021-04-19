//
//  FileCoreDataRelatUniFilter.swift
//  MuzSzafaShared
//
//  Created by Alagris on 05/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//
import CoreData

public class CoreDataRelatUniFilter:CoreDataUniFilter{
	public var pred: SafePredicate.Node{
		get{
			return attr.equals(val.mo)
		}
	}
	
	public var isEnabled: Bool = true
	
	
	
    required public init(parent: CoreDataAttr) {
        let ra = parent as! CoreDataRelatEntry
        val = CellRelatEntry(mo:nil,attr:ra)
        attr = parent
    }
    
    private func updateRelatAttr(){
        let ra = attr as! CoreDataRelatEntry
        val.attr = ra
    }
    private var val:CellRelatEntry
    public var attr: CoreDataAttr{
        didSet{
            updateRelatAttr()
        }
    }
    
    public var value: Any?{
        get{
            return val.mo
        }
        set{
            val.mo = newValue as! NSManagedObject?
        }
    }
    
    public subscript(at:Int)->Any?{
        get{
            if at == 0{
                return val
            }
			assertionFailure()
            return nil
        }
        set{
            if at == 0{
                if let new = newValue{
                    val = new as! CellRelatEntry
                }else{
                    val.mo = nil
                }
			}else{
				assertionFailure()
			}
        }
    }
    
}
