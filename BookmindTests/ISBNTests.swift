//
//  ISBNTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 1/15/24.
//

import XCTest
@testable import Bookmind

final class ISBNTests: XCTestCase {
	func testEmpty() {
		let isbn = ISBN("")
		XCTAssertNil(isbn)
	}
	
	func testInvalidLength() {
		var isbn = ISBN("SBN 425-0")
		XCTAssertNil(isbn)
		
		isbn = ISBN("ISBN 425-0")
		XCTAssertNil(isbn)
		
		isbn = ISBN("ISBN: 425-0")
		XCTAssertNil(isbn)
		
		isbn = ISBN("SBN 425-0978-3-16-148410-0")
		XCTAssertNil(isbn)
		
		isbn = ISBN("ISBN 425-0978-3-16-148410-0")
		XCTAssertNil(isbn)
		
		isbn = ISBN("ISBN: 425-0978-3-16-148410-0")
		XCTAssertNil(isbn)
	}
	
	func testMissing() {
		let isbn = ISBN("Stormbringer by Michael Moorcock")
		XCTAssertNil(isbn)
	}

	func testSuffix() {
		let isbn = ISBN.Preview.prefix
		XCTAssertEqual(isbn?.displayString, "425-03071-7")
		XCTAssertEqual(isbn?.digitString, "425030717")
	}
	
	func testPrefix() {
		let isbn = ISBN.Preview.suffix
		XCTAssertEqual(isbn?.displayString, "425-03071-7")
		XCTAssertEqual(isbn?.digitString, "425030717")
	}
	
	func testSBN() {
		let isbn = ISBN.Preview.sbn
		XCTAssertEqual(isbn?.displayString, "425-03071-7")
		XCTAssertEqual(isbn?.digitString, "425030717")
	}
	
	func testISBN10() {
		let isbn = ISBN.Preview.isbn10
		XCTAssertEqual(isbn?.displayString, "0-441-78754-1")
		XCTAssertEqual(isbn?.digitString, "0441787541")
	}
	
	func testISBN13() {
		let isbn = ISBN.Preview.isbn13
		XCTAssertEqual(isbn?.displayString, "978-3-16-148410-0")
		XCTAssertEqual(isbn?.digitString, "9783161484100")
	}
	
	func testCopyright() {
		let isbn = ISBN.Preview.copyright
		XCTAssertEqual(isbn?.displayString, "0-441-78754-1")
		XCTAssertEqual(isbn?.digitString, "0441787541")
	}
}
