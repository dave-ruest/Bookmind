//
//  Work.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/15/24.
//

import SwiftData
import UIKit

/// Work is an "entity", an object encapsulating persisted data.
/// We use swift data to store books to memory only for previews,
/// and also to store books to phone storage so they persist across
/// restarts. The next big step for book will be cloud storage where
/// the book will persist across devices.
@Model final class Work: ObservableObject {
	let title: String
	let subtitle: String?
	/// The unique identifier for the author.
	/// As this is an openlibrary author id, this ties our data rather
	/// closely to openlibrary, but we may align the whole app that way.
	let olid: String
	/// A many to many relationship with author entities.
	var authors: [Author]
	/// A one to many relationship with edition entities.
	@Relationship(deleteRule: .cascade, inverse: \Edition.work) var editions: [Edition]
	/// Read state of the book/work: has the user read this book?
	/// Required for the "have I read this book" use case.
	var readState = ReadState.none
	/// User rating of the book/work.
	var rating: Int = 0
	
	init(olid: String, title: String, subtitle: String? = nil,
		 authors: [Author] = [], editions: [Edition] = [],
		 readState: ReadState = .none, rating: Int = 0)
	{
		self.olid = olid
		self.title = title
		self.subtitle = subtitle
		self.authors = authors
		self.editions = editions
		self.readState = readState
		self.rating = rating
	}
	
	struct Preview {
		static var allBooks = [Self.quiet, Self.legend, Self.dorsai]
		static var quiet: Work {
			Work(olid: "/works/OL16484595W", title: "Quiet", 
				 subtitle: "The Power of Introverts in a World That Can't Stop Talking",
				 readState: .read, rating: 4
			)
		}
		static var legend: Work {
			Work(olid: "/works/OL21417594W", title: "Legend", readState: .read, rating: 5)
		}
		static var dorsai: Work {
			Work(olid: "/works/OL155455W", title: "Dorsai!", readState: .maybe)
		}
		static var dune: Work {
			Work(olid: "/works/OL893508W", title: "Chapterhouse Dune", readState: .none, rating: 5)
		}
	}
}

extension Work: Fetchable {
	func identityQuery() -> FetchDescriptor<Work> {
		let identifier = self.olid
		return FetchDescriptor<Work>(predicate: #Predicate { $0.olid == identifier })
	}
}

extension Work: Identifiable {
	var id: String {
		self.olid
	}
}
