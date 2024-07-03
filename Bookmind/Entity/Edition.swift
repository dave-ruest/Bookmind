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
	/// A many to one relationship with the book or "work".
	var work: Work?
	/// The unique identifier for this edition of the work.
	let isbn: String
	/// Ownership of the edition: does the user have a physical
	/// copy of this edition? Required for the "should I buy this
	/// book" use case.
	var ownState: OwnState
	/// Open library cover ids used to fetch cover images.
	var coverIds: [Int]
	
	/// If there is an edition with the specified isbn stored in swift data,
	/// return that edition, otherwise return nil. 
	@MainActor static func fetch(isbn: String, storage: StorageModel) -> Edition? {
		let descriptor = FetchDescriptor<Edition> (
			predicate: #Predicate { $0.isbn == isbn }
		)
		return storage.fetch(descriptor).first
	}

	init(isbn: String, book: Work? = nil, coverIds: [Int] = [], ownState: OwnState = .none) {
		self.isbn = isbn
		self.work = book
		self.coverIds = coverIds
		self.ownState = ownState
	}
	
	struct Preview {
		static var allEditions = [Self.quiet, Self.legend, Self.dorsai]
		static var quiet: Edition {
			Edition(isbn: "9780307352156", coverIds: [7407084], ownState: .own)
		}
		static var legend: Edition {
			Edition(isbn: "9781841498584", ownState: .maybe)
		}
		static var dorsai: Edition {
			Edition(isbn: "0879973420", coverIds: [6638671], ownState: .maybe)
		}
		static var dune1986: Edition {
			Edition(isbn: "9780450058868", coverIds: [9256178, 291373], ownState: .none)
		}
		static var dune1987: Edition {
			Edition(isbn: "9780441102679", coverIds: [6451285, 284478], ownState: .want)
		}
	}
}

extension Edition: Equatable {
	static func == (lhs: Edition, rhs: Edition) -> Bool {
		return lhs.isbn == rhs.isbn
	}
}

extension Edition: Fetchable {
	func identityQuery() -> FetchDescriptor<Edition> {
		let identifier = self.isbn
		return FetchDescriptor<Edition>(predicate: #Predicate { $0.isbn == identifier })
	}
}

extension Edition: Identifiable {
	var id: String {
		self.isbn
	}
}

extension Edition: CustomStringConvertible {
	var description: String {
		if let title = self.work?.title {
			return title + "\n" + self.isbn
		}
		return self.isbn
	}
}
