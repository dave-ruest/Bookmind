//
//  ReadState.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/11/24.
//

/// Enumerates the possible read states of a book/work. 
enum ReadState: Int, Codable, CaseIterable {
	case read
	case want
	case reading
	case maybe
	case none

	var description: String {
		return switch self {
			case .maybe:
				"Might read"
			case .want:
				"Want to read"
			case .reading:
				"Reading"
			case .read:
				"Have read"
			case .none:
				"Won't read"
		}
	}
}

extension ReadState: Identifiable {
	var id: Self { self }
}
