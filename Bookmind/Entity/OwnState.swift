//
//  OwnState.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/11/24.
//

/// Enumerates the possible ownership relationships to an edition.
enum OwnState: String, Codable, CaseIterable {
	case none
	case want
	case own

	var description: String {
		return switch self {
		case .none:
			"Don't want"
		case .want:
			"Want"
		case .own:
			"Own"
		}
	}
}

extension OwnState: Identifiable {
	var id: String { "OwnState." + self.rawValue }
}
