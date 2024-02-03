//
//  Book.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/15/24.
//

import SwiftData
import UIKit

/// Book is an "entity", an object encapsulating persisted data.
/// We use swift data to store books to memory only for previews,
/// and also to store books to phone storage so they persist across
/// restarts. The next big step for book will be cloud storage where
/// the book will persist across devices.
@Model final class Book {
	/// The unique identifier for the book.
	let isbn: String
	let title: String
	let subtitle: String
	/// A many to many relationship with author entities.
	var authors: [Author]
	/// We're currently only showing the cover during search.
	/// We definitely want to show the cover when showing the book,
	/// but we want to be careful about storage here. Blindly
	/// storing too large covers will take up space on the users
	/// phone. Not storing them at all means more data use. We
	/// probably want to support some kind of storage so the user
	/// can save their own cover image if it is missing on ol.
	@Transient var cover: UIImage?
	
	init(isbn: String, title: String, subtitle: String = "", authors: [Author] = [], cover: UIImage? = nil) {
		self.isbn = isbn
		self.title = title
		self.subtitle = subtitle
		self.authors = authors
		self.cover = cover
	}
	
	struct Preview {
		static var allBooks = [Self.quiet, Self.legend, Self.dorsai]
		static var quiet: Book {
			Book(isbn: "9780307352156", title: "Quiet")
		}
		static var legend: Book {
			let book = Book(isbn: "9781841498584", title: "Legend")
			return book
		}
		static var dorsai: Book {
			let cover = UIImage(resource: ._6638671_M)
			let book = Book(isbn: "0879973420", title: "Dorsai!", cover: cover)
			return book
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
		self.title
	}
}
