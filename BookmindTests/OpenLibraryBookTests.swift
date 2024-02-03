//
//  OpenLibraryBookTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 1/16/24.
//

import XCTest
@testable import Bookmind

final class OpenLibraryBookTests: XCTestCase {
	private let decoder = JSONDecoder()
	
	// https://openlibrary.org/isbn/9780307352156.json
	func testQuiet() throws {
		let data = """
			{"publishers": ["Broadway Books"], "number_of_pages": 352, "subtitle": "The Power of Introverts in a World That Can't Stop Talking", "covers": [7407084], "physical_format": "Paperback", "lc_classifications": ["BF698.35.I59 C35 2013", "BF698.35.I59 C35 2012"], "key": "/books/OL25613310M", "publish_places": ["United States of America"], "isbn_13": ["9780307352156"], "classifications": {}, "title": "Quiet", "lccn": ["2012464906", "2010053204"], "identifiers": {}, "languages": [{"key": "/languages/eng"}], "local_id": ["urn:evs:39663100293299", "urn:bwbsku:W7-BUP-460"], "publish_date": "2013", "works": [{"key": "/works/OL16484595W"}], "type": {"key": "/type/edition"}, "ocaid": "quietpowerofintr0000cain_y1p5", "oclc_numbers": ["695683619"], "latest_revision": 9, "revision": 9, "created": {"type": "/type/datetime", "value": "2014-08-16T09:21:01.099860"}, "last_modified": {"type": "/type/datetime", "value": "2022-12-22T16:07:02.537404"}}
			"""
			.data(using: .utf8)!
		let book = try self.decoder.decode(OpenLibraryBook.self, from: data)
		XCTAssertEqual(book.key, "/books/OL25613310M")
		XCTAssertEqual(book.title, "Quiet")
		XCTAssertNil(book.authors)
		XCTAssertEqual(book.works, [["key":"/works/OL16484595W"]])
	}
	
	// https://openlibrary.org/isbn/9780525509288.json
	// https://openlibrary.org/works/OL20086330W.json
	func testAntiRacist() throws {
		let data = """
			{"publishers": ["One World"], "number_of_pages": 320, "classifications": {}, "title": "How to Be an Antiracist", "physical_format": "Hardcover", "identifiers": {}, "covers": [12355529, 12293422], "publish_date": "2019", "key": "/books/OL27266357M", "works": [{"key": "/works/OL20086330W"}], "type": {"key": "/type/edition"}, "isbn_13": ["9780525509288"], "ocaid": "howtobeantiracis0000kend", "languages": [{"key": "/languages/eng"}], "lc_classifications": ["E184.A1 K344 2019eb", "E184.A1 K344 2019"], "oclc_numbers": ["1112221532", "1035797624"], "lccn": ["2018058619"], "latest_revision": 13, "revision": 13, "created": {"type": "/type/datetime", "value": "2019-08-14T12:52:00.044780"}, "last_modified": {"type": "/type/datetime", "value": "2023-03-08T04:02:51.534273"}}
			"""
			.data(using: .utf8)!
		let book = try self.decoder.decode(OpenLibraryBook.self, from: data)
		XCTAssertEqual(book.key, "/books/OL27266357M")
		XCTAssertEqual(book.title, "How to Be an Antiracist")
		XCTAssertNil(book.authors)
		XCTAssertEqual(book.works, [["key": "/works/OL20086330W"]])
	}
	
	// https://openlibrary.org/isbn/0879973420.json
	func testDorsai() throws {
		let data = """
			{"publishers": ["DAW"], "ia_box_id": ["IA127711"], "covers": [6638671], "physical_format": "Paperback", "key": "/books/OL8131917M", "authors": [{"key": "/authors/OL25176A"}], "ocaid": "dorsaidi00dick", "subjects": ["Fiction / General"], "first_sentence": {"type": "/type/text", "value": "The boy was odd."}, "classifications": {}, "title": "Dorsai!", "identifiers": {"librarything": ["18637"], "goodreads": ["6051541"]}, "isbn_13": ["9780879973421"], "isbn_10": ["0879973420"], "publish_date": "November 15, 1977", "oclc_numbers": ["2027189"], "works": [{"key": "/works/OL155455W"}], "type": {"key": "/type/edition"}, "latest_revision": 14, "revision": 14, "created": {"type": "/type/datetime", "value": "2008-04-29T15:03:11.581851"}, "last_modified": {"type": "/type/datetime", "value": "2023-01-14T18:55:38.280587"}}
			"""
			.data(using: .utf8)!
		let book = try self.decoder.decode(OpenLibraryBook.self, from: data)
		XCTAssertEqual(book.title, "Dorsai!")
		XCTAssertEqual(book.key, "/books/OL8131917M")
		XCTAssertEqual(book.covers, [6638671])
		XCTAssertEqual(book.authors, [["key": "/authors/OL25176A"]])
		XCTAssertEqual(book.works, [["key": "/works/OL155455W"]])
	}
	
	// https://openlibrary.org/isbn/0441787541.json
	func testStormbringer() throws {
		let data = """
			{"publishers": ["Ace Books"], "number_of_pages": 220, "title": "Stormbringer", "identifiers": {"goodreads": ["60141"], "librarything": ["108540"]}, "covers": [284623], "languages": [{"key": "/languages/eng"}], "publish_date": "December 1992", "key": "/books/OL7526806M", "authors": [{"key": "/authors/OL394285A"}], "works": [{"key": "/works/OL2697512W"}], "type": {"key": "/type/edition"}, "classifications": {}, "subtitle": "Book Six of the Elric Saga", "isbn_10": ["0441787541"], "isbn_13": ["9780441787548"], "source_records": ["bwb:9780441787548"], "latest_revision": 10, "revision": 10, "created": {"type": "/type/datetime", "value": "2008-04-29T13:35:46.876380"}, "last_modified": {"type": "/type/datetime", "value": "2022-12-17T12:26:32.632904"}}
			"""
			.data(using: .utf8)!
		let book = try self.decoder.decode(OpenLibraryBook.self, from: data)
		XCTAssertEqual(book.title, "Stormbringer")
		XCTAssertEqual(book.authors, [["key": "/authors/OL394285A"]])
		XCTAssertEqual(book.works, [["key": "/works/OL2697512W"]])
	}
	
	// https://openlibrary.org/isbn/9781841498584.json
	func testLegend() throws {
		let data = """
			{"publishers": ["Little, Brown Book Group Limited"], "last_modified": {"type": "/type/datetime", "value": "2020-08-20T10:00:26.851463"}, "source_records": ["bwb:9781841498584"], "title": "Legend", "number_of_pages": 352, "isbn_13": ["9781841498584"], "created": {"type": "/type/datetime", "value": "2020-08-20T10:00:26.851463"}, "languages": [{"key": "/languages/eng"}], "full_title": "Legend", "lc_classifications": ["PR6057.E454"], "publish_date": "2009", "key": "/books/OL28996092M", "authors": [{"key": "/authors/OL7444080A"}], "latest_revision": 1, "works": [{"key": "/works/OL21417594W"}], "type": {"key": "/type/edition"}, "subjects": ["Fiction, fantasy, general"], "revision": 1}
			"""
			.data(using: .utf8)!
		let book = try self.decoder.decode(OpenLibraryBook.self, from: data)
		XCTAssertEqual(book.title, "Legend")
		XCTAssertNil(book.covers)
		XCTAssertEqual(book.authors, [["key": "/authors/OL7444080A"]])
		XCTAssertEqual(book.works, [["key": "/works/OL21417594W"]])
	}
	
	// https://openlibrary.org/isbn/9781787470361.json
	func testChalkPit() throws {
		let data = """
			{"title": "Quercus The Chalk Pit", "type": {"key": "/type/edition"}, "isbn_10": ["1787470369"], "isbn_13": ["9781787470361"], "local_id": ["urn:bwbsku:T2-DDQ-528"], "source_records": ["promise:bwb_daily_pallets_2022-05-16:T2-DDQ-528"], "key": "/books/OL42973867M", "works": [{"key": "/works/OL31324143W"}], "latest_revision": 4, "revision": 4, "created": {"type": "/type/datetime", "value": "2022-12-05T09:17:29.450666"}, "last_modified": {"type": "/type/datetime", "value": "2023-10-09T23:35:01.410679"}}
			"""
			.data(using: .utf8)!
		let book = try self.decoder.decode(OpenLibraryBook.self, from: data)
		XCTAssertEqual(book.title, "Quercus The Chalk Pit")
		XCTAssertNil(book.covers)
		XCTAssertNil(book.authors)
		XCTAssertEqual(book.works, [["key": "/works/OL31324143W"]])
	}
}
