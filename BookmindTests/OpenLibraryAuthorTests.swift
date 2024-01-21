//
//  OpenLibraryAuthorTests.swift
//  BookmindTests
//
//  Created by Dave Ruest on 1/20/24.
//

import XCTest
@testable import Bookmind

final class OpenLibraryAuthorTests: XCTestCase {
	private let decoder = JSONDecoder()
	
	// https://openlibrary.org/authors/OL25176A.json
	func testDorsai() throws {
		let data = """
			{"photos": [11413394], "key": "/authors/OL25176A", "source_records": ["amazon:0202865126", "amazon:1531801404", "amazon:0202871053", "amazon:1522664394", "amazon:2277236209", "amazon:0671559397"], "death_date": "31 January 2001", "name": "Gordon R. Dickson", "birth_date": "1 November 1923", "alternate_names": ["Gordon Rupert Dickson", "Gordon Dickson", "Dickson, Gordon R. And Harrison, Harry"], "remote_ids": {"wikidata": "Q446941", "viaf": "24613052", "isni": "0000000081028742"}, "type": {"key": "/type/author"}, "personal_name": "Gordon R. Dickson", "latest_revision": 16, "revision": 16, "created": {"type": "/type/datetime", "value": "2008-04-01T03:28:50.625462"}, "last_modified": {"type": "/type/datetime", "value": "2022-07-16T14:05:07.898218"}}
			"""
			.data(using: .utf8)!
		let author = try self.decoder.decode(OpenLibraryAuthor.self, from: data)
		XCTAssertEqual(author.name, "Gordon R. Dickson")
	}
	
	// https://openlibrary.org/authors/OL394285A.json
	func testStormbringer() throws {
		let data = """
			{"photos": [6882576, 7236384, -1], "birth_date": "18 December 1939", "name": "Michael Moorcock", "type": {"key": "/type/author"}, "links": [{"url": "http://www.fantasticfiction.co.uk/m/michael-moorcock/", "title": "Fantastic Fiction", "type": {"key": "/type/link"}}, {"title": "Wikipedia", "url": "http://en.wikipedia.org/wiki/Michael_Moorcock", "type": {"key": "/type/link"}}, {"url": "https://bookbrainz.org/author/bd422ef2-3802-4646-bb52-dbcaa9f52db5", "title": "BookBrainz", "type": {"key": "/type/link"}}, {"title": "inventaire.io", "url": "https://inventaire.io/entity/wd:Q316138", "type": {"key": "/type/link"}}], "key": "/authors/OL394285A", "remote_ids": {"wikidata": "Q316138", "isni": "0000000081753119", "viaf": "109785773"}, "personal_name": "Michael Moorcock", "alternate_names": ["Bill Barclay", "William Ewert Barclay", "Michael Barrington (joint work with Barrington J. Bayley)", "Edward P. Bradbury", "James Colvin", "Warwick Colvin, Jr.", "Roger Harris", "Desmond Reid (shared)", "Renegade", "Hank Janson"], "source_records": ["amazon:0856174564", "bwb:9780722162156", "amazon:0704310856"], "latest_revision": 18, "revision": 18, "created": {"type": "/type/datetime", "value": "2008-04-01T03:28:50.625462"}, "last_modified": {"type": "/type/datetime", "value": "2022-10-11T11:44:39.796442"}}
			"""
			.data(using: .utf8)!
		let author = try self.decoder.decode(OpenLibraryAuthor.self, from: data)
		XCTAssertEqual(author.name, "Michael Moorcock")
	}
	
	// https://openlibrary.org/authors/OL7444080A.json
	func testLegend() throws {
		let data = """
			{"name": "Gemmell, David", "created": {"type": "/type/datetime", "value": "2019-01-08T20:30:57.166799"}, "last_modified": {"type": "/type/datetime", "value": "2019-01-08T20:30:57.166799"}, "latest_revision": 1, "key": "/authors/OL7444080A", "type": {"key": "/type/author"}, "revision": 1}
			"""
			.data(using: .utf8)!
		let author = try self.decoder.decode(OpenLibraryAuthor.self, from: data)
		XCTAssertEqual(author.name, "Gemmell, David")
	}
}
