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
	var editions: [Edition] {
		self.filter(self.work.editions)
	}
	private var filter: (([Edition]) -> [Edition])
	
	init(work: Work) {
		self.work = work
		self.filter = { editions in
			return editions
		}
	}
	
	init(work: Work, ownState: OwnState) {
		self.work = work
		self.filter = { editions in
			editions.filter {
				$0.ownState == ownState
			}
		}
	}
}
