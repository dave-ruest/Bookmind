//
//  ScanModelTests.swift
//  ScanModelTests
//
//  Created by Dave Ruest on 1/1/24.
//

import XCTest
import VisionKit
@testable import Bookmind

final class ScanModelTests: XCTestCase {
    func testEmptyIsbn() {
		let model = ScanModel()
		XCTAssertNil(model.isbn)
		XCTAssertEqual(model.error, "Scanning...")
    }
	
	func testIsbn() {
		let model = ScanModel(isbn: "4")
		XCTAssertEqual(model.isbn, "4")
		XCTAssertNil(model.error)
	}
	
	@MainActor func testStart() {
		let model = ScanModel()
		let scanner = DataScannerViewController(recognizedDataTypes: [])
		model.start(scanner)
		XCTAssertEqual(model.error, "Could not open scanner")
	}
	
//	@MainActor func testAddedItem() {
//		let model = ScanModel()
//		// alas, no accessible initializers
//		let item = RecognizedItem.barcode(RecognizedItem.Barcode("5"))
//		let scanner = DataScannerViewController(recognizedDataTypes: [])
//		model.dataScanner(scanner, didAdd: [item], allItems: [item])
//		XCTAssertEqual(model.isbn, "5")
//	}
}
