//
//  AuthorTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 2024-06-04.
//

import XCTest
import SwiftData
@testable import Bookmind

final class AuthorTests: XCTestCase {
	func testDescription() {
		XCTAssertEqual(Author.Preview.cain.description, "Susan Cain")
	}

	func testFirstName() {
		XCTAssertEqual(Author.Preview.gemmell.firstName, "David")
	}
	
	func testLastName() {
		XCTAssertEqual(Author.Preview.dickson.lastName, "Dickson")
	}
	
	@MainActor func testIsStored() {
		let storage = StorageModel(preview: true)
		var author = Author.Preview.cain
		XCTAssertFalse(storage.isStored(entity: author))
		
		author = storage.insert(entity: author)
		XCTAssert(storage.isStored(entity: author))
	}
	
	@MainActor func testInsertPreservesOriginal() {
		let storage = StorageModel(preview: true)
		var author = storage.insert(entity: Author.Preview.gemmell)
		XCTAssertEqual(author.firstName, "David")
		
		author = Author(olid: author.id, name: "Not Gemmell")
		XCTAssertEqual(author.firstName, "Not")
		
		author = storage.insert(entity: author)
		// ensure an insert does not overwrite previously saved changes
		XCTAssertEqual(author.firstName, "David")
	}
}
