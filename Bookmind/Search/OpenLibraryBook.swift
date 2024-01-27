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
///
/// In stage two (get book details) we just handled the title.
/// In with stage 2b we fetched authors. Much trickier.
/// Editions *sometimes* have an authors entry, sometimes only the
/// work has authors. So we may need to fetch the work, and will
/// always need to fetch the authors - one request each -  just
/// to get names.
///
/// In stage 2c we fetch covers. Simpler in itself, but then
/// required rather a lot of ui design to show the image nicely.
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
