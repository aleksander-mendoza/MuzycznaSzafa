//
//  Stringifiers.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation


public func stringify(maybe val:Any?)->String?{
    if let v = val{
        return stringify(v)
    }
    return nil
}
public func stringify(_ val:Any)->String?{
    if let s = val as? String{
        return s
    }else if let s = val as? NSAttributedString{
        return s.string
    }else if let s = val as? Int{
        return String(s)
    }else if let s = val as? Int64{
        return String(s)
    }else if let s = val as? Date{
        let f = DateFormatter()
        f.dateFormat = "dd-MM-YYYY"
        return f.string(from: s)
    }else if let s = val as? Bool{
        return getLocalizedString(for: String(s))
    }else{
        return nil
    }
}
public func numerifyToInt(_ val:Any)->Int{
    if let s = val as? Int16{
        return Int(s)
    }else if let s = val as? Int32{
        return Int(s)
    }else if let s = val as? Int64{
        return Int(s)
    }else if let s = val as? Double{
        return Int(s)
    }else if let s = val as? Float{
        return Int(s)
    }else{
        return val as! Int
    }
}
public func numerifyToDouble(maybe val:Any?)->Double?{
    if let v = val{
        return numerifyToDouble(v)
    }
    return nil
}
public func numerifyToDouble(_ val:Any)->Double{
    if let s = val as? Int16{
        return Double(s)
    }else if let s = val as? Int32{
        return Double(s)
    }else if let s = val as? Int64{
        return Double(s)
    }else if let s = val as? Int{
        return Double(s)
    }else if let s = val as? Float{
        return Double(s)
    }else{
        return val as! Double
    }
}
public func numerifyToInt64(maybe val:Any?)->Int64?{
    if let v = val{
        return numerifyToInt64(v)
    }
    return nil
}
public func numerifyToInt64(_ val:Any)->Int64{
    if let s = val as? Int16{
        return Int64(s)
    }else if let s = val as? Int32{
        return Int64(s)
    }else if let s = val as? Int{
        return Int64(s)
    }else if let s = val as? Double{
        return Int64(s)
    }else if let s = val as? Float{
        return Int64(s)
    }else{
        return val as! Int64
    }
}
