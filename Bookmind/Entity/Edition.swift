//
//  Edition.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/21/24.
//

import Combine
import SwiftData
import UIKit

/// Edition is an "entity", an object encapsulating persisted data.
/// We use swift data to store editions to memory only for previews,
/// and also to store editions to phone storage so they persist across
/// restarts. The next big step for book will be cloud storage where
/// the edition will persist across devices.
@Model final class Edition: ObservableObject {
	/// A many to one relationship with the book/"work".
	@Relationship(inverse: \Book.editions) var book: Book?
	/// The unique identifier for the book edition.
	let isbn: String
	/// Ownership of the edition: does the user have a physical
	/// copy of this edition? Required for the "should I buy this
	/// book" use case.
	var ownState: OwnState
	/// Open library cover ids used to fetch cover images.
	var coverIds: [Int]

	init(isbn: String, book: Book? = nil, coverIds: [Int] = [], ownState: OwnState = .none) {
		self.isbn = isbn
		self.book = book
		self.coverIds = coverIds
		self.ownState = ownState
	}
	
	struct Preview {
		static var allEditions = [Self.quiet, Self.legend, Self.dorsai]
		static var quiet: Edition {
			Edition(isbn: "9780307352156", coverIds: [7407084], ownState: .own)
		}
		static var legend: Edition {
			Edition(isbn: "9781841498584", ownState: .want)
		}
		static var dorsai: Edition {
			Edition(isbn: "0879973420", coverIds: [6638671], ownState: .none)
		}
	}
}

extension Edition: Identifiable {
	var id: String {
		self.isbn
	}
}

extension Edition: CustomStringConvertible {
	var description: String {
		if let title = self.book?.title {
			return title + "\n" + self.isbn
		}
		return self.isbn
	}
}
