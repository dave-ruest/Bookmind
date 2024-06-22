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
		 case foundText
		 /// The scanner found an array of possible ISBN codes.
		 case found(ISBN)
		 /// The scanner is working but has not yet found a possible ISBN.
		 case searching
	 }

	struct Preview {
		static let searching = ScanModel()
		static var failed = ScanModel(state: .failed("Could not open scanner"))
		static var foundText = ScanModel(state: .foundText)
		static var found = ScanModel(state: .found(ISBN.Preview.isbn10!))
	}
}

extension ScanModel: CustomStringConvertible {
	var description: String {
		switch self.state {
		case .searching:
			return "Wait for the camera to focus on an ISBN number. Make sure \"ISBN\" and the whole number are visible."
		case .failed(let error):
			return error
		case .foundText:
			return "Trouble scanning? The copyright page may have a larger, clearer font. You can also type an ISBN in search."
		case .found(let isbn):
			return "Searching for \(isbn.displayString)"
		}
	}
}
