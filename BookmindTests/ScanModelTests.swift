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
    func testEmpty() {
		let model = ScanModel()
		XCTAssertEqual(model.state, .searching)
    }
	
	func testFailed() {
		let model = ScanModel()
		model.state = .failed("failed")
		XCTAssertEqual(model.state, .failed("failed"))
	}
	
	func testInvalidAdd() {
		let model = ScanModel()
		model.didAdd("test")
		XCTAssertEqual(model.state, .searching)
	}
	
	func testValidAdd() {
		let model = ScanModel()
		let isbn = "ISBN 978-0-30735-215-6"
		model.didAdd(isbn)
		// the update is async, todo: figure out how to test
		XCTAssertEqual(model.state, .searching)
	}
}
