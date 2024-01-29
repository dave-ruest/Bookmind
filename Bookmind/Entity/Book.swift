//
//  Book.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/15/24.
//

import UIKit

/// Book will be a persistent entity participant. We'll use swift
/// data to store books to disk or iCloud. 
struct Book {
	let title: String
	var authors: String
	let isbn: String
	var cover: UIImage?
	
	struct Preview {
		static var allBooks = [Self.quiet, Self.legend, Self.dorsai]
		static var quiet: Book {
			Book(title: "Quiet", authors: "", isbn: "9780307352156")
		}
		static var legend: Book {
			Book(title: "Legend", authors: "David Gemmell", isbn: "9781841498584")
		}
		static var dorsai: Book {
			Book(title: "Dorsai!", authors: "Gordon R. Dickson",
				 isbn: "0879973420", cover: UIImage(resource: ._6638671_M))
		}
	}
}

extension Book: Identifiable {
	var id: String {
		self.isbn
	}
}

extension Book: CustomStringConvertible {
	var description: String {
		if authors.isEmpty {
			return self.title + "\n" + self.isbn
		}
		return self.title + "\n" + self.authors
	}
}
