//
//  RtfPatternTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 16/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared
@testable import MuzSzafaMacFramework
@testable import MuzSzafaMac

class RtfPatternTest: XCTestCase {

    func test() {
		CoreContext.shared.purge()
		let c1 = Client.cast(Client.ent.new(pk:1))!
		c1.name = "Boris"
		c1.surname = "Zarovich"
		c1.tel = "4357678"
		let c2 = Client.cast(Client.ent.new(pk:2))!
		c2.name = "Maria"
		c2.surname = "Cheroux"
		c2.tel = "1256578"
		
		let t1 = InstrumentType.cast(InstrumentType.ent.new(pk: "Violin")!)
		let t2 = InstrumentType.cast(InstrumentType.ent.new(pk: "Viola")!)
		
		let i1:Instrument = Instrument.cast(Instrument.ent.new(pk:"i;\\1"))!
		i1.type = t1
		i1.instrumentName = "Abc"
		i1.size = "1/4"
		i1.deposit = 1000
		i1.fee = 1300
		let i2 = Instrument.cast(Instrument.ent.new(pk:"i;\\2"))!
		i2.type = t2
		i2.instrumentName = "Hdc"
		i2.size = "4"
		i2.deposit = 4000
		i2.fee = 1500
		
		let d1:Deal =  Deal.cast(Deal.ent.new(pk: "1"))!
		d1.client = c1
		d1.addToInstrument(i1)
		d1.addToInstrument(i2)
		d1.deposit = 4500
		d1.from = Calendar.current.date(from: DateComponents(year:2004, month:4, day:3))
		let p1 = Payment.cast(Payment.ent.new(pk: 1))!
		p1.deal = d1
		p1.paid = false
		p1.term_begin =  Calendar.current.date(from: DateComponents(year:2005, month:4, day:3))
		p1.term_end =  Calendar.current.date(from: DateComponents(year:2005, month:5, day:3))
		p1.money_amount = 4000
		let p2 = Payment.cast(Payment.ent.new(pk: 2))!
		p2.deal = d1
		p2.paid = true
		p2.term_begin =  Calendar.current.date(from: DateComponents(year:2005, month:5, day:3))
		p2.term_end =  Calendar.current.date(from: DateComponents(year:2005, month:6, day:3))
		p2.money_amount = 5000
		let p3 = Payment.cast(Payment.ent.new(pk: 3))!
		p3.deal = d1
		p3.paid = false
		p3.term_begin =  Calendar.current.date(from: DateComponents(year:2005, month:6, day:3))
		p3.term_end =  Calendar.current.date(from: DateComponents(year:2005, month:7, day:3))
		p3.money_amount = 6000
		
		XCTAssertEqual(d1.payment!.count, 3)
		XCTAssertEqual(d1.getUnpaidPayments()!.count, 2)
		
		let p = DealTemplateProcessor(deal:d1)
		let bundle = Bundle(for: type(of: self))
		let path = bundle.url(forResource: "warning_email", withExtension: "rtfd")!
		let template = try! NSMutableAttributedString(url: path, options: [:], documentAttributes: nil)
		let result = p.generateAttrString(tempalte: template)
		let EXPORT_TMP_TRF_FILE_FOR_DEBUG = false
		if EXPORT_TMP_TRF_FILE_FOR_DEBUG{
			let tmpOutput = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("delete_me.rtf")
			try! result.rtf(from: result.totalRange, documentAttributes: [:])?.write(to: tmpOutput)
			//When debugging, put a breakpoint here
			try! FileManager.default.removeItem(at: tmpOutput)
		}
		XCTAssertTrue(result.string.contains("Viola \nHdc\n1\ni;\\2\n4\n"))
		XCTAssertTrue(result.string.contains("Violin \nAbc\n1\ni;\\1\n1/4\n"))
		XCTAssertTrue(result.string.contains("""
03-06-2005 - 03-07-2005
1
60.00
60.00
"""))
		XCTAssertTrue(result.string.contains("""
03-04-2005 - 03-05-2005
1
40.00
40.00
"""))
		XCTAssertTrue(result.string.contains("""
Łącznie
600 zł
"""))
		XCTAssertTrue(result.string.contains("""
Najemca:
Umowa najmu nr 1 z dnia 03-04-2004
Instrumenty:
"""))
    }

}
