//
//  FilteredAuthor.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-10.
//

/// FilteredAuthor wraps an author entity to filter its works.
/// This wrapper allows the same view to show all authors, or
/// only authors with books in various own or read states.
struct FilteredAuthor {
	let author: Author
	var works: [FilteredWork] {
		self.filter(self.author.books)
	}
	private var filter: (([Work]) -> [FilteredWork])
	
	init(author: Author) {
		self.author = author
		self.filter = { works in
			works.map { FilteredWork(work: $0) }
		}
	}
	
	init(author: Author, readState: ReadState) {
		self.author = author
		self.filter = { works in
			works.filter { $0.readState == readState }
				.map { FilteredWork(work: $0) }
		}
	}
	
	init(author: Author, ownState: OwnState) {
		self.author = author
		self.filter = { works in
			works.filter {
				$0.editions.contains { edition in
					edition.ownState == ownState
				}
			}.map { FilteredWork(work: $0, ownState: ownState)}
		}
	}
}

extension FilteredAuthor: Identifiable {
	var id: String {
		self.author.id
	}
}
