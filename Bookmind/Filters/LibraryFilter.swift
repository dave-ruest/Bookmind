//
//  LibraryFilter.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-07-06.
//

/// LibraryFilter wraps and filters an author array. The default
/// init is a passthrough which shows all stored authors. We can
/// filter to show only authors with works in a specific read state,
/// or authors with editions in a specific own state.
struct LibraryFilter {
	let title: String
	let id: String
	private let filter: (([Author]) -> [FilteredAuthor])
	
	init() {
		self.title = "Authors"
		self.id = self.title
		self.filter = { authors in
			authors.map { FilteredAuthor($0) }
		}
	}
	
	init(readState: ReadState) {
		self.title = readState.description
		self.id = readState.id
		self.filter = { authors in
			authors.filter {
				$0.books.contains { work in
					work.readState == readState
				}
			}
			.map { FilteredAuthor($0, readState: readState) }
		}
	}
	
	init(ownState: OwnState) {
		self.title = ownState.description
		self.id = ownState.id
		self.filter = { authors in
			authors.filter {
				$0.books.contains { work in
					work.editions.contains { edition in
						edition.ownState == ownState
					}
				}
			}
			.map { FilteredAuthor($0, ownState: ownState) }
		}
	}
	
	func callAsFunction(_ authors: [Author]) -> [FilteredAuthor] {
		self.filter(authors)
	}
	
	struct Preview {
		static let authors = LibraryFilter()
		static let own = LibraryFilter(ownState: .own)
		static let want = LibraryFilter(ownState: .want)
		static let wantToRead = LibraryFilter(readState: .want)
		static let read = LibraryFilter(readState: .read)
		static let wontRead = LibraryFilter(readState: .none)
	}
}

extension LibraryFilter: Codable {
	init(from decoder: any Decoder) throws {
		self.init()
	}
	
	func encode(to encoder: any Encoder) throws {
		try self.id.encode(to: encoder)
	}
}

extension LibraryFilter: Identifiable, Hashable {
	static func == (lhs: LibraryFilter, rhs: LibraryFilter) -> Bool {
		lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
		self.id.hash(into: &hasher)
	}
}
