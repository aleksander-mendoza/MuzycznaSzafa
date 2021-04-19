//
//  MuzSzafaMacUITests.swift
//  MuzSzafaMacUITests
//
//  Created by Alagris on 22/03/2018.
//  Copyright © 2018 alagris. All rights reserved.
//

import XCTest

class MuzSzafaMacUITests: XCTestCase {
	var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		app = XCUIApplication()
		app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

		//////////////////
		///variables
		//////////////////
		let app = XCUIApplication()
		let menuBarsQuery = app.menuBars
		let muzszafaWindow = XCUIApplication().windows["MuzSzafa"]
//		let dataMenuBarItem = menuBarsQuery.menuBarItems["Data"]
		let newClientMenuItem = menuBarsQuery.menuItems["New client"]
		let instrumentTable = muzszafaWindow.tables
			.containing(.tableColumn, identifier:"instrumentName")
			.element
		let clientTable = muzszafaWindow.tables
			.containing(.tableColumn, identifier:"surname")
			.element
		let propertyTablesQuery = muzszafaWindow.tables.containing(.tableColumn, identifier:"main")
		//////////////////
		///purging
		//////////////////
		menuBarsQuery.menuItems["Purge"].click()
		XCUIApplication().dialogs["alert"].buttons["OK"].click()
		
		//////////////////
		///adding client
		//////////////////
		newClientMenuItem.click()
		
		
		
		
		let textFieldName = propertyTablesQuery.children(matching: .tableRow).element(boundBy: 1).cells.children(matching: .textField).element
		textFieldName.click()
		muzszafaWindow.tables.containing(.tableColumn, identifier:"name").children(matching: .tableRow).element(boundBy: 0).children(matching: .cell).element(boundBy: 0).typeText("testName")
		
		let textFieldSurname = propertyTablesQuery.children(matching: .tableRow).element(boundBy: 2).cells.children(matching: .textField).element
		textFieldSurname.click()
		muzszafaWindow.tables.containing(.tableColumn, identifier:"surname").children(matching: .tableRow).element(boundBy: 0).children(matching: .cell).element(boundBy: 0).typeText("testSurame")
		
		//////////////////
		///testing client
		//////////////////
		
		let clients1stRow = clientTable.tableRows.element(boundBy: 0)
		XCTAssertEqual(clients1stRow.cells.element(boundBy: 0).staticTexts.element(boundBy: 0).value as! String, "testName")
		XCTAssertEqual(clients1stRow.cells.element(boundBy: 1).staticTexts.element(boundBy: 0).value as! String, "testSurame")
		//////////////////
		///adding instrument
		//////////////////
		
		menuBarsQuery.menuItems["New instrument"].click()
		
		let cell = muzszafaWindow.tables.containing(.tableColumn, identifier:"name").tableRows.children(matching: .cell).element(boundBy: 0)
		cell.typeText("newId")
		
		let sheetsQuery = muzszafaWindow.sheets
		sheetsQuery.children(matching: .textField).element(boundBy: 1).click()
		cell.typeText("newType")
		
		let doneButton = sheetsQuery.buttons["Done"]
		doneButton.click()
		
		let newtypeStaticText = muzszafaWindow.tables.staticTexts["newType"]
		newtypeStaticText.click()
		
		propertyTablesQuery.children(matching: .tableRow).element(boundBy: 1).cells.children(matching: .textField).element.click()
		cell.typeText("physicalId")
		propertyTablesQuery
			.children(matching: .tableRow).element(boundBy: 2)
			.cells.children(matching: .textField).element.click()
		cell.typeText("testName")
		propertyTablesQuery.children(matching: .tableRow)
			.element(boundBy: 4).cells
			.children(matching: .textField).element.click()
		cell.typeText("4")
		newtypeStaticText.click()
		//////////////////
		///testing instrument
		//////////////////
		
		let instrument1stRow = instrumentTable.tableRows
			.element(boundBy: 0)
		XCTAssertEqual(instrument1stRow.cells.element(boundBy: 0)
			.staticTexts.element(boundBy: 0).value as! String, "testName")
		XCTAssertEqual(instrument1stRow.cells.element(boundBy: 1)
			.staticTexts.element(boundBy: 0).value as! String, "newType")
		XCTAssertEqual(instrument1stRow.cells.element(boundBy: 2)
			.staticTexts.element(boundBy: 0).value as! String, "4")
		XCTAssertEqual(instrument1stRow.cells.element(boundBy: 3)
			.staticTexts.element(boundBy: 0).value as! String, "newId")
		XCTAssertEqual(instrument1stRow.cells.element(boundBy: 4)
			.staticTexts.element(boundBy: 0).value as! String, "physicalId")
		
		//////////////////
		///adding deal
		//////////////////
		
		
//		instrument1stRow.click(forDuration: TimeInterval(exactly: 1)!, thenDragTo: clients1stRow)
		
		//////////////////
		///loading archive
		//////////////////
		
		
		menuBarsQuery.menuItems["Archive"].menuItems["Import"].click()
		
		let textField = app.browsers["ColumnView"].scrollViews.otherElements.children(matching: .group).element(boundBy: 0).children(matching: .textField).element
		textField.doubleClick()
		
		muzszafaWindow.typeKey("f", modifierFlags:.command)
		muzszafaWindow.tables.buttons["add filters"].click()
		
		
		XCUIApplication().windows["MuzSzafa"].tables
			.containing(.tableColumn, identifier:"main")
			.children(matching: .tableRow)
			.element(boundBy: 1).checkBoxes["id"].click()
		XCUIApplication().windows["MuzSzafa"].tables
			.buttons["Done"].click()
		
		muzszafaWindow.tables.containing(.tableColumn, identifier:"main")
			.children(matching: .tableRow).element(boundBy: 1)
			.cells.children(matching: .textField).element.click()
		muzszafaWindow.tables
			.containing(.tableColumn, identifier:"name")
			.children(matching: .tableRow).element(boundBy: 0)
			.children(matching: .cell)
			.element(boundBy: 0).typeText("13")
		XCUIApplication().windows["MuzSzafa"].tables.buttons["filter now!"].click()
		
	}
    
}
