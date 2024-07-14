//
//  BookTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 2024-07-14.
//

import XCTest
import SwiftData
@testable import Bookmind

final class BookTests: XCTestCase {
	@MainActor func testFetch() {
		let storage = StorageModel(preview: true)
		let edition = Edition.Preview.quiet
		let isbn = ISBN("ISBN " + edition.isbn)!
		var book = Book.fetch(isbn: isbn, storage: storage)
		XCTAssertNil(book)
		
		storage.insert(entity: edition)
		book = Book.fetch(isbn: isbn, storage: storage)
		XCTAssertNil(book)
		
		let work = Work.Preview.quiet
		edition.work = work
		storage.insert(entity: work)
		book = Book.fetch(isbn: isbn, storage: storage)
		XCTAssertNotNil(book)
	}
	
	func testEquals() {
		XCTAssertEqual(Book.Preview.legend, Book.Preview.legend)
		XCTAssertNotEqual(Book.Preview.quiet, Book.Preview.dorsai)
	}
}
