//
//  CSVTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 06/11/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared

class CSVTest: XCTestCase {
	
	
	func testExample() {
		let str = """
a,b,c
a1,b1,c1,d1
a2,"b,2", c2 ,\td2
"a
3", "b""3" ,,
"""
		print(str)
		let reader = CSVReader(data: str)
		let rows = reader.nextNRowsAsArr(n: 20)
		XCTAssertEqual(rows![0][0],"a")
		XCTAssertEqual(rows![0][1],"b")
		XCTAssertEqual(rows![0][2],"c")
		XCTAssertEqual(rows![0].count,3)
		
		XCTAssertEqual(rows![1][0], "a1")
		XCTAssertEqual(rows![1][1], "b1")
		XCTAssertEqual(rows![1][2], "c1")
		XCTAssertEqual(rows![1][3], "d1")
		XCTAssertEqual(rows![1].count,4)
		
		XCTAssertEqual(rows![2][0], "a2")
		XCTAssertEqual(rows![2][1], "b,2")
		XCTAssertEqual(rows![2][2], " c2 ")
		XCTAssertEqual(rows![2][3], "\td2")
		XCTAssertEqual(rows![2].count,4)
		
		XCTAssertEqual(rows![3][3], "")
		XCTAssertEqual(rows![3][0], "a\n3")
		XCTAssertEqual(rows![3][1], " b\"3 ")
		XCTAssertEqual(rows![3][2], "")
		XCTAssertEqual(rows![3].count,4)
	}
	
	
	
	func testExample2() {
		let str = """


"""
		print(str)
		let reader = CSVReader(data: str)
		let rows = reader.nextNRowsAsArr(n: 20)
		XCTAssert(rows![0].isEmpty)
		XCTAssert(rows![1].isEmpty)
		XCTAssertEqual(rows!.count, 2)
	}
	
	
	func testExample3() {
		let str = """
,,,,,
,,,,,

"""
		print(str)
		let reader = CSVReader(data: str)
		let rows = reader.nextNRowsAsArr(n: 20)
		for i in 0..<2{
			for j in 0..<6{
				XCTAssert(rows![i][j].isEmpty,"i=\(i),j=\(j)")
			}
			XCTAssertEqual(rows![i].count,6)
		}
	}
	
	
	
	
	
	func testExample4() {
		let str = """
"\""\""","
\t\t
","',&*(%$",""
"""
		print(str)
		let reader = CSVReader(data: str)
		let rows = reader.nextNRowsAsArr(n: 20)
		XCTAssertEqual(rows![0][0], "\"\"")
		XCTAssertEqual(rows![0][1], "\n\t\t\n")
		XCTAssertEqual(rows![0][2], "',&*(%$")
		XCTAssertEqual(rows![0][3], "")
		XCTAssertEqual(rows![0].count,4)
		
		XCTAssertEqual(rows!.count,1)
		
	}

	func testExample5() {
		let str = """
a
b

c
d


"""
		print(str)
		let reader = CSVReader(data: str)
		let rows = reader.nextNRowsAsArr(n: 20)
		XCTAssertEqual(rows![0], ["a"])
		XCTAssertEqual(rows![1], ["b"])
		XCTAssertEqual(rows![2], [])
		XCTAssertEqual(rows![3], ["c"])
		XCTAssertEqual(rows![4], ["d"])
		XCTAssertEqual(rows![5], [])
		XCTAssertEqual(rows![6], [])
		XCTAssertEqual(rows!.count,7)
	}
}
