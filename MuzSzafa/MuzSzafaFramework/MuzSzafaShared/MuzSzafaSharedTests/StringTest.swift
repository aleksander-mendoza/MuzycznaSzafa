//
//  StringTest.swift
//  MuzSzafaSharedTests
//
//  Created by Alagris on 16/12/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest
@testable import MuzSzafaShared
class StringTest: XCTestCase {
	
    func testSplitEscaped() {
		XCTAssertEqual(["abc","de","ghj"], "abc;de;ghj".split(separator: ";", escapeChar: "\\"))
		XCTAssertEqual(["c","e","j"], "c;e;j".split(separator: ";", escapeChar: "\\"))
		XCTAssertEqual(["","",""], ";;".split(separator: ";", escapeChar: "\\"))
		XCTAssertEqual(["abcdeghj"], "abcdeghj".split(separator: ";", escapeChar: "\\"))
		XCTAssertEqual(["abc;","de;","ghj;"], "abc\\;;de\\;;ghj\\;".split(separator: ";", escapeChar: "\\"))
		XCTAssertEqual([";","/","/;"], "/;;//;///;".split(separator: ";", escapeChar: "/"))
		XCTAssertEqual([";","\\","\\;"], "\\;;\\\\;\\\\\\;".split(separator: ";", escapeChar: "\\"))
    }

}
