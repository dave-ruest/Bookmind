//
//  BookTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 2024-06-04.
//

import XCTest
import SwiftData
@testable import Bookmind

final class BookTests: XCTestCase {
	func testSubtitle() {
		XCTAssertNil(Book.Preview.dorsai.subtitle)
		XCTAssertNil(Book.Preview.legend.subtitle)
		XCTAssertNotNil(Book.Preview.quiet.subtitle)
	}
	
	@MainActor func testAuthorNames() {
		XCTAssertEqual(Book.Preview.legend.authorNames, "")
		
		let storage = StorageModel(preview: true)
		var book = Book.Preview.legend
		_ = storage.insert(edition: Edition.Preview.legend, book: book,
						   authors: [Author.Preview.gemmell])
		XCTAssertEqual(book.authorNames, "David Gemmell")
		
		book = Book.Preview.quiet
		let authors = [Author.Preview.cain, Author.Preview.gemmell]
		_ = storage.insert(edition: Edition.Preview.quiet, book: book,
						   authors: authors)
		XCTAssertEqual(book.authorNames, "Susan Cain, David Gemmell")
	}
	
	@MainActor func testIsStored() {
		let storage = StorageModel(preview: true)
		var book = Book.Preview.dorsai
		XCTAssertFalse(storage.isStored(entity: book))

		book = storage.insert(entity: book)
		XCTAssert(storage.isStored(entity: book))
	}
	
	@MainActor func testInsertPreservesOriginal() {
		let storage = StorageModel(preview: true)
		var book = storage.insert(entity: Book.Preview.dorsai)
		XCTAssertEqual(book.title, "Dorsai!")
		XCTAssertEqual(book.readState, ReadState.none)
		XCTAssertEqual(book.rating, 0)
		
		book = Book(olid: book.id, title: "test", readState: .read, rating: 5)
		XCTAssertEqual(book.title, "test")
		XCTAssertEqual(book.readState, ReadState.read)
		XCTAssertEqual(book.rating, 5)

		book = storage.insert(entity: book)
		XCTAssertEqual(book.title, "Dorsai!")
		XCTAssertEqual(book.readState, ReadState.none)
		XCTAssertEqual(book.rating, 0)
	}
}
