//
//  CoreDataMoneySerializerTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 11/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared

class CoreDataMoneySerializerTest: XCTestCase {
	
	
	func testExample1() {
		let ser = CoreDataMoneySerializer()
		XCTAssertEqual(ser.deserialize("30"), 3000)
		XCTAssertEqual(ser.deserialize("30.30"), 3030)
		XCTAssertEqual(ser.deserialize("0000.30"), 30)
		XCTAssertEqual(ser.deserialize(".30"), 30)
		XCTAssertEqual(ser.deserialize(".99"), 99)
		XCTAssertEqual(ser.deserialize(""), 0)
		XCTAssertEqual(ser.deserialize("."), 0)
		XCTAssertEqual(ser.deserialize(".00"), 0)
		XCTAssertEqual(ser.deserialize("00.00"), 0)
		XCTAssertEqual(ser.deserialize("00."), 0)
		XCTAssertEqual(ser.deserialize("400."), 40000)
	}
	func testExample2() {
		let ser = CoreDataMoneySerializer()
		XCTAssertEqual(ser.serialize(3000), "30.00")
		XCTAssertEqual(ser.serialize(3030), "30.30")
		XCTAssertEqual(ser.serialize(30), "0.30")
		XCTAssertEqual(ser.serialize(30), "0.30")
		XCTAssertEqual(ser.serialize(99), "0.99")
		XCTAssertEqual(ser.serialize(0), "0.00")
		XCTAssertEqual(ser.serialize(40000), "400.00")
	}
}
