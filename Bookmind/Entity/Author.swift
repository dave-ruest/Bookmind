//
//  Author.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/29/24.
//

import SwiftData

/// Author is an "entity", an object encapsulating persisted data.
/// We use swift data to store authors to memory only for previews,
/// and also to store authors to phone storage so they persist across
/// restarts. The next big step for author will be cloud storage where
/// the author will persist across devices.
@Model final class Author {
	/// The unique identifier for the author.
	/// As this is an openlibrary author id, this ties our data rather
	/// closely to openlibrary, but we may align the whole app that way.
	let olid: String
	let name: String
	let firstName: String
	let lastName: String
	/// A many to many relationship with book entities.
	/// We'll need to add a delete rule when the ui supports delete.
	@Relationship(inverse: \Book.authors) var books: [Book]
	
	init(olid: String, name: String, books: [Book] = []) {
		self.olid = olid
		self.name = name
		self.books = books
		
		var splits = name.split(separator: " ")
		self.lastName = String(splits.removeLast())
		self.firstName = splits.joined(separator: " ")
	}
	
	struct Preview {
		static var allAuthors = [Self.cain, Self.gemmell, Self.dickson]
		static var cain: Author {
			Author(olid: "/authors/OL7071534A", name: "Susan Cain")
		}
		static var gemmell: Author {
			Author(olid: "/authors/OL7444080A", name: "David Gemmell")
		}
		static var dickson: Author {
			Author(olid: "/authors/OL25176A", name: "Gordon Dickson")
		}
	}
}

extension Author: Identifiable {
	var id: String {
		self.olid
	}
}

extension Author: CustomStringConvertible {
	var description: String {
		self.name
	}
}
