//
//  EditionTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 2024-06-05.
//

import XCTest
import SwiftData
@testable import Bookmind

final class EditionTests: XCTestCase {
	@MainActor func testDescription() {
		XCTAssertEqual(Edition.Preview.dorsai.description, "0879973420")
		
		let storage = StorageModel(preview: true)
		let book = storage.insert(book: Book.Preview.quiet)
		XCTAssertEqual(book.edition.description, "Quiet\n9780307352156")
	}
	
	func testCoverIds() {
		XCTAssertEqual(Edition.Preview.dorsai.coverIds, [6638671])
		XCTAssertEqual(Edition.Preview.legend.coverIds, [])
		XCTAssertEqual(Edition.Preview.quiet.coverIds, [7407084])
	}
	
	@MainActor func testIsStored() {
		let storage = StorageModel(preview: true)
		var edition = Edition.Preview.dorsai
		XCTAssertFalse(storage.isStored(entity: edition))

		edition = storage.insert(entity: edition)
		XCTAssert(storage.isStored(entity: edition))
	}
	
	@MainActor func testInsertPreservesOriginal() {
		let storage = StorageModel(preview: true)
		var edition = storage.insert(entity: Edition.Preview.legend)
		XCTAssertEqual(edition.ownState, OwnState.want)
		XCTAssertEqual(edition.coverIds, [])

		edition = Edition(isbn: edition.id, coverIds: [1])
		XCTAssertEqual(edition.ownState, OwnState.none)
		XCTAssertEqual(edition.coverIds, [1])

		let original = storage.insert(entity: edition)
		XCTAssert(edition == original)
		XCTAssertEqual(original.ownState, OwnState.want)
		XCTAssertEqual(original.coverIds, [])
	}
}
