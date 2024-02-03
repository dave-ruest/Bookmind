//
//  OpenLibraryBook.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

import Foundation

/// OpenLibraryBook decodes itself from an openlibrary edition
/// (a specific version of a work, each edition has an ISBN).
///
/// We don't yet want our entity properties to be dictated by one
/// search provider, so we store openlibrary results here, but
/// convert to a more generic Book to display to the user.
struct OpenLibraryBook: Decodable {
	let key: String
	let isbn_10: [String]?
	let isbn_13: [String]?
	
	let title: String
	let subtitle: String?
	let authors: [[String: String]]?
	let works: [[String: String]]?
	let covers: [Int]?
	
	static func url(isbn: String) -> URL? {
		URL(string: "https://openlibrary.org/isbn/\(isbn).json")
	}
	
	var coverURL: URL? {
		guard let covers, let cover = covers.first else {
			return nil
		}
		return URL(string: "https://covers.openlibrary.org/b/id/\(cover)-M.jpg")
	}

	/// Map this decoded open library book data to a swift data
	/// model object that may be persisted.
	var entity: Book {
		Book(isbn: self.isbn, title: self.title)
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
