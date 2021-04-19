//
//  Deal.swift
//  MuzSzafaShared
//
//  Created by Alagris on 01/05/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import CoreData

public extension Deal{
    public enum Status:Int16{
        case Negotiated = 0
        case Settled = 1
        case TerminationDeclared = 2
        case Terminated = 3
        case Unsuccessful = 4
    }
	
	public static var ent:CoreDataEntity{
		get{
			return CoreContext.find(ent: "Deal")!
		}
	}
	
	public static var from:CoreDataAttrEntry{
		get{
			return ent.find(attr: "from")! as! CoreDataAttrEntry
		}
	}
	
	public static var status:CoreDataAttrEntry{
		get{
			return ent.find(attr: "status")! as! CoreDataAttrEntry
		}
	}
	
	public static var client:CoreDataRelatEntry{
		get{
			return ent.find(attr: "client")! as! CoreDataRelatEntry
		}
	}
	
	public static var payment:CoreDataRelatEntry{
		get{
			return ent.find(attr: "payment")! as! CoreDataRelatEntry
		}
	}
	
	public static var instrument:CoreDataRelatEntry{
		get{
			return ent.find(attr: "instrument")! as! CoreDataRelatEntry
		}
	}
	
	func delete(_ cntx:NSManagedObjectContext)->String?{
		if payment?.count ?? 0 == 0{
			cntx.delete(self)
			return nil
		}
		return "cant_delete_deal_with_payments"
	}
	
    func filterPayments()->SafePredicate.Node{
//        let args:[Any] = ["deal",self]
//        let format = "%K == %@"
//        let pred = NSPredicate(format:format , argumentArray: args)
        return Payment.deal.equals(self)
    }
    func filterPayments(for date:Date)->SafePredicate.Node{
//        let args:[Any] = ["term_begin",date,date,"term_end","deal",self]
//        let format = "%K < %@ && %@ < %K && %K == %@"
//        let pred = NSPredicate(format:format , argumentArray: args)
        return Payment.deal.equals(self)
			.and(Payment.term_begin.lt(date))
			.and(Payment.term_end.gt(date))
    }
    func filterPayments(paid:Bool)->SafePredicate.Node{
//        let args:[Any] = ["paid",paid,"deal",self]
//        let format = "%K == %@ && %K == %@"
//        let pred = NSPredicate(format:format , argumentArray: args)
//        return pred
		return Payment.deal.equals(self).and(Payment.paid.equals(paid))
    }
//    func payments(for date:Date)->NSFetchedResultsController<NSManagedObject>{
//        let pred = filterPayments(for: date)
//        let out = Payment.ent.makeReqController(pred: pred)
//        return out
//    }
    func lastPayment()->Payment?{
        let out = Payment.safePred(filterPayments()).max(Payment.term_end)
        return Payment.cast(out)
    }
	
	internal static var filterValidArgsWithoutDate:[Any]{
		get{
			return ["status",1,"status",2]
		}
	}
	internal static var filterValidFormatWithoutDate:String{
		get{
			return "%K == %@ || %K == %@"
		}
	}
	
    internal static func filterValidArgs(for date:Date)->[Any]{
        return ["from",date,"status",1,"status",2]
    }
    internal static var filterValidFormat:String{
        get{
            return "%K < %@ && ( %K == %@ || %K == %@ )"
        }
    }
    static func filterValid(for date:Date)->SafePredicate.Node{
//        let pred = NSPredicate(format:filterValidFormat ,
//                               argumentArray: filterValidArgs(for: date))
//        return pred
		return from.lt(date).and(status.equals(1).or(status.equals(2)))
    }
	
    static func filterValidButWithoutPayment(for date:Date) -> SafePredicate.Node{
//        let f = filterValidFormat +
//        """
//        &&
//        SUBQUERY(payment,
//                $r,
//                $r.term_begin <= %@ && %@ < $r.term_end
//        ).@count == 0
//        """
//        let a = filterValidArgs(for: date) + [date,date]
//        let pred = NSPredicate(format: f,argumentArray: a)
//        return pred
		
		return filterValid(for:date).and(Deal.payment.subquery(using: "$r", Payment.term_begin.le(date, using:"$r").and(Payment.term_end.gt(date, using:"$r"))).count().equals(0))
    }
    
    
    public var isValid:Bool{
        get{
            return status == 1 || status == 2
        }
    }
    
    //    public func getExpirationDate() -> Date?{
    //        return from?.add(months: Int(paidMonths))
    //    }
    //    public func getExpirationMonth() -> Date?{
    //        return getExpirationDate()?.getMonthBegin()
    //    }
//    public func getFromMonthBegin() -> Date?{
//        return from?.getMonthBegin()
//    }
    public func getCheckoutDay(inMonth date:Date)->Date?{
        let arr:[Calendar.Component] = [.year,.month,.day]
        let comps = Set(arr)
        var c = Calendar.current.dateComponents(comps, from: date)
        if let d = getCheckoutDay(ofMonth: date){
            c.day = d
        }
        let out = Calendar.current.date(from: c)
        return out
    }
    public func getCheckoutDay(ofMonth date:Date)->Int?{
        guard let from = from else{
            return nil
        }
        let daysInMonth = date.daysInMonth
        return min(from.day,daysInMonth)
    }
    public func isCheckoutDay(_ day:Date)->Bool{
        return day.day == getCheckoutDay(ofMonth: day) ?? -1
    }
    
//    public func isStillValid(at date:Date=Date()) -> Bool{
//        return payments(for: date).count > 0
//    }
    
    
//    public func isIncomeReceived(at date:Date=Date()) -> Bool{
//        return isCheckoutDay(date) && isStillValid(at: date)
//    }
//
    public func getInstrumentName() -> String?{
		guard let i = instrument else {return nil}
		if i.count  > 1{
			return getLocalizedString(for: "multiple_values")
		}
		if i.count == 0{
			return getLocalizedString(for: "no_value")
		}
		return Instrument.cast(i.firstElem)!.instrumentName
    }
    
    public func getInstrumentTypeName() -> String?{
		guard let i = instrument else {return nil}
		if i.count  > 1{
			return getLocalizedString(for: "multiple_values")
		}
		if i.count == 0{
			return getLocalizedString(for: "no_value")
		}
		return Instrument.cast(i.firstElem)!.getTypeName()
    }
    
    public func getClientName() -> String?{
        return client?.name
    }
    
    public func getClientSurname() -> String?{
        return client?.surname
    }
    public func getUnpaidPayments() -> [Payment]?{
        return payment?.filter(){!Payment.cast($0)!.paid} as! [Payment]?
    }
    public var unpaidPaymentsSum:Int64{
        get{
            return getUnpaidPayments()?.summed(){$0.money_amount} ?? 0
        }
    }
//    public static func monthlyFilter(with date:Date)->(Any)->Bool{
//        return {
//            (_ deal:Any)->Bool in
//            return (deal as! Deal).isStillValid(at:date)
//        }
//    }
//    public static func dailyFilter(with date:Date)->(Any)->Bool{
//        return {
//            (_ deal:Any)->Bool in
//            return (deal as! Deal).isIncomeReceived(at: date)
//        }
//    }
//    public static func filter(daily:Bool,with date:Date)->(Any)->Bool{
//        if daily{
//            return dailyFilter(with: date)
//        }else{
//            return monthlyFilter(with: date)
//        }
//    }
	
	public static func cast(_ any:Any)->Deal?{
		return cast(any, ent: CoreContext.find(ent:"Deal")!)
	}
	
	public static func cast(_ any:Any?)->Client?{
		return cast(any, ent: CoreContext.find(ent:"Client")!)
	}
    
	public static func cast(_ mo:NSManagedObject)->Deal?{
		return cast(mo, ent: CoreContext.find(ent:"Deal")!)
	}

	public static func cast(_ mo:NSManagedObject?)->Deal?{
		if let mo = mo{
			return cast(mo)
		}
		return nil
	}
	
	public static func safePred(_ expr:SafePredicate.Node)->SafePredicate{
		return SafePredicate(ent: ent, expr: expr)
	}
	
    public static func ensureExists(id: String,client:Client,instrument:NSSet) -> Deal{
        let mo = Deal.ent.ensureExists(id)
        let deal = Deal.cast(mo)!
		deal.client = client
		deal.addToInstrument(instrument)
		deal.pricing = {
			var sum:Int64 = 0
			for i in instrument{
				let inst = Instrument.cast(i)!
				sum += inst.fee
			}
			return sum
		}()
        let array:Set<Calendar.Component> = [.year,.month,.day]
        let components = Calendar.current.dateComponents(array, from:Date())
        deal.from = Calendar.current.date(from: components)
        return deal
    }
}



