//
//  OwnState.swift
//  Bookmind
//
//  Created by Dave Ruest on 2/11/24.
//

enum OwnState: String, Codable, CaseIterable {
	case own
	case want
	case none

	var description: String {
		return switch self {
			case .none:
				"Don't want"
			case .own:
				"Own"
			case .want:
				"Want"
		}
	}
}

extension OwnState: Identifiable {
	var id: Self { self }
}
