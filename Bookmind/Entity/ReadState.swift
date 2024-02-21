//
//  ReadState.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/11/24.
//

enum ReadState: Int, Codable, CaseIterable {
	case read
	case want
	case none

	var description: String {
		return switch self {
			case .none:
				"Don't want to read"
			case .read:
				"Have read"
			case .want:
				"Want to read"
		}
	}
}

extension ReadState: Identifiable {
	var id: Self { self }
}
