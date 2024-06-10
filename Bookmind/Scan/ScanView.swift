//
//  ScanView.swift
//  Bookmind
//
//  Created by Dave Ruest on 1/2/24.
//

import SwiftUI
import VisionKit

/// ScanView adapts a DataScannerViewController, which is otherwise unavailable in SwiftUI.
struct ScanView: UIViewControllerRepresentable {
	typealias UIViewControllerType = DataScannerViewController
	
	@EnvironmentObject var scanModel: ScanModel
	
		print("ScanView.makeCoordinator")
		let coordinator = ScanViewCoordinator(model: scanModel)
		return coordinator
	}
	
	func makeUIViewController(context: Context) -> DataScannerViewController {
		print("ScanView.makeUIViewController")
		let controller = DataScannerViewController(recognizedDataTypes: [
			.barcode(symbologies: [.ean8, .ean13]),
			.text()
		], recognizesMultipleItems: true, isHighFrameRateTrackingEnabled: true, isHighlightingEnabled: true)
		controller.view.backgroundColor = .background
		controller.delegate = context.coordinator
		context.coordinator.start(scanner: controller)
		return controller
	}
	
	static func dismantleUIViewController(_ controller: DataScannerViewController, coordinator: ScanViewCoordinator) {
		controller.stopScanning()
	}
	
	func updateUIViewController(_ controller: DataScannerViewController, context: Context) {
		// called for life cycle events and layout changes
		// with zero indication of what is happening, so completely useless
	}
}
