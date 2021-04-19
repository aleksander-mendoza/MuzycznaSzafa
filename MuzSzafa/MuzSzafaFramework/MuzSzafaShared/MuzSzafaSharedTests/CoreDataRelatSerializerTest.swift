//
//  CoreDataSerializerTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 16/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared
class CoreDataRelatSerializerTest: XCTestCase {

    func testExample() {
		CoreContext.shared.purge()
		let a = CoreContext.shared.cache.find("Deal")!.find(attr: "instrument")!
		let i = CoreContext.shared.cache.find("Instrument")!
		let i1 = i.ensureExists("1")
		let i2 = i.ensureExists("2")
		let i3 = i.ensureExists("3")
		let ser = a.serializer as! CoreDataRelatToManySerializer
		let set = ser.deserialize(any: "1;2;3") as! NSSet
		XCTAssert(set.contains(i1))
		XCTAssert(set.contains(i2))
		XCTAssert(set.contains(i3))
		XCTAssertEqual(set.count,3)
    }


}
