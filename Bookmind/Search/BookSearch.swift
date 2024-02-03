//
//  BookSearch.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/17/24.
//

import Combine

/// BookSearch is the base class for ISBN book searches. This hides
/// the details of the search site, simplifying those details for the
/// search model, but also allowing easier replacement with other sites,
/// or allowing searches on multiple sites.
class BookSearch {
	let isbn: String
	@Published var result: BookSearch.Result
	
	init(isbn: String) {
		self.isbn = isbn
		self.result = .searching(isbn)
	}
	
	// Never really got the hang of these associated type enums til now.
	// The lack of context when setting the value feels less readable. But as
	// a published state property it is fantastic to be able to convey
	// as many states as necessary, including .none for a nil value.
	enum Result {
		/// Waiting on the response for a book detail request for a scanned ISBN.
		case searching(String)
		/// Found details for a book matching the scanned ISBN.
		case found(Book, [Author])
		/// No book was found matching the scanned ISBN.
		/// Should distinguish general network errors here...
		case failed(String)		
	}
}
