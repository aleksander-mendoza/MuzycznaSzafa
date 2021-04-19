//
//  CoreDataDateSerializerTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 10/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import Foundation

import XCTest
@testable import MuzSzafaShared

class CoreDataDateSerializerTest: XCTestCase {
	
	
	
	func test1() {
		let ser = CoreDataDateSerializer()
		let str:String = "10/$%^1/^&*%$2018"
		let day:Int? = 10
		let month:Int? = 1
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test2() {
		let ser = CoreDataDateSerializer()
		let str:String = "10Jan2018"
		let day:Int? = 10
		let month:Int? = 1
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	func test3() {
		let ser = CoreDataDateSerializer()
		let str:String = "10January2018"
		let day:Int? = 10
		let month:Int? = 1
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	func test4() {
		let ser = CoreDataDateSerializer()
		let str:String = "10March2018"
		let day:Int? = 10
		let month:Int? = 3
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	func test5() {
		let ser = CoreDataDateSerializer()
		let str:String = "10Apr2018"
		let day:Int? = 10
		let month:Int? = 4
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test6() {
		let ser = CoreDataDateSerializer()
		let str:String = "2018Apr18"
		let day:Int? = 18
		let month:Int? = 4
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test7() {
		let ser = CoreDataDateSerializer()
		let str:String = "2018 2 18"
		let day:Int? = 18
		let month:Int? = 2
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test8() {
		let ser = CoreDataDateSerializer()
		let str:String = "2 18 2018"
		let day:Int? = 18
		let month:Int? = 2
		let year:Int? = 2018
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test9() {
		let ser = CoreDataDateSerializer()
		let str:String = "2 18 19"
		let day:Int? = 18
		let month:Int? = 2
		let year:Int? = 2019
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test10() {
		let ser = CoreDataDateSerializer()
		let str:String = "2 3 4"
		let day:Int? = 2
		let month:Int? = 3
		let year:Int? = 2004
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test11() {
		let ser = CoreDataDateSerializer()
		let str:String = "13 3 4"
		let day:Int? = 13
		let month:Int? = 3
		let year:Int? = 2004
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	
	func test14() {
		let ser = CoreDataDateSerializer()
		let str:String = "13 14 4"
		let day:Int? = 13
		let month:Int? = 4
		let year:Int? = 2014
		let date = ser.deserialize(str)!
		if let day = day{
			XCTAssertEqual(day,date.day)
		}
		if let month = month{
			XCTAssertEqual(month,date.month)
		}
		if let year = year{
			XCTAssertEqual(year,date.year)
		}
		print("PARSED DATE=",date)
	}
	
	func test15() {
		let ser = CoreDataDateSerializer()
		let formatter = DateFormatter()
		let dates = ["01/04/2017",
					 "01/05/2017",
					 "01/06/2017",
					 "01/07/2017",
					 "01/08/2017",
					 "01/09/2017",
					 "01/10/2017",
					 "01/11/2017",
					 "01/12/2017",
					 "01/01/2018",
					 "01/02/2018",
					 "01/03/2018",
					 "01/04/2018",
					 "01/05/2018",
					 "01/06/2018",
					 "01/07/2018",
					 "01/08/2018",
					 "01/09/2018",
					 "01/10/2018",
					 "01/11/2018",
					 "01/12/2018",
					 "01/01/2019"]
		formatter.dateFormat = "dd/MM/yyyy"
		for date in dates{
			let s = formatter.string(from: ser.deserialize(date)!)
			XCTAssertEqual(s,date)
		}
	}
	
	func test16() {
		let ser = CoreDataDateSerializer()
		let formatter = DateFormatter()
		let dates = ["01/04/2017 20:12:30",
					 "01/04/2017 21:32:10",
					 "01/04/2017 01:01:10"]
		formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
		for date in dates{
			let s = formatter.string(from: ser.deserialize(date)!)
			XCTAssertEqual(s,date)
		}
	}
	
	func test17() {
		let ser = CoreDataDateSerializer()
		let str:String = ""
		let date = ser.deserialize(str)
		XCTAssertEqual(date,nil)
		print("PARSED DATE=",date)
	}
}
