//
//  CoreDataRelatTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 16/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared

class CoreDataRelatTest: XCTestCase {
	
	func test() throws{
		CoreContext.shared.purge()
		
		let c1 = Client.cast(Client.ent.new(pk: 1))!
		c1.name = "Boris"
		c1.surname = "Zarovich"
		c1.tel = "4357678"
		let c2 = Client.cast(Client.ent.new(pk: 2))!
		c2.name = "Maria"
		c2.surname = "Cheroux"
		c2.tel = "1256578"
		
		let i1 = Instrument.cast(Instrument.ent.new(pk: "i;\\1"))!
		i1.instrumentName = "Abc"
		i1.size = "1/4"
		i1.deposit = 1000
		i1.fee = 1300
		let i2 = Instrument.cast(Instrument.ent.new(pk: "i;\\2"))!
		i2.instrumentName = "Hdc"
		i2.size = "4"
		i2.deposit = 4000
		i2.fee = 1500
		
		let d1:Deal =  Deal.cast(Deal.ent.new(pk: "1"))!
		d1.client = c1
		d1.addToInstrument(i1)
		d1.addToInstrument(i2)
		d1.deposit = 4500
		
		let p1 = Payment.cast(Payment.ent.new(pk: 1))!
		p1.deal = d1
		p1.paid = true
		p1.money_amount = 4000
		let p2 = Payment.cast(Payment.ent.new(pk: 2))!
		p2.deal = d1
		p2.paid = false
		p2.money_amount = 5000
		let p3 = Payment.cast(Payment.ent.new(pk: 3))!
		p3.deal = d1
		p3.paid = true
		p3.money_amount = 6000
		func assertData(msg:String){
			XCTAssertEqual(Deal.ent.count(),1,msg)
			XCTAssertEqual(Instrument.ent.count(),2,msg)
			XCTAssertEqual(Client.ent.count(),2,msg)
			XCTAssertEqual(Payment.ent.count(),3,msg)
			let deals = Deal.ent.fetch()
			let ids = deals?.map(){
				($0 as! Deal).id
			}
			XCTAssertEqual(ids!.count,1)
//			XCTAssertEqual(ids![0],"1")
			let d1 =  Deal.cast(Deal.ent.getFirst("1"))!
			let all = Instrument.ent.fetch()!
			debugPrint(all)
			let i1 = Instrument.cast(Instrument.ent.getFirst("i;\\1"))!
			let i2 = Instrument.cast(Instrument.ent.getFirst("i;\\2"))!
			let c1 = Client.cast(Client.ent.getFirst(1))!
			let c2 = Client.cast(Client.ent.getFirst(2))!
			let p1 = Payment.cast(Payment.ent.getFirst(1))!
			let p2 = Payment.cast(Payment.ent.getFirst(2))!
			let p3 = Payment.cast(Payment.ent.getFirst(3))!
			XCTAssert(d1.instrument!.contains(i1), msg)
			XCTAssert(d1.instrument!.contains(i2), msg)
			XCTAssertEqual(d1.instrument!.count, 2, msg)
			XCTAssert(d1.payment!.contains(p1), msg)
			XCTAssert(d1.payment!.contains(p2), msg)
			XCTAssert(d1.payment!.contains(p3), msg)
			XCTAssertEqual(d1.payment!.count, 3)
			XCTAssertEqual(c1.name, "Boris", msg)
			XCTAssertEqual(c1.surname, "Zarovich", msg)
			XCTAssertEqual(c1.tel, "4357678", msg)
			XCTAssertEqual(c2.name, "Maria", msg)
			XCTAssertEqual(c2.surname, "Cheroux", msg)
			XCTAssertEqual(c2.tel, "1256578", msg)
			XCTAssertEqual(i1.instrumentName, "Abc", msg)
			XCTAssertEqual(i1.size, "1/4", msg)
			XCTAssertEqual(i1.deposit, 1000, msg)
			XCTAssertEqual(i1.fee, 1300, msg)
			XCTAssertEqual(i2.instrumentName, "Hdc", msg)
			XCTAssertEqual(i2.size, "4", msg)
			XCTAssertEqual(i2.deposit, 4000, msg)
			XCTAssertEqual(i2.fee, 1500, msg)
			XCTAssertEqual(d1.deposit, 4500, msg)
			XCTAssertEqual(p1.paid, true, msg)
			XCTAssertEqual(p1.money_amount, 4000, msg)
			XCTAssertEqual(p2.paid, false, msg)
			XCTAssertEqual(p2.money_amount, 5000, msg)
			XCTAssertEqual(p3.paid, true, msg)
			XCTAssertEqual(p3.money_amount, 6000, msg)
		}
		assertData(msg:"ORIGINAL")
		let file = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("delete_me.archive")
		do{
			_ = try OutputStream.doWith(url: file){
				do{
					try CoreContext.shared.cache.exportArchive(stream: $0)
				}catch let e{
					XCTFail(e.localizedDescription)
				}
			}
		}catch let e{
			XCTFail(e.localizedDescription)
		}
		
		CoreContext.shared.purge()
		do{
			try CoreContext.shared.cache.importArchive(file: file)
		}catch let e{
			XCTFail(e.localizedDescription)
		}
		do{
			try FileManager.default.removeItem(at: file)
		}catch let e{
			XCTFail(e.localizedDescription)
		}
		assertData(msg:"LOADED")
		
	}
}
