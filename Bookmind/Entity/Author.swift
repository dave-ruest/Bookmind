//
//  Author.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/29/24.
//

import Foundation
import SwiftData

/// Author is an "entity", an object encapsulating persisted data.
/// We use swift data to store authors to memory only for previews,
/// and also to store authors to phone storage so they persist across
/// restarts. The next big step for author will be cloud storage where
/// the author will persist across devices.
@Model final class Author {
	let name: String
	let firstName: String
	let lastName: String
	/// The unique identifier for the author.
	/// As this is an openlibrary author id, this ties our data rather
	/// closely to openlibrary, but we may align the whole app that way.
	let olid: String
	/// A many to many relationship with book entities.
	/// Use the default delete rule (.nullify).
	@Relationship(inverse: \Work.authors) var books: [Work]

	init(olid: String, name: String, books: [Work] = []) {
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
		static var herbert: Author {
			Author(olid: "/authors/OL79034A", name: "Frank Herbert")
		}
	}
}

extension Array where Element == Author {
	var names: String {
		// added sorting to make test deterministic
		// seems the storage is unordered, need to fix if we need ordered
		// i.e. to match the list of authors on the edition
		let sorted = self.sorted { $0.lastName < $1.lastName }
		return sorted.map { $0.name }.joined(separator: ", ")
	}
}

extension Author: Fetchable {
	func identityQuery() -> FetchDescriptor<Author> {
		let identifier = self.olid
		return FetchDescriptor<Author>(predicate: #Predicate { $0.olid == identifier })
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
