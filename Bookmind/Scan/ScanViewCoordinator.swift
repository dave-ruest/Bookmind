//
//  ScanViewCoordinator.swift
//  Bookmind
//
//  Created by Dave Ruest on 2024-06-09.
//

import VisionKit

/// ScanViewCoordinator glues the UIKit data scanner to our SwiftUI app.
/// It encapsulates knowledge of the scanner controller, using the then
/// much simpler scan model to communicate the essentials to the rest of
/// the app. 
final class ScanViewCoordinator: NSObject {
	let model: ScanModel
	
	init(model: ScanModel) {
		self.model = model
	}
	
	/// Start the scanner. If there is an error starting the scan, set the model
	/// error property to an appropriate error message. If scan start is successful,
	/// the model will receive updates in its delegate implementation.
	@MainActor func start(scanner: DataScannerViewController) {
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
			self.model.state = .failed(message)
		}
	}
}

extension ScanViewCoordinator: DataScannerViewControllerDelegate {
	func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
		let scannedCodes: [ISBN] = addedItems.compactMap { ISBN(item: $0) }
		DispatchQueue.main.async {
			self.model.state = .found(scannedCodes)
		}
	}
}

private extension ISBN {
	init?(item: RecognizedItem) {
		switch item {
		case .barcode(let barcode): self.init(barcode: barcode)
			case .text(let text): self.init(text.transcript)
			default: return nil
		}
	}
	
	init?(barcode: RecognizedItem.Barcode) {
		guard let string = barcode.payloadStringValue else { return nil }
		self.init(string)
	}
}
