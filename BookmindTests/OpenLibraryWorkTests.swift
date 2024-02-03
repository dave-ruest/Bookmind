//
//  OpenLibraryWorkTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 1/21/24.
//

import XCTest
@testable import Bookmind

final class OpenLibraryWorkTests: XCTestCase {
	private let decoder = JSONDecoder()
	
	// https://openlibrary.org/works/OL16484595W.json
	func testQuiet() throws {
		let data = """
			{"covers": [7079753, 7407094, 7079754, 7073009, 7407105, 8142530, 8814330], "key": "/works/OL16484595W", "authors": [{"type": {"key": "/type/author_role"}, "author": {"key": "/authors/OL7071534A"}}], "title": "Quiet", "subjects": ["Extraversion", "Introverts", "Interpersonal relations", "Introversion", "New York Times bestseller", "nyt:combined_print_nonfiction=2012-03-03", "Reading Level-Grade 11", "Reading Level-Grade 12", "Self-actualization (psychology)", "Temperament", "Popular Works", "Psychological Introversion", "Psychological Extraversion", "Interpersonal Relations", "Temperament", "Personality", "Introversion (Psychology)", "Extraversion (Psychology)", "Large print type books", "Large type books", "nyt:paperback-nonfiction=2013-02-17", "New York Times reviewed", "Nyt:paperback-nonfiction=2013-02-17", "New york times bestseller", "New york times reviewed"], "type": {"key": "/type/work"}, "links": [{"url": "https://www.nytimes.com/2012/02/12/books/review/susan-cains-quiet-argues-for-the-power-of-introverts.html", "title": "New York Times review", "type": {"key": "/type/link"}}], "latest_revision": 37, "revision": 37, "created": {"type": "/type/datetime", "value": "2012-02-01T07:54:26.425583"}, "last_modified": {"type": "/type/datetime", "value": "2024-01-01T22:52:43.047452"}}
			"""
			.data(using: .utf8)!
		let work = try self.decoder.decode(OpenLibraryWork.self, from: data)
		XCTAssertEqual(work.authors, [["type": ["key": "/type/author_role"], "author": ["key": "/authors/OL7071534A"]]])
	}
	
	// https://openlibrary.org/works/OL20086330W.json
	func testAntiRacist() throws {
		let data = """
			{"key": "/works/OL20086330W", "title": "How to Be an Antiracist", "authors": [{"author": {"key": "/authors/OL7392644A"}, "type": {"key": "/type/author_role"}}], "type": {"key": "/type/work"}, "covers": [12355529, 9159889, 12293422, 10198360], "links": [{"url": "https://www.nytimes.com/2019/08/20/books/review/how-to-be-an-antiracist-ibram-x-kendi.html", "title": "New York Times review", "type": {"key": "/type/link"}}], "subject_places": ["United States"], "subject_people": ["Ibram X. Kendi"], "latest_revision": 20, "revision": 20, "created": {"type": "/type/datetime", "value": "2019-08-14T12:52:00.044780"}, "last_modified": {"type": "/type/datetime", "value": "2023-12-19T23:00:41.994582"}}
			"""
			.data(using: .utf8)!
		let work = try self.decoder.decode(OpenLibraryWork.self, from: data)
		XCTAssertEqual(work.authors, [["author": ["key": "/authors/OL7392644A"], "type": ["key": "/type/author_role"]]])
	}
	
	// https://openlibrary.org/works/OL155455W.json
	func testDorsai() throws {
		let data = """
			{"first_publish_date": "February 1983", "title": "Dorsai!", "covers": [4629374, 603094, 8324095, 6875464], "first_sentence": {"type": "/type/text", "value": "The boy was odd."}, "key": "/works/OL155455W", "authors": [{"author": {"key": "/authors/OL25176A"}, "type": {"key": "/type/author_role"}}], "type": {"key": "/type/work"}, "subjects": ["American Science Fiction", "Science Fiction", "Dorsai (imaginary place), fiction", "Fiction, science fiction, general"], "latest_revision": 6, "revision": 6, "created": {"type": "/type/datetime", "value": "2009-12-08T02:10:39.970701"}, "last_modified": {"type": "/type/datetime", "value": "2021-09-16T03:33:45.418961"}}
			"""
			.data(using: .utf8)!
		let work = try self.decoder.decode(OpenLibraryWork.self, from: data)
		XCTAssertEqual(work.authors, [["author": ["key": "/authors/OL25176A"], "type": ["key": "/type/author_role"]]])
	}
	
	// https://openlibrary.org/works/OL2697512W.json
	func testStormbringer() throws {
		let data = """
			{"key": "/works/OL2697512W", "title": "Stormbringer", "first_publish_date": "1965", "authors": [{"author": {"key": "/authors/OL394285A"}, "type": {"key": "/type/author_role"}}], "dewey_number": ["823.91"], "type": {"key": "/type/work"}, "covers": [10237221], "subjects": ["Elric of melnibone (fictitious character), fiction", "Fiction, fantasy, epic", "Melnibone (imaginary place), fiction"], "latest_revision": 5, "revision": 5, "created": {"type": "/type/datetime", "value": "2009-12-10T00:15:07.263895"}, "last_modified": {"type": "/type/datetime", "value": "2022-12-17T11:51:08.451419"}}
			"""
			.data(using: .utf8)!
		let work = try self.decoder.decode(OpenLibraryWork.self, from: data)
		XCTAssertEqual(work.authors, [["author": ["key": "/authors/OL394285A"], "type": ["key": "/type/author_role"]]])
	}
	
	// https://openlibrary.org/works/OL21417594W.json
	func testLegend() throws {
		let data = """
			{"last_modified": {"type": "/type/datetime", "value": "2020-08-20T10:00:26.851463"}, "title": "Legend", "created": {"type": "/type/datetime", "value": "2020-08-20T10:00:26.851463"}, "subjects": ["Fiction, fantasy, general"], "latest_revision": 1, "key": "/works/OL21417594W", "authors": [{"type": {"key": "/type/author_role"}, "author": {"key": "/authors/OL7444080A"}}], "type": {"key": "/type/work"}, "revision": 1}
			"""
			.data(using: .utf8)!
		let work = try self.decoder.decode(OpenLibraryWork.self, from: data)
		XCTAssertEqual(work.authors, [["author": ["key": "/authors/OL7444080A"], "type": ["key": "/type/author_role"]]])
	}
	
	// https://openlibrary.org/works/OL31324143W.json
	func testChalkPit() throws {
		let data = """
			{"type": {"key": "/type/work"}, "title": "Quercus The Chalk Pit", "key": "/works/OL31324143W", "authors": [{"type": {"key": "/type/author_role"}, "author": {"key": "/authors/OL1239270A"}}], "latest_revision": 2, "revision": 2, "created": {"type": "/type/datetime", "value": "2022-12-05T09:17:29.450666"}, "last_modified": {"type": "/type/datetime", "value": "2022-12-05T09:17:29.759949"}}
			"""
			.data(using: .utf8)!
		let work = try self.decoder.decode(OpenLibraryWork.self, from: data)
		XCTAssertEqual(work.authors, [["type": ["key": "/type/author_role"], "author": ["key": "/authors/OL1239270A"]]])
	}
}
