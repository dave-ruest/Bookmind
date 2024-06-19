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
	
	func makeCoordinator() -> ScanViewCoordinator {
		ScanViewCoordinator(model: scanModel)
	}
	
	func makeUIViewController(context: Context) -> DataScannerViewController {
		let controller = DataScannerViewController(recognizedDataTypes: [.text()],
			qualityLevel: .fast, recognizesMultipleItems: true, isHighlightingEnabled: true)
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
