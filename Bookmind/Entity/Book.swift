//
//  Book.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-10.
//

/// A convenience structure with all the entities describing
/// all the details of a physical book.
struct Book {
	/// An edition describes a specific printing with its ISBN number.
	/// A user "owns" or "wants" or "does not" want an edition (own state).
	var edition: Edition
	/// A work is an abstract concept representing all editions of a book.
	/// A user "has read" or "wants to read" a work. The user rating of
	/// the book is also stored on the work, since this is unlikely to
	/// change between editions.
	var work: Work
	/// The authors of the work.
	var authors: [Author]

	struct Preview {
		static let quiet = Book(edition: Edition.Preview.quiet,
								work: Work.Preview.quiet,
								authors: [Author.Preview.cain])
		static let legend = Book(edition: Edition.Preview.legend,
								 work: Work.Preview.legend,
								 authors: [Author.Preview.gemmell])
		static let dorsai = Book(edition: Edition.Preview.dorsai,
								 work: Work.Preview.dorsai,
								 authors: [Author.Preview.dickson])
	}
}

extension Book: CustomStringConvertible {
	var description: String {
		"\(work.title) by \(authors.names)"
	}
}

extension Book: Equatable {
	static func == (lhs: Book, rhs: Book) -> Bool {
		lhs.edition == rhs.edition
		&& lhs.work == rhs.work
		&& lhs.authors == rhs.authors
	}
}

extension Book: Identifiable {
	var id: String {
		self.edition.isbn
	}
}
