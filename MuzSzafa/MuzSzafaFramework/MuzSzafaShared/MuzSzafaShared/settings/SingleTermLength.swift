//
//  SingleTermLength.swift
//  MuzSzafaShared
//
//  Created by Alagris on 30/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

public extension UserDefaults{
    static let TERM_YEARS_KEY = "single_term_length_years"
    static let TERM_MONTHS_KEY = "single_term_length_months"
    static let TERM_DAYS_KEY = "single_term_length_days"
    static let TERM_HOURS_KEY = "single_term_length_hours"
    static let TERM_MINUTES_KEY = "single_term_length_minutes"
    public var singleTermLengthYears:Int{
        get{
            return integer(forKey: UserDefaults.TERM_YEARS_KEY)
        }
        set{
            set(newValue, forKey: UserDefaults.TERM_YEARS_KEY)
        }
    }
    public var singleTermLengthMonths:Int{
        get{
            return integer(forKey: UserDefaults.TERM_MONTHS_KEY)
        }
        set{
            set(newValue, forKey: UserDefaults.TERM_MONTHS_KEY)
        }
    }
    public var singleTermLengthDays:Int{
        get{
            return integer(forKey: UserDefaults.TERM_DAYS_KEY)
        }
        set{
            set(newValue, forKey: UserDefaults.TERM_DAYS_KEY)
        }
    }
    public var singleTermLengthHours:Int{
        get{
            return integer(forKey: UserDefaults.TERM_HOURS_KEY)
        }
        set{
            set(newValue, forKey: UserDefaults.TERM_HOURS_KEY)
        }
    }
    public var singleTermLengthMinutes:Int{
        get{
            return integer(forKey: UserDefaults.TERM_MINUTES_KEY)
        }
        set{
            set(newValue, forKey: UserDefaults.TERM_MINUTES_KEY)
        }
    }
    
}
public extension Date{
    public func increaseBySingleTermLength(_ ud:UserDefaults=UserDefaults.standard) -> Date?{
        return self.add(years: ud.singleTermLengthYears)?.add(months: ud.singleTermLengthMonths)?.add(days: ud.singleTermLengthDays)
    }
}
public extension UserDefaultsPropertyEntry{
    static func generateSettings()->[PropertyTableEntry]{
        return [
            ManualPropertyEntry(localizedName: "single term length:", type: .display,val:""),
            UserDefaultsPropertyEntry(localizedName:  "years", key: UserDefaults.TERM_YEARS_KEY, type: .int),
            UserDefaultsPropertyEntry(localizedName:  "months", key: UserDefaults.TERM_MONTHS_KEY, type: .int),
            UserDefaultsPropertyEntry(localizedName:  "days", key: UserDefaults.TERM_DAYS_KEY, type: .int),
            UserDefaultsPropertyEntry(localizedName:  "hours", key: UserDefaults.TERM_HOURS_KEY, type: .int),
            UserDefaultsPropertyEntry(localizedName:  "minutes", key: UserDefaults.TERM_MINUTES_KEY, type: .int)
        ]
    }
}

