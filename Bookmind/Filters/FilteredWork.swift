//
//  FilteredWork.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-10.
//

/// FilteredWork wraps a work entity to filter its editions.
/// In practice we have a passthrough filter, and filters
/// related to own state of the editions. 
struct FilteredWork {
	let work: Work
	var books: [Book] {
		self.filter(self.work.editions)
	}
	private var filter: (([Edition]) -> [Book])
	
	init(work: Work) {
		self.work = work
		self.filter = { editions in
			editions.map {
				Book(edition: $0, work: work, authors: work.authors)
			}
		}
	}
	
	init(work: Work, ownState: OwnState) {
		self.work = work
		self.filter = { editions in
			editions.filter {
				$0.ownState == ownState
			}
			.map {
				Book(edition: $0, work: work, authors: work.authors)
			}
		}
	}
}

extension FilteredWork: Comparable {
	static func < (lhs: FilteredWork, rhs: FilteredWork) -> Bool {
		lhs.id < rhs.id
	}
	
	static func == (lhs: FilteredWork, rhs: FilteredWork) -> Bool {
		lhs.id == rhs.id
	}
	
	
}

extension FilteredWork: Identifiable {
	var id: String {
		self.work.id
	}
}
