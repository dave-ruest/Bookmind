//
//  WorkTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 2024-06-04.
//

import XCTest
import SwiftData
@testable import Bookmind

final class WorkTests: XCTestCase {
	func testSubtitle() {
		XCTAssertNil(Work.Preview.dorsai.subtitle)
		XCTAssertNil(Work.Preview.legend.subtitle)
		XCTAssertNotNil(Work.Preview.quiet.subtitle)
	}
	
	@MainActor func testAuthorNames() {
		var book = Book.Preview.legend
		XCTAssertEqual(book.work.authors.names, "")
		
		let storage = StorageModel(preview: true)
		book = storage.insert(book: book)
		XCTAssertEqual(book.work.authors.names, "David Gemmell")
		
		let authors = [Author.Preview.cain, Author.Preview.gemmell]
		book = Book(edition: Edition.Preview.quiet, work: Work.Preview.quiet, authors: authors)
		book = storage.insert(book: book)
		XCTAssertEqual(book.work.authors.names, "Susan Cain, David Gemmell")
	}
	
	@MainActor func testIsStored() {
		let storage = StorageModel(preview: true)
		var book = Work.Preview.dorsai
		XCTAssertFalse(storage.isStored(entity: book))

		book = storage.insert(entity: book)
		XCTAssert(storage.isStored(entity: book))
	}
	
	@MainActor func testInsertPreservesOriginal() {
		let storage = StorageModel(preview: true)
		var book = storage.insert(entity: Work.Preview.dorsai)
		XCTAssertEqual(book.title, "Dorsai!")
		XCTAssertEqual(book.readState, ReadState.maybe)
		
		book = Work(olid: book.id, title: "test", readState: .read)
		XCTAssertEqual(book.title, "test")
		XCTAssertEqual(book.readState, ReadState.read)

		book = storage.insert(entity: book)
		XCTAssertEqual(book.title, "Dorsai!")
		XCTAssertEqual(book.readState, ReadState.maybe)
	}
}
