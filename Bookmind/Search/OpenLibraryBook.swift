//
//  OpenLibraryBook.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

/// OpenLibraryBook is a struct specifically design to decode
/// openlibrary book results. As we don't necessarily want our
/// entity properties to be dictated by one search provider, we
/// map to the more generic Book type in the derived property "book".
///
/// In stage two (get book details) we're just handling the title
/// property. We'll tackle the trickier authors (an array of
/// dictionaries, take that decodable) and covers next. Both of these
/// need additional requests. 
struct OpenLibraryBook: Decodable {
	let title: String
	let subtitle: String?
//	let authors: [String]
//	let covers: [Int]
	let isbn_10: [String]?
	let isbn_13: [String]?
	
	var book: Book {
		Book(title: self.title, authors: "", isbn: self.isbn)
	}
	
	private var isbn: String {
		if let isbn_13, !isbn_13.isEmpty {
			return isbn_13[0]
		}
		if let isbn_10, !isbn_10.isEmpty {
			return isbn_10[0]
		}
		return ""
	}
}
