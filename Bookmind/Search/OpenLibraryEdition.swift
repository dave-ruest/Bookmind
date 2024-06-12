//
//  OpenLibraryEdition.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

import Foundation

/// OpenLibraryEdition decodes itself from an openlibrary edition
/// (a specific version of a work, each edition has an ISBN).
///
/// We don't yet want our entity properties to be dictated by one
/// search provider, so we store openlibrary results here, but
/// convert to a more generic Work to display to the user.
struct OpenLibraryEdition: Decodable {
	let key: String
	let isbn_10: [String]?
	let isbn_13: [String]?
	
	let title: String
	let subtitle: String?
	let authors: [[String: String]]?
	let works: [[String: String]]?
	let covers: [Int]?

	/// Map this decoded open library edition data to a swift data
	/// Edition model object that may be persisted.
	var entity: Edition {
		Edition(isbn: self.isbn, coverIds: self.covers ?? [])
	}
	
	/// Map this decoded open library edition data to a swift data
	/// Book model object that may be persisted.
	var work: Work? {
		guard let olid = self.works?.first?.first?.value else {
			// no work for the edition, treat as invalid for now
			return nil
		}
		return Work(olid: olid, title: self.title, subtitle: self.subtitle)
	}

	/// Return the open library url for edition data on the specified ISBN.
	static func url(isbn: String) -> URL? {
		// key includes "/authors/" prefix
		URL(string: "https://openlibrary.org/isbn/\(isbn).json")
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
