//
//  ScanModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/2/24.
//

import VisionKit

/// ScanModel communicates the scanner state to the view hierarchy.
/// The scan view and its coordinator update the scan model stored in
/// the environment. The scan screen updates appropriately when the
/// scan state changes.
final class ScanModel: ObservableObject {
	/// The state of the scanner.
	@Published var state: ScanModel.State = .searching

	init(state: ScanModel.State = .searching) {
		self.state = state
	}

	/// The current state of the scanner.
	 enum State: Equatable {
		 /// A message helping the user understand why the scanner isn't working.
		 case failed(String)
		 /// The scanner found an array of possible ISBN codes.
		 case found(ISBN)
		 /// The scanner is working but has not yet found a possible ISBN.
		 case searching
	 }

	struct Preview {
		static let searching = ScanModel()
		static var failed = ScanModel(state: .failed("Could not open scanner"))
		static var found = ScanModel(state: .found(ISBN.Preview.isbn10!))
	}
}

extension ScanModel: CustomStringConvertible {
	var description: String {
		switch self.state {
			case .searching:
				return "Center the camera on an ISBN number, either on the back cover or the copyright page."
			case .failed(let error):
				return error
			case .found(let isbn):
			return "Searching for \(isbn.displayString)"
		}
	}
}
