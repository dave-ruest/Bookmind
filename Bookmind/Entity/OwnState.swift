//
//  OwnState.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/11/24.
//

/// Enumerates the possible ownership relationships to an edition.
enum OwnState: String, Codable, CaseIterable {
	case own
	case want
	case maybe
	case none

	var description: String {
		return switch self {
			case .maybe:
				"Might want"
			case .want:
				"Want"
			case .own:
				"Own"
			case .none:
				"Don't want"
		}
	}
}

extension OwnState: Identifiable {
	var id: Self { self }
}
