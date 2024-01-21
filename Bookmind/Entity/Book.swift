//
//  Book.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/15/24.
//

/// Book will be a persistent entity participant. We'll use swift
/// data to store books to disk or iCloud. 
struct Book {
	let title: String
	var authors: String
	let isbn: String
}

extension Book: CustomStringConvertible {
	var description: String {
		if authors.isEmpty {
			return self.title + "\n" + self.isbn
		}
		return self.title + "\n" + self.authors
	}
}
