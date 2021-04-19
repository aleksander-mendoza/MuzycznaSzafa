//
//  CoreDataEntTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 16/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared

class CoreDataEntTest: XCTestCase {
	
	
	func test() {
		CoreContext.shared.purge()
		let clients =  CoreContext.shared.cache.find("Client")!
		let deals =  CoreContext.shared.cache.find("Deal")!
//		let instruments =  CoreContext.shared.cache.find("Instrument")!
//		let payments =  CoreContext.shared.cache.find("Payment")!
		let instrumentsID = clients.find(attr: "id")!
		XCTAssert(instrumentsID.serializer is CoreDataFlexibleSerializer,  "\(type(of:instrumentsID.serializer))")
		let dealsClient = deals.find(attr: "client")!
		XCTAssert(dealsClient.serializer is CoreDataRelatSerializer)
		let dealsInstrument = deals.find(attr: "instrument")!
		XCTAssert(dealsInstrument.serializer is CoreDataRelatToManySerializer)
	}
}
