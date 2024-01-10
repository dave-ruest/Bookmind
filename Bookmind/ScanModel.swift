//
//  ScanModel.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/2/24.
//

import VisionKit

/// ScanModel represents the state of the "scan ISBN" flow. That state is
/// summarized in two properties: isbn and error. The isbn property contains
/// the last ibsn number found by the scanner. The error property contains
/// a message for the user if there was an error starting the scanner.
///
/// For stage one (prove we can scan the ibsn) we start with just model-view
/// participants. We still need to add lookup and persistence... we may add
/// entity and interactor participants. I double SwiftUI will require VIPER's
/// presenter or router participants.
final class ScanModel: ObservableObject {
	/// The last ISBN number found by the scanner. Nil at the start of each scan.
	@Published var isbn: String?
	/// A message helping the user understand why the scanner isn't working.
	/// Nil if the scanner is working correctly. 
	@Published var error: String?
	
	/// Create a new scan model with default values.
	init(isbn: String? = nil) {
		self.isbn = isbn
		self.error = isbn == nil ? "Scanning..." : nil
	}
	
	/// Start the scanner. If there is an error starting the scan, set the model
	/// error property to an appropriate error message. If scan start is successful,
	/// the model will receive updates in its delegate implementation.
	@MainActor func start(_ scanner: DataScannerViewController) {
		self.isbn = nil
		scanner.delegate = self
		do {
			try scanner.startScanning()
		} catch DataScannerViewController.ScanningUnavailable.unsupported {
			self.error = "Scanning not available on this device"
		} catch {
			self.error = "Could not open scanner"
		}
	}
}

extension ScanModel: DataScannerViewControllerDelegate {
	func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
		guard let item = addedItems.first else { return }
		switch item {
			case .barcode(let barcode): 
				DispatchQueue.main.async {
					self.isbn = barcode.payloadStringValue
					self.error = nil
				}
			default: return
		}
	}
}
