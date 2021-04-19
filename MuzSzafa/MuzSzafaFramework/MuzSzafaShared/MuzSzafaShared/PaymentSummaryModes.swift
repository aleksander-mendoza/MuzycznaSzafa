//
//  PaymentSummaryModes.swift
//  MuzSzafaShared
//
//  Created by Alagris on 20/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation
import CoreData
public func updatePaymentSummary(mode:Int, date:Date, table:EntFilteredRecordsTable)->(Int64,Int64){
	
	func settlementDayFilter(_ mo:NSManagedObject)->Bool{
		let pay = Payment.cast(mo)!
		let deal = pay.deal
		let out = deal?.isCheckoutDay(date)
		return out ?? false
	}
	switch mode {
	case 0:
		table.pred = Payment.safePred(Payment.filter(validAt: date))
		table.filter = nil
	case 1:
		table.pred = Payment.safePred(Payment.filter(validAtDay: date))
		table.filter = nil
	case 2:
		table.pred = Payment.safePred(Payment.filter(validAtMonth: date))
		table.filter = nil
	case 3:
		table.pred = Payment.safePred(Payment.filter(validAtMonth: date))
		table.filter = settlementDayFilter
	case 4:
		table.pred = Payment.safePred(Payment.filter(validAtPaymentDay: date))
		table.filter = nil
	case 5:
		table.pred = Payment.safePred(Payment.filter(endsAtDay: date))
		table.filter = nil
	case 6:
		table.pred = Payment.safePred(Payment.filter(endsAtMonth: date))
		table.filter = nil
	case 7:
		table.pred = Payment.safePred(Payment.filter(endsAtMonth: date))
		table.filter = settlementDayFilter
	default:
		table.pred = Payment.safePred(Payment.filter(validAt: date))
		table.filter = nil
	}
	table.reloadData()
	var sum:Int64 = 0
	var realSum:Int64 = 0
	for obj in table.filteredObjects.converted(with: {Payment.cast($0)!}){
		sum += obj.money_amount
		if obj.paid{
			realSum += obj.money_amount
		}
	}
	return (sum,realSum)
}
