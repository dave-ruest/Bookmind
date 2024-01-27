//
//  ScanModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/2/24.
//

import os
import VisionKit

/// The current state of the scanner.
enum ScanState: Equatable {
	/// A message helping the user understand why the scanner isn't working.
	case failed(String)
	case found(ISBN)
	case searching
}

/// ScanModel represents the state of the "scan ISBN" flow. That state is
/// summarized in two properties: isbn and error. The isbn property contains
/// the last ibsn number found by the scanner. The error property contains
/// a message for the user if there was an error starting the scanner.
///
/// For stage one (prove we can scan the ibsn) we start with just model-view
/// participants. For stage two (fetch book details) we kept plain old
/// model-view, we just added the search in another model (SearchModel).
final class ScanModel: ObservableObject {
	/// The state of the scanner.
	@Published var state: ScanState

	init(state: ScanState = .searching) {
		self.state = state
	}
	
	/// Start the scanner. If there is an error starting the scan, set the model
	/// error property to an appropriate error message. If scan start is successful,
	/// the model will receive updates in its delegate implementation.
	@MainActor func start(_ scanner: DataScannerViewController) {
		scanner.delegate = self
		do {
			try scanner.startScanning()
		} catch DataScannerViewController.ScanningUnavailable.unsupported {
			self.scanFailed("Scanning not available on this device")
		} catch DataScannerViewController.ScanningUnavailable.cameraRestricted {
			self.scanFailed("Camera not available")
		} catch {
			self.scanFailed("Could not open scanner")
		}
	}
	
	private func scanFailed(_ message: String) {
		DispatchQueue.main.async {
			self.state = .failed(message)
		}
	}
	
	struct Preview {
		static let searching = ScanModel()
		static var failed = ScanModel(state: .failed("Could not open scanner"))
		static var found = ScanModel(state: .found(ISBN("9781841498584")!))
	}
}

extension ScanModel: CustomStringConvertible {
	var description: String {
		switch self.state {
			case .searching:
				return "Center the camera on an ISBN number or bar code"
			case .failed(let error):
				return error
			case .found(let isbn):
				return "Searching for ISBN \(isbn.displayString)"
		}
	}
}

extension ScanModel: DataScannerViewControllerDelegate {
	func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
		guard let item = addedItems.first else { return }
		switch item {
			case .barcode(let barcode): self.didAdd(barcode)
			case .text(let text): self.didAdd(text)
			default: return
		}
	}
	
	private func didAdd(_ barcode: RecognizedItem.Barcode) {
		guard let string = barcode.payloadStringValue else { return }
		self.didAdd(string)
	}
	
	private func didAdd(_ text: RecognizedItem.Text) {
		self.didAdd(text.transcript)
	}
	
	// public for testing purposes only
	func didAdd(_ string: String) {
		guard let isbn = ISBN(string) else { return }
		DispatchQueue.main.async {
			self.state = .found(isbn)
		}
	}
}
