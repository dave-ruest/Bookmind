//
//  ISBNTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 1/15/24.
//

import XCTest
@testable import Bookmind

final class ISBNTests: XCTestCase {
	static let sbn = "SBN 425-03071-7"
	static let isbn10 = "ISBN 0-441-78754-1"
	static let isbn13 = "ISBN 978-3-16-148410-0"
	
	func testEmpty() {
		let isbn = ISBN("")
		XCTAssertNil(isbn)
	}
	
	func testInvalidLength() {
		let isbn = ISBN("Stormbringer by Michael Moorcock")
		XCTAssertNil(isbn)
	}
	
	func testInvalidSuffix() {
		let isbn = ISBN(Self.sbn + " suffix")
		XCTAssertNil(isbn)
	}
	
	func testInvalidPrefix() {
		let isbn = ISBN("prefix " + Self.sbn)
		XCTAssertNil(isbn)
	}
	
	func testSBN() {
		let isbn = ISBN(Self.sbn)
		XCTAssertEqual(isbn?.displayString, Self.sbn)
		XCTAssertEqual(isbn?.digitString, "425030717")
	}
	
	func testISBN10() {
		let isbn = ISBN(Self.isbn10)
		XCTAssertEqual(isbn?.displayString, Self.isbn10)
		XCTAssertEqual(isbn?.digitString, "0441787541")
	}
	
	func testISBN13() {
		let isbn = ISBN(Self.isbn13)
		XCTAssertEqual(isbn?.displayString, Self.isbn13)
		XCTAssertEqual(isbn?.digitString, "9783161484100")
	}
}
