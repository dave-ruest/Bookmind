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
	
	func testSBN_() {
		let isbn = ISBN.Preview.sbn_
		XCTAssertEqual(isbn?.displayString, "425-03585-9")
		XCTAssertEqual(isbn?.digitString, "425035859")
	}
	
	func testISBNX() {
		var isbn = ISBN.Preview.isbnx
		XCTAssertEqual(isbn?.displayString, "0-00-653192-x")
		XCTAssertEqual(isbn?.digitString, "000653192x")
		
		isbn = ISBN.Preview.isbnX
		XCTAssertEqual(isbn?.displayString, "1-55192-756-X")
		XCTAssertEqual(isbn?.digitString, "155192756X")
	}

	func testISBN10() {
		var isbn = ISBN.Preview.isbn10
		XCTAssertEqual(isbn?.displayString, "0-441-78754-1")
		XCTAssertEqual(isbn?.digitString, "0441787541")
		
		isbn = ISBN.Preview.isbn_10
		XCTAssertEqual(isbn?.displayString, "0-7582-8393-8")
		XCTAssertEqual(isbn?.digitString, "0758283938")
	}
	
	func testISBN13() {
		var isbn = ISBN.Preview.isbn13
		XCTAssertEqual(isbn?.displayString, "978-3-16-148410-0")
		XCTAssertEqual(isbn?.digitString, "9783161484100")
		
		isbn = ISBN.Preview.isbn_13
		XCTAssertEqual(isbn?.displayString, "978-0-7783-3027-1")
		XCTAssertEqual(isbn?.digitString, "9780778330271")
	}
	
	func testCopyright() {
		let isbn = ISBN.Preview.copyright
		XCTAssertEqual(isbn?.displayString, "0-441-78754-1")
		XCTAssertEqual(isbn?.digitString, "0441787541")
	}
}
