//
//  Date.swift
//  MuzSzafaShared
//
//  Created by Alagris on 18/04/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
public extension Date{
    public func extract(component:Calendar.Component)->Int?{
        return Calendar.current.component(component, from: self)
    }
    public func extract(components:Set<Calendar.Component>)->Date?{
        let c = Calendar.current.dateComponents(components, from: self)
        return Calendar.current.date(from: c)
    }
    public func getDayBegin()->Date?{
        return extract(components: [.year, .month, .day])
    }
    public func getDayEnd()->Date?{
        let dayBegin = getDayBegin()!
        let nextDay = dayBegin.add(days:1)!
        return nextDay.add(nanos: -1)
    }
    public func getMonthBegin()->Date?{
       return extract(components: [.year, .month])
    }
    public func getMonthEnd()->Date?{
        let monthBegin = getMonthBegin()!
        let nextMonth = monthBegin.add(months:1)!
        return nextMonth.add(nanos: -1)
    }
    public func add(months:Int)->Date?{
        return Calendar.current.date(byAdding: .month,value: months, to: self)
    }
    public func add(days:Int)->Date?{
        return Calendar.current.date(byAdding: .day,value: days, to: self)
    }
    public func add(seconds:Int)->Date?{
        return Calendar.current.date(byAdding: .second,value: seconds, to: self)
    }
    public func add(nanos:Int)->Date?{
        return Calendar.current.date(byAdding: .nanosecond,value: nanos, to: self)
    }
    public func add(years:Int)->Date?{
        return Calendar.current.date(byAdding: .year,value: years, to: self)
    }
    public var daysInMonth:Int{
        get{
            return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
        }
    }
    public var day:Int{
        get{
            return extract(component: .day) ?? 0
        }
    }
    public var month:Int{
        get{
            return extract(component: .month) ?? 0
        }
    }
    public var year:Int{
        get{
            return extract(component: .year) ?? 0
        }
    }
    public func set(day:Int)->Date?{
        return Calendar.current.date(bySetting: .day, value: day, of: self)
    }
    public func set(month:Int)->Date?{
        
        return Calendar.current.date(bySetting: .month, value: month, of: self)
    }
    public func set(year:Int)->Date?{
        return Calendar.current.date(bySetting: .year, value: year, of: self)
    }
}
