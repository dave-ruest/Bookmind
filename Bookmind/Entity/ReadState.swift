//
//  ReadState.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/11/24.
//

/// Enumerates the possible read states of a book/work. 
enum ReadState: String, Codable, CaseIterable {
	case none
	case want
	case reading
	case read

	var description: String {
		return switch self {
		case .none:
			"Won't read"
		case .want:
			"Want to read"
		case .reading:
			"Reading"
		case .read:
			"Have read"
		}
	}
}

extension ReadState: Identifiable {
	var id: Self { self }
}
